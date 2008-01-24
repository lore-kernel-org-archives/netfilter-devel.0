From: Laszlo Attila Toth <panther@balabit.hu>
Subject: [PATCH] Set default policy of chains in filter tables to DROP/ACCEPT
Date: Thu, 24 Jan 2008 15:11:25 +0100
Message-ID: <1201183885868-git-send-email-panther@balabit.hu>
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>,
	Laszlo Attila Toth <panther@balabit.hu>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from www.balabit.hu ([212.92.18.33]:43444 "EHLO lists.balabit.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751591AbYAXOLa (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 24 Jan 2008 09:11:30 -0500
Received: from balabit.hu (unknown [10.80.0.254])
	by lists.balabit.hu (Postfix) with ESMTP id 04CD7C1162
	for <netfilter-devel@vger.kernel.org>; Thu, 24 Jan 2008 15:11:26 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Set the default policy of INPUT/FORWARD/OUTPUT chains of IPv4/IPv6 filter
tables to DROP or ACCEPT in kernel configuration. It can be override by
a module parameter (defaultdrop for IPv4 and defaultdropv6 for IPv6).

Signed-off-by: Laszlo Attila Toth <panther@balabit.hu>
---
 net/ipv4/netfilter/Kconfig           |   11 +++++++++++
 net/ipv4/netfilter/iptable_filter.c  |   23 ++++++++++++++++-------
 net/ipv6/netfilter/Kconfig           |   11 +++++++++++
 net/ipv6/netfilter/ip6table_filter.c |   23 ++++++++++++++++-------
 4 files changed, 54 insertions(+), 14 deletions(-)

diff --git a/net/ipv4/netfilter/Kconfig b/net/ipv4/netfilter/Kconfig
index 9a077cb..72e0de7 100644
--- a/net/ipv4/netfilter/Kconfig
+++ b/net/ipv4/netfilter/Kconfig
@@ -123,6 +123,17 @@ config IP_NF_FILTER
 
 	  To compile it as a module, choose M here.  If unsure, say N.
 
+config IP_NF_FILTER_DEFAULT_DROP
+	bool "Default policy is drop"
+	depends on IP_NF_FILTER
+	default n
+	help
+	  In server environment the recommended default policy of the chains
+	  of filter table is DROP before any network interface is up. If this
+	  option is set, the policy will be  DROP, otherwise ACCEPT.
+
+	  If unsure, say N.
+
 config IP_NF_TARGET_REJECT
 	tristate "REJECT target support"
 	depends on IP_NF_FILTER
diff --git a/net/ipv4/netfilter/iptable_filter.c b/net/ipv4/netfilter/iptable_filter.c
index 29bb4f9..01c84f1 100644
--- a/net/ipv4/netfilter/iptable_filter.c
+++ b/net/ipv4/netfilter/iptable_filter.c
@@ -115,21 +115,30 @@ static struct nf_hook_ops ipt_ops[] __read_mostly = {
 	},
 };
 
-/* Default to forward because I got too much mail already. */
-static int forward = NF_ACCEPT;
-module_param(forward, bool, 0000);
+static int defaultdrop
+#ifdef CONFIG_IP_NF_FILTER_DEFAULT_DROP
+			= 1;
+#else
+			= 0;
+#endif
+module_param(defaultdrop, int, 0400);
 
 static int __init iptable_filter_init(void)
 {
 	int ret;
+	int verdict;
 
-	if (forward < 0 || forward > NF_MAX_VERDICT) {
-		printk("iptables forward must be 0 or 1\n");
+	if (defaultdrop < 0 || defaultdrop > 1) {
+		printk("iptables defaultdrop must be 0 or 1\n");
 		return -EINVAL;
 	}
 
-	/* Entry 1 is the FORWARD hook */
-	initial_table.entries[1].target.verdict = -forward - 1;
+	/* Change default rule to ACCEPT if defaultdrop = 0 was given. */
+	verdict = - (defaultdrop ? NF_DROP : NF_ACCEPT) - 1;
+	
+	initial_table.entries[0].target.verdict = verdict;
+	initial_table.entries[1].target.verdict = verdict;
+	initial_table.entries[2].target.verdict = verdict;
 
 	/* Register table */
 	ret = ipt_register_table(&packet_filter, &initial_table.repl);
diff --git a/net/ipv6/netfilter/Kconfig b/net/ipv6/netfilter/Kconfig
index 4fc0b02..1b3c560 100644
--- a/net/ipv6/netfilter/Kconfig
+++ b/net/ipv6/netfilter/Kconfig
@@ -147,6 +147,17 @@ config IP6_NF_FILTER
 
 	  To compile it as a module, choose M here.  If unsure, say N.
 
+config IP6_NF_FILTER_DEFAULT_DROP
+	bool "Default policy is drop"
+	depends on IP6_NF_FILTER
+	default n
+	help
+	  In server environment the recommended default policy of the chains
+	  of filter table is DROP before any network interface is up. If this
+	  option is set, the policy will be  DROP, otherwise ACCEPT.
+
+	  If unsure, say N.
+
 config IP6_NF_TARGET_LOG
 	tristate "LOG target support"
 	depends on IP6_NF_FILTER
diff --git a/net/ipv6/netfilter/ip6table_filter.c b/net/ipv6/netfilter/ip6table_filter.c
index 87d38d0..9e37920 100644
--- a/net/ipv6/netfilter/ip6table_filter.c
+++ b/net/ipv6/netfilter/ip6table_filter.c
@@ -114,21 +114,30 @@ static struct nf_hook_ops ip6t_ops[] __read_mostly = {
 	},
 };
 
-/* Default to forward because I got too much mail already. */
-static int forward = NF_ACCEPT;
-module_param(forward, bool, 0000);
+static int defaultdropv6
+#ifdef CONFIG_IP6_NF_FILTER_DEFAULT_DROP
+			= 1;
+#else
+			= 0;
+#endif
+module_param(defaultdropv6, int, 0400);
 
 static int __init ip6table_filter_init(void)
 {
 	int ret;
+	int verdict;
 
-	if (forward < 0 || forward > NF_MAX_VERDICT) {
-		printk("iptables forward must be 0 or 1\n");
+	if (defaultdropv6 < 0 || defaultdropv6 > 1) {
+		printk("iptables defaultdropv6 must be 0 or 1\n");
 		return -EINVAL;
 	}
 
-	/* Entry 1 is the FORWARD hook */
-	initial_table.entries[1].target.verdict = -forward - 1;
+	/* Change default rule to ACCEPT if defaultdrop = 0 was given. */
+	verdict = - (defaultdropv6 ? NF_DROP : NF_ACCEPT) - 1;
+	
+	initial_table.entries[0].target.verdict = verdict;
+	initial_table.entries[1].target.verdict = verdict;
+	initial_table.entries[2].target.verdict = verdict;
 
 	/* Register table */
 	ret = ip6t_register_table(&packet_filter, &initial_table.repl);
-- 
1.5.2.5

