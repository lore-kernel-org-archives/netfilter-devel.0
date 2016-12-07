From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf-next] netfilter: nft_quota: allow to restore consumed quota
Date: Wed,  7 Dec 2016 17:06:26 +0100
Message-ID: <1481126786-1328-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48806 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753033AbcLGQGk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 7 Dec 2016 11:06:40 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id DFE9E80B03
        for <netfilter-devel@vger.kernel.org>; Wed,  7 Dec 2016 17:06:37 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id CE660DA729
        for <netfilter-devel@vger.kernel.org>; Wed,  7 Dec 2016 17:06:37 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2FB5FDA729
        for <netfilter-devel@vger.kernel.org>; Wed,  7 Dec 2016 17:06:35 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Allow to restore consumed quota, this is useful to restore the quota
state across reboots.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
N.B: Just this one more patch on the current pile on nf-next, and I'll be
preparing the pull request for David.

 net/netfilter/nft_quota.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nft_quota.c b/net/netfilter/nft_quota.c
index 7f27ebdce7ab..bd6efc53f26d 100644
--- a/net/netfilter/nft_quota.c
+++ b/net/netfilter/nft_quota.c
@@ -43,6 +43,7 @@ static inline void nft_quota_do_eval(struct nft_quota *priv,
 static const struct nla_policy nft_quota_policy[NFTA_QUOTA_MAX + 1] = {
 	[NFTA_QUOTA_BYTES]	= { .type = NLA_U64 },
 	[NFTA_QUOTA_FLAGS]	= { .type = NLA_U32 },
+	[NFTA_QUOTA_CONSUMED]	= { .type = NLA_U64 },
 };
 
 #define NFT_QUOTA_DEPLETED_BIT	1	/* From NFT_QUOTA_F_DEPLETED. */
@@ -68,7 +69,7 @@ static int nft_quota_do_init(const struct nlattr * const tb[],
 			     struct nft_quota *priv)
 {
 	unsigned long flags = 0;
-	u64 quota;
+	u64 quota, consumed = 0;
 
 	if (!tb[NFTA_QUOTA_BYTES])
 		return -EINVAL;
@@ -77,6 +78,12 @@ static int nft_quota_do_init(const struct nlattr * const tb[],
 	if (quota > S64_MAX)
 		return -EOVERFLOW;
 
+	if (tb[NFTA_QUOTA_CONSUMED]) {
+		consumed = be64_to_cpu(nla_get_be64(tb[NFTA_QUOTA_CONSUMED]));
+		if (consumed > quota)
+			return -EINVAL;
+	}
+
 	if (tb[NFTA_QUOTA_FLAGS]) {
 		flags = ntohl(nla_get_be32(tb[NFTA_QUOTA_FLAGS]));
 		if (flags & ~NFT_QUOTA_F_INV)
@@ -87,7 +94,7 @@ static int nft_quota_do_init(const struct nlattr * const tb[],
 
 	priv->quota = quota;
 	priv->flags = flags;
-	atomic64_set(&priv->consumed, 0);
+	atomic64_set(&priv->consumed, consumed);
 
 	return 0;
 }
-- 
2.1.4

