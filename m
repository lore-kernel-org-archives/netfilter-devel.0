Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9747BC54EE9
	for <netfilter-devel@archiver.kernel.org>; Fri, 16 Sep 2022 11:48:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229745AbiIPLsL (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 16 Sep 2022 07:48:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230470AbiIPLsH (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 16 Sep 2022 07:48:07 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 60EFCAE861
        for <netfilter-devel@vger.kernel.org>; Fri, 16 Sep 2022 04:48:02 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next,RFC 1/1] netfilter: nft_inner: support for inner header matching
Date:   Fri, 16 Sep 2022 13:47:54 +0200
Message-Id: <20220916114754.31913-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220916114754.31913-1-pablo@netfilter.org>
References: <20220916114754.31913-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This new expression allows you to match on the inner headers that is
encapsulated by any of the tunneling protocols.

Basically, the idea is to update the link, network and transport offsets
that are provided by nft_pktinfo, so the existing expressions (with little
updates) can be reused to match on the inner headers.

The expression supports for different tunnel combinations such as:

- ethernet frame over IPv4/IPv6 packet, eg. VxLAN.
- IPv4/IPv6 packet over IPv4/IPv6 packet, eg. IPIP.
- IPv4/IPv6 packet over IPv4/IPv6 + transport header, eg. GRE.
- transport header (ESP or SCTP) over transport header (usually UDP)

Currently it only supports for the payload expression, but it should be
possible to extend it to support for the meta expression too, hence,
matching on inner meta protocol and l4proto reports the inner header, as
well as extension headers.

The new inner expression parses the inner header based on the template
description provided by userspace.

- flags: to describe how to parse the inner packet:

  NFT_PAYLOAD_CTX_INNER_TUN, the tunnel provides its own header.
  NFT_PAYLOAD_CTX_INNER_ETHER, the ethernet frame is available as inner header.
  NFT_PAYLOAD_CTX_INNER_NH, the network header is available as inner header.
  NFT_PAYLOAD_CTX_INNER_TH, the transport header is available as inner header.

For example, VxLAN sets on all these flags. While GRE only sets on
NFT_PAYLOAD_CTX_INNER_NH and NFT_PAYLOAD_CTX_INNER_TH, because the GRE tunnel
header comes as an outer transport header offset to match on it.

- header size: in case the tunnel comes with its own header. Only used for
  VxLAN and Geneve since they come over UDP.

- type: this provides a hint to userspace on how to delinearize the rule.
  This is useful for VxLAN and Geneve since they run over UDP, since
  transport does not provide a hint. This is also useful in case hardware
  offload is ever supported. The type is not currently interpreted by the
  kernel.

- expected inner layer 3 protocol (via INNER_NFPROTO), either IPv4 or IPv6.
  NFPROTO_INET is used to allow for both.

- expression: currently only payload supported. The meta and exthdr
  expressions should be supported too. There is a new expression operation
  that needs to be registers via inner_ops which uses the inner header
  offsets.

There is a new NFT_PAYLOAD_TUN_HEADER base which allows to match on the
tunnel header fields, eg. vxlan vni.

The inner expression is embedded into nft_inner private area and it is
passed to the payload inner eval call.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h        |   5 +
 include/net/netfilter/nf_tables_core.h   |  22 ++
 include/uapi/linux/netfilter/nf_tables.h |  27 ++
 net/netfilter/Makefile                   |   2 +-
 net/netfilter/nf_tables_api.c            |  37 +++
 net/netfilter/nf_tables_core.c           |   1 +
 net/netfilter/nft_inner.c                | 303 +++++++++++++++++++++++
 net/netfilter/nft_payload.c              | 113 ++++++++-
 8 files changed, 508 insertions(+), 2 deletions(-)
 create mode 100644 net/netfilter/nft_inner.c

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index cdb7db9b0e25..c5827f8a0010 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -375,6 +375,10 @@ static inline void *nft_expr_priv(const struct nft_expr *expr)
 	return (void *)expr->data;
 }
 
