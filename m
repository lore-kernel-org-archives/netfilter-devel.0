Return-Path: <SRS0=zt5D=RD=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACD80C43381
	for <netfilter-devel@archiver.kernel.org>; Thu, 28 Feb 2019 11:02:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7C4EF21850
	for <netfilter-devel@archiver.kernel.org>; Thu, 28 Feb 2019 11:02:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731794AbfB1LCj (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 28 Feb 2019 06:02:39 -0500
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:54008 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731481AbfB1LCj (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 28 Feb 2019 06:02:39 -0500
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@breakpoint.cc>)
        id 1gzJSV-0003gz-57; Thu, 28 Feb 2019 12:02:35 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 3/3] netfilter: nf_tables: merge ipv4 and ipv6 nat chain types
Date:   Thu, 28 Feb 2019 12:02:52 +0100
Message-Id: <20190228110252.4423-4-fw@strlen.de>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20190228110252.4423-1-fw@strlen.de>
References: <20190228110252.4423-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Merge the ipv4 and ipv6 nat chain type. This is the last
missing piece which allows to provide inet family support
for nat in a follow patch.

The kconfig knobs for ipv4/ipv6 nat chain are removed, the
nat chain type will be built unconditionally if NFT_NAT
expression is enabled.

Before:
   text	   data	    bss	    dec	    hex	filename
   1576     896       0    2472     9a8 nft_chain_nat_ipv4.ko
   1697     896       0    2593     a21 nft_chain_nat_ipv6.ko

After:
   text	   data	    bss	    dec	    hex	filename
   1832     896       0    2728     aa8 nft_chain_nat.ko

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/ipv4/netfilter/Kconfig              |  13 ---
 net/ipv4/netfilter/Makefile             |   1 -
 net/ipv4/netfilter/nft_chain_nat_ipv4.c |  85 -------------------
 net/ipv6/netfilter/Kconfig              |  11 ---
 net/ipv6/netfilter/Makefile             |   1 -
 net/ipv6/netfilter/nft_chain_nat_ipv6.c |  83 ------------------
 net/netfilter/Kconfig                   |   1 +
 net/netfilter/Makefile                  |   2 +
 net/netfilter/nft_chain_nat.c           | 108 ++++++++++++++++++++++++
 9 files changed, 111 insertions(+), 194 deletions(-)
 delete mode 100644 net/ipv4/netfilter/nft_chain_nat_ipv4.c
 delete mode 100644 net/ipv6/netfilter/nft_chain_nat_ipv6.c
 create mode 100644 net/netfilter/nft_chain_nat.c

diff --git a/net/ipv4/netfilter/Kconfig b/net/ipv4/netfilter/Kconfig
index 71c291a86245..c98391d49200 100644
--- a/net/ipv4/netfilter/Kconfig
+++ b/net/ipv4/netfilter/Kconfig
@@ -95,19 +95,6 @@ config NF_REJECT_IPV4
 	default m if NETFILTER_ADVANCED=n
 
 if NF_NAT
-
-if NF_TABLES
-config NFT_CHAIN_NAT_IPV4
-	depends on NF_TABLES_IPV4
-	tristate "IPv4 nf_tables nat chain support"
-	help
-	  This option enables the "nat" chain for IPv4 in nf_tables. This
-	  chain type is used to perform Network Address Translation (NAT)
-	  packet transformations such as the source, destination address and
-	  source and destination ports.
-
-endif # NF_TABLES
-
 config NF_NAT_SNMP_BASIC
 	tristate "Basic SNMP-ALG support"
 	depends on NF_CONNTRACK_SNMP
