Return-Path: <SRS0=B2LC=D5=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 290DDC388F9
	for <netfilter-devel@archiver.kernel.org>; Thu, 22 Oct 2020 19:44:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B085F207C4
	for <netfilter-devel@archiver.kernel.org>; Thu, 22 Oct 2020 19:44:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=riseup.net header.i=@riseup.net header.b="pYxtbq8L"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S370385AbgJVToh (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 22 Oct 2020 15:44:37 -0400
Received: from mx1.riseup.net ([198.252.153.129]:44150 "EHLO mx1.riseup.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2508686AbgJVTog (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 22 Oct 2020 15:44:36 -0400
Received: from capuchin.riseup.net (capuchin-pn.riseup.net [10.0.1.176])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "*.riseup.net", Issuer "Sectigo RSA Domain Validation Secure Server CA" (not verified))
        by mx1.riseup.net (Postfix) with ESMTPS id 4CHHr34q9VzFcs1;
        Thu, 22 Oct 2020 12:44:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1603395875; bh=xgGR0V28Uq8h+mtAt1cgIS4cD3j37EJoKLuAmwuCHQI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pYxtbq8L38EBkAvVho0efwpyJ2YOsQwKTT8VLXhTUwZEtMNeV2xCoFRGGTry5IRCB
         SU1D42+riSi5BKfNuVPE6rDWSjWvzv/7Ye9OZ9MnhgoxgLW8+xzUbL+DzeScstHz3a
         2VI08XcGD6xEsAn8gUBqo2v4zUzCfs0v0I1oaJ2M=
X-Riseup-User-ID: C10EFDD26EE3BCEF1DC1349793F942B363CF2750AFCA2301ED18ADB364137A2B
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by capuchin.riseup.net (Postfix) with ESMTPSA id 4CHHr25yVCz8sX6;
        Thu, 22 Oct 2020 12:44:34 -0700 (PDT)
From:   "Jose M. Guisado Gomez" <guigom@riseup.net>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next 3/5] net: netfilter: add reject verdict support for netdev
Date:   Thu, 22 Oct 2020 21:43:53 +0200
Message-Id: <20201022194355.1816-4-guigom@riseup.net>
In-Reply-To: <20201022194355.1816-1-guigom@riseup.net>
References: <20201022194355.1816-1-guigom@riseup.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Adds support for reject from ingress hook in netdev family.
Both stacks ipv4 and ipv6.  With reject packets supporting ICMP
and TCP RST.

This ability is required in devices that need to REJECT legitimate
clients which traffic is forwarded from the ingress hook.

	Joint work with Laura Garcia.

Signed-off-by: Jose M. Guisado Gomez <guigom@riseup.net>
---
 net/netfilter/Kconfig             |  10 ++
 net/netfilter/Makefile            |   1 +
 net/netfilter/nft_reject_netdev.c | 189 ++++++++++++++++++++++++++++++
 3 files changed, 200 insertions(+)
 create mode 100644 net/netfilter/nft_reject_netdev.c

diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 25313c29d799..e6031daaa23e 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -681,6 +681,16 @@ config NFT_FIB_NETDEV
 	  The lookup will be delegated to the IPv4 or IPv6 FIB depending
 	  on the protocol of the packet.
 
+config NFT_REJECT_NETDEV
+	depends on NFT_REJECT_IPV4
+	depends on NFT_REJECT_IPV6
+	tristate "Netfilter nf_tables netdev REJECT support"
+	help
+	  This option enables the REJECT support from the netdev table.
+	  The return packet generation will be delegated to the IPv4
+	  or IPv6 ICMP or TCP RST implementation depending on the
+	  protocol of the packet.
+
 endif # NF_TABLES_NETDEV
 
 endif # NF_TABLES
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index 0e0ded87e27b..33da7bf1b68e 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -101,6 +101,7 @@ obj-$(CONFIG_NFT_QUEUE)		+= nft_queue.o
 obj-$(CONFIG_NFT_QUOTA)		+= nft_quota.o
 obj-$(CONFIG_NFT_REJECT) 	+= nft_reject.o
 obj-$(CONFIG_NFT_REJECT_INET)	+= nft_reject_inet.o
