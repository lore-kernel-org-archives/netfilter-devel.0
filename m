Return-Path: <SRS0=2UWv=XQ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2588C49ED7
	for <netfilter-devel@archiver.kernel.org>; Sat, 21 Sep 2019 12:21:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AAF032070C
	for <netfilter-devel@archiver.kernel.org>; Sat, 21 Sep 2019 12:21:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="BKpc8GzG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437858AbfIUMVD (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 21 Sep 2019 08:21:03 -0400
Received: from kadath.azazel.net ([81.187.231.250]:33108 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437850AbfIUMVC (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 21 Sep 2019 08:21:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=bVLIyaoulr9AiK05vx+7dy82NRhbWi2iXLxIKQYpPE8=; b=BKpc8GzGSsOYj4bWQr4M3CR1Pz
        rHlsC8tPCOPZ0XLWktKJVtBC8MEhyHraeNDNcH0X0eN6hnS+/PL47Be5k2Pahnbv3nJxPMYmXKAJW
        HdRDIW8s1eqrDSa9WtQwmhrMhAxEGKGC+omoMf2i5nvwOYEilL3nosPM37WVRJ3atpZ3sFEzwthbk
        wyl1dCJOd63KCNKH2guhVPwz+lWISrWuWbGg9mySBJHYbwY8jopZU1o0loPLakQGI5TtrF04ShKno
        UbOKUKlHhzt+Kx6cNn6/hr9Fb12136n2MKoAMNfpZZi4cFZw7mHkKKkCSIWneYb1BmD8ublvLw5wX
        EWcjoP3A==;
Received: from ulthar.dreamlands ([192.168.96.2])
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1iBeNp-0000qr-Az; Sat, 21 Sep 2019 13:21:01 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>,
        Sebastian Priebe <sebastian.priebe@de.sii.group>
Subject: [PATCH nftables 2/3] cli: add linenoise CLI implementation.
Date:   Sat, 21 Sep 2019 13:20:59 +0100
Message-Id: <20190921122100.3740-3-jeremy@azazel.net>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190921122100.3740-1-jeremy@azazel.net>
References: <20190921122100.3740-1-jeremy@azazel.net>
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
 configure.ac             | 14 ++++++---
 include/cli.h            |  2 +-
 src/Makefile.am          |  9 ++++++
 src/cli.c                | 64 ++++++++++++++++++++++++++++++++++------
 tests/build/run-tests.sh |  4 +--
 5 files changed, 77 insertions(+), 16 deletions(-)

diff --git a/configure.ac b/configure.ac
index 68f97f090535..27cd6f301c43 100644
--- a/configure.ac
+++ b/configure.ac
@@ -68,14 +68,20 @@ AC_CHECK_LIB([gmp],[__gmpz_init], , AC_MSG_ERROR([No suitable version of libgmp
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
+      [test "x$with_cli" = xlinenoise], [],
+      [test "x$with_cli" != xno], [
+AC_MSG_ERROR([unexpected CLI value: $with_cli])
 ])
 AM_CONDITIONAL([BUILD_CLI], [test "x$with_cli" != xno])
+AM_CONDITIONAL([BUILD_CLI_LINENOISE], [test "x$with_cli" = xlinenoise])
 
 AC_ARG_WITH([xtables], [AS_HELP_STRING([--with-xtables],
             [Use libxtables for iptables interaction])],
diff --git a/include/cli.h b/include/cli.h
index 023f004b8dab..ea1bd3267d64 100644
--- a/include/cli.h
+++ b/include/cli.h
@@ -4,7 +4,7 @@
 #include <nftables/libnftables.h>
 #include <config.h>
 
-#ifdef HAVE_LIBREADLINE
+#if defined(HAVE_LIBREADLINE) || defined(HAVE_LINENOISE)
 extern int cli_init(struct nft_ctx *nft);
 #else
 static inline int cli_init(struct nft_ctx *nft)
diff --git a/src/Makefile.am b/src/Makefile.am
index 740c21f2cac8..5c2ecbd87288 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -13,6 +13,9 @@ endif
 if BUILD_XTABLES
 AM_CPPFLAGS += ${XTABLES_CFLAGS}
 endif
+if BUILD_CLI_LINENOISE
+AM_CPPFLAGS += -DHAVE_LINENOISE
+endif
 
 AM_CFLAGS = -Wall								\
 	    -Wstrict-prototypes -Wmissing-prototypes -Wmissing-declarations	\
@@ -98,6 +101,12 @@ nft_SOURCES = main.c
 
 if BUILD_CLI
 nft_SOURCES += cli.c
+if BUILD_CLI_LINENOISE
+noinst_LTLIBRARIES += liblinenoise.la
+liblinenoise_la_SOURCES = linenoise.c
+liblinenoise_la_CFLAGS = -Wall -W
+libnftables_la_LIBADD += liblinenoise.la
+endif
 endif
 
 if BUILD_JSON
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

