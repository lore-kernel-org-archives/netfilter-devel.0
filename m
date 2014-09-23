From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [nf_tables PATCH 1/2 v2] netfilter: nf_tables: store and dump sets policy
Date: Tue, 23 Sep 2014 13:30:41 +0200
Message-ID: <1411471842-4854-1-git-send-email-arturo.borrero.glez@gmail.com>
Cc: pablo@netfilter.org, kaber@trash.net,
	Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp4.cica.es ([150.214.5.182]:38837 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752162AbaIWLap (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 23 Sep 2014 07:30:45 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

We want to know in which cases the user explicitly set the policy
options. In that case, we also want to dump back the info.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
v2: address comments by Patrick. Only dump policy if not the default.
    Also, set size info if != 0.

 include/net/netfilter/nf_tables.h |    2 ++
 net/netfilter/nf_tables_api.c     |    6 ++++++
 2 files changed, 8 insertions(+)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index c4d8619..9cfa155 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -241,6 +241,7 @@ void nft_unregister_set(struct nft_set_ops *ops);
  * 	@dtype: data type (verdict or numeric type defined by userspace)
  * 	@size: maximum set size
  * 	@nelems: number of elements
+ *	@policy: (enum nft_set_policies)
  * 	@ops: set ops
  * 	@flags: set flags
  * 	@klen: key length
@@ -255,6 +256,7 @@ struct nft_set {
 	u32				dtype;
 	u32				size;
 	u32				nelems;
+	u16				policy;
 	/* runtime data below here */
 	const struct nft_set_ops	*ops ____cacheline_aligned;
 	u16				flags;
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index a476b99..0534c30 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2344,6 +2344,11 @@ static int nf_tables_fill_set(struct sk_buff *skb, const struct nft_ctx *ctx,
 			goto nla_put_failure;
 	}
 
+	if (set->policy != NFT_SET_POL_PERFORMANCE) {
+		if (nla_put_be32(skb, NFTA_SET_POLICY, htonl(set->policy)))
+			goto nla_put_failure;
+	}
+
 	desc = nla_nest_start(skb, NFTA_SET_DESC);
 	if (desc == NULL)
 		goto nla_put_failure;
@@ -2669,6 +2674,7 @@ static int nf_tables_newset(struct sock *nlsk, struct sk_buff *skb,
 	set->dlen  = desc.dlen;
 	set->flags = flags;
 	set->size  = desc.size;
+	set->policy	= policy;
 
 	err = ops->init(set, &desc, nla);
 	if (err < 0)
-- 
1.7.10.4