diff --git a/net/ipv4/netfilter/Makefile b/net/ipv4/netfilter/Makefile
index 1ae24d71d3cc..e241f5188ebe 100644
--- a/net/ipv4/netfilter/Makefile
+++ b/net/ipv4/netfilter/Makefile
@@ -25,7 +25,6 @@ $(obj)/nf_nat_snmp_basic_main.o: $(obj)/nf_nat_snmp_basic.asn1.h
 obj-$(CONFIG_NF_NAT_SNMP_BASIC) += nf_nat_snmp_basic.o
 
 obj-$(CONFIG_NFT_CHAIN_ROUTE_IPV4) += nft_chain_route_ipv4.o
-obj-$(CONFIG_NFT_CHAIN_NAT_IPV4) += nft_chain_nat_ipv4.o
 obj-$(CONFIG_NFT_REJECT_IPV4) += nft_reject_ipv4.o
 obj-$(CONFIG_NFT_FIB_IPV4) += nft_fib_ipv4.o
 obj-$(CONFIG_NFT_DUP_IPV4) += nft_dup_ipv4.o
diff --git a/net/ipv4/netfilter/nft_chain_nat_ipv4.c b/net/ipv4/netfilter/nft_chain_nat_ipv4.c
deleted file mode 100644
index 0d1ad5901aff..000000000000
--- a/net/ipv4/netfilter/nft_chain_nat_ipv4.c
+++ /dev/null
@@ -1,85 +0,0 @@
-/*
- * Copyright (c) 2008-2009 Patrick McHardy <kaber@trash.net>
- * Copyright (c) 2012 Pablo Neira Ayuso <pablo@netfilter.org>
- * Copyright (c) 2012 Intel Corporation
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- *
- * Development of this code funded by Astaro AG (http://www.astaro.com/)
- */
-
-#include <linux/module.h>
-#include <linux/init.h>
-#include <linux/list.h>
-#include <linux/skbuff.h>
-#include <linux/ip.h>
-#include <linux/netfilter.h>
-#include <linux/netfilter_ipv4.h>
-#include <linux/netfilter/nf_tables.h>
-#include <net/netfilter/nf_conntrack.h>
-#include <net/netfilter/nf_nat.h>
-#include <net/netfilter/nf_tables.h>
-#include <net/netfilter/nf_tables_ipv4.h>
-#include <net/ip.h>
-
-static unsigned int nft_nat_do_chain(void *priv,
-				     struct sk_buff *skb,
-				     const struct nf_hook_state *state)
-{
-	struct nft_pktinfo pkt;
-
-	nft_set_pktinfo(&pkt, skb, state);
-	nft_set_pktinfo_ipv4(&pkt, skb);
-
-	return nft_do_chain(&pkt, priv);
-}
-
-static int nft_nat_ipv4_reg(struct net *net, const struct nf_hook_ops *ops)
-{
-	return nf_nat_ipv4_register_fn(net, ops);
-}
-
-static void nft_nat_ipv4_unreg(struct net *net, const struct nf_hook_ops *ops)
-{
-	nf_nat_ipv4_unregister_fn(net, ops);
-}
-
-static const struct nft_chain_type nft_chain_nat_ipv4 = {
-	.name		= "nat",
-	.type		= NFT_CHAIN_T_NAT,
-	.family		= NFPROTO_IPV4,
-	.owner		= THIS_MODULE,
-	.hook_mask	= (1 << NF_INET_PRE_ROUTING) |
-			  (1 << NF_INET_POST_ROUTING) |
-			  (1 << NF_INET_LOCAL_OUT) |
-			  (1 << NF_INET_LOCAL_IN),
-	.hooks		= {
-		[NF_INET_PRE_ROUTING]	= nft_nat_do_chain,
-		[NF_INET_POST_ROUTING]	= nft_nat_do_chain,
-		[NF_INET_LOCAL_OUT]	= nft_nat_do_chain,
-		[NF_INET_LOCAL_IN]	= nft_nat_do_chain,
-	},
-	.ops_register = nft_nat_ipv4_reg,
-	.ops_unregister = nft_nat_ipv4_unreg,
-};
-
-static int __init nft_chain_nat_init(void)
-{
-	nft_register_chain_type(&nft_chain_nat_ipv4);
-
-	return 0;
-}
-
-static void __exit nft_chain_nat_exit(void)
-{
-	nft_unregister_chain_type(&nft_chain_nat_ipv4);
-}
-
-module_init(nft_chain_nat_init);
-module_exit(nft_chain_nat_exit);
-
-MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Patrick McHardy <kaber@trash.net>");
-MODULE_ALIAS_NFT_CHAIN(AF_INET, "nat");
diff --git a/net/ipv6/netfilter/Kconfig b/net/ipv6/netfilter/Kconfig
index b95351a5cb83..ddc99a1653aa 100644
--- a/net/ipv6/netfilter/Kconfig
+++ b/net/ipv6/netfilter/Kconfig
@@ -31,17 +31,6 @@ config NFT_CHAIN_ROUTE_IPV6
 	  fields such as the source, destination, flowlabel, hop-limit and
 	  the packet mark.
 
