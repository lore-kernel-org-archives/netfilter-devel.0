Return-Path: <SRS0=Dg9R=XT=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46590C4320D
	for <netfilter-devel@archiver.kernel.org>; Tue, 24 Sep 2019 07:40:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1C03F20872
	for <netfilter-devel@archiver.kernel.org>; Tue, 24 Sep 2019 07:40:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="jo+DE/qL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440594AbfIXHk5 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 24 Sep 2019 03:40:57 -0400
Received: from kadath.azazel.net ([81.187.231.250]:33546 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389597AbfIXHk5 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 24 Sep 2019 03:40:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Nfb2ILmhL/ZAR823BMR/bjDZBOvBwfXxYZ8Urm8VG4U=; b=jo+DE/qLh1Q3Lsvt9Mza2VC8+6
        cc4qsHGvVXk10lkZKoyDEjWhDklngEGs/UINbhxh/1juPGrtXl1Xc28Uc5DQ1EDtYs/XwT2AJa5Os
        VWhJyztGZKpwdc4SozKZTE4B/OuU7J4ADPmMwUsoA7gplV+hh3ravlxraw8ziURY8jW8HB9X9wxyr
        pldPUa3N3Yg83o79Ld9cI0umjxJgIHLUiSF41zgyHr2xboAqDs7fVAbfURZ2SdEVYJsCxM+nK4N3T
        DqTzIRuqwFrmo5ULzL33+W6gLJkg3v2Bw5/493dz3WomA2pnEuCGynBgVCjcfTXHDc7oC2UDAuoT1
        rX39dHeA==;
Received: from ulthar.dreamlands ([192.168.96.2])
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1iCfRP-0001Sh-W4; Tue, 24 Sep 2019 08:40:56 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>,
        Sebastian Priebe <sebastian.priebe@de.sii.group>
Subject: [PATCH nftables v2 1/2] cli: add linenoise CLI implementation.
Date:   Tue, 24 Sep 2019 08:40:54 +0100
Message-Id: <20190924074055.4146-2-jeremy@azazel.net>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190924074055.4146-1-jeremy@azazel.net>
References: <20190924074055.4146-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 192.168.96.2
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

By default, continue to use libreadline, but if `--with-cli=linenoise`
is passed to configure, build the linenoise implementation instead.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 configure.ac             | 17 ++++++++---
 include/cli.h            |  2 +-
 src/cli.c                | 64 ++++++++++++++++++++++++++++++++++------
 tests/build/run-tests.sh |  4 +--
 4 files changed, 71 insertions(+), 16 deletions(-)

diff --git a/configure.ac b/configure.ac
index 68f97f090535..73654b005cd2 100644
--- a/configure.ac
+++ b/configure.ac
@@ -68,12 +68,21 @@ AC_CHECK_LIB([gmp],[__gmpz_init], , AC_MSG_ERROR([No suitable version of libgmp
 AM_CONDITIONAL([BUILD_MINIGMP], [test "x$with_mini_gmp" = xyes])
 
 AC_ARG_WITH([cli], [AS_HELP_STRING([--without-cli],
-            [disable interactive CLI (libreadline support)])],
-            [], [with_cli=yes])
-AS_IF([test "x$with_cli" != xno], [
+            [disable interactive CLI (libreadline or linenoise support)])],
+            [], [with_cli=readline])
+
+AS_IF([test "x$with_cli" = xreadline], [
 AC_CHECK_LIB([readline], [readline], ,
-	     AC_MSG_ERROR([No suitable version of libreadline found]))
+        AC_MSG_ERROR([No suitable version of libreadline found]))
 AC_DEFINE([HAVE_LIBREADLINE], [1], [])
+],
+      [test "x$with_cli" = xlinenoise], [
+AC_CHECK_LIB([linenoise], [linenoise], ,
+        AC_MSG_ERROR([No suitable version of linenoise found]))
+AC_DEFINE([HAVE_LIBLINENOISE], [1], [])
+],
+      [test "x$with_cli" != xno], [
+AC_MSG_ERROR([unexpected CLI value: $with_cli])
 ])
 AM_CONDITIONAL([BUILD_CLI], [test "x$with_cli" != xno])
 
diff --git a/include/cli.h b/include/cli.h
index 023f004b8dab..d82517750abc 100644
--- a/include/cli.h
+++ b/include/cli.h
@@ -4,7 +4,7 @@
 #include <nftables/libnftables.h>
 #include <config.h>
 
-#ifdef HAVE_LIBREADLINE
+#if defined(HAVE_LIBREADLINE) || defined(HAVE_LIBLINENOISE)
 extern int cli_init(struct nft_ctx *nft);
 #else
 static inline int cli_init(struct nft_ctx *nft)
diff --git a/src/cli.c b/src/cli.c
index f1e89926f2bc..4c0c3e9d67c6 100644
--- a/src/cli.c
+++ b/src/cli.c
@@ -21,16 +21,36 @@
 #include <string.h>
 #include <ctype.h>
 #include <limits.h>
+#ifdef HAVE_LIBREADLINE
 #include <readline/readline.h>
 #include <readline/history.h>
+#else
+#include <linenoise.h>
+#endif
 
 #include <cli.h>
 #include <list.h>
 
 #define CMDLINE_HISTFILE	".nft.history"
+#define CMDLINE_PROMPT		"nft> "
+#define CMDLINE_QUIT		"quit"
 
-static struct nft_ctx *cli_nft;
 static char histfile[PATH_MAX];
+
+static void
+init_histfile(void)
+{
+	const char *home;
+
+	home = getenv("HOME");
+	if (home == NULL)
+		home = "";
+	snprintf(histfile, sizeof(histfile), "%s/%s", home, CMDLINE_HISTFILE);
+}
+
+#ifdef HAVE_LIBREADLINE
+
+static struct nft_ctx *cli_nft;
 static char *multiline;
 
 static char *cli_append_multiline(char *line)
@@ -100,7 +120,7 @@ static void cli_complete(char *line)
 	if (*c == '\0')
 		return;
 
-	if (!strcmp(line, "quit")) {
+	if (!strcmp(line, CMDLINE_QUIT)) {
 		cli_exit();
 		exit(0);
 	}
@@ -121,20 +141,15 @@ static char **cli_completion(const char *text, int start, int end)
 
 int cli_init(struct nft_ctx *nft)
 {
-	const char *home;
-
 	cli_nft = nft;
 	rl_readline_name = "nft";
 	rl_instream  = stdin;
 	rl_outstream = stdout;
 
-	rl_callback_handler_install("nft> ", cli_complete);
+	rl_callback_handler_install(CMDLINE_PROMPT, cli_complete);
 	rl_attempted_completion_function = cli_completion;
 
-	home = getenv("HOME");
-	if (home == NULL)
-		home = "";
-	snprintf(histfile, sizeof(histfile), "%s/%s", home, CMDLINE_HISTFILE);
+	init_histfile();
 
 	read_history(histfile);
 	history_set_pos(history_length);
@@ -150,3 +165,34 @@ void cli_exit(void)
 	rl_deprep_terminal();
 	write_history(histfile);
 }
+
+#else /* !HAVE_LIBREADLINE */
+
+int cli_init(struct nft_ctx *nft)
+{
+	int quit = 0;
+	char *line;
+
+	init_histfile();
+	linenoiseHistoryLoad(histfile);
+	linenoiseSetMultiLine(1);
+
+	while (!quit && (line = linenoise(CMDLINE_PROMPT)) != NULL) {
+		if (strcmp(line, CMDLINE_QUIT) == 0) {
+			quit = 1;
+		} else if (line[0] != '\0') {
+			linenoiseHistoryAdd(line);
+			nft_run_cmd_from_buffer(nft, line);
+		}
+		linenoiseFree(line);
+	}
+	cli_exit();
+	exit(0);
+}
+
+void cli_exit(void)
+{
+	linenoiseHistorySave(histfile);
+}
+
+#endif /* HAVE_LIBREADLINE */
diff --git a/tests/build/run-tests.sh b/tests/build/run-tests.sh
index b0560da61398..ccb62af3d8dd 100755
--- a/tests/build/run-tests.sh
+++ b/tests/build/run-tests.sh
@@ -2,8 +2,8 @@
 
 log_file="`pwd`/tests.log"
 dir=../..
-argument=( --without-cli --enable-debug --with-mini-gmp --enable-man-doc
-	    --with-xtables --with-json)
+argument=( --without-cli --with-cli=linenoise --enable-debug --with-mini-gmp
+	   --enable-man-doc --with-xtables --with-json)
 ok=0
 failed=0
 
-- 
2.23.0

