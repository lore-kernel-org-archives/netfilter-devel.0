From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft] log: netlink_linearize: don't set level if user didn't specify
Date: Thu, 11 Sep 2014 18:45:49 +0200
Message-ID: <1410453949-6647-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33733 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755563AbaIKQpI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 11 Sep 2014 12:45:08 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The kernel will default on LOG_WARNING, to mimic iptables behaviour.

Reported-by: Ana Rey <anarey@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/netlink_linearize.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
index 5eecd79..17375a5 100644
--- a/src/netlink_linearize.c
+++ b/src/netlink_linearize.c
@@ -586,7 +586,10 @@ static void netlink_gen_log_stmt(struct netlink_linearize_ctx *ctx,
 			nft_rule_expr_set_u16(nle, NFT_EXPR_LOG_QTHRESHOLD,
 					      stmt->log.qthreshold);
 	} else {
-		nft_rule_expr_set_u32(nle, NFT_EXPR_LOG_LEVEL, stmt->log.level);
+		if (stmt->log.flags & STMT_LOG_LEVEL) {
+			nft_rule_expr_set_u32(nle, NFT_EXPR_LOG_LEVEL,
+					      stmt->log.level);
+		}
 	}
 	nft_rule_add_expr(ctx->nlr, nle);
 }
-- 
1.7.10.4