-if NF_NAT
-
-config NFT_CHAIN_NAT_IPV6
-	tristate "IPv6 nf_tables nat chain support"
-	help
-	  This option enables the "nat" chain for IPv6 in nf_tables. This
-	  chain type is used to perform Network Address Translation (NAT)
-	  packet transformations such as the source, destination address and
-	  source and destination ports.
-endif # NF_NAT
-
 config NFT_REJECT_IPV6
 	select NF_REJECT_IPV6
 	default NFT_REJECT
diff --git a/net/ipv6/netfilter/Makefile b/net/ipv6/netfilter/Makefile
index 06c1829f8ffc..3853c648ebaa 100644
--- a/net/ipv6/netfilter/Makefile
+++ b/net/ipv6/netfilter/Makefile
@@ -28,7 +28,6 @@ obj-$(CONFIG_NF_DUP_IPV6) += nf_dup_ipv6.o
 
 # nf_tables
 obj-$(CONFIG_NFT_CHAIN_ROUTE_IPV6) += nft_chain_route_ipv6.o
-obj-$(CONFIG_NFT_CHAIN_NAT_IPV6) += nft_chain_nat_ipv6.o
 obj-$(CONFIG_NFT_REJECT_IPV6) += nft_reject_ipv6.o
 obj-$(CONFIG_NFT_DUP_IPV6) += nft_dup_ipv6.o
 obj-$(CONFIG_NFT_FIB_IPV6) += nft_fib_ipv6.o
