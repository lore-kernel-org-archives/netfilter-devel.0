From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [nftables PATCH] netfilter: nft_ct: fix unconditional dump of 'dir'
	attr
Date: Fri, 17 Jan 2014 02:28:45 +0100
Message-ID: <20140117012845.2934.34608.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:48105 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751552AbaAQB2z (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 16 Jan 2014 20:28:55 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

We want to make sure that the information that we get from the kernel can be
reinjected without troubles.

The kernel shouldn't return an attribute that is not required, or even
prohibited.

Dump unconditionally NFTA_CT_DIRECTION could lead an application in
userspace to interpret that the attribute was originally set, while it was not.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 net/netfilter/nft_ct.c |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
index 917052e..feaf0f3 100644
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -311,8 +311,19 @@ static int nft_ct_get_dump(struct sk_buff *skb, const struct nft_expr *expr)
 		goto nla_put_failure;
 	if (nla_put_be32(skb, NFTA_CT_KEY, htonl(priv->key)))
 		goto nla_put_failure;
-	if (nla_put_u8(skb, NFTA_CT_DIRECTION, priv->dir))
-		goto nla_put_failure;
+
+	switch (priv->key) {
+	case NFT_CT_PROTOCOL:
+	case NFT_CT_SRC:
+	case NFT_CT_DST:
+	case NFT_CT_PROTO_SRC:
+	case NFT_CT_PROTO_DST:
+		if (nla_put_u8(skb, NFTA_CT_DIRECTION, priv->dir))
+			goto nla_put_failure;
+	default:
+		break;
+	}
+
 	return 0;
 
 nla_put_failure:

