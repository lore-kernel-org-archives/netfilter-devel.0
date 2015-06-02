From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 1/6 nft] netlink_delinearize: pass ctx pointer to stmt_reject_postprocess()
Date: Tue,  2 Jun 2015 19:03:02 +0200
Message-ID: <1433264587-29705-2-git-send-email-pablo@netfilter.org>
References: <1433264587-29705-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49734 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759612AbbFBQ6B (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 2 Jun 2015 12:58:01 -0400
In-Reply-To: <1433264587-29705-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Instead of a copy of the context variable.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/netlink_delinearize.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index b041579..26a8c85 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -1082,18 +1082,18 @@ static void expr_postprocess(struct rule_pp_ctx *ctx,
 	}
 }
 
-static void stmt_reject_postprocess(struct rule_pp_ctx rctx, struct stmt *stmt)
+static void stmt_reject_postprocess(struct rule_pp_ctx *rctx, struct stmt *stmt)
 {
 	const struct proto_desc *desc, *base;
 	int protocol;
 
-	switch (rctx.pctx.family) {
+	switch (rctx->pctx.family) {
 	case NFPROTO_IPV4:
-		stmt->reject.family = rctx.pctx.family;
+		stmt->reject.family = rctx->pctx.family;
 		stmt->reject.expr->dtype = &icmp_code_type;
 		break;
 	case NFPROTO_IPV6:
-		stmt->reject.family = rctx.pctx.family;
+		stmt->reject.family = rctx->pctx.family;
 		stmt->reject.expr->dtype = &icmpv6_code_type;
 		break;
 	case NFPROTO_INET:
@@ -1101,8 +1101,8 @@ static void stmt_reject_postprocess(struct rule_pp_ctx rctx, struct stmt *stmt)
 			stmt->reject.expr->dtype = &icmpx_code_type;
 			break;
 		}
-		base = rctx.pctx.protocol[PROTO_BASE_LL_HDR].desc;
-		desc = rctx.pctx.protocol[PROTO_BASE_NETWORK_HDR].desc;
+		base = rctx->pctx.protocol[PROTO_BASE_LL_HDR].desc;
+		desc = rctx->pctx.protocol[PROTO_BASE_NETWORK_HDR].desc;
 		protocol = proto_find_num(base, desc);
 		switch (protocol) {
 		case NFPROTO_IPV4:
@@ -1119,8 +1119,8 @@ static void stmt_reject_postprocess(struct rule_pp_ctx rctx, struct stmt *stmt)
 			stmt->reject.expr->dtype = &icmpx_code_type;
 			break;
 		}
-		base = rctx.pctx.protocol[PROTO_BASE_LL_HDR].desc;
-		desc = rctx.pctx.protocol[PROTO_BASE_NETWORK_HDR].desc;
+		base = rctx->pctx.protocol[PROTO_BASE_LL_HDR].desc;
+		desc = rctx->pctx.protocol[PROTO_BASE_NETWORK_HDR].desc;
 		protocol = proto_find_num(base, desc);
 		switch (protocol) {
 		case __constant_htons(ETH_P_IP):
@@ -1173,7 +1173,7 @@ static void rule_parse_postprocess(struct netlink_parse_ctx *ctx, struct rule *r
 						 &stmt->redir.proto);
 			break;
 		case STMT_REJECT:
-			stmt_reject_postprocess(rctx, stmt);
+			stmt_reject_postprocess(&rctx, stmt);
 			break;
 		case STMT_SET:
 			expr_postprocess(&rctx, stmt, &stmt->set.key);
-- 
1.7.10.4

