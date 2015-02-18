From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH] iptables-compat: unset context flags in netlink delinearize step
Date: Thu, 19 Feb 2015 00:18:38 +0100
Message-ID: <1424301518-20039-1-git-send-email-pablo@netfilter.org>
Cc: arturo.borrero.glez@gmail.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59821 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751872AbbBRXPY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 18 Feb 2015 18:15:24 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Once the data that compare provides have been digested.

-A INPUT -i noexist -p udplite -s 10.10.10.10/32 -d 10.0.0.10/32 -j ACCEPT

shows via iptables-compat-save:

-A INPUT -i

+t -p udplite -s 10.10.10.10/32 -d 10.0.0.10/32 -j ACCEPT

Reported-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 iptables/nft-shared.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/iptables/nft-shared.c b/iptables/nft-shared.c
index 620da3e..1182f56 100644
--- a/iptables/nft-shared.c
+++ b/iptables/nft-shared.c
@@ -434,11 +434,15 @@ void nft_parse_cmp(struct nft_xt_ctx *ctx, struct nft_rule_expr *e)
 	if (ctx->reg && reg != ctx->reg)
 		return;
 
-	if (ctx->flags & NFT_XT_CTX_META)
+	if (ctx->flags & NFT_XT_CTX_META) {
 		ops->parse_meta(ctx, e, data);
+		ctx->flags &= ~NFT_XT_CTX_META;
+	}
 	/* bitwise context is interpreted from payload */
-	if (ctx->flags & NFT_XT_CTX_PAYLOAD)
+	if (ctx->flags & NFT_XT_CTX_PAYLOAD) {
 		ops->parse_payload(ctx, e, data);
+		ctx->flags &= ~NFT_XT_CTX_PAYLOAD;
+	}
 }
 
 void nft_parse_counter(struct nft_rule_expr *e, struct xt_counters *counters)
-- 
1.7.10.4

