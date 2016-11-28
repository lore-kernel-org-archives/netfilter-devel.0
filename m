From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf-next 08/11] netfilter: nft_quota: add depleted flag for objects
Date: Mon, 28 Nov 2016 01:01:07 +0100
Message-ID: <1480291270-3715-9-git-send-email-pablo@netfilter.org>
References: <1480291270-3715-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40142 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753957AbcK1ABa (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 27 Nov 2016 19:01:30 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id BE5B6D1637
        for <netfilter-devel@vger.kernel.org>; Mon, 28 Nov 2016 01:01:28 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id AF530524C0
        for <netfilter-devel@vger.kernel.org>; Mon, 28 Nov 2016 01:01:28 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B39A0524C0
        for <netfilter-devel@vger.kernel.org>; Mon, 28 Nov 2016 01:01:26 +0100 (CET)
In-Reply-To: <1480291270-3715-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Notify on depleted quota objects. The NFT_QUOTA_F_DEPLETED flag
indicates we have reached overquota.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/uapi/linux/netfilter/nf_tables.h |  1 +
 net/netfilter/nft_quota.c                | 33 ++++++++++++++++++++++++--------
 2 files changed, 26 insertions(+), 8 deletions(-)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index bd80501c5633..cf2130457d00 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -1013,6 +1013,7 @@ enum nft_queue_attributes {
 
 enum nft_quota_flags {
 	NFT_QUOTA_F_INV		= (1 << 0),
+	NFT_QUOTA_F_DEPLETED	= (1 << 1),
 };
 
 /**
diff --git a/net/netfilter/nft_quota.c b/net/netfilter/nft_quota.c
index ef2f2ae885aa..bbc5aa93b3cc 100644
--- a/net/netfilter/nft_quota.c
+++ b/net/netfilter/nft_quota.c
@@ -17,8 +17,8 @@
 
 struct nft_quota {
 	u64		quota;
-	bool		invert;
 	atomic64_t	consumed;
+	unsigned long	flags;
 };
 
 static inline bool nft_overquota(struct nft_quota *priv,
@@ -27,11 +27,16 @@ static inline bool nft_overquota(struct nft_quota *priv,
 	return atomic64_add_return(pkt->skb->len, &priv->consumed) > priv->quota;
 }
 
+static inline bool nft_quota_invert(struct nft_quota *priv)
+{
+	return priv->flags & NFT_QUOTA_F_INV;
+}
+
 static inline void nft_quota_do_eval(struct nft_quota *priv,
 				     struct nft_regs *regs,
 				     const struct nft_pktinfo *pkt)
 {
-	if (nft_overquota(priv, pkt) ^ priv->invert)
+	if (nft_overquota(priv, pkt) ^ nft_quota_invert(priv))
 		regs->verdict.code = NFT_BREAK;
 }
 
@@ -46,13 +51,20 @@ static void nft_quota_obj_eval(void *obj,
 {
 	struct nft_quota *priv = obj;
 
-	nft_quota_do_eval(priv, regs, pkt);
+	if (nft_overquota(priv, pkt) ^ nft_quota_invert(priv)) {
+		if (test_and_set_bit(NFT_QUOTA_F_DEPLETED, &priv->flags)) {
+			nft_obj_notify(nft_net(pkt), nft_chain(pkt)->table,
+				       obj, 0, 0, NFT_MSG_NEWOBJ,
+				       nft_pf(pkt), 0, GFP_ATOMIC);
+		}
+		regs->verdict.code = NFT_BREAK;
+	}
 }
 
 static int nft_quota_obj_init(const struct nlattr * const tb[], void *obj)
 {
 	struct nft_quota *priv = obj;
-	u32 flags = 0;
+	unsigned long flags = 0;
 	u64 quota;
 
 	if (!tb[NFTA_QUOTA_BYTES])
@@ -66,10 +78,12 @@ static int nft_quota_obj_init(const struct nlattr * const tb[], void *obj)
 		flags = ntohl(nla_get_be32(tb[NFTA_QUOTA_FLAGS]));
 		if (flags & ~NFT_QUOTA_F_INV)
 			return -EINVAL;
+		if (flags & NFT_QUOTA_F_DEPLETED)
+			return -EOPNOTSUPP;
 	}
 
 	priv->quota = quota;
-	priv->invert = (flags & NFT_QUOTA_F_INV) ? true : false;
+	priv->flags = flags;
 	atomic64_set(&priv->consumed, 0);
 
 	return 0;
@@ -78,13 +92,16 @@ static int nft_quota_obj_init(const struct nlattr * const tb[], void *obj)
 static int nft_quota_obj_dump(struct sk_buff *skb, void *obj, bool reset)
 {
 	struct nft_quota *priv = obj;
-	u32 flags = priv->invert ? NFT_QUOTA_F_INV : 0;
+	unsigned long flags = priv->flags;
 	u64 consumed;
 
-	if (reset)
+	if (reset) {
 		consumed = atomic64_xchg(&priv->consumed, 0);
-	else
+		if (test_and_clear_bit(NFT_QUOTA_F_DEPLETED, &priv->flags))
+			flags |= NFT_QUOTA_F_DEPLETED;
+	} else {
 		consumed = atomic64_read(&priv->consumed);
+	}
 
 	if (nla_put_be64(skb, NFTA_QUOTA_BYTES, cpu_to_be64(priv->quota),
 			 NFTA_QUOTA_PAD) ||
-- 
2.1.4

