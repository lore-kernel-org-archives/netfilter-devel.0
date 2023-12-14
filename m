Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07551116
	for <netfilter-devel@vger.kernel.org>; Thu, 14 Dec 2023 04:50:32 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1rDlAc-0000Ma-0l; Thu, 14 Dec 2023 13:50:30 +0100
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH v2 nft] initial support for the afl++ (american fuzzy lop++) fuzzer
Date: Thu, 14 Dec 2023 13:50:21 +0100
Message-ID: <20231214125025.8729-1-fw@strlen.de>
X-Mailer: git-send-email 2.41.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

afl comes with a compiler frontend that can add instrumentation suitable
for running nftables via the "afl-fuzz" fuzzer.

This change adds a "--with-fuzzer" option to configure script and enables
specific handling in nftables and libnftables to speed up the fuzzing process.
It also adds the "--fuzzer" command line option.

afl-fuzz initialisation gets delayed until after the netlink context is set up
and symbol tables such as (e.g. route marks) have been parsed.

When afl-fuzz restarts the process with a new input round, it will
resume *after* this point (see __AFL_INIT macro in main.c).

With --fuzzer <stage>, nft will perform multiple fuzzing rounds per
invocation: this increases processing rate by an order of magnitude.

Each new input passes through the following processing stages:

1: pre-validation. Checks the input buffer (the fuzzer generated
   ruleset/commands) to make sure minimal requirements are met:
   - minimum "ineresting" length
   - 0-terminated input (command, ruleset)
   - initial keywords could result in state change (ruleset load,
     deletion or addition of rules/chains/tables,..

This stage is always executed.

2: 'parser':
    Only run flex/bison parser and quit instantly if that fails,
    without evaluation of the generated AST (No need to generate
    error messages for the user).

3: 'eval': pass the input through the evaluation phase as well.
    This attempts to build a complete ruleset in memory, does
    symbol resolution, adds needed shift/masks to payload instructions
    etc.

4: 'netlink-ro' or 'netlink-write'.
    'netlink-ro' builds the netlink buffer to send to the kernel,
    without actually doing so.
    With 'write', the generated command/ruleset will be passed to the
    kernel.

The argument to '--fuzzer' specifies the last stage to run.

Use 'netlink-ro' if you want to prevent the fuzzing from ever submitting any
changes to the kernel.

You can combine '--fuzzer netlink-write' with the '--check' option to send
data to the kernel but without actually committing any changes.

This could still end up triggering a kernel crash if there are bugs in the
valiation / transaction / abort phases.

Before sending a command to the kernel, the input is stored in temporary
files (named [0-255]/[0-255] in the "tests/afl++/nft-afl-work" directory.

In case a splat is detected, the fuzzing process halts.
This will also block all further fuzzer attempts until reboot.

nft-afl-work/log logs when a "talk to kernel" phase begins or when a
kernel crash/warning splat was detected.

Check "tests/afl++/hooks" for script hooks, those allow to customize the
fuzzing process by making regular snapshots of the ruleset, deleting old
temporary files, flushing rules, checking KASAN, etc.

The default hook scripts will enable fault injection for the nft process
being fuzzed, i.e. kernel memory allocations will randonly fail.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 .gitignore                     |   6 +
 Makefile.am                    |   5 +
 configure.ac                   |  14 +
 include/afl++.h                |  49 +++
 include/nftables.h             |   3 +
 src/afl++.c                    | 729 +++++++++++++++++++++++++++++++++
 src/libnftables.c              |  23 +-
 src/main.c                     | 101 +++++
 src/mnl.c                      |   2 +-
 tests/afl++/README             | 126 ++++++
 tests/afl++/TODO               |   6 +
 tests/afl++/afl-sysctl.cfg     |   5 +
 tests/afl++/hooks/init         |  54 +++
 tests/afl++/hooks/post-commit  |   8 +
 tests/afl++/hooks/post-restart |   8 +
 tests/afl++/hooks/pre-commit   |   6 +
 tests/afl++/hooks/pre-restart  |  12 +
 tests/afl++/run-afl.sh         |  43 ++
 18 files changed, 1198 insertions(+), 2 deletions(-)
 create mode 100644 include/afl++.h
 create mode 100644 src/afl++.c
 create mode 100644 tests/afl++/README
 create mode 100644 tests/afl++/TODO
 create mode 100644 tests/afl++/afl-sysctl.cfg
 create mode 100755 tests/afl++/hooks/init
 create mode 100755 tests/afl++/hooks/post-commit
 create mode 100755 tests/afl++/hooks/post-restart
 create mode 100755 tests/afl++/hooks/pre-commit
 create mode 100755 tests/afl++/hooks/pre-restart
 create mode 100755 tests/afl++/run-afl.sh

diff --git a/.gitignore b/.gitignore
index a62e31f31c6b..1d9eb9c22a70 100644
--- a/.gitignore
+++ b/.gitignore
@@ -22,6 +22,12 @@ libtool
 *.payload.got
 tests/build/tests.log
 
+# generated by run-afl.sh
+tests/afl++/in/
+tests/afl++/nft.dict
+tests/afl++/out/
+tests/afl++/nft-afl-work/
+
 # Debian package build temporary files
 build-stamp
 
diff --git a/Makefile.am b/Makefile.am
index 0ed831a19e95..21c01e712010 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -63,6 +63,7 @@ noinst_HEADERS = \
 	include/linux/netfilter_ipv6.h \
 	include/linux/netfilter_ipv6/ip6_tables.h \
 	\
+	include/afl++.h	\
 	include/cache.h \
 	include/cli.h \
 	include/cmd.h \
@@ -284,6 +285,10 @@ sbin_PROGRAMS += src/nft
 
 src_nft_SOURCES = src/main.c
 
+if BUILD_AFL
+src_nft_SOURCES += src/afl++.c
+endif
+
 if BUILD_CLI
 src_nft_SOURCES += src/cli.c
 endif
diff --git a/configure.ac b/configure.ac
index 724a4ae726c1..c162f388ce7c 100644
--- a/configure.ac
+++ b/configure.ac
@@ -91,6 +91,15 @@ AC_MSG_ERROR([unexpected CLI value: $with_cli])
 ])
 AM_CONDITIONAL([BUILD_CLI], [test "x$with_cli" != xno])
 
+AC_ARG_ENABLE([fuzzer],
+	      AS_HELP_STRING([--enable-fuzzer], [Enable fuzzer support.  NEVER use this unless you work on nftables project]),
+	      [enable_fuzzer=yes], [enable_fuzzer=no])
+
+AM_CONDITIONAL([BUILD_AFL], [test "x$enable_fuzzer" = xyes])
+AS_IF([test "x$enable_fuzzer" != xno], [
+	AC_DEFINE([HAVE_FUZZER_BUILD], [1], [Define if you want to build with fuzzer support])
+	], [])
+
 AC_ARG_WITH([xtables], [AS_HELP_STRING([--with-xtables],
             [Use libxtables for iptables interaction])],
 	    [], [with_xtables=no])
