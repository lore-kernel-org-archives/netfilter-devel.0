From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [nf_tables 1/3] netfilter: nf_tables: store and dump sets mechanism options
Date: Thu, 18 Sep 2014 20:18:18 +0200
Message-ID: <1411064300-4433-1-git-send-email-arturo.borrero.glez@gmail.com>
Cc: pablo@netfilter.org, kaber@trash.net,
	Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:55924 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932442AbaIRSS7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 18 Sep 2014 14:18:59 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The sets mechanism options was not being stored anywhere.

We want to know in which cases the user explicitly set the mechanism
options. In that case, we also want to dump back the info.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 include/net/netfilter/nf_tables.h |   12 +++++++++++
 net/netfilter/nf_tables_api.c     |   42 +++++++++++++++++++++++++++----------
 2 files changed, 43 insertions(+), 11 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index c4d8619..a9c6387 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -231,6 +231,14 @@ struct nft_set_ops {
 int nft_register_set(struct nft_set_ops *ops);
 void nft_unregister_set(struct nft_set_ops *ops);
 
+/* internal flags to know which attributes were originally set
+ * from userspace.
+ */
+enum nft_set_attr {
+	NFT_SET_ATTR_POLICY	= 0x1,
+	NFT_SET_ATTR_DESC_SIZE	= 0x2,
+};
+
 /**
  * 	struct nft_set - nf_tables set instance
  *
@@ -241,6 +249,8 @@ void nft_unregister_set(struct nft_set_ops *ops);
  * 	@dtype: data type (verdict or numeric type defined by userspace)
  * 	@size: maximum set size
  * 	@nelems: number of elements
+ *	@attr_flags: (enum nft_set_flags)
+ *	@policy: (enum nft_set_policies)
  * 	@ops: set ops
  * 	@flags: set flags
  * 	@klen: key length
@@ -255,6 +265,8 @@ struct nft_set {
 	u32				dtype;
 	u32				size;
 	u32				nelems;
+	u16				attr_flags;
+	u32				policy;
 	/* runtime data below here */
 	const struct nft_set_ops	*ops ____cacheline_aligned;
 	u16				flags;
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 8237460..d1c3f3e 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2342,13 +2342,24 @@ static int nf_tables_fill_set(struct sk_buff *skb, const struct nft_ctx *ctx,
 			goto nla_put_failure;
 	}
 
-	desc = nla_nest_start(skb, NFTA_SET_DESC);
-	if (desc == NULL)
-		goto nla_put_failure;
-	if (set->size &&
-	    nla_put_be32(skb, NFTA_SET_DESC_SIZE, htonl(set->size)))
-		goto nla_put_failure;
-	nla_nest_end(skb, desc);
+	/* dump policy and desc info only if they were explicitly set */
+	if (set->attr_flags & (1 << NFT_SET_ATTR_POLICY)) {
+		if (nla_put_be32(skb, NFTA_SET_POLICY, htonl(set->policy)))
+			goto nla_put_failure;
+	}
+
+	if (set->attr_flags & (1 << NFT_SET_ATTR_DESC_SIZE)) {
+		desc = nla_nest_start(skb, NFTA_SET_DESC);
+		if (desc == NULL)
+			goto nla_put_failure;
+
+		if (set->size &&
+		    nla_put_be32(skb, NFTA_SET_DESC_SIZE, htonl(set->size))) {
+			goto nla_put_failure;
+		}
+
+		nla_nest_end(skb, desc);
+	}
 
 	return nlmsg_end(skb, nlh);
 
@@ -2519,7 +2530,8 @@ err:
 
 static int nf_tables_set_desc_parse(const struct nft_ctx *ctx,
 				    struct nft_set_desc *desc,
-				    const struct nlattr *nla)
+				    const struct nlattr *nla,
+				    u16 *attr_flags)
 {
 	struct nlattr *da[NFTA_SET_DESC_MAX + 1];
 	int err;
@@ -2528,8 +2540,10 @@ static int nf_tables_set_desc_parse(const struct nft_ctx *ctx,
 	if (err < 0)
 		return err;
 
-	if (da[NFTA_SET_DESC_SIZE] != NULL)
+	if (da[NFTA_SET_DESC_SIZE] != NULL) {
 		desc->size = ntohl(nla_get_be32(da[NFTA_SET_DESC_SIZE]));
+		*attr_flags |= (1 << NFT_SET_ATTR_DESC_SIZE);
+	}
 
 	return 0;
 }
@@ -2549,6 +2563,7 @@ static int nf_tables_newset(struct sock *nlsk, struct sk_buff *skb,
 	unsigned int size;
 	bool create;
 	u32 ktype, dtype, flags, policy;
+	u16 attr_flags = 0;
 	struct nft_set_desc desc;
 	int err;
 
@@ -2602,11 +2617,14 @@ static int nf_tables_newset(struct sock *nlsk, struct sk_buff *skb,
 		return -EINVAL;
 
 	policy = NFT_SET_POL_PERFORMANCE;
-	if (nla[NFTA_SET_POLICY] != NULL)
+	if (nla[NFTA_SET_POLICY] != NULL) {
 		policy = ntohl(nla_get_be32(nla[NFTA_SET_POLICY]));
+		attr_flags |= (1 << NFT_SET_ATTR_POLICY);
+	}
 
 	if (nla[NFTA_SET_DESC] != NULL) {
-		err = nf_tables_set_desc_parse(&ctx, &desc, nla[NFTA_SET_DESC]);
+		err = nf_tables_set_desc_parse(&ctx, &desc, nla[NFTA_SET_DESC],
+					       &attr_flags);
 		if (err < 0)
 			return err;
 	}
@@ -2667,6 +2685,8 @@ static int nf_tables_newset(struct sock *nlsk, struct sk_buff *skb,
 	set->dlen  = desc.dlen;
 	set->flags = flags;
 	set->size  = desc.size;
+	set->attr_flags	= attr_flags;
+	set->policy	= policy;
 
 	err = ops->init(set, &desc, nla);
 	if (err < 0)
-- 
1.7.10.4

