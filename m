From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf 3/3] netfilter: nft_nat: dump attributes if they are set
Date: Thu, 16 Oct 2014 14:57:18 +0200
Message-ID: <1413464238-4071-3-git-send-email-pablo@netfilter.org>
References: <1413464238-4071-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58552 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751957AbaJPM4H (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 16 Oct 2014 08:56:07 -0400
In-Reply-To: <1413464238-4071-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Dump NFTA_NAT_REG_ADDR_MIN if this is non-zero. Same thing with
NFTA_NAT_REG_PROTO_MIN.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_nat.c |   24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/net/netfilter/nft_nat.c b/net/netfilter/nft_nat.c
index eb1afe0..a7c2ffe 100644
--- a/net/netfilter/nft_nat.c
+++ b/net/netfilter/nft_nat.c
@@ -191,20 +191,20 @@ static int nft_nat_dump(struct sk_buff *skb, const struct nft_expr *expr)
 
 	if (nla_put_be32(skb, NFTA_NAT_FAMILY, htonl(priv->family)))
 		goto nla_put_failure;
-	if (nla_put_be32(skb,
-			 NFTA_NAT_REG_ADDR_MIN, htonl(priv->sreg_addr_min)))
+
+	if (priv->sreg_addr_min != 0 &&
+	    nla_put_be32(skb, NFTA_NAT_REG_ADDR_MIN,
+			 htonl(priv->sreg_addr_min)) ||
+	    nla_put_be32(skb, NFTA_NAT_REG_ADDR_MAX,
+			 htonl(priv->sreg_addr_max)))
 		goto nla_put_failure;
-	if (nla_put_be32(skb,
-			 NFTA_NAT_REG_ADDR_MAX, htonl(priv->sreg_addr_max)))
+
+	if (priv->sreg_proto_min != 0 &&
+	    nla_put_be32(skb, NFTA_NAT_REG_PROTO_MIN,
+			 htonl(priv->sreg_proto_min)) ||
+	    nla_put_be32(skb, NFTA_NAT_REG_PROTO_MAX,
+			 htonl(priv->sreg_proto_max)))
 		goto nla_put_failure;
-	if (priv->sreg_proto_min) {
-		if (nla_put_be32(skb, NFTA_NAT_REG_PROTO_MIN,
-				 htonl(priv->sreg_proto_min)))
-			goto nla_put_failure;
-		if (nla_put_be32(skb, NFTA_NAT_REG_PROTO_MAX,
-				 htonl(priv->sreg_proto_max)))
-			goto nla_put_failure;
-	}
 
 	if (priv->flags != 0) {
 		if (nla_put_be32(skb, NFTA_NAT_FLAGS, htonl(priv->flags)))
-- 
1.7.10.4

