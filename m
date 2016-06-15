From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft] src: use new definitions from libnftnl
Date: Wed, 15 Jun 2016 13:56:41 +0200
Message-ID: <1465991801-30494-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43559 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932976AbcFOL4v (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 15 Jun 2016 07:56:51 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 9C2A59BF2C8
	for <netfilter-devel@vger.kernel.org>; Wed, 15 Jun 2016 13:56:49 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 8B5BB1B3065
	for <netfilter-devel@vger.kernel.org>; Wed, 15 Jun 2016 13:56:49 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 386151B3065
	for <netfilter-devel@vger.kernel.org>; Wed, 15 Jun 2016 13:56:45 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Use new definitions in libnftnl, so we can consider getting rid of them
at some point.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/netlink.c             |  4 ++--
 src/netlink_delinearize.c |  4 ++--
 src/netlink_linearize.c   | 14 +++++++-------
 3 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/src/netlink.c b/src/netlink.c
index f82d4fa..cf24c8a 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -1502,10 +1502,10 @@ static int netlink_delinearize_setelem(struct nftnl_set_elem *nlse,
 		data = nftnl_set_elem_get(nlse, NFTNL_SET_ELEM_USERDATA, &len);
 		expr->comment = udata_get_comment(data, len);
 	}
-	if (nftnl_set_elem_is_set(nlse, NFT_SET_ELEM_ATTR_EXPR)) {
+	if (nftnl_set_elem_is_set(nlse, NFTNL_SET_ELEM_EXPR)) {
 		const struct nftnl_expr *nle;
 
-		nle = nftnl_set_elem_get(nlse, NFT_SET_ELEM_ATTR_EXPR, NULL);
+		nle = nftnl_set_elem_get(nlse, NFTNL_SET_ELEM_EXPR, NULL);
 		expr->stmt = netlink_parse_set_expr(set, nle);
 	}
 
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 9e26078..7735699 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -433,7 +433,7 @@ static void netlink_parse_payload_stmt(struct netlink_parse_ctx *ctx,
 	expr = payload_expr_alloc(loc, NULL, 0);
 	payload_init_raw(expr, base, offset, len);
 
-	sreg = netlink_parse_register(nle, NFT_EXPR_PAYLOAD_SREG);
+	sreg = netlink_parse_register(nle, NFTNL_EXPR_PAYLOAD_SREG);
 	val  = netlink_get_register(ctx, loc, sreg);
 	stmt = payload_stmt_alloc(loc, expr, val);
 
@@ -444,7 +444,7 @@ static void netlink_parse_payload(struct netlink_parse_ctx *ctx,
 				  const struct location *loc,
 				  const struct nftnl_expr *nle)
 {
-	if (nftnl_expr_is_set(nle, NFT_EXPR_PAYLOAD_DREG))
+	if (nftnl_expr_is_set(nle, NFTNL_EXPR_PAYLOAD_DREG))
 		netlink_parse_payload_expr(ctx, loc, nle);
 	else
 		netlink_parse_payload_stmt(ctx, loc, nle);
diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index 98c22d8..01a85d0 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -116,7 +116,7 @@ static void netlink_gen_payload(struct netlink_linearize_ctx *ctx,
 			   expr->payload.base - 1);
 	nftnl_expr_set_u32(nle, NFTNL_EXPR_PAYLOAD_OFFSET,
 			   expr->payload.offset / BITS_PER_BYTE);
-	nftnl_expr_set_u32(nle, NFT_EXPR_PAYLOAD_LEN,
+	nftnl_expr_set_u32(nle, NFTNL_EXPR_PAYLOAD_LEN,
 			   div_round_up(expr->len, BITS_PER_BYTE));
 
 	nftnl_rule_add_expr(ctx->nlr, nle);
@@ -1054,14 +1054,14 @@ static void netlink_gen_flow_stmt(struct netlink_linearize_ctx *ctx,
 		op = NFT_DYNSET_OP_ADD;
 
 	nle = alloc_nft_expr("dynset");
-	netlink_put_register(nle, NFT_EXPR_DYNSET_SREG_KEY, sreg_key);
+	netlink_put_register(nle, NFTNL_EXPR_DYNSET_SREG_KEY, sreg_key);
 	if (stmt->flow.key->timeout)
-		nftnl_expr_set_u64(nle, NFT_EXPR_DYNSET_TIMEOUT,
+		nftnl_expr_set_u64(nle, NFTNL_EXPR_DYNSET_TIMEOUT,
 				   stmt->flow.key->timeout);
-	nftnl_expr_set_u32(nle, NFT_EXPR_DYNSET_OP, op);
-	nftnl_expr_set_str(nle, NFT_EXPR_DYNSET_SET_NAME, set->handle.set);
-	nftnl_expr_set_u32(nle, NFT_EXPR_DYNSET_SET_ID, set->handle.set_id);
-	nftnl_expr_set(nle, NFT_EXPR_DYNSET_EXPR,
+	nftnl_expr_set_u32(nle, NFTNL_EXPR_DYNSET_OP, op);
+	nftnl_expr_set_str(nle, NFTNL_EXPR_DYNSET_SET_NAME, set->handle.set);
+	nftnl_expr_set_u32(nle, NFTNL_EXPR_DYNSET_SET_ID, set->handle.set_id);
+	nftnl_expr_set(nle, NFTNL_EXPR_DYNSET_EXPR,
 		       netlink_gen_stmt_stateful(ctx, stmt->flow.stmt), 0);
 	nftnl_rule_add_expr(ctx->nlr, nle);
 }
-- 
2.1.4

