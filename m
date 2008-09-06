From: Jan Engelhardt <jengelh@medozas.de>
Subject: [NETFILTER]: Make BRIDGE_NF_EBTABLES a menuconfig option
Date: Sat, 6 Sep 2008 12:09:58 -0400 (EDT)
Message-ID: <alpine.LNX.1.10.0809061209470.14936@fbirervta.pbzchgretzou.qr>
References: <alpine.LNX.1.10.0809061209150.14936@fbirervta.pbzchgretzou.qr> <alpine.LNX.1.10.0809061209310.14936@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:55515 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752220AbYIFQKA (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 6 Sep 2008 12:10:00 -0400
In-Reply-To: <alpine.LNX.1.10.0809061209310.14936@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit 459a249b231488f4c1f2728e1e53ff57527b59b8
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Sun Aug 10 22:16:17 2008 -0400

[NETFILTER]: Make BRIDGE_NF_EBTABLES a menuconfig option

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 net/bridge/netfilter/Kconfig |   29 +++++------------------------
 1 files changed, 5 insertions(+), 24 deletions(-)

diff --git a/net/bridge/netfilter/Kconfig b/net/bridge/netfilter/Kconfig
index e339421..e14f56d 100644
--- a/net/bridge/netfilter/Kconfig
+++ b/net/bridge/netfilter/Kconfig
@@ -2,22 +2,21 @@
 # Bridge netfilter configuration
 #
 
-menu "Bridge: Netfilter Configuration"
-	depends on BRIDGE && BRIDGE_NETFILTER
-
-config BRIDGE_NF_EBTABLES
+menuconfig BRIDGE_NF_EBTABLES
 	tristate "Ethernet Bridge tables (ebtables) support"
 	select NETFILTER_XTABLES
 	help
 	  ebtables is a general, extensible frame/packet identification
 	  framework. Say 'Y' or 'M' here if you want to do Ethernet
 	  filtering/NAT/brouting on the Ethernet bridge.
+
+if BRIDGE_NF_EBTABLES
+
 #
 # tables
 #
 config BRIDGE_EBT_BROUTE
 	tristate "ebt: broute table support"
-	depends on BRIDGE_NF_EBTABLES
 	help
 	  The ebtables broute table is used to define rules that decide between
 	  bridging and routing frames, giving Linux the functionality of a
@@ -28,7 +27,6 @@ config BRIDGE_EBT_BROUTE
 
 config BRIDGE_EBT_T_FILTER
 	tristate "ebt: filter table support"
-	depends on BRIDGE_NF_EBTABLES
 	help
 	  The ebtables filter table is used to define frame filtering rules at
 	  local input, forwarding and local output. See the man page for
@@ -38,7 +36,6 @@ config BRIDGE_EBT_T_FILTER
 
 config BRIDGE_EBT_T_NAT
 	tristate "ebt: nat table support"
-	depends on BRIDGE_NF_EBTABLES
 	help
 	  The ebtables nat table is used to define rules that alter the MAC
 	  source address (MAC SNAT) or the MAC destination address (MAC DNAT).
@@ -53,7 +50,6 @@ if NETFILTER_XTABLES
 #
 config BRIDGE_EBT_802_3
 	tristate "ebt: 802.3 filter support"
-	depends on BRIDGE_NF_EBTABLES
 	help
 	  This option adds matching support for 802.3 Ethernet frames.
 
@@ -61,7 +57,6 @@ config BRIDGE_EBT_802_3
 
 config BRIDGE_EBT_AMONG
 	tristate "ebt: among filter support"
-	depends on BRIDGE_NF_EBTABLES
 	help
 	  This option adds the among match, which allows matching the MAC source
 	  and/or destination address on a list of addresses. Optionally,
@@ -71,7 +66,6 @@ config BRIDGE_EBT_AMONG
 
 config BRIDGE_EBT_ARP
 	tristate "ebt: ARP filter support"
-	depends on BRIDGE_NF_EBTABLES
 	help
 	  This option adds the ARP match, which allows ARP and RARP header field
 	  filtering.
@@ -80,7 +74,6 @@ config BRIDGE_EBT_ARP
 
 config BRIDGE_EBT_IP
 	tristate "ebt: IP filter support"
-	depends on BRIDGE_NF_EBTABLES
 	help
 	  This option adds the IP match, which allows basic IP header field
 	  filtering.
@@ -98,7 +91,6 @@ config BRIDGE_EBT_IP6
 
 config BRIDGE_EBT_LIMIT
 	tristate "ebt: limit match support"
-	depends on BRIDGE_NF_EBTABLES
 	help
 	  This option adds the limit match, which allows you to control
 	  the rate at which a rule can be matched. This match is the
@@ -109,7 +101,6 @@ config BRIDGE_EBT_LIMIT
 
 config BRIDGE_EBT_MARK
 	tristate "ebt: mark filter support"
-	depends on BRIDGE_NF_EBTABLES
 	help
 	  This option adds the mark match, which allows matching frames based on
 	  the 'nfmark' value in the frame. This can be set by the mark target.
@@ -120,7 +111,6 @@ config BRIDGE_EBT_MARK
 
 config BRIDGE_EBT_PKTTYPE
 	tristate "ebt: packet type filter support"
-	depends on BRIDGE_NF_EBTABLES
 	help
 	  This option adds the packet type match, which allows matching on the
 	  type of packet based on its Ethernet "class" (as determined by
@@ -131,7 +121,6 @@ config BRIDGE_EBT_PKTTYPE
 
 config BRIDGE_EBT_STP
 	tristate "ebt: STP filter support"
-	depends on BRIDGE_NF_EBTABLES
 	help
 	  This option adds the Spanning Tree Protocol match, which
 	  allows STP header field filtering.
@@ -140,7 +129,6 @@ config BRIDGE_EBT_STP
 
 config BRIDGE_EBT_VLAN
 	tristate "ebt: 802.1Q VLAN filter support"
-	depends on BRIDGE_NF_EBTABLES
 	help
 	  This option adds the 802.1Q vlan match, which allows the filtering of
 	  802.1Q vlan fields.
@@ -151,7 +139,6 @@ config BRIDGE_EBT_VLAN
 #
 config BRIDGE_EBT_DNAT
 	tristate "ebt: dnat target support"
-	depends on BRIDGE_NF_EBTABLES
 	help
 	  This option adds the MAC DNAT target, which allows altering the MAC
 	  destination address of frames.
@@ -160,7 +147,6 @@ config BRIDGE_EBT_DNAT
 
 config BRIDGE_EBT_MARK_T
 	tristate "ebt: mark target support"
-	depends on BRIDGE_NF_EBTABLES
 	help
 	  This option adds the mark target, which allows marking frames by
 	  setting the 'nfmark' value in the frame.
@@ -171,7 +157,6 @@ config BRIDGE_EBT_MARK_T
 
 config BRIDGE_EBT_REDIRECT
 	tristate "ebt: redirect target support"
-	depends on BRIDGE_NF_EBTABLES
 	help
 	  This option adds the MAC redirect target, which allows altering the MAC
 	  destination address of a frame to that of the device it arrived on.
@@ -180,7 +165,6 @@ config BRIDGE_EBT_REDIRECT
 
 config BRIDGE_EBT_SNAT
 	tristate "ebt: snat target support"
-	depends on BRIDGE_NF_EBTABLES
 	help
 	  This option adds the MAC SNAT target, which allows altering the MAC
 	  source address of frames.
@@ -191,7 +175,6 @@ config BRIDGE_EBT_SNAT
 #
 config BRIDGE_EBT_LOG
 	tristate "ebt: log support"
-	depends on BRIDGE_NF_EBTABLES
 	help
 	  This option adds the log watcher, that you can use in any rule
 	  in any ebtables table. It records info about the frame header
@@ -201,7 +184,6 @@ config BRIDGE_EBT_LOG
 
 config BRIDGE_EBT_ULOG
 	tristate "ebt: ulog support (OBSOLETE)"
-	depends on BRIDGE_NF_EBTABLES
 	help
 	  This option enables the old bridge-specific "ebt_ulog" implementation
 	  which has been obsoleted by the new "nfnetlink_log" code (see
@@ -218,7 +200,6 @@ config BRIDGE_EBT_ULOG
 
 config BRIDGE_EBT_NFLOG
 	tristate "ebt: nflog support"
-	depends on BRIDGE_NF_EBTABLES
 	help
 	  This option enables the nflog watcher, which allows to LOG
 	  messages through the netfilter logging API, which can use
@@ -232,4 +213,4 @@ config BRIDGE_EBT_NFLOG
 
 endif # NETFILTER_XTABLES
 
-endmenu
+endif # BRIDGE_NF_EBTABLES
