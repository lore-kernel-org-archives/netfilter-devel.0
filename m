From: Changli Gao <xiaosuo@gmail.com>
Subject: [PATCH] netfilter: remove CONFIG_NF_CT_ACCT
Date: Fri, 06 Nov 2009 17:00:19 +0800
Message-ID: <4AF3E5A3.1080805@gmail.com>
Reply-To: xiaosuo@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, xiaosuo <xiaosuo@gmail.com>,
	Krzysztof Piotr Oledzki <ole@ans.pl>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pw0-f42.google.com ([209.85.160.42]:60447 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754397AbZKFJAF (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 6 Nov 2009 04:00:05 -0500
Received: by pwj9 with SMTP id 9so533188pwj.21
        for <netfilter-devel@vger.kernel.org>; Fri, 06 Nov 2009 01:00:10 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

remove CONFIG_NF_CT_ACCT

Accounting can now be enabled/disabled without kernel recompilation.
Currently used only to set a default value for a feature that is also
controlled by a kernel/module/sysfs/sysctl parameter.

Signed-off-by: Changli Gao <xiaosuo@gmail.com>
----
Documentation/feature-removal-schedule.txt | 9 ---------
net/netfilter/Kconfig | 22 ----------------------
net/netfilter/nf_conntrack_acct.c | 10 ----------
net/netfilter/nf_conntrack_netlink.c | 2 --
4 files changed, 43 deletions(-)

diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 634d14a..5dfe7ec 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -40,27 +40,6 @@ config NF_CONNTRACK
 
 if NF_CONNTRACK
 
-config NF_CT_ACCT
-	bool "Connection tracking flow accounting"
-	depends on NETFILTER_ADVANCED
-	help
-	  If this option is enabled, the connection tracking code will
-	  keep per-flow packet and byte counters.
-
-	  Those counters can be used for flow-based accounting or the
-	  `connbytes' match.
-
-	  Please note that currently this option only sets a default state.
-	  You may change it at boot time with nf_conntrack.acct=0/1 kernel
-	  parameter or by loading the nf_conntrack module with acct=0/1.
-
-	  You may also disable/enable it on a running system with:
-	   sysctl net.netfilter.nf_conntrack_acct=0/1
-
-	  This option will be removed in 2.6.29.
-
-	  If unsure, say `N'.
-
 config NF_CONNTRACK_MARK
 	bool  'Connection mark tracking support'
 	depends on NETFILTER_ADVANCED
@@ -557,7 +536,6 @@ config NETFILTER_XT_MATCH_CONNBYTES
 	tristate  '"connbytes" per-connection counter match support'
 	depends on NF_CONNTRACK
 	depends on NETFILTER_ADVANCED
-	select NF_CT_ACCT
 	help
 	  This option adds a `connbytes' match, which allows you to match the
 	  number of bytes and/or packets for each direction within a connection.
diff --git a/net/netfilter/nf_conntrack_acct.c b/net/netfilter/nf_conntrack_acct.c
index 4a1d94a..bc25451 100644
--- a/net/netfilter/nf_conntrack_acct.c
+++ b/net/netfilter/nf_conntrack_acct.c
@@ -16,11 +16,7 @@
 #include <net/netfilter/nf_conntrack_extend.h>
 #include <net/netfilter/nf_conntrack_acct.h>
 
-#ifdef CONFIG_NF_CT_ACCT
-#define NF_CT_ACCT_DEFAULT 1
-#else
 #define NF_CT_ACCT_DEFAULT 0
-#endif
 
 static int nf_ct_acct __read_mostly = NF_CT_ACCT_DEFAULT;
 
@@ -114,12 +110,6 @@ int nf_conntrack_acct_init(struct net *net)
 	net->ct.sysctl_acct = nf_ct_acct;
 
 	if (net_eq(net, &init_net)) {
-#ifdef CONFIG_NF_CT_ACCT
-	printk(KERN_WARNING "CONFIG_NF_CT_ACCT is deprecated and will be removed soon. Please use\n");
-		printk(KERN_WARNING "nf_conntrack.acct=1 kernel parameter, acct=1 nf_conntrack module option or\n");
-		printk(KERN_WARNING "sysctl net.netfilter.nf_conntrack_acct=1 to enable it.\n");
-#endif
-
 		ret = nf_ct_extend_register(&acct_extend);
 		if (ret < 0) {
 			printk(KERN_ERR "nf_conntrack_acct: Unable to register extension\n");
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 59d8064..d679562 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -430,11 +430,9 @@ ctnetlink_nlmsg_size(const struct nf_conn *ct)
 	       + 3 * nla_total_size(sizeof(u_int8_t)) /* CTA_PROTO_NUM */
 	       + nla_total_size(sizeof(u_int32_t)) /* CTA_ID */
 	       + nla_total_size(sizeof(u_int32_t)) /* CTA_STATUS */
-#ifdef CONFIG_NF_CT_ACCT
 	       + 2 * nla_total_size(0) /* CTA_COUNTERS_ORIG|REPL */
 	       + 2 * nla_total_size(sizeof(uint64_t)) /* CTA_COUNTERS_PACKETS */
 	       + 2 * nla_total_size(sizeof(uint64_t)) /* CTA_COUNTERS_BYTES */
-#endif
 	       + nla_total_size(sizeof(u_int32_t)) /* CTA_TIMEOUT */
 	       + nla_total_size(0) /* CTA_PROTOINFO */
 	       + nla_total_size(0) /* CTA_HELP */
diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index bc693ff..a4a8bf8 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -345,15 +345,6 @@ Who:	Johannes Berg <johannes@sipsolutions.net>
 
 ---------------------------
 
-What: CONFIG_NF_CT_ACCT
-When: 2.6.29
-Why:  Accounting can now be enabled/disabled without kernel recompilation.
-      Currently used only to set a default value for a feature that is also
-      controlled by a kernel/module/sysfs/sysctl parameter.
-Who:  Krzysztof Piotr Oledzki <ole@ans.pl>
-
----------------------------
-
 What:	sysfs ui for changing p4-clockmod parameters
 When:	September 2009
 Why:	See commits 129f8ae9b1b5be94517da76009ea956e89104ce8 and


