From: Bernhard Thaler <bernhard.thaler@wvnet.at>
Subject: [PATCHv3 2/2 nf] netfilter: bridge: fix IPv6 packets not being bridged with CONFIG_IPV6=n
Date: Thu, 30 Jul 2015 06:07:01 +0200
Message-ID: <1438229221-25959-1-git-send-email-bernhard.thaler@wvnet.at>
Cc: netfilter-devel@vger.kernel.org,
	Bernhard Thaler <bernhard.thaler@wvnet.at>
To: pablo@netfilter.org, kadlec@blackhole.kfki.hu
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx-out.wvnet.at ([62.212.170.133]:25665 "EHLO mx-out.wvnet.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754270AbbG2XSa (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 29 Jul 2015 19:18:30 -0400
Received: from smtp.wvnet.at (localhost [127.0.0.1])
	by mx-out.wvnet.at (Postfix) with ESMTP id 39A4E605AE
	for <netfilter-devel@vger.kernel.org>; Thu, 30 Jul 2015 01:18:29 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

230ac490f7fba introduced a dependency to CONFIG_IPV6 which breaks bridging
of IPv6 packets on a bridge with CONFIG_IPV6=n. This is due to the default
value 1 for sysctl entry /proc/sys/net/bridge/bridge-nf-call-ip6tables,
manually setting it to 0 makes IPv6 packets traverse bridge again.

Default /proc/sys/net/bridge/bridge-nf-call-ip6tables to 0 if
CONFIG_IP6_NF_IPTABLES is not enabled as CONFIG_IP6_NF_IPTABLES depends on
CONFIG_IPV6 as well and is needed for ip6tables to work correctly.

Do not expose sysctl entry /proc/sys/net/bridge/bridge-nf-call-ip6tables
and sysfs entry /sys/class/net/brXXX/bridge/nf_call_ip6tables if
CONFIG_IP6_NF_IPTABLES is not enabled.

Make br_netfilter_ipv6.o dependent on CONFIG_IP6_NF_IPTABLES instead of
CONFIG_IPV6.

Set global brnf_call_* variables to defaults in br_nf_proc_register() and
br_nf_ipv6_proc_register() at module init instead of at variable definition
to avoid further #ifdef CONFIG_SYSCTL constructs.

Define br_nf_ipv6_proc_register() and br_nf_ipv6_proc_unregister() to avoid

Tested with a simple bridge with two interfaces and IPv6 packets trying
to pass from host on left side to host on right side of the bridge.

Fixes: 230ac490f7fba ("netfilter: bridge: split ipv6 code into separated file")

Signed-off-by: Bernhard Thaler <bernhard.thaler@wvnet.at>
---
---
NOTE:
* dependency to CONFIG_IPV6 instead of CONFIG_IP6_NF_IPTABLES would be more
  "conservative" approach as br_netfilter_ipv6.o was introduced due to
  dependencies in br_validate_ipv6() to CONFIG_IPV6; but CONFIG_IP6_NF_IPTABLES
  will be needed for ip6tables so this dependency may be more "holistic"
* CONFIG_IP6_NF_IPTABLES=n makes br_validate_ipv6() being imported from
  br_netfilter.h; it is used in br_netfilter_hooks.c within br_nf_forward_ip()
  and br_nf_dev_queue_xmit() and returns -1 which will lead to NF_DROP;
  After defaulting /proc/sys/net/bridge/bridge-nf-call-ip6tables to 0 with
  CONFIG_IP6_NF_IPTABLES=n these two functions me never see IPV6 packets and 
  therefore this may not be a problem; I was not able to fully confirm this

Patch history

v3
* fix checkpatch error in separate patch
* changes to reduce #ifdef pollution

v2
* do not expose sysfs and sysctl if CONFIG_IP6_NF_IPTABLES=n 
* change dependency to CONFIG_IP6_NF_IPTABLES as suggested by Florian Westphal
* removed changes to br_validate_ipv6() in br_netfilter.h as test show it may
  not be needed

v1
* sysfs and sysctl entry were exposed but not writeable if CONFIG_IPV6=n
 include/net/netfilter/br_netfilter.h |   21 +++++++++-
 net/bridge/Makefile                  |    2 +-
 net/bridge/br_netfilter_hooks.c      |   70 ++++++++++++++++++++--------------
 net/bridge/br_netfilter_ipv6.c       |   44 +++++++++++++++++++++
 net/bridge/br_sysfs_br.c             |    4 ++
 5 files changed, 111 insertions(+), 30 deletions(-)

diff --git a/include/net/netfilter/br_netfilter.h b/include/net/netfilter/br_netfilter.h
index bab824b..e2cb715 100644
--- a/include/net/netfilter/br_netfilter.h
+++ b/include/net/netfilter/br_netfilter.h
@@ -44,11 +44,17 @@ static inline struct rtable *bridge_parent_rtable(const struct net_device *dev)
 struct net_device *setup_pre_routing(struct sk_buff *skb);
 void br_netfilter_enable(void);
 
-#if IS_ENABLED(CONFIG_IPV6)
+#if IS_ENABLED(CONFIG_IP6_NF_IPTABLES)
 int br_validate_ipv6(struct sk_buff *skb);
 unsigned int br_nf_pre_routing_ipv6(const struct nf_hook_ops *ops,
 				    struct sk_buff *skb,
 				    const struct nf_hook_state *state);
+#ifdef CONFIG_SYSCTL
+int brnf_sysctl_call_tables(struct ctl_table *ctl, int write,
+			    void __user *buffer, size_t *lenp, loff_t *ppos);
+int br_nf_ipv6_proc_register(void);
+void br_nf_ipv6_proc_unregister(void);
+#endif
 #else
 static inline int br_validate_ipv6(struct sk_buff *skb)
 {
@@ -61,6 +67,19 @@ br_nf_pre_routing_ipv6(const struct nf_hook_ops *ops, struct sk_buff *skb,
 {
 	return NF_DROP;
 }
+
+#ifdef CONFIG_SYSCTL
+static inline int br_nf_ipv6_proc_register(void)
+{
+	return 0;
+}
+
+static inline void br_nf_ipv6_proc_unregister(void)
+{
+}
 #endif
+#endif
+
+extern int brnf_call_ip6tables __read_mostly;
 
 #endif /* _BR_NETFILTER_H_ */
diff --git a/net/bridge/Makefile b/net/bridge/Makefile
index a1cda5d..3fd8beb 100644
--- a/net/bridge/Makefile
+++ b/net/bridge/Makefile
@@ -13,7 +13,7 @@ bridge-$(CONFIG_SYSFS) += br_sysfs_if.o br_sysfs_br.o
 bridge-$(subst m,y,$(CONFIG_BRIDGE_NETFILTER)) += br_nf_core.o
 
 br_netfilter-y := br_netfilter_hooks.o
-br_netfilter-$(subst m,y,$(CONFIG_IPV6)) += br_netfilter_ipv6.o
+br_netfilter-$(subst m,y,$(CONFIG_IP6_NF_IPTABLES)) += br_netfilter_ipv6.o
 obj-$(CONFIG_BRIDGE_NETFILTER) += br_netfilter.o
 
 bridge-$(CONFIG_BRIDGE_IGMP_SNOOPING) += br_multicast.o br_mdb.o
diff --git a/net/bridge/br_netfilter_hooks.c b/net/bridge/br_netfilter_hooks.c
index 624e1f2..b202cfe 100644
--- a/net/bridge/br_netfilter_hooks.c
+++ b/net/bridge/br_netfilter_hooks.c
@@ -42,24 +42,16 @@
 #include "br_private.h"
 #ifdef CONFIG_SYSCTL
 #include <linux/sysctl.h>
-#endif
 
-#ifdef CONFIG_SYSCTL
 static struct ctl_table_header *brnf_sysctl_header;
-static int brnf_call_iptables __read_mostly = 1;
-static int brnf_call_ip6tables __read_mostly = 1;
-static int brnf_call_arptables __read_mostly = 1;
+#endif
+
+static int brnf_call_iptables __read_mostly;
+int brnf_call_ip6tables __read_mostly;
+static int brnf_call_arptables __read_mostly;
 static int brnf_filter_vlan_tagged __read_mostly;
 static int brnf_filter_pppoe_tagged __read_mostly;
 static int brnf_pass_vlan_indev __read_mostly;
-#else
-#define brnf_call_iptables 1
-#define brnf_call_ip6tables 1
-#define brnf_call_arptables 1
-#define brnf_filter_vlan_tagged 0
-#define brnf_filter_pppoe_tagged 0
-#define brnf_pass_vlan_indev 0
-#endif
 
 #define IS_IP(skb) \
 	(!skb_vlan_tag_present(skb) && skb->protocol == htons(ETH_P_IP))
@@ -958,7 +950,6 @@ static struct nf_hook_ops br_nf_ops[] __read_mostly = {
 };
 
 #ifdef CONFIG_SYSCTL
-static
 int brnf_sysctl_call_tables(struct ctl_table *ctl, int write,
 			    void __user *buffer, size_t *lenp, loff_t *ppos)
 {
@@ -987,13 +978,6 @@ static struct ctl_table brnf_table[] = {
 		.proc_handler	= brnf_sysctl_call_tables,
 	},
 	{
-		.procname	= "bridge-nf-call-ip6tables",
-		.data		= &brnf_call_ip6tables,
-		.maxlen		= sizeof(int),
-		.mode		= 0644,
-		.proc_handler	= brnf_sysctl_call_tables,
-	},
-	{
 		.procname	= "bridge-nf-filter-vlan-tagged",
 		.data		= &brnf_filter_vlan_tagged,
 		.maxlen		= sizeof(int),
@@ -1016,6 +1000,40 @@ static struct ctl_table brnf_table[] = {
 	},
 	{ }
 };
+
+static int br_nf_proc_register(void)
+{
+	int ret;
+
+	brnf_call_iptables = 1;
+	brnf_call_arptables = 1;
+
+	brnf_sysctl_header =
+		register_net_sysctl(&init_net, "net/bridge", brnf_table);
+	if (!brnf_sysctl_header)
+		return -1;
+	ret = br_nf_ipv6_proc_register();
+
+	return ret;
+}
+
+static void br_nf_proc_unregister(void)
+{
+	unregister_net_sysctl_table(brnf_sysctl_header);
+	br_nf_ipv6_proc_unregister();
+}
+#else
+static int br_nf_proc_register(void)
+{
+	brnf_call_iptables = 1;
+	brnf_call_arptables = 1;
+
+	return 0;
+}
+
+static void br_nf_proc_unregister(void)
+{
+}
 #endif
 
 static int __init br_netfilter_init(void)
@@ -1026,15 +1044,13 @@ static int __init br_netfilter_init(void)
 	if (ret < 0)
 		return ret;
 
-#ifdef CONFIG_SYSCTL
-	brnf_sysctl_header = register_net_sysctl(&init_net, "net/bridge", brnf_table);
-	if (brnf_sysctl_header == NULL) {
+	ret = br_nf_proc_register();
+	if (ret < 0) {
 		printk(KERN_WARNING
 		       "br_netfilter: can't register to sysctl.\n");
 		nf_unregister_hooks(br_nf_ops, ARRAY_SIZE(br_nf_ops));
 		return -ENOMEM;
 	}
-#endif
 	RCU_INIT_POINTER(nf_br_ops, &br_ops);
 	printk(KERN_NOTICE "Bridge firewalling registered\n");
 	return 0;
@@ -1044,9 +1060,7 @@ static void __exit br_netfilter_fini(void)
 {
 	RCU_INIT_POINTER(nf_br_ops, NULL);
 	nf_unregister_hooks(br_nf_ops, ARRAY_SIZE(br_nf_ops));
-#ifdef CONFIG_SYSCTL
-	unregister_net_sysctl_table(brnf_sysctl_header);
-#endif
+	br_nf_proc_unregister();
 }
 
 module_init(br_netfilter_init);
diff --git a/net/bridge/br_netfilter_ipv6.c b/net/bridge/br_netfilter_ipv6.c
index 13b7d1e..6de5788 100644
--- a/net/bridge/br_netfilter_ipv6.c
+++ b/net/bridge/br_netfilter_ipv6.c
@@ -44,6 +44,50 @@
 #include <linux/sysctl.h>
 #endif
 
+#ifdef CONFIG_SYSCTL
+static struct ctl_table_header *brnf_sysctl_header_ipv6;
+
+static struct ctl_table brnf_table_ipv6[] = {
+	{
+		.procname       = "bridge-nf-call-ip6tables",
+		.data           = &brnf_call_ip6tables,
+		.maxlen         = sizeof(int),
+		.mode           = 0644,
+		.proc_handler   = brnf_sysctl_call_tables,
+	},
+	{ }
+};
+
+int br_nf_ipv6_proc_register(void)
+{
+	brnf_call_ip6tables = 1;
+
+	brnf_sysctl_header_ipv6 =
+		register_net_sysctl(&init_net, "net/bridge", brnf_table_ipv6);
+	if (!brnf_sysctl_header_ipv6)
+		return -1;
+
+	return 0;
+}
+
+void br_nf_ipv6_proc_unregister(void)
+{
+	unregister_net_sysctl_table(brnf_sysctl_header_ipv6);
+}
+#else
+
+int br_nf_ipv6_proc_register(void)
+{
+	brnf_call_ip6tables = 1;
+
+	return 0;
+}
+
+void br_nf_ipv6_proc_unregister(void)
+{
+}
+#endif
+
 /* We only check the length. A bridge shouldn't do any hop-by-hop stuff
  * anyway
  */
diff --git a/net/bridge/br_sysfs_br.c b/net/bridge/br_sysfs_br.c
index 4c97fc5..6113928 100644
--- a/net/bridge/br_sysfs_br.c
+++ b/net/bridge/br_sysfs_br.c
@@ -651,6 +651,7 @@ static ssize_t nf_call_iptables_store(
 }
 static DEVICE_ATTR_RW(nf_call_iptables);
 
+#if IS_ENABLED(CONFIG_IP6_NF_IPTABLES)
 static ssize_t nf_call_ip6tables_show(
 	struct device *d, struct device_attribute *attr, char *buf)
 {
@@ -671,6 +672,7 @@ static ssize_t nf_call_ip6tables_store(
 	return store_bridge_parm(d, buf, len, set_nf_call_ip6tables);
 }
 static DEVICE_ATTR_RW(nf_call_ip6tables);
+#endif
 
 static ssize_t nf_call_arptables_show(
 	struct device *d, struct device_attribute *attr, char *buf)
@@ -781,7 +783,9 @@ static struct attribute *bridge_attrs[] = {
 #endif
 #if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
 	&dev_attr_nf_call_iptables.attr,
+#if IS_ENABLED(CONFIG_IP6_NF_IPTABLES)
 	&dev_attr_nf_call_ip6tables.attr,
+#endif
 	&dev_attr_nf_call_arptables.attr,
 #endif
 #ifdef CONFIG_BRIDGE_VLAN_FILTERING
-- 
1.7.10.4

