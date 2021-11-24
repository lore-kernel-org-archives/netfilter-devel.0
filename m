Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC56DC433EF
	for <netfilter-devel@archiver.kernel.org>; Wed, 24 Nov 2021 22:27:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245474AbhKXWa6 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 24 Nov 2021 17:30:58 -0500
Received: from mail.netfilter.org ([217.70.188.207]:37480 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243729AbhKXWa5 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 24 Nov 2021 17:30:57 -0500
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 5A64B60140
        for <netfilter-devel@vger.kernel.org>; Wed, 24 Nov 2021 23:25:34 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] cli: save history on ctrl-d
Date:   Wed, 24 Nov 2021 23:27:40 +0100
Message-Id: <20211124222740.600613-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Missing call to cli_exit() to save the history when ctrl-d is pressed in
nft -i.

Moreover, remove call to rl_callback_handler_remove() in cli_exit() for
editline cli since it does not call rl_callback_handler_install().

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/cli.c | 21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/src/cli.c b/src/cli.c
index 8729176680cf..11fc85abeaa2 100644
--- a/src/cli.c
+++ b/src/cli.c
@@ -152,13 +152,6 @@ static void cli_complete(char *line)
 	nft_run_cmd_from_buffer(cli_nft, line);
 	free(line);
 }
-
-void cli_exit(void)
-{
-	rl_callback_handler_remove();
-	rl_deprep_terminal();
-	write_history(histfile);
-}
 #endif
 
 #if defined(HAVE_LIBREADLINE)
@@ -188,6 +181,13 @@ int cli_init(struct nft_ctx *nft)
 	return 0;
 }
 
+void cli_exit(void)
+{
+	rl_callback_handler_remove();
+	rl_deprep_terminal();
+	write_history(histfile);
+}
+
 #elif defined(HAVE_LIBEDIT)
 
 int cli_init(struct nft_ctx *nft)
@@ -212,10 +212,17 @@ int cli_init(struct nft_ctx *nft)
 
 		cli_complete(line);
 	}
+	cli_exit();
 
 	return 0;
 }
 
+void cli_exit(void)
+{
+	rl_deprep_terminal();
+	write_history(histfile);
+}
+
 #else /* HAVE_LINENOISE */
 
 int cli_init(struct nft_ctx *nft)
-- 
2.30.2