@@ -128,3 +137,8 @@ nft configuration:
   enable man page:              ${enable_man_doc}
   libxtables support:		${with_xtables}
   json output support:          ${with_json}"
+
+# Do not print "fuzzer support:		no", this is development-only.
+AS_IF([test "x$enable_fuzzer" = xyes ], [
+	echo "  fuzzer support:		yes"
+	], [ ])
diff --git a/include/afl++.h b/include/afl++.h
new file mode 100644
index 000000000000..28244dcaaf62
--- /dev/null
+++ b/include/afl++.h
@@ -0,0 +1,49 @@
+#ifndef _NFT_AFLPLUSPLUS_H_
+#define _NFT_AFLPLUSPLUS_H_
+
+#include <nftables/libnftables.h>
+#include <config.h>
+
+/*
+ * enum nft_afl_fuzzer_stage - current fuzzer stage
+ *
+ * @NFT_AFL_FUZZER_DISABLED: running without --fuzzer
+ * @NFT_AFL_FUZZER_PARSER: only fuzz the parser, do not run eval step.
+ * @NFT_AFL_FUZZER_EVALUATION: continue to evaluation step, if possible.
+ * @NFT_AFL_FUZZER_NETLINK_RO: convert internal representation to netlink buffer but don't send any changes to the kernel.
+ * @NFT_AFL_FUZZER_NETLINK_RW: send the netlink message to kernel for processing.
+ */
+enum nft_afl_fuzzer_stage {
+	NFT_AFL_FUZZER_DISABLED,
+	NFT_AFL_FUZZER_PARSER,
+	NFT_AFL_FUZZER_EVALUATION,
+	NFT_AFL_FUZZER_NETLINK_RO,
+	NFT_AFL_FUZZER_NETLINK_RW,
+};
+
+static inline void nft_afl_print_build_info(FILE *fp)
+{
+#if defined(HAVE_FUZZER_BUILD) && defined(FUZZING_BUILD_MODE_UNSAFE_FOR_PRODUCTION)
+	fprintf(fp, "\nWARNING: BUILT WITH FUZZER SUPPORT AND AFL INSTRUMENTATION\n");
+#elif defined(FUZZING_BUILD_MODE_UNSAFE_FOR_PRODUCTION)
+	fprintf(fp, "\nWARNING: BUILT WITH AFL INSTRUMENTATION\n");
+#elif defined(HAVE_FUZZER_BUILD)
+	fprintf(fp, "\nWARNING: BUILT WITH FUZZER SUPPORT BUT NO AFL INSTRUMENTATION\n");
+#endif
+}
+
+#if defined(HAVE_FUZZER_BUILD)
+extern int nft_afl_init(enum nft_afl_fuzzer_stage s);
+extern int nft_afl_main(struct nft_ctx *nft);
+#else
+static inline int nft_afl_main(struct nft_ctx *ctx)
+{
+        return -1;
+}
+static inline int nft_afl_init(enum nft_afl_fuzzer_stage s){ return -1; }
+#endif
+
+#ifndef FUZZING_BUILD_MODE_UNSAFE_FOR_PRODUCTION
+#define __AFL_INIT() do { } while (0)
+#endif
+#endif
diff --git a/include/nftables.h b/include/nftables.h
index 4b7c335928da..02d110e609eb 100644
--- a/include/nftables.h
+++ b/include/nftables.h
@@ -144,6 +144,9 @@ struct nft_ctx {
 	void			*json_root;
 	json_t			*json_echo;
 	const char		*stdin_buf;
+#if defined(HAVE_FUZZER_BUILD)
+	int			afl_ctx_stage;
+#endif
 };
 
 enum nftables_exit_codes {
diff --git a/src/afl++.c b/src/afl++.c
new file mode 100644
index 000000000000..d3e19fdd3a43
--- /dev/null
+++ b/src/afl++.c
@@ -0,0 +1,729 @@
+/*
+ * Copyright (c) Red Hat GmbH.	Author: Florian Westphal <fw@strlen.de>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 (or any
+ * later) as published by the Free Software Foundation.
+ */
+
+#define _GNU_SOURCE
+#include <stdio.h>
+#include <stdlib.h>
+
+#include <errno.h>
+#include <ctype.h>
+#include <limits.h>
+#include <fcntl.h>
+#include <unistd.h>
+#include <string.h>
+#include <time.h>
+
+#include <sys/stat.h>
+#include <sys/wait.h>
+
+#include <afl++.h>
+#include <nftables.h>
+
+static const char nft_afl_hookdirname[] = "tests/afl++/hooks";
+static const char nft_afl_workdirname[] = "tests/afl++/nft-afl-work";
+static const char self_fault_inject_file[] = "/proc/self/make-it-fail";
+
+#ifdef __AFL_FUZZ_TESTCASE_LEN
+/* the below macro gets passed via afl-cc, declares prototypes
+ * depending on the afl-cc flavor.
+ */
+__AFL_FUZZ_INIT();
+#else
+/* this lets the source compile without afl-clang-fast/lto */
+static unsigned char fuzz_buf[4096];
+static ssize_t fuzz_len;
+
+#define __AFL_FUZZ_TESTCASE_LEN fuzz_len
+#define __AFL_FUZZ_TESTCASE_BUF fuzz_buf
+#define __AFL_FUZZ_INIT() do { } while (0)
+#define __AFL_LOOP(x) \
+   ((fuzz_len = read(0, fuzz_buf, sizeof(fuzz_buf))) > 0 ? 1 : 0)
+#endif
+
+#define NFT_AFL_GC_TIME		30
+#define NFT_AFL_FB_SIZE	1024
+#define NFT_AFL_FNAME_SIZE	(strlen(nft_afl_workdirname) + sizeof("/255/255"))
+#define NFT_AFL_HDIR_SIZE	(strlen(nft_afl_hookdirname) + sizeof("/hooks/"))
+
+struct nft_afl_input {
+	unsigned int failcount;
+	char *buffer;
+	char *fname;
+	int retval;
+	bool use_filename;
+};
+
+/* we store 256 test cases in 256 dirs */
+struct nft_afl_level {
+	struct nft_afl_input inputs[256];
+	uint8_t next;
+};
+
+enum nft_afl_state_enum {
+	NFT_AFL_STATE_NORMAL,
+	NFT_AFL_STATE_TAINTED,
+};
+
+struct nft_afl_state {
+	unsigned int candidates;
+	struct nft_afl_level level[256];
+	uint8_t levelcount;
+	enum nft_afl_fuzzer_stage stage_max;
+	enum nft_afl_state_enum state;
+	FILE *log;
+	FILE *make_it_fail_fp;
+};
+
+static struct nft_afl_state state;
+
+static char *preprocess(unsigned char *input, ssize_t len)
+{
+	/* shortest state-change command i could think of */
+	static const ssize_t minlen = (ssize_t)sizeof("add set s");
+	unsigned int i;
+	char *real_in;
+
+	if (len < minlen)
+		return NULL;
+
+	/* skip whitespace, and check minlen again.
+	 * This is to speed things up by avoiding
+	 * more costly libnftables parser for junk
+	 * inputs.
+	 */
+	real_in = (char *)input;
+	for (; len > 0; real_in++, len--) {
+		switch (*real_in) {
+		case ' ':
+		case '\t':
+		case '\n':
+			break;
+		case 0:
+			/* pure whitespace? reject. */
+			return NULL;
+		default:
+			/* non-whitespace, truncate at earliest opportunity */
+			for (i = 0; i < len; i++) {
+				/* don't bother: parser rejects it. */
+				if (!isascii(real_in[i])) {
+					len = i;
+					goto done;
+				}
+			}
+
+			/* no '\0' found in input, truncate. */
+			if (i == len) {
+				if (len)
+					real_in[--len] = 0;
+				goto done;
+			}
+		}
+	}
+done:
+	if (len < minlen)
+		return NULL;
+
+	return real_in;
+}
+
+static struct nft_afl_input *savebuf(struct nft_afl_level *level, const char *buf)
+{
+	struct nft_afl_input *input = &level->inputs[level->next];
+	char *fast_buf = input->buffer;
+	int r;
+
+	r = snprintf(fast_buf, NFT_AFL_FB_SIZE, "%s", buf);
+	if (r >= NFT_AFL_FB_SIZE) {
+		input->use_filename = true;
+		fast_buf[0] = 0;
+	} else {
+		input->use_filename = false;
+	}
+
+	return input;
+}
+
+static int opencandidate(const char *name)
+{
+	return open(name, O_WRONLY | O_CLOEXEC | O_CREAT | O_TRUNC, 0644);
+}
+
+static void mark_tainted(struct nft_afl_state *s)
+{
+	char taintname[512];
+	FILE *fp;
+
+	snprintf(taintname, sizeof(taintname), "%s/TAINT", nft_afl_workdirname);
+
+	/* mark it tainted, no more fuzzer runs until this file gets deleted. */
+	fp = fopen(taintname, "w");
+	if (fp)
+		fclose(fp);
+
+	s->state = NFT_AFL_STATE_TAINTED;
+}
+
+static void nft_afl_state_log_str(const struct nft_afl_state *s, const char *message)
+{
+	FILE *fp = fopen("/proc/uptime", "r");
+	char buf[256];
+	char *nl;
+
+	if (!fp)
+		return;
+
+	if (!fgets(buf, sizeof(buf), fp))
+		snprintf(buf, sizeof(buf), "error reading uptime: %s", strerror(errno));
+
+	fclose(fp);
+
+	nl = strchr(buf, '\n');
+	if (nl)
+		*nl = 0;
+
+	fprintf(s->log, "%s: %s\n", buf, message);
+	fflush(s->log);
+}
+
+__attribute__((format(printf, 2, 3)))
+static void nft_afl_state_logf(const struct nft_afl_state *s, const char *fmt, ... )
+{
+	char buffer[512];
+	va_list ap;
+
+	va_start(ap, fmt);
+	vsnprintf(buffer, sizeof(buffer), fmt, ap);
+	va_end(ap);
+
+	nft_afl_state_log_str(s, buffer);
+}
+
+static bool kernel_is_tainted(const struct nft_afl_state *s)
+{
+	FILE *fp = fopen("/proc/sys/kernel/tainted", "r");
+	unsigned int taint;
+	bool ret = false;
+
+	if (fp && fscanf(fp, "%u", &taint) == 1 && taint) {
+		nft_afl_state_logf(s, "Kernel is tainted: 0x%x\n", taint);
+		ret = true;
+	}
+
+	fclose(fp);
+	return ret;
+}
+
+static void fault_inject_write(FILE *fp, unsigned int v)
+{
+	rewind(fp);
+	fprintf(fp, "%u\n", v);
+	fflush(fp);
+}
+
+static void fault_inject_enable(const struct nft_afl_state *state)
+{
+	if (state->make_it_fail_fp)
+		fault_inject_write(state->make_it_fail_fp, 1);
+}
+
+static void fault_inject_disable(const struct nft_afl_state *state)
+{
+	if (state->make_it_fail_fp)
+		fault_inject_write(state->make_it_fail_fp, 0);
+}
+
+/* NB: splats can happen even after return to userspace,
+ * or even when the kernel returned an error from
+ * nft_run_cmd_from_buffer/filename.
+ *
+ * This is due to delayed destruction in kernel
+ * and cleanup/error unwind semantics.
+ */
+static void log_splat_seen(struct nft_afl_state *state, const struct nft_afl_input *r)
+{
+	nft_afl_state_logf(state, "tainted, last run: %s", r->fname);
+
+	mark_tainted(state);
+}
+
+static bool nft_afl_run_cmd(struct nft_afl_state *s, struct nft_ctx *ctx, struct nft_afl_input *run)
+{
+	if (kernel_is_tainted(s))
+		goto splat;
+
+	switch (s->stage_max) {
+	case NFT_AFL_FUZZER_DISABLED:
+		/* silences warning wrt. unhandled enum in switch */
+		BUG("Fuzzer disabled but in fuzzer loop");
+	case NFT_AFL_FUZZER_PARSER:
+	case NFT_AFL_FUZZER_EVALUATION:
+		return true;
+	case NFT_AFL_FUZZER_NETLINK_RO:
+	case NFT_AFL_FUZZER_NETLINK_RW:
+		ctx->afl_ctx_stage = s->stage_max;
+		break;
+	}
+
+	fault_inject_enable(s);
+
+	if (run->use_filename)
+		nft_run_cmd_from_filename(ctx, run->fname);
+	else
+		nft_run_cmd_from_buffer(ctx, run->buffer);
+
+	fault_inject_disable(s);
+
+	if (kernel_is_tainted(s))
+		goto splat;
+
+	return true;
+splat:
+	log_splat_seen(s, run);
+	return false;
+}
+
+static struct nft_afl_input *
+save_candidate(struct nft_afl_state *state, const char *buf)
+{
+	unsigned int next, lc = state->levelcount;
+	char levelname[512], name[NFT_AFL_FNAME_SIZE];
+	struct nft_afl_level *level;
+	struct nft_afl_input *input;
+	int len, err, fd;
+	ssize_t rv;
+
+	/* no need to save in a file, kernel won't see any data */
+	if (state->stage_max <= NFT_AFL_FUZZER_NETLINK_RO) {
+		level = &state->level[lc];
+		next = level->next;
+
+		input = savebuf(level, buf);
+
+		if (input->use_filename)
+			goto save_now;
+
+		return input;
+	}
+
+	for (; lc < array_size(state->level); lc++) {
+		level = &state->level[lc];
+
+		for (next = level->next; next < array_size(level->inputs); next++) {
+			input = &level->inputs[next];
+
+			if (!input->use_filename) {
+				level->next = next;
+				state->levelcount = lc;
+				goto save_now;
+			}
+		}
+	}
+
+save_now:
+	snprintf(levelname, sizeof(levelname), "%s/%03d", nft_afl_workdirname, lc);
+
+	err = mkdir(levelname, 0755);
+	if (err && errno != EEXIST) {
+		nft_afl_state_logf(state, "%s: mkdir failed: %s",
+				   name, strerror(errno));
+		return NULL;
+	}
+
+	snprintf(name, sizeof(name), "%s/%03d/%03d", nft_afl_workdirname, lc, next);
+	fd = opencandidate(name);
+	if (fd < 0) {
+		nft_afl_state_logf(state, "%s: create failed: %s",
+				   name, strerror(errno));
+		return NULL;
+	}
+
+	input = savebuf(level, buf);
+	snprintf(input->fname, NFT_AFL_FNAME_SIZE, "%s", name);
+	len = strlen(buf);
+
+	rv = write(fd, buf, len);
+	if (rv != len) {
+		close(fd);
+		mark_tainted(state);
+		nft_afl_state_logf(state, "%s: write %u bytes, got %ld: %s",
+				   name, len, (long)rv, strerror(errno));
+		return NULL;
+	}
+
+	++next;
+	level->next = next;
+
+	if (next == array_size(level->inputs) - 1) {
+		lc++;
+
+		if (lc < array_size(state->level))
+			state->levelcount = lc;
+
+	}
+
+	close(fd);
+
+	return input;
+}
+
+static bool nft_afl_level_init(struct nft_afl_level *level)
+{
+	struct nft_afl_input *input;
+	unsigned int i;
+
+	for (i = 0; i < array_size(level->inputs); i++) {
+		input = &level->inputs[i];
+
+		input->buffer = malloc(NFT_AFL_FB_SIZE);
+		input->fname = malloc(NFT_AFL_FNAME_SIZE);
+
+		if (!input->buffer || !input->fname)
+			return false;
+	}
+
+	return true;
+}
+
+static FILE *fault_inject_open(void)
+{
+	return fopen(self_fault_inject_file, "r+");
+}
+
+static bool nft_afl_state_init(struct nft_afl_state *state, enum nft_afl_fuzzer_stage max)
+{
+	char logname[512];
+	unsigned int i;
+	int err;
+
+	memset(state, 0, sizeof(*state));
+
+	for (i = 0; i < array_size(state->level); i++) {
+		if (!nft_afl_level_init(&state->level[i]))
+			return false;
+	}
+
+	snprintf(logname, sizeof(logname), "%s/log", nft_afl_workdirname);
+
+	err = mkdir(nft_afl_workdirname, 0755);
+	if (err && errno != EEXIST) {
+		fprintf(stderr, "create %s: %s\n", nft_afl_workdirname, strerror(errno));
+		return false;
+	}
+
+	state->log = fopen(logname, "a");
+	if (!state->log) {
+		fprintf(stderr, "open %s: %s\n", logname, strerror(errno));
+		return false;
+	}
+
+	state->stage_max = max;
+	state->make_it_fail_fp = fault_inject_open();
+	return true;
+}
+
+static bool is_tainted(void)
+{
+	char taintname[512];
+	FILE *fp;
+
+	snprintf(taintname, sizeof(taintname), "%s/TAINT", nft_afl_workdirname);
+
+	fp = fopen(taintname, "r");
+	if (fp) {
+		fclose(fp);
+		sleep(60);	/* don't burn cycles, no more fuzzing */
+		return true;
+	}
+
+	return false;
+}
+
+static void forkandexec(struct nft_afl_state *state, char *name)
+{
+	char * const argv[] = { name, NULL };
+	int ret, wstatus;
+	pid_t p = fork();
+
+	if (p < 0) {
+		nft_afl_state_logf(state, "Cannot fork %s: %s", name, strerror(errno));
+		return;
+	}
+
+	if (p == 0) {
+		execve(name, argv, environ);
+		nft_afl_state_logf(state, "Cannot execve %s: %s", name, strerror(errno));
+		exit(EXIT_FAILURE);
+	}
+
+	ret = waitpid(p, &wstatus, 0);
+	if (ret < 0) {
+		nft_afl_state_logf(state, "waitpid %ld %s: %s", (long)p, name, strerror(errno));
+		return;
+	}
+
+	if (WIFEXITED(wstatus)) {
+		if (WEXITSTATUS(wstatus) == 0)
+			return;
+
+		nft_afl_state_logf(state, "waitpid %s: exited with %d", name, WEXITSTATUS(wstatus));
+		return;
+	}
+
+	if (WIFSIGNALED(wstatus)) {
+		nft_afl_state_logf(state, "waitpid %s: exited with signal %d", name, WTERMSIG(wstatus));
+		return;
+	}
+
+	nft_afl_state_logf(state, "waitpid %s: exited with unexpected result", name);
+}
+
+static void nft_exec_hookscript(struct nft_afl_state *state, const char *sname)
+{
+	char name[NFT_AFL_HDIR_SIZE + sizeof("post-commit")]; /* largest possible script name */
+	struct stat sb;
+	int ret;
+
+	snprintf(name, sizeof(name), "%s/%s", nft_afl_hookdirname, sname);
+
+	ret = lstat(name, &sb);
+	if (ret != 0) {
+		if (errno == ENOENT)
+			return;
+
+		nft_afl_state_logf(state, "Cannot stat %s: %s", name, strerror(errno));
+		return;
+	}
+
+	if (sb.st_uid != 0 && geteuid() == 0) {
+		nft_afl_state_logf(state, "ignore %s: owner != uid 0", name);
+		return;
+	}
+
+	if (sb.st_mode & 0002) {
+		nft_afl_state_logf(state, "ignore %s: writeable by anyone", name);
+		return;
+	}
+
+	if ((sb.st_mode & 0700) == 0)
+		return;
+
+	forkandexec(state, name);
+}
+
+static bool nft_afl_read_existing_candidates(struct nft_afl_state *state,
+					     struct nft_ctx *ctx)
+{
+	char name[NFT_AFL_FNAME_SIZE];
+	time_t now = time(NULL);
+	unsigned int found = 0;
+	unsigned int gc = 0;
+	unsigned int i, j;
+
+	nft_exec_hookscript(state, "pre-restart");
+
+	for (i = 0; i < array_size(state->level); i++) {
+		struct nft_afl_level *level = &state->level[i];
+		struct stat sb;
+		int ret;
+
+		snprintf(name, sizeof(name), "%s/%03d", nft_afl_workdirname, i);
+		ret = lstat(name, &sb);
+		if (ret != 0) {
+			if (errno == ENOENT)
+				continue;
+
+			nft_afl_state_logf(state, "stat dir %s: %s", name, strerror(errno));
+			return false;
+		}
+
+		if ((sb.st_mode & S_IFMT) != S_IFDIR) {
+			nft_afl_state_logf(state, "stat dir %s: not a directory", name);
+			return false;
+		}
+
+		for (j = 0; j < array_size(level->inputs); j++) {
+			struct nft_afl_input *in = &level->inputs[i];
+
+			snprintf(name, sizeof(name), "%s/%03d/%03d", nft_afl_workdirname, i, j);
+
+			ret = lstat(name, &sb);
+			if (ret == 0) {
+				if (sb.st_mtime + NFT_AFL_GC_TIME < now) {
+					++gc;
+					continue;
+				}
+
+				if (sb.st_size > 0) {
+					state->candidates++;
+					in->use_filename = true;
+					snprintf(in->buffer, NFT_AFL_FB_SIZE, "%s", name);
+					found++;
+					continue;
+				}
+
+				continue;
+			} else {
+				if (errno == ENOENT)
+					continue;
+
+				nft_afl_state_logf(state, "stat file %s: %s", name, strerror(errno));
+				return false;
+			}
+		}
+
+		state->levelcount++;
+	}
+
+	if (gc) {
+		state->levelcount = 0;
+		state->level[0].next = 0;
+	}
+
+	nft_afl_state_logf(state, "start with %u existing test cases from %s/*/* (%u marked expired)", found, nft_afl_workdirname, gc);
+
+	nft_exec_hookscript(state, "post-restart");
+
+	return true;
+}
+
+static bool nft_afl_switch_to_next_stage(const struct nft_afl_state *state, struct nft_ctx *ctx, enum nft_afl_fuzzer_stage next_stage)
+{
+	if (next_stage <= state->stage_max) {
+		ctx->afl_ctx_stage = next_stage;
+		return true;
+	}
+
+	return false;
+}
+
+int nft_afl_init(enum nft_afl_fuzzer_stage stage)
+{
+#ifdef FUZZING_BUILD_MODE_UNSAFE_FOR_PRODUCTION
+	const char instrumented[] = "afl instrumented";
+#else
+	const char instrumented[] = "no afl instrumentation";
+#endif
+	char *workdir = NULL;
+	int ret;
+
+	nft_afl_print_build_info(stderr);
+
+	if (!nft_afl_state_init(&state, stage))
+		return -1;
+
+	ret = asprintf(&workdir, "NFT_AFL_WORKDIR=%s", nft_afl_workdirname);
+	if (ret < 0 || !workdir || putenv(workdir) != 0) {
+		nft_afl_state_logf(&state, "Out of memory");
+		return -1;
+	}
+
+	nft_exec_hookscript(&state, "init");
+
+	if (state.make_it_fail_fp) {
+		unsigned int value;
+		int ret;
+
+		rewind(state.make_it_fail_fp);
+		ret = fscanf(state.make_it_fail_fp, "%u", &value);
+		if (ret != 1 || value != 1) {
+			fclose(state.make_it_fail_fp);
+			state.make_it_fail_fp = NULL;
+		}
+
+		/* if its enabled, disable and then re-enable ONLY
+		 * when submitting data to the kernel.
+		 *
+		 * Otherwise even hook scripts will cause fault injections,
+		 * which is not what we want.
+		 */
+		fault_inject_disable(&state);
+	}
+
+	nft_afl_state_logf(&state, "starting (%s, %s fault injection)", instrumented,
+			   state.make_it_fail_fp ? "with" : "no");
+	return 0;
+}
+
+int nft_afl_main(struct nft_ctx *ctx)
+{
+	unsigned int new_additions = 0;
+	bool last_run = false;
+	unsigned char *buf;
+	ssize_t len;
+	int rc;
+
+	if (is_tainted()) {
+		nft_afl_state_logf(&state,
+				  "No more fuzzer runs: TAINT file exists, reboot and remove %s/TAINT",
+				  nft_afl_workdirname);
+		return -1;
+	}
+
+	if (state.make_it_fail_fp) {
+		FILE *fp = fault_inject_open();
+
+		/* reopen is needed because /proc/self is a symlink, i.e.
+		 * fp refers to parent process, not "us".
+		 */
+		if (!fp) {
+			nft_afl_state_logf(&state, "Could not reopen %s: %s", self_fault_inject_file, strerror(errno));
+			return -1;
+		}
+		fclose(state.make_it_fail_fp);
+		state.make_it_fail_fp = fp;
+	}
+
+	rc = nft_afl_read_existing_candidates(&state, ctx);
+	if (rc <= 0)
+		return rc;
+
+	buf = __AFL_FUZZ_TESTCASE_BUF;
+
+	while (__AFL_LOOP(UINT_MAX)) {
+		struct nft_afl_input *cmd_to_run;
+		char *input;
+
+		len = __AFL_FUZZ_TESTCASE_LEN;  // do not use the macro directly in a call!
+
+		input = preprocess(buf, len);
+		if (!input)
+			continue;
+
+		/* buf has minimum length and is null terminated at this point */
+		ctx->afl_ctx_stage = NFT_AFL_FUZZER_PARSER;
+		rc = nft_run_cmd_from_buffer(ctx, input);
+		if (rc < 0) /* rejected at parsing stage */
+			continue;
+
+		if (!nft_afl_switch_to_next_stage(&state, ctx, NFT_AFL_FUZZER_EVALUATION))
+			continue;
+
+		rc = nft_run_cmd_from_buffer(ctx, input);
+		if (rc < 0) /* rejected at eval stage */
+			continue;
+
+		cmd_to_run = save_candidate(&state, input);
+		if (!cmd_to_run)
+			break;
+
+		nft_exec_hookscript(&state, "pre-commit");
+
+		if (!nft_afl_run_cmd(&state, ctx, cmd_to_run))
+			continue;
+
+		nft_exec_hookscript(&state, "post-commit");
+
+		if (++new_additions > 1024 || last_run)
+			break;
+
+		last_run = (state.levelcount == (array_size(state.level) - 1)) && state.level[array_size(state.level) - 1].next;
+	}
+
+	/* afl-fuzz will restart us. */
+	return 0;
+}
diff --git a/src/libnftables.c b/src/libnftables.c
index 0dee1bacb0db..d4ba696a7e7a 100644
--- a/src/libnftables.c
+++ b/src/libnftables.c
@@ -9,6 +9,7 @@
 #include <nft.h>
 
 #include <nftables/libnftables.h>
+#include <afl++.h>
 #include <erec.h>
 #include <mnl.h>
 #include <parser.h>
@@ -18,6 +19,17 @@
 #include <errno.h>
 #include <sys/stat.h>
 
+static int do_mnl_batch_talk(struct netlink_ctx *ctx, struct list_head *err_list,
+			     uint32_t num_cmds)
+{
+#if defined(HAVE_FUZZER_BUILD)
+	if (ctx->nft->afl_ctx_stage &&
+	    ctx->nft->afl_ctx_stage < NFT_AFL_FUZZER_NETLINK_RW)
+		return 0;
+#endif
+	return mnl_batch_talk(ctx, err_list, num_cmds);
+}
+
 static int nft_netlink(struct nft_ctx *nft,
 		       struct list_head *cmds, struct list_head *msgs)
 {
@@ -36,6 +48,11 @@ static int nft_netlink(struct nft_ctx *nft,
 	if (list_empty(cmds))
 		goto out;
 
+#if defined(HAVE_FUZZER_BUILD)
+	if (nft->afl_ctx_stage &&
+	    nft->afl_ctx_stage <= NFT_AFL_FUZZER_EVALUATION)
+		goto out;
+#endif
 	batch_seqnum = mnl_batch_begin(ctx.batch, mnl_seqnum_alloc(&seqnum));
 	list_for_each_entry(cmd, cmds, list) {
 		ctx.seqnum = cmd->seqnum = mnl_seqnum_alloc(&seqnum);
@@ -54,7 +71,7 @@ static int nft_netlink(struct nft_ctx *nft,
 	if (!mnl_batch_ready(ctx.batch))
 		goto out;
 
-	ret = mnl_batch_talk(&ctx, &err_list, num_cmds);
+	ret = do_mnl_batch_talk(&ctx, &err_list, num_cmds);
 	if (ret < 0) {
 		if (ctx.maybe_emsgsize && errno == EMSGSIZE) {
 			netlink_io_error(&ctx, NULL,
@@ -579,6 +596,10 @@ int nft_run_cmd_from_buffer(struct nft_ctx *nft, const char *buf)
 		rc = nft_parse_bison_buffer(nft, nlbuf, &msgs, &cmds,
 					    &indesc_cmdline);
 
+#if defined(HAVE_FUZZER_BUILD)
+	if (nft->afl_ctx_stage == NFT_AFL_FUZZER_PARSER)
+		goto err;
+#endif
 	parser_rc = rc;
 
 	rc = nft_evaluate(nft, &msgs, &cmds);
diff --git a/src/main.c b/src/main.c
index d3491cda7f8d..eb8e2d1e5b67 100644
--- a/src/main.c
+++ b/src/main.c
@@ -21,6 +21,7 @@
 #include <nftables/libnftables.h>
 #include <utils.h>
 #include <cli.h>
+#include <afl++.h>
 
 static struct nft_ctx *nft;
 
@@ -55,6 +56,9 @@ enum opt_indices {
         IDX_ECHO,
 #define IDX_CMD_OUTPUT_START	IDX_ECHO
         IDX_JSON,
+#ifdef HAVE_FUZZER_BUILD
+        IDX_FUZZER,
+#endif
         IDX_DEBUG,
 #define IDX_CMD_OUTPUT_END	IDX_DEBUG
 };
@@ -83,6 +87,11 @@ enum opt_vals {
 	OPT_TERSE		= 't',
 	OPT_OPTIMIZE		= 'o',
 	OPT_INVALID		= '?',
+
+#ifdef HAVE_FUZZER_BUILD
+	/* keep last */
+        OPT_FUZZER		= 254
+#endif
 };
 
 struct nft_opt {
@@ -140,6 +149,10 @@ static const struct nft_opt nft_options[] = {
 				     "Specify debugging level (scanner, parser, eval, netlink, mnl, proto-ctx, segtree, all)"),
 	[IDX_OPTIMIZE]	    = NFT_OPT("optimize",		OPT_OPTIMIZE,		NULL,
 				     "Optimize ruleset"),
+#ifdef HAVE_FUZZER_BUILD
+	[IDX_FUZZER]	    = NFT_OPT("fuzzer",			OPT_FUZZER,		"stage",
+				      "fuzzer stage to run (parser, eval, netlink-ro, netlink-rw)"),
+#endif
 };
 
 #define NR_NFT_OPTIONS (sizeof(nft_options) / sizeof(nft_options[0]))
@@ -230,6 +243,7 @@ static void show_help(const char *name)
 		print_option(&nft_options[i]);
 
 	fputs("\n", stdout);
+	nft_afl_print_build_info(stdout);
 }
 
 static void show_version(void)
@@ -271,6 +285,8 @@ static void show_version(void)
 	       "  libxtables:	%s\n",
 	       PACKAGE_NAME, PACKAGE_VERSION, RELEASE_NAME,
 	       cli, json, minigmp, xt);
+
+	nft_afl_print_build_info(stdout);
 }
 
 static const struct {
@@ -311,6 +327,38 @@ static const struct {
 	},
 };
 
+#if defined(HAVE_FUZZER_BUILD)
+static const struct {
+	const char			*name;
+	enum nft_afl_fuzzer_stage	stage;
+} fuzzer_stage_param[] = {
+	{
+		.name		= "parser",
+		.stage		= NFT_AFL_FUZZER_PARSER,
+	},
+	{
+		.name		= "eval",
+		.stage		= NFT_AFL_FUZZER_EVALUATION,
+	},
+	{
+		.name		= "netlink-ro",
+		.stage		= NFT_AFL_FUZZER_NETLINK_RO,
+	},
+	{
+		.name		= "netlink-rw",
+		.stage		= NFT_AFL_FUZZER_NETLINK_RW,
+	},
+};
+static void afl_exit(const char *err)
+{
+	fprintf(stderr, "Error: fuzzer: %s\n", err);
+	sleep(60);	/* assume we're running under afl-fuzz and would be restarted right away */
+	exit(EXIT_FAILURE);
+}
+#else
+static inline void afl_exit(const char *err) { }
+#endif
+
 static void nft_options_error(int argc, char * const argv[], int pos)
 {
 	int i;
@@ -359,6 +407,7 @@ static bool nft_options_check(int argc, char * const argv[])
 int main(int argc, char * const *argv)
 {
 	const struct option *options = get_options();
+	enum nft_afl_fuzzer_stage fuzzer_stage = 0;
 	bool interactive = false, define = false;
 	const char *optstring = get_optstring();
 	unsigned int output_flags = 0;
@@ -501,6 +550,26 @@ int main(int argc, char * const *argv)
 		case OPT_OPTIMIZE:
 			nft_ctx_set_optimize(nft, 0x1);
 			break;
+#if defined(HAVE_FUZZER_BUILD)
+		case OPT_FUZZER:
+			{
+				unsigned int i;
+
+				for (i = 0; i < array_size(fuzzer_stage_param); i++) {
+					if (strcmp(fuzzer_stage_param[i].name, optarg))
+						continue;
+					fuzzer_stage = fuzzer_stage_param[i].stage;
+					break;
+				}
+
+				if (i == array_size(fuzzer_stage_param)) {
+					fprintf(stderr, "invalid fuzzer stage `%s'\n",
+						optarg);
+					goto out_fail;
+				}
+			}
+			break;
+#endif
 		case OPT_INVALID:
 			goto out_fail;
 		}
@@ -513,6 +582,38 @@ int main(int argc, char * const *argv)
 
 	nft_ctx_output_set_flags(nft, output_flags);
 
+	if (fuzzer_stage) {
+		unsigned int input_flags;
+
+		if (filename || define || interactive)
+			afl_exit("-D/--define, -f/--filename and -i/--interactive are incompatible options");
+
+		rc = nft_afl_init(fuzzer_stage);
+		if (rc != 0)
+			afl_exit("cannot initialize");
+
+		input_flags = nft_ctx_input_get_flags(nft);
+
+		/* DNS lookups can result in severe fuzzer slowdown */
+		input_flags |= NFT_CTX_INPUT_NO_DNS;
+		nft_ctx_input_set_flags(nft, input_flags);
+
+		if (fuzzer_stage < NFT_AFL_FUZZER_NETLINK_RW)
+			nft_ctx_set_dry_run(nft, true);
+
+		fprintf(stderr, "Awaiting fuzzer-generated inputs\n");
+	}
+
+	__AFL_INIT();
+
+	if (fuzzer_stage) {
+		rc = nft_afl_main(nft);
+		if (rc != 0)
+			afl_exit("fatal error");
+
+		return EXIT_SUCCESS;
+	}
+
 	if (optind != argc) {
 		char *buf;
 
diff --git a/src/mnl.c b/src/mnl.c
index 9e4bfcd9a030..fa699e3205ba 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -27,6 +27,7 @@
 #include <linux/netfilter/nfnetlink_hook.h>
 #include <linux/netfilter/nf_tables.h>
 
+#include <afl++.h>
 #include <mnl.h>
 #include <cmd.h>
 #include <net/if.h>
@@ -427,7 +428,6 @@ int mnl_batch_talk(struct netlink_ctx *ctx, struct list_head *err_list,
 	}
 
 	mnl_set_rcvbuffer(ctx->nft->nf_sock, rcvbufsiz);
-
 	ret = mnl_nft_socket_sendmsg(ctx, &msg);
 	if (ret == -1)
 		return -1;
diff --git a/tests/afl++/README b/tests/afl++/README
new file mode 100644
index 000000000000..92fdb95e01df
--- /dev/null
+++ b/tests/afl++/README
@@ -0,0 +1,126 @@
+First you need to install afl++.  If your distro doesn't package it, you can
+get it from https://github.com/AFLplusplus/AFLplusplus
+
+Next build and install afl++, this needs llvm/clang installed.
+
+Nftables configue + compile steps:
+
+To get the best results, build nftables with the following options:
+
+CC=afl-clang-lto LD=afl-clang-lto CFLAGS+=-fsanitize=address ./configure \
+   --disable-shared --with-json --without-xtables \
+   --with-cli=readline --enable-fuzzer
+
+[ you might want to enable xtables or use a different cli, your choice ].
+
+Important options are:
+--disable-shared, so that libnftables is instrumented too.
+--enable-fuzzer
+
+--enable-fuzzer is not strictly required, you can run normal nft builds under
+afl-fuzz too.  But the execution speed will be much slower.
+
+--enable-fuzzer also provides the nft --fuzzer command line option that allows
+more fine-grained control over what code paths should be covered by the fuzzing
+process.
+
+Most importantly, it collects the pseudo-generated rules/commands it sends
+to the kernel and saves them in the 'nft-afl-work' directory for later
+debugging.
+
+When fuzzing in this mode, then each new input passes through the following
+processing stages:
+
+1: 'parser':
+    Only run flex/bison parser and quit instantly if that fails,
+    without evaluation of the generated (partial) AST: No need to
+    generate error messages for the user.
+
+2: 'eval': pass the input through the evaluation phase as well.
+    This attempts to build a complete ruleset in memory.
+
+3: 'netlink-ro' or 'netlink-rw'.
+   'netlink-ro' builds the netlink buffer to send to the kernel,
+   without actually doing so.
+   'netlink-rw' will send the buffer to the kernel.
+
+The argument to '--fuzzer' specifies the last stage to run, so e.g.
+'parser' will only exercise flex/bison code paths.
+
+Use 'netlink-ro' if you want to prevent the fuzzing from ever
+submitting any changes to the kernel.
+
+You can use "--fuzzer netlink-rw --check" to send the ruleset to the
+kernel, but have the transaction be aborted before committing any changes.
+
+Note that "--fuzzer netlink-rw --check" can trigger a kernel crash if
+there are bugs in the kernel validation / transaction / abort phases,
+so '--check --fuzzer netlink-rw' is not the same thing as 'netlink-ro'.
+
+All --fuzzer modes EXCEPT 'netlink-rw' imply --check, these modes never
+alter state in the kernel.
+
+Before sending a command to the kernel, the input is stored in temporary
+files (named [0-255]/[0-255] in the "nft-afl-work" directory.
+
+After each input, fuzzer mode will check the kernel taint status.
+
+If kernel is tainted, the file nft-afl-work/TAINT is created.
+The fuzzer is stopped. You need to reboot and manually remove the TAINT file.
+
+To execute nftables with afl++, run nftables like this:
+
+unshare -n \
+  afl-fuzz -g 16 -G 2000 -t 5000 -i tests/afl++/in -o tests/afl++/out \
+  -- src/nft --fuzzer <arg>
+
+arg should be either "netlink-ro" (if you only want to exercise nft userspace)
+or "netlink-rw" (if you want to test kernel code paths too).
+
+See nft --help for a list of valid stages to fuzz.
+
+Its also a good idea to do this from tmux/screen so you can disconnect/reattach
+later.  You can also spawn multiple instances.
+In that case, add the '-M' option to afl-fuzz for the first instance you start,
+and '-S' for subsequent secondary instances.
+
+This expects a unique directory name as argument, so interesting findings 
+from the different instances are cleary separated.
+
+With above default options, outputs will be in 'tests/afl++/out/<variantname>'.
+Please see the afl++ docs for more information about this.
+
+You can use tests/afl++/run-afl.sh script to autogenerate an initial set of valid
+inputs that the fuzzer can start from.
+
+Use
+
+sysctl -f tests/afl++/afl-sysctl.cfg
+
+to enable some fuzzer-beneficial sysctl options.
+
+--fuzzer supports hook scripts, see the provided skeletons in tests/afl++/hooks/
+Remove or copy the scripts and remove the '-sample' suffix.
+Scripts need to be executable, owned by root and not writeable by others.
+
+The environment variable NFT_AFL_WORKDIR will be set before running a hook
+script, it contains the relative pathname to the nft-afl work directory.
+
+Kernel config:
+Best to use a debug kernel with at least
+
+# CONFIG_NOTIFIER_ERROR_INJECTION is not set
+CONFIG_KASAN=y
+CONFIG_KASAN_INLINE=y
+CONFIG_DEBUG_ATOMIC_SLEEP=y
+CONFIG_DEBUG_LOCKDEP=y
+CONFIG_FAULT_INJECTION=y
+CONFIG_FAILSLAB=y
+CONFIG_DEBUG_KMEMLEAK=y
+
+If you want to sample test coverage, then set
+CONFIG_GCOV_KERNEL=y
+
+echo GCOV_PROFILE := y > net/netfilter/Makefile
+
+or enable CONFIG_GCOV_PROFILE_ALL=y
diff --git a/tests/afl++/TODO b/tests/afl++/TODO
new file mode 100644
index 000000000000..d31ba71d2364
--- /dev/null
+++ b/tests/afl++/TODO
@@ -0,0 +1,6 @@
+Fuzzing is sometimes VERY slow, this happens when current inputs contain
+"host names".  Either --fuzzer could set NFT_CTX_INPUT_NO_DNS to avoid this,
+or nft needs a new command line option so both (dns and no dns) can be combined.
+
+Investigate custom mutator for afl to further improve the fuzzing rate.
+This would likely allow to get rid of the pre-validation in src/afl++.c.
diff --git a/tests/afl++/afl-sysctl.cfg b/tests/afl++/afl-sysctl.cfg
new file mode 100644
index 000000000000..490e62b00094
--- /dev/null
+++ b/tests/afl++/afl-sysctl.cfg
@@ -0,0 +1,5 @@
+kernel.core_pattern=core
+fs.suid_dumpable=1
+kernel.core_uses_pid=0
+kernel.randomize_va_space=0
+kernel.sched_autogroup_enabled=1
diff --git a/tests/afl++/hooks/init b/tests/afl++/hooks/init
new file mode 100755
index 000000000000..503257afa2f1
--- /dev/null
+++ b/tests/afl++/hooks/init
@@ -0,0 +1,54 @@
+#!/bin/bash
+
+# This script is run only once, when "nft --fuzzer" is started.
+# It doesn't run again when afl-fuzz auto-restarts with a new
+# input round, you need to CTRL-C and re-invoke afl.
+
+rm -f $NFT_AFL_WORKDIR/[0-255][0-255][0-255]/[0-255][0-255][0-255]
+
+# clean state
+nft flush ruleset
+
+set_fails() {
+	FAILTYPE=$1
+
+	test -d /sys/kernel/debug/$FAILTYPE/ || return
+
+	# We want failures when the fuzzed nft talks to kernel, this
+	# pairs with the post-restart script which has to do
+	#  echo 1 > /proc/$PPID/make-it-fail
+	echo Y > /sys/kernel/debug/$FAILTYPE/task-filter
+
+	# 10% failure rate, this is a lot as nft transactions
+	# allocate a lot of temporary transaction objects.
+	echo 1 > /sys/kernel/debug/$FAILTYPE/probability
+
+	# interval where fault inject is suppressed
+	echo 100 > /sys/kernel/debug/$FAILTYPE/interval
+
+	# unlimited failslab errors.
+	echo -1 > /sys/kernel/debug/$FAILTYPE/times
+
+	# no initial budget, i.e. fails are allowed instantly
+	echo 0 > /sys/kernel/debug/$FAILTYPE/space
+
+	# 0: no messages, 1: one line, 2: backtrace for each injected error
+	echo 0 > /sys/kernel/debug/$FAILTYPE/verbose
+
+	# also fail GFP_KERNEL allocations.
+	# Most allocations nf_tables control plane performs
+	# can sleep. We want to maximise error path coverage so
+	# we want allocation failures for those as well.
+	echo N > /sys/kernel/debug/$FAILTYPE/ignore-gfp-wait
+}
+
+set_fails "failslab"
+set_fails "fail_page_alloc"
+
+# Enable fault injection on kernel side for all transactions.
+# NB: nft --fuzzer will auto-disable this immediately and then
+# re-enable it just for the final fuzzer stage, when data is sent
+# to kernel.  Otherwise, even hook scripts and parser/evaluation
+# stage fuzzing would be subject to fault injections.
+nftpid=$PPID
+test -f /proc/$nftpid/make-it-fail && echo 1 > /proc/$nftpid/make-it-fail
diff --git a/tests/afl++/hooks/post-commit b/tests/afl++/hooks/post-commit
new file mode 100755
index 000000000000..be81ce6747b4
--- /dev/null
+++ b/tests/afl++/hooks/post-commit
@@ -0,0 +1,8 @@
+#!/bin/bash
+
+# This script is run right after "nft --fuzzer" has committed a
+# fuzzer-generated ruleset to the kernel.
+
+test -f $NFT_AFL_WORKDIR/TAINT || exit 0
+
+exec nft list ruleset > $NFT_AFL_WORKDIR/post_taint_ruleset
diff --git a/tests/afl++/hooks/post-restart b/tests/afl++/hooks/post-restart
new file mode 100755
index 000000000000..1848709a4ea1
--- /dev/null
+++ b/tests/afl++/hooks/post-restart
@@ -0,0 +1,8 @@
+#!/bin/bash
+
+# This script is run when afl-fuzz has re-started nft with a new fuzzer
+# input round and after "nft --fuzzer" has read the existing input files
+# from its workdir ($NFT_AFL_WORKDIR).
+
+# start each round with a clean kernel state
+nft flush ruleset
diff --git a/tests/afl++/hooks/pre-commit b/tests/afl++/hooks/pre-commit
new file mode 100755
index 000000000000..c89167475907
--- /dev/null
+++ b/tests/afl++/hooks/pre-commit
@@ -0,0 +1,6 @@
+#!/bin/bash
+
+# This script is run right before "nft --fuzzer" is going to submit a new
+# fuzzer-generated ruleset to the kernel.
+
+nft list ruleset > $NFT_AFL_WORKDIR/last_precommit_ruleset
diff --git a/tests/afl++/hooks/pre-restart b/tests/afl++/hooks/pre-restart
new file mode 100755
index 000000000000..4595dfb05889
--- /dev/null
+++ b/tests/afl++/hooks/pre-restart
@@ -0,0 +1,12 @@
+#!/bin/bash
+
+# This script is run when afl-fuzz has re-started nft with a new fuzzer
+# input round and before "nft --fuzzer" has read the existing input files
+# from its workdir ($NFT_AFL_WORKDIR).
+
+test -f /sys/kernel/debug/kmemleak && echo "scan" > /sys/kernel/debug/kmemleak &
+
+# house-cleaning: delete old inputs
+find $NFT_AFL_WORKDIR/*/ -type f -mmin +15 -exec rm -f {} + &
+
+nft list ruleset > $NFT_AFL_WORKDIR/current_ruleset
diff --git a/tests/afl++/run-afl.sh b/tests/afl++/run-afl.sh
new file mode 100755
index 000000000000..7bec254c4a81
--- /dev/null
+++ b/tests/afl++/run-afl.sh
@@ -0,0 +1,43 @@
+#!/bin/bash
+
+set -e
+
+ME=$(dirname $0)
+SRC_NFT="$(dirname $0)/../../src/nft"
+
+cd $ME/../..
+
+echo "# nft tokens and common strings, autogenerated via $0" >  tests/afl++/nft.dict
+grep %token src/parser_bison.y | while read token comment value; do
+	echo $value
+done | grep -v "[A-Z]" | sort | cut -f 1 -d " " |  grep '^"' >> tests/afl++/nft.dict
+
+cat >> tests/afl++/nft.dict <<EOF
+"\"quoted\""
+"{"
+"}"
+"["
+"]"
+";"
+":"
+","
+"."
+"192.168.0.1"
+"65535"
+";;"
+"\x09"
+"\x0d\x0a"
+"\x0a"
+EOF
+
+for d in "tests/afl++/in/" "tests/afl++/out/" "tests/afl++/nft-afl-work/"; do
+	test -d "$d" || mkdir "$d"
+done
+
+find tests/shell/testcases -type f -name '*.nft' | while read filename; do
+	install -m 644 $filename "tests/afl++/in/"$(echo $filename | tr / _)
+done
+
+echo "built initial set of inputs to fuzz from shell test case dump files."
+echo "sample invocation:"
+echo "unshare -n afl-fuzz -g 16 -G 2000 -t 5000 -i tests/afl++/in -o tests/afl++/out -- src/nft --fuzzer netlink-ro"
-- 
2.41.0