+obj-$(CONFIG_NFT_REJECT_NETDEV)	+= nft_reject_netdev.o
 obj-$(CONFIG_NFT_TUNNEL)	+= nft_tunnel.o
 obj-$(CONFIG_NFT_COUNTER)	+= nft_counter.o
 obj-$(CONFIG_NFT_LOG)		+= nft_log.o
diff --git a/net/netfilter/nft_reject_netdev.c b/net/netfilter/nft_reject_netdev.c
new file mode 100644
index 000000000000..d89f68754f42
--- /dev/null
+++ b/net/netfilter/nft_reject_netdev.c
@@ -0,0 +1,189 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (c) 2020 Laura Garcia Liebana <nevola@gmail.com>
+ * Copyright (c) 2020 Jose M. Guisado <guigom@riseup.net>
+ */
+
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/netlink.h>
+#include <linux/netfilter.h>
+#include <linux/netfilter/nf_tables.h>
+#include <net/netfilter/nf_tables.h>
+#include <net/netfilter/nft_reject.h>
+#include <net/netfilter/ipv4/nf_reject.h>
+#include <net/netfilter/ipv6/nf_reject.h>
+
+static void nft_reject_queue_xmit(struct sk_buff *nskb, struct sk_buff *oldskb)
+{
+	dev_hard_header(nskb, nskb->dev, ntohs(oldskb->protocol),
+			eth_hdr(oldskb)->h_source, eth_hdr(oldskb)->h_dest,
+			nskb->len);
+	dev_queue_xmit(nskb);
+}
+
+static void nft_reject_netdev_send_v4_tcp_reset(struct net *net,
+						struct sk_buff *oldskb,
+						const struct net_device *dev,
+						int hook)
+{
+	struct sk_buff *nskb;
+
+	nskb = nf_reject_skb_v4_tcp_reset(net, oldskb, dev, hook);
+	if (!nskb)
+		return;
+
+	nft_reject_queue_xmit(nskb, oldskb);
+}
+
+static void nft_reject_netdev_send_v4_unreach(struct net *net,
+					      struct sk_buff *oldskb,
+					      const struct net_device *dev,
+					      int hook, u8 code)
+{
+	struct sk_buff *nskb;
+
+	nskb = nf_reject_skb_v4_unreach(net, oldskb, dev, hook, code);
+	if (!nskb)
+		return;
+
+	nft_reject_queue_xmit(nskb, oldskb);
+}
+
+static void nft_reject_netdev_send_v6_tcp_reset(struct net *net,
+						struct sk_buff *oldskb,
+						const struct net_device *dev,
+						int hook)
+{
+	struct sk_buff *nskb;
+
+	nskb = nf_reject_skb_v6_tcp_reset(net, oldskb, dev, hook);
+	if (!nskb)
+		return;
+
+	nft_reject_queue_xmit(nskb, oldskb);
+}
+
+
+static void nft_reject_netdev_send_v6_unreach(struct net *net,
+					      struct sk_buff *oldskb,
+					      const struct net_device *dev,
+					      int hook, u8 code)
+{
+	struct sk_buff *nskb;
+
+	nskb = nf_reject_skb_v6_unreach(net, oldskb, dev, hook, code);
+	if (!nskb)
+		return;
+
+	nft_reject_queue_xmit(nskb, oldskb);
+}
+
+static void nft_reject_netdev_eval(const struct nft_expr *expr,
+				   struct nft_regs *regs,
+				   const struct nft_pktinfo *pkt)
+{
+	struct ethhdr *eth = eth_hdr(pkt->skb);
+	struct nft_reject *priv = nft_expr_priv(expr);
+	const unsigned char *dest = eth->h_dest;
+
+	if (is_broadcast_ether_addr(dest) ||
+	    is_multicast_ether_addr(dest))
+		goto out;
+
+	switch (eth->h_proto) {
+	case htons(ETH_P_IP):
+		switch (priv->type) {
+		case NFT_REJECT_ICMP_UNREACH:
+			nft_reject_netdev_send_v4_unreach(nft_net(pkt), pkt->skb,
+							  nft_in(pkt),
+							  nft_hook(pkt),
+							  priv->icmp_code);
+			break;
+		case NFT_REJECT_TCP_RST:
+			nft_reject_netdev_send_v4_tcp_reset(nft_net(pkt), pkt->skb,
+							    nft_in(pkt),
+							    nft_hook(pkt));
+			break;
+		case NFT_REJECT_ICMPX_UNREACH:
+			nft_reject_netdev_send_v4_unreach(nft_net(pkt), pkt->skb,
+							  nft_in(pkt),
+							  nft_hook(pkt),
+							  nft_reject_icmp_code(priv->icmp_code));
+			break;
+		}
+		break;
+	case htons(ETH_P_IPV6):
+		switch (priv->type) {
+		case NFT_REJECT_ICMP_UNREACH:
+			nft_reject_netdev_send_v6_unreach(nft_net(pkt), pkt->skb,
+							  nft_in(pkt),
+							  nft_hook(pkt),
+							  priv->icmp_code);
+			break;
+		case NFT_REJECT_TCP_RST:
+			nft_reject_netdev_send_v6_tcp_reset(nft_net(pkt), pkt->skb,
+							    nft_in(pkt),
+							    nft_hook(pkt));
+			break;
+		case NFT_REJECT_ICMPX_UNREACH:
+			nft_reject_netdev_send_v6_unreach(nft_net(pkt), pkt->skb,
+							  nft_in(pkt),
+							  nft_hook(pkt),
+							  nft_reject_icmpv6_code(priv->icmp_code));
+			break;
+		}
+		break;
+	default:
+		/* No explicit way to reject this protocol, drop it. */
+		break;
+	}
+out:
+	regs->verdict.code = NF_DROP;
+}
+
+static int nft_reject_netdev_validate(const struct nft_ctx *ctx,
+				      const struct nft_expr *expr,
+				      const struct nft_data **data)
+{
+	return nft_chain_validate_hooks(ctx->chain, (1 << NF_NETDEV_INGRESS));
+}
+
+static struct nft_expr_type nft_reject_netdev_type;
+static const struct nft_expr_ops nft_reject_netdev_ops = {
+	.type		= &nft_reject_netdev_type,
+	.size		= NFT_EXPR_SIZE(sizeof(struct nft_reject)),
+	.eval		= nft_reject_netdev_eval,
+	.init		= nft_reject_init,
+	.dump		= nft_reject_dump,
+	.validate	= nft_reject_netdev_validate,
+};
+
+static struct nft_expr_type nft_reject_netdev_type __read_mostly = {
+	.family		= NFPROTO_NETDEV,
+	.name		= "reject",
+	.ops		= &nft_reject_netdev_ops,
+	.policy		= nft_reject_policy,
+	.maxattr	= NFTA_REJECT_MAX,
+	.owner		= THIS_MODULE,
+};
+
+static int __init nft_reject_netdev_module_init(void)
+{
+	return nft_register_expr(&nft_reject_netdev_type);
+}
+
+static void __exit nft_reject_netdev_module_exit(void)
+{
+	nft_unregister_expr(&nft_reject_netdev_type);
+}
+
+module_init(nft_reject_netdev_module_init);
+module_exit(nft_reject_netdev_module_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Laura Garcia Liebana <nevola@gmail.com>");
+MODULE_AUTHOR("Jose M. Guisado <guigom@riseup.net>");
+MODULE_DESCRIPTION("Reject packets from netdev via nftables");
+MODULE_ALIAS_NFT_AF_EXPR(5, "reject");
-- 
2.28.0

