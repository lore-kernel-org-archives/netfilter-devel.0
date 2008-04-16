From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [PATCH 12/13] [NETFILTER]: Make BRIDGE_NF_EBTABLES a menuconfig option
Date: Wed, 16 Apr 2008 17:31:04 +0200
Message-ID: <d03d759fd3c0c0cc5c10dbea42aba1265344a6de.1208359825.git.jengelh@computergmbh.de>
References: <1208359865-3022-1-git-send-email-jengelh@computergmbh.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:38093 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763709AbYDPPbJ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 16 Apr 2008 11:31:09 -0400
In-Reply-To: <1208359865-3022-1-git-send-email-jengelh@computergmbh.de>
In-Reply-To: <540dfb29c6c573830cbde9bf579ddef33657ed20.1208359825.git.jengelh@computergmbh.de>
References: <540dfb29c6c573830cbde9bf579ddef33657ed20.1208359825.git.jengelh@computergmbh.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
---
 net/bridge/netfilter/Kconfig |   29 +++++------------------------
 1 files changed, 5 insertions(+), 24 deletions(-)

diff --git a/net/bridge/netfilter/Kconfig b/net/bridge/netfilter/Kconfig
index 117c1be..3c7fd31 100644
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
@@ -89,7 +82,6 @@ config BRIDGE_EBT_IP
 
 config BRIDGE_EBT_LIMIT
 	tristate "ebt: limit match support"
-	depends on BRIDGE_NF_EBTABLES
 	help
 	  This option adds the limit match, which allows you to control
 	  the rate at which a rule can be matched. This match is the
@@ -100,7 +92,6 @@ config BRIDGE_EBT_LIMIT
 
 config BRIDGE_EBT_MARK
 	tristate "ebt: mark filter support"
-	depends on BRIDGE_NF_EBTABLES
 	help
 	  This option adds the mark match, which allows matching frames based on
 	  the 'nfmark' value in the frame. This can be set by the mark target.
@@ -111,7 +102,6 @@ config BRIDGE_EBT_MARK
 
 config BRIDGE_EBT_PKTTYPE
 	tristate "ebt: packet type filter support"
-	depends on BRIDGE_NF_EBTABLES
 	help
 	  This option adds the packet type match, which allows matching on the
 	  type of packet based on its Ethernet "class" (as determined by
@@ -122,7 +112,6 @@ config BRIDGE_EBT_PKTTYPE
 
 config BRIDGE_EBT_STP
 	tristate "ebt: STP filter support"
-	depends on BRIDGE_NF_EBTABLES
 	help
 	  This option adds the Spanning Tree Protocol match, which
 	  allows STP header field filtering.
@@ -131,7 +120,6 @@ config BRIDGE_EBT_STP
 
 config BRIDGE_EBT_VLAN
 	tristate "ebt: 802.1Q VLAN filter support"
-	depends on BRIDGE_NF_EBTABLES
 	help
 	  This option adds the 802.1Q vlan match, which allows the filtering of
 	  802.1Q vlan fields.
@@ -142,7 +130,6 @@ config BRIDGE_EBT_VLAN
 #
 config BRIDGE_EBT_DNAT
 	tristate "ebt: dnat target support"
-	depends on BRIDGE_NF_EBTABLES
 	help
 	  This option adds the MAC DNAT target, which allows altering the MAC
 	  destination address of frames.
@@ -151,7 +138,6 @@ config BRIDGE_EBT_DNAT
 
 config BRIDGE_EBT_MARK_T
 	tristate "ebt: mark target support"
-	depends on BRIDGE_NF_EBTABLES
 	help
 	  This option adds the mark target, which allows marking frames by
 	  setting the 'nfmark' value in the frame.
@@ -162,7 +148,6 @@ config BRIDGE_EBT_MARK_T
 
 config BRIDGE_EBT_REDIRECT
 	tristate "ebt: redirect target support"
-	depends on BRIDGE_NF_EBTABLES
 	help
 	  This option adds the MAC redirect target, which allows altering the MAC
 	  destination address of a frame to that of the device it arrived on.
@@ -171,7 +156,6 @@ config BRIDGE_EBT_REDIRECT
 
 config BRIDGE_EBT_SNAT
 	tristate "ebt: snat target support"
-	depends on BRIDGE_NF_EBTABLES
 	help
 	  This option adds the MAC SNAT target, which allows altering the MAC
 	  source address of frames.
@@ -182,7 +166,6 @@ config BRIDGE_EBT_SNAT
 #
 config BRIDGE_EBT_LOG
 	tristate "ebt: log support"
-	depends on BRIDGE_NF_EBTABLES
 	help
 	  This option adds the log watcher, that you can use in any rule
 	  in any ebtables table. It records info about the frame header
@@ -192,7 +175,6 @@ config BRIDGE_EBT_LOG
 
 config BRIDGE_EBT_ULOG
 	tristate "ebt: ulog support (OBSOLETE)"
-	depends on BRIDGE_NF_EBTABLES
 	help
 	  This option enables the old bridge-specific "ebt_ulog" implementation
 	  which has been obsoleted by the new "nfnetlink_log" code (see
@@ -209,7 +191,6 @@ config BRIDGE_EBT_ULOG
 
 config BRIDGE_EBT_NFLOG
 	tristate "ebt: nflog support"
-	depends on BRIDGE_NF_EBTABLES
 	help
 	  This option enables the nflog watcher, which allows to LOG
 	  messages through the netfilter logging API, which can use
@@ -223,4 +204,4 @@ config BRIDGE_EBT_NFLOG
 
 endif # NETFILTER_XTABLES
 
-endmenu
+endif # BRIDGE_NF_EBTABLES
-- 
1.5.5

