From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 49/49]: Select CONFIG_NETFILTER_NETLINK when needed
Date: Tue,  4 Dec 2007 13:03:04 +0100 (MET)
Message-ID: <20071204120304.2442.34288.sendpatchset@localhost.localdomain>
References: <20071204120154.2442.91626.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:62261 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753282AbXLDMDF (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Dec 2007 07:03:05 -0500
In-Reply-To: <20071204120154.2442.91626.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: Select CONFIG_NETFILTER_NETLINK when needed

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit c2bf9632fd83ce5b3b66dcafde0d447a50b45fdd
tree 780a893558e5ac335fb5f35bc0357800528d93a4
parent 961020004705df03d7f44449985d98ed4b99a0f7
author Patrick McHardy <kaber@trash.net> Tue, 04 Dec 2007 10:48:34 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 04 Dec 2007 12:37:37 +0100

 net/netfilter/Kconfig |   13 +++++--------
 1 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 772c58c..bb61f83 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -2,21 +2,18 @@ menu "Core Netfilter Configuration"
 	depends on NET && INET && NETFILTER
 
 config NETFILTER_NETLINK
-       tristate "Netfilter netlink interface"
-       help
-         If this option is enabled, the kernel will include support
-         for the new netfilter netlink interface.
+	tristate
 
 config NETFILTER_NETLINK_QUEUE
 	tristate "Netfilter NFQUEUE over NFNETLINK interface"
-	depends on NETFILTER_NETLINK
+	select NETFILTER_NETLINK
 	help
 	  If this option is enabled, the kernel will include support
 	  for queueing packets via NFNETLINK.
 	  
 config NETFILTER_NETLINK_LOG
 	tristate "Netfilter LOG over NFNETLINK interface"
-	depends on NETFILTER_NETLINK
+	select NETFILTER_NETLINK
 	help
 	  If this option is enabled, the kernel will include support
 	  for logging packets via NFNETLINK.
@@ -246,8 +243,8 @@ config NF_CONNTRACK_TFTP
 
 config NF_CT_NETLINK
 	tristate 'Connection tracking netlink interface (EXPERIMENTAL)'
-	depends on EXPERIMENTAL && NF_CONNTRACK && NETFILTER_NETLINK
-	depends on NF_CONNTRACK!=y || NETFILTER_NETLINK!=m
+	depends on EXPERIMENTAL && NF_CONNTRACK
+	select NETFILTER_NETLINK
 	depends on NF_NAT=n || NF_NAT
 	help
 	  This option enables support for a netlink-based userspace interface