+struct nft_expr_info;
+
+int nft_expr_inner_parse(const struct nft_ctx *ctx, const struct nlattr *nla,
+			 struct nft_expr_info *info);
 int nft_expr_clone(struct nft_expr *dst, struct nft_expr *src);
 void nft_expr_destroy(const struct nft_ctx *ctx, struct nft_expr *expr);
 int nft_expr_dump(struct sk_buff *skb, unsigned int attr,
@@ -864,6 +868,7 @@ struct nft_expr_type {
 						       const struct nlattr * const tb[]);
 	void				(*release_ops)(const struct nft_expr_ops *ops);
 	const struct nft_expr_ops	*ops;
+	const struct nft_expr_ops	*inner_ops;
 	struct list_head		list;
 	const char			*name;
 	struct module			*owner;
diff --git a/include/net/netfilter/nf_tables_core.h b/include/net/netfilter/nf_tables_core.h
index 990c3767a350..1e1e6f54d56a 100644
--- a/include/net/netfilter/nf_tables_core.h
+++ b/include/net/netfilter/nf_tables_core.h
@@ -18,6 +18,7 @@ extern struct nft_expr_type nft_meta_type;
 extern struct nft_expr_type nft_rt_type;
 extern struct nft_expr_type nft_exthdr_type;
 extern struct nft_expr_type nft_last_type;
+extern struct nft_expr_type nft_inner_type;
 
 #ifdef CONFIG_NETWORK_SECMARK
 extern struct nft_object_type nft_secmark_obj_type;
@@ -138,4 +139,25 @@ void nft_rt_get_eval(const struct nft_expr *expr,
 		     struct nft_regs *regs, const struct nft_pktinfo *pkt);
 void nft_counter_eval(const struct nft_expr *expr, struct nft_regs *regs,
                       const struct nft_pktinfo *pkt);
+
+enum {
+	NFT_PAYLOAD_CTX_INNER_TUN	= (1 << 0),
+	NFT_PAYLOAD_CTX_INNER_LL	= (1 << 1),
+	NFT_PAYLOAD_CTX_INNER_NH	= (1 << 2),
+	NFT_PAYLOAD_CTX_INNER_TH	= (1 << 3),
+};
+
+struct nft_inner_tun_ctx {
+	u8	inner_tunoff;
+	u8	inner_lloff;
+	u8	inner_nhoff;
+	u8	inner_thoff;
+	u8      flags;
+};
+
+int nft_payload_inner_offset(const struct nft_pktinfo *pkt);
+void nft_payload_inner_eval(const struct nft_expr *expr, struct nft_regs *regs,
+			    const struct nft_pktinfo *pkt,
+			    struct nft_inner_tun_ctx *ctx);
+
 #endif /* _NET_NF_TABLES_CORE_H */
diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 466fd3f4447c..4c92ff2e83be 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -760,6 +760,7 @@ enum nft_payload_bases {
 	NFT_PAYLOAD_NETWORK_HEADER,
 	NFT_PAYLOAD_TRANSPORT_HEADER,
 	NFT_PAYLOAD_INNER_HEADER,
+	NFT_PAYLOAD_TUN_HEADER,
 };
 
 /**
@@ -779,6 +780,32 @@ enum nft_payload_csum_flags {
 	NFT_PAYLOAD_L4CSUM_PSEUDOHDR = (1 << 0),
 };
 
+enum nft_inner_type {
+	NFT_INNER_UNSPEC	= 0,
+	NFT_INNER_VXLAN,
+};
+
+enum nft_inner_flags {
+	NFT_INNER_HDRSIZE	= (1 << 0),
+	NFT_INNER_LL		= (1 << 1),
+	NFT_INNER_NH		= (1 << 2),
+	NFT_INNER_TH		= (1 << 3),
+};
+#define NFT_INNER_MASK		(NFT_INNER_HDRSIZE | NFT_INNER_LL | \
+				 NFT_INNER_NH |  NFT_INNER_TH)
+
+enum nft_inner_attributes {
+	NFTA_INNER_UNSPEC,
+	NFTA_INNER_NUM,
+	NFTA_INNER_TYPE,
+	NFTA_INNER_FLAGS,
+	NFTA_INNER_HDRSIZE,
+	NFTA_INNER_NFPROTO,
+	NFTA_INNER_EXPR,
+	__NFTA_INNER_MAX
+};
+#define NFTA_INNER_MAX	(__NFTA_INNER_MAX - 1)
+
 /**
  * enum nft_payload_attributes - nf_tables payload expression netlink attributes
  *
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index 06df49ea6329..2079650eb8ee 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -82,7 +82,7 @@ nf_tables-objs := nf_tables_core.o nf_tables_api.o nft_chain_filter.o \
 		  nft_dynset.o nft_meta.o nft_rt.o nft_exthdr.o nft_last.o \
 		  nft_counter.o nft_chain_route.o nf_tables_offload.o \
 		  nft_set_hash.o nft_set_bitmap.o nft_set_rbtree.o \
-		  nft_set_pipapo.o
+		  nft_set_pipapo.o nft_inner.o
 
 ifdef CONFIG_X86_64
 ifndef CONFIG_UML
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 816052089b33..5fb783d09012 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2857,6 +2857,43 @@ static int nf_tables_expr_parse(const struct nft_ctx *ctx,
 	return err;
 }
 
+int nft_expr_inner_parse(const struct nft_ctx *ctx, const struct nlattr *nla,
+			 struct nft_expr_info *info)
+{
+	struct nlattr *tb[NFTA_EXPR_MAX + 1];
+	const struct nft_expr_type *type;
+	int err;
+
+	err = nla_parse_nested_deprecated(tb, NFTA_EXPR_MAX, nla,
+					  nft_expr_policy, NULL);
+	if (err < 0)
+		return err;
+
+	if (!tb[NFTA_EXPR_DATA])
+		return -EINVAL;
+
+	type = __nft_expr_type_get(ctx->family, tb[NFTA_EXPR_NAME]);
+	if (IS_ERR(type))
+		return PTR_ERR(type);
+
+	if (!type->inner_ops)
+		return -EOPNOTSUPP;
+
+	err = nla_parse_nested_deprecated(info->tb, type->maxattr,
+					  tb[NFTA_EXPR_DATA],
+					  type->policy, NULL);
+	if (err < 0)
+		goto err_nla_parse;
+
+	info->attr = nla;
+	info->ops = type->inner_ops;
+
+	return 0;
+
+err_nla_parse:
+	return err;
+}
+
 static int nf_tables_newexpr(const struct nft_ctx *ctx,
 			     const struct nft_expr_info *expr_info,
 			     struct nft_expr *expr)
diff --git a/net/netfilter/nf_tables_core.c b/net/netfilter/nf_tables_core.c
index cee3e4e905ec..75580517f385 100644
--- a/net/netfilter/nf_tables_core.c
+++ b/net/netfilter/nf_tables_core.c
@@ -340,6 +340,7 @@ static struct nft_expr_type *nft_basic_types[] = {
 	&nft_exthdr_type,
 	&nft_last_type,
 	&nft_counter_type,
+	&nft_inner_type,
 };
 
 static struct nft_object_type *nft_basic_objects[] = {
diff --git a/net/netfilter/nft_inner.c b/net/netfilter/nft_inner.c
new file mode 100644
index 000000000000..081d0ee43e0f
--- /dev/null
+++ b/net/netfilter/nft_inner.c
@@ -0,0 +1,303 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (c) 2022 Pablo Neira Ayuso <pablo@netfilter.org>
+ */
+
+#include <linux/kernel.h>
+#include <linux/if_vlan.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/netlink.h>
+#include <linux/netfilter.h>
+#include <linux/netfilter/nf_tables.h>
+#include <net/netfilter/nf_tables_core.h>
+#include <net/netfilter/nf_tables.h>
+#include <net/netfilter/nf_tables_offload.h>
+#include <linux/tcp.h>
+#include <linux/udp.h>
+#include <net/gre.h>
+#include <net/ip.h>
+#include <linux/icmpv6.h>
+#include <linux/ip.h>
+#include <linux/ipv6.h>
+
+struct __nft_expr {
+	const struct nft_expr_ops	*ops;
+	union {
+		struct nft_payload	payload;
+	} __attribute__((aligned(__alignof__(u64))));
+};
+
+struct nft_inner {
+	u8			flags;
+	u8			hdrsize;
+	u8			nfproto;
+	u8			type;
+
+	struct __nft_expr	expr;
+};
+
+static int nft_inner_parse_l2l3(const struct nft_inner *priv,
+				const struct nft_pktinfo *pkt,
+				struct nft_inner_tun_ctx *ctx, u32 off)
+{
+	u32 nhoff, thoff;
+	u16 llproto;
+
+	if (priv->flags & NFT_INNER_LL) {
+		struct ethhdr *eth, _eth;
+
+		eth = skb_header_pointer(pkt->skb, off, sizeof(_eth), &_eth);
+		if (!eth)
+			return -1;
+
+		switch (eth->h_proto) {
+		case htons(ETH_P_IP):
+		case htons(ETH_P_IPV6):
+			break;
+		default:
+			return -1;
+		}
+
+		llproto = ntohs(eth->h_proto);
+		ctx->inner_lloff = off - pkt->inneroff;
+		ctx->flags |= NFT_PAYLOAD_CTX_INNER_LL;
+
+		off += sizeof(_eth);
+	} else {
+		struct iphdr *iph;
+		u32 _version;
+
+		iph = skb_header_pointer(pkt->skb, off, sizeof(_version), &_version);
+		if (!iph)
+			return -1;
+
+		switch (iph->version) {
+		case 4:
+			llproto = ETH_P_IP;
+			break;
+		case 6:
+			llproto = ETH_P_IPV6;
+			break;
+		default:
+			return -1;
+		}
+	}
+
+	nhoff = off;
+
+	switch (llproto) {
+	case ETH_P_IP: {
+		struct iphdr *iph, _iph;
+
+		iph = skb_header_pointer(pkt->skb, nhoff, sizeof(_iph), &_iph);
+		if (!iph)
+			return -1;
+
+		if (iph->ihl < 5 || iph->version != 4)
+			return -1;
+
+		ctx->inner_nhoff = nhoff - pkt->inneroff;
+		ctx->flags |= NFT_PAYLOAD_CTX_INNER_NH;
+
+		if ((ntohs(iph->frag_off) & IP_OFFSET) == 0) {
+			ctx->flags |= NFT_PAYLOAD_CTX_INNER_TH;
+			ctx->inner_thoff = nhoff + (iph->ihl * 4);
+		}
+		break;
+		}
+	case ETH_P_IPV6: {
+		struct ipv6hdr *ip6h, _ip6h;
+		int fh_flags = IP6_FH_F_AUTH;
+		unsigned short frag_off;
+		int l4proto;
+
+		ip6h = skb_header_pointer(pkt->skb, nhoff, sizeof(_ip6h), &_ip6h);
+		if (!ip6h)
+			return -1;
+
+		if (ip6h->version != 6)
+			return -1;
+
+		ctx->inner_nhoff = nhoff - pkt->inneroff;
+		ctx->flags |= NFT_PAYLOAD_CTX_INNER_NH;
+
+		thoff = nhoff;
+		l4proto = ipv6_find_hdr(pkt->skb, &thoff, -1, &frag_off, &fh_flags);
+		if (l4proto < 0)
+			return -1;
+
+		if (frag_off == 0) {
+			thoff = nhoff + sizeof(_ip6h);
+			ctx->flags |= NFT_PAYLOAD_CTX_INNER_TH;
+			ctx->inner_thoff = thoff - pkt->inneroff;
+		}
+		break;
+		}
+	default:
+		return -1;
+	}
+
+	return 0;
+}
+
+static int nft_inner_parse(const struct nft_inner *priv,
+			   const struct nft_pktinfo *pkt,
+			   struct nft_inner_tun_ctx *ctx)
+{
+	u32 off = pkt->inneroff;
+
+	if (priv->flags & NFT_INNER_HDRSIZE) {
+		ctx->inner_tunoff = off - pkt->inneroff;
+		ctx->flags |= NFT_PAYLOAD_CTX_INNER_TUN;
+		off += priv->hdrsize;
+	}
+
+	if (priv->flags & (NFT_INNER_LL | NFT_INNER_NH) &&
+	    nft_inner_parse_l2l3(priv, pkt, ctx, off) < 0)
+		return -1;
+	else if (priv->flags & NFT_INNER_TH) {
+		ctx->inner_thoff = off - pkt->inneroff;
+		ctx->flags |= NFT_PAYLOAD_CTX_INNER_TH;
+	}
+
+	return 0;
+}
+
+static void nft_inner_eval(const struct nft_expr *expr, struct nft_regs *regs,
+			   const struct nft_pktinfo *pkt)
+{
+	const struct nft_inner *priv = nft_expr_priv(expr);
+	struct nft_inner_tun_ctx tun_ctx = {};
+
+	if (nft_payload_inner_offset(pkt) < 0)
+		goto err;
+
+	if (nft_inner_parse(priv, pkt, &tun_ctx) < 0)
+		goto err;
+
+	nft_payload_inner_eval((struct nft_expr *)&priv->expr, regs, pkt, &tun_ctx);
+	return;
+err:
+	regs->verdict.code = NFT_BREAK;
+}
+
+static const struct nla_policy nft_inner_policy[NFTA_INNER_MAX + 1] = {
+	[NFTA_INNER_NUM]	= { .type = NLA_U32 },
+	[NFTA_INNER_FLAGS]	= { .type = NLA_U32 },
+	[NFTA_INNER_NFPROTO]	= { .type = NLA_U32 },
+	[NFTA_INNER_HDRSIZE]	= { .type = NLA_U32 },
+	[NFTA_INNER_TYPE]	= { .type = NLA_U32 },
+	[NFTA_INNER_EXPR]	= { .type = NLA_NESTED },
+};
+
+struct nft_expr_info {
+	const struct nft_expr_ops	*ops;
+	const struct nlattr		*attr;
+	struct nlattr			*tb[NFT_EXPR_MAXATTR + 1];
+};
+
+static int nft_inner_init(const struct nft_ctx *ctx,
+			  const struct nft_expr *expr,
+			  const struct nlattr * const tb[])
+{
+	struct nft_inner *priv = nft_expr_priv(expr);
+	u32 flags, hdrsize, nfproto, type, num;
+	struct nft_expr_info expr_info;
+	int err;
+
+	if (!tb[NFTA_INNER_FLAGS] ||
+	    !tb[NFTA_INNER_NFPROTO] ||
+	    !tb[NFTA_INNER_HDRSIZE] ||
+	    !tb[NFTA_INNER_TYPE] ||
+	    !tb[NFTA_INNER_EXPR])
+		return -EINVAL;
+
+	flags = ntohl(nla_get_be32(tb[NFTA_INNER_FLAGS]));
+	if (flags & ~NFT_INNER_MASK)
+		return -EOPNOTSUPP;
+
+	num = ntohl(nla_get_be32(tb[NFTA_INNER_NUM]));
+	if (num != 0)
+		return -EOPNOTSUPP;
+
+	nfproto = ntohl(nla_get_be32(tb[NFTA_INNER_NFPROTO]));
+	hdrsize = ntohl(nla_get_be32(tb[NFTA_INNER_HDRSIZE]));
+	type = ntohl(nla_get_be32(tb[NFTA_INNER_TYPE]));
+
+	if (type > U8_MAX)
+		return -EINVAL;
+
+	if (flags & NFT_INNER_HDRSIZE) {
+		if (hdrsize == 0 || hdrsize > 64)
+			return -EOPNOTSUPP;
+	}
+
+	switch (nfproto) {
+	case NFPROTO_IPV4:
+	case NFPROTO_IPV6:
+	case NFPROTO_INET:
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	priv->flags = flags;
+	priv->nfproto = nfproto;
+	priv->hdrsize = hdrsize;
+	priv->type = type;
+
+	err = nft_expr_inner_parse(ctx, tb[NFTA_INNER_EXPR], &expr_info);
+	if (err < 0)
+		return err;
+
+	priv->expr.ops = expr_info.ops;
+
+	err = expr_info.ops->init(ctx, (struct nft_expr *)&priv->expr,
+				  (const struct nlattr * const*)expr_info.tb);
+	if (err < 0)
+		return err;
+
+	if (nfproto == NFPROTO_INET &&
+	    priv->expr.payload.base == NFT_PAYLOAD_NETWORK_HEADER)
+		return -EOPNOTSUPP;
+
+	return 0;
+}
+
+static int nft_inner_dump(struct sk_buff *skb, const struct nft_expr *expr)
+{
+	const struct nft_inner *priv = nft_expr_priv(expr);
+
+	if (nla_put_be32(skb, NFTA_INNER_NUM, htonl(0)) ||
+	    nla_put_be32(skb, NFTA_INNER_TYPE, htonl(priv->type)) ||
+	    nla_put_be32(skb, NFTA_INNER_FLAGS, htonl(priv->flags)) ||
+	    nla_put_be32(skb, NFTA_INNER_NFPROTO, htonl(priv->nfproto)) ||
+	    nla_put_be32(skb, NFTA_INNER_HDRSIZE, htonl(priv->hdrsize)))
+		goto nla_put_failure;
+
+	if (nft_expr_dump(skb, NFTA_INNER_EXPR,
+			  (struct nft_expr *)&priv->expr) < 0)
+		goto nla_put_failure;
+
+	return 0;
+
+nla_put_failure:
+	return -1;
+}
+
+static const struct nft_expr_ops nft_inner_ops = {
+	.type		= &nft_inner_type,
+	.size		= NFT_EXPR_SIZE(sizeof(struct nft_inner)),
+	.eval		= nft_inner_eval,
+	.init		= nft_inner_init,
+	.dump		= nft_inner_dump,
+};
+
+struct nft_expr_type nft_inner_type __read_mostly = {
+	.name		= "inner",
+	.ops		= &nft_inner_ops,
+	.policy		= nft_inner_policy,
+	.maxattr	= NFTA_INNER_MAX,
+	.owner		= THIS_MODULE,
+};
diff --git a/net/netfilter/nft_payload.c b/net/netfilter/nft_payload.c
index 47425ccd9fae..66d7254868ca 100644
--- a/net/netfilter/nft_payload.c
+++ b/net/netfilter/nft_payload.c
@@ -116,7 +116,7 @@ static int __nft_payload_inner_offset(struct nft_pktinfo *pkt)
 	return 0;
 }
 
-static int nft_payload_inner_offset(const struct nft_pktinfo *pkt)
+int nft_payload_inner_offset(const struct nft_pktinfo *pkt)
 {
 	if (!(pkt->flags & NFT_PKTINFO_INNER) &&
 	    __nft_payload_inner_offset((struct nft_pktinfo *)pkt) < 0)
@@ -559,6 +559,116 @@ const struct nft_expr_ops nft_payload_fast_ops = {
 	.offload	= nft_payload_offload,
 };
 
+void nft_payload_inner_eval(const struct nft_expr *expr, struct nft_regs *regs,
+			    const struct nft_pktinfo *pkt,
+			    struct nft_inner_tun_ctx *tun_ctx)
+{
+	const struct nft_payload *priv = nft_expr_priv(expr);
+	const struct sk_buff *skb = pkt->skb;
+	u32 *dest = &regs->data[priv->dreg];
+	int offset;
+
+	pr_info("> inner eval\n");
+
+	if (priv->len % NFT_REG32_SIZE)
+		dest[priv->len / NFT_REG32_SIZE] = 0;
+
+	switch (priv->base) {
+	case NFT_PAYLOAD_TUN_HEADER:
+		if (!(tun_ctx->flags & NFT_PAYLOAD_CTX_INNER_TUN))
+			goto err;
+
+		offset = pkt->inneroff + tun_ctx->inner_tunoff;
+		break;
+	case NFT_PAYLOAD_LL_HEADER:
+		if (!(tun_ctx->flags & NFT_PAYLOAD_CTX_INNER_LL))
+			goto err;
+
+		offset = pkt->inneroff + tun_ctx->inner_lloff;
+		break;
+	case NFT_PAYLOAD_NETWORK_HEADER:
+		if (!(tun_ctx->flags & NFT_PAYLOAD_CTX_INNER_NH)) {
+			pr_info(">> no inner nh\n");
+			goto err;
+		}
+
+		offset = pkt->inneroff + tun_ctx->inner_nhoff;
+		pr_info("> inner match nh offset %u\n", offset);
+		break;
+	case NFT_PAYLOAD_TRANSPORT_HEADER:
+		if (!(pkt->flags & NFT_PAYLOAD_CTX_INNER_TH))
+			goto err;
+
+		offset = pkt->inneroff + tun_ctx->inner_thoff;
+		break;
+	default:
+		WARN_ON_ONCE(1);
+		goto err;
+	}
+	offset += priv->offset;
+
+	pr_info(">>fetching payload at offset %u (len=%u)\n", offset, priv->len);
+
+	if (skb_copy_bits(skb, offset, dest, priv->len) < 0)
+		goto err;
+	return;
+err:
+	regs->verdict.code = NFT_BREAK;
+}
+
+static int nft_payload_inner_init(const struct nft_ctx *ctx,
+				  const struct nft_expr *expr,
+				  const struct nlattr * const tb[])
+{
+	struct nft_payload *priv = nft_expr_priv(expr);
+	u32 base;
+
+	pr_info("inner_init\n");
+
+	base   = ntohl(nla_get_be32(tb[NFTA_PAYLOAD_BASE]));
+	switch (base) {
+	case NFT_PAYLOAD_TUN_HEADER:
+	case NFT_PAYLOAD_LL_HEADER:
+	case NFT_PAYLOAD_NETWORK_HEADER:
+	case NFT_PAYLOAD_TRANSPORT_HEADER:
+		break;
+	default:
+		pr_info("	bad base %u\n", base);
+		return -EOPNOTSUPP;
+	}
+
+	priv->base   = base;
+	priv->offset = ntohl(nla_get_be32(tb[NFTA_PAYLOAD_OFFSET]));
+	priv->len    = ntohl(nla_get_be32(tb[NFTA_PAYLOAD_LEN]));
+
+	return nft_parse_register_store(ctx, tb[NFTA_PAYLOAD_DREG],
+					&priv->dreg, NULL, NFT_DATA_VALUE,
+					priv->len);
+}
+
+static int nft_payload_inner_dump(struct sk_buff *skb,
+				  const struct nft_expr *expr)
+{
+	const struct nft_payload *priv = nft_expr_priv(expr);
+
+	if (nft_dump_register(skb, NFTA_PAYLOAD_DREG, priv->dreg) ||
+	    nla_put_be32(skb, NFTA_PAYLOAD_BASE, htonl(priv->base)) ||
+	    nla_put_be32(skb, NFTA_PAYLOAD_OFFSET, htonl(priv->offset)) ||
+	    nla_put_be32(skb, NFTA_PAYLOAD_LEN, htonl(priv->len)))
+		goto nla_put_failure;
+	return 0;
+
+nla_put_failure:
+	return -1;
+}
+
+static const struct nft_expr_ops nft_payload_inner_ops = {
+	.type		= &nft_payload_type,
+	.size		= NFT_EXPR_SIZE(sizeof(struct nft_payload)),
+	.init		= nft_payload_inner_init,
+	.dump		= nft_payload_inner_dump,
+};
+
 static inline void nft_csum_replace(__sum16 *sum, __wsum fsum, __wsum tsum)
 {
 	*sum = csum_fold(csum_add(csum_sub(~csum_unfold(*sum), fsum), tsum));
@@ -902,6 +1012,7 @@ nft_payload_select_ops(const struct nft_ctx *ctx,
 struct nft_expr_type nft_payload_type __read_mostly = {
 	.name		= "payload",
 	.select_ops	= nft_payload_select_ops,
+	.inner_ops	= &nft_payload_inner_ops,
 	.policy		= nft_payload_policy,
 	.maxattr	= NFTA_PAYLOAD_MAX,
 	.owner		= THIS_MODULE,
-- 
2.30.2

