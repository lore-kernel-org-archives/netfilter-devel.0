From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH] netfilter: nft_nat: don't dump port information if unset
Date: Fri, 13 Jun 2014 13:45:38 +0200
Message-ID: <1402659938-22802-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49489 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751082AbaFMLpu (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 13 Jun 2014 07:45:50 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Don't include port information attributes if they are unset.

Reported-by: Ana Rey <anarey@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_nat.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/nft_nat.c b/net/netfilter/nft_nat.c
index a0195d2..79ff58c 100644
--- a/net/netfilter/nft_nat.c
+++ b/net/netfilter/nft_nat.c
@@ -175,12 +175,14 @@ static int nft_nat_dump(struct sk_buff *skb, const struct nft_expr *expr)
 	if (nla_put_be32(skb,
 			 NFTA_NAT_REG_ADDR_MAX, htonl(priv->sreg_addr_max)))
 		goto nla_put_failure;
-	if (nla_put_be32(skb,
-			 NFTA_NAT_REG_PROTO_MIN, htonl(priv->sreg_proto_min)))
-		goto nla_put_failure;
-	if (nla_put_be32(skb,
-			 NFTA_NAT_REG_PROTO_MAX, htonl(priv->sreg_proto_max)))
-		goto nla_put_failure;
+	if (priv->sreg_proto_min) {
+		if (nla_put_be32(skb, NFTA_NAT_REG_PROTO_MIN,
+				 htonl(priv->sreg_proto_min)))
+			goto nla_put_failure;
+		if (nla_put_be32(skb, NFTA_NAT_REG_PROTO_MAX,
+				 htonl(priv->sreg_proto_max)))
+			goto nla_put_failure;
+	}
 	return 0;
 
 nla_put_failure:
-- 
1.7.10.4

