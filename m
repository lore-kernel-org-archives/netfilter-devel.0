From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [nf-next PATCH] netfilter: nf_tables: add support for inverted
 login in nft_lookup
Date: Tue, 31 May 2016 13:33:53 +0200
Message-ID: <146469443294.16092.10350972377628813816.stgit@nfdev2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:60739 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751121AbcEaLd7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 31 May 2016 07:33:59 -0400
Received: from localhost (unknown [127.0.0.1])
	by smtp.cica.es (Postfix) with ESMTP id DD6F851F2D7
	for <netfilter-devel@vger.kernel.org>; Tue, 31 May 2016 11:33:56 +0000 (UTC)
Received: from smtp.cica.es ([127.0.0.1])
	by localhost (mail.cica.es [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id P-wWv6KWZOtY for <netfilter-devel@vger.kernel.org>;
	Tue, 31 May 2016 13:33:51 +0200 (CEST)
Received: from nfdev2.cica.es (nfdev2.cica.es [IPv6:2a00:9ac0:c1ca:31::221])
	(Authenticated sender: servers@cica.es)
	by smtp.cica.es (Postfix) with ESMTP id C7EAD51F2D3
	for <netfilter-devel@vger.kernel.org>; Tue, 31 May 2016 13:33:51 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Introduce a new configuration option for this expression, which allows users
to invert the logic of set lookups.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 include/uapi/linux/netfilter/nf_tables.h |    6 ++++++
 net/netfilter/nft_lookup.c               |   15 ++++++++++++++-
 2 files changed, 20 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 6a4dbe0..01751fa 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -546,6 +546,10 @@ enum nft_cmp_attributes {
 };
 #define NFTA_CMP_MAX		(__NFTA_CMP_MAX - 1)
 
+enum nft_lookup_flags {
+	NFT_LOOKUP_F_INV = (1 << 0),
+};
+
 /**
  * enum nft_lookup_attributes - nf_tables set lookup expression netlink attributes
  *
@@ -553,6 +557,7 @@ enum nft_cmp_attributes {
  * @NFTA_LOOKUP_SREG: source register of the data to look for (NLA_U32: nft_registers)
  * @NFTA_LOOKUP_DREG: destination register (NLA_U32: nft_registers)
  * @NFTA_LOOKUP_SET_ID: uniquely identifies a set in a transaction (NLA_U32)
+ * @NFTA_LOOKUP_FLAGS: flags (NLA_U32: enum nft_lookup_flags)
  */
 enum nft_lookup_attributes {
 	NFTA_LOOKUP_UNSPEC,
@@ -560,6 +565,7 @@ enum nft_lookup_attributes {
 	NFTA_LOOKUP_SREG,
 	NFTA_LOOKUP_DREG,
 	NFTA_LOOKUP_SET_ID,
+	NFTA_LOOKUP_FLAGS,
 	__NFTA_LOOKUP_MAX
 };
 #define NFTA_LOOKUP_MAX		(__NFTA_LOOKUP_MAX - 1)
diff --git a/net/netfilter/nft_lookup.c b/net/netfilter/nft_lookup.c
index b3c31ef..4a9ee78 100644
--- a/net/netfilter/nft_lookup.c
+++ b/net/netfilter/nft_lookup.c
@@ -23,6 +23,7 @@ struct nft_lookup {
 	enum nft_registers		sreg:8;
 	enum nft_registers		dreg:8;
 	struct nft_set_binding		binding;
+	bool				invert;
 };
 
 static void nft_lookup_eval(const struct nft_expr *expr,
@@ -33,7 +34,8 @@ static void nft_lookup_eval(const struct nft_expr *expr,
 	const struct nft_set *set = priv->set;
 	const struct nft_set_ext *ext;
 
-	if (set->ops->lookup(set, &regs->data[priv->sreg], &ext)) {
+	if (set->ops->lookup(set, &regs->data[priv->sreg], &ext) ^
+	    priv->invert) {
 		if (set->flags & NFT_SET_MAP)
 			nft_data_copy(&regs->data[priv->dreg],
 				      nft_set_ext_data(ext), set->dlen);
@@ -47,6 +49,7 @@ static const struct nla_policy nft_lookup_policy[NFTA_LOOKUP_MAX + 1] = {
 	[NFTA_LOOKUP_SET_ID]	= { .type = NLA_U32 },
 	[NFTA_LOOKUP_SREG]	= { .type = NLA_U32 },
 	[NFTA_LOOKUP_DREG]	= { .type = NLA_U32 },
+	[NFTA_LOOKUP_FLAGS]	= { .type = NLA_U32 },
 };
 
 static int nft_lookup_init(const struct nft_ctx *ctx,
@@ -55,6 +58,7 @@ static int nft_lookup_init(const struct nft_ctx *ctx,
 {
 	struct nft_lookup *priv = nft_expr_priv(expr);
 	struct nft_set *set;
+	u32 flags;
 	int err;
 
 	if (tb[NFTA_LOOKUP_SET] == NULL ||
@@ -91,6 +95,12 @@ static int nft_lookup_init(const struct nft_ctx *ctx,
 	} else if (set->flags & NFT_SET_MAP)
 		return -EINVAL;
 
+	if (tb[NFTA_LOOKUP_FLAGS]) {
+		flags = ntohl(nla_get_be32(tb[NFTA_LOOKUP_FLAGS]));
+		if (flags & NFT_LOOKUP_F_INV)
+			priv->invert = true;
+	}
+
 	priv->binding.flags = set->flags & NFT_SET_MAP;
 
 	err = nf_tables_bind_set(ctx, set, &priv->binding);
@@ -112,6 +122,7 @@ static void nft_lookup_destroy(const struct nft_ctx *ctx,
 static int nft_lookup_dump(struct sk_buff *skb, const struct nft_expr *expr)
 {
 	const struct nft_lookup *priv = nft_expr_priv(expr);
+	u32 flags = priv->invert ? NFT_LOOKUP_F_INV : 0;
 
 	if (nla_put_string(skb, NFTA_LOOKUP_SET, priv->set->name))
 		goto nla_put_failure;
@@ -120,6 +131,8 @@ static int nft_lookup_dump(struct sk_buff *skb, const struct nft_expr *expr)
 	if (priv->set->flags & NFT_SET_MAP)
 		if (nft_dump_register(skb, NFTA_LOOKUP_DREG, priv->dreg))
 			goto nla_put_failure;
+	if (nla_put_be32(skb, NFTA_LOOKUP_FLAGS, htonl(flags)))
+		goto nla_put_failure;
 	return 0;
 
 nla_put_failure:

