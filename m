Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74FE1C433DB
	for <netfilter-devel@archiver.kernel.org>; Mon,  4 Jan 2021 20:47:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 338DF216C4
	for <netfilter-devel@archiver.kernel.org>; Mon,  4 Jan 2021 20:47:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726329AbhADUrX (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 4 Jan 2021 15:47:23 -0500
Received: from correo.us.es ([193.147.175.20]:46580 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726168AbhADUrW (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 4 Jan 2021 15:47:22 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 138F039626B
        for <netfilter-devel@vger.kernel.org>; Mon,  4 Jan 2021 21:46:04 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 05942DA789
        for <netfilter-devel@vger.kernel.org>; Mon,  4 Jan 2021 21:46:04 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id EF7C8DA704; Mon,  4 Jan 2021 21:46:03 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id DADF7DA704;
        Mon,  4 Jan 2021 21:46:00 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 04 Jan 2021 21:46:00 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id AFAEC426CC84;
        Mon,  4 Jan 2021 21:46:00 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     arturo@netfilter.org, phil@nwl.cc
Subject: [PATCH nft] cli: add libedit support
Date:   Mon,  4 Jan 2021 21:46:32 +0100
Message-Id: <20210104204632.2703-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Extend cli to support for libedit readline shim code.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 configure.ac             |  7 ++++++-
 include/cli.h            |  2 +-
 src/cli.c                | 36 ++++++++++++++++++++++++++++--------
 src/main.c               |  4 +++-
 tests/build/run-tests.sh |  2 +-
 5 files changed, 39 insertions(+), 12 deletions(-)

diff --git a/configure.ac b/configure.ac
index 1b493541af3d..043fd53e9bce 100644
--- a/configure.ac
+++ b/configure.ac
@@ -68,7 +68,7 @@ AC_CHECK_LIB([gmp],[__gmpz_init], , AC_MSG_ERROR([No suitable version of libgmp
 AM_CONDITIONAL([BUILD_MINIGMP], [test "x$with_mini_gmp" = xyes])
 
 AC_ARG_WITH([cli], [AS_HELP_STRING([--without-cli],
-            [disable interactive CLI (libreadline or linenoise support)])],
+            [disable interactive CLI (libreadline, libedit or linenoise support)])],
             [], [with_cli=readline])
 
 AS_IF([test "x$with_cli" = xreadline], [
@@ -80,6 +80,11 @@ AC_DEFINE([HAVE_LIBREADLINE], [1], [])
 AC_CHECK_LIB([linenoise], [linenoise], ,
 	     AC_MSG_ERROR([No suitable version of linenoise found]))
 AC_DEFINE([HAVE_LIBLINENOISE], [1], [])
+],
+      [test "x$with_cli" = xedit], [
+AC_CHECK_LIB([edit], [readline], ,
+	     AC_MSG_ERROR([No suitable version of libedit found]))
+AC_DEFINE([HAVE_LIBEDIT], [1], [])
 ],
       [test "x$with_cli" != xno], [
 AC_MSG_ERROR([unexpected CLI value: $with_cli])
diff --git a/include/cli.h b/include/cli.h
index d82517750abc..609ed2ed0e0a 100644
--- a/include/cli.h
+++ b/include/cli.h
@@ -4,7 +4,7 @@
 #include <nftables/libnftables.h>
 #include <config.h>
 
-#if defined(HAVE_LIBREADLINE) || defined(HAVE_LIBLINENOISE)
+#if defined(HAVE_LIBREADLINE) || defined(HAVE_LIBEDIT) || defined(HAVE_LIBLINENOISE)
 extern int cli_init(struct nft_ctx *nft);
 #else
 static inline int cli_init(struct nft_ctx *nft)
diff --git a/src/cli.c b/src/cli.c
index 4c0c3e9d67c6..45811595fc77 100644
--- a/src/cli.c
+++ b/src/cli.c
@@ -24,6 +24,9 @@
 #ifdef HAVE_LIBREADLINE
 #include <readline/readline.h>
 #include <readline/history.h>
+#elif defined(HAVE_LIBEDIT)
+#include <editline/readline.h>
+#include <editline/history.h>
 #else
 #include <linenoise.h>
 #endif
@@ -48,7 +51,26 @@ init_histfile(void)
 	snprintf(histfile, sizeof(histfile), "%s/%s", home, CMDLINE_HISTFILE);
 }
 
-#ifdef HAVE_LIBREADLINE
+#if defined(HAVE_LIBREADLINE)
+static void nft_rl_prompt_save(void)
+{
+	rl_save_prompt();
+	rl_clear_message();
+	rl_set_prompt(".... ");
+}
+#define nft_rl_prompt_restore rl_restore_prompt
+#elif defined(HAVE_LIBEDIT)
+static void nft_rl_prompt_save(void)
+{
+	rl_set_prompt(".... ");
+}
+static void nft_rl_prompt_restore(void)
+{
+	rl_set_prompt("nft> ");
+}
+#endif
+
+#if defined(HAVE_LIBREADLINE) || defined(HAVE_LIBEDIT)
 
 static struct nft_ctx *cli_nft;
 static char *multiline;
@@ -72,9 +94,7 @@ static char *cli_append_multiline(char *line)
 
 	if (multiline == NULL) {
 		multiline = line;
-		rl_save_prompt();
-		rl_clear_message();
-		rl_set_prompt(".... ");
+		nft_rl_prompt_save();
 	} else {
 		len += strlen(multiline);
 		s = malloc(len + 1);
@@ -93,7 +113,7 @@ static char *cli_append_multiline(char *line)
 	if (complete) {
 		line = multiline;
 		multiline = NULL;
-		rl_restore_prompt();
+		nft_rl_prompt_restore();
 	}
 	return line;
 }
@@ -142,7 +162,7 @@ static char **cli_completion(const char *text, int start, int end)
 int cli_init(struct nft_ctx *nft)
 {
 	cli_nft = nft;
-	rl_readline_name = "nft";
+	rl_readline_name = (char *)"nft";
 	rl_instream  = stdin;
 	rl_outstream = stdout;
 
@@ -166,7 +186,7 @@ void cli_exit(void)
 	write_history(histfile);
 }
 
-#else /* !HAVE_LIBREADLINE */
+#else /* HAVE_LINENOISE */
 
 int cli_init(struct nft_ctx *nft)
 {
@@ -195,4 +215,4 @@ void cli_exit(void)
 	linenoiseHistorySave(histfile);
 }
 
-#endif /* HAVE_LIBREADLINE */
+#endif /* HAVE_LINENOISE */
diff --git a/src/main.c b/src/main.c
index 3c26f51029ff..a0caf0796a55 100644
--- a/src/main.c
+++ b/src/main.c
@@ -227,8 +227,10 @@ static void show_version(void)
 {
 	const char *cli, *minigmp, *json, *xt;
 
-#if defined(HAVE_LIBREADLINE)
+#if defined(HAVE_READLINE)
 	cli = "readline";
+#elif defined(HAVE_LIBEDIT)
+	cli = "edit";
 #elif defined(HAVE_LIBLINENOISE)
 	cli = "linenoise";
 #else
diff --git a/tests/build/run-tests.sh b/tests/build/run-tests.sh
index ccb62af3d8dd..fc82f05b4216 100755
--- a/tests/build/run-tests.sh
+++ b/tests/build/run-tests.sh
@@ -2,7 +2,7 @@
 
 log_file="`pwd`/tests.log"
 dir=../..
-argument=( --without-cli --with-cli=linenoise --enable-debug --with-mini-gmp
+argument=( --without-cli --with-cli=linenoise --with-cli=edit --enable-debug --with-mini-gmp
 	   --enable-man-doc --with-xtables --with-json)
 ok=0
 failed=0
-- 
2.20.1

