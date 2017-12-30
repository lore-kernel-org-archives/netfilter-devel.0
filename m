From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf-next RFC 8/8] netfilter: nf_tables: consolidate filter chain definitions
Date: Sun, 31 Dec 2017 00:13:48 +0100
Message-ID: <20171230231348.5497-9-pablo@netfilter.org>
References: <20171230231348.5497-1-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39220 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751134AbdL3XOB (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 30 Dec 2017 18:14:01 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 0AC18C51B9
        for <netfilter-devel@vger.kernel.org>; Sun, 31 Dec 2017 00:14:00 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E408E71D2
        for <netfilter-devel@vger.kernel.org>; Sun, 31 Dec 2017 00:13:59 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id BA23B71D2
        for <netfilter-devel@vger.kernel.org>; Sun, 31 Dec 2017 00:13:56 +0100 (CET)
Received: from salvia.here (40.red-212-170-55.staticip.rima-tde.net [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 81CC24265A32
        for <netfilter-devel@vger.kernel.org>; Sun, 31 Dec 2017 00:13:56 +0100 (CET)
In-Reply-To: <20171230231348.5497-1-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Enable filter chain by default. This was not the case in iptables, given
this came with an implicit hook registration that has a performance
penalty. In nftables, this is not the case anymore given that chains are
explicitly define by the user.

Place all filter chains in one single file to get rid of quite a bit of
boiler plate code.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h       |   3 +
 net/bridge/netfilter/Makefile           |   1 -
 net/bridge/netfilter/nf_tables_bridge.c |  79 ---------
 net/ipv4/netfilter/Makefile             |   2 -
 net/ipv4/netfilter/nf_tables_ipv4.c     |  67 --------
 net/ipv6/netfilter/Makefile             |   1 -
 net/ipv6/netfilter/nf_tables_ipv6.c     |  65 -------
 net/netfilter/Makefile                  |   5 +-
 net/netfilter/nf_tables_api.c           |   9 +-
 net/netfilter/nf_tables_inet.c          |  96 -----------
 net/netfilter/nf_tables_netdev.c        | 142 ---------------
 net/netfilter/nft_chain_filter.c        | 294 ++++++++++++++++++++++++++++++++
 12 files changed, 307 insertions(+), 457 deletions(-)
 delete mode 100644 net/bridge/netfilter/nf_tables_bridge.c
 delete mode 100644 net/ipv4/netfilter/nf_tables_ipv4.c
 delete mode 100644 net/ipv6/netfilter/nf_tables_ipv6.c
 delete mode 100644 net/netfilter/nf_tables_inet.c
 delete mode 100644 net/netfilter/nf_tables_netdev.c
 create mode 100644 net/netfilter/nft_chain_filter.c

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 5a3b4b9abb1b..730f2898ef66 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1089,6 +1089,9 @@ void nft_trace_init(struct nft_traceinfo *info, const struct nft_pktinfo *pkt,
 
 void nft_trace_notify(struct nft_traceinfo *info);
 
+int nf_tables_filter_init(void);
+void nf_tables_filter_fini(void);
+
 #define nft_dereference(p)					\
 	nfnl_dereference(p, NFNL_SUBSYS_NFTABLES)
 
diff --git a/net/bridge/netfilter/Makefile b/net/bridge/netfilter/Makefile
index 2f28e16de6c7..4bc758dd4a8c 100644
--- a/net/bridge/netfilter/Makefile
+++ b/net/bridge/netfilter/Makefile
@@ -3,7 +3,6 @@
 # Makefile for the netfilter modules for Link Layer filtering on a bridge.
 #
 
-obj-$(CONFIG_NF_TABLES_BRIDGE) += nf_tables_bridge.o
 obj-$(CONFIG_NFT_BRIDGE_META)  += nft_meta_bridge.o
 obj-$(CONFIG_NFT_BRIDGE_REJECT)  += nft_reject_bridge.o
 
diff --git a/net/bridge/netfilter/nf_tables_bridge.c b/net/bridge/netfilter/nf_tables_bridge.c
deleted file mode 100644
index 5160cf614176..000000000000
--- a/net/bridge/netfilter/nf_tables_bridge.c
+++ /dev/null
@@ -1,79 +0,0 @@
-/*
- * Copyright (c) 2008 Patrick McHardy <kaber@trash.net>
- * Copyright (c) 2013 Pablo Neira Ayuso <pablo@netfilter.org>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- *
- * Development of this code funded by Astaro AG (http://www.astaro.com/)
- */
-
-#include <linux/init.h>
-#include <linux/module.h>
-#include <linux/netfilter_bridge.h>
-#include <net/netfilter/nf_tables.h>
-#include <linux/ip.h>
-#include <linux/ipv6.h>
-#include <net/netfilter/nf_tables_ipv4.h>
-#include <net/netfilter/nf_tables_ipv6.h>
-
-static unsigned int
-nft_do_chain_bridge(void *priv,
-		    struct sk_buff *skb,
-		    const struct nf_hook_state *state)
-{
-	struct nft_pktinfo pkt;
-
-	nft_set_pktinfo(&pkt, skb, state);
-
-	switch (eth_hdr(skb)->h_proto) {
-	case htons(ETH_P_IP):
-		nft_set_pktinfo_ipv4_validate(&pkt, skb);
-		break;
-	case htons(ETH_P_IPV6):
-		nft_set_pktinfo_ipv6_validate(&pkt, skb);
-		break;
-	default:
-		nft_set_pktinfo_unspec(&pkt, skb);
-		break;
-	}
-
-	return nft_do_chain(&pkt, priv);
-}
-
-static const struct nf_chain_type filter_bridge = {
-	.name		= "filter",
-	.type		= NFT_CHAIN_T_DEFAULT,
-	.family		= NFPROTO_BRIDGE,
-	.owner		= THIS_MODULE,
-	.hook_mask	= (1 << NF_BR_PRE_ROUTING) |
-			  (1 << NF_BR_LOCAL_IN) |
-			  (1 << NF_BR_FORWARD) |
-			  (1 << NF_BR_LOCAL_OUT) |
-			  (1 << NF_BR_POST_ROUTING),
-	.hooks		= {
-		[NF_BR_PRE_ROUTING]	= nft_do_chain_bridge,
-		[NF_BR_LOCAL_IN]	= nft_do_chain_bridge,
-		[NF_BR_FORWARD]		= nft_do_chain_bridge,
-		[NF_BR_LOCAL_OUT]	= nft_do_chain_bridge,
-		[NF_BR_POST_ROUTING]	= nft_do_chain_bridge,
-	},
-};
-
-static int __init nf_tables_bridge_init(void)
-{
-	return nft_register_chain_type(&filter_bridge);
-}
-
-static void __exit nf_tables_bridge_exit(void)
-{
-	nft_unregister_chain_type(&filter_bridge);
-}
-
-module_init(nf_tables_bridge_init);
-module_exit(nf_tables_bridge_exit);
-
-MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Patrick McHardy <kaber@trash.net>");
-MODULE_ALIAS_NFT_CHAIN(AF_BRIDGE, "filter");
diff --git a/net/ipv4/netfilter/Makefile b/net/ipv4/netfilter/Makefile
index adcdae358365..185fec48c2f7 100644
--- a/net/ipv4/netfilter/Makefile
+++ b/net/ipv4/netfilter/Makefile
@@ -33,7 +33,6 @@ obj-$(CONFIG_NF_NAT_MASQUERADE_IPV4) += nf_nat_masquerade_ipv4.o
 # NAT protocols (nf_nat)
 obj-$(CONFIG_NF_NAT_PROTO_GRE) += nf_nat_proto_gre.o
 
-obj-$(CONFIG_NF_TABLES_IPV4) += nf_tables_ipv4.o
 obj-$(CONFIG_NFT_CHAIN_ROUTE_IPV4) += nft_chain_route_ipv4.o
 obj-$(CONFIG_NFT_CHAIN_NAT_IPV4) += nft_chain_nat_ipv4.o
 obj-$(CONFIG_NFT_REJECT_IPV4) += nft_reject_ipv4.o
@@ -41,7 +40,6 @@ obj-$(CONFIG_NFT_FIB_IPV4) += nft_fib_ipv4.o
 obj-$(CONFIG_NFT_MASQ_IPV4) += nft_masq_ipv4.o
 obj-$(CONFIG_NFT_REDIR_IPV4) += nft_redir_ipv4.o
 obj-$(CONFIG_NFT_DUP_IPV4) += nft_dup_ipv4.o
-obj-$(CONFIG_NF_TABLES_ARP) += nf_tables_arp.o
 
 # generic IP tables 
 obj-$(CONFIG_IP_NF_IPTABLES) += ip_tables.o
diff --git a/net/ipv4/netfilter/nf_tables_ipv4.c b/net/ipv4/netfilter/nf_tables_ipv4.c
deleted file mode 100644
index 96f955496d5f..000000000000
--- a/net/ipv4/netfilter/nf_tables_ipv4.c
+++ /dev/null
@@ -1,67 +0,0 @@
-/*
- * Copyright (c) 2008 Patrick McHardy <kaber@trash.net>
- * Copyright (c) 2012-2013 Pablo Neira Ayuso <pablo@netfilter.org>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- *
- * Development of this code funded by Astaro AG (http://www.astaro.com/)
- */
-
-#include <linux/init.h>
-#include <linux/module.h>
-#include <linux/ip.h>
-#include <linux/netfilter_ipv4.h>
-#include <net/netfilter/nf_tables.h>
-#include <net/net_namespace.h>
-#include <net/ip.h>
-#include <net/netfilter/nf_tables_ipv4.h>
-
-static unsigned int nft_do_chain_ipv4(void *priv,
-				      struct sk_buff *skb,
-				      const struct nf_hook_state *state)
-{
-	struct nft_pktinfo pkt;
-
-	nft_set_pktinfo(&pkt, skb, state);
-	nft_set_pktinfo_ipv4(&pkt, skb);
-
-	return nft_do_chain(&pkt, priv);
-}
-
-static const struct nf_chain_type filter_ipv4 = {
-	.name		= "filter",
-	.type		= NFT_CHAIN_T_DEFAULT,
-	.family		= NFPROTO_IPV4,
-	.owner		= THIS_MODULE,
-	.hook_mask	= (1 << NF_INET_LOCAL_IN) |
-			  (1 << NF_INET_LOCAL_OUT) |
-			  (1 << NF_INET_FORWARD) |
-			  (1 << NF_INET_PRE_ROUTING) |
-			  (1 << NF_INET_POST_ROUTING),
-	.hooks		= {
-		[NF_INET_LOCAL_IN]	= nft_do_chain_ipv4,
-		[NF_INET_LOCAL_OUT]	= nft_do_chain_ipv4,
-		[NF_INET_FORWARD]	= nft_do_chain_ipv4,
-		[NF_INET_PRE_ROUTING]	= nft_do_chain_ipv4,
-		[NF_INET_POST_ROUTING]	= nft_do_chain_ipv4,
-	},
-};
-
-static int __init nf_tables_ipv4_init(void)
-{
-	return nft_register_chain_type(&filter_ipv4);
-}
-
-static void __exit nf_tables_ipv4_exit(void)
-{
-	nft_unregister_chain_type(&filter_ipv4);
-}
-
-module_init(nf_tables_ipv4_init);
-module_exit(nf_tables_ipv4_exit);
-
-MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Patrick McHardy <kaber@trash.net>");
-MODULE_ALIAS_NFT_CHAIN(AF_INET, "filter");
diff --git a/net/ipv6/netfilter/Makefile b/net/ipv6/netfilter/Makefile
index c6ee0cdd0ba9..421977da41a1 100644
--- a/net/ipv6/netfilter/Makefile
+++ b/net/ipv6/netfilter/Makefile
@@ -36,7 +36,6 @@ obj-$(CONFIG_NF_REJECT_IPV6) += nf_reject_ipv6.o
 obj-$(CONFIG_NF_DUP_IPV6) += nf_dup_ipv6.o
 
 # nf_tables
-obj-$(CONFIG_NF_TABLES_IPV6) += nf_tables_ipv6.o
 obj-$(CONFIG_NFT_CHAIN_ROUTE_IPV6) += nft_chain_route_ipv6.o
 obj-$(CONFIG_NFT_CHAIN_NAT_IPV6) += nft_chain_nat_ipv6.o
 obj-$(CONFIG_NFT_REJECT_IPV6) += nft_reject_ipv6.o
diff --git a/net/ipv6/netfilter/nf_tables_ipv6.c b/net/ipv6/netfilter/nf_tables_ipv6.c
deleted file mode 100644
index 17e03589331c..000000000000
--- a/net/ipv6/netfilter/nf_tables_ipv6.c
+++ /dev/null
@@ -1,65 +0,0 @@
-/*
- * Copyright (c) 2008 Patrick McHardy <kaber@trash.net>
- * Copyright (c) 2012-2013 Pablo Neira Ayuso <pablo@netfilter.org>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- *
- * Development of this code funded by Astaro AG (http://www.astaro.com/)
- */
-
-#include <linux/init.h>
-#include <linux/module.h>
-#include <linux/ipv6.h>
-#include <linux/netfilter_ipv6.h>
-#include <net/netfilter/nf_tables.h>
-#include <net/netfilter/nf_tables_ipv6.h>
-
-static unsigned int nft_do_chain_ipv6(void *priv,
-				      struct sk_buff *skb,
-				      const struct nf_hook_state *state)
-{
-	struct nft_pktinfo pkt;
-
-	nft_set_pktinfo(&pkt, skb, state);
-	nft_set_pktinfo_ipv6(&pkt, skb);
-
-	return nft_do_chain(&pkt, priv);
-}
-
-static const struct nf_chain_type filter_ipv6 = {
-	.name		= "filter",
-	.type		= NFT_CHAIN_T_DEFAULT,
-	.family		= NFPROTO_IPV6,
-	.owner		= THIS_MODULE,
-	.hook_mask	= (1 << NF_INET_LOCAL_IN) |
-			  (1 << NF_INET_LOCAL_OUT) |
-			  (1 << NF_INET_FORWARD) |
-			  (1 << NF_INET_PRE_ROUTING) |
-			  (1 << NF_INET_POST_ROUTING),
-	.hooks		= {
-		[NF_INET_LOCAL_IN]	= nft_do_chain_ipv6,
-		[NF_INET_LOCAL_OUT]	= nft_do_chain_ipv6,
-		[NF_INET_FORWARD]	= nft_do_chain_ipv6,
-		[NF_INET_PRE_ROUTING]	= nft_do_chain_ipv6,
-		[NF_INET_POST_ROUTING]	= nft_do_chain_ipv6,
-	},
-};
-
-static int __init nf_tables_ipv6_init(void)
-{
-	return nft_register_chain_type(&filter_ipv6);
-}
-
-static void __exit nf_tables_ipv6_exit(void)
-{
-	nft_unregister_chain_type(&filter_ipv6);
-}
-
-module_init(nf_tables_ipv6_init);
-module_exit(nf_tables_ipv6_exit);
-
-MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Patrick McHardy <kaber@trash.net>");
-MODULE_ALIAS_NFT_CHAIN(AF_INET6, "filter");
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index eec0c3b72926..fe9b4d31567e 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -73,13 +73,12 @@ obj-$(CONFIG_NETFILTER_CONNCOUNT) += nf_conncount.o
 obj-$(CONFIG_NF_DUP_NETDEV)	+= nf_dup_netdev.o
 
 # nf_tables
-nf_tables-objs := nf_tables_core.o nf_tables_api.o nf_tables_trace.o \
+nf_tables-objs := nf_tables_core.o nft_chain_filter.o \
+		  nf_tables_api.o nf_tables_trace.o \
 		  nft_immediate.o nft_cmp.o nft_range.o nft_bitwise.o \
 		  nft_byteorder.o nft_payload.o nft_lookup.o nft_dynset.o
 
 obj-$(CONFIG_NF_TABLES)		+= nf_tables.o
-obj-$(CONFIG_NF_TABLES_INET)	+= nf_tables_inet.o
-obj-$(CONFIG_NF_TABLES_NETDEV)	+= nf_tables_netdev.o
 obj-$(CONFIG_NFT_COMPAT)	+= nft_compat.o
 obj-$(CONFIG_NFT_EXTHDR)	+= nft_exthdr.o
 obj-$(CONFIG_NFT_META)		+= nft_meta.o
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 93bf276bc602..c6289404207b 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -5750,12 +5750,18 @@ static int __init nf_tables_module_init(void)
 	if (err < 0)
 		goto err2;
 
-	err = nfnetlink_subsys_register(&nf_tables_subsys);
+	err = nf_tables_filter_init();
 	if (err < 0)
 		goto err3;
 
+	err = nfnetlink_subsys_register(&nf_tables_subsys);
+	if (err < 0)
+		goto err4;
+
 	pr_info("nf_tables: (c) 2007-2009 Patrick McHardy <kaber@trash.net>\n");
 	return register_pernet_subsys(&nf_tables_net_ops);
+err4:
+	nf_tables_filter_fini();
 err3:
 	nf_tables_core_module_exit();
 err2:
@@ -5768,6 +5774,7 @@ static void __exit nf_tables_module_exit(void)
 {
 	unregister_pernet_subsys(&nf_tables_net_ops);
 	nfnetlink_subsys_unregister(&nf_tables_subsys);
+	nf_tables_filter_fini();
 	rcu_barrier();
 	nf_tables_core_module_exit();
 	kfree(info);
diff --git a/net/netfilter/nf_tables_inet.c b/net/netfilter/nf_tables_inet.c
deleted file mode 100644
index 94ba72f4dc6d..000000000000
--- a/net/netfilter/nf_tables_inet.c
+++ /dev/null
@@ -1,96 +0,0 @@
-/*
- * Copyright (c) 2012-2014 Patrick McHardy <kaber@trash.net>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-
-#include <linux/init.h>
-#include <linux/module.h>
-#include <linux/ip.h>
-#include <linux/ipv6.h>
-#include <linux/netfilter_ipv4.h>
-#include <linux/netfilter_ipv6.h>
-#include <net/netfilter/nf_tables.h>
-#include <net/netfilter/nf_tables_ipv4.h>
-#include <net/netfilter/nf_tables_ipv6.h>
-#include <net/ip.h>
-
-static unsigned int nft_do_chain_inet(void *priv, struct sk_buff *skb,
-				      const struct nf_hook_state *state)
-{
-	struct nft_pktinfo pkt;
-
-	nft_set_pktinfo(&pkt, skb, state);
-
-	switch (state->pf) {
-	case NFPROTO_IPV4:
-		nft_set_pktinfo_ipv4(&pkt, skb);
-		break;
-	case NFPROTO_IPV6:
-		nft_set_pktinfo_ipv6(&pkt, skb);
-		break;
-	default:
-		break;
-	}
-
-	return nft_do_chain(&pkt, priv);
-}
-
-static unsigned int nft_inet_output(void *priv, struct sk_buff *skb,
-				    const struct nf_hook_state *state)
-{
-	struct nft_pktinfo pkt;
-
-	nft_set_pktinfo(&pkt, skb, state);
-
-	switch (state->pf) {
-	case NFPROTO_IPV4:
-		nft_set_pktinfo_ipv4(&pkt, skb);
-		break;
-	case NFPROTO_IPV6:
-		nft_set_pktinfo_ipv6(&pkt, skb);
-		break;
-	default:
-		break;
-	}
-
-	return nft_do_chain(&pkt, priv);
-}
-
-static const struct nf_chain_type filter_inet = {
-	.name		= "filter",
-	.type		= NFT_CHAIN_T_DEFAULT,
-	.family		= NFPROTO_INET,
-	.owner		= THIS_MODULE,
-	.hook_mask	= (1 << NF_INET_LOCAL_IN) |
-			  (1 << NF_INET_LOCAL_OUT) |
-			  (1 << NF_INET_FORWARD) |
-			  (1 << NF_INET_PRE_ROUTING) |
-			  (1 << NF_INET_POST_ROUTING),
-	.hooks		= {
-		[NF_INET_LOCAL_IN]	= nft_do_chain_inet,
-		[NF_INET_LOCAL_OUT]	= nft_inet_output,
-		[NF_INET_FORWARD]	= nft_do_chain_inet,
-		[NF_INET_PRE_ROUTING]	= nft_do_chain_inet,
-		[NF_INET_POST_ROUTING]	= nft_do_chain_inet,
-        },
-};
-
-static int __init nf_tables_inet_init(void)
-{
-	return nft_register_chain_type(&filter_inet);
-}
-
-static void __exit nf_tables_inet_exit(void)
-{
-	nft_unregister_chain_type(&filter_inet);
-}
-
-module_init(nf_tables_inet_init);
-module_exit(nf_tables_inet_exit);
-
-MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Patrick McHardy <kaber@trash.net>");
-+MODULE_ALIAS_NFT_CHAIN(1, "filter");
diff --git a/net/netfilter/nf_tables_netdev.c b/net/netfilter/nf_tables_netdev.c
deleted file mode 100644
index 4041fafca934..000000000000
--- a/net/netfilter/nf_tables_netdev.c
+++ /dev/null
@@ -1,142 +0,0 @@
-/*
- * Copyright (c) 2015 Pablo Neira Ayuso <pablo@netfilter.org>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-
-#include <linux/init.h>
-#include <linux/module.h>
-#include <linux/netdevice.h>
-#include <net/netfilter/nf_tables.h>
-#include <linux/ip.h>
-#include <linux/ipv6.h>
-#include <net/netfilter/nf_tables_ipv4.h>
-#include <net/netfilter/nf_tables_ipv6.h>
-
-static unsigned int
-nft_do_chain_netdev(void *priv, struct sk_buff *skb,
-		    const struct nf_hook_state *state)
-{
-	struct nft_pktinfo pkt;
-
-	nft_set_pktinfo(&pkt, skb, state);
-
-	switch (skb->protocol) {
-	case htons(ETH_P_IP):
-		nft_set_pktinfo_ipv4_validate(&pkt, skb);
-		break;
-	case htons(ETH_P_IPV6):
-		nft_set_pktinfo_ipv6_validate(&pkt, skb);
-		break;
-	default:
-		nft_set_pktinfo_unspec(&pkt, skb);
-		break;
-	}
-
-	return nft_do_chain(&pkt, priv);
-}
-
-static const struct nf_chain_type nft_filter_chain_netdev = {
-	.name		= "filter",
-	.type		= NFT_CHAIN_T_DEFAULT,
-	.family		= NFPROTO_NETDEV,
-	.owner		= THIS_MODULE,
-	.hook_mask	= (1 << NF_NETDEV_INGRESS),
-	.hooks		= {
-		[NF_NETDEV_INGRESS]	= nft_do_chain_netdev,
-	},
-};
-
-static void nft_netdev_event(unsigned long event, struct net_device *dev,
-			     struct nft_ctx *ctx)
-{
-	struct nft_base_chain *basechain = nft_base_chain(ctx->chain);
-
-	switch (event) {
-	case NETDEV_UNREGISTER:
-		if (strcmp(basechain->dev_name, dev->name) != 0)
-			return;
-
-		__nft_release_basechain(ctx);
-		break;
-	case NETDEV_CHANGENAME:
-		if (dev->ifindex != basechain->ops.dev->ifindex)
-			return;
-
-		strncpy(basechain->dev_name, dev->name, IFNAMSIZ);
-		break;
-	}
-}
-
-static int nf_tables_netdev_event(struct notifier_block *this,
-				  unsigned long event, void *ptr)
-{
-	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
-	struct nft_table *table;
-	struct nft_chain *chain, *nr;
-	struct nft_ctx ctx = {
-		.net	= dev_net(dev),
-	};
-
-	if (event != NETDEV_UNREGISTER &&
-	    event != NETDEV_CHANGENAME)
-		return NOTIFY_DONE;
-
-	nfnl_lock(NFNL_SUBSYS_NFTABLES);
-	list_for_each_entry(table, &ctx.net->nft.tables, list) {
-		if (table->family != NFPROTO_NETDEV)
-			continue;
-
-		ctx.family = table->family;
-		ctx.table = table;
-		list_for_each_entry_safe(chain, nr, &table->chains, list) {
-			if (!nft_is_base_chain(chain))
-				continue;
-
-			ctx.chain = chain;
-			nft_netdev_event(event, dev, &ctx);
-		}
-	}
-	nfnl_unlock(NFNL_SUBSYS_NFTABLES);
-
-	return NOTIFY_DONE;
-}
-
-static struct notifier_block nf_tables_netdev_notifier = {
-	.notifier_call	= nf_tables_netdev_event,
-};
-
-static int __init nf_tables_netdev_init(void)
-{
-	int ret;
-
-	ret = nft_register_chain_type(&nft_filter_chain_netdev);
-	if (ret)
-		return ret;
-
-	ret = register_netdevice_notifier(&nf_tables_netdev_notifier);
-	if (ret)
-		goto err_register_netdevice_notifier;
-
-	return 0;
-
-err_register_netdevice_notifier:
-	nft_unregister_chain_type(&nft_filter_chain_netdev);
-
-	return ret;
-}
-
-static void __exit nf_tables_netdev_exit(void)
-{
-	unregister_netdevice_notifier(&nf_tables_netdev_notifier);
-	nft_unregister_chain_type(&nft_filter_chain_netdev);
-}
-
-module_init(nf_tables_netdev_init);
-module_exit(nf_tables_netdev_exit);
-
-MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Pablo Neira Ayuso <pablo@netfilter.org>");
-MODULE_ALIAS_NFT_CHAIN(5, "filter"); /* NFPROTO_NETDEV */
diff --git a/net/netfilter/nft_chain_filter.c b/net/netfilter/nft_chain_filter.c
new file mode 100644
index 000000000000..76612f4572dc
--- /dev/null
+++ b/net/netfilter/nft_chain_filter.c
@@ -0,0 +1,294 @@
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/netfilter_bridge.h>
+#include <linux/netfilter_arp.h>
+#include <net/netfilter/nf_tables.h>
+#include <net/netfilter/nf_tables_ipv4.h>
+#include <net/netfilter/nf_tables_ipv6.h>
+
+static unsigned int nft_do_chain_ipv4(void *priv, struct sk_buff *skb,
+				      const struct nf_hook_state *state)
+{
+	struct nft_pktinfo pkt;
+
+	nft_set_pktinfo(&pkt, skb, state);
+	nft_set_pktinfo_ipv4(&pkt, skb);
+
+	return nft_do_chain(&pkt, priv);
+}
+
+static const struct nf_chain_type filter_ipv4 = {
+	.name		= "filter",
+	.type		= NFT_CHAIN_T_DEFAULT,
+	.family		= NFPROTO_IPV4,
+	.owner		= THIS_MODULE,
+	.hook_mask	= (1 << NF_INET_LOCAL_IN) |
+			  (1 << NF_INET_LOCAL_OUT) |
+			  (1 << NF_INET_FORWARD) |
+			  (1 << NF_INET_PRE_ROUTING) |
+			  (1 << NF_INET_POST_ROUTING),
+	.hooks		= {
+		[NF_INET_LOCAL_IN]	= nft_do_chain_ipv4,
+		[NF_INET_LOCAL_OUT]	= nft_do_chain_ipv4,
+		[NF_INET_FORWARD]	= nft_do_chain_ipv4,
+		[NF_INET_PRE_ROUTING]	= nft_do_chain_ipv4,
+		[NF_INET_POST_ROUTING]	= nft_do_chain_ipv4,
+	},
+};
+
+static unsigned int nft_do_chain_ipv6(void *priv, struct sk_buff *skb,
+				      const struct nf_hook_state *state)
+{
+	struct nft_pktinfo pkt;
+
+	nft_set_pktinfo(&pkt, skb, state);
+	nft_set_pktinfo_ipv6(&pkt, skb);
+
+	return nft_do_chain(&pkt, priv);
+}
+
+static const struct nf_chain_type filter_ipv6 = {
+	.name		= "filter",
+	.type		= NFT_CHAIN_T_DEFAULT,
+	.family		= NFPROTO_IPV6,
+	.owner		= THIS_MODULE,
+	.hook_mask	= (1 << NF_INET_LOCAL_IN) |
+			  (1 << NF_INET_LOCAL_OUT) |
+			  (1 << NF_INET_FORWARD) |
+			  (1 << NF_INET_PRE_ROUTING) |
+			  (1 << NF_INET_POST_ROUTING),
+	.hooks		= {
+		[NF_INET_LOCAL_IN]	= nft_do_chain_ipv6,
+		[NF_INET_LOCAL_OUT]	= nft_do_chain_ipv6,
+		[NF_INET_FORWARD]	= nft_do_chain_ipv6,
+		[NF_INET_PRE_ROUTING]	= nft_do_chain_ipv6,
+		[NF_INET_POST_ROUTING]	= nft_do_chain_ipv6,
+	},
+};
+
+static unsigned int nft_do_chain_inet(void *priv, struct sk_buff *skb,
+				      const struct nf_hook_state *state)
+{
+	struct nft_pktinfo pkt;
+
+	nft_set_pktinfo(&pkt, skb, state);
+
+	switch (state->pf) {
+	case NFPROTO_IPV4:
+		nft_set_pktinfo_ipv4(&pkt, skb);
+		break;
+	case NFPROTO_IPV6:
+		nft_set_pktinfo_ipv6(&pkt, skb);
+		break;
+	default:
+		break;
+	}
+
+	return nft_do_chain(&pkt, priv);
+}
+
+static const struct nf_chain_type filter_inet = {
+	.name		= "filter",
+	.type		= NFT_CHAIN_T_DEFAULT,
+	.family         = NFPROTO_INET,
+	.owner		= THIS_MODULE,
+	.hook_mask	= (1 << NF_INET_LOCAL_IN) |
+			  (1 << NF_INET_LOCAL_OUT) |
+			  (1 << NF_INET_FORWARD) |
+			  (1 << NF_INET_PRE_ROUTING) |
+			  (1 << NF_INET_POST_ROUTING),
+	.hooks          = {
+		[NF_INET_LOCAL_IN]	= nft_do_chain_inet,
+		[NF_INET_LOCAL_OUT]	= nft_do_chain_inet,
+		[NF_INET_FORWARD]	= nft_do_chain_inet,
+		[NF_INET_PRE_ROUTING]	= nft_do_chain_inet,
+		[NF_INET_POST_ROUTING]	= nft_do_chain_inet,
+	},
+};
+
+static unsigned int nft_do_chain_arp(void *priv, struct sk_buff *skb,
+				     const struct nf_hook_state *state)
+{
+	struct nft_pktinfo pkt;
+
+	nft_set_pktinfo(&pkt, skb, state);
+	nft_set_pktinfo_unspec(&pkt, skb);
+
+	return nft_do_chain(&pkt, priv);
+}
+
+static const struct nf_chain_type filter_arp = {
+	.name		= "filter",
+	.type		= NFT_CHAIN_T_DEFAULT,
+	.family		= NFPROTO_ARP,
+	.owner		= THIS_MODULE,
+	.hook_mask	= (1 << NF_ARP_IN) |
+			  (1 << NF_ARP_OUT),
+	.hooks		= {
+		[NF_ARP_IN]		= nft_do_chain_arp,
+		[NF_ARP_OUT]		= nft_do_chain_arp,
+	},
+};
+
+static unsigned int nft_do_chain_bridge(void *priv, struct sk_buff *skb,
+					const struct nf_hook_state *state)
+{
+	struct nft_pktinfo pkt;
+
+	nft_set_pktinfo(&pkt, skb, state);
+
+	switch (eth_hdr(skb)->h_proto) {
+	case htons(ETH_P_IP):
+		nft_set_pktinfo_ipv4_validate(&pkt, skb);
+		break;
+	case htons(ETH_P_IPV6):
+		nft_set_pktinfo_ipv6_validate(&pkt, skb);
+		break;
+	default:
+		nft_set_pktinfo_unspec(&pkt, skb);
+		break;
+	}
+
+	return nft_do_chain(&pkt, priv);
+}
+
+static const struct nf_chain_type filter_bridge = {
+	.name		= "filter",
+	.type		= NFT_CHAIN_T_DEFAULT,
+	.family		= NFPROTO_BRIDGE,
+	.owner		= THIS_MODULE,
+	.hook_mask	= (1 << NF_BR_PRE_ROUTING) |
+			  (1 << NF_BR_LOCAL_IN) |
+			  (1 << NF_BR_FORWARD) |
+			  (1 << NF_BR_LOCAL_OUT) |
+			  (1 << NF_BR_POST_ROUTING),
+	.hooks		= {
+		[NF_BR_PRE_ROUTING]	= nft_do_chain_bridge,
+		[NF_BR_LOCAL_IN]	= nft_do_chain_bridge,
+		[NF_BR_FORWARD]		= nft_do_chain_bridge,
+		[NF_BR_LOCAL_OUT]	= nft_do_chain_bridge,
+		[NF_BR_POST_ROUTING]	= nft_do_chain_bridge,
+	},
+};
+
+static unsigned int nft_do_chain_netdev(void *priv, struct sk_buff *skb,
+					const struct nf_hook_state *state)
+{
+	struct nft_pktinfo pkt;
+
+	nft_set_pktinfo(&pkt, skb, state);
+
+	switch (skb->protocol) {
+	case htons(ETH_P_IP):
+		nft_set_pktinfo_ipv4_validate(&pkt, skb);
+		break;
+	case htons(ETH_P_IPV6):
+		nft_set_pktinfo_ipv6_validate(&pkt, skb);
+		break;
+	default:
+		nft_set_pktinfo_unspec(&pkt, skb);
+		break;
+	}
+
+	return nft_do_chain(&pkt, priv);
+}
+
+static const struct nf_chain_type filter_netdev = {
+	.name		= "filter",
+	.type		= NFT_CHAIN_T_DEFAULT,
+	.family		= NFPROTO_NETDEV,
+	.owner		= THIS_MODULE,
+	.hook_mask	= (1 << NF_NETDEV_INGRESS),
+	.hooks		= {
+		[NF_NETDEV_INGRESS]	= nft_do_chain_netdev,
+	},
+};
+
+static void nft_netdev_event(unsigned long event, struct net_device *dev,
+			     struct nft_ctx *ctx)
+{
+	struct nft_base_chain *basechain = nft_base_chain(ctx->chain);
+
+	switch (event) {
+	case NETDEV_UNREGISTER:
+		if (strcmp(basechain->dev_name, dev->name) != 0)
+			return;
+
+		__nft_release_basechain(ctx);
+		break;
+	case NETDEV_CHANGENAME:
+		if (dev->ifindex != basechain->ops.dev->ifindex)
+			return;
+
+		strncpy(basechain->dev_name, dev->name, IFNAMSIZ);
+		break;
+	}
+}
+
+static int nf_tables_netdev_event(struct notifier_block *this,
+				  unsigned long event, void *ptr)
+{
+	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
+	struct nft_table *table;
+	struct nft_chain *chain, *nr;
+	struct nft_ctx ctx = {
+		.net	= dev_net(dev),
+	};
+
+	if (event != NETDEV_UNREGISTER &&
+	    event != NETDEV_CHANGENAME)
+		return NOTIFY_DONE;
+
+	nfnl_lock(NFNL_SUBSYS_NFTABLES);
+	list_for_each_entry(table, &ctx.net->nft.tables, list) {
+		if (table->family != NFPROTO_NETDEV)
+			continue;
+
+		ctx.family = table->family;
+		ctx.table = table;
+		list_for_each_entry_safe(chain, nr, &table->chains, list) {
+			if (!nft_is_base_chain(chain))
+				continue;
+
+			ctx.chain = chain;
+			nft_netdev_event(event, dev, &ctx);
+		}
+	}
+	nfnl_unlock(NFNL_SUBSYS_NFTABLES);
+
+	return NOTIFY_DONE;
+}
+
+static struct notifier_block nf_tables_netdev_notifier = {
+	.notifier_call	= nf_tables_netdev_event,
+};
+
+int nf_tables_filter_init(void)
+{
+	int err;
+
+	err = register_netdevice_notifier(&nf_tables_netdev_notifier);
+	if (err < 0)
+		return err;
+
+	nft_register_chain_type(&filter_ipv4);
+	nft_register_chain_type(&filter_ipv6);
+	nft_register_chain_type(&filter_inet);
+	nft_register_chain_type(&filter_arp);
+	nft_register_chain_type(&filter_bridge);
+	nft_register_chain_type(&filter_netdev);
+
+	return 0;
+}
+
+void nf_tables_filter_fini(void)
+{
+	nft_unregister_chain_type(&filter_netdev);
+	nft_unregister_chain_type(&filter_bridge);
+	nft_unregister_chain_type(&filter_arp);
+	nft_unregister_chain_type(&filter_inet);
+	nft_unregister_chain_type(&filter_ipv6);
+	nft_unregister_chain_type(&filter_ipv4);
+
+	unregister_netdevice_notifier(&nf_tables_netdev_notifier);
+}
-- 
2.11.0

