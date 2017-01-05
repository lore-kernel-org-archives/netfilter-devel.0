From: Elise Lennion <elise.lennion@gmail.com>
Subject: [PATCH nft] evaluate: Remove cache_update() in cmd_evaluate_flush()
Date: Thu, 5 Jan 2017 16:38:42 -0200
Message-ID: <20170105183842.GA19565@lennorien.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, anatole@rezel.net
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-yw0-f195.google.com ([209.85.161.195]:36705 "EHLO
        mail-yw0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932152AbdAESit (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 5 Jan 2017 13:38:49 -0500
Received: by mail-yw0-f195.google.com with SMTP id r204so45842456ywb.3
        for <netfilter-devel@vger.kernel.org>; Thu, 05 Jan 2017 10:38:49 -0800 (PST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

cache_update() fetches set elements, when the set is big and sorted
this leads to an unnecessary delay on 'nft flush ruleset'.

There is only a possible call to cache_flush() after the update, so
this update isn't needed.

Signed-off-by: Elise Lennion <elise.lennion@gmail.com>
---
 src/evaluate.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index cebc5a9..a506f9a 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -2951,12 +2951,6 @@ static int cmd_evaluate_list(struct eval_ctx *ctx, struct cmd *cmd)
 
 static int cmd_evaluate_flush(struct eval_ctx *ctx, struct cmd *cmd)
 {
-	int ret;
-
-	ret = cache_update(cmd->op, ctx->msgs);
-	if (ret < 0)
-		return ret;
-
 	switch (cmd->obj) {
 	case CMD_OBJ_RULESET:
 		cache_flush();
-- 
2.7.4

