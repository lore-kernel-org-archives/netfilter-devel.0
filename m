From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 2/3] netfilter: nf_tables: limit maximum number of elements
Date: Sun,  5 Jan 2014 22:18:47 +0100
Message-ID: <1388956728-6754-3-git-send-email-pablo@netfilter.org>
References: <1388956728-6754-1-git-send-email-pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52012 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751894AbaAEVTA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 5 Jan 2014 16:19:00 -0500
In-Reply-To: <1388956728-6754-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds a limit to the maximum number of elements that
belong to a set. It also adds a new field to count the current
number of elements, so in case that limit is reached, we hit
-ENOSPC.

This patch also adds two new attributes: NFTA_SET_MAXELEMS to
set and to indicate the current limit and NFTA_SET_NUMELEMS
to export the current number of set elements.

If not specified, it defaults to 1024 that results in a hashtable
of 16 KBytes in x86_64.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h        |    4 ++++
 include/uapi/linux/netfilter/nf_tables.h |    4 ++++
 net/netfilter/nf_tables_api.c            |   15 +++++++++++++++
 3 files changed, 23 insertions(+)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 82920e8..bb51649 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -208,6 +208,8 @@ void nft_unregister_set(struct nft_set_ops *ops);
  * 	@flags: set flags
  * 	@klen: key length
  * 	@dlen: data length
+ *	@maxelems: maximum number of elemens (default to 65535)
+ *	@numelems: current number of elemens
  * 	@data: private set data
  */
 struct nft_set {
@@ -221,6 +223,8 @@ struct nft_set {
 	u16				flags;
 	u8				klen;
 	u8				dlen;
+	u32				maxelems;
+	u32				numelems;
 	unsigned char			data[]
 		__attribute__((aligned(__alignof__(u64))));
 };
diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index aa86a152..aea7589 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -218,6 +218,8 @@ enum nft_set_flags {
  * @NFTA_SET_KEY_LEN: key data length (NLA_U32)
  * @NFTA_SET_DATA_TYPE: mapping data type (NLA_U32)
  * @NFTA_SET_DATA_LEN: mapping data length (NLA_U32)
+ * @NFTA_SET_MAXELEMS: maximum number of elements (NLA_U32)
+ * @NFTA_SET_NUMELEMS: current number of elements (NLA_U32)
  */
 enum nft_set_attributes {
 	NFTA_SET_UNSPEC,
@@ -228,6 +230,8 @@ enum nft_set_attributes {
 	NFTA_SET_KEY_LEN,
 	NFTA_SET_DATA_TYPE,
 	NFTA_SET_DATA_LEN,
+	NFTA_SET_MAXELEMS,
+	NFTA_SET_NUMELEMS,
 	__NFTA_SET_MAX
 };
 #define NFTA_SET_MAX		(__NFTA_SET_MAX - 1)
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 60efb61..488277d 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1895,6 +1895,7 @@ static const struct nla_policy nft_set_policy[NFTA_SET_MAX + 1] = {
 	[NFTA_SET_KEY_LEN]		= { .type = NLA_U32 },
 	[NFTA_SET_DATA_TYPE]		= { .type = NLA_U32 },
 	[NFTA_SET_DATA_LEN]		= { .type = NLA_U32 },
+	[NFTA_SET_MAXELEMS]		= { .type = NLA_U32 },
 };
 
 static int nft_ctx_init_from_setattr(struct nft_ctx *ctx,
@@ -2015,6 +2016,10 @@ static int nf_tables_fill_set(struct sk_buff *skb, const struct nft_ctx *ctx,
 		if (nla_put_be32(skb, NFTA_SET_DATA_LEN, htonl(set->dlen)))
 			goto nla_put_failure;
 	}
+	if (nla_put_be32(skb, NFTA_SET_MAXELEMS, htonl(set->maxelems)))
+		goto nla_put_failure;
+	if (nla_put_be32(skb, NFTA_SET_NUMELEMS, htonl(set->numelems)))
+		goto nla_put_failure;
 
 	return nlmsg_end(skb, nlh);
 
@@ -2360,6 +2365,11 @@ static int nf_tables_newset(struct sock *nlsk, struct sk_buff *skb,
 	set->dlen  = dlen;
 	set->flags = flags;
 
+	if (nla[NFTA_SET_MAXELEMS])
+		set->maxelems = ntohl(nla_get_be32(nla[NFTA_SET_MAXELEMS]));
+	else
+		set->maxelems = 1024;
+
 	err = ops->init(set, nla);
 	if (err < 0)
 		goto err2;
@@ -2669,6 +2679,9 @@ static int nft_add_set_elem(const struct nft_ctx *ctx, struct nft_set *set,
 	enum nft_registers dreg;
 	int err;
 
+	if (set->numelems >= set->maxelems)
+		return -ENOSPC;
+
 	err = nla_parse_nested(nla, NFTA_SET_ELEM_MAX, attr,
 			       nft_set_elem_policy);
 	if (err < 0)
@@ -2732,6 +2745,7 @@ static int nft_add_set_elem(const struct nft_ctx *ctx, struct nft_set *set,
 	if (err < 0)
 		goto err3;
 
+	set->numelems++;
 	return 0;
 
 err3:
@@ -2805,6 +2819,7 @@ static int nft_del_setelem(const struct nft_ctx *ctx, struct nft_set *set,
 	if (set->flags & NFT_SET_MAP)
 		nft_data_uninit(&elem.data, set->dtype);
 
+	set->numelems--;
 err2:
 	nft_data_uninit(&elem.key, desc.type);
 err1:
-- 
1.7.10.4

