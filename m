From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [nf-next PATCH v4] netfilter: nf_tables: add support for inverted
 logic in nft_lookup
Date: Wed, 01 Jun 2016 17:23:02 +0200
Message-ID: <146479452764.7621.9693339197925845407.stgit@nfdev2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:41640 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758613AbcFAPXK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 1 Jun 2016 11:23:10 -0400
Received: from localhost (unknown [127.0.0.1])
	by smtp.cica.es (Postfix) with ESMTP id F3E4151F346
	for <netfilter-devel@vger.kernel.org>; Wed,  1 Jun 2016 15:23:06 +0000 (UTC)
Received: from smtp.cica.es ([127.0.0.1])
	by localhost (mail.cica.es [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id yQLXaKGWQv6x for <netfilter-devel@vger.kernel.org>;
	Wed,  1 Jun 2016 17:23:01 +0200 (CEST)
Received: from nfdev2.cica.es (nfdev2.cica.es [IPv6:2a00:9ac0:c1ca:31::221])
	(Authenticated sender: servers@cica.es)
	by smtp.cica.es (Postfix) with ESMTP id ABBB251F340
	for <netfilter-devel@vger.kernel.org>; Wed,  1 Jun 2016 17:23:01 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Introduce a new configuration option for this expression, which allows users
to invert the logic of set lookups.

In _init() we will now return EINVAL if NFT_LOOKUP_F_INV is anyway
related to a map lookup.

The code in the _eval() function has been untangled and updated to sopport the
XOR of options, as we should consider 4 cases:
 * lookup false, invert false -> NFT_BREAK
 * lookup false, invert true -> return w/o NFT_BREAK
 * lookup true, invert false -> return w/o NFT_BREAK
 * lookup true, invert true -> NFT_BREAK

I decided to be extra defensive and check again in the _eval() path for an
invalid combination of the invert flag, in order to avoid the potential
disaster of copying registers uncontrollably.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
v2: better aling memory of struct nft_lookup, put 'bool invert' before bindings
v3: include flags coherence validation
v4: stronger validation in _init(), stronger validation in _eval(), also untangle
    code, and update patch description

 include/uapi/linux/netfilter/nf_tables.h |    6 +++++
 net/netfilter/nft_lookup.c               |   36 ++++++++++++++++++++++++++----
 2 files changed, 37 insertions(+), 5 deletions(-)

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
index b3c31ef..e87e960 100644
--- a/net/netfilter/nft_lookup.c
+++ b/net/netfilter/nft_lookup.c
@@ -22,6 +22,7 @@ struct nft_lookup {
 	struct nft_set			*set;
 	enum nft_registers		sreg:8;
 	enum nft_registers		dreg:8;
+	bool				invert;
 	struct nft_set_binding		binding;
 };
 
@@ -32,14 +33,19 @@ static void nft_lookup_eval(const struct nft_expr *expr,
 	const struct nft_lookup *priv = nft_expr_priv(expr);
 	const struct nft_set *set = priv->set;
 	const struct nft_set_ext *ext;
+	bool found;
 
-	if (set->ops->lookup(set, &regs->data[priv->sreg], &ext)) {
-		if (set->flags & NFT_SET_MAP)
-			nft_data_copy(&regs->data[priv->dreg],
-				      nft_set_ext_data(ext), set->dlen);
+	found = set->ops->lookup(set, &regs->data[priv->sreg], &ext);
+
+	if (!(found ^ priv->invert)) {
+		regs->verdict.code = NFT_BREAK;
 		return;
 	}
-	regs->verdict.code = NFT_BREAK;
+
+	if (set->flags & NFT_SET_MAP && found && !priv->invert)
+		nft_data_copy(&regs->data[priv->dreg],
+			      nft_set_ext_data(ext), set->dlen);
+
 }
 
 static const struct nla_policy nft_lookup_policy[NFTA_LOOKUP_MAX + 1] = {
@@ -47,6 +53,7 @@ static const struct nla_policy nft_lookup_policy[NFTA_LOOKUP_MAX + 1] = {
 	[NFTA_LOOKUP_SET_ID]	= { .type = NLA_U32 },
 	[NFTA_LOOKUP_SREG]	= { .type = NLA_U32 },
 	[NFTA_LOOKUP_DREG]	= { .type = NLA_U32 },
+	[NFTA_LOOKUP_FLAGS]	= { .type = NLA_U32 },
 };
 
 static int nft_lookup_init(const struct nft_ctx *ctx,
@@ -55,6 +62,7 @@ static int nft_lookup_init(const struct nft_ctx *ctx,
 {
 	struct nft_lookup *priv = nft_expr_priv(expr);
 	struct nft_set *set;
+	u32 flags;
 	int err;
 
 	if (tb[NFTA_LOOKUP_SET] == NULL ||
@@ -79,7 +87,22 @@ static int nft_lookup_init(const struct nft_ctx *ctx,
 	if (err < 0)
 		return err;
 
+	if (tb[NFTA_LOOKUP_FLAGS]) {
+		flags = ntohl(nla_get_be32(tb[NFTA_LOOKUP_FLAGS]));
+
+		if (flags & ~NFT_LOOKUP_F_INV)
+			return -EINVAL;
+
+		if (flags & NFT_LOOKUP_F_INV) {
+			if (set->flags & NFT_SET_MAP)
+				return -EINVAL;
+			priv->invert = true;
+		}
+	}
+
 	if (tb[NFTA_LOOKUP_DREG] != NULL) {
+		if (priv->invert)
+			return -EINVAL;
 		if (!(set->flags & NFT_SET_MAP))
 			return -EINVAL;
 
@@ -112,6 +135,7 @@ static void nft_lookup_destroy(const struct nft_ctx *ctx,
 static int nft_lookup_dump(struct sk_buff *skb, const struct nft_expr *expr)
 {
 	const struct nft_lookup *priv = nft_expr_priv(expr);
+	u32 flags = priv->invert ? NFT_LOOKUP_F_INV : 0;
 
 	if (nla_put_string(skb, NFTA_LOOKUP_SET, priv->set->name))
 		goto nla_put_failure;
@@ -120,6 +144,8 @@ static int nft_lookup_dump(struct sk_buff *skb, const struct nft_expr *expr)
 	if (priv->set->flags & NFT_SET_MAP)
 		if (nft_dump_register(skb, NFTA_LOOKUP_DREG, priv->dreg))
 			goto nla_put_failure;
+	if (nla_put_be32(skb, NFTA_LOOKUP_FLAGS, htonl(flags)))
+		goto nla_put_failure;
 	return 0;
 
 nla_put_failure:

