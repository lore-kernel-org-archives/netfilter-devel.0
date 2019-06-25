Return-Path: <SRS0=l45K=UY=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C39AC48BD5
	for <netfilter-devel@archiver.kernel.org>; Tue, 25 Jun 2019 10:37:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 38ED92084B
	for <netfilter-devel@archiver.kernel.org>; Tue, 25 Jun 2019 10:37:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=riseup.net header.i=@riseup.net header.b="ODxAM+uE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731983AbfFYKhG (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 25 Jun 2019 06:37:06 -0400
Received: from mx1.riseup.net ([198.252.153.129]:58090 "EHLO mx1.riseup.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728377AbfFYKhD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 25 Jun 2019 06:37:03 -0400
Received: from bell.riseup.net (bell-pn.riseup.net [10.0.1.178])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "*.riseup.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (verified OK))
        by mx1.riseup.net (Postfix) with ESMTPS id 069D21B9354
        for <netfilter-devel@vger.kernel.org>; Tue, 25 Jun 2019 03:37:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1561459021; bh=QiqlZpNhffylJrxTYTOngaJ9z5bLKpKQPkFWrBeh6nU=;
        h=From:To:Cc:Subject:Date:From;
        b=ODxAM+uEMapMp93BGpR0NakzdzVUOLRAzgS6HuA7XNK0Xx0zc9Uy4+PRIDHUh723U
         JNYdhb0HYjO2kmFsFpHKNT5MoqRHC8yEham0Tme7R+r2jkK/j7nHuvTt3SKpdFYGMT
         Tbd8y5Mj0ODN47MnS+NpxPN9PPjrewosFo0sJipM=
X-Riseup-User-ID: F406200B4172092C03E12D6437123263CDF27CD3EC2F5C16D5AB5B0426482753
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by bell.riseup.net (Postfix) with ESMTPSA id 106B4220404;
        Tue, 25 Jun 2019 03:36:59 -0700 (PDT)
From:   Fernando Fernandez Mancera <ffmancera@riseup.net>
To:     netfilter-devel@vger.kernel.org
Cc:     Fernando Fernandez Mancera <ffmancera@riseup.net>
Subject: [PATCH nf-next v4] netfilter: nf_tables: Add SYNPROXY support
Date:   Tue, 25 Jun 2019 12:37:11 +0200
Message-Id: <20190625103711.751-1-ffmancera@riseup.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Add SYNPROXY module support in nf_tables. It preserves the behaviour of the
SYNPROXY target of iptables but structured in a different way to propose
improvements in the future.

Signed-off-by: Fernando Fernandez Mancera <ffmancera@riseup.net>
---
v1: initial patch
v2: add IPV6 module checks
v3: move common eval parts into a function, reorder init function
v4: remove NFT_CONTINUE, place error check close to function call in eval
---
 include/net/netfilter/nf_conntrack_synproxy.h |   1 +
 include/uapi/linux/netfilter/nf_SYNPROXY.h    |   4 +
 include/uapi/linux/netfilter/nf_tables.h      |  17 +
 net/netfilter/Kconfig                         |  11 +
 net/netfilter/Makefile                        |   1 +
 net/netfilter/nft_synproxy.c                  | 293 ++++++++++++++++++
 6 files changed, 327 insertions(+)
 create mode 100644 net/netfilter/nft_synproxy.c

diff --git a/include/net/netfilter/nf_conntrack_synproxy.h b/include/net/netfilter/nf_conntrack_synproxy.h
index c5659dcf5b1a..8f00125b06f4 100644
--- a/include/net/netfilter/nf_conntrack_synproxy.h
+++ b/include/net/netfilter/nf_conntrack_synproxy.h
@@ -2,6 +2,7 @@
 #ifndef _NF_CONNTRACK_SYNPROXY_H
 #define _NF_CONNTRACK_SYNPROXY_H
 
+#include <net/netfilter/nf_conntrack_seqadj.h>
 #include <net/netns/generic.h>
 
 struct nf_conn_synproxy {
diff --git a/include/uapi/linux/netfilter/nf_SYNPROXY.h b/include/uapi/linux/netfilter/nf_SYNPROXY.h
index 068d1b3a6f06..6f3791c8946f 100644
--- a/include/uapi/linux/netfilter/nf_SYNPROXY.h
+++ b/include/uapi/linux/netfilter/nf_SYNPROXY.h
@@ -9,6 +9,10 @@
 #define NF_SYNPROXY_OPT_SACK_PERM	0x04
 #define NF_SYNPROXY_OPT_TIMESTAMP	0x08
 #define NF_SYNPROXY_OPT_ECN		0x10
+#define NF_SYNPROXY_OPT_MASK		(NF_SYNPROXY_OPT_MSS | \
+					 NF_SYNPROXY_OPT_WSCALE | \
+					 NF_SYNPROXY_OPT_SACK_PERM | \
+					 NF_SYNPROXY_OPT_TIMESTAMP)
 
 struct nf_synproxy_info {
 	__u8	options;
diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index c6c8ec5c7c00..302c25af17d7 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -1551,6 +1551,23 @@ enum nft_osf_flags {
 	NFT_OSF_F_VERSION = (1 << 0),
 };
 
+/**
+ * enum nft_synproxy_attributes - nf_tables synproxy expression
+ * netlink attributes
+ *
+ * @NFTA_SYNPROXY_MSS: mss value sent to the backend (NLA_U16)
+ * @NFTA_SYNPROXY_WSCALE: wscale value sent to the backend (NLA_U8)
+ * @NFTA_SYNPROXY_FLAGS: flags (NLA_U32)
+ */
+enum nft_synproxy_attributes {
+	NFTA_SYNPROXY_UNSPEC,
+	NFTA_SYNPROXY_MSS,
+	NFTA_SYNPROXY_WSCALE,
+	NFTA_SYNPROXY_FLAGS,
+	__NFTA_SYNPROXY_MAX,
+};
+#define NFTA_SYNPROXY_MAX (__NFTA_SYNPROXY_MAX - 1)
+
 /**
  * enum nft_device_attributes - nf_tables device netlink attributes
  *
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 21025c2c605b..d59742408d9b 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -651,6 +651,17 @@ config NFT_TPROXY
 	help
 	  This makes transparent proxy support available in nftables.
 
+config NFT_SYNPROXY
+	tristate "Netfilter nf_tables SYNPROXY expression support"
+	depends on NF_CONNTRACK && NETFILTER_ADVANCED
+	select NETFILTER_SYNPROXY
+	select SYN_COOKIES
+	help
+	  The SYNPROXY expression allows you to intercept TCP connections and
+	  establish them using syncookies before they are passed on to the
+	  server. This allows to avoid conntrack and server resource usage
+	  during SYN-flood attacks.
+
 if NF_TABLES_NETDEV
 
 config NF_DUP_NETDEV
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index 72cca6b48960..deada20975ff 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -110,6 +110,7 @@ obj-$(CONFIG_NFT_SOCKET)	+= nft_socket.o
 obj-$(CONFIG_NFT_OSF)		+= nft_osf.o
 obj-$(CONFIG_NFT_TPROXY)	+= nft_tproxy.o
 obj-$(CONFIG_NFT_XFRM)		+= nft_xfrm.o
+obj-$(CONFIG_NFT_SYNPROXY)	+= nft_synproxy.o
 
 obj-$(CONFIG_NFT_NAT)		+= nft_chain_nat.o
 
diff --git a/net/netfilter/nft_synproxy.c b/net/netfilter/nft_synproxy.c
new file mode 100644
index 000000000000..d829c28d5be1
--- /dev/null
+++ b/net/netfilter/nft_synproxy.c
@@ -0,0 +1,293 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <linux/types.h>
+#include <net/ip.h>
+#include <net/tcp.h>
+#include <net/netlink.h>
+#include <net/netfilter/nf_tables.h>
+#include <net/netfilter/nf_conntrack.h>
+#include <net/netfilter/nf_conntrack_synproxy.h>
+#include <net/netfilter/nf_synproxy.h>
+#include <linux/netfilter/nf_tables.h>
+#include <linux/netfilter/nf_SYNPROXY.h>
+
+struct nft_synproxy {
+	struct nf_synproxy_info	info;
+};
+
+static const struct nla_policy nft_synproxy_policy[NFTA_SYNPROXY_MAX + 1] = {
+	[NFTA_SYNPROXY_MSS]		= { .type = NLA_U16 },
+	[NFTA_SYNPROXY_WSCALE]		= { .type = NLA_U8 },
+	[NFTA_SYNPROXY_FLAGS]		= { .type = NLA_U32 },
+};
+
+static void nft_synproxy_tcp_options(struct synproxy_options *opts,
+				     const struct tcphdr *tcp,
+				     struct synproxy_net *snet,
+				     struct nf_synproxy_info *info,
+				     struct nft_synproxy *priv)
+{
+	this_cpu_inc(snet->stats->syn_received);
+	if (tcp->ece && tcp->cwr)
+		opts->options |= NF_SYNPROXY_OPT_ECN;
+
+	opts->options &= priv->info.options;
+	if (opts->options & NF_SYNPROXY_OPT_TIMESTAMP)
+		synproxy_init_timestamp_cookie(info, opts);
+	else
+		opts->options &= ~(NF_SYNPROXY_OPT_WSCALE |
+				  NF_SYNPROXY_OPT_SACK_PERM |
+				  NF_SYNPROXY_OPT_ECN);
+}
+
+static void nft_synproxy_eval_v4(const struct nft_expr *expr,
+				 struct nft_regs *regs,
+				 const struct nft_pktinfo *pkt,
+				 const struct tcphdr *tcp,
+				 struct tcphdr *_tcph,
+				 struct synproxy_options *opts)
+{
+	struct nft_synproxy *priv = nft_expr_priv(expr);
+	struct nf_synproxy_info info = priv->info;
+	struct net *net = nft_net(pkt);
+	struct synproxy_net *snet = synproxy_pernet(net);
+	struct sk_buff *skb = pkt->skb;
+
+	if (tcp->syn) {
+		/* Initial SYN from client */
+		nft_synproxy_tcp_options(opts, tcp, snet, &info, priv);
+		synproxy_send_client_synack(net, skb, tcp, opts);
+		consume_skb(skb);
+		regs->verdict.code = NF_STOLEN;
+		return;
+	} else if (tcp->ack) {
+		/* ACK from client */
+		if (synproxy_recv_client_ack(net, skb, tcp, opts,
+					     ntohl(tcp->seq))) {
+			consume_skb(skb);
+			regs->verdict.code = NF_STOLEN;
+		} else {
+			regs->verdict.code = NF_DROP;
+		}
+	}
+}
+
+#if IS_ENABLED(CONFIG_NF_TABLES_IPV6)
+static void nft_synproxy_eval_v6(const struct nft_expr *expr,
+				 struct nft_regs *regs,
+				 const struct nft_pktinfo *pkt,
+				 const struct tcphdr *tcp,
+				 struct tcphdr *_tcph,
+				 struct synproxy_options *opts)
+{
+	struct nft_synproxy *priv = nft_expr_priv(expr);
+	struct nf_synproxy_info info = priv->info;
+	struct net *net = nft_net(pkt);
+	struct synproxy_net *snet = synproxy_pernet(net);
+	struct sk_buff *skb = pkt->skb;
+
+	if (tcp->syn) {
+		/* Initial SYN from client */
+		nft_synproxy_tcp_options(opts, tcp, snet, &info, priv);
+		synproxy_send_client_synack_ipv6(net, skb, tcp, opts);
+		consume_skb(skb);
+		regs->verdict.code = NF_STOLEN;
+		return;
+	} else if (tcp->ack) {
+		/* ACK from client */
+		if (synproxy_recv_client_ack_ipv6(net, skb, tcp, opts,
+						  ntohl(tcp->seq))) {
+			consume_skb(skb);
+			regs->verdict.code = NF_STOLEN;
+		} else {
+			regs->verdict.code = NF_DROP;
+		}
+	}
+}
+#endif /* CONFIG_NF_TABLES_IPV6*/
+
+static void nft_synproxy_eval(const struct nft_expr *expr,
+			      struct nft_regs *regs,
+			      const struct nft_pktinfo *pkt)
+{
+	struct synproxy_options opts = {};
+	struct sk_buff *skb = pkt->skb;
+	int thoff = pkt->xt.thoff;
+	const struct tcphdr *tcp;
+	struct tcphdr _tcph;
+
+	if (pkt->tprot != IPPROTO_TCP) {
+		regs->verdict.code = NFT_BREAK;
+		return;
+	}
+
+	if (nf_ip_checksum(skb, nft_hook(pkt), thoff, IPPROTO_TCP)) {
+		regs->verdict.code = NF_DROP;
+		return;
+	}
+
+	tcp = skb_header_pointer(skb, pkt->xt.thoff,
+				 sizeof(struct tcphdr),
+				 &_tcph);
+	if (!tcp) {
+		regs->verdict.code = NF_DROP;
+		return;
+	}
+
+	if (!synproxy_parse_options(skb, thoff, tcp, &opts)) {
+		regs->verdict.code = NF_DROP;
+		return;
+	}
+
+	switch (skb->protocol) {
+	case htons(ETH_P_IP):
+		nft_synproxy_eval_v4(expr, regs, pkt, tcp, &_tcph, &opts);
+		return;
+#if IS_ENABLED(CONFIG_NF_TABLES_IPV6)
+	case htons(ETH_P_IPV6):
+		nft_synproxy_eval_v6(expr, regs, pkt, tcp, &_tcph, &opts);
+		return;
+#endif
+	}
+	regs->verdict.code = NFT_BREAK;
+}
+
+static int nft_synproxy_init(const struct nft_ctx *ctx,
+			     const struct nft_expr *expr,
+			     const struct nlattr * const tb[])
+{
+	struct synproxy_net *snet = synproxy_pernet(ctx->net);
+	struct nft_synproxy *priv = nft_expr_priv(expr);
+	u32 flags;
+	int err;
+
+	if (tb[NFTA_SYNPROXY_MSS])
+		priv->info.mss = ntohs(nla_get_be16(tb[NFTA_SYNPROXY_MSS]));
+	if (tb[NFTA_SYNPROXY_WSCALE])
+		priv->info.wscale = nla_get_u8(tb[NFTA_SYNPROXY_WSCALE]);
+	if (tb[NFTA_SYNPROXY_FLAGS]) {
+		flags = ntohl(nla_get_be32(tb[NFTA_SYNPROXY_FLAGS]));
+		if (flags != 0 && (flags & NF_SYNPROXY_OPT_MASK) == 0)
+			return -EINVAL;
+		priv->info.options = flags;
+	}
+
+	err = nf_ct_netns_get(ctx->net, ctx->family);
+	if (err)
+		return err;
+
+	switch (ctx->family) {
+	case NFPROTO_IPV4:
+		err = nf_synproxy_ipv4_init(snet, ctx->net);
+		if (err)
+			goto nf_ct_failure;
+		snet->hook_ref4++;
+		break;
+#if IS_ENABLED(CONFIG_IPV6)
+	case NFPROTO_IPV6:
+		err = nf_synproxy_ipv6_init(snet, ctx->net);
+		if (err)
+			goto nf_ct_failure;
+		snet->hook_ref6++;
+		break;
+	case NFPROTO_INET:
+	case NFPROTO_BRIDGE:
+		err = nf_synproxy_ipv4_init(snet, ctx->net);
+		if (err)
+			goto nf_ct_failure;
+		err = nf_synproxy_ipv6_init(snet, ctx->net);
+		if (err)
+			goto nf_ct_failure;
+		snet->hook_ref4++;
+		snet->hook_ref6++;
+		break;
+#endif
+	}
+
+	return 0;
+
+nf_ct_failure:
+	nf_ct_netns_put(ctx->net, ctx->family);
+	return err;
+}
+
+static void nft_synproxy_destroy(const struct nft_ctx *ctx,
+				 const struct nft_expr *expr)
+{
+	struct synproxy_net *snet = synproxy_pernet(ctx->net);
+
+	switch (ctx->family) {
+	case NFPROTO_IPV4:
+		nf_synproxy_ipv4_fini(snet, ctx->net);
+		break;
+#if IS_ENABLED(CONFIG_IPV6)
+	case NFPROTO_IPV6:
+		nf_synproxy_ipv6_fini(snet, ctx->net);
+		break;
+	case NFPROTO_INET:
+	case NFPROTO_BRIDGE:
+		nf_synproxy_ipv4_fini(snet, ctx->net);
+		nf_synproxy_ipv6_fini(snet, ctx->net);
+		break;
+#endif
+	}
+	nf_ct_netns_put(ctx->net, ctx->family);
+}
+
+static int nft_synproxy_dump(struct sk_buff *skb, const struct nft_expr *expr)
+{
+	const struct nft_synproxy *priv = nft_expr_priv(expr);
+
+	if (nla_put_be16(skb, NFTA_SYNPROXY_MSS, ntohs(priv->info.mss)) ||
+	    nla_put_u8(skb, NFTA_SYNPROXY_WSCALE, priv->info.wscale) ||
+	    nla_put_be32(skb, NFTA_SYNPROXY_FLAGS, ntohl(priv->info.options)))
+		goto nla_put_failure;
+
+	return 0;
+
+nla_put_failure:
+	return -1;
+}
+
+static int nft_synproxy_validate(const struct nft_ctx *ctx,
+				 const struct nft_expr *expr,
+				 const struct nft_data **data)
+{
+	return nft_chain_validate_hooks(ctx->chain, (1 << NF_INET_LOCAL_IN) |
+						    (1 << NF_INET_FORWARD));
+}
+
+static struct nft_expr_type nft_synproxy_type;
+static const struct nft_expr_ops nft_synproxy_ops = {
+	.eval		= nft_synproxy_eval,
+	.size		= NFT_EXPR_SIZE(sizeof(struct nft_synproxy)),
+	.init		= nft_synproxy_init,
+	.destroy	= nft_synproxy_destroy,
+	.dump		= nft_synproxy_dump,
+	.type		= &nft_synproxy_type,
+	.validate	= nft_synproxy_validate,
+};
+
+static struct nft_expr_type nft_synproxy_type __read_mostly = {
+	.ops		= &nft_synproxy_ops,
+	.name		= "synproxy",
+	.owner		= THIS_MODULE,
+	.policy		= nft_synproxy_policy,
+	.maxattr	= NFTA_OSF_MAX,
+};
+
+static int __init nft_synproxy_module_init(void)
+{
+	return nft_register_expr(&nft_synproxy_type);
+}
+
+static void __exit nft_synproxy_module_exit(void)
+{
+	return nft_unregister_expr(&nft_synproxy_type);
+}
+
+module_init(nft_synproxy_module_init);
+module_exit(nft_synproxy_module_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Fernando Fernandez <ffmancera@riseup.net>");
+MODULE_ALIAS_NFT_EXPR("synproxy");
-- 
2.20.1

