From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH v2,nf-next 07/11] netfilter: nft_quota: dump consumed quota
Date: Fri,  2 Dec 2016 19:08:37 +0100
Message-ID: <1480702121-1782-8-git-send-email-pablo@netfilter.org>
References: <1480702121-1782-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47722 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751438AbcLBSJ0 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 2 Dec 2016 13:09:26 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 5F3EDD163D
        for <netfilter-devel@vger.kernel.org>; Fri,  2 Dec 2016 19:08:58 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4E76FDA399
        for <netfilter-devel@vger.kernel.org>; Fri,  2 Dec 2016 19:08:58 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 50EA8DA399
        for <netfilter-devel@vger.kernel.org>; Fri,  2 Dec 2016 19:08:56 +0100 (CET)
In-Reply-To: <1480702121-1782-1-git-send-email-pablo@netfilter.org>
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
v2: Fix dump logic, nft_quota_do_dump() should include consumed bytes
    larger than the total quota.

 include/uapi/linux/netfilter/nf_tables.h |  2 ++
 net/netfilter/nft_quota.c                | 20 +++++++++++++++-----
 2 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index e1b11aa777f2..d4b0b652e76f 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -984,12 +984,14 @@ enum nft_quota_flags {
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
index 6fcd41b1a251..e98c0c70f40a 100644
--- a/net/netfilter/nft_quota.c
+++ b/net/netfilter/nft_quota.c
@@ -18,20 +18,20 @@
 struct nft_quota {
 	u64		quota;
 	bool		invert;
-	atomic64_t	remain;
+	atomic64_t	consumed;
 };
 
 static inline bool nft_overquota(struct nft_quota *priv,
-				 const struct nft_pktinfo *pkt)
+				 const struct sk_buff *skb)
 {
-	return atomic64_sub_return(pkt->skb->len, &priv->remain) < 0;
+	return atomic64_add_return(skb->len, &priv->consumed) >= priv->quota;
 }
 
 static inline void nft_quota_do_eval(struct nft_quota *priv,
 				     struct nft_regs *regs,
 				     const struct nft_pktinfo *pkt)
 {
-	if (nft_overquota(priv, pkt) ^ priv->invert)
+	if (nft_overquota(priv, pkt->skb) ^ priv->invert)
 		regs->verdict.code = NFT_BREAK;
 }
 
@@ -70,7 +70,7 @@ static int nft_quota_do_init(const struct nlattr * const tb[],
 
 	priv->quota = quota;
 	priv->invert = (flags & NFT_QUOTA_F_INV) ? true : false;
-	atomic64_set(&priv->remain, quota);
+	atomic64_set(&priv->consumed, 0);
 
 	return 0;
 }
@@ -87,9 +87,19 @@ static int nft_quota_do_dump(struct sk_buff *skb, struct nft_quota *priv,
 			     bool reset)
 {
 	u32 flags = priv->invert ? NFT_QUOTA_F_INV : 0;
+	u64 consumed;
+
+	consumed = atomic64_read(&priv->consumed);
+	/* Since we inconditionally increment the quota for each packet that we
+	 * see, don't puzzle userspace with a number going over the quota.
+	 */
+	if (consumed > priv->quota)
+		consumed = priv->quota;
 
 	if (nla_put_be64(skb, NFTA_QUOTA_BYTES, cpu_to_be64(priv->quota),
 			 NFTA_QUOTA_PAD) ||
+	    nla_put_be64(skb, NFTA_QUOTA_CONSUMED, cpu_to_be64(consumed),
+			 NFTA_QUOTA_PAD) ||
 	    nla_put_be32(skb, NFTA_QUOTA_FLAGS, htonl(flags)))
 		goto nla_put_failure;
 	return 0;
-- 
2.1.4

