Return-Path: <SRS0=EuAs=XL=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD91CC4CECE
	for <netfilter-devel@archiver.kernel.org>; Mon, 16 Sep 2019 12:42:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AAA57214D9
	for <netfilter-devel@archiver.kernel.org>; Mon, 16 Sep 2019 12:42:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="t8uTpO6q"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728055AbfIPMmJ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 16 Sep 2019 08:42:09 -0400
Received: from kadath.azazel.net ([81.187.231.250]:44754 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727884AbfIPMmI (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 16 Sep 2019 08:42:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=0DqLwI+UVwRjZYJjD0KwmgcyRRAG3DXK59HpCKohL7s=; b=t8uTpO6qvJB2fdpXnom9n2ttnI
        B7NlYvcsRD0AC4MJQf0nun68/FdwIUXaxWei0+JcPqenA4UrseyrYS5pxkAN95/r+ugLFzKePfjzs
        0uFyReX+9qj5BJZwW2swHhDzY5wBRid4H+sB0xV3oeLyIV4OYAOhKyOizTbQqR+J5/bgAI6C4wmVB
        /z6ZVBBQLLD8sIqbl6LsyrDYPSEzFQgA7akxRbO8Sqz1mqYOFEvHXsJFdQUVxN0U38ACO5bME5LNe
        rL3WHuyEBdhKcSJLMfANAgv3tVq7k03DRZ/4kAp8CeyqOr0gPbtGOuDgmeCqy6UIU0w4o08ZcamcI
        uTa8Egtg==;
Received: from ulthar.dreamlands ([192.168.96.2])
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1i9qKS-0005OR-SA; Mon, 16 Sep 2019 13:42:04 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Cc:     Sebastian Priebe <sebastian.priebe@de.sii.group>
Subject: [PATCH RFC nftables 4/4] cli: add linenoise CLI implementation.
Date:   Mon, 16 Sep 2019 13:42:03 +0100
Message-Id: <20190916124203.31380-5-jeremy@azazel.net>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190916124203.31380-1-jeremy@azazel.net>
References: <4df20614cd10434b9f91080d0862dd0c@de.sii.group>
 <20190916124203.31380-1-jeremy@azazel.net>
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
 Makefile.am                               |  7 ++-
 configure.ac                              | 18 +++++--
 include/cli.h                             |  2 +-
 linenoise/.gitignore                      |  6 +++
 linenoise/Makefile.am                     | 13 +++++
 linenoise/{Makefile => Makefile.upstream} |  0
 src/Makefile.am                           |  6 +++
 src/cli.c                                 | 64 +++++++++++++++++++----
 8 files changed, 101 insertions(+), 15 deletions(-)
 create mode 100644 linenoise/.gitignore
 create mode 100644 linenoise/Makefile.am
 rename linenoise/{Makefile => Makefile.upstream} (100%)

diff --git a/Makefile.am b/Makefile.am
index 4a17424d45b8..0095e1958482 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -1,6 +1,11 @@
 ACLOCAL_AMFLAGS	= -I m4
 
-SUBDIRS = 	src	\
+if BUILD_CLI_LINENOISE
+SUBDIRS = linenoise
+else
+SUBDIRS =
+endif
+SUBDIRS += 	src	\
 		include	\
 		files	\
 		doc
diff --git a/configure.ac b/configure.ac
index 68f97f090535..347f3b0cc772 100644
--- a/configure.ac
+++ b/configure.ac
@@ -68,14 +68,23 @@ AC_CHECK_LIB([gmp],[__gmpz_init], , AC_MSG_ERROR([No suitable version of libgmp
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
+AH_TEMPLATE([HAVE_LINENOISE], [])
+AC_DEFINE([HAVE_LINENOISE], [1], [])
+],
+      [test "x$with_cli" != xno], [
+AC_MSG_ERROR([unexpected CLI value: $with_cli])
 ])
 AM_CONDITIONAL([BUILD_CLI], [test "x$with_cli" != xno])
+AM_CONDITIONAL([BUILD_CLI_LINENOISE], [test "x$with_cli" = xlinenoise])
 
 AC_ARG_WITH([xtables], [AS_HELP_STRING([--with-xtables],
             [Use libxtables for iptables interaction])],
@@ -118,6 +127,7 @@ AM_CONDITIONAL([HAVE_PYTHON], [test "$enable_python" != "no"])
 AC_CONFIG_FILES([					\
 		Makefile				\
 		libnftables.pc				\
+		linenoise/Makefile			\
 		src/Makefile				\
 		include/Makefile			\
 		include/nftables/Makefile		\
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
diff --git a/linenoise/.gitignore b/linenoise/.gitignore
new file mode 100644
index 000000000000..38bf97184f38
--- /dev/null
+++ b/linenoise/.gitignore
@@ -0,0 +1,6 @@
+*.la
+*.lo
+*.o
+.deps/
+.libs/
+linenoise_example
diff --git a/linenoise/Makefile.am b/linenoise/Makefile.am
new file mode 100644
index 000000000000..599db790414a
--- /dev/null
+++ b/linenoise/Makefile.am
@@ -0,0 +1,13 @@
+include $(top_srcdir)/Make_global.am
+
+AM_CFLAGS = -Wall -W
+
+noinst_LTLIBRARIES = liblinenoise.la
+
+liblinenoise_la_SOURCES = linenoise.c
+
+noinst_PROGRAMS = linenoise_example
+
+linenoise_example_SOURCES = example.c
+
+linenoise_example_LDADD = liblinenoise.la
diff --git a/linenoise/Makefile b/linenoise/Makefile.upstream
similarity index 100%
rename from linenoise/Makefile
rename to linenoise/Makefile.upstream
diff --git a/src/Makefile.am b/src/Makefile.am
index 740c21f2cac8..0d8a750c461f 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -13,6 +13,9 @@ endif
 if BUILD_XTABLES
 AM_CPPFLAGS += ${XTABLES_CFLAGS}
 endif
+if BUILD_CLI_LINENOISE
+AM_CPPFLAGS += -I$(top_srcdir)/linenoise
+endif
 
 AM_CFLAGS = -Wall								\
 	    -Wstrict-prototypes -Wmissing-prototypes -Wmissing-declarations	\
@@ -106,3 +109,6 @@ libnftables_la_LIBADD += ${JANSSON_LIBS}
 endif
 
 nft_LDADD = libnftables.la
+if BUILD_CLI_LINENOISE
+nft_LDADD += $(top_srcdir)/linenoise/liblinenoise.la
+endif
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
-- 
2.23.0

