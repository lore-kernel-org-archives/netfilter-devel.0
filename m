Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98D59EB64D8
	for <netfilter-devel@archiver.kernel.org>; Thu, 22 Jun 2023 15:46:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229659AbjFVPqt (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 22 Jun 2023 11:46:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230195AbjFVPqr (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 22 Jun 2023 11:46:47 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5122010F6
        for <netfilter-devel@vger.kernel.org>; Thu, 22 Jun 2023 08:46:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=KNkie3FTyJR/1gq++7/fOVJP8AWD6vTI1tHR21xugIU=; b=Fu2hbZlgNRWwoJEpQH8sYhdGWt
        1EKk239Ph6uR8dW5kPM+CTOruFiYp9GUpONk2uceW6wi01rbqSYrWQ6tuFYttBkVvmzxgixyh4uYh
        EpnqNt5pJfsCtRTsblQjjNMk5qg+PhDc/qUff/w+httttPLqDAagdJzvsBXxc15Hfb55p8J2yEmB/
        hjYlay/5MRV0YonQWAqybtP2rVItBqy7kAyNri8WtqxBgQLydY7mQMaWmYbK/QkaCel3mP+KfWJz7
        IP2J0xVt7icCQLJYlq8efC62PCy9p6fxkoJlJniZK1gJ+X0tSVrEh2lLGFMOtCuf/VDjE2TIeMzJq
        rFuPDp/w==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1qCMWA-0001sF-Sf; Thu, 22 Jun 2023 17:46:42 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH 3/4] cli: Make cli_init() return to caller
Date:   Thu, 22 Jun 2023 17:46:33 +0200
Message-Id: <20230622154634.25862-4-phil@nwl.cc>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230622154634.25862-1-phil@nwl.cc>
References: <20230622154634.25862-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Avoid direct exit() calls as that leaves the caller-allocated nft_ctx
object in place. Making sure it is freed helps with valgrind-analyses at
least.

To signal desired exit from CLI, introduce global cli_quit boolean and
make all cli_exit() implementations also set cli_rc variable to the
appropriate return code.

The logic is to finish CLI only if cli_quit is true which asserts proper
cleanup as it is set only by the respective cli_exit() function.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 include/cli.h |  2 +-
 src/cli.c     | 63 ++++++++++++++++++++++++++++++++++-----------------
 2 files changed, 43 insertions(+), 22 deletions(-)

diff --git a/include/cli.h b/include/cli.h
index 609ed2ed0e0aa..c854948e4a16d 100644
--- a/include/cli.h
+++ b/include/cli.h
@@ -12,6 +12,6 @@ static inline int cli_init(struct nft_ctx *nft)
         return -1;
 }
 #endif
-extern void cli_exit(void);
+extern void cli_exit(int rc);
 
 #endif
diff --git a/src/cli.c b/src/cli.c
index 11fc85abeaa2b..5f7e01ff96314 100644
--- a/src/cli.c
+++ b/src/cli.c
@@ -37,6 +37,15 @@
 #define CMDLINE_PROMPT		"nft> "
 #define CMDLINE_QUIT		"quit"
 
+static bool cli_quit;
+static int cli_rc;
+
+static void __cli_exit(int rc)
+{
+	cli_quit = true;
+	cli_rc = rc;
+}
+
 static char histfile[PATH_MAX];
 
 static void
@@ -100,8 +109,8 @@ static char *cli_append_multiline(char *line)
 		if (!s) {
 			fprintf(stderr, "%s:%u: Memory allocation failure\n",
 				__FILE__, __LINE__);
-			cli_exit();
-			exit(EXIT_FAILURE);
+			cli_exit(EXIT_FAILURE);
+			return NULL;
 		}
 		snprintf(s, len + 1, "%s%s", multiline, line);
 		free(multiline);
@@ -125,8 +134,7 @@ static void cli_complete(char *line)
 
 	if (line == NULL) {
 		printf("\n");
-		cli_exit();
-		exit(0);
+		return cli_exit(0);
 	}
 
 	line = cli_append_multiline(line);
@@ -139,10 +147,8 @@ static void cli_complete(char *line)
 	if (*c == '\0')
 		return;
 
-	if (!strcmp(line, CMDLINE_QUIT)) {
-		cli_exit();
-		exit(0);
-	}
+	if (!strcmp(line, CMDLINE_QUIT))
+		return cli_exit(0);
 
 	/* avoid duplicate history entries */
 	hist = history_get(history_length);
@@ -176,16 +182,19 @@ int cli_init(struct nft_ctx *nft)
 	read_history(histfile);
 	history_set_pos(history_length);
 
-	while (true)
+	while (!cli_quit)
 		rl_callback_read_char();
-	return 0;
+
+	return cli_rc;
 }
 
-void cli_exit(void)
+void cli_exit(int rc)
 {
 	rl_callback_handler_remove();
 	rl_deprep_terminal();
 	write_history(histfile);
+
+	__cli_exit(rc);
 }
 
 #elif defined(HAVE_LIBEDIT)
@@ -205,51 +214,63 @@ int cli_init(struct nft_ctx *nft)
 	history_set_pos(history_length);
 
 	rl_set_prompt(CMDLINE_PROMPT);
-	while ((line = readline(rl_prompt)) != NULL) {
+	while (!cli_quit) {
+		line = readline(rl_prompt);
+		if (!line) {
+			cli_exit(0);
+			break;
+		}
 		line = cli_append_multiline(line);
 		if (!line)
 			continue;
 
 		cli_complete(line);
 	}
-	cli_exit();
 
-	return 0;
+	return cli_rc;
 }
 
-void cli_exit(void)
+void cli_exit(int rc)
 {
 	rl_deprep_terminal();
 	write_history(histfile);
+
+	__cli_exit(rc);
 }
 
 #else /* HAVE_LINENOISE */
 
 int cli_init(struct nft_ctx *nft)
 {
-	int quit = 0;
 	char *line;
 
 	init_histfile();
 	linenoiseHistoryLoad(histfile);
 	linenoiseSetMultiLine(1);
 
-	while (!quit && (line = linenoise(CMDLINE_PROMPT)) != NULL) {
+	while (!cli_quit) {
+		line = linenoise(CMDLINE_PROMPT);
+		if (!line) {
+			cli_exit(0);
+			break;
+		}
 		if (strcmp(line, CMDLINE_QUIT) == 0) {
-			quit = 1;
+			cli_exit(0);
 		} else if (line[0] != '\0') {
 			linenoiseHistoryAdd(line);
 			nft_run_cmd_from_buffer(nft, line);
 		}
 		linenoiseFree(line);
 	}
-	cli_exit();
-	exit(0);
+
+	return cli_rc;
 }
 
-void cli_exit(void)
+void cli_exit(int rc)
 {
 	linenoiseHistorySave(histfile);
+
+	__cli_exit(rc);
 }
 
 #endif /* HAVE_LINENOISE */
-- 
2.40.0

