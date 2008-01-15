From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 02/38]: Remove some EXPERIMENTAL dependencies
Date: Tue, 15 Jan 2008 07:19:15 +0100 (MET)
Message-ID: <20080115061910.3184.20236.sendpatchset@localhost.localdomain>
References: <20080115061907.3184.39432.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:62162 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752031AbYAOGTQ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 15 Jan 2008 01:19:16 -0500
In-Reply-To: <20080115061907.3184.39432.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: Remove some EXPERIMENTAL dependencies

Most of the netfilter modules are not considered experimental anymore,
the only ones I want to keep marked as EXPERIMENTAL are:

- TCPOPTSTRIP target, which is brand new.

- SANE helper, which is quite new.

- CLUSTERIP target, which I believe hasn't had much testing despite
  being in the kernel for quite a long time.

- SCTP match and conntrack protocol, which are a mess and need to
  be reviewed and cleaned up before I would trust them.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 9eef50d726e834652abc7aca9740b62fbb89c124
tree 21abe009ce0e5e64be41a6a4c307fc7b30db0f08
parent 46cc0c9011901f2697608a11c05d43765c7a3b38
author Patrick McHardy <kaber@trash.net> Mon, 14 Jan 2008 06:51:08 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 15 Jan 2008 06:23:22 +0100

 net/ipv4/netfilter/Kconfig |    4 ++--
 net/ipv6/netfilter/Kconfig |   12 ++++++------
 net/netfilter/Kconfig      |   24 ++++++++++++------------
 3 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/net/ipv4/netfilter/Kconfig b/net/ipv4/netfilter/Kconfig
index cface71..10ca307 100644
--- a/net/ipv4/netfilter/Kconfig
+++ b/net/ipv4/netfilter/Kconfig
@@ -229,8 +229,8 @@ config IP_NF_TARGET_NETMAP
 	  To compile it as a module, choose M here.  If unsure, say N.
 
 config NF_NAT_SNMP_BASIC
-	tristate "Basic SNMP-ALG support (EXPERIMENTAL)"
-	depends on EXPERIMENTAL && NF_NAT
+	tristate "Basic SNMP-ALG support"
+	depends on NF_NAT
 	depends on NETFILTER_ADVANCED
 	---help---
 
diff --git a/net/ipv6/netfilter/Kconfig b/net/ipv6/netfilter/Kconfig
index a6b4a9a..4fc0b02 100644
--- a/net/ipv6/netfilter/Kconfig
+++ b/net/ipv6/netfilter/Kconfig
@@ -2,12 +2,12 @@
 # IP netfilter configuration
 #
 
-menu "IPv6: Netfilter Configuration (EXPERIMENTAL)"
-	depends on INET && IPV6 && NETFILTER && EXPERIMENTAL
+menu "IPv6: Netfilter Configuration"
+	depends on INET && IPV6 && NETFILTER
 
 config NF_CONNTRACK_IPV6
-	tristate "IPv6 connection tracking support (EXPERIMENTAL)"
-	depends on INET && IPV6 && EXPERIMENTAL && NF_CONNTRACK
+	tristate "IPv6 connection tracking support"
+	depends on INET && IPV6 && NF_CONNTRACK
 	default m if NETFILTER_ADVANCED=n
 	---help---
 	  Connection tracking keeps a record of what packets have passed
@@ -22,7 +22,7 @@ config NF_CONNTRACK_IPV6
 
 config IP6_NF_QUEUE
 	tristate "IP6 Userspace queueing via NETLINK (OBSOLETE)"
-	depends on INET && IPV6 && NETFILTER && EXPERIMENTAL
+	depends on INET && IPV6 && NETFILTER
 	depends on NETFILTER_ADVANCED
 	---help---
 
@@ -44,7 +44,7 @@ config IP6_NF_QUEUE
 
 config IP6_NF_IPTABLES
 	tristate "IP6 tables support (required for filtering)"
-	depends on INET && IPV6 && EXPERIMENTAL
+	depends on INET && IPV6
 	select NETFILTER_XTABLES
 	default m if NETFILTER_ADVANCED=n
 	help
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index a711b42..79d7143 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -76,8 +76,8 @@ config NF_CONNTRACK_SECMARK
 	  If unsure, say 'N'.
 
 config NF_CONNTRACK_EVENTS
-	bool "Connection tracking events (EXPERIMENTAL)"
-	depends on EXPERIMENTAL && NF_CONNTRACK
+	bool "Connection tracking events"
+	depends on NF_CONNTRACK
 	depends on NETFILTER_ADVANCED
 	help
 	  If this option is enabled, the connection tracking code will
@@ -102,8 +102,8 @@ config NF_CT_PROTO_SCTP
 	  <file:Documentation/kbuild/modules.txt>.  If unsure, say `N'.
 
 config NF_CT_PROTO_UDPLITE
-	tristate 'UDP-Lite protocol connection tracking support (EXPERIMENTAL)'
-	depends on EXPERIMENTAL && NF_CONNTRACK
+	tristate 'UDP-Lite protocol connection tracking support'
+	depends on NF_CONNTRACK
 	depends on NETFILTER_ADVANCED
 	help
 	  With this option enabled, the layer 3 independent connection
@@ -144,8 +144,8 @@ config NF_CONNTRACK_FTP
 	  To compile it as a module, choose M here.  If unsure, say N.
 
 config NF_CONNTRACK_H323
-	tristate "H.323 protocol support (EXPERIMENTAL)"
-	depends on EXPERIMENTAL && NF_CONNTRACK && (IPV6 || IPV6=n)
+	tristate "H.323 protocol support"
+	depends on NF_CONNTRACK && (IPV6 || IPV6=n)
 	depends on NETFILTER_ADVANCED
 	help
 	  H.323 is a VoIP signalling protocol from ITU-T. As one of the most
@@ -180,8 +180,8 @@ config NF_CONNTRACK_IRC
 	  To compile it as a module, choose M here.  If unsure, say N.
 
 config NF_CONNTRACK_NETBIOS_NS
-	tristate "NetBIOS name service protocol support (EXPERIMENTAL)"
-	depends on EXPERIMENTAL && NF_CONNTRACK
+	tristate "NetBIOS name service protocol support"
+	depends on NF_CONNTRACK
 	depends on NETFILTER_ADVANCED
 	help
 	  NetBIOS name service requests are sent as broadcast messages from an
@@ -234,8 +234,8 @@ config NF_CONNTRACK_SANE
 	  To compile it as a module, choose M here.  If unsure, say N.
 
 config NF_CONNTRACK_SIP
-	tristate "SIP protocol support (EXPERIMENTAL)"
-	depends on EXPERIMENTAL && NF_CONNTRACK
+	tristate "SIP protocol support"
+	depends on NF_CONNTRACK
 	default m if NETFILTER_ADVANCED=n
 	help
 	  SIP is an application-layer control protocol that can establish,
@@ -259,8 +259,8 @@ config NF_CONNTRACK_TFTP
 	  To compile it as a module, choose M here.  If unsure, say N.
 
 config NF_CT_NETLINK
-	tristate 'Connection tracking netlink interface (EXPERIMENTAL)'
-	depends on EXPERIMENTAL && NF_CONNTRACK
+	tristate 'Connection tracking netlink interface'
+	depends on NF_CONNTRACK
 	select NETFILTER_NETLINK
 	depends on NF_NAT=n || NF_NAT
 	default m if NETFILTER_ADVANCED=n
