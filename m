From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf-next 07/11] netfilter: nft_quota: dump consumed quota
Date: Mon, 28 Nov 2016 01:01:06 +0100
Message-ID: <1480291270-3715-8-git-send-email-pablo@netfilter.org>
References: <1480291270-3715-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40136 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753237AbcK1AB3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 27 Nov 2016 19:01:29 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id F1780D163A
        for <netfilter-devel@vger.kernel.org>; Mon, 28 Nov 2016 01:01:27 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id DF230DA729
        for <netfilter-devel@vger.kernel.org>; Mon, 28 Nov 2016 01:01:27 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E8E1DDA729
        for <netfilter-devel@vger.kernel.org>; Mon, 28 Nov 2016 01:01:25 +0100 (CET)
In-Reply-To: <1480291270-3715-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add a new attribute NFTA_QUOTA_CONSUMED that displays the amount of
quota that has been already consumed. This allows us to restore the
internal state of the quota object between reboots as well as to monitor
how wasted it is.

This patch changes the logic to account for the consumed bytes, instead
of the bytes that remain to be consumed.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/uapi/linux/netfilter/nf_tables.h | 2 ++
 net/netfilter/nft_quota.c                | 9 ++++++---
 2 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index c14a82f7ea48..bd80501c5633 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -1020,12 +1020,14 @@ enum nft_quota_flags {
  *
  * @NFTA_QUOTA_BYTES: quota in bytes (NLA_U16)
  * @NFTA_QUOTA_FLAGS: flags (NLA_U32)
+ * @NFTA_QUOTA_CONSUMED: quota already consumed in bytes (NLA_U64)
  */
 enum nft_quota_attributes {
 	NFTA_QUOTA_UNSPEC,
 	NFTA_QUOTA_BYTES,
 	NFTA_QUOTA_FLAGS,
 	NFTA_QUOTA_PAD,
+	NFTA_QUOTA_CONSUMED,
 	__NFTA_QUOTA_MAX
 };
 #define NFTA_QUOTA_MAX		(__NFTA_QUOTA_MAX - 1)
diff --git a/net/netfilter/nft_quota.c b/net/netfilter/nft_quota.c
index 1c5f106b4595..ef2f2ae885aa 100644
--- a/net/netfilter/nft_quota.c
+++ b/net/netfilter/nft_quota.c
@@ -18,13 +18,13 @@
 struct nft_quota {
 	u64		quota;
 	bool		invert;
-	atomic64_t	remain;
+	atomic64_t	consumed;
 };
 
 static inline bool nft_overquota(struct nft_quota *priv,
 				 const struct nft_pktinfo *pkt)
 {
-	return atomic64_sub_return(pkt->skb->len, &priv->remain) < 0;
+	return atomic64_add_return(pkt->skb->len, &priv->consumed) > priv->quota;
 }
 
 static inline void nft_quota_do_eval(struct nft_quota *priv,
@@ -70,7 +70,7 @@ static int nft_quota_obj_init(const struct nlattr * const tb[], void *obj)
 
 	priv->quota = quota;
 	priv->invert = (flags & NFT_QUOTA_F_INV) ? true : false;
-	atomic64_set(&priv->remain, quota);
+	atomic64_set(&priv->consumed, 0);
 
 	return 0;
 }
@@ -88,6 +88,9 @@ static int nft_quota_obj_dump(struct sk_buff *skb, void *obj, bool reset)
 
 	if (nla_put_be64(skb, NFTA_QUOTA_BYTES, cpu_to_be64(priv->quota),
 			 NFTA_QUOTA_PAD) ||
+	    nla_put_be64(skb, NFTA_QUOTA_CONSUMED,
+			 cpu_to_be64(atomic64_read(&priv->consumed)),
+			 NFTA_QUOTA_PAD) ||
 	    nla_put_be32(skb, NFTA_QUOTA_FLAGS, htonl(flags)))
 		goto nla_put_failure;
 	return 0;
-- 
2.1.4

