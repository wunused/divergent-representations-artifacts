# Divergent Representations: Artifacts

### Requirements:

* Git
* Docker (Artifact 1 & 3)
* VSCode (Artifact 2)
* Binary Ninja (Artifact 3)
* Python3 (Artifact 3 - Optional)

### Getting Started

Install git and clone this repository, ensuring that all submodules are
downloaded and initialized (example shown for Debian-based Linux systems):

```
$ sudo apt update && sudo apt install -y git
$ git clone --recurse-submodules git@github.com:wunused/divergent-representations-artifacts.git
```

### Artifact 1: Exploit CVE-2022-35737 using Divergent Representation

We provide a proof-of-concept exploit for SQLite CVE-2022-35737 and show that
it sets the saved return address of the vulnerable function only when the
vulnerable program contains a divergent representation. This supports our claim
that SQLite CVE-2022-35737 is enabled by a compiler-inserted divergent
representation.

#### Setup

Install Docker (example shown for Debian-based Linux systems):

```
$ sudo apt update && sudo apt install -y docker.io
```

Build Docker image and run the container shown in the snippet below
(approximately 5 minutes to build). The container contains exploit
proof-of-concept (`/poc/snprintf-control-pc`) and two builds of the vulnerable
SQLite library (`/sqlite3/build-optimized/.libs/libsqlite3.so` and
`/sqlite3/build-unoptimized/.libs/libsqlite3.so`).

The optimized build of `libsqlite3.so` contains a divergent representation that
the proof-of-concept exploit uses to overwrite the saved return address of the
vulnerable function (`sqlite3_str_vappendf`). The unoptimized build of
`libsqlite3.so` does not contain the divergent representation, so the
proof-of-concept exploit crashes as soon as the overwrite occurs.

```
$ docker build -t cve-2022-35737 publications/disclosures/cve-2022-35737/
$ docker run --rm -it cve-2022-35737 /bin/bash
```

#### Evaluation

Execute the exploit program by pre-loading the vulnerable library built WITHOUT
optimizations. The program will crash with a memory segmentation fault because
the stack buffer overflow writes 1GB of data to the program's 8MB stack,
resulting in an immediate crash:

```
# LD_PRELOAD=/sqlite3/build-unoptimized/.libs/libsqlite3.so /poc/snprintf-control-pc
Segmentation fault (core dumped)
```

Execute the exploit program by pre-loading the vulnerable library built WITH
optimizations. The program will crash with a stack smashing warning. The
divergent representation in the optimized build allows the exploit to overwrite
the saved return address (and stack canary) with attacker controlled values,
and then to reach the function return where the stack canary is checked (rather
than immediately crashing, as when the exploit is run against the unoptimized
build):

```
# LD_PRELOAD=/sqlite3/build-optimized/.libs/libsqlite3.so /poc/snprintf-control-pc
*** stack smashing detected ***: terminated
Aborted (core dumped)
```

If desired, one can further confirm our result by using a debugger to set a
breakpoint in the vulnerable function (`sqlite3_str_vappendf`) at the function
return location (but before the stack canary is checked) and observing that,
when the breakpoint is hit in the optimized build, the saved return address has
been set to the attacker controlled value `0xdeadbeefdeadbeef`.

(Note that the breakpoint address may be different in each build of the
vulnerable library - the specific breakpoint address can be determinied by
first setting a breakpoint on the `sqlite3_str_vappendf` function and
disassembling it to determine the function return address.)

