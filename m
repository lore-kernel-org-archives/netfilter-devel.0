Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32F8825B1DA
	for <netfilter-devel@vger.kernel.org>; Fri, 17 Oct 2025 11:51:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760701916; cv=none; b=cSVQFyMmNGfu2VQM/bLT8uSyjux2KwY7sypDtvmV1w87p2kzpvuKJvt1ZI+X0rOO3y1Uyu3YKQllal4TpWaWJl/9/hFbXBA1Z1qasuB06HgMlqX2fbs4ox0RUhd6AdxKxIwuIkjVEdflCEUDMorrN33AABmGh254Tp4IoSpeLQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760701916; c=relaxed/simple;
	bh=Q0aa0jaKL+78OgZKgRL9BHQcR1IR4Cy9LJ1ReKLj8UM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=OChFLQPGnhgz7oRyBj8dULUBoR916iLkybCoO8jibCElGaXiwrE5micjBqraonnZ8d53OQf8WBbhZeqf8Crr13mi6xhZmqaloclwZTVzA30UKXSxXtKhcZBcYcCEKNV1vKPKKbzl0ybGwk6kHYSPN8jxC8V9eXHLSLJQg+HXvAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id E06B260329; Fri, 17 Oct 2025 13:51:49 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft v2] support for afl++ (american fuzzy lop++) fuzzer
Date: Fri, 17 Oct 2025 13:51:41 +0200
Message-ID: <20251017115145.20679-1-fw@strlen.de>
X-Mailer: git-send-email 2.51.0
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
The argument to '--fuzzer' specifies the last stage to run:

1: 'parser':
    Only run / exercise the flex/bison parser.

2: 'eval': stop after the evaluation phase.
    This attempts to build a complete ruleset in memory, does
    symbol resolution, adds needed shift/masks to payload instructions
    etc.

3: 'netlink-ro':
    'netlink-ro' builds the netlink buffer to send to the kernel,
    without actually doing so.

4: 'netlink-rw':
    Pass generated command/ruleset will be passed to the kernel.
    You can combine it with the '--check' option to send data to the kernel
    but without actually committing any changes.
    This could still end up triggering a kernel crash if there are bugs
    in the valiation / transaction / abort phases.

Use 'netlink-ro' if you want to prevent nft from ever submitting any
changes to the kernel or if you are only interested in fuzzing nftables
and its libraries.

In case a kernel splat is detected, the fuzzing process stops and all further
fuzzer attemps are blocked until reboot.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 Changes since v2:
  - get rid of most of v1 preprocessing
  - remove all of the input-save mechanism and
    all of the helper stage scripting that v1 had.

  v1 used to save a backlog of fuzzer inputs to disk so
  that kernel splats could be better understood.
  This slows down fuzzing a lot, so no longer do that.
  It could still be added back later on if needed.

  This patch could be further simplified by removing
  'parser' and 'eval' fuzz modes, but it would not save much
  code so I kept both.

  The netlink-ro one is useful because netlink-rw mode
  is substantially slower (kernel abort, mutex serialization
  when running multiple afl instances in same netns).

 .gitignore                       |   5 +
 Makefile.am                      |   5 +
 configure.ac                     |  17 +++
 include/afl++.h                  |  48 +++++++
 include/nftables.h               |   3 +
 src/afl++.c                      | 213 +++++++++++++++++++++++++++++++
 src/libnftables.c                |  24 +++-
 src/main.c                       | 101 +++++++++++++++
 src/preprocess.c                 |   2 +
 tests/afl++/README               | 108 ++++++++++++++++
 tests/afl++/afl-sysctl.conf      |   5 +
 tests/afl++/check_reproducers.sh | 118 +++++++++++++++++
 tests/afl++/run-afl.sh           |  47 +++++++
 13 files changed, 695 insertions(+), 1 deletion(-)
 create mode 100644 include/afl++.h
 create mode 100644 src/afl++.c
 create mode 100644 tests/afl++/README
 create mode 100644 tests/afl++/afl-sysctl.conf
 create mode 100755 tests/afl++/check_reproducers.sh
 create mode 100755 tests/afl++/run-afl.sh

diff --git a/.gitignore b/.gitignore
index db329eafa529..719829b65d21 100644
--- a/.gitignore
+++ b/.gitignore
@@ -36,6 +36,11 @@ tests/build/tests.log
 /tests/shell/run-tests.sh.log
 /tests/shell/run-tests.sh.trs
 
