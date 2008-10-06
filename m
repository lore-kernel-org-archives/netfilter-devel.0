From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 11/23] netfilter: ebtables: make BRIDGE_NF_EBTABLES a menuconfig option
Date: Mon,  6 Oct 2008 08:15:14 -0400
Message-ID: <473a8263f7870f36f0184b5c6a11b130730b1b00.1223294924.git.jengelh@medozas.de>
References: <1223295326-10890-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:57106 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752945AbYJFMPb (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 6 Oct 2008 08:15:31 -0400
In-Reply-To: <1223295326-10890-1-git-send-email-jengelh@medozas.de>
In-Reply-To: <0a71cdb22ae4ae9ad9c49cab82cc41ccdd5653a1.1223294924.git.jengelh@medozas.de>
References: <0a71cdb22ae4ae9ad9c49cab82cc41ccdd5653a1.1223294924.git.jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 net/bridge/netfilter/Kconfig |   29 +++++------------------------
 1 files changed, 5 insertions(+), 24 deletions(-)

diff --git a/net/bridge/netfilter/Kconfig b/net/bridge/netfilter/Kconfig
index e7c197f..366d3e9 100644
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
@@ -50,7 +47,6 @@ config BRIDGE_EBT_T_NAT
 #
 config BRIDGE_EBT_802_3
 	tristate "ebt: 802.3 filter support"
-	depends on BRIDGE_NF_EBTABLES
 	help
 	  This option adds matching support for 802.3 Ethernet frames.
 
@@ -58,7 +54,6 @@ config BRIDGE_EBT_802_3
 
 config BRIDGE_EBT_AMONG
 	tristate "ebt: among filter support"
-	depends on BRIDGE_NF_EBTABLES
 	help
 	  This option adds the among match, which allows matching the MAC source
 	  and/or destination address on a list of addresses. Optionally,
@@ -68,7 +63,6 @@ config BRIDGE_EBT_AMONG
 
 config BRIDGE_EBT_ARP
 	tristate "ebt: ARP filter support"
-	depends on BRIDGE_NF_EBTABLES
 	help
 	  This option adds the ARP match, which allows ARP and RARP header field
 	  filtering.
@@ -77,7 +71,6 @@ config BRIDGE_EBT_ARP
 
 config BRIDGE_EBT_IP
 	tristate "ebt: IP filter support"
-	depends on BRIDGE_NF_EBTABLES
 	help
 	  This option adds the IP match, which allows basic IP header field
 	  filtering.
@@ -95,7 +88,6 @@ config BRIDGE_EBT_IP6
 
 config BRIDGE_EBT_LIMIT
 	tristate "ebt: limit match support"
-	depends on BRIDGE_NF_EBTABLES
 	help
 	  This option adds the limit match, which allows you to control
 	  the rate at which a rule can be matched. This match is the
@@ -106,7 +98,6 @@ config BRIDGE_EBT_LIMIT
 
 config BRIDGE_EBT_MARK
 	tristate "ebt: mark filter support"
-	depends on BRIDGE_NF_EBTABLES
 	help
 	  This option adds the mark match, which allows matching frames based on
 	  the 'nfmark' value in the frame. This can be set by the mark target.
@@ -117,7 +108,6 @@ config BRIDGE_EBT_MARK
 
 config BRIDGE_EBT_PKTTYPE
 	tristate "ebt: packet type filter support"
-	depends on BRIDGE_NF_EBTABLES
 	help
 	  This option adds the packet type match, which allows matching on the
 	  type of packet based on its Ethernet "class" (as determined by
@@ -128,7 +118,6 @@ config BRIDGE_EBT_PKTTYPE
 
 config BRIDGE_EBT_STP
 	tristate "ebt: STP filter support"
-	depends on BRIDGE_NF_EBTABLES
 	help
 	  This option adds the Spanning Tree Protocol match, which
 	  allows STP header field filtering.
@@ -137,7 +126,6 @@ config BRIDGE_EBT_STP
 
 config BRIDGE_EBT_VLAN
 	tristate "ebt: 802.1Q VLAN filter support"
-	depends on BRIDGE_NF_EBTABLES
 	help
 	  This option adds the 802.1Q vlan match, which allows the filtering of
 	  802.1Q vlan fields.
@@ -157,7 +145,6 @@ config BRIDGE_EBT_ARPREPLY
 
 config BRIDGE_EBT_DNAT
 	tristate "ebt: dnat target support"
-	depends on BRIDGE_NF_EBTABLES
 	help
 	  This option adds the MAC DNAT target, which allows altering the MAC
 	  destination address of frames.
@@ -166,7 +153,6 @@ config BRIDGE_EBT_DNAT
 
 config BRIDGE_EBT_MARK_T
 	tristate "ebt: mark target support"
-	depends on BRIDGE_NF_EBTABLES
 	help
 	  This option adds the mark target, which allows marking frames by
 	  setting the 'nfmark' value in the frame.
@@ -177,7 +163,6 @@ config BRIDGE_EBT_MARK_T
 
 config BRIDGE_EBT_REDIRECT
 	tristate "ebt: redirect target support"
-	depends on BRIDGE_NF_EBTABLES
 	help
 	  This option adds the MAC redirect target, which allows altering the MAC
 	  destination address of a frame to that of the device it arrived on.
@@ -186,7 +171,6 @@ config BRIDGE_EBT_REDIRECT
 
 config BRIDGE_EBT_SNAT
 	tristate "ebt: snat target support"
-	depends on BRIDGE_NF_EBTABLES
 	help
 	  This option adds the MAC SNAT target, which allows altering the MAC
 	  source address of frames.
@@ -197,7 +181,6 @@ config BRIDGE_EBT_SNAT
 #
 config BRIDGE_EBT_LOG
 	tristate "ebt: log support"
-	depends on BRIDGE_NF_EBTABLES
 	help
 	  This option adds the log watcher, that you can use in any rule
 	  in any ebtables table. It records info about the frame header
@@ -207,7 +190,6 @@ config BRIDGE_EBT_LOG
 
 config BRIDGE_EBT_ULOG
 	tristate "ebt: ulog support (OBSOLETE)"
-	depends on BRIDGE_NF_EBTABLES
 	help
 	  This option enables the old bridge-specific "ebt_ulog" implementation
 	  which has been obsoleted by the new "nfnetlink_log" code (see
@@ -224,7 +206,6 @@ config BRIDGE_EBT_ULOG
 
 config BRIDGE_EBT_NFLOG
 	tristate "ebt: nflog support"
-	depends on BRIDGE_NF_EBTABLES
 	help
 	  This option enables the nflog watcher, which allows to LOG
 	  messages through the netfilter logging API, which can use
@@ -236,4 +217,4 @@ config BRIDGE_EBT_NFLOG
 
 	  To compile it as a module, choose M here.  If unsure, say N.
 
-endmenu
+endif # BRIDGE_NF_EBTABLES
-- 
1.6.0.1