```
# gdb --args env LD_PRELOAD=/sqlite3/build-optimized/.libs/libsqlite3.so /poc/snprintf-control-pc
(gdb) break sqlite3_str_vappendf
(gdb) run
<snip>
Breakpoint 1, sqlite3_str_vappendf (pAccum=pAccum@entry=0x7fff24c495a0, fmt=0x556615f3a056 "'%!q'", ap=0x7fff24c495e0) at sqlite3.c:28173
28173	){
(gdb) disass
<snip>
   0x00007ff37b821f01 <+7265>:	mov    %ebp,%r9d
   0x00007ff37b821f04 <+7268>:	jmpq   0x7ff37b821da7 <sqlite3_str_vappendf+6919>
   0x00007ff37b821f09 <+7273>:	callq  0x7ff37b7fec80 <__stack_chk_fail@plt>
End of assembler dump.
(gdb) break *0x00007ff37b821f09
(gdb) continue
Continuing.

Breakpoint 2, 0x00007ff37b821f09 in sqlite3_str_vappendf (pAccum=0x7fff24c495a0, fmt=<optimized out>, ap=<optimized out>) at sqlite3.c:27504
27504	        return db->lookaside.szTrue;
(gdb) info frame
Stack level 0, frame at 0x7fff24c495a0:
 rip = 0x7ff37b821f09 in sqlite3_str_vappendf (sqlite3.c:27504); saved rip = 0xdeadbeefdeadbeef
 called by frame at 0x7fff24c495a8
 source language c.
 Arglist at 0x7fff24c49498, args: pAccum=0x7fff24c495a0, fmt=<optimized out>, ap=<optimized out>
 Locals at 0x7fff24c49498, Previous frame's sp is 0x7fff24c495a0
 Saved registers:
  rbx at 0x7fff24c49568, rbp at 0x7fff24c49570, r12 at 0x7fff24c49578, r13 at 0x7fff24c49580, r14 at 0x7fff24c49588, r15 at 0x7fff24c49590, rip at 0x7fff24c49598
(gdb) quit
```

Note that `saved rip = 0xdeadbeefdeadbeef`.

By contrast, in the unoptimized build, the program crashes before reaching the
equivalent breakpoint at the end of the function:

```
# gdb --args env LD_PRELOAD=/sqlite3/build-unoptimized/.libs/libsqlite3.so /poc/snprintf-control-pc
(gdb) break sqlite3_str_vappendf
(gdb) run
<snip>
Breakpoint 1, sqlite3_str_vappendf (pAccum=0x0, fmt=0x0, ap=0x0) at sqlite3.c:28173
28173	){
(gdb) disass
<snip>
   0x00007f9feb167701 <+9678>:	xor    %fs:0x28,%rax
   0x00007f9feb16770a <+9687>:	je     0x7f9feb167711 <sqlite3_str_vappendf+9694>
   0x00007f9feb16770c <+9689>:	callq  0x7f9feb15ec50 <__stack_chk_fail@plt>
   0x00007f9feb167711 <+9694>:	add    $0x1b8,%rsp
   0x00007f9feb167718 <+9701>:	pop    %rbx
   0x00007f9feb167719 <+9702>:	pop    %rbp
   0x00007f9feb16771a <+9703>:	retq
End of assembler dump.
(gdb) break *0x00007f9feb167701
(gdb) continue
Continuing.

Program received signal SIGSEGV, Segmentation fault.
0x00007f9feb16718a in sqlite3_str_vappendf (pAccum=0x7ffe9788aa80, fmt=0x556b975dc059 "q'", ap=0x7ffe9788aaf0) at sqlite3.c:28783
28783	            while( (escarg[i+1]&0xc0)==0x80 ){ i++; }
(gdb) quit
```

Source code for the exploit can be viewed in this repository at
`publications/disclosures/CVE-2022-35737/snprintf-control-pc.c` or in the
container at `/poc/snprintf-control-pc.c`.

### Artifact 2: Identify divergent representation patterns in source code

We provide CodeQL scripts to scan source code repositories for code patterns
that may result in divergent representations, when compiled. To scan many
repositories at scale, we use the newly released Multi-Repository Variant
Analysis feature provided by CodeQL and integrated into the CodeQL VSCode
plugin. We provide instructions to scan exactly the same 999 repositories that
we scanned, to validate our claim that code patterns that may result in
divergent representations are common in source code.

#### Setup

Install VSCode: https://code.visualstudio.com/docs/setup/setup-overview.

Open VSCode and install the CodeQL plugin for VSCode:
https://codeql.github.com/docs/codeql-for-visual-studio-code/setting-up-codeql-in-visual-studio-code/#starter-workspace.
Note that in the "Setting up a CodeQL Workspace" step, we recommend following
the "Using the starter workspace" option. All that this requires is creating
your own personal GitHub fork of the
https://github.com/github/vscode-codeql-starter/ repository. The CodeQL
documentation recommends cloning the starter repository locally, but we
recommend creating a GitHub fork in order to simplify later use of the
Multi-Repository Variant Analysis feature.

Create a new workspace in VSCode for this repository. To set up
Multi-Repository Variant Analysis, select the CodeQL plugin on the left pane of
VSCode. Under the "Variant Analysis Repositories" tile in the plugin view,
select "Set up controller repository" and provide the GitHub repository
identifier for your personal fork of the vscode-codeql-starter repository. This
allows the CodeQL plugin to submit GitHub actions on your behalf to run CodeQL
scans. Additional information can be found at:
https://codeql.github.com/docs/codeql-for-visual-studio-code/running-codeql-queries-at-scale-with-mrva/.

