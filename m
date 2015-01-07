From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [ebtables-compat PATCH v2] ebtables-compat: incluyde
 /etc/ethertypes in tarball
Date: Wed, 07 Jan 2015 17:22:01 +0100
Message-ID: <20150107162111.30498.33295.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:57337 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752474AbbAGQWP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 7 Jan 2015 11:22:15 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The /etc/ethertypes file was originally distributed by the ebtables tarball.
So, let's include the file also in ebtables-compat, so users can keep using
protocol names instead of the hex code.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
v2: install /etc/ethertype file with `make install', as requested by Pablo.

 Makefile.am    |    5 +++++
 etc/ethertypes |   39 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 44 insertions(+)
 create mode 100644 etc/ethertypes

diff --git a/Makefile.am b/Makefile.am
index 275ebc3..044f646 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -16,6 +16,11 @@ SUBDIRS         += extensions
 # Depends on extensions/libext.a:
 SUBDIRS         += iptables
 
+if ENABLE_NFTABLES
+confdir		= $(sysconfdir)
+dist_conf_DATA	= etc/ethertypes
+endif
+
 .PHONY: tarball
 tarball:
 	rm -Rf /tmp/${PACKAGE_TARNAME}-${PACKAGE_VERSION};
diff --git a/etc/ethertypes b/etc/ethertypes
new file mode 100644
index 0000000..813177b
--- /dev/null
+++ b/etc/ethertypes
@@ -0,0 +1,39 @@
+#
+# Ethernet frame types
+#		This file describes some of the various Ethernet
+#		protocol types that are used on Ethernet networks.
+#
+# This list could be found on:
+#         http://www.iana.org/assignments/ethernet-numbers
+#         http://www.iana.org/assignments/ieee-802-numbers
+#
+# <name>    <hexnumber> <alias1>...<alias35> #Comment
+#
+IPv4	 	0800  	ip ip4 		# Internet IP (IPv4)
+X25		0805
+ARP		0806	ether-arp	#
+FR_ARP		0808    		# Frame Relay ARP        [RFC1701]
+BPQ		08FF			# G8BPQ AX.25 Ethernet Packet
+DEC		6000			# DEC Assigned proto
+DNA_DL		6001			# DEC DNA Dump/Load
+DNA_RC		6002			# DEC DNA Remote Console
+DNA_RT		6003			# DEC DNA Routing
+LAT		6004			# DEC LAT
+DIAG		6005			# DEC Diagnostics
+CUST		6006			# DEC Customer use
+SCA		6007			# DEC Systems Comms Arch
+TEB		6558			# Trans Ether Bridging   [RFC1701]
+RAW_FR  	6559			# Raw Frame Relay        [RFC1701]
+RARP		8035			# Reverse ARP            [RFC903]
+AARP		80F3			# Appletalk AARP
+ATALK		809B			# Appletalk
+802_1Q		8100	8021q 1q 802.1q	dot1q # 802.1Q Virtual LAN tagged frame
+IPX		8137			# Novell IPX
+NetBEUI		8191			# NetBEUI
+IPv6		86DD	ip6 		# IP version 6
+PPP		880B			# PPP
+ATMMPOA		884C			# MultiProtocol over ATM
+PPP_DISC	8863			# PPPoE discovery messages
+PPP_SES		8864			# PPPoE session messages
+ATMFATE		8884			# Frame-based ATM Transport over Ethernet
+LOOP		9000	loopback 	# loop proto