diff --git a/net/ipv6/netfilter/nft_chain_nat_ipv6.c b/net/ipv6/netfilter/nft_chain_nat_ipv6.c
deleted file mode 100644
index e66bfd0b3d15..000000000000
--- a/net/ipv6/netfilter/nft_chain_nat_ipv6.c
+++ /dev/null
@@ -1,83 +0,0 @@
-/*
- * Copyright (c) 2011 Patrick McHardy <kaber@trash.net>
- * Copyright (c) 2012 Intel Corporation
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms and conditions of the GNU General Public License,
- * version 2, as published by the Free Software Foundation.
- *
- */
-
-#include <linux/module.h>
-#include <linux/init.h>
-#include <linux/list.h>
-#include <linux/skbuff.h>
-#include <linux/ip.h>
-#include <linux/netfilter.h>
-#include <linux/netfilter_ipv6.h>
-#include <linux/netfilter/nf_tables.h>
-#include <net/netfilter/nf_conntrack.h>
-#include <net/netfilter/nf_nat.h>
-#include <net/netfilter/nf_tables.h>
-#include <net/netfilter/nf_tables_ipv6.h>
-#include <net/ipv6.h>
-
-static unsigned int nft_nat_do_chain(void *priv,
-				     struct sk_buff *skb,
-				     const struct nf_hook_state *state)
-{
-	struct nft_pktinfo pkt;
-
-	nft_set_pktinfo(&pkt, skb, state);
-	nft_set_pktinfo_ipv6(&pkt, skb);
-
-	return nft_do_chain(&pkt, priv);
-}
-
-static int nft_nat_ipv6_reg(struct net *net, const struct nf_hook_ops *ops)
-{
-	return nf_nat_ipv6_register_fn(net, ops);
-}
-
-static void nft_nat_ipv6_unreg(struct net *net, const struct nf_hook_ops *ops)
-{
-	nf_nat_ipv6_unregister_fn(net, ops);
-}
-
-static const struct nft_chain_type nft_chain_nat_ipv6 = {
-	.name		= "nat",
-	.type		= NFT_CHAIN_T_NAT,
-	.family		= NFPROTO_IPV6,
-	.owner		= THIS_MODULE,
-	.hook_mask	= (1 << NF_INET_PRE_ROUTING) |
-			  (1 << NF_INET_POST_ROUTING) |
-			  (1 << NF_INET_LOCAL_OUT) |
-			  (1 << NF_INET_LOCAL_IN),
-	.hooks		= {
-		[NF_INET_PRE_ROUTING]	= nft_nat_do_chain,
-		[NF_INET_POST_ROUTING]	= nft_nat_do_chain,
-		[NF_INET_LOCAL_OUT]	= nft_nat_do_chain,
-		[NF_INET_LOCAL_IN]	= nft_nat_do_chain,
-	},
-	.ops_register		= nft_nat_ipv6_reg,
-	.ops_unregister		= nft_nat_ipv6_unreg,
-};
-
-static int __init nft_chain_nat_ipv6_init(void)
-{
-	nft_register_chain_type(&nft_chain_nat_ipv6);
-
-	return 0;
-}
-
-static void __exit nft_chain_nat_ipv6_exit(void)
-{
-	nft_unregister_chain_type(&nft_chain_nat_ipv6);
-}
-
-module_init(nft_chain_nat_ipv6_init);
-module_exit(nft_chain_nat_ipv6_exit);
-
-MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>");
-MODULE_ALIAS_NFT_CHAIN(AF_INET6, "nat");
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 537f23a8ed52..d43ffb09939b 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -550,6 +550,7 @@ config NFT_REDIR
 config NFT_NAT
 	depends on NF_CONNTRACK
 	select NF_NAT
+	depends on NF_TABLES_IPV4 || NF_TABLES_IPV6
 	tristate "Netfilter nf_tables nat module"
 	help
 	  This option adds the "nat" expression that you can use to perform
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index c7910706f8dd..4894a85cdd0b 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -110,6 +110,8 @@ obj-$(CONFIG_NFT_OSF)		+= nft_osf.o
 obj-$(CONFIG_NFT_TPROXY)	+= nft_tproxy.o
 obj-$(CONFIG_NFT_XFRM)		+= nft_xfrm.o
 
+obj-$(CONFIG_NFT_NAT)		+= nft_chain_nat.o
+
 # nf_tables netdev
 obj-$(CONFIG_NFT_DUP_NETDEV)	+= nft_dup_netdev.o
 obj-$(CONFIG_NFT_FWD_NETDEV)	+= nft_fwd_netdev.o
