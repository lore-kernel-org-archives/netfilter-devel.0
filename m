From: Alvaro Neira Ayuso <alvaroneay@gmail.com>
Subject: [nftables PATCH 1/2] reject: Check the protocol context for indicating the reject type
Date: Wed, 11 Jun 2014 18:49:22 +0200
Message-ID: <1402505362-8355-1-git-send-email-alvaroneay@gmail.com>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-we0-f181.google.com ([74.125.82.181]:49631 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751152AbaFKQtl (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 11 Jun 2014 12:49:41 -0400
Received: by mail-we0-f181.google.com with SMTP id q59so3428wes.40
        for <netfilter-devel@vger.kernel.org>; Wed, 11 Jun 2014 09:49:40 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch check the protocol context and initialize the reject type
considering if the transport protocol is tcp, udp, etc. Before, we
didn't initialize it

Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
---
 src/evaluate.c            |   12 ++++++++++++
 src/netlink_delinearize.c |    1 +
 2 files changed, 13 insertions(+)

diff --git a/src/evaluate.c b/src/evaluate.c
index 2330bbb..c15cd55 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1132,6 +1132,18 @@ static int stmt_evaluate_meta(struct eval_ctx *ctx, struct stmt *stmt)
 
 static int stmt_evaluate_reject(struct eval_ctx *ctx, struct stmt *stmt)
 {
+	struct proto_ctx *pctx = &ctx->pctx;
+	const struct proto_desc *base;
+
+	base = pctx->protocol[PROTO_BASE_TRANSPORT_HDR].desc;
+	if (base == NULL)
+		return -1;
+
+	if (strcmp(base->name, "tcp") == 0)
+		stmt->reject.type = NFT_REJECT_TCP_RST;
+	else
+		stmt->reject.type = NFT_REJECT_ICMP_UNREACH;
+
 	stmt->flags |= STMT_F_TERMINAL;
 	return 0;
 }
diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 5c6ca80..a98c68f 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -456,6 +456,7 @@ static void netlink_parse_reject(struct netlink_parse_ctx *ctx,
 	struct stmt *stmt;
 
 	stmt = reject_stmt_alloc(loc);
+	stmt->reject.type = nft_rule_expr_get_u32(expr, NFT_EXPR_REJECT_TYPE);
 	list_add_tail(&stmt->list, &ctx->rule->stmts);
 }
 
-- 
1.7.10.4

