From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 4/5] netfilter: nf_tables: add flag to indicate set contains expressions
Date: Sat, 11 Apr 2015 10:46:41 +0100
Message-ID: <1428745602-31799-5-git-send-email-kaber@trash.net>
References: <1428745602-31799-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:49257 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932218AbbDKJqs (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 11 Apr 2015 05:46:48 -0400
In-Reply-To: <1428745602-31799-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add a set flag to indicate that the set is used as a state table and
contains expressions for evaluation. This operation is mutually
exclusive with the mapping operation, so sets specifying both are
rejected. The lookup expression also rejects binding to state tables
since it only deals with loopup and map operations.

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 include/uapi/linux/netfilter/nf_tables.h | 2 ++
 net/netfilter/nf_tables_api.c            | 8 ++++++--
 net/netfilter/nft_lookup.c               | 3 +++
 3 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index f9c5af2..4894238 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -238,6 +238,7 @@ enum nft_rule_compat_attributes {
  * @NFT_SET_INTERVAL: set contains intervals
  * @NFT_SET_MAP: set is used as a dictionary
  * @NFT_SET_TIMEOUT: set uses timeouts
+ * @NFT_SET_EVAL: set contains expressions for evaluation
  */
 enum nft_set_flags {
 	NFT_SET_ANONYMOUS		= 0x1,
@@ -245,6 +246,7 @@ enum nft_set_flags {
 	NFT_SET_INTERVAL		= 0x4,
 	NFT_SET_MAP			= 0x8,
 	NFT_SET_TIMEOUT			= 0x10,
+	NFT_SET_EVAL			= 0x20,
 };
 
 /**
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 8830811..78af83b 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2661,9 +2661,13 @@ static int nf_tables_newset(struct sock *nlsk, struct sk_buff *skb,
 	if (nla[NFTA_SET_FLAGS] != NULL) {
 		flags = ntohl(nla_get_be32(nla[NFTA_SET_FLAGS]));
 		if (flags & ~(NFT_SET_ANONYMOUS | NFT_SET_CONSTANT |
-			      NFT_SET_INTERVAL | NFT_SET_MAP |
-			      NFT_SET_TIMEOUT))
+			      NFT_SET_INTERVAL | NFT_SET_TIMEOUT |
+			      NFT_SET_MAP | NFT_SET_EVAL))
 			return -EINVAL;
+		/* Only one of both operations is supported */
+		if ((flags & (NFT_SET_MAP | NFT_SET_EVAL)) ==
+			     (NFT_SET_MAP | NFT_SET_EVAL))
+			return -EOPNOTSUPP;
 	}
 
 	dtype = 0;
diff --git a/net/netfilter/nft_lookup.c b/net/netfilter/nft_lookup.c
index ba14662..b3c31ef 100644
--- a/net/netfilter/nft_lookup.c
+++ b/net/netfilter/nft_lookup.c
@@ -71,6 +71,9 @@ static int nft_lookup_init(const struct nft_ctx *ctx,
 			return PTR_ERR(set);
 	}
 
+	if (set->flags & NFT_SET_EVAL)
+		return -EOPNOTSUPP;
+
 	priv->sreg = nft_parse_register(tb[NFTA_LOOKUP_SREG]);
 	err = nft_validate_register_load(priv->sreg, set->klen);
 	if (err < 0)
-- 
2.1.0