#### Evaluation

In this repository is a file named `codeql-scanlist.txt` containing the name of
all repositories that we scanned. To add them as a list for automated scanning
in CodeQL, follow the instructions to create a custom list of repositories:
https://codeql.github.com/docs/codeql-for-visual-studio-code/running-codeql-queries-at-scale-with-mrva/#creating-a-custom-list-of-repositories.
Edit the `databases.json` file by clicking on the `{}` icon (described in the
link above) and paste the contents of the `codeql-scanlist.txt` file into the
newly created list entry in the `repositories` list field. Alternatively, you
can copy the `databases.json` file provided in this repository over the local
`databases.json` file in your VSCode workspace.

To reproduce our analysis, select the custom repository list in the VSCode
CodeQL plugin. In the VSCode file browser, open the files
`divergent-representations/codeql-queries/divergentrepsfor.ql` and
`divergent-representations/codeql-queries/divergentrepswhile.ql`. In each
opened file, right click and select "CodeQL: Run Variant Analysis". This will
result in GitHub actions that execute the query code and download the results
for local analysis (approximately 15 minutes).

Our full results can be viewed at https://pastebin.com/QxCRXAp8, which are
produced by adding the results of `divergentrepsfor.ql` and
`divergentrepswhile.ql`. Note that CodeQL Multi-Repository Variant Analysis
only scans the code as it exists at the time of the query, so results may
differ slightly from ours as repositories have changed.

### Artifact 3: Identify divergent representation patterns in compiled binaries

We provide a Binary Ninja plugin that identifies compiled binary code that may
be a divergent representation, and Docker containers to reproduce our builds of
the software that we scanned. For each software project that we scanned, we
built multiple versions of the project: one for each optimization level (O0 -
O3) and each compiler used (GCC and Clang) for six total builds of each
project. We also provide pre-compiled binaries, in the event that you do not
wish to reproduce our builds from scratch.

#### Setup

Install and license Binary Ninja (note that Binary Ninja is proprietary
software): https://docs.binary.ninja/getting-started.html, https://binary.ninja/purchase/

If using a commercial Binary Ninja license: ensure that Python3 is installed on
your system. No further Binary Ninja setup required.

If using a personal Binary Ninja license: copy the contents of the
`divergent-representations/binja-scripts/` directory to the appropriate Binary
Ninja plugins location for your system. For example, if using a Linux system:

```
$ cp -r divergent-representations/binja-scripts ~/.binaryninja/plugins/divergent-reps
```

(Optional - if you want to reproduce builds of scanned software from scratch)

Build Docker image of the base build environment used by all other build
containers (approximately 1-5 minutes):

```
$ docker build -t build-environment -f builds/build-environment.dockerfile builds/
```

For each subdirectory in the `builds` directory, build the Docker image from
the associated Dockerfile (approximately 30 minutes to build, each). For
example, to build the SQLite image:

```
$ docker build -t sqlite-build -f builds/sqlite/sqlite-build.dockerfile builds/sqlite/
```

This creates a Docker image with six builds of SQLite each compiled at a
different optimization level for each compiler. All build artifacts are
located in the `/artifacts` directory of the container image.

#### Evaluation

If using commercial Binary Ninja license:

For each software artifact, execute the provided Binary Ninja script from the
command line, and pass as argument the path to the compiled binary artifact
For example, to scan the SQLite artifacts for Divergent
Representations from the command line (approximately 1 minute per project):

```
$ python3 divergent-representations/binja-scripts/fdr.py builds/sqlite/artifacts/libsqlite3.so.gcc-O3
<snip>
sqlite3Pragma@0xf1b70: rax_268#332 = ϕ(rax_268#331, rax_268#333)
sqlite3CreateIndex@0x103b08: rax_83#175 = ϕ(rax_83#174, rax_83#176)
found 51 divergent representations in builds/sqlite/artifacts/libsqlite3.so.0.8.6.gcc-O3
```

Warnings about function complexity may be ignored.

If using personal Binary Ninja license:

For each software artifact, open the compiled binary in Binary Ninja. Wait for
Binary Ninja to analyze the program. Right click in the center window and
select "Plugins -> Binja Div Reps -> Find in all functions". Plugin results
will be printed in the Log console.

Numbers of identified divergent representations should match Table 1 of
submission.