diff --git a/net/netfilter/nft_chain_nat.c b/net/netfilter/nft_chain_nat.c
new file mode 100644
index 000000000000..ee4852088d50
--- /dev/null
+++ b/net/netfilter/nft_chain_nat.c
@@ -0,0 +1,108 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <linux/module.h>
+#include <linux/netfilter/nf_tables.h>
+#include <net/netfilter/nf_nat.h>
+#include <net/netfilter/nf_tables.h>
+#include <net/netfilter/nf_tables_ipv4.h>
+#include <net/netfilter/nf_tables_ipv6.h>
+
+static unsigned int nft_nat_do_chain(void *priv, struct sk_buff *skb,
+				     const struct nf_hook_state *state)
+{
+	struct nft_pktinfo pkt;
+
+	nft_set_pktinfo(&pkt, skb, state);
+
+	switch (state->pf) {
+#ifdef CONFIG_NF_TABLES_IPV4
+	case NFPROTO_IPV4:
+		nft_set_pktinfo_ipv4(&pkt, skb);
+		break;
+#endif
+#ifdef CONFIG_NF_TABLES_IPV6
+	case NFPROTO_IPV6:
+		nft_set_pktinfo_ipv6(&pkt, skb);
+		break;
+#endif
+	default:
+		break;
+	}
+
+	return nft_do_chain(&pkt, priv);
+}
+
+#ifdef CONFIG_NF_TABLES_IPV4
+static const struct nft_chain_type nft_chain_nat_ipv4 = {
+	.name		= "nat",
+	.type		= NFT_CHAIN_T_NAT,
+	.family		= NFPROTO_IPV4,
+	.owner		= THIS_MODULE,
+	.hook_mask	= (1 << NF_INET_PRE_ROUTING) |
+			  (1 << NF_INET_POST_ROUTING) |
+			  (1 << NF_INET_LOCAL_OUT) |
+			  (1 << NF_INET_LOCAL_IN),
+	.hooks		= {
+		[NF_INET_PRE_ROUTING]	= nft_nat_do_chain,
+		[NF_INET_POST_ROUTING]	= nft_nat_do_chain,
+		[NF_INET_LOCAL_OUT]	= nft_nat_do_chain,
+		[NF_INET_LOCAL_IN]	= nft_nat_do_chain,
+	},
+	.ops_register = nf_nat_ipv4_register_fn,
+	.ops_unregister = nf_nat_ipv4_unregister_fn,
+};
+#endif
+
+#ifdef CONFIG_NF_TABLES_IPV6
+static const struct nft_chain_type nft_chain_nat_ipv6 = {
+	.name		= "nat",
+	.type		= NFT_CHAIN_T_NAT,
+	.family		= NFPROTO_IPV6,
+	.owner		= THIS_MODULE,
+	.hook_mask	= (1 << NF_INET_PRE_ROUTING) |
+			  (1 << NF_INET_POST_ROUTING) |
+			  (1 << NF_INET_LOCAL_OUT) |
+			  (1 << NF_INET_LOCAL_IN),
+	.hooks		= {
+		[NF_INET_PRE_ROUTING]	= nft_nat_do_chain,
+		[NF_INET_POST_ROUTING]	= nft_nat_do_chain,
+		[NF_INET_LOCAL_OUT]	= nft_nat_do_chain,
+		[NF_INET_LOCAL_IN]	= nft_nat_do_chain,
+	},
+	.ops_register		= nf_nat_ipv6_register_fn,
+	.ops_unregister		= nf_nat_ipv6_unregister_fn,
+};
+#endif
+
+static int __init nft_chain_nat_init(void)
+{
+#ifdef CONFIG_NF_TABLES_IPV6
+	nft_register_chain_type(&nft_chain_nat_ipv6);
+#endif
+#ifdef CONFIG_NF_TABLES_IPV4
+	nft_register_chain_type(&nft_chain_nat_ipv4);
+#endif
+
+	return 0;
+}
+
+static void __exit nft_chain_nat_exit(void)
+{
+#ifdef CONFIG_NF_TABLES_IPV4
+	nft_unregister_chain_type(&nft_chain_nat_ipv4);
+#endif
+#ifdef CONFIG_NF_TABLES_IPV6
+	nft_unregister_chain_type(&nft_chain_nat_ipv6);
+#endif
+}
+
+module_init(nft_chain_nat_init);
+module_exit(nft_chain_nat_exit);
+
+MODULE_LICENSE("GPL");
+#ifdef CONFIG_NF_TABLES_IPV4
+MODULE_ALIAS_NFT_CHAIN(AF_INET, "nat");
+#endif
+#ifdef CONFIG_NF_TABLES_IPV6
+MODULE_ALIAS_NFT_CHAIN(AF_INET6, "nat");
+#endif
-- 
2.19.2

