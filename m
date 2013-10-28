From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [RFC PATCH 1/2 nf_tables] netfilter: nf_tables: allow 32/64/128-bits register addressing
Date: Mon, 28 Oct 2013 13:59:38 +0100
Message-ID: <1382965180-9400-2-git-send-email-pablo@netfilter.org>
References: <1382965180-9400-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49947 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756409Ab3J1M7x (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 28 Oct 2013 08:59:53 -0400
In-Reply-To: <1382965180-9400-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch allows 32/64/128-bits register addressing to nf_tables.
So far it was only possible to address registers using 128-bits
word size. This is problematic for set elements that are composed
of several tuples, ie. concatenations, as each tuple needs to be
aligned to the 128-bits word size of nf_tables.

With this patch, a simple concatenation like 'ip saddr . ip daddr'
is represented in the following way:

ip filter output 10 0
  [ payload load 4b @ network header + 12 => reg 19 ]
  [ payload load 4b @ network header + 16 => reg 20 ]
  [ lookup reg 19 set set0 dreg 0 ]
  [ counter pkts 0 bytes 0 ]

Thus, two IPv4 addresses are squashed in 8 bytes. With the previous
approach, we need 32 bytes for this.

This patch adds overlapping registers that allows us to address
register at different offset, there's a mapping between the register
and the byte offset:

int reg_to_offset[NFT_REG_ADDR_MAX] = {
       /* 128-bits addressing */
       [NFT_REG_VERDICT]       = 0,
       [NFT_REG_1]             = 4,
       [NFT_REG_2]             = 8,
       [NFT_REG_3]             = 12,
       [NFT_REG_4]             = 16,
       /* 64-bits addressing */
       [NFT_REG_5]             = 0, /* NFT_REG_VERDICT */
       [NFT_REG_6]             = 2, /* NFT_REG_VERDICT */
       [NFT_REG_7]             = 4,
       [NFT_REG_8]             = 6,
       [NFT_REG_9]             = 8,
       [NFT_REG_10]            = 10,
       [NFT_REG_11]            = 12,
       [NFT_REG_12]            = 14,
       [NFT_REG_13]            = 16,
       [NFT_REG_14]            = 18,
       /* 32-bits addressing */
       [NFT_REG_15]            = 0, /* NFT_REG_VERDICT */
       [NFT_REG_16]            = 1, /* NFT_REG_VERDICT */
       [NFT_REG_17]            = 2, /* NFT_REG_VERDICT */
       [NFT_REG_18]            = 3, /* NFT_REG_VERDICT */
       [NFT_REG_19]            = 4,
       [NFT_REG_20]            = 5,
       [NFT_REG_21]            = 6,
       [NFT_REG_22]            = 7,
       [NFT_REG_23]            = 8,
       [NFT_REG_24]            = 9,
       [NFT_REG_25]            = 10,
       [NFT_REG_26]            = 11,
       [NFT_REG_27]            = 12,
       [NFT_REG_28]            = 13,
       [NFT_REG_29]            = 14,
       [NFT_REG_30]            = 15,
       [NFT_REG_31]            = 16,
       [NFT_REG_32]            = 17,
       [NFT_REG_33]            = 18,
       [NFT_REG_34]            = 19,
};

There's some extra runtime overhead which involves the translation
from register to byte offset. In user-space, there's some extra
complexity in the register allocation as we have to explicitly
request to enter 32-bits addressing, and go back to default 128-bits
when needed.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h        |   16 +++++-
 include/uapi/linux/netfilter/nf_tables.h |   35 ++++++++++++-
 net/netfilter/nf_tables_api.c            |    4 +-
 net/netfilter/nf_tables_core.c           |   81 +++++++++++++++++++++++-------
 net/netfilter/nft_bitwise.c              |   10 ++--
 net/netfilter/nft_byteorder.c            |   10 ++--
 net/netfilter/nft_cmp.c                  |    8 +--
 net/netfilter/nft_compat.c               |   16 +++---
 net/netfilter/nft_ct.c                   |   35 +++++++------
 net/netfilter/nft_exthdr.c               |    9 ++--
 net/netfilter/nft_hash.c                 |   13 +++--
 net/netfilter/nft_immediate.c            |    5 +-
 net/netfilter/nft_limit.c                |    5 +-
 net/netfilter/nft_log.c                  |    3 +-
 net/netfilter/nft_lookup.c               |    9 ++--
 net/netfilter/nft_meta.c                 |   37 +++++++-------
 net/netfilter/nft_nat.c                  |   27 +++++-----
 net/netfilter/nft_payload.c              |    9 ++--
 net/netfilter/nft_rbtree.c               |    5 +-
 19 files changed, 207 insertions(+), 130 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 54c4a5c..93b294d 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -65,6 +65,18 @@ static inline void nft_data_debug(const struct nft_data *data)
 		 data->data[2], data->data[3]);
 }
 
