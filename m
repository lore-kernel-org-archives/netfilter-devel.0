From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 13/23] netfilter: xtables: use "if" blocks in Kconfig
Date: Mon,  6 Oct 2008 08:15:16 -0400
Message-ID: <b567654be00394eae62515d3c2efe77eee54add5.1223294924.git.jengelh@medozas.de>
References: <1223295326-10890-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:57110 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753004AbYJFMPc (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 6 Oct 2008 08:15:32 -0400
In-Reply-To: <1223295326-10890-1-git-send-email-jengelh@medozas.de>
In-Reply-To: <0a71cdb22ae4ae9ad9c49cab82cc41ccdd5653a1.1223294924.git.jengelh@medozas.de>
References: <0a71cdb22ae4ae9ad9c49cab82cc41ccdd5653a1.1223294924.git.jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 net/ipv4/netfilter/Kconfig |   36 ++++++++----------
 net/ipv6/netfilter/Kconfig |   17 ++-------
 net/netfilter/Kconfig      |   84 +++++++++++---------------------------------
 3 files changed, 41 insertions(+), 96 deletions(-)

diff --git a/net/ipv4/netfilter/Kconfig b/net/ipv4/netfilter/Kconfig
index 087b829..3816e1d 100644
--- a/net/ipv4/netfilter/Kconfig
+++ b/net/ipv4/netfilter/Kconfig
@@ -61,10 +61,11 @@ config IP_NF_IPTABLES
 
 	  To compile it as a module, choose M here.  If unsure, say N.
 
+if IP_NF_IPTABLES
+
 # The matches.
 config IP_NF_MATCH_ADDRTYPE
 	tristate '"addrtype" address type match support'
-	depends on IP_NF_IPTABLES
 	depends on NETFILTER_ADVANCED
 	help
 	  This option allows you to match what routing thinks of an address,
@@ -75,7 +76,6 @@ config IP_NF_MATCH_ADDRTYPE
 
 config IP_NF_MATCH_AH
 	tristate '"ah" match support'
-	depends on IP_NF_IPTABLES
 	depends on NETFILTER_ADVANCED
 	help
 	  This match extension allows you to match a range of SPIs
@@ -85,7 +85,6 @@ config IP_NF_MATCH_AH
 
 config IP_NF_MATCH_ECN
 	tristate '"ecn" match support'
-	depends on IP_NF_IPTABLES
 	depends on NETFILTER_ADVANCED
 	help
 	  This option adds a `ECN' match, which allows you to match against
@@ -95,7 +94,6 @@ config IP_NF_MATCH_ECN
 
 config IP_NF_MATCH_TTL
 	tristate '"ttl" match support'
-	depends on IP_NF_IPTABLES
 	depends on NETFILTER_ADVANCED
 	help
 	  This adds CONFIG_IP_NF_MATCH_TTL option, which enabled the user
@@ -106,7 +104,6 @@ config IP_NF_MATCH_TTL
 # `filter', generic and specific targets
 config IP_NF_FILTER
 	tristate "Packet filtering"
-	depends on IP_NF_IPTABLES
 	default m if NETFILTER_ADVANCED=n
 	help
 	  Packet filtering defines a table `filter', which has a series of
@@ -128,7 +125,6 @@ config IP_NF_TARGET_REJECT
 
 config IP_NF_TARGET_LOG
 	tristate "LOG target support"
-	depends on IP_NF_IPTABLES
 	default m if NETFILTER_ADVANCED=n
 	help
 	  This option adds a `LOG' target, which allows you to create rules in
@@ -138,7 +134,6 @@ config IP_NF_TARGET_LOG
 
 config IP_NF_TARGET_ULOG
 	tristate "ULOG target support"
-	depends on IP_NF_IPTABLES
 	default m if NETFILTER_ADVANCED=n
 	---help---
 
@@ -159,7 +154,7 @@ config IP_NF_TARGET_ULOG
 # NAT + specific targets: nf_conntrack
 config NF_NAT
 	tristate "Full NAT"
-	depends on IP_NF_IPTABLES && NF_CONNTRACK_IPV4
+	depends on NF_CONNTRACK_IPV4
 	default m if NETFILTER_ADVANCED=n
 	help
 	  The Full NAT option allows masquerading, port forwarding and other
@@ -254,44 +249,43 @@ config NF_NAT_PROTO_SCTP
 
 config NF_NAT_FTP
 	tristate
-	depends on IP_NF_IPTABLES && NF_CONNTRACK && NF_NAT
+	depends on NF_CONNTRACK && NF_NAT
 	default NF_NAT && NF_CONNTRACK_FTP
 
 config NF_NAT_IRC
 	tristate
-	depends on IP_NF_IPTABLES && NF_CONNTRACK && NF_NAT
+	depends on NF_CONNTRACK && NF_NAT
 	default NF_NAT && NF_CONNTRACK_IRC
 
 config NF_NAT_TFTP
 	tristate
-	depends on IP_NF_IPTABLES && NF_CONNTRACK && NF_NAT
+	depends on NF_CONNTRACK && NF_NAT
 	default NF_NAT && NF_CONNTRACK_TFTP
 
 config NF_NAT_AMANDA
 	tristate
-	depends on IP_NF_IPTABLES && NF_CONNTRACK && NF_NAT
+	depends on NF_CONNTRACK && NF_NAT
 	default NF_NAT && NF_CONNTRACK_AMANDA
 
 config NF_NAT_PPTP
 	tristate
-	depends on IP_NF_IPTABLES && NF_CONNTRACK && NF_NAT
+	depends on NF_CONNTRACK && NF_NAT
 	default NF_NAT && NF_CONNTRACK_PPTP
 	select NF_NAT_PROTO_GRE
 
 config NF_NAT_H323
 	tristate
-	depends on IP_NF_IPTABLES && NF_CONNTRACK && NF_NAT
+	depends on NF_CONNTRACK && NF_NAT
 	default NF_NAT && NF_CONNTRACK_H323
 
 config NF_NAT_SIP
 	tristate
-	depends on IP_NF_IPTABLES && NF_CONNTRACK && NF_NAT
+	depends on NF_CONNTRACK && NF_NAT
 	default NF_NAT && NF_CONNTRACK_SIP
 
 # mangle + specific targets
 config IP_NF_MANGLE
 	tristate "Packet mangling"
-	depends on IP_NF_IPTABLES
 	default m if NETFILTER_ADVANCED=n
 	help
 	  This option adds a `mangle' table to iptables: see the man page for
@@ -346,7 +340,6 @@ config IP_NF_TARGET_TTL
 # raw + specific targets
 config IP_NF_RAW
 	tristate  'raw table support (required for NOTRACK/TRACE)'
-	depends on IP_NF_IPTABLES
 	depends on NETFILTER_ADVANCED
 	help
 	  This option adds a `raw' table to iptables. This table is the very
@@ -359,7 +352,6 @@ config IP_NF_RAW
 # security table for MAC policy
 config IP_NF_SECURITY
 	tristate "Security table"
-	depends on IP_NF_IPTABLES
 	depends on SECURITY
 	depends on NETFILTER_ADVANCED
 	help
@@ -368,6 +360,8 @@ config IP_NF_SECURITY
 	 
 	  If unsure, say N.
 
+endif # IP_NF_IPTABLES
+
 # ARP tables
 config IP_NF_ARPTABLES
 	tristate "ARP tables support"
@@ -380,9 +374,10 @@ config IP_NF_ARPTABLES
 
 	  To compile it as a module, choose M here.  If unsure, say N.
 
+if IP_NF_ARPTABLES
+
 config IP_NF_ARPFILTER
 	tristate "ARP packet filtering"
-	depends on IP_NF_ARPTABLES
 	help
 	  ARP packet filtering defines a table `filter', which has a series of
 	  rules for simple ARP packet filtering at local input and
@@ -393,10 +388,11 @@ config IP_NF_ARPFILTER
 
 config IP_NF_ARP_MANGLE
 	tristate "ARP payload mangling"
-	depends on IP_NF_ARPTABLES
 	help
 	  Allows altering the ARP packet payload: source and destination
 	  hardware and network addresses.
 
+endif # IP_NF_ARPTABLES
+
 endmenu
 
diff --git a/net/ipv6/netfilter/Kconfig b/net/ipv6/netfilter/Kconfig
index 91ffba0..53ea512 100644
--- a/net/ipv6/netfilter/Kconfig
+++ b/net/ipv6/netfilter/Kconfig
@@ -55,10 +55,11 @@ config IP6_NF_IPTABLES
 
 	  To compile it as a module, choose M here.  If unsure, say N.
 
+if IP6_NF_IPTABLES
+
 # The simple matches.
 config IP6_NF_MATCH_AH
 	tristate '"ah" match support'
-	depends on IP6_NF_IPTABLES
 	depends on NETFILTER_ADVANCED
 	help
 	  This module allows one to match AH packets.
@@ -67,7 +68,6 @@ config IP6_NF_MATCH_AH
 
 config IP6_NF_MATCH_EUI64
 	tristate '"eui64" address check'
-	depends on IP6_NF_IPTABLES
 	depends on NETFILTER_ADVANCED
 	help
 	  This module performs checking on the IPv6 source address
@@ -78,7 +78,6 @@ config IP6_NF_MATCH_EUI64
 
 config IP6_NF_MATCH_FRAG
 	tristate '"frag" Fragmentation header match support'
-	depends on IP6_NF_IPTABLES
 	depends on NETFILTER_ADVANCED
 	help
 	  frag matching allows you to match packets based on the fragmentation
@@ -88,7 +87,6 @@ config IP6_NF_MATCH_FRAG
 
 config IP6_NF_MATCH_OPTS
 	tristate '"hbh" hop-by-hop and "dst" opts header match support'
-	depends on IP6_NF_IPTABLES
 	depends on NETFILTER_ADVANCED
 	help
 	  This allows one to match packets based on the hop-by-hop
@@ -98,7 +96,6 @@ config IP6_NF_MATCH_OPTS
 
 config IP6_NF_MATCH_HL
 	tristate '"hl" match support'
-	depends on IP6_NF_IPTABLES
 	depends on NETFILTER_ADVANCED
 	help
 	  HL matching allows you to match packets based on the hop
@@ -108,7 +105,6 @@ config IP6_NF_MATCH_HL
 
 config IP6_NF_MATCH_IPV6HEADER
 	tristate '"ipv6header" IPv6 Extension Headers Match'
-	depends on IP6_NF_IPTABLES
 	default m if NETFILTER_ADVANCED=n
 	help
 	  This module allows one to match packets based upon
@@ -118,7 +114,6 @@ config IP6_NF_MATCH_IPV6HEADER
 
 config IP6_NF_MATCH_MH
 	tristate '"mh" match support'
-	depends on IP6_NF_IPTABLES
 	depends on NETFILTER_ADVANCED
 	help
 	  This module allows one to match MH packets.
@@ -127,7 +122,6 @@ config IP6_NF_MATCH_MH
 
 config IP6_NF_MATCH_RT
 	tristate '"rt" Routing header match support'
-	depends on IP6_NF_IPTABLES
 	depends on NETFILTER_ADVANCED
 	help
 	  rt matching allows you to match packets based on the routing
@@ -138,7 +132,6 @@ config IP6_NF_MATCH_RT
 # The targets
 config IP6_NF_TARGET_LOG
 	tristate "LOG target support"
-	depends on IP6_NF_IPTABLES
 	default m if NETFILTER_ADVANCED=n
 	help
 	  This option adds a `LOG' target, which allows you to create rules in
@@ -148,7 +141,6 @@ config IP6_NF_TARGET_LOG
 
 config IP6_NF_FILTER
 	tristate "Packet filtering"
-	depends on IP6_NF_IPTABLES
 	default m if NETFILTER_ADVANCED=n
 	help
 	  Packet filtering defines a table `filter', which has a series of
@@ -170,7 +162,6 @@ config IP6_NF_TARGET_REJECT
 
 config IP6_NF_MANGLE
 	tristate "Packet mangling"
-	depends on IP6_NF_IPTABLES
 	default m if NETFILTER_ADVANCED=n
 	help
 	  This option adds a `mangle' table to iptables: see the man page for
@@ -198,7 +189,6 @@ config IP6_NF_TARGET_HL
 
 config IP6_NF_RAW
 	tristate  'raw table support (required for TRACE)'
-	depends on IP6_NF_IPTABLES
 	depends on NETFILTER_ADVANCED
 	help
 	  This option adds a `raw' table to ip6tables. This table is the very
@@ -211,7 +201,6 @@ config IP6_NF_RAW
 # security table for MAC policy
 config IP6_NF_SECURITY
        tristate "Security table"
-       depends on IP6_NF_IPTABLES
        depends on SECURITY
        depends on NETFILTER_ADVANCED
        help
@@ -220,5 +209,7 @@ config IP6_NF_SECURITY
         
          If unsure, say N.
 
+endif # IP6_NF_IPTABLES
+
 endmenu
 
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 9ad74e8..899e780 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -38,10 +38,11 @@ config NF_CONNTRACK
 
 	  To compile it as a module, choose M here.  If unsure, say N.
 
+if NF_CONNTRACK
+
 config NF_CT_ACCT
 	bool "Connection tracking flow accounting"
 	depends on NETFILTER_ADVANCED
-	depends on NF_CONNTRACK
 	help
 	  If this option is enabled, the connection tracking code will
 	  keep per-flow packet and byte counters.
@@ -63,7 +64,6 @@ config NF_CT_ACCT
 config NF_CONNTRACK_MARK
 	bool  'Connection mark tracking support'
 	depends on NETFILTER_ADVANCED
-	depends on NF_CONNTRACK
 	help
 	  This option enables support for connection marks, used by the
 	  `CONNMARK' target and `connmark' match. Similar to the mark value
@@ -72,7 +72,7 @@ config NF_CONNTRACK_MARK
 
 config NF_CONNTRACK_SECMARK
 	bool  'Connection tracking security mark support'
-	depends on NF_CONNTRACK && NETWORK_SECMARK
+	depends on NETWORK_SECMARK
 	default m if NETFILTER_ADVANCED=n
 	help
 	  This option enables security markings to be applied to
@@ -85,7 +85,6 @@ config NF_CONNTRACK_SECMARK
 
 config NF_CONNTRACK_EVENTS
 	bool "Connection tracking events"
-	depends on NF_CONNTRACK
 	depends on NETFILTER_ADVANCED
 	help
 	  If this option is enabled, the connection tracking code will
@@ -96,7 +95,7 @@ config NF_CONNTRACK_EVENTS
 
 config NF_CT_PROTO_DCCP
 	tristate 'DCCP protocol connection tracking support (EXPERIMENTAL)'
-	depends on EXPERIMENTAL && NF_CONNTRACK
+	depends on EXPERIMENTAL
 	depends on NETFILTER_ADVANCED
 	default IP_DCCP
 	help
@@ -107,11 +106,10 @@ config NF_CT_PROTO_DCCP
 
 config NF_CT_PROTO_GRE
 	tristate
-	depends on NF_CONNTRACK
 
 config NF_CT_PROTO_SCTP
 	tristate 'SCTP protocol connection tracking support (EXPERIMENTAL)'
-	depends on EXPERIMENTAL && NF_CONNTRACK
+	depends on EXPERIMENTAL
 	depends on NETFILTER_ADVANCED
 	default IP_SCTP
 	help
@@ -123,7 +121,6 @@ config NF_CT_PROTO_SCTP
 
 config NF_CT_PROTO_UDPLITE
 	tristate 'UDP-Lite protocol connection tracking support'
-	depends on NF_CONNTRACK
 	depends on NETFILTER_ADVANCED
 	help
 	  With this option enabled, the layer 3 independent connection
@@ -134,7 +131,6 @@ config NF_CT_PROTO_UDPLITE
 
 config NF_CONNTRACK_AMANDA
 	tristate "Amanda backup protocol support"
-	depends on NF_CONNTRACK
 	depends on NETFILTER_ADVANCED
 	select TEXTSEARCH
 	select TEXTSEARCH_KMP
@@ -150,7 +146,6 @@ config NF_CONNTRACK_AMANDA
 
 config NF_CONNTRACK_FTP
 	tristate "FTP protocol support"
-	depends on NF_CONNTRACK
 	default m if NETFILTER_ADVANCED=n
 	help
 	  Tracking FTP connections is problematic: special helpers are
@@ -165,7 +160,7 @@ config NF_CONNTRACK_FTP
 
 config NF_CONNTRACK_H323
 	tristate "H.323 protocol support"
-	depends on NF_CONNTRACK && (IPV6 || IPV6=n)
+	depends on (IPV6 || IPV6=n)
 	depends on NETFILTER_ADVANCED
 	help
 	  H.323 is a VoIP signalling protocol from ITU-T. As one of the most
@@ -185,7 +180,6 @@ config NF_CONNTRACK_H323
 
 config NF_CONNTRACK_IRC
 	tristate "IRC protocol support"
-	depends on NF_CONNTRACK
 	default m if NETFILTER_ADVANCED=n
 	help
 	  There is a commonly-used extension to IRC called
@@ -201,7 +195,6 @@ config NF_CONNTRACK_IRC
 
 config NF_CONNTRACK_NETBIOS_NS
 	tristate "NetBIOS name service protocol support"
-	depends on NF_CONNTRACK
 	depends on NETFILTER_ADVANCED
 	help
 	  NetBIOS name service requests are sent as broadcast messages from an
@@ -221,7 +214,6 @@ config NF_CONNTRACK_NETBIOS_NS
 
 config NF_CONNTRACK_PPTP
 	tristate "PPtP protocol support"
-	depends on NF_CONNTRACK
 	depends on NETFILTER_ADVANCED
 	select NF_CT_PROTO_GRE
 	help
@@ -241,7 +233,7 @@ config NF_CONNTRACK_PPTP
 
 config NF_CONNTRACK_SANE
 	tristate "SANE protocol support (EXPERIMENTAL)"
-	depends on EXPERIMENTAL && NF_CONNTRACK
+	depends on EXPERIMENTAL
 	depends on NETFILTER_ADVANCED
 	help
 	  SANE is a protocol for remote access to scanners as implemented
@@ -255,7 +247,6 @@ config NF_CONNTRACK_SANE
 
 config NF_CONNTRACK_SIP
 	tristate "SIP protocol support"
-	depends on NF_CONNTRACK
 	default m if NETFILTER_ADVANCED=n
 	help
 	  SIP is an application-layer control protocol that can establish,
@@ -268,7 +259,6 @@ config NF_CONNTRACK_SIP
 
 config NF_CONNTRACK_TFTP
 	tristate "TFTP protocol support"
-	depends on NF_CONNTRACK
 	depends on NETFILTER_ADVANCED
 	help
 	  TFTP connection tracking helper, this is required depending
@@ -280,7 +270,6 @@ config NF_CONNTRACK_TFTP
 
 config NF_CT_NETLINK
 	tristate 'Connection tracking netlink interface'
-	depends on NF_CONNTRACK
 	select NETFILTER_NETLINK
 	depends on NF_NAT=n || NF_NAT
 	default m if NETFILTER_ADVANCED=n
@@ -302,6 +291,8 @@ config NETFILTER_TPROXY
 
 	  To compile it as a module, choose M here.  If unsure, say N.
 
+endif # NF_CONNTRACK
+
 config NETFILTER_XTABLES
 	tristate "Netfilter Xtables support (required for ip_tables)"
 	default m if NETFILTER_ADVANCED=n
@@ -309,11 +300,12 @@ config NETFILTER_XTABLES
 	  This is required if you intend to use any of ip_tables,
 	  ip6_tables or arp_tables.
 
+if NETFILTER_XTABLES
+
 # alphabetically ordered list of targets
 
 config NETFILTER_XT_TARGET_CLASSIFY
 	tristate '"CLASSIFY" target support'
-	depends on NETFILTER_XTABLES
 	depends on NETFILTER_ADVANCED
 	help
 	  This option adds a `CLASSIFY' target, which enables the user to set
@@ -326,7 +318,6 @@ config NETFILTER_XT_TARGET_CLASSIFY
 
 config NETFILTER_XT_TARGET_CONNMARK
 	tristate  '"CONNMARK" target support'
-	depends on NETFILTER_XTABLES
 	depends on IP_NF_MANGLE || IP6_NF_MANGLE
 	depends on NF_CONNTRACK
 	depends on NETFILTER_ADVANCED
@@ -342,7 +333,7 @@ config NETFILTER_XT_TARGET_CONNMARK
 
 config NETFILTER_XT_TARGET_CONNSECMARK
 	tristate '"CONNSECMARK" target support'
-	depends on NETFILTER_XTABLES && NF_CONNTRACK && NF_CONNTRACK_SECMARK
+	depends on NF_CONNTRACK && NF_CONNTRACK_SECMARK
 	default m if NETFILTER_ADVANCED=n
 	help
 	  The CONNSECMARK target copies security markings from packets
@@ -354,7 +345,6 @@ config NETFILTER_XT_TARGET_CONNSECMARK
 
 config NETFILTER_XT_TARGET_DSCP
 	tristate '"DSCP" and "TOS" target support'
-	depends on NETFILTER_XTABLES
 	depends on IP_NF_MANGLE || IP6_NF_MANGLE
 	depends on NETFILTER_ADVANCED
 	help
@@ -371,7 +361,6 @@ config NETFILTER_XT_TARGET_DSCP
 
 config NETFILTER_XT_TARGET_MARK
 	tristate '"MARK" target support'
-	depends on NETFILTER_XTABLES
 	default m if NETFILTER_ADVANCED=n
 	help
 	  This option adds a `MARK' target, which allows you to create rules
@@ -385,7 +374,6 @@ config NETFILTER_XT_TARGET_MARK
 
 config NETFILTER_XT_TARGET_NFLOG
 	tristate '"NFLOG" target support'
-	depends on NETFILTER_XTABLES
 	default m if NETFILTER_ADVANCED=n
 	help
 	  This option enables the NFLOG target, which allows to LOG
@@ -397,7 +385,6 @@ config NETFILTER_XT_TARGET_NFLOG
 
 config NETFILTER_XT_TARGET_NFQUEUE
 	tristate '"NFQUEUE" target Support'
-	depends on NETFILTER_XTABLES
 	depends on NETFILTER_ADVANCED
 	help
 	  This target replaced the old obsolete QUEUE target.
@@ -409,7 +396,6 @@ config NETFILTER_XT_TARGET_NFQUEUE
 
 config NETFILTER_XT_TARGET_NOTRACK
 	tristate  '"NOTRACK" target support'
-	depends on NETFILTER_XTABLES
 	depends on IP_NF_RAW || IP6_NF_RAW
 	depends on NF_CONNTRACK
 	depends on NETFILTER_ADVANCED
@@ -424,7 +410,6 @@ config NETFILTER_XT_TARGET_NOTRACK
 
 config NETFILTER_XT_TARGET_RATEEST
 	tristate '"RATEEST" target support'
-	depends on NETFILTER_XTABLES
 	depends on NETFILTER_ADVANCED
 	help
 	  This option adds a `RATEEST' target, which allows to measure
@@ -450,7 +435,6 @@ config NETFILTER_XT_TARGET_TPROXY
 
 config NETFILTER_XT_TARGET_TRACE
 	tristate  '"TRACE" target support'
-	depends on NETFILTER_XTABLES
 	depends on IP_NF_RAW || IP6_NF_RAW
 	depends on NETFILTER_ADVANCED
 	help
@@ -463,7 +447,7 @@ config NETFILTER_XT_TARGET_TRACE
 
 config NETFILTER_XT_TARGET_SECMARK
 	tristate '"SECMARK" target support'
-	depends on NETFILTER_XTABLES && NETWORK_SECMARK
+	depends on NETWORK_SECMARK
 	default m if NETFILTER_ADVANCED=n
 	help
 	  The SECMARK target allows security marking of network
@@ -473,7 +457,7 @@ config NETFILTER_XT_TARGET_SECMARK
 
 config NETFILTER_XT_TARGET_TCPMSS
 	tristate '"TCPMSS" target support'
-	depends on NETFILTER_XTABLES && (IPV6 || IPV6=n)
+	depends on (IPV6 || IPV6=n)
 	default m if NETFILTER_ADVANCED=n
 	---help---
 	  This option adds a `TCPMSS' target, which allows you to alter the
@@ -500,7 +484,7 @@ config NETFILTER_XT_TARGET_TCPMSS
 
 config NETFILTER_XT_TARGET_TCPOPTSTRIP
 	tristate '"TCPOPTSTRIP" target support (EXPERIMENTAL)'
-	depends on EXPERIMENTAL && NETFILTER_XTABLES
+	depends on EXPERIMENTAL
 	depends on IP_NF_MANGLE || IP6_NF_MANGLE
 	depends on NETFILTER_ADVANCED
 	help
@@ -509,7 +493,6 @@ config NETFILTER_XT_TARGET_TCPOPTSTRIP
 
 config NETFILTER_XT_MATCH_COMMENT
 	tristate  '"comment" match support'
-	depends on NETFILTER_XTABLES
 	depends on NETFILTER_ADVANCED
 	help
 	  This option adds a `comment' dummy-match, which allows you to put
@@ -520,7 +503,6 @@ config NETFILTER_XT_MATCH_COMMENT
 
 config NETFILTER_XT_MATCH_CONNBYTES
 	tristate  '"connbytes" per-connection counter match support'
-	depends on NETFILTER_XTABLES
 	depends on NF_CONNTRACK
 	depends on NETFILTER_ADVANCED
 	select NF_CT_ACCT
@@ -533,7 +515,6 @@ config NETFILTER_XT_MATCH_CONNBYTES
 
 config NETFILTER_XT_MATCH_CONNLIMIT
 	tristate '"connlimit" match support"'
-	depends on NETFILTER_XTABLES
 	depends on NF_CONNTRACK
 	depends on NETFILTER_ADVANCED
 	---help---
@@ -542,7 +523,6 @@ config NETFILTER_XT_MATCH_CONNLIMIT
 
 config NETFILTER_XT_MATCH_CONNMARK
 	tristate  '"connmark" connection mark match support'
-	depends on NETFILTER_XTABLES
 	depends on NF_CONNTRACK
 	depends on NETFILTER_ADVANCED
 	select NF_CONNTRACK_MARK
@@ -556,7 +536,6 @@ config NETFILTER_XT_MATCH_CONNMARK
 
 config NETFILTER_XT_MATCH_CONNTRACK
 	tristate '"conntrack" connection tracking match support'
-	depends on NETFILTER_XTABLES
 	depends on NF_CONNTRACK
 	default m if NETFILTER_ADVANCED=n
 	help
@@ -570,7 +549,6 @@ config NETFILTER_XT_MATCH_CONNTRACK
 
 config NETFILTER_XT_MATCH_DCCP
 	tristate '"dccp" protocol match support'
-	depends on NETFILTER_XTABLES
 	depends on NETFILTER_ADVANCED
 	default IP_DCCP
 	help
@@ -583,7 +561,6 @@ config NETFILTER_XT_MATCH_DCCP
 
 config NETFILTER_XT_MATCH_DSCP
 	tristate '"dscp" and "tos" match support'
-	depends on NETFILTER_XTABLES
 	depends on NETFILTER_ADVANCED
 	help
 	  This option adds a `DSCP' match, which allows you to match against
@@ -599,7 +576,6 @@ config NETFILTER_XT_MATCH_DSCP
 
 config NETFILTER_XT_MATCH_ESP
 	tristate '"esp" match support'
-	depends on NETFILTER_XTABLES
 	depends on NETFILTER_ADVANCED
 	help
 	  This match extension allows you to match a range of SPIs
@@ -609,7 +585,7 @@ config NETFILTER_XT_MATCH_ESP
 
 config NETFILTER_XT_MATCH_HASHLIMIT
 	tristate '"hashlimit" match support'
-	depends on NETFILTER_XTABLES && (IP6_NF_IPTABLES || IP6_NF_IPTABLES=n)
+	depends on (IP6_NF_IPTABLES || IP6_NF_IPTABLES=n)
 	depends on NETFILTER_ADVANCED
 	help
 	  This option adds a `hashlimit' match.
@@ -624,7 +600,6 @@ config NETFILTER_XT_MATCH_HASHLIMIT
 
 config NETFILTER_XT_MATCH_HELPER
 	tristate '"helper" match support'
-	depends on NETFILTER_XTABLES
 	depends on NF_CONNTRACK
 	depends on NETFILTER_ADVANCED
 	help
@@ -635,7 +610,6 @@ config NETFILTER_XT_MATCH_HELPER
 
 config NETFILTER_XT_MATCH_IPRANGE
 	tristate '"iprange" address range match support'
-	depends on NETFILTER_XTABLES
 	depends on NETFILTER_ADVANCED
 	---help---
 	This option adds a "iprange" match, which allows you to match based on
@@ -646,7 +620,6 @@ config NETFILTER_XT_MATCH_IPRANGE
 
 config NETFILTER_XT_MATCH_LENGTH
 	tristate '"length" match support'
-	depends on NETFILTER_XTABLES
 	depends on NETFILTER_ADVANCED
 	help
 	  This option allows you to match the length of a packet against a
@@ -656,7 +629,6 @@ config NETFILTER_XT_MATCH_LENGTH
 
 config NETFILTER_XT_MATCH_LIMIT
 	tristate '"limit" match support'
-	depends on NETFILTER_XTABLES
 	depends on NETFILTER_ADVANCED
 	help
 	  limit matching allows you to control the rate at which a rule can be
@@ -667,7 +639,6 @@ config NETFILTER_XT_MATCH_LIMIT
 
 config NETFILTER_XT_MATCH_MAC
 	tristate '"mac" address match support'
-	depends on NETFILTER_XTABLES
 	depends on NETFILTER_ADVANCED
 	help
 	  MAC matching allows you to match packets based on the source
@@ -677,7 +648,6 @@ config NETFILTER_XT_MATCH_MAC
 
 config NETFILTER_XT_MATCH_MARK
 	tristate '"mark" match support'
-	depends on NETFILTER_XTABLES
 	default m if NETFILTER_ADVANCED=n
 	help
 	  Netfilter mark matching allows you to match packets based on the
@@ -688,7 +658,6 @@ config NETFILTER_XT_MATCH_MARK
 
 config NETFILTER_XT_MATCH_MULTIPORT
 	tristate '"multiport" Multiple port match support'
-	depends on NETFILTER_XTABLES
 	depends on NETFILTER_ADVANCED
 	help
 	  Multiport matching allows you to match TCP or UDP packets based on
@@ -699,7 +668,6 @@ config NETFILTER_XT_MATCH_MULTIPORT
 
 config NETFILTER_XT_MATCH_OWNER
 	tristate '"owner" match support'
-	depends on NETFILTER_XTABLES
 	depends on NETFILTER_ADVANCED
 	---help---
 	Socket owner matching allows you to match locally-generated packets
@@ -708,7 +676,7 @@ config NETFILTER_XT_MATCH_OWNER
 
 config NETFILTER_XT_MATCH_POLICY
 	tristate 'IPsec "policy" match support'
-	depends on NETFILTER_XTABLES && XFRM
+	depends on XFRM
 	default m if NETFILTER_ADVANCED=n
 	help
 	  Policy matching allows you to match packets based on the
@@ -719,7 +687,7 @@ config NETFILTER_XT_MATCH_POLICY
 
 config NETFILTER_XT_MATCH_PHYSDEV
 	tristate '"physdev" match support'
-	depends on NETFILTER_XTABLES && BRIDGE && BRIDGE_NETFILTER
+	depends on BRIDGE && BRIDGE_NETFILTER
 	depends on NETFILTER_ADVANCED
 	help
 	  Physdev packet matching matches against the physical bridge ports
@@ -729,7 +697,6 @@ config NETFILTER_XT_MATCH_PHYSDEV
 
 config NETFILTER_XT_MATCH_PKTTYPE
 	tristate '"pkttype" packet type match support'
-	depends on NETFILTER_XTABLES
 	depends on NETFILTER_ADVANCED
 	help
 	  Packet type matching allows you to match a packet by
@@ -742,7 +709,6 @@ config NETFILTER_XT_MATCH_PKTTYPE
 
 config NETFILTER_XT_MATCH_QUOTA
 	tristate '"quota" match support'
-	depends on NETFILTER_XTABLES
 	depends on NETFILTER_ADVANCED
 	help
 	  This option adds a `quota' match, which allows to match on a
@@ -753,7 +719,6 @@ config NETFILTER_XT_MATCH_QUOTA
 
 config NETFILTER_XT_MATCH_RATEEST
 	tristate '"rateest" match support'
-	depends on NETFILTER_XTABLES
 	depends on NETFILTER_ADVANCED
 	select NETFILTER_XT_TARGET_RATEEST
 	help
@@ -764,7 +729,6 @@ config NETFILTER_XT_MATCH_RATEEST
 
 config NETFILTER_XT_MATCH_REALM
 	tristate  '"realm" match support'
-	depends on NETFILTER_XTABLES
 	depends on NETFILTER_ADVANCED
 	select NET_CLS_ROUTE
 	help
@@ -779,7 +743,6 @@ config NETFILTER_XT_MATCH_REALM
 
 config NETFILTER_XT_MATCH_RECENT
 	tristate '"recent" match support'
-	depends on NETFILTER_XTABLES
 	depends on NETFILTER_ADVANCED
 	---help---
 	This match is used for creating one or many lists of recently
@@ -797,7 +760,7 @@ config NETFILTER_XT_MATCH_RECENT_PROC_COMPAT
 
 config NETFILTER_XT_MATCH_SCTP
 	tristate  '"sctp" protocol match support (EXPERIMENTAL)'
-	depends on NETFILTER_XTABLES && EXPERIMENTAL
+	depends on EXPERIMENTAL
 	depends on NETFILTER_ADVANCED
 	default IP_SCTP
 	help
@@ -825,7 +788,6 @@ config NETFILTER_XT_MATCH_SOCKET
 
 config NETFILTER_XT_MATCH_STATE
 	tristate '"state" match support'
-	depends on NETFILTER_XTABLES
 	depends on NF_CONNTRACK
 	default m if NETFILTER_ADVANCED=n
 	help
@@ -837,7 +799,6 @@ config NETFILTER_XT_MATCH_STATE
 
 config NETFILTER_XT_MATCH_STATISTIC
 	tristate '"statistic" match support'
-	depends on NETFILTER_XTABLES
 	depends on NETFILTER_ADVANCED
 	help
 	  This option adds a `statistic' match, which allows you to match
@@ -847,7 +808,6 @@ config NETFILTER_XT_MATCH_STATISTIC
 
 config NETFILTER_XT_MATCH_STRING
 	tristate  '"string" match support'
-	depends on NETFILTER_XTABLES
 	depends on NETFILTER_ADVANCED
 	select TEXTSEARCH
 	select TEXTSEARCH_KMP
@@ -861,7 +821,6 @@ config NETFILTER_XT_MATCH_STRING
 
 config NETFILTER_XT_MATCH_TCPMSS
 	tristate '"tcpmss" match support'
-	depends on NETFILTER_XTABLES
 	depends on NETFILTER_ADVANCED
 	help
 	  This option adds a `tcpmss' match, which allows you to examine the
@@ -872,7 +831,6 @@ config NETFILTER_XT_MATCH_TCPMSS
 
 config NETFILTER_XT_MATCH_TIME
 	tristate '"time" match support'
-	depends on NETFILTER_XTABLES
 	depends on NETFILTER_ADVANCED
 	---help---
 	  This option adds a "time" match, which allows you to match based on
@@ -887,7 +845,6 @@ config NETFILTER_XT_MATCH_TIME
 
 config NETFILTER_XT_MATCH_U32
 	tristate '"u32" match support'
-	depends on NETFILTER_XTABLES
 	depends on NETFILTER_ADVANCED
 	---help---
 	  u32 allows you to extract quantities of up to 4 bytes from a packet,
@@ -899,5 +856,6 @@ config NETFILTER_XT_MATCH_U32
 
 	  Details and examples are in the kernel module source.
 
-endmenu
+endif # NETFILTER_XTABLES
 
+endmenu
-- 
1.6.0.1

