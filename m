From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 7/7] evaluate: bail out on prefix or range to non-interval set
Date: Mon, 18 Apr 2016 20:14:35 +0200
Message-ID: <1461003275-2330-8-git-send-email-pablo@netfilter.org>
References: <1461003275-2330-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35462 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751591AbcDRSO5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 18 Apr 2016 14:14:57 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id B9FB1C1068
	for <netfilter-devel@vger.kernel.org>; Mon, 18 Apr 2016 20:14:55 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 9C0089D0E7
	for <netfilter-devel@vger.kernel.org>; Mon, 18 Apr 2016 20:14:55 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 889B09D0E7
	for <netfilter-devel@vger.kernel.org>; Mon, 18 Apr 2016 20:14:53 +0200 (CEST)
In-Reply-To: <1461003275-2330-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

If you declare a set with no interval flag, you get this bug message:

 # nft add element filter myset { 192.168.1.100/24 }
 BUG: invalid data expression type prefix
 nft: netlink.c:323: netlink_gen_data: Assertion `0' failed.
 Aborted

After this patch, we provide a clue to the user:

 # nft add element filter myset { 192.168.1.100/24 }
 <cmdline>:1:23-38: Error: Set member cannot be prefix, missing interval flag on declaration
 add element filter myset { 192.168.1.100/24 }
                            ^^^^^^^^^^^^^^^^

 # nft add element filter myset { 192.168.1.100-192.168.1.200 }
 <cmdline>:1:23-49: Error: Set member cannot be range, missing interval flag on declaration
 add element filter myset { 192.168.1.100-192.168.1.200 }
                            ^^^^^^^^^^^^^^^^^^^^^^^^^^^

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/evaluate.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/src/evaluate.c b/src/evaluate.c
index 346e34f..be4dac7 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -957,6 +957,21 @@ static int expr_evaluate_set_elem(struct eval_ctx *ctx, struct expr **expr)
 	if (expr_evaluate(ctx, &elem->key) < 0)
 		return -1;
 
+	if (ctx->set && !(ctx->set->flags & SET_F_INTERVAL)) {
+		switch (elem->key->ops->type) {
+		case EXPR_PREFIX:
+			return expr_error(ctx->msgs, elem,
+					  "Set member cannot be prefix, "
+					  "missing interval flag on declaration");
+		case EXPR_RANGE:
+			return expr_error(ctx->msgs, elem,
+					  "Set member cannot be range, "
+					  "missing interval flag on declaration");
+		default:
+			break;
+		}
+	}
+
 	elem->dtype = elem->key->dtype;
 	elem->len   = elem->key->len;
 	elem->flags = elem->key->flags;
-- 
2.1.4

