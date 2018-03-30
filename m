From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 40/47] netfilter: nf_tables: build-in filter chain type
Date: Fri, 30 Mar 2018 13:46:12 +0200
Message-ID: <20180330114619.18797-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

One module per supported filter chain family type takes too much memory
for very little code - too much modularization - place all chain filter
definitions in one single file.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h       |   3 +
 net/bridge/netfilter/Kconfig            |   2 +-
 net/bridge/netfilter/Makefile           |   1 -
 net/bridge/netfilter/nf_tables_bridge.c |  81 -------
 net/ipv4/netfilter/Kconfig              |   4 +-
 net/ipv4/netfilter/Makefile             |   2 -
 net/ipv4/netfilter/nf_tables_arp.c      |  60 -----
 net/ipv4/netfilter/nf_tables_ipv4.c     |  69 ------
 net/ipv6/netfilter/Kconfig              |   2 +-
 net/ipv6/netfilter/Makefile             |   1 -
 net/ipv6/netfilter/nf_tables_ipv6.c     |  67 ------
 net/netfilter/Kconfig                   |   4 +-
 net/netfilter/Makefile                  |   9 +-
 net/netfilter/nf_tables_api.c           |   3 +
 net/netfilter/nf_tables_inet.c          |  77 ------
 net/netfilter/nf_tables_netdev.c        | 140 -----------
 net/netfilter/nft_chain_filter.c        | 398 ++++++++++++++++++++++++++++++++
 17 files changed, 414 insertions(+), 509 deletions(-)
 delete mode 100644 net/bridge/netfilter/nf_tables_bridge.c
 delete mode 100644 net/ipv4/netfilter/nf_tables_arp.c
 delete mode 100644 net/ipv4/netfilter/nf_tables_ipv4.c
 delete mode 100644 net/ipv6/netfilter/nf_tables_ipv6.c
 delete mode 100644 net/netfilter/nf_tables_inet.c
 delete mode 100644 net/netfilter/nf_tables_netdev.c
 create mode 100644 net/netfilter/nft_chain_filter.c

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 1f7148fe0504..77c3c04c27ac 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1345,4 +1345,7 @@ struct nft_trans_flowtable {
 #define nft_trans_flowtable(trans)	\
 	(((struct nft_trans_flowtable *)trans->data)->flowtable)
 
+int __init nft_chain_filter_init(void);
+void __exit nft_chain_filter_fini(void);
+
 #endif /* _NET_NF_TABLES_H */
diff --git a/net/bridge/netfilter/Kconfig b/net/bridge/netfilter/Kconfig
index 225d1668dfdd..f212447794bd 100644
--- a/net/bridge/netfilter/Kconfig
+++ b/net/bridge/netfilter/Kconfig
@@ -5,7 +5,7 @@
 menuconfig NF_TABLES_BRIDGE
 	depends on BRIDGE && NETFILTER && NF_TABLES
 	select NETFILTER_FAMILY_BRIDGE
-	tristate "Ethernet Bridge nf_tables support"
+	bool "Ethernet Bridge nf_tables support"
 
 if NF_TABLES_BRIDGE
 
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
index ffb8580dfdac..000000000000
--- a/net/bridge/netfilter/nf_tables_bridge.c
+++ /dev/null
@@ -1,81 +0,0 @@
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
-static const struct nft_chain_type filter_bridge = {
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
-	nft_register_chain_type(&filter_bridge);
-
-	return 0;
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
diff --git a/net/ipv4/netfilter/Kconfig b/net/ipv4/netfilter/Kconfig
index dfe6fa4ea554..280048e1e395 100644
--- a/net/ipv4/netfilter/Kconfig
+++ b/net/ipv4/netfilter/Kconfig
@@ -34,7 +34,7 @@ config NF_SOCKET_IPV4
 if NF_TABLES
 
 config NF_TABLES_IPV4
-	tristate "IPv4 nf_tables support"
+	bool "IPv4 nf_tables support"
 	help
 	  This option enables the IPv4 support for nf_tables.
 
@@ -71,7 +71,7 @@ config NFT_FIB_IPV4
 endif # NF_TABLES_IPV4
 
 config NF_TABLES_ARP
-	tristate "ARP nf_tables support"
+	bool "ARP nf_tables support"
 	select NETFILTER_FAMILY_ARP
 	help
 	  This option enables the ARP support for nf_tables.
diff --git a/net/ipv4/netfilter/Makefile b/net/ipv4/netfilter/Makefile
index 2dad20eefd26..62ede5e3a3de 100644
--- a/net/ipv4/netfilter/Makefile
+++ b/net/ipv4/netfilter/Makefile
@@ -39,7 +39,6 @@ obj-$(CONFIG_NF_NAT_MASQUERADE_IPV4) += nf_nat_masquerade_ipv4.o
 # NAT protocols (nf_nat)
 obj-$(CONFIG_NF_NAT_PROTO_GRE) += nf_nat_proto_gre.o
 
-obj-$(CONFIG_NF_TABLES_IPV4) += nf_tables_ipv4.o
 obj-$(CONFIG_NFT_CHAIN_ROUTE_IPV4) += nft_chain_route_ipv4.o
 obj-$(CONFIG_NFT_CHAIN_NAT_IPV4) += nft_chain_nat_ipv4.o
 obj-$(CONFIG_NFT_REJECT_IPV4) += nft_reject_ipv4.o
@@ -47,7 +46,6 @@ obj-$(CONFIG_NFT_FIB_IPV4) += nft_fib_ipv4.o
 obj-$(CONFIG_NFT_MASQ_IPV4) += nft_masq_ipv4.o
 obj-$(CONFIG_NFT_REDIR_IPV4) += nft_redir_ipv4.o
 obj-$(CONFIG_NFT_DUP_IPV4) += nft_dup_ipv4.o
-obj-$(CONFIG_NF_TABLES_ARP) += nf_tables_arp.o
 
 # flow table support
 obj-$(CONFIG_NF_FLOW_TABLE_IPV4) += nf_flow_table_ipv4.o
diff --git a/net/ipv4/netfilter/nf_tables_arp.c b/net/ipv4/netfilter/nf_tables_arp.c
deleted file mode 100644
index c2ee64208743..000000000000
--- a/net/ipv4/netfilter/nf_tables_arp.c
+++ /dev/null
@@ -1,60 +0,0 @@
-/*
- * Copyright (c) 2008-2010 Patrick McHardy <kaber@trash.net>
- * Copyright (c) 2013 Pablo Neira Ayuso <pablo@netfilter.org>
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
-#include <linux/netfilter_arp.h>
-#include <net/netfilter/nf_tables.h>
-
-static unsigned int
-nft_do_chain_arp(void *priv,
-		  struct sk_buff *skb,
-		  const struct nf_hook_state *state)
-{
-	struct nft_pktinfo pkt;
-
-	nft_set_pktinfo(&pkt, skb, state);
-	nft_set_pktinfo_unspec(&pkt, skb);
-
-	return nft_do_chain(&pkt, priv);
-}
-
-static const struct nft_chain_type filter_arp = {
-	.name		= "filter",
-	.type		= NFT_CHAIN_T_DEFAULT,
-	.family		= NFPROTO_ARP,
-	.owner		= THIS_MODULE,
-	.hook_mask	= (1 << NF_ARP_IN) |
-			  (1 << NF_ARP_OUT),
-	.hooks		= {
-		[NF_ARP_IN]		= nft_do_chain_arp,
-		[NF_ARP_OUT]		= nft_do_chain_arp,
-	},
-};
-
-static int __init nf_tables_arp_init(void)
-{
-	nft_register_chain_type(&filter_arp);
-
-	return 0;
-}
-
-static void __exit nf_tables_arp_exit(void)
-{
-	nft_unregister_chain_type(&filter_arp);
-}
-
-module_init(nf_tables_arp_init);
-module_exit(nf_tables_arp_exit);
-
-MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Patrick McHardy <kaber@trash.net>");
-MODULE_ALIAS_NFT_CHAIN(3, "filter"); /* NFPROTO_ARP */
diff --git a/net/ipv4/netfilter/nf_tables_ipv4.c b/net/ipv4/netfilter/nf_tables_ipv4.c
deleted file mode 100644
index c09667de0d68..000000000000
--- a/net/ipv4/netfilter/nf_tables_ipv4.c
+++ /dev/null
@@ -1,69 +0,0 @@
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
-static const struct nft_chain_type filter_ipv4 = {
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
-	nft_register_chain_type(&filter_ipv4);
-
-	return 0;
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
diff --git a/net/ipv6/netfilter/Kconfig b/net/ipv6/netfilter/Kconfig
index d395d1590699..ccbfa83e4bb0 100644
--- a/net/ipv6/netfilter/Kconfig
+++ b/net/ipv6/netfilter/Kconfig
@@ -34,7 +34,7 @@ config NF_SOCKET_IPV6
 if NF_TABLES
 
 config NF_TABLES_IPV6
-	tristate "IPv6 nf_tables support"
+	bool "IPv6 nf_tables support"
 	help
 	  This option enables the IPv6 support for nf_tables.
 
diff --git a/net/ipv6/netfilter/Makefile b/net/ipv6/netfilter/Makefile
index d984057b8395..44273d6f03a5 100644
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
index 496f69453457..000000000000
--- a/net/ipv6/netfilter/nf_tables_ipv6.c
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
-static const struct nft_chain_type filter_ipv6 = {
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
-	nft_register_chain_type(&filter_ipv6);
-
-	return 0;
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
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index d3220b43c832..704b3832dbad 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -465,12 +465,12 @@ config NF_TABLES_INET
 	depends on IPV6
 	select NF_TABLES_IPV4
 	select NF_TABLES_IPV6
-	tristate "Netfilter nf_tables mixed IPv4/IPv6 tables support"
+	bool "Netfilter nf_tables mixed IPv4/IPv6 tables support"
 	help
 	  This option enables support for a mixed IPv4/IPv6 "inet" table.
 
 config NF_TABLES_NETDEV
-	tristate "Netfilter nf_tables netdev tables support"
+	bool "Netfilter nf_tables netdev tables support"
 	help
 	  This option enables support for the "netdev" table.
 
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index 5d9b8b959e58..fd32bd2c9521 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -73,13 +73,12 @@ obj-$(CONFIG_NETFILTER_CONNCOUNT) += nf_conncount.o
 obj-$(CONFIG_NF_DUP_NETDEV)	+= nf_dup_netdev.o
 
 # nf_tables
-nf_tables-objs := nf_tables_core.o nf_tables_api.o nf_tables_trace.o \
-		  nft_immediate.o nft_cmp.o nft_range.o nft_bitwise.o \
-		  nft_byteorder.o nft_payload.o nft_lookup.o nft_dynset.o
+nf_tables-objs := nf_tables_core.o nf_tables_api.o nft_chain_filter.o \
+		  nf_tables_trace.o nft_immediate.o nft_cmp.o nft_range.o \
+		  nft_bitwise.o nft_byteorder.o nft_payload.o nft_lookup.o \
+		  nft_dynset.o
 
 obj-$(CONFIG_NF_TABLES)		+= nf_tables.o
-obj-$(CONFIG_NF_TABLES_INET)	+= nf_tables_inet.o
-obj-$(CONFIG_NF_TABLES_NETDEV)	+= nf_tables_netdev.o
 obj-$(CONFIG_NFT_COMPAT)	+= nft_compat.o
 obj-$(CONFIG_NFT_EXTHDR)	+= nft_exthdr.o
 obj-$(CONFIG_NFT_META)		+= nft_meta.o
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 9e4b1614ee39..97ec1c388bfe 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -6584,6 +6584,8 @@ static int __init nf_tables_module_init(void)
 {
 	int err;
 
+	nft_chain_filter_init();
+
 	info = kmalloc(sizeof(struct nft_expr_info) * NFT_RULE_MAXEXPRS,
 		       GFP_KERNEL);
 	if (info == NULL) {
@@ -6618,6 +6620,7 @@ static void __exit nf_tables_module_exit(void)
 	rcu_barrier();
 	nf_tables_core_module_exit();
 	kfree(info);
+	nft_chain_filter_fini();
 }
 
 module_init(nf_tables_module_init);
diff --git a/net/netfilter/nf_tables_inet.c b/net/netfilter/nf_tables_inet.c
deleted file mode 100644
index 202c4219969b..000000000000
--- a/net/netfilter/nf_tables_inet.c
+++ /dev/null
@@ -1,77 +0,0 @@
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
-static const struct nft_chain_type filter_inet = {
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
-		[NF_INET_LOCAL_OUT]	= nft_do_chain_inet,
-		[NF_INET_FORWARD]	= nft_do_chain_inet,
-		[NF_INET_PRE_ROUTING]	= nft_do_chain_inet,
-		[NF_INET_POST_ROUTING]	= nft_do_chain_inet,
-        },
-};
-
-static int __init nf_tables_inet_init(void)
-{
-	nft_register_chain_type(&filter_inet);
-
-	return 0;
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
-MODULE_ALIAS_NFT_CHAIN(1, "filter");
diff --git a/net/netfilter/nf_tables_netdev.c b/net/netfilter/nf_tables_netdev.c
deleted file mode 100644
index 4c3835bca63e..000000000000
--- a/net/netfilter/nf_tables_netdev.c
+++ /dev/null
@@ -1,140 +0,0 @@
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
-static const struct nft_chain_type nft_filter_chain_netdev = {
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
-	nft_register_chain_type(&nft_filter_chain_netdev);
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
index 000000000000..84c902477a91
--- /dev/null
+++ b/net/netfilter/nft_chain_filter.c
@@ -0,0 +1,398 @@
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/netdevice.h>
+#include <net/net_namespace.h>
+#include <net/netfilter/nf_tables.h>
+#include <linux/netfilter_ipv4.h>
+#include <linux/netfilter_ipv6.h>
+#include <linux/netfilter_bridge.h>
+#include <linux/netfilter_arp.h>
+#include <net/netfilter/nf_tables_ipv4.h>
+#include <net/netfilter/nf_tables_ipv6.h>
+
+#ifdef CONFIG_NF_TABLES_IPV4
+static unsigned int nft_do_chain_ipv4(void *priv,
+				      struct sk_buff *skb,
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
+static const struct nft_chain_type nft_chain_filter_ipv4 = {
+	.name		= "filter",
+	.type		= NFT_CHAIN_T_DEFAULT,
+	.family		= NFPROTO_IPV4,
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
+static void nft_chain_filter_ipv4_init(void)
+{
+	nft_register_chain_type(&nft_chain_filter_ipv4);
+}
+static void nft_chain_filter_ipv4_fini(void)
+{
+	nft_unregister_chain_type(&nft_chain_filter_ipv4);
+}
+
+#else
+static inline void nft_chain_filter_ipv4_init(void) {}
+static inline void nft_chain_filter_ipv4_fini(void) {}
+#endif /* CONFIG_NF_TABLES_IPV4 */
+
+#ifdef CONFIG_NF_TABLES_ARP
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
+static const struct nft_chain_type nft_chain_filter_arp = {
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
+static void nft_chain_filter_arp_init(void)
+{
+	nft_register_chain_type(&nft_chain_filter_arp);
+}
+
+static void nft_chain_filter_arp_fini(void)
+{
+	nft_unregister_chain_type(&nft_chain_filter_arp);
+}
+#else
+static inline void nft_chain_filter_arp_init(void) {}
+static inline void nft_chain_filter_arp_fini(void) {}
+#endif /* CONFIG_NF_TABLES_ARP */
+
+#ifdef CONFIG_NF_TABLES_IPV6
+static unsigned int nft_do_chain_ipv6(void *priv,
+				      struct sk_buff *skb,
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
+static const struct nft_chain_type nft_chain_filter_ipv6 = {
+	.name		= "filter",
+	.type		= NFT_CHAIN_T_DEFAULT,
+	.family		= NFPROTO_IPV6,
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
+static void nft_chain_filter_ipv6_init(void)
+{
+	nft_register_chain_type(&nft_chain_filter_ipv6);
+}
+
+static void nft_chain_filter_ipv6_fini(void)
+{
+	nft_unregister_chain_type(&nft_chain_filter_ipv6);
+}
+#else
+static inline void nft_chain_filter_ipv6_init(void) {}
+static inline void nft_chain_filter_ipv6_fini(void) {}
+#endif /* CONFIG_NF_TABLES_IPV6 */
+
+#ifdef CONFIG_NF_TABLES_INET
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
+static const struct nft_chain_type nft_chain_filter_inet = {
+	.name		= "filter",
+	.type		= NFT_CHAIN_T_DEFAULT,
+	.family		= NFPROTO_INET,
+	.hook_mask	= (1 << NF_INET_LOCAL_IN) |
+			  (1 << NF_INET_LOCAL_OUT) |
+			  (1 << NF_INET_FORWARD) |
+			  (1 << NF_INET_PRE_ROUTING) |
+			  (1 << NF_INET_POST_ROUTING),
+	.hooks		= {
+		[NF_INET_LOCAL_IN]	= nft_do_chain_inet,
+		[NF_INET_LOCAL_OUT]	= nft_do_chain_inet,
+		[NF_INET_FORWARD]	= nft_do_chain_inet,
+		[NF_INET_PRE_ROUTING]	= nft_do_chain_inet,
+		[NF_INET_POST_ROUTING]	= nft_do_chain_inet,
+        },
+};
+
+static void nft_chain_filter_inet_init(void)
+{
+	nft_register_chain_type(&nft_chain_filter_inet);
+}
+
+static void nft_chain_filter_inet_fini(void)
+{
+	nft_unregister_chain_type(&nft_chain_filter_inet);
+}
+#else
+static inline void nft_chain_filter_inet_init(void) {}
+static inline void nft_chain_filter_inet_fini(void) {}
+#endif /* CONFIG_NF_TABLES_IPV6 */
+
+#ifdef CONFIG_NF_TABLES_BRIDGE
+static unsigned int
+nft_do_chain_bridge(void *priv,
+		    struct sk_buff *skb,
+		    const struct nf_hook_state *state)
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
+static const struct nft_chain_type nft_chain_filter_bridge = {
+	.name		= "filter",
+	.type		= NFT_CHAIN_T_DEFAULT,
+	.family		= NFPROTO_BRIDGE,
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
+static void nft_chain_filter_bridge_init(void)
+{
+	nft_register_chain_type(&nft_chain_filter_bridge);
+}
+
+static void nft_chain_filter_bridge_fini(void)
+{
+	nft_unregister_chain_type(&nft_chain_filter_bridge);
+}
+#else
+static inline void nft_chain_filter_bridge_init(void) {}
+static inline void nft_chain_filter_bridge_fini(void) {}
+#endif /* CONFIG_NF_TABLES_BRIDGE */
+
+#ifdef CONFIG_NF_TABLES_NETDEV
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
+static const struct nft_chain_type nft_chain_filter_netdev = {
+	.name		= "filter",
+	.type		= NFT_CHAIN_T_DEFAULT,
+	.family		= NFPROTO_NETDEV,
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
+static int nft_chain_filter_netdev_init(void)
+{
+	int err;
+
+	nft_register_chain_type(&nft_chain_filter_netdev);
+
+	err = register_netdevice_notifier(&nf_tables_netdev_notifier);
+	if (err)
+		goto err_register_netdevice_notifier;
+
+	return 0;
+
+err_register_netdevice_notifier:
+	nft_unregister_chain_type(&nft_chain_filter_netdev);
+
+	return err;
+}
+
+static void nft_chain_filter_netdev_fini(void)
+{
+	nft_unregister_chain_type(&nft_chain_filter_netdev);
+	unregister_netdevice_notifier(&nf_tables_netdev_notifier);
+}
+#else
+static inline int nft_chain_filter_netdev_init(void) { return 0; }
+static inline void nft_chain_filter_netdev_fini(void) {}
+#endif /* CONFIG_NF_TABLES_NETDEV */
+
+int __init nft_chain_filter_init(void)
+{
+	int err;
+
+	err = nft_chain_filter_netdev_init();
+	if (err < 0)
+		return err;
+
+	nft_chain_filter_ipv4_init();
+	nft_chain_filter_ipv6_init();
+	nft_chain_filter_arp_init();
+	nft_chain_filter_inet_init();
+	nft_chain_filter_bridge_init();
+
+	return 0;
+}
+
+void __exit nft_chain_filter_fini(void)
+{
+	nft_chain_filter_bridge_fini();
+	nft_chain_filter_inet_fini();
+	nft_chain_filter_arp_fini();
+	nft_chain_filter_ipv6_fini();
+	nft_chain_filter_ipv4_fini();
+	nft_chain_filter_netdev_fini();
+}
-- 
2.11.0