+# generated by run-afl.sh
+/tests/afl++/in/
+/tests/afl++/nft.dict
+/tests/afl++/out/
+
 # Debian package build temporary files
 build-stamp
 
diff --git a/Makefile.am b/Makefile.am
index fac7ad55cbe7..0a4c213390d5 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -64,6 +64,7 @@ noinst_HEADERS = \
 	include/linux/netfilter_ipv6.h \
 	include/linux/netfilter_ipv6/ip6_tables.h \
 	\
+	include/afl++.h	\
 	include/cache.h \
 	include/cli.h \
 	include/cmd.h \
@@ -293,6 +294,10 @@ sbin_PROGRAMS += src/nft
 
 src_nft_SOURCES = src/main.c
 
+if BUILD_AFL
+src_nft_SOURCES += src/afl++.c
+endif
+
 if BUILD_CLI
 src_nft_SOURCES += src/cli.c
 endif
diff --git a/configure.ac b/configure.ac
index a3ae2956cdf3..9a65fcaf0374 100644
--- a/configure.ac
+++ b/configure.ac
@@ -91,6 +91,18 @@ AC_MSG_ERROR([unexpected CLI value: $with_cli])
 ])
 AM_CONDITIONAL([BUILD_CLI], [test "x$with_cli" != xno])
 
+AC_ARG_ENABLE([fuzzer],
+	      AS_HELP_STRING([--enable-fuzzer], [Enable fuzzer support.  NEVER use this unless you work on nftables project]),
+	      [enable_fuzzer=yes], [enable_fuzzer=no])
+
+AM_CONDITIONAL([BUILD_AFL], [test "x$enable_fuzzer" = xyes])
+
+HAVE_FUZZER_BUILD=0
+AS_IF([test "x$enable_fuzzer" != xno], [
+	HAVE_FUZZER_BUILD=1
+])
+AC_DEFINE_UNQUOTED([HAVE_FUZZER_BUILD], [$HAVE_FUZZER_BUILD], [Whether to build with fuzzer support])
+
 AC_ARG_WITH([xtables], [AS_HELP_STRING([--with-xtables],
             [Use libxtables for iptables interaction])],
 	    [], [with_xtables=no])
@@ -180,3 +192,8 @@ echo "  systemd unit:                 ${unitdir}"
 else
 echo "  systemd unit:                 no"
 fi
