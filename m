From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf-next] netfilter: nft_dynset: allow to invert match criteria
Date: Thu, 18 Aug 2016 18:22:59 +0200
Message-ID: <1471537379-2288-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ganesha.gnumonks.org ([213.95.27.120]:43323 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753968AbcHSC5o (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 18 Aug 2016 22:57:44 -0400
Received: from 129.166.216.87.static.jazztel.es ([87.216.166.129] helo=salvia.here)
        by ganesha.gnumonks.org with esmtpsa (TLS1.0:RSA_AES_128_CBC_SHA1:16)
        (Exim 4.72)
        (envelope-from <pablo@netfilter.org>)
        id 1baQ64-0003U1-Eq
        for netfilter-devel@vger.kernel.org; Thu, 18 Aug 2016 18:23:14 +0200
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The dynset expression matches if we can fit a new entry into the set.
If there is not room for it, then it breaks the rule evaluation.

This patch introduces the inversion flag to obtain the opposite
behaviour, ie. explicity drop packets that don't fit into set.

For example:

 # nft filter input set update ip saddr timeout 10s over size 24 @myset drop

This allows us to express the logic in a similar fashion to iptables
connlimit. Basically, every new entry uses the IPv4 address as key in
the set, this entry gets a timeout of 10 seconds that gets refresh on
every packet seen. If we get a packet and our set contains 24 entries
already, then this packet is dropped.

You can also express this in positive logic, assuming default policy to
drop:

 # nft filter input set update ip saddr timeout 10s size 24 @myset accept

Specifically, the plan is that 'over size' enables this flag inversion.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/uapi/linux/netfilter/nf_tables.h |  6 ++++++
 net/netfilter/nft_dynset.c               | 20 +++++++++++++++++++-
 2 files changed, 25 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 6ce0a6d..7859a91 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -575,6 +575,10 @@ enum nft_dynset_ops {
 	NFT_DYNSET_OP_UPDATE,
 };
 
+enum nft_dynset_flags {
+	NFT_DYNSET_F_INV	= (1 << 0),
+};
+
 /**
  * enum nft_dynset_attributes - dynset expression attributes
  *
@@ -585,6 +589,7 @@ enum nft_dynset_ops {
  * @NFTA_DYNSET_SREG_DATA: source register of the data (NLA_U32)
  * @NFTA_DYNSET_TIMEOUT: timeout value for the new element (NLA_U64)
  * @NFTA_DYNSET_EXPR: expression (NLA_NESTED: nft_expr_attributes)
+ * @NFTA_DYNSET_FLAGS: flags (NLA_U32)
  */
 enum nft_dynset_attributes {
 	NFTA_DYNSET_UNSPEC,
@@ -596,6 +601,7 @@ enum nft_dynset_attributes {
 	NFTA_DYNSET_TIMEOUT,
 	NFTA_DYNSET_EXPR,
 	NFTA_DYNSET_PAD,
+	NFTA_DYNSET_FLAGS,
 	__NFTA_DYNSET_MAX,
 };
 #define NFTA_DYNSET_MAX		(__NFTA_DYNSET_MAX - 1)
diff --git a/net/netfilter/nft_dynset.c b/net/netfilter/nft_dynset.c
index 0af2669..8fb567a 100644
--- a/net/netfilter/nft_dynset.c
+++ b/net/netfilter/nft_dynset.c
@@ -22,6 +22,7 @@ struct nft_dynset {
 	enum nft_dynset_ops		op:8;
 	enum nft_registers		sreg_key:8;
 	enum nft_registers		sreg_data:8;
+	bool				invert;
 	u64				timeout;
 	struct nft_expr			*expr;
 	struct nft_set_binding		binding;
@@ -82,10 +83,14 @@ static void nft_dynset_eval(const struct nft_expr *expr,
 
 		if (sexpr != NULL)
 			sexpr->ops->eval(sexpr, regs, pkt);
+
+		if (priv->invert)
+			regs->verdict.code = NFT_BREAK;
 		return;
 	}
 out:
-	regs->verdict.code = NFT_BREAK;
+	if (!priv->invert)
+		regs->verdict.code = NFT_BREAK;
 }
 
 static const struct nla_policy nft_dynset_policy[NFTA_DYNSET_MAX + 1] = {
@@ -96,6 +101,7 @@ static const struct nla_policy nft_dynset_policy[NFTA_DYNSET_MAX + 1] = {
 	[NFTA_DYNSET_SREG_DATA]	= { .type = NLA_U32 },
 	[NFTA_DYNSET_TIMEOUT]	= { .type = NLA_U64 },
 	[NFTA_DYNSET_EXPR]	= { .type = NLA_NESTED },
+	[NFTA_DYNSET_FLAGS]	= { .type = NLA_U32 },
 };
 
 static int nft_dynset_init(const struct nft_ctx *ctx,
@@ -113,6 +119,15 @@ static int nft_dynset_init(const struct nft_ctx *ctx,
 	    tb[NFTA_DYNSET_SREG_KEY] == NULL)
 		return -EINVAL;
 
+	if (tb[NFTA_DYNSET_FLAGS]) {
+		u32 flags = ntonl(nla_get_be32(tb[NFTA_DYNSET_FLAGS]));
+
+		if (flags & ~NFT_DYNSET_F_INV)
+			return -EINVAL;
+		if (flags & NFT_DYNSET_F_INV)
+			priv->invert = true;
+	}
+
 	set = nf_tables_set_lookup(ctx->table, tb[NFTA_DYNSET_SET_NAME],
 				   genmask);
 	if (IS_ERR(set)) {
@@ -220,6 +235,7 @@ static void nft_dynset_destroy(const struct nft_ctx *ctx,
 static int nft_dynset_dump(struct sk_buff *skb, const struct nft_expr *expr)
 {
 	const struct nft_dynset *priv = nft_expr_priv(expr);
+	u32 flags = priv->invert ? NFT_DYNSET_F_INV : 0;
 
 	if (nft_dump_register(skb, NFTA_DYNSET_SREG_KEY, priv->sreg_key))
 		goto nla_put_failure;
@@ -235,6 +251,8 @@ static int nft_dynset_dump(struct sk_buff *skb, const struct nft_expr *expr)
 		goto nla_put_failure;
 	if (priv->expr && nft_expr_dump(skb, NFTA_DYNSET_EXPR, priv->expr))
 		goto nla_put_failure;
+	if (nla_put_be32(skb, NFTA_DYNSET_FLAGS, htonl(flags)))
+		goto nla_put_failure;
 	return 0;
 
 nla_put_failure:
-- 
2.1.4

