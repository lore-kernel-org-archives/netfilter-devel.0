From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: [nftables-kernel PATCH 5/7] netfilter: nf_tables: Add a meta key to get the device address length
Date: Mon, 14 Oct 2013 15:46:54 +0300
Message-ID: <1381754816-28472-6-git-send-email-tomasz.bursztyka@linux.intel.com>
References: <1381754816-28472-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Cc: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:52811 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756064Ab3JNMrI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Oct 2013 08:47:08 -0400
In-Reply-To: <1381754816-28472-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This will be useful to determine at runtime the position of some data in
the packet.

Signed-off-by: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
---
 include/uapi/linux/netfilter/nf_tables.h |  2 ++
 net/netfilter/nft_meta.c                 | 12 +++++++++++-
 2 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 81eec3b..65f41ff 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -526,6 +526,7 @@ enum nft_exthdr_attributes {
  * @NFT_META_OIFNAME: packet output interface name (dev->name)
  * @NFT_META_IIFTYPE: packet input interface type (dev->type)
  * @NFT_META_OIFTYPE: packet output interface type (dev->type)
+ * @NFT_META_DEV_ADDRLEN: packet interface address length (dev->addr_len)
  * @NFT_META_SKUID: originating socket UID (fsuid)
  * @NFT_META_SKGID: originating socket GID (fsgid)
  * @NFT_META_NFTRACE: packet nftrace bit
@@ -543,6 +544,7 @@ enum nft_meta_keys {
 	NFT_META_OIFNAME,
 	NFT_META_IIFTYPE,
 	NFT_META_OIFTYPE,
+	NFT_META_DEV_ADDRLEN,
 	NFT_META_SKUID,
 	NFT_META_SKGID,
 	NFT_META_NFTRACE,
diff --git a/net/netfilter/nft_meta.c b/net/netfilter/nft_meta.c
index 8c28220..8116535 100644
--- a/net/netfilter/nft_meta.c
+++ b/net/netfilter/nft_meta.c
@@ -30,7 +30,7 @@ static void nft_meta_eval(const struct nft_expr *expr,
 {
 	const struct nft_meta *priv = nft_expr_priv(expr);
 	const struct sk_buff *skb = pkt->skb;
-	const struct net_device *in = pkt->in, *out = pkt->out;
+	const struct net_device *in = pkt->in, *out = pkt->out, *dev;
 	struct nft_data *dest = &data[priv->dreg];
 
 	switch (priv->key) {
@@ -76,6 +76,15 @@ static void nft_meta_eval(const struct nft_expr *expr,
 			goto err;
 		*(u16 *)dest->data = out->type;
 		break;
+	case NFT_META_DEV_ADDRLEN:
+		if (out != NULL)
+			dev = out;
+		else if (in != NULL)
+			dev = out;
+		else
+			goto err;
+		*(u8 *)dest->data = dev->addr_len;
+		break;
 	case NFT_META_SKUID:
 		if (skb->sk == NULL || skb->sk->sk_state == TCP_TIME_WAIT)
 			goto err;
@@ -159,6 +168,7 @@ static int nft_meta_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
 	case NFT_META_OIFNAME:
 	case NFT_META_IIFTYPE:
 	case NFT_META_OIFTYPE:
+	case NFT_META_DEV_ADDRLEN:
 	case NFT_META_SKUID:
 	case NFT_META_SKGID:
 #ifdef CONFIG_NET_CLS_ROUTE
-- 
1.8.3.2

