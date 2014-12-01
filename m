From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 1/5] netlink_delinearize: clone on netlink_get_register(), release previous on _set()
Date: Mon,  1 Dec 2014 12:45:49 +0100
Message-ID: <1417434354-5782-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:41604 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753081AbaLALnn (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 1 Dec 2014 06:43:43 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

If we add this rule:

  nft add rule filter input meta length 33-55

the listing shows:

  meta length >= 33 meta length <= 754974720

The two meta statements share the same left-hand side, thus, only the
first one is converted from network byte order to host byte order.

Update netlink_get_register() to return a clone so each left-hand side
has its own left-hand side.

Moreover, release the existing register before overriding it with fresh
expressions in netlink_set_register().

Thefore, if you manipulate a register from any of the existing parse
functions, you have to re-set it again to place fresh modified clone.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/netlink_delinearize.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
index 1be409b..c809bb6 100644
--- a/src/netlink_delinearize.c
+++ b/src/netlink_delinearize.c
@@ -57,6 +57,9 @@ static void netlink_set_register(struct netlink_parse_ctx *ctx,
 		return;
 	}
 
+	if (ctx->registers[reg] != NULL)
+		expr_free(ctx->registers[reg]);
+
 	ctx->registers[reg] = expr;
 }
 
@@ -72,7 +75,15 @@ static struct expr *netlink_get_register(struct netlink_parse_ctx *ctx,
 	}
 
 	expr = ctx->registers[reg];
-	return expr;
+	return expr_clone(expr);
+}
+
+static void netlink_release_registers(struct netlink_parse_ctx *ctx)
+{
+	int i;
+
+	for (i = 0; i <= NFT_REG_MAX; i++)
+		expr_free(ctx->registers[i]);
 }
 
 static void netlink_parse_immediate(struct netlink_parse_ctx *ctx,
@@ -1109,5 +1120,6 @@ struct rule *netlink_delinearize_rule(struct netlink_ctx *ctx,
 	nft_rule_expr_foreach((struct nft_rule *)nlr, netlink_parse_expr, pctx);
 
 	rule_parse_postprocess(pctx, pctx->rule);
+	netlink_release_registers(pctx);
 	return pctx->rule;
 }
-- 
1.7.10.4

