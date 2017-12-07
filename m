From: Florian Westphal <fw@strlen.de>
Subject: [PATCH v3 nf-next 4/5] netfilter: don't allocate space for arp/bridge hooks unless needed
Date: Thu,  7 Dec 2017 16:28:26 +0100
Message-ID: <20171207152827.24317-5-fw@strlen.de>
References: <20171207152827.24317-1-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:45026 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753530AbdLGP3D (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 7 Dec 2017 10:29:03 -0500
In-Reply-To: <20171207152827.24317-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

no need to define hook points if the family isn't supported.
Because we need these hooks for either nftables, arp/ebtables
or the 'call-iptables' hack we have in the bridge layer add two
new dependencies, NETFILTER_FAMILY_{ARP,BRIDGE}, and have the
users select them.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 changes since v2:
 split this from a different patch.

 include/linux/netfilter.h     | 4 ++++
 include/net/netns/netfilter.h | 4 ++++
 net/Kconfig                   | 1 +
 net/bridge/netfilter/Kconfig  | 2 ++
 net/ipv4/netfilter/Kconfig    | 2 ++
 net/netfilter/Kconfig         | 6 ++++++
 net/netfilter/core.c          | 8 ++++++++
 net/netfilter/nf_queue.c      | 2 ++
 8 files changed, 29 insertions(+)

diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
index ce4e91df8b56..0e46cb43dd12 100644
--- a/include/linux/netfilter.h
+++ b/include/linux/netfilter.h
@@ -213,12 +213,16 @@ static inline int nf_hook(u_int8_t pf, unsigned int hook, struct net *net,
 	case NFPROTO_IPV6:
 		hook_head = rcu_dereference(net->nf.hooks_ipv6[hook]);
 		break;
+#ifdef CONFIG_NETFILTER_FAMILY_ARP
 	case NFPROTO_ARP:
 		hook_head = rcu_dereference(net->nf.hooks_arp[hook]);
 		break;
+#endif
+#ifdef CONFIG_NETFILTER_FAMILY_BRIDGE
 	case NFPROTO_BRIDGE:
 		hook_head = rcu_dereference(net->nf.hooks_bridge[hook]);
 		break;
+#endif
 #if IS_ENABLED(CONFIG_DECNET)
 	case NFPROTO_DECNET:
 		hook_head = rcu_dereference(net->nf.hooks_decnet[hook]);
diff --git a/include/net/netns/netfilter.h b/include/net/netns/netfilter.h
index 432609fd9899..ca043342c0eb 100644
--- a/include/net/netns/netfilter.h
+++ b/include/net/netns/netfilter.h
@@ -19,8 +19,12 @@ struct netns_nf {
 #endif
 	struct nf_hook_entries __rcu *hooks_ipv4[NF_INET_NUMHOOKS];
 	struct nf_hook_entries __rcu *hooks_ipv6[NF_INET_NUMHOOKS];
+#ifdef CONFIG_NETFILTER_FAMILY_ARP
 	struct nf_hook_entries __rcu *hooks_arp[NF_ARP_NUMHOOKS];
+#endif
+#ifdef CONFIG_NETFILTER_FAMILY_BRIDGE
 	struct nf_hook_entries __rcu *hooks_bridge[NF_INET_NUMHOOKS];
+#endif
 #if IS_ENABLED(CONFIG_DECNET)
 	struct nf_hook_entries __rcu *hooks_decnet[NF_DN_NUMHOOKS];
 #endif
diff --git a/net/Kconfig b/net/Kconfig
index 9dba2715919d..842dfedbc621 100644
--- a/net/Kconfig
+++ b/net/Kconfig
@@ -182,6 +182,7 @@ config BRIDGE_NETFILTER
 	depends on BRIDGE
 	depends on NETFILTER && INET
 	depends on NETFILTER_ADVANCED
+	select NETFILTER_FAMILY_BRIDGE
 	default m
 	---help---
 	  Enabling this option will let arptables resp. iptables see bridged
diff --git a/net/bridge/netfilter/Kconfig b/net/bridge/netfilter/Kconfig
index e7ef1a1ef3a6..225d1668dfdd 100644
--- a/net/bridge/netfilter/Kconfig
+++ b/net/bridge/netfilter/Kconfig
@@ -4,6 +4,7 @@
 #
 menuconfig NF_TABLES_BRIDGE
 	depends on BRIDGE && NETFILTER && NF_TABLES
+	select NETFILTER_FAMILY_BRIDGE
 	tristate "Ethernet Bridge nf_tables support"
 
 if NF_TABLES_BRIDGE
@@ -29,6 +30,7 @@ endif # NF_TABLES_BRIDGE
 menuconfig BRIDGE_NF_EBTABLES
 	tristate "Ethernet Bridge tables (ebtables) support"
 	depends on BRIDGE && NETFILTER && NETFILTER_XTABLES
+	select NETFILTER_FAMILY_BRIDGE
 	help
 	  ebtables is a general, extensible frame/packet identification
 	  framework. Say 'Y' or 'M' here if you want to do Ethernet
diff --git a/net/ipv4/netfilter/Kconfig b/net/ipv4/netfilter/Kconfig
index c11eb1744ab1..cee51045e2f7 100644
--- a/net/ipv4/netfilter/Kconfig
+++ b/net/ipv4/netfilter/Kconfig
@@ -72,6 +72,7 @@ endif # NF_TABLES_IPV4
 
 config NF_TABLES_ARP
 	tristate "ARP nf_tables support"
+	select NETFILTER_FAMILY_ARP
 	help
 	  This option enables the ARP support for nf_tables.
 
@@ -392,6 +393,7 @@ endif # IP_NF_IPTABLES
 config IP_NF_ARPTABLES
 	tristate "ARP tables support"
 	select NETFILTER_XTABLES
+	select NETFILTER_FAMILY_ARP
 	depends on NETFILTER_ADVANCED
 	help
 	  arptables is a general, extensible packet identification framework.
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index e4a13cc8a2e7..263609a7e010 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -12,6 +12,12 @@ config NETFILTER_INGRESS
 config NETFILTER_NETLINK
 	tristate
 
+config NETFILTER_FAMILY_BRIDGE
+	bool
+
+config NETFILTER_FAMILY_ARP
+	bool
+
 config NETFILTER_NETLINK_ACCT
 tristate "Netfilter NFACCT over NFNETLINK interface"
 	depends on NETFILTER_ADVANCED
diff --git a/net/netfilter/core.c b/net/netfilter/core.c
index 4738d0d0ebac..ed8618f4efd7 100644
--- a/net/netfilter/core.c
+++ b/net/netfilter/core.c
@@ -267,14 +267,18 @@ static struct nf_hook_entries __rcu **nf_hook_entry_head(struct net *net, const
 	switch (reg->pf) {
 	case NFPROTO_NETDEV:
 		break;
+#ifdef CONFIG_NETFILTER_FAMILY_ARP
 	case NFPROTO_ARP:
 		if (WARN_ON_ONCE(ARRAY_SIZE(net->nf.hooks_arp) <= reg->hooknum))
 			return NULL;
 		return net->nf.hooks_arp + reg->hooknum;
+#endif
+#ifdef CONFIG_NETFILTER_FAMILY_BRIDGE
 	case NFPROTO_BRIDGE:
 		if (WARN_ON_ONCE(ARRAY_SIZE(net->nf.hooks_bridge) <= reg->hooknum))
 			return NULL;
 		return net->nf.hooks_bridge + reg->hooknum;
+#endif
 	case NFPROTO_IPV4:
 		if (WARN_ON_ONCE(ARRAY_SIZE(net->nf.hooks_ipv4) <= reg->hooknum))
 			return NULL;
@@ -573,8 +577,12 @@ static int __net_init netfilter_net_init(struct net *net)
 {
 	__netfilter_net_init(net->nf.hooks_ipv4, ARRAY_SIZE(net->nf.hooks_ipv4));
 	__netfilter_net_init(net->nf.hooks_ipv6, ARRAY_SIZE(net->nf.hooks_ipv6));
+#ifdef CONFIG_NETFILTER_FAMILY_ARP
 	__netfilter_net_init(net->nf.hooks_arp, ARRAY_SIZE(net->nf.hooks_arp));
+#endif
+#ifdef CONFIG_NETFILTER_FAMILY_BRIDGE
 	__netfilter_net_init(net->nf.hooks_bridge, ARRAY_SIZE(net->nf.hooks_bridge));
+#endif
 #if IS_ENABLED(CONFIG_DECNET)
 	__netfilter_net_init(net->nf.hooks_decnet, ARRAY_SIZE(net->nf.hooks_decnet));
 #endif
diff --git a/net/netfilter/nf_queue.c b/net/netfilter/nf_queue.c
index 836aeb08686e..0c02fdb7efc9 100644
--- a/net/netfilter/nf_queue.c
+++ b/net/netfilter/nf_queue.c
@@ -204,8 +204,10 @@ static unsigned int nf_iterate(struct sk_buff *skb,
 static struct nf_hook_entries *nf_hook_entries_head(const struct net *net, u8 pf, u8 hooknum)
 {
 	switch (pf) {
+#ifdef CONFIG_NETFILTER_FAMILY_BRIDGE
 	case NFPROTO_BRIDGE:
 		return rcu_dereference(net->nf.hooks_bridge[hooknum]);
+#endif
 	case NFPROTO_IPV4:
 		return rcu_dereference(net->nf.hooks_ipv4[hooknum]);
 	case NFPROTO_IPV6:
-- 
2.13.6

