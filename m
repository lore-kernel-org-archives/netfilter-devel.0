From: Bernhard Thaler <bernhard.thaler@wvnet.at>
Subject: [RFC PATCH nf] netfilter: bridge: fix IPv6 packets not being bridged with CONFIG_IPV6=n
Date: Sun,  5 Jul 2015 23:15:33 +0200
Message-ID: <1436130933-17639-1-git-send-email-bernhard.thaler@wvnet.at>
Cc: netfilter-devel@vger.kernel.org,
	Bernhard Thaler <bernhard.thaler@wvnet.at>
To: pablo@netfilter.org, kadlec@blackhole.kfki.hu
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx-out.wvnet.at ([62.212.170.132]:5908 "EHLO mx-out.wvnet.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752428AbbGEVZC (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 5 Jul 2015 17:25:02 -0400
Received: from smtp.wvnet.at (localhost [127.0.0.1])
	by mx-out.wvnet.at (Postfix) with ESMTP id 38E45196A941
	for <netfilter-devel@vger.kernel.org>; Sun,  5 Jul 2015 23:16:12 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

/sys/class/net/brXXX/bridge/nf_call_ip6tables and
/proc/sys/net/bridge/bridge-nf-call-ip6tables can be set to 1 with
CONFIG_IPV6=n. But br_nf_pre_routing_ipv6() is not available and
ip6tables would not be usable as well.

Do not allow to set both flags to 1 with CONFIG_IPV6=n.

Change return value of placeholder for br_validate_ipv6() as it is
used in br_nf_forward_ip() even with CONFIG_IPV6=n.

Fixes: 230ac490f7fba ("netfilter: bridge: split ipv6 code into separated file")
Signed-off-by: Bernhard Thaler <bernhard.thaler@wvnet.at>
---
checkpatch.pl throws error "ERROR: do not initialise statics to 0 or NULL"
but left for consistency with similar declarations

 include/net/netfilter/br_netfilter.h |    2 +-
 net/bridge/br_netfilter_hooks.c      |   21 ++++++++++++++++++++-
 net/bridge/br_sysfs_br.c             |    3 +++
 3 files changed, 24 insertions(+), 2 deletions(-)

diff --git a/include/net/netfilter/br_netfilter.h b/include/net/netfilter/br_netfilter.h
index bab824b..f2601c1 100644
--- a/include/net/netfilter/br_netfilter.h
+++ b/include/net/netfilter/br_netfilter.h
@@ -52,7 +52,7 @@ unsigned int br_nf_pre_routing_ipv6(const struct nf_hook_ops *ops,
 #else
 static inline int br_validate_ipv6(struct sk_buff *skb)
 {
-	return -1;
+	return 0;
 }
 
 static inline unsigned int
diff --git a/net/bridge/br_netfilter_hooks.c b/net/bridge/br_netfilter_hooks.c
index d89f4fa..db0d038 100644
--- a/net/bridge/br_netfilter_hooks.c
+++ b/net/bridge/br_netfilter_hooks.c
@@ -47,14 +47,22 @@
 #ifdef CONFIG_SYSCTL
 static struct ctl_table_header *brnf_sysctl_header;
 static int brnf_call_iptables __read_mostly = 1;
+#if IS_ENABLED(CONFIG_IPV6)
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
+#if IS_ENABLED(CONFIG_IPV6)
 #define brnf_call_ip6tables 1
+#else
+#define brnf_call_ip6tables 0
+#endif
 #define brnf_call_arptables 1
 #define brnf_filter_vlan_tagged 0
 #define brnf_filter_pppoe_tagged 0
@@ -965,6 +973,17 @@ int brnf_sysctl_call_tables(struct ctl_table *ctl, int write,
 	return ret;
 }
 
+static
+int brnf_sysctl_call_ip6tables(struct ctl_table *ctl, int write,
+			       void __user *buffer, size_t *lenp, loff_t *ppos)
+{
+	if (!IS_ENABLED(CONFIG_IPV6)) {
+		if (write)
+			return -EINVAL;
+	}
+	return brnf_sysctl_call_tables(ctl, write, buffer, lenp, ppos);
+}
+
 static struct ctl_table brnf_table[] = {
 	{
 		.procname	= "bridge-nf-call-arptables",
@@ -985,7 +1004,7 @@ static struct ctl_table brnf_table[] = {
 		.data		= &brnf_call_ip6tables,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= brnf_sysctl_call_tables,
+		.proc_handler	= brnf_sysctl_call_ip6tables,
 	},
 	{
 		.procname	= "bridge-nf-filter-vlan-tagged",
diff --git a/net/bridge/br_sysfs_br.c b/net/bridge/br_sysfs_br.c
index 4c97fc5..8767477 100644
--- a/net/bridge/br_sysfs_br.c
+++ b/net/bridge/br_sysfs_br.c
@@ -660,6 +660,9 @@ static ssize_t nf_call_ip6tables_show(
 
 static int set_nf_call_ip6tables(struct net_bridge *br, unsigned long val)
 {
+	if (!IS_ENABLED(CONFIG_IPV6))
+		return -EINVAL;
+
 	br->nf_call_ip6tables = val ? true : false;
 	return 0;
 }
-- 
1.7.10.4