+
+# Do not print "fuzzer support:		no", this is development-only.
+AS_IF([test "x$enable_fuzzer" = xyes ], [
+	echo "  fuzzer support:		yes"
+	], [ ])
diff --git a/include/afl++.h b/include/afl++.h
new file mode 100644
index 000000000000..a23bcef1bd0d
--- /dev/null
+++ b/include/afl++.h
@@ -0,0 +1,48 @@
+#ifndef _NFT_AFLPLUSPLUS_H_
+#define _NFT_AFLPLUSPLUS_H_
+
+#include <nftables/libnftables.h>
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
+#if HAVE_FUZZER_BUILD && defined(FUZZING_BUILD_MODE_UNSAFE_FOR_PRODUCTION)
+	fprintf(fp, "\nWARNING: BUILT WITH FUZZER SUPPORT AND AFL INSTRUMENTATION\n");
+#elif defined(FUZZING_BUILD_MODE_UNSAFE_FOR_PRODUCTION)
+	fprintf(fp, "\nWARNING: BUILT WITH AFL INSTRUMENTATION\n");
+#elif HAVE_FUZZER_BUILD
+	fprintf(fp, "\nWARNING: BUILT WITH FUZZER SUPPORT BUT NO AFL INSTRUMENTATION\n");
+#endif
+}
+
+#if HAVE_FUZZER_BUILD
+extern int nft_afl_init(struct nft_ctx *nft, enum nft_afl_fuzzer_stage s);
+extern int nft_afl_main(struct nft_ctx *nft);
+#else
+static inline int nft_afl_main(struct nft_ctx *ctx)
+{
+        return -1;
+}
+static inline int nft_afl_init(struct nft_ctx *nft, enum nft_afl_fuzzer_stage s){ return -1; }
+#endif
+
+#ifndef FUZZING_BUILD_MODE_UNSAFE_FOR_PRODUCTION
+#define __AFL_INIT() do { } while (0)
+#endif
+#endif
diff --git a/include/nftables.h b/include/nftables.h
index c058667c03fa..538150126816 100644
--- a/include/nftables.h
+++ b/include/nftables.h
@@ -145,6 +145,9 @@ struct nft_ctx {
 	void			*json_root;
 	json_t			*json_echo;
 	const char		*stdin_buf;
+#if HAVE_FUZZER_BUILD
+	int			afl_ctx_stage;
+#endif
 };
 
 enum nftables_exit_codes {
diff --git a/src/afl++.c b/src/afl++.c
new file mode 100644
index 000000000000..b276e7b6ba78
--- /dev/null
+++ b/src/afl++.c
@@ -0,0 +1,213 @@
+/*
+ * Copyright (c) Red Hat GmbH.	Author: Florian Westphal <fw@strlen.de>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 (or any
+ * later) as published by the Free Software Foundation.
+ */
+
+#include <nft.h>
+#include <stdio.h>
+
+#include <errno.h>
+#include <ctype.h>
+#include <limits.h>
+#include <fcntl.h>
+#include <unistd.h>
+#include <time.h>
+
+#include <sys/stat.h>
+#include <sys/wait.h>
+
+#include <afl++.h>
+#include <nftables.h>
+
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
+struct nft_afl_state {
+	FILE *make_it_fail_fp;
+};
+
+static struct nft_afl_state state;
+
+static char *preprocess(unsigned char *input, ssize_t len)
+{
+	ssize_t real_len = strnlen((char *)input, len);
+
+	if (real_len == 0)
+		return NULL;
+
+	if (real_len >= len)
+		input[len - 1] = 0;
+
+	return (char *)input;
+}
+
+static bool kernel_is_tainted(void)
+{
+	FILE *fp = fopen("/proc/sys/kernel/tainted", "r");
+	unsigned int taint;
+	bool ret = false;
+
+	if (fp) {
+		if (fscanf(fp, "%u", &taint) == 1 && taint) {
+			fprintf(stderr, "Kernel is tainted: 0x%x\n", taint);
+			sleep(3);	/* in case we run under fuzzer, don't restart right away */
+			ret = true;
+		}
+
+		fclose(fp);
+	}
+
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
+static bool nft_afl_run_cmd(struct nft_ctx *ctx, const char *input_cmd)
+{
+	if (kernel_is_tainted())
+		return false;
+
+	switch (ctx->afl_ctx_stage) {
+	case NFT_AFL_FUZZER_PARSER:
+	case NFT_AFL_FUZZER_EVALUATION:
+	case NFT_AFL_FUZZER_NETLINK_RO:
+		nft_run_cmd_from_buffer(ctx, input_cmd);
+		return true;
+	case NFT_AFL_FUZZER_NETLINK_RW:
+		break;
+	}
+
+	fault_inject_enable(&state);
+	nft_run_cmd_from_buffer(ctx, input_cmd);
+	fault_inject_disable(&state);
+
+	return kernel_is_tainted();
+}
+
+static FILE *fault_inject_open(void)
+{
+	return fopen(self_fault_inject_file, "r+");
+}
+
+static bool nft_afl_state_init(struct nft_afl_state *state)
+{
+	state->make_it_fail_fp = fault_inject_open();
+	return true;
+}
+
+int nft_afl_init(struct nft_ctx *ctx, enum nft_afl_fuzzer_stage stage)
+{
+#ifdef FUZZING_BUILD_MODE_UNSAFE_FOR_PRODUCTION
+	const char instrumented[] = "afl instrumented";
+#else
+	const char instrumented[] = "no afl instrumentation";
+#endif
+	nft_afl_print_build_info(stderr);
+
+	if (!nft_afl_state_init(&state))
+		return -1;
+
+	ctx->afl_ctx_stage = stage;
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
+		 * Otherwise even libnftables memory allocations could fail
+		 * which is not what we want.
+		 */
+		fault_inject_disable(&state);
+	}
+
+	fprintf(stderr, "starting (%s, %s fault injection)", instrumented, state.make_it_fail_fp ? "with" : "no");
+	return 0;
+}
+
+int nft_afl_main(struct nft_ctx *ctx)
+{
+	unsigned char *buf;
+	ssize_t len;
+
+	if (kernel_is_tainted())
+		return -1;
+
+	if (state.make_it_fail_fp) {
+		FILE *fp = fault_inject_open();
+
+		/* reopen is needed because /proc/self is a symlink, i.e.
+		 * fp refers to parent process, not "us".
+		 */
+		if (!fp) {
+			fprintf(stderr, "Could not reopen %s: %s", self_fault_inject_file, strerror(errno));
+			return -1;
+		}
+
+		fclose(state.make_it_fail_fp);
+		state.make_it_fail_fp = fp;
+	}
+
+	buf = __AFL_FUZZ_TESTCASE_BUF;
+
+	while (__AFL_LOOP(UINT_MAX)) {
+		char *input;
+
+		len = __AFL_FUZZ_TESTCASE_LEN;  // do not use the macro directly in a call!
+
+		input = preprocess(buf, len);
+		if (!input)
+			continue;
+
+		/* buf is null terminated at this point */
+		if (!nft_afl_run_cmd(ctx, input))
+			continue;
+	}
+
+	/* afl-fuzz will restart us. */
+	return 0;
+}
diff --git a/src/libnftables.c b/src/libnftables.c
index 9f6a1bc33539..66b03a1170bb 100644
--- a/src/libnftables.c
+++ b/src/libnftables.c
@@ -9,6 +9,7 @@
 #include <nft.h>
 
 #include <nftables/libnftables.h>
+#include <afl++.h>
 #include <erec.h>
 #include <mnl.h>
 #include <parser.h>
@@ -19,6 +20,17 @@
 #include <sys/stat.h>
 #include <libgen.h>
 
+static int do_mnl_batch_talk(struct netlink_ctx *ctx, struct list_head *err_list,
+			     uint32_t num_cmds)
+{
+#if HAVE_FUZZER_BUILD
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
@@ -37,7 +49,13 @@ static int nft_netlink(struct nft_ctx *nft,
 	if (list_empty(cmds))
 		goto out;
 
+#if HAVE_FUZZER_BUILD
+	if (nft->afl_ctx_stage &&
+	    nft->afl_ctx_stage <= NFT_AFL_FUZZER_EVALUATION)
+		goto out;
+#endif
 	batch_seqnum = mnl_batch_begin(ctx.batch, mnl_seqnum_inc(&seqnum));
+
 	list_for_each_entry(cmd, cmds, list) {
 		ctx.seqnum = cmd->seqnum_from = mnl_seqnum_inc(&seqnum);
 		ret = do_command(&ctx, cmd);
@@ -57,7 +75,7 @@ static int nft_netlink(struct nft_ctx *nft,
 	if (!mnl_batch_ready(ctx.batch))
 		goto out;
 
-	ret = mnl_batch_talk(&ctx, &err_list, num_cmds);
+	ret = do_mnl_batch_talk(&ctx, &err_list, num_cmds);
 	if (ret < 0) {
 		if (ctx.maybe_emsgsize && errno == EMSGSIZE) {
 			netlink_io_error(&ctx, NULL,
@@ -605,6 +623,10 @@ int nft_run_cmd_from_buffer(struct nft_ctx *nft, const char *buf)
 		rc = nft_parse_bison_buffer(nft, nlbuf, &msgs, &cmds,
 					    &indesc_cmdline);
 
+#if HAVE_FUZZER_BUILD
+	if (nft->afl_ctx_stage == NFT_AFL_FUZZER_PARSER)
+		goto err;
+#endif
 	parser_rc = rc;
 
 	rc = nft_evaluate(nft, &msgs, &cmds);
diff --git a/src/main.c b/src/main.c
index 72151e62d410..c2e909d2841a 100644
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
+#if HAVE_FUZZER_BUILD
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
+#if HAVE_FUZZER_BUILD
+	/* keep last */
+        OPT_FUZZER		= 254
+#endif
 };
 
 struct nft_opt {
@@ -140,6 +149,10 @@ static const struct nft_opt nft_options[] = {
 				     "Specify debugging level (scanner, parser, eval, netlink, mnl, proto-ctx, segtree, all)"),
 	[IDX_OPTIMIZE]	    = NFT_OPT("optimize",		OPT_OPTIMIZE,		NULL,
 				     "Optimize ruleset"),
+#if HAVE_FUZZER_BUILD
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
 
+#if HAVE_FUZZER_BUILD
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
@@ -500,6 +549,26 @@ int main(int argc, char * const *argv)
 		case OPT_OPTIMIZE:
 			nft_ctx_set_optimize(nft, 0x1);
 			break;
+#if HAVE_FUZZER_BUILD
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
@@ -512,6 +581,38 @@ int main(int argc, char * const *argv)
 
 	nft_ctx_output_set_flags(nft, output_flags);
 
+	if (fuzzer_stage) {
+		unsigned int input_flags;
+
+		if (filename || define || interactive)
+			afl_exit("-D/--define, -f/--filename and -i/--interactive are incompatible options");
+
+		rc = nft_afl_init(nft, fuzzer_stage);
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
 
diff --git a/src/preprocess.c b/src/preprocess.c
index 619f67a15049..640ffad34a62 100644
--- a/src/preprocess.c
+++ b/src/preprocess.c
@@ -6,6 +6,8 @@
  * later) as published by the Free Software Foundation.
  */
 
+#include <nft.h>
+
 #include <ctype.h>
 #include <stdio.h>
 #include <stdlib.h>
diff --git a/tests/afl++/README b/tests/afl++/README
new file mode 100644
index 000000000000..9ff7e6485987
--- /dev/null
+++ b/tests/afl++/README
@@ -0,0 +1,108 @@
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
+   --with-cli=readline --enable-fuzzer --disable-man-doc
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
+When fuzzing in this mode, then each new input passes through the following
+processing stages:
+
+1: 'parser':
+    Only run / exercise the flex/bison parser.
+
+2: 'eval': stop after the evaluation phase.
+    This attempts to build a complete ruleset in memory, does
+    symbol resolution, adds needed shift/masks to payload instructions
+    etc.
+
+3: 'netlink-ro':
+    Also build/serialize the ruleset into netlink-commands to send to the
+    kernel, but omit the final write so the kernel will not see the message.
+
+4: 'netlink-rw':
+    Same as 3 but the message will be sent to the kernel.
+    You can combine this option with the '--check' option to send data to the
+    kernel but without committing any changes.
+    Unlike 3), even when combined with '--check', this option can still trigger
+    a kernel crash if there are bugs in the kernel, e.g. during the
+    valiation / transaction / abort stages.
+    When using this without '--check', remember to lauch nft in its own network
+    namespace to prevent VM connectivity loss due to committed 'drop' rules.
+
+Use 'netlink-ro' if you want to prevent nft from ever submitting any
+changes to the kernel or if you are only interested in fuzzing nftables
+and its libraries.
+
+All --fuzzer modes EXCEPT 'netlink-rw' do imply --check as these modes never
+alter state in the kernel.
+
+In rw mode, before each input, nft checks the kernel "taint" status as provided
+by "/proc/sys/kernel/tainted".  If this is non-zero, fuzzing stops.
+
+To run nftables under afl++, run nftables like this:
+
+unshare -n \
+  afl-fuzz -g 16 -G 2000 -t 5000 -i tests/afl++/in -o tests/afl++/out \
+  -- src/nft --fuzzer <arg>
+
+arg should be either "netlink-ro" (if you only want to exercise nft userspace)
+or "netlink-rw" (if you want to test kernel code paths too).
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
+sysctl -f tests/afl++/afl-sysctl.conf
+
+to enable some fuzzer-beneficial sysctl options.
+
+Kernel config:
+When using the 'netlink-rw' option it is best to also use a debug kernel
+with at least:
+
+# CONFIG_NOTIFIER_ERROR_INJECTION is not set
+CONFIG_KASAN=y
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
+or enable CONFIG_GCOV_PROFILE_ALL=y.
diff --git a/tests/afl++/afl-sysctl.conf b/tests/afl++/afl-sysctl.conf
new file mode 100644
index 000000000000..490e62b00094
--- /dev/null
+++ b/tests/afl++/afl-sysctl.conf
@@ -0,0 +1,5 @@
+kernel.core_pattern=core
+fs.suid_dumpable=1
+kernel.core_uses_pid=0
+kernel.randomize_va_space=0
+kernel.sched_autogroup_enabled=1
diff --git a/tests/afl++/check_reproducers.sh b/tests/afl++/check_reproducers.sh
new file mode 100755
index 000000000000..063ad37de628
--- /dev/null
+++ b/tests/afl++/check_reproducers.sh
@@ -0,0 +1,118 @@
+#!/bin/bash
+
+# convenience script to check afl reproducers. Many reproducers are
+# variations of the same bug/root cause, so this allows to check if
+# we get same assertion.
+
+pts=$(readlink /proc/self/fd/0)
+
+files=$(find tests/afl++/out/*/crashes/ -type f -name 'id:0000*')
+
+TMP=""
+
+cleanup()
+{
+	rm -rf "$TMP"
+}
+
+trap cleanup EXIT
+
+[ -z "$files" ] && exit 0
+
+TMP=$(mktemp -d)
+
+prompt_del()
+{
+	local f="$1"
+
+	read yn < "$pts"
+	if [ "$yn" = "y" ];then
+		echo delete
+		rm -f "$f"
+	elif [ "$yn" = "n" ]; then
+		echo kept.
+	fi
+}
+
+filter_asan()
+{
+	# retrain the backtrace only.
+	# else check_dup_output won't detect duplicates due to PID
+	# and register dump.
+	grep '#' "$TMP/output" > "$TMP/asan_bt"
+	[ -s "$TMP/asan_bt" ] && mv "$TMP/asan_bt" "$TMP/output"
+}
+
+check_dup_output()
+{
+	local f="$1"
+	local sha=""
+
+	if [ ! -s "$TMP/output" ]; then
+		return 0
+	fi
+
+	sha=$(sha256sum "$TMP/output" | cut -f 1 -d " ")
+
+	if [ -f "$TMP/$sha.output" ]; then
+		local dup=$(cat "$TMP/$sha".filename)
+		echo "Duplicate output, identical splat seen from $dup"
+
+		local s1=$(du -sb "$dup"| cut -f 1)
+		local s2=$(du -sb "$f"| cut -f 1)
+
+		# keep the smaller file.
+		if [ "$s2" -lt "$s1" ];then
+			echo "$f" > "$TMP/$sha".filename
+			f="$dup"
+		fi
+
+		echo "Delete $f?"
+		prompt_del "$f"
+		return 1
+	fi
+
+	# New output.
+	mv "$TMP/output" "$TMP/$sha.output"
+	echo "$f" > "$TMP/$sha.filename"
+	return 0
+}
+
+check_input()
+{
+	local NFT="$1"
+	local f="$2"
+
+	if [ ! -x "$NFT" ] ;then
+		return 1
+	fi
+
+	for arg in "" "-j"; do
+		"$NFT" --check $arg -f - < "$f" > "$TMP/output" 2>&1
+		local rv=$?
+
+		if grep AddressSanitizer "$TMP/output"; then
+			echo "ASAN: \"$NFT $arg -f $f\" exited with $rv"
+			filter_asan "$TMP/output"
+			check_dup_output "$f"
+			return 0
+		fi
+
+		[ $rv -eq 0 ] && continue
+		[ $rv -eq 1 ] && continue
+
+		echo "\"$NFT $arg -f $f\" exited with $rv"
+		check_dup_output "$f"
+		return 0
+	done
+
+	return 1
+}
+
+for f in $files;do
+	check_input src/nft-asan "$f" && continue
+	check_input src/nft "$f" && continue
+
+	echo "$f did not trigger a splat.  Delete?"
+	prompt_del "$f"
+done
diff --git a/tests/afl++/run-afl.sh b/tests/afl++/run-afl.sh
new file mode 100755
index 000000000000..ee9d98fee3c5
--- /dev/null
+++ b/tests/afl++/run-afl.sh
@@ -0,0 +1,47 @@
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
+for d in "tests/afl++/in/" "tests/afl++/in-json" "tests/afl++/out/";do
+	test -d "$d" || mkdir "$d"
+done
+
+find tests/shell/testcases -type f -name '*.nft' | while read filename; do
+	install -m 644 $filename "tests/afl++/in/"$(echo $filename | tr / _)
+done
+find tests/shell/testcases -type f -name '*.json-nft' | while read filename; do
+	install -m 644 $filename "tests/afl++/in-json/"$(echo $filename | tr / _)
+done
+
+echo "built initial set of inputs to fuzz from shell test case dump files."
+echo "sample invocations:"
+echo "unshare -n afl-fuzz -g 16 -G 2000 -t 5000 -i tests/afl++/in -o tests/afl++/out -- src/nft --fuzzer netlink-ro"
+echo "unshare -n afl-fuzz -g 16 -G 2000 -t 5000 -i tests/afl++/in-json -o tests/afl++/out -- src/nft -j --check --fuzzer netlink-rw"
-- 
2.51.0

