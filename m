From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft] evaluate: Better error reporting for bad set references
Date: Mon, 19 Jun 2017 14:04:49 +0200
Message-ID: <1497873889-4548-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52498 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750882AbdFSME6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 19 Jun 2017 08:04:58 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 0FCAB210578
        for <netfilter-devel@vger.kernel.org>; Mon, 19 Jun 2017 14:04:48 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 01A381853C
        for <netfilter-devel@vger.kernel.org>; Mon, 19 Jun 2017 14:04:48 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C0E51102182
        for <netfilter-devel@vger.kernel.org>; Mon, 19 Jun 2017 14:04:44 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

In case you refer to an unexisting set, bail out with:

 # nft -f rc.nftables-test
 rc.nftables-test:64:34-49: Error: Set 'reject_to_rule2' does not exist
                ip protocol vmap @reject_to_rule2
                                 ^^^^^^^^^^^^^^^^

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/evaluate.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/src/evaluate.c b/src/evaluate.c
index ec898033c984..ca8b63b74fdc 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -192,8 +192,9 @@ static int expr_evaluate_symbol(struct eval_ctx *ctx, struct expr **expr)
 
 		set = set_lookup(table, (*expr)->identifier);
 		if (set == NULL)
-			return cmd_error(ctx, "Could not process rule: Set '%s' does not exist",
-					 (*expr)->identifier);
+			return expr_error(ctx->msgs, *expr,
+					  "Set '%s' does not exist",
+					  (*expr)->identifier);
 		new = set_ref_expr_alloc(&(*expr)->location, set);
 		break;
 	}
-- 
2.1.4

