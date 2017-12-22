From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf-next,v3 5/7] netfilter: flow table support for the mixed IPv4/IPv6 family
Date: Fri, 22 Dec 2017 20:27:30 +0100
Message-ID: <20171222192732.13188-6-pablo@netfilter.org>
References: <20171222192732.13188-1-pablo@netfilter.org>
Cc: netdev@vger.kernel.org, f.fainelli@gmail.com,
        simon.horman@netronome.com, ronye@mellanox.com, jiri@mellanox.com,
        nbd@nbd.name, john@phrozen.org, kubakici@wp.pl, fw@strlen.de
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42404 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756748AbdLVT2J (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 22 Dec 2017 14:28:09 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 71F01EBAE5
        for <netfilter-devel@vger.kernel.org>; Fri, 22 Dec 2017 20:28:07 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 623FBF731B
        for <netfilter-devel@vger.kernel.org>; Fri, 22 Dec 2017 20:28:07 +0100 (CET)
In-Reply-To: <20171222192732.13188-1-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds the IPv6 flow table type, that implements the datapath
flow table to forward IPv6 traffic.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_flow_table.h   |  5 ++++
 net/ipv4/netfilter/nf_flow_table_ipv4.c |  3 ++-
 net/ipv6/netfilter/nf_flow_table_ipv6.c |  3 ++-
 net/netfilter/Kconfig                   |  8 ++++++
 net/netfilter/nf_flow_table_inet.c      | 48 +++++++++++++++++++++++++++++++++
 5 files changed, 65 insertions(+), 2 deletions(-)
 create mode 100644 net/netfilter/nf_flow_table_inet.c

diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index 161f71ca78a0..b22b22082733 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -111,6 +111,11 @@ struct flow_ports {
 	__be16 source, dest;
 };
 
+unsigned int nf_flow_offload_ip_hook(void *priv, struct sk_buff *skb,
+				     const struct nf_hook_state *state);
+unsigned int nf_flow_offload_ipv6_hook(void *priv, struct sk_buff *skb,
+				       const struct nf_hook_state *state);
+
 #define MODULE_ALIAS_NF_FLOWTABLE(family)	\
 	MODULE_ALIAS("nf-flowtable-" __stringify(family))
 
diff --git a/net/ipv4/netfilter/nf_flow_table_ipv4.c b/net/ipv4/netfilter/nf_flow_table_ipv4.c
index ac56c0f0492a..b2d01eb25f2c 100644
--- a/net/ipv4/netfilter/nf_flow_table_ipv4.c
+++ b/net/ipv4/netfilter/nf_flow_table_ipv4.c
@@ -202,7 +202,7 @@ static bool nf_flow_exceeds_mtu(struct sk_buff *skb, const struct rtable *rt)
 	return false;
 }
 
-static unsigned int
+unsigned int
 nf_flow_offload_ip_hook(void *priv, struct sk_buff *skb,
 			const struct nf_hook_state *state)
 {
@@ -254,6 +254,7 @@ nf_flow_offload_ip_hook(void *priv, struct sk_buff *skb,
 
 	return NF_STOLEN;
 }
+EXPORT_SYMBOL_GPL(nf_flow_offload_ip_hook);
 
 static struct nf_flowtable_type flowtable_ipv4 = {
 	.family		= NFPROTO_IPV4,
diff --git a/net/ipv6/netfilter/nf_flow_table_ipv6.c b/net/ipv6/netfilter/nf_flow_table_ipv6.c
index ab78703154d8..021209be0c3c 100644
--- a/net/ipv6/netfilter/nf_flow_table_ipv6.c
+++ b/net/ipv6/netfilter/nf_flow_table_ipv6.c
@@ -196,7 +196,7 @@ static bool nf_flow_exceeds_mtu(struct sk_buff *skb, const struct rt6_info *rt)
 	return false;
 }
 
-static unsigned int
+unsigned int
 nf_flow_ipv6_offload_hook(void *priv, struct sk_buff *skb,
 			 const struct nf_hook_state *state)
 {
@@ -248,6 +248,7 @@ nf_flow_ipv6_offload_hook(void *priv, struct sk_buff *skb,
 
 	return NF_STOLEN;
 }
+EXPORT_SYMBOL_GPL(nf_flow_ipv6_offload_hook);
 
 static struct nf_flowtable_type flowtable_ipv6 = {
 	.family		= NFPROTO_IPV6,
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index af0f58322515..0c6256db5a6c 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -649,6 +649,14 @@ endif # NF_TABLES_NETDEV
 
 endif # NF_TABLES
 
+config NF_FLOW_TABLE_INET
+	select NF_FLOW_TABLE
+	tristate "Netfilter flow table mixed IPv4/IPv6 module"
+	help
+          This option adds the flow table mixed IPv4/IPv6 support.
+
+	  To compile it as a module, choose M here.
+
 config NF_FLOW_TABLE
 	tristate "Netfilter flow table module"
 	help
diff --git a/net/netfilter/nf_flow_table_inet.c b/net/netfilter/nf_flow_table_inet.c
new file mode 100644
index 000000000000..281209aeba8f
--- /dev/null
+++ b/net/netfilter/nf_flow_table_inet.c
@@ -0,0 +1,48 @@
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/netfilter.h>
+#include <linux/rhashtable.h>
+#include <net/netfilter/nf_flow_table.h>
+#include <net/netfilter/nf_tables.h>
+
+static unsigned int
+nf_flow_offload_inet_hook(void *priv, struct sk_buff *skb,
+			  const struct nf_hook_state *state)
+{
+	switch (skb->protocol) {
+	case htons(ETH_P_IP):
+		return nf_flow_offload_ip_hook(priv, skb, state);
+	case htons(ETH_P_IPV6):
+		return nf_flow_offload_ipv6_hook(priv, skb, state);
+	}
+
+	return NF_ACCEPT;
+}
+
+static struct nf_flowtable_type flowtable_inet = {
+	.family		= NFPROTO_INET,
+	.params		= &nf_flow_offload_rhash_params,
+	.gc		= nf_flow_offload_work_gc,
+	.hook		= nf_flow_offload_inet_hook,
+	.owner		= THIS_MODULE,
+};
+
+static int __init nf_flow_inet_module_init(void)
+{
+	nft_register_flowtable_type(&flowtable_inet);
+
+	return 0;
+}
+
+static void __exit nf_flow_inet_module_exit(void)
+{
+	nft_unregister_flowtable_type(&flowtable_inet);
+}
+
+module_init(nf_flow_inet_module_init);
+module_exit(nf_flow_inet_module_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Pablo Neira Ayuso <pablo@netfilter.org>");
+MODULE_ALIAS_NF_FLOWTABLE(1); /* NFPROTO_INET */
-- 
2.11.0

