From: Bernhard Thaler <bernhard.thaler@wvnet.at>
Subject: [PATCHv2 nf] netfilter: bridge: fix IPv6 packets not being bridged with CONFIG_IPV6=n
Date: Thu, 16 Jul 2015 02:34:44 +0200
Message-ID: <1437006884-11116-1-git-send-email-bernhard.thaler@wvnet.at>
References: <20150715174702.GA7407@salvia>
Cc: netfilter-devel@vger.kernel.org,
	Bernhard Thaler <bernhard.thaler@wvnet.at>
To: pablo@netfilter.org, kadlec@blackhole.kfki.hu
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx-out.wvnet.at ([62.212.170.133]:8439 "EHLO mx-out.wvnet.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754437AbbGPAfb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 15 Jul 2015 20:35:31 -0400
Received: from smtp.wvnet.at (localhost [127.0.0.1])
	by mx-out.wvnet.at (Postfix) with ESMTP id 65C9C1BCCD4E
	for <netfilter-devel@vger.kernel.org>; Thu, 16 Jul 2015 02:35:27 +0200 (CEST)
In-Reply-To: <20150715174702.GA7407@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

230ac490f7fba introduced a dependency to CONFIG_IPV6 which breaks bridging
of IPv6 packets on a bridge with CONFIG_IPV6=n. This is due to the default
value 1 for sysctl entry /proc/sys/net/bridge/bridge-nf-call-ip6tables,
manually setting it to 0 makes IPv6 packets traverse bridge again.

Default /proc/sys/net/bridge/bridge-nf-call-ip6tables to 0 if
CONFIG_IP6_NF_IPTABLES is enabled as CONFIG_IP6_NF_IPTABLES is dependent on
CONFIG_IPV6 as well and is needed for ip6tales to work correclty anyway.

Do not expose sysctl entry /proc/sys/net/bridge/bridge-nf-call-ip6tables
and sysfs entry /sys/class/net/brXXX/bridge/nf_call_ip6tables if
CONFIG_IP6_NF_IPTABLES is not enabled.

Make br_netfilter_ipv6.o dependent on CONFIG_IP6_NF_IPTABLES instead of
CONFIG_IPV6.

Tested with a simple bridge with two interfaces and IPv6 packets trying
to pass from host of left side to host on right side of the bridge.

Fixes: 230ac490f7fba ("netfilter: bridge: split ipv6 code into separated file")

Signed-off-by: Bernhard Thaler <bernhard.thaler@wvnet.at>
---
NOTE:
* checkpatch.pl throws error "ERROR: do not initialise statics to 0 or NULL"
but left for consistency with similar declarations
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

v2
* do not expose sysfs and sysctl if CONFIG_IP6_NF_IPTABLES=n 
* change dependency to CONFIG_IP6_NF_IPTABLES as suggested by Florian Westphal
* removed changes to br_validate_ipv6() in br_netfilter.h as test show it may
  not be needed

v1
* sysfs and sysctl entry were exposed but not writeable if CONFIG_IPV6=n

 include/net/netfilter/br_netfilter.h |    2 +-
 net/bridge/Makefile                  |    2 +-
 net/bridge/br_netfilter_hooks.c      |   10 ++++++++++
 net/bridge/br_sysfs_br.c             |    4 ++++
 4 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/include/net/netfilter/br_netfilter.h b/include/net/netfilter/br_netfilter.h
index bab824b..0efbb26 100644
--- a/include/net/netfilter/br_netfilter.h
+++ b/include/net/netfilter/br_netfilter.h
@@ -44,7 +44,7 @@ static inline struct rtable *bridge_parent_rtable(const struct net_device *dev)
 struct net_device *setup_pre_routing(struct sk_buff *skb);
 void br_netfilter_enable(void);
 
-#if IS_ENABLED(CONFIG_IPV6)
+#if IS_ENABLED(CONFIG_IP6_NF_IPTABLES)
 int br_validate_ipv6(struct sk_buff *skb);
 unsigned int br_nf_pre_routing_ipv6(const struct nf_hook_ops *ops,
 				    struct sk_buff *skb,
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
index c8b9bcf..29993e8 100644
--- a/net/bridge/br_netfilter_hooks.c
+++ b/net/bridge/br_netfilter_hooks.c
@@ -47,14 +47,22 @@
 #ifdef CONFIG_SYSCTL
 static struct ctl_table_header *brnf_sysctl_header;
 static int brnf_call_iptables __read_mostly = 1;
+#if IS_ENABLED(CONFIG_IP6_NF_IPTABLES)
 static int brnf_call_ip6tables __read_mostly = 1;
+#else
+static int brnf_call_ip6tables __read_mostly = 0;
+#endif
 static int brnf_call_arptables __read_mostly = 1;
 static int brnf_filter_vlan_tagged __read_mostly = 0;
 static int brnf_filter_pppoe_tagged __read_mostly = 0;
 static int brnf_pass_vlan_indev __read_mostly = 0;
 #else
 #define brnf_call_iptables 1
+#if IS_ENABLED(CONFIG_IP6_NF_IPTABLES)
 #define brnf_call_ip6tables 1
+#else
+#define brnf_call_ip6tables 0
+#endif
 #define brnf_call_arptables 1
 #define brnf_filter_vlan_tagged 0
 #define brnf_filter_pppoe_tagged 0
@@ -986,6 +994,7 @@ static struct ctl_table brnf_table[] = {
 		.mode		= 0644,
 		.proc_handler	= brnf_sysctl_call_tables,
 	},
+#if IS_ENABLED(CONFIG_IP6_NF_IPTABLES)
 	{
 		.procname	= "bridge-nf-call-ip6tables",
 		.data		= &brnf_call_ip6tables,
@@ -993,6 +1002,7 @@ static struct ctl_table brnf_table[] = {
 		.mode		= 0644,
 		.proc_handler	= brnf_sysctl_call_tables,
 	},
+#endif
 	{
 		.procname	= "bridge-nf-filter-vlan-tagged",
 		.data		= &brnf_filter_vlan_tagged,
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