+union nft_regset {
+	struct nft_data data[NFT_REG_MAX + 1];
+	u32 word[(NFT_REG_MAX + 1) * sizeof(u32)];
+};
+
+extern int reg_to_offset[];
+
+static inline u32 *get_reg_offset(union nft_regset *rs, u32 regnum)
+{
+	return &rs->word[reg_to_offset[regnum]];
+}
+
 /**
  *	struct nft_ctx - nf_tables rule/set context
  *
@@ -161,7 +173,7 @@ struct nft_set_iter {
  */
 struct nft_set_ops {
 	bool				(*lookup)(const struct nft_set *set,
-						  const struct nft_data *key,
+						  const u32 *key,
 						  struct nft_data *data);
 	int				(*get)(const struct nft_set *set,
 					       struct nft_set_elem *elem);
@@ -280,7 +292,7 @@ struct nft_expr_type {
 struct nft_expr;
 struct nft_expr_ops {
 	void				(*eval)(const struct nft_expr *expr,
-						struct nft_data data[NFT_REG_MAX + 1],
+						union nft_regset *rs,
 						const struct nft_pktinfo *pkt);
 	unsigned int			size;
 
diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index fbfd229..18e5d31 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -9,7 +9,40 @@ enum nft_registers {
 	NFT_REG_2,
 	NFT_REG_3,
 	NFT_REG_4,
-	__NFT_REG_MAX
+	__NFT_REG_MAX,
+	/* 64 bits addressing */
+	NFT_REG_5 = __NFT_REG_MAX,
+	NFT_REG_6,
+	NFT_REG_7,
+	NFT_REG_8,
+	NFT_REG_9,
+	NFT_REG_10,
+	NFT_REG_11,
+	NFT_REG_12,
+	NFT_REG_13,
+	NFT_REG_14,
+	/* 32 bits addressing */
+	NFT_REG_15,
+	NFT_REG_16,
+	NFT_REG_17,
+	NFT_REG_18,
+	NFT_REG_19,
+	NFT_REG_20,
+	NFT_REG_21,
+	NFT_REG_22,
+	NFT_REG_23,
+	NFT_REG_24,
+	NFT_REG_25,
+	NFT_REG_26,
+	NFT_REG_27,
+	NFT_REG_28,
+	NFT_REG_29,
+	NFT_REG_30,
+	NFT_REG_31,
+	NFT_REG_32,
+	NFT_REG_33,
+	NFT_REG_34,
+	NFT_REG_ADDR_MAX,
 };
 #define NFT_REG_MAX	(__NFT_REG_MAX - 1)
 
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index dcddc49..6b716eb 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2953,7 +2953,7 @@ int nft_validate_input_register(enum nft_registers reg)
 {
 	if (reg <= NFT_REG_VERDICT)
 		return -EINVAL;
-	if (reg > NFT_REG_MAX)
+	if (reg > NFT_REG_ADDR_MAX)
 		return -ERANGE;
 	return 0;
 }
@@ -2971,7 +2971,7 @@ int nft_validate_output_register(enum nft_registers reg)
 {
 	if (reg < NFT_REG_VERDICT)
 		return -EINVAL;
-	if (reg > NFT_REG_MAX)
+	if (reg > NFT_REG_ADDR_MAX)
 		return -ERANGE;
 	return 0;
 }
diff --git a/net/netfilter/nf_tables_core.c b/net/netfilter/nf_tables_core.c
index cb9e685..b814b0c4 100644
--- a/net/netfilter/nf_tables_core.c
+++ b/net/netfilter/nf_tables_core.c
@@ -22,24 +22,25 @@
 #include <net/netfilter/nf_log.h>
 
 static void nft_cmp_fast_eval(const struct nft_expr *expr,
-			      struct nft_data data[NFT_REG_MAX + 1])
+			      union nft_regset *rs)
 {
 	const struct nft_cmp_fast_expr *priv = nft_expr_priv(expr);
+	u32 *src = get_reg_offset(rs, priv->sreg);
 	u32 mask;
 
 	mask = ~0U >> (sizeof(priv->data) * BITS_PER_BYTE - priv->len);
-	if ((data[priv->sreg].data[0] & mask) == priv->data)
+	if ((src[0] & mask) == priv->data)
 		return;
-	data[NFT_REG_VERDICT].verdict = NFT_BREAK;
+	rs->data[NFT_REG_VERDICT].verdict = NFT_BREAK;
 }
 
 static bool nft_payload_fast_eval(const struct nft_expr *expr,
-				  struct nft_data data[NFT_REG_MAX + 1],
+				  union nft_regset *rs,
 				  const struct nft_pktinfo *pkt)
 {
 	const struct nft_payload *priv = nft_expr_priv(expr);
 	const struct sk_buff *skb = pkt->skb;
-	struct nft_data *dest = &data[priv->dreg];
+	u32 *dest = get_reg_offset(rs, priv->dreg);
 	unsigned char *ptr;
 
 	if (priv->base == NFT_PAYLOAD_NETWORK_HEADER)
@@ -53,11 +54,11 @@ static bool nft_payload_fast_eval(const struct nft_expr *expr,
 		return false;
 
 	if (priv->len == 2)
-		*(u16 *)dest->data = *(u16 *)ptr;
+		*(u16 *)dest = *(u16 *)ptr;
 	else if (priv->len == 4)
-		*(u32 *)dest->data = *(u32 *)ptr;
+		*(u32 *)dest = *(u32 *)ptr;
 	else
-		*(u8 *)dest->data = *(u8 *)ptr;
+		*(u8 *)dest = *(u8 *)ptr;
 	return true;
 }
 
@@ -115,13 +116,55 @@ static inline void nft_trace_packet(const struct nft_pktinfo *pkt,
 		      rulenum);
 }
 
+int reg_to_offset[NFT_REG_ADDR_MAX] = {
+	/* 128-bits addressing */
+	[NFT_REG_VERDICT]	= 0,
+	[NFT_REG_1]		= 4,
+	[NFT_REG_2]		= 8,
+	[NFT_REG_3]		= 12,
+	[NFT_REG_4]		= 16,
+	/* 64-bits addressing */
+	[NFT_REG_5]		= 0, /* NFT_REG_VERDICT */
+	[NFT_REG_6]		= 2, /* NFT_REG_VERDICT */
+	[NFT_REG_7]		= 4,
+	[NFT_REG_8]		= 6,
+	[NFT_REG_9]		= 8,
+	[NFT_REG_10]		= 10,
+	[NFT_REG_11]		= 12,
+	[NFT_REG_12]		= 14,
+	[NFT_REG_13]		= 16,
+	[NFT_REG_14]		= 18,
+	/* 32-bits addressing */
+	[NFT_REG_15]		= 0, /* NFT_REG_VERDICT */
+	[NFT_REG_16]		= 1, /* NFT_REG_VERDICT */
+	[NFT_REG_17]		= 2, /* NFT_REG_VERDICT */
+	[NFT_REG_18]		= 3, /* NFT_REG_VERDICT */
+	[NFT_REG_19]		= 4,
+	[NFT_REG_20]		= 5,
+	[NFT_REG_21]		= 6,
+	[NFT_REG_22]		= 7,
+	[NFT_REG_23]		= 8,
+	[NFT_REG_24]		= 9,
+	[NFT_REG_25]		= 10,
+	[NFT_REG_26]		= 11,
+	[NFT_REG_27]		= 12,
+	[NFT_REG_28]		= 13,
+	[NFT_REG_29]		= 14,
+	[NFT_REG_30]		= 15,
+	[NFT_REG_31]		= 16,
+	[NFT_REG_32]		= 17,
+	[NFT_REG_33]		= 18,
+	[NFT_REG_34]		= 19,
+};
+EXPORT_SYMBOL_GPL(reg_to_offset);
+
 unsigned int
 nft_do_chain_pktinfo(struct nft_pktinfo *pkt, const struct nf_hook_ops *ops)
 {
 	const struct nft_chain *chain = ops->priv;
 	const struct nft_rule *rule;
 	const struct nft_expr *expr, *last;
-	struct nft_data data[NFT_REG_MAX + 1];
+	union nft_regset rs;
 	unsigned int stackptr = 0;
 	struct nft_jumpstack jumpstack[NFT_JUMP_STACK_SIZE];
 	int rulenum = 0;
@@ -134,7 +177,7 @@ nft_do_chain_pktinfo(struct nft_pktinfo *pkt, const struct nf_hook_ops *ops)
 do_chain:
 	rule = list_entry(&chain->rules, struct nft_rule, list);
 next_rule:
-	data[NFT_REG_VERDICT].verdict = NFT_CONTINUE;
+	rs.data[NFT_REG_VERDICT].verdict = NFT_CONTINUE;
 	list_for_each_entry_continue_rcu(rule, &chain->rules, list) {
 
 		/* This rule is not active, skip. */
@@ -145,18 +188,18 @@ next_rule:
 
 		nft_rule_for_each_expr(expr, last, rule) {
 			if (expr->ops == &nft_cmp_fast_ops)
-				nft_cmp_fast_eval(expr, data);
+				nft_cmp_fast_eval(expr, &rs);
 			else if (expr->ops != &nft_payload_fast_ops ||
-				 !nft_payload_fast_eval(expr, data, pkt))
-				expr->ops->eval(expr, data, pkt);
+				 !nft_payload_fast_eval(expr, &rs, pkt))
+				expr->ops->eval(expr, &rs, pkt);
 
-			if (data[NFT_REG_VERDICT].verdict != NFT_CONTINUE)
+			if (rs.data[NFT_REG_VERDICT].verdict != NFT_CONTINUE)
 				break;
 		}
 
-		switch (data[NFT_REG_VERDICT].verdict) {
+		switch (rs.data[NFT_REG_VERDICT].verdict) {
 		case NFT_BREAK:
-			data[NFT_REG_VERDICT].verdict = NFT_CONTINUE;
+			rs.data[NFT_REG_VERDICT].verdict = NFT_CONTINUE;
 			/* fall through */
 		case NFT_CONTINUE:
 			continue;
@@ -164,14 +207,14 @@ next_rule:
 		break;
 	}
 
-	switch (data[NFT_REG_VERDICT].verdict) {
+	switch (rs.data[NFT_REG_VERDICT].verdict) {
 	case NF_ACCEPT:
 	case NF_DROP:
 	case NF_QUEUE:
 		if (unlikely(pkt->skb->nf_trace))
 			nft_trace_packet(pkt, chain, rulenum, NFT_TRACE_RULE);
 
-		return data[NFT_REG_VERDICT].verdict;
+		return rs.data[NFT_REG_VERDICT].verdict;
 	case NFT_JUMP:
 		if (unlikely(pkt->skb->nf_trace))
 			nft_trace_packet(pkt, chain, rulenum, NFT_TRACE_RULE);
@@ -183,7 +226,7 @@ next_rule:
 		stackptr++;
 		/* fall through */
 	case NFT_GOTO:
-		chain = data[NFT_REG_VERDICT].chain;
+		chain = rs.data[NFT_REG_VERDICT].chain;
 		goto do_chain;
 	case NFT_RETURN:
 		if (unlikely(pkt->skb->nf_trace))
diff --git a/net/netfilter/nft_bitwise.c b/net/netfilter/nft_bitwise.c
index 4fb6ee2..6e2d4a1 100644
--- a/net/netfilter/nft_bitwise.c
+++ b/net/netfilter/nft_bitwise.c
@@ -25,18 +25,16 @@ struct nft_bitwise {
 	struct nft_data		xor;
 };
 
-static void nft_bitwise_eval(const struct nft_expr *expr,
-			     struct nft_data data[NFT_REG_MAX + 1],
+static void nft_bitwise_eval(const struct nft_expr *expr, union nft_regset *rs,
 			     const struct nft_pktinfo *pkt)
 {
 	const struct nft_bitwise *priv = nft_expr_priv(expr);
-	const struct nft_data *src = &data[priv->sreg];
-	struct nft_data *dst = &data[priv->dreg];
+	const u32 *src = get_reg_offset(rs, priv->sreg);
+	u32 *dst = get_reg_offset(rs, priv->dreg);
 	unsigned int i;
 
 	for (i = 0; i < DIV_ROUND_UP(priv->len, 4); i++) {
-		dst->data[i] = (src->data[i] & priv->mask.data[i]) ^
-			       priv->xor.data[i];
+		dst[i] = (src[i] & priv->mask.data[i]) ^ priv->xor.data[i];
 	}
 }
 
diff --git a/net/netfilter/nft_byteorder.c b/net/netfilter/nft_byteorder.c
index c39ed8d..c7debbe 100644
--- a/net/netfilter/nft_byteorder.c
+++ b/net/netfilter/nft_byteorder.c
@@ -26,17 +26,15 @@ struct nft_byteorder {
 };
 
 static void nft_byteorder_eval(const struct nft_expr *expr,
-			       struct nft_data data[NFT_REG_MAX + 1],
+			       union nft_regset *rs,
 			       const struct nft_pktinfo *pkt)
 {
 	const struct nft_byteorder *priv = nft_expr_priv(expr);
-	struct nft_data *src = &data[priv->sreg], *dst = &data[priv->dreg];
-	union { u32 u32; u16 u16; } *s, *d;
+	u32 *src = get_reg_offset(rs, priv->sreg);
+	u32 *dst = get_reg_offset(rs, priv->dreg);
+	union { u32 u32; u16 u16; } *s = (void *)src, *d = (void *)dst;
 	unsigned int i;
 
-	s = (void *)src->data;
-	d = (void *)dst->data;
-
 	switch (priv->size) {
 	case 4:
 		switch (priv->op) {
diff --git a/net/netfilter/nft_cmp.c b/net/netfilter/nft_cmp.c
index 954925d..79ff1cd 100644
--- a/net/netfilter/nft_cmp.c
+++ b/net/netfilter/nft_cmp.c
@@ -24,14 +24,14 @@ struct nft_cmp_expr {
 	enum nft_cmp_ops	op:8;
 };
 
-static void nft_cmp_eval(const struct nft_expr *expr,
-			 struct nft_data data[NFT_REG_MAX + 1],
+static void nft_cmp_eval(const struct nft_expr *expr, union nft_regset *rs,
 			 const struct nft_pktinfo *pkt)
 {
 	const struct nft_cmp_expr *priv = nft_expr_priv(expr);
+	u32 *src = get_reg_offset(rs, priv->sreg);
 	int d;
 
-	d = nft_data_cmp(&data[priv->sreg], &priv->data, priv->len);
+	d = memcmp(src, &priv->data, priv->len);
 	switch (priv->op) {
 	case NFT_CMP_EQ:
 		if (d != 0)
@@ -59,7 +59,7 @@ static void nft_cmp_eval(const struct nft_expr *expr,
 	return;
 
 mismatch:
-	data[NFT_REG_VERDICT].verdict = NFT_BREAK;
+	rs->data[NFT_REG_VERDICT].verdict = NFT_BREAK;
 }
 
 static const struct nla_policy nft_cmp_policy[NFTA_CMP_MAX + 1] = {
diff --git a/net/netfilter/nft_compat.c b/net/netfilter/nft_compat.c
index 4811f76..ec68d1e 100644
--- a/net/netfilter/nft_compat.c
+++ b/net/netfilter/nft_compat.c
@@ -35,8 +35,7 @@ nft_compat_set_par(struct xt_action_param *par, void *xt, const void *xt_info)
 	par->hotdrop	= false;
 }
 
-static void nft_target_eval(const struct nft_expr *expr,
-			    struct nft_data data[NFT_REG_MAX + 1],
+static void nft_target_eval(const struct nft_expr *expr, union nft_regset *rs,
 			    const struct nft_pktinfo *pkt)
 {
 	void *info = nft_expr_priv(expr);
@@ -53,10 +52,10 @@ static void nft_target_eval(const struct nft_expr *expr,
 
 	switch(ret) {
 	case XT_CONTINUE:
-		data[NFT_REG_VERDICT].verdict = NFT_CONTINUE;
+		rs->data[NFT_REG_VERDICT].verdict = NFT_CONTINUE;
 		break;
 	default:
-		data[NFT_REG_VERDICT].verdict = ret;
+		rs->data[NFT_REG_VERDICT].verdict = ret;
 		break;
 	}
 	return;
@@ -261,8 +260,7 @@ static int nft_target_validate(const struct nft_ctx *ctx,
 	return 0;
 }
 
-static void nft_match_eval(const struct nft_expr *expr,
-			   struct nft_data data[NFT_REG_MAX + 1],
+static void nft_match_eval(const struct nft_expr *expr, union nft_regset *rs,
 			   const struct nft_pktinfo *pkt)
 {
 	void *info = nft_expr_priv(expr);
@@ -275,16 +273,16 @@ static void nft_match_eval(const struct nft_expr *expr,
 	ret = match->match(skb, (struct xt_action_param *)&pkt->xt);
 
 	if (pkt->xt.hotdrop) {
-		data[NFT_REG_VERDICT].verdict = NF_DROP;
+		rs->data[NFT_REG_VERDICT].verdict = NF_DROP;
 		return;
 	}
 
 	switch(ret) {
 	case true:
-		data[NFT_REG_VERDICT].verdict = NFT_CONTINUE;
+		rs->data[NFT_REG_VERDICT].verdict = NFT_CONTINUE;
 		break;
 	case false:
-		data[NFT_REG_VERDICT].verdict = NFT_BREAK;
+		rs->data[NFT_REG_VERDICT].verdict = NFT_BREAK;
 		break;
 	}
 }
diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
index 955f4e6..6cad02e 100644
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -26,12 +26,11 @@ struct nft_ct {
 	uint8_t			family;
 };
 
-static void nft_ct_eval(const struct nft_expr *expr,
-			struct nft_data data[NFT_REG_MAX + 1],
+static void nft_ct_eval(const struct nft_expr *expr, union nft_regset *rs,
 			const struct nft_pktinfo *pkt)
 {
 	const struct nft_ct *priv = nft_expr_priv(expr);
-	struct nft_data *dest = &data[priv->dreg];
+	u32 *dest = get_reg_offset(rs, priv->dreg);
 	enum ip_conntrack_info ctinfo;
 	const struct nf_conn *ct;
 	const struct nf_conn_help *help;
@@ -50,7 +49,7 @@ static void nft_ct_eval(const struct nft_expr *expr,
 			state = NF_CT_STATE_UNTRACKED_BIT;
 		else
 			state = NF_CT_STATE_BIT(ctinfo);
-		dest->data[0] = state;
+		dest[0] = state;
 		return;
 	}
 
@@ -59,26 +58,26 @@ static void nft_ct_eval(const struct nft_expr *expr,
 
 	switch (priv->key) {
 	case NFT_CT_DIRECTION:
-		dest->data[0] = CTINFO2DIR(ctinfo);
+		dest[0] = CTINFO2DIR(ctinfo);
 		return;
 	case NFT_CT_STATUS:
-		dest->data[0] = ct->status;
+		dest[0] = ct->status;
 		return;
 #ifdef CONFIG_NF_CONNTRACK_MARK
 	case NFT_CT_MARK:
-		dest->data[0] = ct->mark;
+		dest[0] = ct->mark;
 		return;
 #endif
 #ifdef CONFIG_NF_CONNTRACK_SECMARK
 	case NFT_CT_SECMARK:
-		dest->data[0] = ct->secmark;
+		dest[0] = ct->secmark;
 		return;
 #endif
 	case NFT_CT_EXPIRATION:
 		diff = (long)jiffies - (long)ct->timeout.expires;
 		if (diff < 0)
 			diff = 0;
-		dest->data[0] = jiffies_to_msecs(diff);
+		dest[0] = jiffies_to_msecs(diff);
 		return;
 	case NFT_CT_HELPER:
 		if (ct->master == NULL)
@@ -89,38 +88,38 @@ static void nft_ct_eval(const struct nft_expr *expr,
 		helper = rcu_dereference(help->helper);
 		if (helper == NULL)
 			goto err;
-		if (strlen(helper->name) >= sizeof(dest->data))
+		if (strlen(helper->name) >= sizeof(struct nft_data))
 			goto err;
-		strncpy((char *)dest->data, helper->name, sizeof(dest->data));
+		strncpy((char *)dest, helper->name, sizeof(struct nft_data));
 		return;
 	}
 
 	tuple = &ct->tuplehash[priv->dir].tuple;
 	switch (priv->key) {
 	case NFT_CT_L3PROTOCOL:
-		dest->data[0] = nf_ct_l3num(ct);
+		dest[0] = nf_ct_l3num(ct);
 		return;
 	case NFT_CT_SRC:
-		memcpy(dest->data, tuple->src.u3.all,
+		memcpy(dest, tuple->src.u3.all,
 		       nf_ct_l3num(ct) == NFPROTO_IPV4 ? 4 : 16);
 		return;
 	case NFT_CT_DST:
-		memcpy(dest->data, tuple->dst.u3.all,
+		memcpy(dest, tuple->dst.u3.all,
 		       nf_ct_l3num(ct) == NFPROTO_IPV4 ? 4 : 16);
 		return;
 	case NFT_CT_PROTOCOL:
-		dest->data[0] = nf_ct_protonum(ct);
+		dest[0] = nf_ct_protonum(ct);
 		return;
 	case NFT_CT_PROTO_SRC:
-		dest->data[0] = (__force __u16)tuple->src.u.all;
+		dest[0] = (__force __u16)tuple->src.u.all;
 		return;
 	case NFT_CT_PROTO_DST:
-		dest->data[0] = (__force __u16)tuple->dst.u.all;
+		dest[0] = (__force __u16)tuple->dst.u.all;
 		return;
 	}
 	return;
 err:
-	data[NFT_REG_VERDICT].verdict = NFT_BREAK;
+	rs->data[NFT_REG_VERDICT].verdict = NFT_BREAK;
 }
 
 static const struct nla_policy nft_ct_policy[NFTA_CT_MAX + 1] = {
diff --git a/net/netfilter/nft_exthdr.c b/net/netfilter/nft_exthdr.c
index 8e0bb75..4c0c402 100644
--- a/net/netfilter/nft_exthdr.c
+++ b/net/netfilter/nft_exthdr.c
@@ -25,12 +25,11 @@ struct nft_exthdr {
 	enum nft_registers	dreg:8;
 };
 
-static void nft_exthdr_eval(const struct nft_expr *expr,
-			    struct nft_data data[NFT_REG_MAX + 1],
+static void nft_exthdr_eval(const struct nft_expr *expr, union nft_regset *rs,
 			    const struct nft_pktinfo *pkt)
 {
 	struct nft_exthdr *priv = nft_expr_priv(expr);
-	struct nft_data *dest = &data[priv->dreg];
+	u32 *dest = get_reg_offset(rs, priv->dreg);
 	unsigned int offset;
 	int err;
 
@@ -39,11 +38,11 @@ static void nft_exthdr_eval(const struct nft_expr *expr,
 		goto err;
 	offset += priv->offset;
 
-	if (skb_copy_bits(pkt->skb, offset, dest->data, priv->len) < 0)
+	if (skb_copy_bits(pkt->skb, offset, dest, priv->len) < 0)
 		goto err;
 	return;
 err:
-	data[NFT_REG_VERDICT].verdict = NFT_BREAK;
+	rs->data[NFT_REG_VERDICT].verdict = NFT_BREAK;
 }
 
 static const struct nla_policy nft_exthdr_policy[NFTA_EXTHDR_MAX + 1] = {
diff --git a/net/netfilter/nft_hash.c b/net/netfilter/nft_hash.c
index 3d3f8fc..b4b9a0b 100644
--- a/net/netfilter/nft_hash.c
+++ b/net/netfilter/nft_hash.c
@@ -32,18 +32,17 @@ struct nft_hash_elem {
 static u32 nft_hash_rnd __read_mostly;
 static bool nft_hash_rnd_initted __read_mostly;
 
-static unsigned int nft_hash_data(const struct nft_data *data,
+static unsigned int nft_hash_data(const u32 *data,
 				  unsigned int hsize, unsigned int len)
 {
 	unsigned int h;
 
-	h = jhash(data->data, len, nft_hash_rnd);
+	h = jhash(data, len, nft_hash_rnd);
 	return ((u64)h * hsize) >> 32;
 }
 
 static bool nft_hash_lookup(const struct nft_set *set,
-			    const struct nft_data *key,
-			    struct nft_data *data)
+			    const u32 *key, struct nft_data *data)
 {
 	const struct nft_hash *priv = nft_set_priv(set);
 	const struct nft_hash_elem *he;
@@ -51,7 +50,7 @@ static bool nft_hash_lookup(const struct nft_set *set,
 
 	h = nft_hash_data(key, priv->hsize, set->klen);
 	hlist_for_each_entry(he, &priv->hash[h], hnode) {
-		if (nft_data_cmp(&he->key, key, set->klen))
+		if (memcmp(&he->key, key, set->klen) != 0)
 			continue;
 		if (set->flags & NFT_SET_MAP)
 			nft_data_copy(data, he->data);
@@ -91,7 +90,7 @@ static int nft_hash_insert(const struct nft_set *set,
 	if (set->flags & NFT_SET_MAP)
 		nft_data_copy(he->data, &elem->data);
 
-	h = nft_hash_data(&he->key, priv->hsize, set->klen);
+	h = nft_hash_data((u32 *)&he->key, priv->hsize, set->klen);
 	hlist_add_head_rcu(&he->hnode, &priv->hash[h]);
 	return 0;
 }
@@ -111,7 +110,7 @@ static int nft_hash_get(const struct nft_set *set, struct nft_set_elem *elem)
 	struct nft_hash_elem *he;
 	unsigned int h;
 
-	h = nft_hash_data(&elem->key, priv->hsize, set->klen);
+	h = nft_hash_data((u32 *)&elem->key, priv->hsize, set->klen);
 	hlist_for_each_entry(he, &priv->hash[h], hnode) {
 		if (nft_data_cmp(&he->key, &elem->key, set->klen))
 			continue;
diff --git a/net/netfilter/nft_immediate.c b/net/netfilter/nft_immediate.c
index f169501..5d9053c 100644
--- a/net/netfilter/nft_immediate.c
+++ b/net/netfilter/nft_immediate.c
@@ -24,12 +24,13 @@ struct nft_immediate_expr {
 };
 
 static void nft_immediate_eval(const struct nft_expr *expr,
-			       struct nft_data data[NFT_REG_MAX + 1],
+			       union nft_regset *rs,
 			       const struct nft_pktinfo *pkt)
 {
 	const struct nft_immediate_expr *priv = nft_expr_priv(expr);
+	u32 *dest = get_reg_offset(rs, priv->dreg);
 
-	nft_data_copy(&data[priv->dreg], &priv->data);
+	memcpy(dest, &priv->data, sizeof(struct nft_data));
 }
 
 static const struct nla_policy nft_immediate_policy[NFTA_IMMEDIATE_MAX + 1] = {
diff --git a/net/netfilter/nft_limit.c b/net/netfilter/nft_limit.c
index 85da5bd..88bdc51 100644
--- a/net/netfilter/nft_limit.c
+++ b/net/netfilter/nft_limit.c
@@ -26,8 +26,7 @@ struct nft_limit {
 	unsigned long	stamp;
 };
 
-static void nft_limit_eval(const struct nft_expr *expr,
-			   struct nft_data data[NFT_REG_MAX + 1],
+static void nft_limit_eval(const struct nft_expr *expr, union nft_regset *rs,
 			   const struct nft_pktinfo *pkt)
 {
 	struct nft_limit *priv = nft_expr_priv(expr);
@@ -45,7 +44,7 @@ static void nft_limit_eval(const struct nft_expr *expr,
 	}
 	spin_unlock_bh(&limit_lock);
 
-	data[NFT_REG_VERDICT].verdict = NFT_BREAK;
+	rs->data[NFT_REG_VERDICT].verdict = NFT_BREAK;
 }
 
 static const struct nla_policy nft_limit_policy[NFTA_LIMIT_MAX + 1] = {
diff --git a/net/netfilter/nft_log.c b/net/netfilter/nft_log.c
index 57cad07..b0281a9 100644
--- a/net/netfilter/nft_log.c
+++ b/net/netfilter/nft_log.c
@@ -26,8 +26,7 @@ struct nft_log {
 	int			family;
 };
 
-static void nft_log_eval(const struct nft_expr *expr,
-			 struct nft_data data[NFT_REG_MAX + 1],
+static void nft_log_eval(const struct nft_expr *expr, union nft_regset *rs,
 			 const struct nft_pktinfo *pkt)
 {
 	const struct nft_log *priv = nft_expr_priv(expr);
diff --git a/net/netfilter/nft_lookup.c b/net/netfilter/nft_lookup.c
index 8a6116b..ab87fc7 100644
--- a/net/netfilter/nft_lookup.c
+++ b/net/netfilter/nft_lookup.c
@@ -24,16 +24,17 @@ struct nft_lookup {
 	struct nft_set_binding		binding;
 };
 
-static void nft_lookup_eval(const struct nft_expr *expr,
-			    struct nft_data data[NFT_REG_MAX + 1],
+static void nft_lookup_eval(const struct nft_expr *expr, union nft_regset *rs,
 			    const struct nft_pktinfo *pkt)
 {
 	const struct nft_lookup *priv = nft_expr_priv(expr);
 	const struct nft_set *set = priv->set;
+	u32 *src = get_reg_offset(rs, priv->sreg);
+	u32 *dst = get_reg_offset(rs, priv->dreg);
 
-	if (set->ops->lookup(set, &data[priv->sreg], &data[priv->dreg]))
+	if (set->ops->lookup(set, src, (struct nft_data *)dst))
 		return;
-	data[NFT_REG_VERDICT].verdict = NFT_BREAK;
+	rs->data[NFT_REG_VERDICT].verdict = NFT_BREAK;
 }
 
 static const struct nla_policy nft_lookup_policy[NFTA_LOOKUP_MAX + 1] = {
diff --git a/net/netfilter/nft_meta.c b/net/netfilter/nft_meta.c
index 8c28220..26f2195 100644
--- a/net/netfilter/nft_meta.c
+++ b/net/netfilter/nft_meta.c
@@ -25,56 +25,55 @@ struct nft_meta {
 };
 
 static void nft_meta_eval(const struct nft_expr *expr,
-			  struct nft_data data[NFT_REG_MAX + 1],
-			  const struct nft_pktinfo *pkt)
+			  union nft_regset *rs, const struct nft_pktinfo *pkt)
 {
 	const struct nft_meta *priv = nft_expr_priv(expr);
 	const struct sk_buff *skb = pkt->skb;
 	const struct net_device *in = pkt->in, *out = pkt->out;
-	struct nft_data *dest = &data[priv->dreg];
+	u32 *dest = get_reg_offset(rs, priv->dreg);
 
 	switch (priv->key) {
 	case NFT_META_LEN:
-		dest->data[0] = skb->len;
+		dest[0] = skb->len;
 		break;
 	case NFT_META_PROTOCOL:
-		*(__be16 *)dest->data = skb->protocol;
+		*(__be16 *)dest = skb->protocol;
 		break;
 	case NFT_META_PRIORITY:
-		dest->data[0] = skb->priority;
+		dest[0] = skb->priority;
 		break;
 	case NFT_META_MARK:
-		dest->data[0] = skb->mark;
+		dest[0] = skb->mark;
 		break;
 	case NFT_META_IIF:
 		if (in == NULL)
 			goto err;
-		dest->data[0] = in->ifindex;
+		dest[0] = in->ifindex;
 		break;
 	case NFT_META_OIF:
 		if (out == NULL)
 			goto err;
-		dest->data[0] = out->ifindex;
+		dest[0] = out->ifindex;
 		break;
 	case NFT_META_IIFNAME:
 		if (in == NULL)
 			goto err;
-		strncpy((char *)dest->data, in->name, sizeof(dest->data));
+		strncpy((char *)dest, in->name, sizeof(struct nft_data));
 		break;
 	case NFT_META_OIFNAME:
 		if (out == NULL)
 			goto err;
-		strncpy((char *)dest->data, out->name, sizeof(dest->data));
+		strncpy((char *)dest, out->name, sizeof(struct nft_data));
 		break;
 	case NFT_META_IIFTYPE:
 		if (in == NULL)
 			goto err;
-		*(u16 *)dest->data = in->type;
+		*(u16 *)dest = in->type;
 		break;
 	case NFT_META_OIFTYPE:
 		if (out == NULL)
 			goto err;
-		*(u16 *)dest->data = out->type;
+		*(u16 *)dest = out->type;
 		break;
 	case NFT_META_SKUID:
 		if (skb->sk == NULL || skb->sk->sk_state == TCP_TIME_WAIT)
@@ -87,8 +86,7 @@ static void nft_meta_eval(const struct nft_expr *expr,
 			goto err;
 		}
 
-		dest->data[0] =
-			from_kuid_munged(&init_user_ns,
+		dest[0] = from_kuid_munged(&init_user_ns,
 				skb->sk->sk_socket->file->f_cred->fsuid);
 		read_unlock_bh(&skb->sk->sk_callback_lock);
 		break;
@@ -102,8 +100,7 @@ static void nft_meta_eval(const struct nft_expr *expr,
 			read_unlock_bh(&skb->sk->sk_callback_lock);
 			goto err;
 		}
-		dest->data[0] =
-			from_kgid_munged(&init_user_ns,
+		dest[0] = from_kgid_munged(&init_user_ns,
 				 skb->sk->sk_socket->file->f_cred->fsgid);
 		read_unlock_bh(&skb->sk->sk_callback_lock);
 		break;
@@ -113,13 +110,13 @@ static void nft_meta_eval(const struct nft_expr *expr,
 
 		if (dst == NULL)
 			goto err;
-		dest->data[0] = dst->tclassid;
+		dest[0] = dst->tclassid;
 		break;
 	}
 #endif
 #ifdef CONFIG_NETWORK_SECMARK
 	case NFT_META_SECMARK:
-		dest->data[0] = skb->secmark;
+		dest[0] = skb->secmark;
 		break;
 #endif
 	default:
@@ -129,7 +126,7 @@ static void nft_meta_eval(const struct nft_expr *expr,
 	return;
 
 err:
-	data[NFT_REG_VERDICT].verdict = NFT_BREAK;
+	rs->data[NFT_REG_VERDICT].verdict = NFT_BREAK;
 }
 
 static const struct nla_policy nft_meta_policy[NFTA_META_MAX + 1] = {
diff --git a/net/netfilter/nft_nat.c b/net/netfilter/nft_nat.c
index b0b87b2..94df394 100644
--- a/net/netfilter/nft_nat.c
+++ b/net/netfilter/nft_nat.c
@@ -1,6 +1,6 @@
 /*
  * Copyright (c) 2008-2009 Patrick McHardy <kaber@trash.net>
- * Copyright (c) 2012 Pablo Neira Ayuso <pablo@netfilter.org>
+ * Copyright (c) 2012-2013 Pablo Neira Ayuso <pablo@netfilter.org>
  * Copyright (c) 2012 Intel Corporation
  *
  * This program is free software; you can redistribute it and/or modify it
@@ -36,8 +36,7 @@ struct nft_nat {
 };
 
 static void nft_nat_eval(const struct nft_expr *expr,
-			 struct nft_data data[NFT_REG_MAX + 1],
-			 const struct nft_pktinfo *pkt)
+			 union nft_regset *rs, const struct nft_pktinfo *pkt)
 {
 	const struct nft_nat *priv = nft_expr_priv(expr);
 	enum ip_conntrack_info ctinfo;
@@ -46,28 +45,32 @@ static void nft_nat_eval(const struct nft_expr *expr,
 
 	memset(&range, 0, sizeof(range));
 	if (priv->sreg_addr_min) {
+		u32 *addr_min = get_reg_offset(rs, priv->sreg_addr_min),
+		    *addr_max = get_reg_offset(rs, priv->sreg_addr_max);
+
 		if (priv->family == AF_INET) {
-			range.min_addr.ip = data[priv->sreg_addr_min].data[0];
-			range.max_addr.ip = data[priv->sreg_addr_max].data[0];
+			range.min_addr.ip = addr_min[0];
+			range.max_addr.ip = addr_max[0];
 
 		} else {
-			memcpy(range.min_addr.ip6,
-			       data[priv->sreg_addr_min].data,
+			memcpy(range.min_addr.ip6, addr_min,
 			       sizeof(struct nft_data));
-			memcpy(range.max_addr.ip6,
-			       data[priv->sreg_addr_max].data,
+			memcpy(range.max_addr.ip6, addr_max,
 			       sizeof(struct nft_data));
 		}
 		range.flags |= NF_NAT_RANGE_MAP_IPS;
 	}
 
 	if (priv->sreg_proto_min) {
-		range.min_proto.all = data[priv->sreg_proto_min].data[0];
-		range.max_proto.all = data[priv->sreg_proto_max].data[0];
+		u32 *proto_min = get_reg_offset(rs, priv->sreg_proto_min),
+		    *proto_max = get_reg_offset(rs, priv->sreg_proto_max);
+
+		range.min_proto.all = proto_min[0];
+		range.max_proto.all = proto_max[0];
 		range.flags |= NF_NAT_RANGE_PROTO_SPECIFIED;
 	}
 
-	data[NFT_REG_VERDICT].verdict =
+	rs->data[NFT_REG_VERDICT].verdict =
 		nf_nat_setup_info(ct, &range, priv->type);
 }
 
diff --git a/net/netfilter/nft_payload.c b/net/netfilter/nft_payload.c
index a2aeb31..e532445 100644
--- a/net/netfilter/nft_payload.c
+++ b/net/netfilter/nft_payload.c
@@ -17,13 +17,12 @@
 #include <net/netfilter/nf_tables_core.h>
 #include <net/netfilter/nf_tables.h>
 
-static void nft_payload_eval(const struct nft_expr *expr,
-			     struct nft_data data[NFT_REG_MAX + 1],
+static void nft_payload_eval(const struct nft_expr *expr, union nft_regset *rs,
 			     const struct nft_pktinfo *pkt)
 {
 	const struct nft_payload *priv = nft_expr_priv(expr);
 	const struct sk_buff *skb = pkt->skb;
-	struct nft_data *dest = &data[priv->dreg];
+	u32 *dest = get_reg_offset(rs, priv->dreg);
 	int offset;
 
 	switch (priv->base) {
@@ -43,11 +42,11 @@ static void nft_payload_eval(const struct nft_expr *expr,
 	}
 	offset += priv->offset;
 
-	if (skb_copy_bits(skb, offset, dest->data, priv->len) < 0)
+	if (skb_copy_bits(skb, offset, dest, priv->len) < 0)
 		goto err;
 	return;
 err:
-	data[NFT_REG_VERDICT].verdict = NFT_BREAK;
+	rs->data[NFT_REG_VERDICT].verdict = NFT_BREAK;
 }
 
 static const struct nla_policy nft_payload_policy[NFTA_PAYLOAD_MAX + 1] = {
diff --git a/net/netfilter/nft_rbtree.c b/net/netfilter/nft_rbtree.c
index ca0c1b2..f5f8739 100644
--- a/net/netfilter/nft_rbtree.c
+++ b/net/netfilter/nft_rbtree.c
@@ -30,8 +30,7 @@ struct nft_rbtree_elem {
 };
 
 static bool nft_rbtree_lookup(const struct nft_set *set,
-			      const struct nft_data *key,
-			      struct nft_data *data)
+			      const u32 *key, struct nft_data *data)
 {
 	const struct nft_rbtree *priv = nft_set_priv(set);
 	const struct nft_rbtree_elem *rbe, *interval = NULL;
@@ -41,7 +40,7 @@ static bool nft_rbtree_lookup(const struct nft_set *set,
 	while (parent != NULL) {
 		rbe = rb_entry(parent, struct nft_rbtree_elem, node);
 
-		d = nft_data_cmp(&rbe->key, key, set->klen);
+		d = memcmp(&rbe->key, key, set->klen);
 		if (d < 0) {
 			parent = parent->rb_left;
 			interval = rbe;
-- 
1.7.10.4

