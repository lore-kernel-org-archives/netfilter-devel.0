From: Tobias Doerffel <tobias.doerffel@gmail.com>
Subject: [PATCH] netfilter: scheduled removal of CONFIG_NF_CT_ACCT
Date: Sun, 30 May 2010 13:51:51 +0200
Message-ID: <1275220311-12578-1-git-send-email-tobias.doerffel@gmail.com>
Cc: Krzysztof Piotr Oledzki <ole@ans.pl>,
	Tobias Doerffel <tobias.doerffel@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from jessica.hrz.tu-chemnitz.de ([134.109.132.47]:39309 "EHLO
	jessica.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753212Ab0E3MYk (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 30 May 2010 08:24:40 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Removal of the CONFIG_NF_CT_ACCT was already scheduled for 2.6.29,
therefore remove it now and set nf_conntrack.acct depending on
CONFIG_NETFILTER_XT_MATCH_CONNBYTES.

Signed-off-by: Tobias Doerffel <tobias.doerffel@gmail.com>
---
 Documentation/feature-removal-schedule.txt |    9 ---------
 net/netfilter/Kconfig                      |   22 ----------------------
 net/netfilter/nf_conntrack_acct.c          |    8 +-------
 3 files changed, 1 insertions(+), 38 deletions(-)

diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index 672be01..92f021a 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -303,15 +303,6 @@ Who:	Johannes Berg <johannes@sipsolutions.net>
 
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
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 8593a77..ba936f6 100644
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
@@ -618,7 +597,6 @@ config NETFILTER_XT_MATCH_CONNBYTES
 	tristate  '"connbytes" per-connection counter match support'
 	depends on NF_CONNTRACK
 	depends on NETFILTER_ADVANCED
-	select NF_CT_ACCT
 	help
 	  This option adds a `connbytes' match, which allows you to match the
 	  number of bytes and/or packets for each direction within a connection.
diff --git a/net/netfilter/nf_conntrack_acct.c b/net/netfilter/nf_conntrack_acct.c
index ab81b38..cac29c7 100644
--- a/net/netfilter/nf_conntrack_acct.c
+++ b/net/netfilter/nf_conntrack_acct.c
@@ -17,7 +17,7 @@
 #include <net/netfilter/nf_conntrack_extend.h>
 #include <net/netfilter/nf_conntrack_acct.h>
 
-#ifdef CONFIG_NF_CT_ACCT
+#ifdef CONFIG_NETFILTER_XT_MATCH_CONNBYTES
 #define NF_CT_ACCT_DEFAULT 1
 #else
 #define NF_CT_ACCT_DEFAULT 0
@@ -114,12 +114,6 @@ int nf_conntrack_acct_init(struct net *net)
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
-- 
1.7.0.4

