Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77BADC433E0
	for <netfilter-devel@archiver.kernel.org>; Mon,  4 Jan 2021 16:49:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 38454224DE
	for <netfilter-devel@archiver.kernel.org>; Mon,  4 Jan 2021 16:49:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727696AbhADQsx (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 4 Jan 2021 11:48:53 -0500
Received: from correo.us.es ([193.147.175.20]:41036 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726074AbhADQsx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 4 Jan 2021 11:48:53 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id AC671DA714
        for <netfilter-devel@vger.kernel.org>; Mon,  4 Jan 2021 17:47:35 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9762BDA704
        for <netfilter-devel@vger.kernel.org>; Mon,  4 Jan 2021 17:47:35 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 8CFDFDA73F; Mon,  4 Jan 2021 17:47:35 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5BB5EDA73D;
        Mon,  4 Jan 2021 17:47:32 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 04 Jan 2021 17:47:32 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 3A581426CC85;
        Mon,  4 Jan 2021 17:47:32 +0100 (CET)
Date:   Mon, 4 Jan 2021 17:48:08 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Arturo Borrero Gonzalez <arturo@netfilter.org>
Cc:     "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Subject: Re: Potential licensing issue with libreadline
Message-ID: <20210104164808.GA13217@salvia>
References: <8146169e-57f5-0912-becf-e27b64051177@netfilter.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="BOKacYhQ+x31HxR3"
Content-Disposition: inline
In-Reply-To: <8146169e-57f5-0912-becf-e27b64051177@netfilter.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--BOKacYhQ+x31HxR3
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi Arturo,

On Mon, Jan 04, 2021 at 01:21:46PM +0100, Arturo Borrero Gonzalez wrote:
> Hi,
> 
> the debian nftables package got a bug report about a potential licensing
> issue related to libreadline. More info here:
> 
> https://bugs.debian.org/979103 Legally problematic GPL-3+ readline dependency
> 
> This may or may not be a Debian-specific problem, but I wanted to notify you
> and collect your ideas before trying to work out a solution myself.

I'm attaching a quick patch to use libeditreadline shim as suggested.

--BOKacYhQ+x31HxR3
Content-Type: text/x-diff; charset=utf-8
Content-Disposition: attachment; filename="libedit.patch"

diff --git a/INSTALL b/INSTALL
index a3f10c372d14..a80bc99f8318 100644
--- a/INSTALL
+++ b/INSTALL
@@ -16,7 +16,7 @@ Installation instructions for nftables
 
   - libgmp
 
-  - libreadline
+  - libedit
 
   - pkg-config
 
diff --git a/configure.ac b/configure.ac
index 1b493541af3d..ff2e18376066 100644
--- a/configure.ac
+++ b/configure.ac
@@ -68,13 +68,13 @@ AC_CHECK_LIB([gmp],[__gmpz_init], , AC_MSG_ERROR([No suitable version of libgmp
 AM_CONDITIONAL([BUILD_MINIGMP], [test "x$with_mini_gmp" = xyes])
 
 AC_ARG_WITH([cli], [AS_HELP_STRING([--without-cli],
-            [disable interactive CLI (libreadline or linenoise support)])],
-            [], [with_cli=readline])
+            [disable interactive CLI (libedit or linenoise support)])],
+            [], [with_cli=edit])
 
-AS_IF([test "x$with_cli" = xreadline], [
-AC_CHECK_LIB([readline], [readline], ,
-	     AC_MSG_ERROR([No suitable version of libreadline found]))
-AC_DEFINE([HAVE_LIBREADLINE], [1], [])
+AS_IF([test "x$with_cli" = xedit], [
+AC_CHECK_LIB([edit], [read_history], ,
+	     AC_MSG_ERROR([No suitable version of libedit found]))
+AC_DEFINE([HAVE_LIBEDIT], [1], [])
 ],
       [test "x$with_cli" = xlinenoise], [
 AC_CHECK_LIB([linenoise], [linenoise], ,
diff --git a/doc/nft.txt b/doc/nft.txt
index 2642d8903787..dabdb8aefb7a 100644
--- a/doc/nft.txt
+++ b/doc/nft.txt
@@ -46,7 +46,7 @@ understanding of their meaning. You can get information about options by running
 
 *-i*::
 *--interactive*::
-	Read input from an interactive readline CLI. You can use quit to exit, or use the EOF marker,
+	Read input from an interactive CLI. You can use quit to exit, or use the EOF marker,
 	normally this is CTRL-D.
 
 *-I*::
diff --git a/include/cli.h b/include/cli.h
index d82517750abc..3d93679278b4 100644
--- a/include/cli.h
+++ b/include/cli.h
@@ -4,7 +4,7 @@
 #include <nftables/libnftables.h>
 #include <config.h>
 
-#if defined(HAVE_LIBREADLINE) || defined(HAVE_LIBLINENOISE)
+#if defined(HAVE_LIBEDIT) || defined(HAVE_LIBLINENOISE)
 extern int cli_init(struct nft_ctx *nft);
 #else
 static inline int cli_init(struct nft_ctx *nft)
diff --git a/src/cli.c b/src/cli.c
index 4c0c3e9d67c6..e1950e869dd6 100644
--- a/src/cli.c
+++ b/src/cli.c
@@ -21,9 +21,9 @@
 #include <string.h>
 #include <ctype.h>
 #include <limits.h>
-#ifdef HAVE_LIBREADLINE
-#include <readline/readline.h>
-#include <readline/history.h>
+#ifdef HAVE_LIBEDIT
+#include <editline/readline.h>
+#include <editline/history.h>
 #else
 #include <linenoise.h>
 #endif
@@ -48,7 +48,7 @@ init_histfile(void)
 	snprintf(histfile, sizeof(histfile), "%s/%s", home, CMDLINE_HISTFILE);
 }
 
-#ifdef HAVE_LIBREADLINE
+#ifdef HAVE_LIBEDIT
 
 static struct nft_ctx *cli_nft;
 static char *multiline;
@@ -72,8 +72,6 @@ static char *cli_append_multiline(char *line)
 
 	if (multiline == NULL) {
 		multiline = line;
-		rl_save_prompt();
-		rl_clear_message();
 		rl_set_prompt(".... ");
 	} else {
 		len += strlen(multiline);
@@ -93,7 +91,7 @@ static char *cli_append_multiline(char *line)
 	if (complete) {
 		line = multiline;
 		multiline = NULL;
-		rl_restore_prompt();
+		rl_set_prompt("nft> ");
 	}
 	return line;
 }
@@ -139,10 +137,13 @@ static char **cli_completion(const char *text, int start, int end)
 	return NULL;
 }
 
+static char nft_readline_name[4];
+
 int cli_init(struct nft_ctx *nft)
 {
 	cli_nft = nft;
-	rl_readline_name = "nft";
+	sprintf(nft_readline_name, "nft");
+	rl_readline_name = nft_readline_name;
 	rl_instream  = stdin;
 	rl_outstream = stdout;
 
@@ -166,7 +167,7 @@ void cli_exit(void)
 	write_history(histfile);
 }
 
-#else /* !HAVE_LIBREADLINE */
+#else /* !HAVE_LIBEDIT */
 
 int cli_init(struct nft_ctx *nft)
 {
@@ -195,4 +196,4 @@ void cli_exit(void)
 	linenoiseHistorySave(histfile);
 }
 
-#endif /* HAVE_LIBREADLINE */
+#endif /* HAVE_LIBEDIT */
diff --git a/src/main.c b/src/main.c
index 3c26f51029ff..0a2acc41b935 100644
--- a/src/main.c
+++ b/src/main.c
@@ -227,8 +227,8 @@ static void show_version(void)
 {
 	const char *cli, *minigmp, *json, *xt;
 
-#if defined(HAVE_LIBREADLINE)
-	cli = "readline";
+#if defined(HAVE_LIBEDIT)
+	cli = "edit";
 #elif defined(HAVE_LIBLINENOISE)
 	cli = "linenoise";
 #else

--BOKacYhQ+x31HxR3--
