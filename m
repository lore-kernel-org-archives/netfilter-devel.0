Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6099CC19F2B
	for <netfilter-devel@archiver.kernel.org>; Fri, 29 Jul 2022 09:31:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231952AbiG2Jbk (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 29 Jul 2022 05:31:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231454AbiG2Jbk (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 29 Jul 2022 05:31:40 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1AB824D4FE
        for <netfilter-devel@vger.kernel.org>; Fri, 29 Jul 2022 02:31:39 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH RFC 3/3] netfilter: nf_tables: add string expression
Date:   Fri, 29 Jul 2022 11:31:29 +0200
Message-Id: <20220729093129.3108-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220729093129.3108-1-pablo@netfilter.org>
References: <20220729093129.3108-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Add string expression to allow to match patterns on packets. These
patterns are specified by an existing string set which uses the
Aho-Corasick tree to store patterns.

This expression allows for a packet base offset to be specified: network,
transport or inner header offset. On top of this, you can specify an offset
range to restrict the pattern search.

This patch uses the existing sequencial read skbuff API to search for
matching patterns.

Currently, it only supports for the NFT_STR_F_PRESENT flags which is
mandatory to test whether a pattern is matching the payload. This leaves
room to extend this expression to support for more new matching modes in
the future.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h        |   4 +
 include/net/netfilter/nf_tables_core.h   |   1 +
 include/uapi/linux/netfilter/nf_tables.h |  26 +++
 net/netfilter/Makefile                   |   1 +
 net/netfilter/nf_tables_api.c            |   7 +-
 net/netfilter/nf_tables_core.c           |   1 +
 net/netfilter/nft_string.c               | 254 +++++++++++++++++++++++
 7 files changed, 290 insertions(+), 4 deletions(-)
 create mode 100644 net/netfilter/nft_string.c

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index c4e9a969122a..20e12a881246 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1365,6 +1365,10 @@ struct nft_strset {
 	u32				use;
 };
 
+struct nft_strset *nft_strset_lookup(const struct net *net,
+				     struct nft_table *table,
+				     const struct nlattr *nla, u8 genmask);
+
 /**
  *	struct nft_traceinfo - nft tracing information and state
  *
diff --git a/include/net/netfilter/nf_tables_core.h b/include/net/netfilter/nf_tables_core.h
index 0ea7c55cea4d..f5a4bef2afba 100644
--- a/include/net/netfilter/nf_tables_core.h
+++ b/include/net/netfilter/nf_tables_core.h
@@ -12,6 +12,7 @@ extern struct nft_expr_type nft_lookup_type;
 extern struct nft_expr_type nft_bitwise_type;
 extern struct nft_expr_type nft_byteorder_type;
 extern struct nft_expr_type nft_payload_type;
+extern struct nft_expr_type nft_string_type;
 extern struct nft_expr_type nft_dynset_type;
 extern struct nft_expr_type nft_range_type;
 extern struct nft_expr_type nft_meta_type;
diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index d7a668199611..8ce2400952c0 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -1711,6 +1711,32 @@ enum nft_string_hook_attributes {
 };
 #define NFTA_STRING_MAX	(__NFTA_STRING_MAX - 1)
 
+enum nft_string_flags {
+	NFT_STR_F_PRESENT = (1 << 0),
+};
+
+/**
+ * enum nft_str_hook_attributes - nf_tables string expression netlink attributes
+ *
+ * @NFTA_STR_NAME: string set name (NLA_STRING)
+ * @NFTA_STR_BASE: payload base (NLA_U32: nft_payload_bases)
+ * @NFTA_STR_FROM: offset to start matching from (NLA_U32)
+ * @NFTA_STR_TO: offset to end matching to (NLA_U32)
+ * @NFTA_STR_DREG: destination register (NLA_U32: nft_registers)
+ * @NFTA_STR_FLAGS: flags (NLA_U32)
+ */
+enum nft_str_hook_attributes {
+	NFTA_STR_UNSPEC,
+	NFTA_STR_NAME,
+	NFTA_STR_BASE,
+	NFTA_STR_FROM,
+	NFTA_STR_TO,
+	NFTA_STR_DREG,
+	NFTA_STR_FLAGS,
+	__NFTA_STR_MAX
+};
+#define NFTA_STR_MAX	(__NFTA_STR_MAX - 1)
+
 /**
  * enum nft_osf_attributes - nftables osf expression netlink attributes
  *
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index 18127c83b88c..47ed19be4ac6 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -91,6 +91,7 @@ endif
 endif
 
 nf_tables-$(CONFIG_NFT_STRING)	+= ahocorasick.o
+nf_tables-$(CONFIG_NFT_STRING)	+= nft_string.o
 
 obj-$(CONFIG_NF_TABLES)		+= nf_tables.o
 obj-$(CONFIG_NFT_COMPAT)	+= nft_compat.o
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 736bdf6b9671..854ee78884aa 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -8117,10 +8117,9 @@ static const struct nla_policy nft_strset_policy[NFTA_STRSET_MAX + 1] = {
 	[NFTA_STRSET_HANDLE]	= { .type = NLA_U64 },
 };
 
-static struct nft_strset *nft_strset_lookup(const struct net *net,
-					    struct nft_table *table,
-					    const struct nlattr *nla,
-					    u8 genmask)
+struct nft_strset *nft_strset_lookup(const struct net *net,
+				     struct nft_table *table,
+				     const struct nlattr *nla, u8 genmask)
 {
 	struct nft_strset *strset;
 
diff --git a/net/netfilter/nf_tables_core.c b/net/netfilter/nf_tables_core.c
index 3ddce24ac76d..ffa413378d7a 100644
--- a/net/netfilter/nf_tables_core.c
+++ b/net/netfilter/nf_tables_core.c
@@ -336,6 +336,7 @@ static struct nft_expr_type *nft_basic_types[] = {
 	&nft_payload_type,
 	&nft_dynset_type,
 	&nft_range_type,
+	&nft_string_type,
 	&nft_meta_type,
 	&nft_rt_type,
 	&nft_exthdr_type,
diff --git a/net/netfilter/nft_string.c b/net/netfilter/nft_string.c
new file mode 100644
index 000000000000..e3bf4be59c7c
--- /dev/null
+++ b/net/netfilter/nft_string.c
@@ -0,0 +1,254 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (c) 2022 Pablo Neira Ayuso <pablo@netfilter.org>
+ */
+
+#include <linux/kernel.h>
+#include <linux/netlink.h>
+#include <linux/netfilter.h>
+#include <linux/netfilter/nf_tables.h>
+#include <net/netfilter/nf_tables.h>
+#include <net/netfilter/nf_tables_core.h>
+#include <net/netfilter/ahocorasick.h>
+#include <linux/tcp.h>
+#include <linux/udp.h>
+
+struct nft_string {
+	struct nft_strset	*strset;
+	u8			dreg;
+	u8			base;
+	u8			flags;
+	u32			from;
+	u32			to;
+};
+
+static int __nft_payload_inner_offset(struct nft_pktinfo *pkt)
+{
+	unsigned int thoff = nft_thoff(pkt);
+
+	if (!(pkt->flags & NFT_PKTINFO_L4PROTO) || pkt->fragoff)
+		return -1;
+
+	switch (pkt->tprot) {
+	case IPPROTO_UDP:
+		pkt->inneroff = thoff + sizeof(struct udphdr);
+		break;
+	case IPPROTO_TCP: {
+		struct tcphdr *th, _tcph;
+
+		th = skb_header_pointer(pkt->skb, thoff, sizeof(_tcph), &_tcph);
+		if (!th)
+			return -1;
+
+		pkt->inneroff = thoff + __tcp_hdrlen(th);
+		}
+		break;
+	default:
+		return -1;
+	}
+
+	pkt->flags |= NFT_PKTINFO_INNER;
+
+	return 0;
+}
+
+static int nft_payload_inner_offset(const struct nft_pktinfo *pkt)
+{
+	if (!(pkt->flags & NFT_PKTINFO_INNER) &&
+	    __nft_payload_inner_offset((struct nft_pktinfo *)pkt) < 0)
+		return -1;
+
+	return pkt->inneroff;
+}
+
+static int nft_string_base(const struct nft_string *priv,
+			   const struct nft_pktinfo *pkt)
+{
+	int base_offset;
+
+	switch (priv->base) {
+	case NFT_PAYLOAD_NETWORK_HEADER:
+		base_offset = skb_network_offset(pkt->skb);
+		break;
+	case NFT_PAYLOAD_TRANSPORT_HEADER:
+		base_offset = skb_transport_offset(pkt->skb);
+		break;
+	case NFT_PAYLOAD_INNER_HEADER:
+		if (nft_payload_inner_offset(pkt))
+			base_offset = pkt->inneroff;
+		else
+			base_offset = 0;
+		break;
+	default:
+		WARN_ON_ONCE(1);
+		break;
+	}
+
+	if (WARN_ON_ONCE(base_offset < 0))
+		base_offset = 0;
+
+	return base_offset;
+}
+
+static void nft_string_eval(const struct nft_expr *expr,
+			    struct nft_regs *regs,
+			    const struct nft_pktinfo *pkt)
+{
+	const struct nft_string *priv = nft_expr_priv(expr);
+	bool genbit = READ_ONCE(nft_net(pkt)->nft.gencursor);
+	u32 *dest = &regs->data[priv->dreg];
+	unsigned int consumed = 0, len;
+	struct sk_buff *skb = pkt->skb;
+	struct ac_tree __rcu *tree;
+	struct skb_seq_state state;
+	int base_offset, pos = -1;
+	const u8 *data;
+	u32 from, to;
+
+	base_offset = nft_string_base(priv, pkt);
+	if (priv->from + base_offset < priv->from)
+		from = priv->from;
+	else
+		from = priv->from + base_offset;
+
+	if (priv->to + base_offset < priv->to)
+		to = priv->to;
+	else
+		to = priv->to + base_offset;
+
+	skb_prepare_seq_read(skb, from, to, &state);
+
+	tree = rcu_dereference(priv->strset->tree[genbit]);
+
+	len = skb_seq_read(consumed, &data, &state);
+	while (len > 0) {
+		pos = ac_find(tree, data, len);
+		if (pos >= 0)
+			break;
+
+		consumed += len;
+		len = skb_seq_read(consumed, &data, &state);
+	}
+	skb_abort_seq_read(&state);
+
+	if (pos < 0)
+		*dest = 0;
+	else
+		*dest = 1;
+}
+
+static const struct nla_policy nft_string_policy[NFTA_STR_MAX + 1] = {
+	[NFTA_STR_DREG]		= { .type = NLA_U32 },
+	[NFTA_STR_NAME]		= { .type = NLA_STRING },
+	[NFTA_STR_BASE]		= { .type = NLA_U32 },
+	[NFTA_STR_FROM]		= { .type = NLA_U32 },
+	[NFTA_STR_TO]		= { .type = NLA_U32 },
+	[NFTA_STR_FLAGS]	= { .type = NLA_U32 },
+};
+
+static int nft_string_init(const struct nft_ctx *ctx,
+			   const struct nft_expr *expr,
+			   const struct nlattr * const tb[])
+{
+	struct nft_string *priv = nft_expr_priv(expr);
+	u8 genmask = nft_genmask_next(ctx->net);
+	uint32_t from, to, flags, base;
+	struct nft_strset *strset;
+	int err;
+
+	if (!tb[NFTA_STR_NAME] ||
+	    !tb[NFTA_STR_BASE] ||
+	    !tb[NFTA_STR_FROM] ||
+	    !tb[NFTA_STR_TO] ||
+	    !tb[NFTA_STR_DREG] ||
+	    !tb[NFTA_STR_FLAGS])
+		return -EINVAL;
+
+	from = ntohl(nla_get_be32(tb[NFTA_STR_FROM]));
+	to = ntohl(nla_get_be32(tb[NFTA_STR_TO]));
+	if (from > to)
+		return -EINVAL;
+
+	flags = ntohl(nla_get_be32(tb[NFTA_STR_FLAGS]));
+	if (flags & ~NFT_STR_F_PRESENT)
+		return -EOPNOTSUPP;
+	else if (flags == 0)	/* always NFT_STR_F_PRESENT set on by now. */
+		return -EOPNOTSUPP;
+
+	base = ntohl(nla_get_be32(tb[NFTA_STR_BASE]));
+	switch (base) {
+	case NFT_PAYLOAD_NETWORK_HEADER:
+	case NFT_PAYLOAD_TRANSPORT_HEADER:
+	case NFT_PAYLOAD_INNER_HEADER:
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+	priv->base = base;
+
+	err = nft_parse_register_store(ctx, tb[NFTA_STR_DREG], &priv->dreg,
+				       NULL, NFT_DATA_VALUE, sizeof(u32));
+	if (err < 0)
+		return err;
+
+	strset = nft_strset_lookup(ctx->net, ctx->table, tb[NFTA_STR_NAME],
+				   genmask);
+	if (IS_ERR(strset))
+		return PTR_ERR(strset);
+
+	strset->use++;
+
+	priv->strset = strset;
+	priv->from = from;
+	priv->to = to;
+
+	return 0;
+}
+
+static void nft_string_destroy(const struct nft_ctx *ctx,
+			       const struct nft_expr *expr)
+{
+	const struct nft_string *priv = nft_expr_priv(expr);
+
+	priv->strset->use--;
+}
+
+static int nft_string_dump(struct sk_buff *skb,
+			   const struct nft_expr *expr)
+{
+	const struct nft_string *priv = nft_expr_priv(expr);
+
+	if (nla_put_string(skb, NFTA_STR_NAME, priv->strset->name))
+		goto nla_put_failure;
+	if (nla_put_be32(skb, NFTA_STR_BASE, htonl(priv->base)))
+		goto nla_put_failure;
+	if (nla_put_be32(skb, NFTA_STR_FROM, htonl(priv->from)))
+		goto nla_put_failure;
+	if (nla_put_be32(skb, NFTA_STR_TO, htonl(priv->to)))
+		goto nla_put_failure;
+	if (nla_put_be32(skb, NFTA_STR_FLAGS, htonl(priv->flags)))
+		goto nla_put_failure;
+	if (nft_dump_register(skb, NFTA_STR_DREG, priv->dreg))
+		goto nla_put_failure;
+	return 0;
+
+nla_put_failure:
+	return -1;
+}
+
+static const struct nft_expr_ops nft_string_get_ops = {
+	.type		= &nft_string_type,
+	.size		= NFT_EXPR_SIZE(sizeof(struct nft_string)),
+	.eval		= nft_string_eval,
+	.init		= nft_string_init,
+	.destroy	= nft_string_destroy,
+	.dump		= nft_string_dump,
+};
+
+struct nft_expr_type nft_string_type __read_mostly = {
+	.name		= "string",
+	.ops		= &nft_string_get_ops,
+	.policy		= nft_string_policy,
+	.maxattr	= NFTA_STR_MAX,
+	.owner		= THIS_MODULE,
+};
-- 
2.30.2

