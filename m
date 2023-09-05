Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54365C83F2C
	for <netfilter-devel@archiver.kernel.org>; Tue,  5 Sep 2023 16:27:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244725AbjIEQ1I (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 5 Sep 2023 12:27:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354816AbjIEOlu (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 5 Sep 2023 10:41:50 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3193B18C
        for <netfilter-devel@vger.kernel.org>; Tue,  5 Sep 2023 07:41:47 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1qdXFR-0007dN-TE; Tue, 05 Sep 2023 16:41:45 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] evaluate: fix get element for concatenated set
Date:   Tue,  5 Sep 2023 16:41:38 +0200
Message-ID: <20230905144141.9290-1-fw@strlen.de>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

given:
table ip filter {
	set test {
		type ipv4_addr . ether_addr . mark
		flags interval
		elements = { 198.51.100.0/25 . 00:0b:0c:ca:cc:10-c1:a0:c1:cc:10:00 . 0x0000006f, }
	}
}

We get lookup failure:

nft get element ip filter test { 198.51.100.1 . 00:0b:0c:ca:cc:10 . 0x6f }
Error: Could not process rule: No such file or directory

Its possible to work around this via dummy range somewhere in the key, e.g.
nft get element ip filter test { 198.51.100.1 . 00:0b:0c:ca:cc:10 . 0x6f-0x6f }

but that shouldn't be needed, so make sure the INTERVAL flag is enabled
for the queried element if the set is of interval type.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/evaluate.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index ab3ec98739e9..b1fe7147c2e1 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -4500,11 +4500,14 @@ static int setelem_evaluate(struct eval_ctx *ctx, struct cmd *cmd)
 		return -1;
 
 	cmd->elem.set = set_get(set);
+	if (set_is_interval(ctx->set->flags)) {
+		if (!(set->flags & NFT_SET_CONCAT) &&
+		    interval_set_eval(ctx, ctx->set, cmd->expr) < 0)
+			return -1;
 
-	if (set_is_interval(ctx->set->flags) &&
-	    !(set->flags & NFT_SET_CONCAT) &&
-	    interval_set_eval(ctx, ctx->set, cmd->expr) < 0)
-		return -1;
+		if (cmd->expr->etype == EXPR_SET)
+			cmd->expr->set_flags |= NFT_SET_INTERVAL;
+	}
 
 	ctx->set = NULL;
 
-- 
2.41.0

