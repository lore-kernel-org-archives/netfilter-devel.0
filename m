From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 35/38]: kill nf_sysctl.c
Date: Tue, 15 Jan 2008 07:19:59 +0100 (MET)
Message-ID: <20080115061954.3184.53295.sendpatchset@localhost.localdomain>
References: <20080115061907.3184.39432.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:62267 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752878AbYAOGUA (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 15 Jan 2008 01:20:00 -0500
In-Reply-To: <20080115061907.3184.39432.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: kill nf_sysctl.c

Since there now is generic support for shared sysctl paths, the only
remains are the net/netfilter and net/ipv4/netfilter paths. Move them
to net/netfilter/core.c and net/ipv4/netfilter.c and kill nf_sysctl.c.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit b243ece57ad7c480af162ff7cc857b8aa2b0c409
tree 693c714dbe16fa64247a5bfa7d2ef6da944952bd
parent 918cc347b331a901245021bd85c1cb3c7ff54482
author Patrick McHardy <kaber@trash.net> Tue, 15 Jan 2008 06:53:30 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 15 Jan 2008 06:53:30 +0100

 net/ipv4/netfilter.c      |   10 ++++++++++
 net/netfilter/Makefile    |    1 -
 net/netfilter/core.c      |    9 +++++++++
 net/netfilter/nf_sysctl.c |   25 -------------------------
 4 files changed, 19 insertions(+), 26 deletions(-)

diff --git a/net/ipv4/netfilter.c b/net/ipv4/netfilter.c
index 0ed843e..6322155 100644
--- a/net/ipv4/netfilter.c
+++ b/net/ipv4/netfilter.c
@@ -211,3 +211,13 @@ static void ipv4_netfilter_fini(void)
 
 module_init(ipv4_netfilter_init);
 module_exit(ipv4_netfilter_fini);
+
+#ifdef CONFIG_SYSCTL
+struct ctl_path nf_net_ipv4_netfilter_sysctl_path[] = {
+	{ .procname = "net", .ctl_name = CTL_NET, },
+	{ .procname = "ipv4", .ctl_name = NET_IPV4, },
+	{ .procname = "netfilter", .ctl_name = NET_IPV4_NETFILTER, },
+	{ }
+};
+EXPORT_SYMBOL_GPL(nf_net_ipv4_netfilter_sysctl_path);
+#endif /* CONFIG_SYSCTL */
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index c910cae..ea75083 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -4,7 +4,6 @@ nf_conntrack-y	:= nf_conntrack_core.o nf_conntrack_standalone.o nf_conntrack_exp
 nf_conntrack-$(CONFIG_NF_CONNTRACK_EVENTS) += nf_conntrack_ecache.o
 
 obj-$(CONFIG_NETFILTER) = netfilter.o
-obj-$(CONFIG_SYSCTL) += nf_sysctl.o
 
 obj-$(CONFIG_NETFILTER_NETLINK) += nfnetlink.o
 obj-$(CONFIG_NETFILTER_NETLINK_QUEUE) += nfnetlink_queue.o
diff --git a/net/netfilter/core.c b/net/netfilter/core.c
index e026344..c4065b8 100644
--- a/net/netfilter/core.c
+++ b/net/netfilter/core.c
@@ -272,3 +272,12 @@ void __init netfilter_init(void)
 	if (netfilter_log_init() < 0)
 		panic("cannot initialize nf_log");
 }
+
+#ifdef CONFIG_SYSCTL
+struct ctl_path nf_net_netfilter_sysctl_path[] = {
+	{ .procname = "net", .ctl_name = CTL_NET, },
+	{ .procname = "netfilter", .ctl_name = NET_NETFILTER, },
+	{ }
+};
+EXPORT_SYMBOL_GPL(nf_net_netfilter_sysctl_path);
+#endif /* CONFIG_SYSCTL */
diff --git a/net/netfilter/nf_sysctl.c b/net/netfilter/nf_sysctl.c
deleted file mode 100644
index d9fcc89..0000000
--- a/net/netfilter/nf_sysctl.c
+++ /dev/null
@@ -1,25 +0,0 @@
-/* nf_sysctl.c	netfilter sysctl registration/unregistation
- *
- * Copyright (c) 2006 Patrick McHardy <kaber@trash.net>
- */
-#include <linux/module.h>
-#include <linux/sysctl.h>
-#include <linux/string.h>
-#include <linux/slab.h>
-
-/* net/netfilter */
-struct ctl_path nf_net_netfilter_sysctl_path[] = {
-	{ .procname = "net", .ctl_name = CTL_NET, },
-	{ .procname = "netfilter", .ctl_name = NET_NETFILTER, },
-	{ }
-};
-EXPORT_SYMBOL_GPL(nf_net_netfilter_sysctl_path);
-
-/* net/ipv4/netfilter */
-struct ctl_path nf_net_ipv4_netfilter_sysctl_path[] = {
-	{ .procname = "net", .ctl_name = CTL_NET, },
-	{ .procname = "ipv4", .ctl_name = NET_IPV4, },
-	{ .procname = "netfilter", .ctl_name = NET_IPV4_NETFILTER, },
-	{ }
-};
-EXPORT_SYMBOL_GPL(nf_net_ipv4_netfilter_sysctl_path);
