From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 64/64]: Add CONFIG_NETFILTER_ADVANCED option
Date: Tue, 18 Dec 2007 00:47:40 +0100 (MET)
Message-ID: <20071217234740.23601.17449.sendpatchset@localhost.localdomain>
References: <20071217234612.23601.6979.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:39081 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933345AbXLQXrm (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Dec 2007 18:47:42 -0500
In-Reply-To: <20071217234612.23601.6979.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: Add CONFIG_NETFILTER_ADVANCED option

The NETFILTER_ADVANCED option hides lots of the rather obscure netfilter
options when disabled and provides defaults (M) that should allow to
run a distribution firewall without further thinking.

Defaults to 'y' to avoid breaking current configurations.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit ed6a0634607e258ffba2af6dca7591867f429b17
tree 343aa772140fcc3bd9e2684589418a27e3bf2e70
parent e5dc0b8b87651227dc92fa1365ab3e9707f9898e
author Patrick McHardy <kaber@trash.net> Mon, 17 Dec 2007 14:58:59 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 18 Dec 2007 00:29:27 +0100

 net/Kconfig                  |   12 +++++++
 net/bridge/netfilter/Kconfig |    2 +
 net/decnet/netfilter/Kconfig |    1 +
 net/ipv4/netfilter/Kconfig   |   26 +++++++++++++++
 net/ipv6/netfilter/Kconfig   |   23 ++++++++++++--
 net/netfilter/Kconfig        |   71 ++++++++++++++++++++++++++++++++++++++----
 6 files changed, 124 insertions(+), 11 deletions(-)

diff --git a/net/Kconfig b/net/Kconfig
index 58ed2f4..b6a5d45 100644
--- a/net/Kconfig
+++ b/net/Kconfig
@@ -144,9 +144,21 @@ config NETFILTER_DEBUG
 	  You can say Y here if you want to get additional messages useful in
 	  debugging the netfilter code.
 
+config NETFILTER_ADVANCED
+	bool "Advanced netfilter configuration"
+	depends on NETFILTER
+	default y
+	help
+	  If you say Y here you can select between all the netfilter modules.
+	  If you say N the more ununsual ones will not be shown and the
+	  basic ones needed by most people will default to 'M'.
+
+	  If unsure, say Y.
+
 config BRIDGE_NETFILTER
 	bool "Bridged IP/ARP packets filtering"
 	depends on BRIDGE && NETFILTER && INET
+	depends on NETFILTER_ADVANCED
 	default y
 	---help---
 	  Enabling this option will let arptables resp. iptables see bridged
diff --git a/net/bridge/netfilter/Kconfig b/net/bridge/netfilter/Kconfig
index b84fc60..4a3e2bf 100644
--- a/net/bridge/netfilter/Kconfig
+++ b/net/bridge/netfilter/Kconfig
@@ -3,7 +3,7 @@
 #
 
 menu "Bridge: Netfilter Configuration"
-	depends on BRIDGE && NETFILTER
+	depends on BRIDGE && BRIDGE_NETFILTER
 
 config BRIDGE_NF_EBTABLES
 	tristate "Ethernet Bridge tables (ebtables) support"
diff --git a/net/decnet/netfilter/Kconfig b/net/decnet/netfilter/Kconfig
index ecdb3f9..2f81de5 100644
--- a/net/decnet/netfilter/Kconfig
+++ b/net/decnet/netfilter/Kconfig
@@ -4,6 +4,7 @@
 
 menu "DECnet: Netfilter Configuration"
 	depends on DECNET && NETFILTER && EXPERIMENTAL
+	depends on NETFILTER_ADVANCED
 
 config DECNET_NF_GRABULATOR
 	tristate "Routing message grabulator (for userland routing daemon)"
diff --git a/net/ipv4/netfilter/Kconfig b/net/ipv4/netfilter/Kconfig
index ad26f66..cface71 100644
--- a/net/ipv4/netfilter/Kconfig
+++ b/net/ipv4/netfilter/Kconfig
@@ -8,6 +8,7 @@ menu "IP: Netfilter Configuration"
 config NF_CONNTRACK_IPV4
 	tristate "IPv4 connection tracking support (required for NAT)"
 	depends on NF_CONNTRACK
+	default m if NETFILTER_ADVANCED=n
 	---help---
 	  Connection tracking keeps a record of what packets have passed
 	  through your machine, in order to figure out how they are related
@@ -32,6 +33,7 @@ config NF_CONNTRACK_PROC_COMPAT
 
 config IP_NF_QUEUE
 	tristate "IP Userspace queueing via NETLINK (OBSOLETE)"
+	depends on NETFILTER_ADVANCED
 	help
 	  Netfilter has the ability to queue packets to user space: the
 	  netlink device can be used to access them using this driver.
@@ -44,6 +46,7 @@ config IP_NF_QUEUE
 
 config IP_NF_IPTABLES
 	tristate "IP tables support (required for filtering/masq/NAT)"
+	default m if NETFILTER_ADVANCED=n
 	select NETFILTER_XTABLES
 	help
 	  iptables is a general, extensible packet identification framework.
@@ -57,6 +60,7 @@ config IP_NF_IPTABLES
 config IP_NF_MATCH_IPRANGE
 	tristate '"iprange" match support'
 	depends on IP_NF_IPTABLES
+	depends on NETFILTER_ADVANCED
 	help
 	  This option makes possible to match IP addresses against IP address
 	  ranges.
@@ -66,6 +70,7 @@ config IP_NF_MATCH_IPRANGE
 config IP_NF_MATCH_RECENT
 	tristate '"recent" match support'
 	depends on IP_NF_IPTABLES
+	depends on NETFILTER_ADVANCED
 	help
 	  This match is used for creating one or many lists of recently
 	  used addresses and then matching against that/those list(s).
@@ -78,6 +83,7 @@ config IP_NF_MATCH_RECENT
 config IP_NF_MATCH_ECN
 	tristate '"ecn" match support'
 	depends on IP_NF_IPTABLES
+	depends on NETFILTER_ADVANCED
 	help
 	  This option adds a `ECN' match, which allows you to match against
 	  the IPv4 and TCP header ECN fields.
@@ -87,6 +93,7 @@ config IP_NF_MATCH_ECN
 config IP_NF_MATCH_AH
 	tristate '"ah" match support'
 	depends on IP_NF_IPTABLES
+	depends on NETFILTER_ADVANCED
 	help
 	  This match extension allows you to match a range of SPIs
 	  inside AH header of IPSec packets.
@@ -96,6 +103,7 @@ config IP_NF_MATCH_AH
 config IP_NF_MATCH_TTL
 	tristate '"ttl" match support'
 	depends on IP_NF_IPTABLES
+	depends on NETFILTER_ADVANCED
 	help
 	  This adds CONFIG_IP_NF_MATCH_TTL option, which enabled the user
 	  to match packets by their TTL value.
@@ -105,10 +113,11 @@ config IP_NF_MATCH_TTL
 config IP_NF_MATCH_ADDRTYPE
 	tristate '"addrtype" address type match support'
 	depends on IP_NF_IPTABLES
+	depends on NETFILTER_ADVANCED
 	help
 	  This option allows you to match what routing thinks of an address,
 	  eg. UNICAST, LOCAL, BROADCAST, ...
-	
+
 	  If you want to compile it as a module, say M here and read
 	  <file:Documentation/kbuild/modules.txt>.  If unsure, say `N'.
 
@@ -116,6 +125,7 @@ config IP_NF_MATCH_ADDRTYPE
 config IP_NF_FILTER
 	tristate "Packet filtering"
 	depends on IP_NF_IPTABLES
+	default m if NETFILTER_ADVANCED=n
 	help
 	  Packet filtering defines a table `filter', which has a series of
 	  rules for simple packet filtering at local input, forwarding and
@@ -126,6 +136,7 @@ config IP_NF_FILTER
 config IP_NF_TARGET_REJECT
 	tristate "REJECT target support"
 	depends on IP_NF_FILTER
+	default m if NETFILTER_ADVANCED=n
 	help
 	  The REJECT target allows a filtering rule to specify that an ICMP
 	  error should be issued in response to an incoming packet, rather
@@ -136,6 +147,7 @@ config IP_NF_TARGET_REJECT
 config IP_NF_TARGET_LOG
 	tristate "LOG target support"
 	depends on IP_NF_IPTABLES
+	default m if NETFILTER_ADVANCED=n
 	help
 	  This option adds a `LOG' target, which allows you to create rules in
 	  any iptables table which records the packet header to the syslog.
@@ -145,6 +157,7 @@ config IP_NF_TARGET_LOG
 config IP_NF_TARGET_ULOG
 	tristate "ULOG target support"
 	depends on IP_NF_IPTABLES
+	default m if NETFILTER_ADVANCED=n
 	---help---
 
 	  This option enables the old IPv4-only "ipt_ULOG" implementation
@@ -165,6 +178,7 @@ config IP_NF_TARGET_ULOG
 config NF_NAT
 	tristate "Full NAT"
 	depends on IP_NF_IPTABLES && NF_CONNTRACK_IPV4
+	default m if NETFILTER_ADVANCED=n
 	help
 	  The Full NAT option allows masquerading, port forwarding and other
 	  forms of full Network Address Port Translation.  It is controlled by
@@ -180,6 +194,7 @@ config NF_NAT_NEEDED
 config IP_NF_TARGET_MASQUERADE
 	tristate "MASQUERADE target support"
 	depends on NF_NAT
+	default m if NETFILTER_ADVANCED=n
 	help
 	  Masquerading is a special case of NAT: all outgoing connections are
 	  changed to seem to come from a particular interface's address, and
@@ -192,6 +207,7 @@ config IP_NF_TARGET_MASQUERADE
 config IP_NF_TARGET_REDIRECT
 	tristate "REDIRECT target support"
 	depends on NF_NAT
+	depends on NETFILTER_ADVANCED
 	help
 	  REDIRECT is a special case of NAT: all incoming connections are
 	  mapped onto the incoming interface's address, causing the packets to
@@ -203,6 +219,7 @@ config IP_NF_TARGET_REDIRECT
 config IP_NF_TARGET_NETMAP
 	tristate "NETMAP target support"
 	depends on NF_NAT
+	depends on NETFILTER_ADVANCED
 	help
 	  NETMAP is an implementation of static 1:1 NAT mapping of network
 	  addresses. It maps the network address part, while keeping the host
@@ -214,6 +231,7 @@ config IP_NF_TARGET_NETMAP
 config NF_NAT_SNMP_BASIC
 	tristate "Basic SNMP-ALG support (EXPERIMENTAL)"
 	depends on EXPERIMENTAL && NF_NAT
+	depends on NETFILTER_ADVANCED
 	---help---
 
 	  This module implements an Application Layer Gateway (ALG) for
@@ -277,6 +295,7 @@ config NF_NAT_SIP
 config IP_NF_MANGLE
 	tristate "Packet mangling"
 	depends on IP_NF_IPTABLES
+	default m if NETFILTER_ADVANCED=n
 	help
 	  This option adds a `mangle' table to iptables: see the man page for
 	  iptables(8).  This table is used for various packet alterations
@@ -287,6 +306,7 @@ config IP_NF_MANGLE
 config IP_NF_TARGET_ECN
 	tristate "ECN target support"
 	depends on IP_NF_MANGLE
+	depends on NETFILTER_ADVANCED
 	---help---
 	  This option adds a `ECN' target, which can be used in the iptables mangle
 	  table.  
@@ -301,6 +321,7 @@ config IP_NF_TARGET_ECN
 config IP_NF_TARGET_TTL
 	tristate  'TTL target support'
 	depends on IP_NF_MANGLE
+	depends on NETFILTER_ADVANCED
 	help
 	  This option adds a `TTL' target, which enables the user to modify
 	  the TTL value of the IP header.
@@ -316,6 +337,7 @@ config IP_NF_TARGET_CLUSTERIP
 	tristate "CLUSTERIP target support (EXPERIMENTAL)"
 	depends on IP_NF_MANGLE && EXPERIMENTAL
 	depends on NF_CONNTRACK_IPV4
+	depends on NETFILTER_ADVANCED
 	select NF_CONNTRACK_MARK
 	help
 	  The CLUSTERIP target allows you to build load-balancing clusters of
@@ -328,6 +350,7 @@ config IP_NF_TARGET_CLUSTERIP
 config IP_NF_RAW
 	tristate  'raw table support (required for NOTRACK/TRACE)'
 	depends on IP_NF_IPTABLES
+	depends on NETFILTER_ADVANCED
 	help
 	  This option adds a `raw' table to iptables. This table is the very
 	  first in the netfilter framework and hooks in at the PREROUTING
@@ -340,6 +363,7 @@ config IP_NF_RAW
 config IP_NF_ARPTABLES
 	tristate "ARP tables support"
 	select NETFILTER_XTABLES
+	depends on NETFILTER_ADVANCED
 	help
 	  arptables is a general, extensible packet identification framework.
 	  The ARP packet filtering and mangling (manipulation)subsystems
diff --git a/net/ipv6/netfilter/Kconfig b/net/ipv6/netfilter/Kconfig
index 5374c66..a6b4a9a 100644
--- a/net/ipv6/netfilter/Kconfig
+++ b/net/ipv6/netfilter/Kconfig
@@ -8,6 +8,7 @@ menu "IPv6: Netfilter Configuration (EXPERIMENTAL)"
 config NF_CONNTRACK_IPV6
 	tristate "IPv6 connection tracking support (EXPERIMENTAL)"
 	depends on INET && IPV6 && EXPERIMENTAL && NF_CONNTRACK
+	default m if NETFILTER_ADVANCED=n
 	---help---
 	  Connection tracking keeps a record of what packets have passed
 	  through your machine, in order to figure out how they are related
@@ -22,6 +23,7 @@ config NF_CONNTRACK_IPV6
 config IP6_NF_QUEUE
 	tristate "IP6 Userspace queueing via NETLINK (OBSOLETE)"
 	depends on INET && IPV6 && NETFILTER && EXPERIMENTAL
+	depends on NETFILTER_ADVANCED
 	---help---
 
 	  This option adds a queue handler to the kernel for IPv6
@@ -44,6 +46,7 @@ config IP6_NF_IPTABLES
 	tristate "IP6 tables support (required for filtering)"
 	depends on INET && IPV6 && EXPERIMENTAL
 	select NETFILTER_XTABLES
+	default m if NETFILTER_ADVANCED=n
 	help
 	  ip6tables is a general, extensible packet identification framework.
 	  Currently only the packet filtering and packet mangling subsystem
@@ -56,6 +59,7 @@ config IP6_NF_IPTABLES
 config IP6_NF_MATCH_RT
 	tristate '"rt" Routing header match support'
 	depends on IP6_NF_IPTABLES
+	depends on NETFILTER_ADVANCED
 	help
 	  rt matching allows you to match packets based on the routing
 	  header of the packet.
@@ -65,6 +69,7 @@ config IP6_NF_MATCH_RT
 config IP6_NF_MATCH_OPTS
 	tristate '"hopbyhop" and "dst" opts header match support'
 	depends on IP6_NF_IPTABLES
+	depends on NETFILTER_ADVANCED
 	help
 	  This allows one to match packets based on the hop-by-hop
 	  and destination options headers of a packet.
@@ -74,6 +79,7 @@ config IP6_NF_MATCH_OPTS
 config IP6_NF_MATCH_FRAG
 	tristate '"frag" Fragmentation header match support'
 	depends on IP6_NF_IPTABLES
+	depends on NETFILTER_ADVANCED
 	help
 	  frag matching allows you to match packets based on the fragmentation
 	  header of the packet.
@@ -83,6 +89,7 @@ config IP6_NF_MATCH_FRAG
 config IP6_NF_MATCH_HL
 	tristate '"hl" match support'
 	depends on IP6_NF_IPTABLES
+	depends on NETFILTER_ADVANCED
 	help
 	  HL matching allows you to match packets based on the hop
 	  limit of the packet.
@@ -92,6 +99,7 @@ config IP6_NF_MATCH_HL
 config IP6_NF_MATCH_IPV6HEADER
 	tristate '"ipv6header" IPv6 Extension Headers Match'
 	depends on IP6_NF_IPTABLES
+	depends on NETFILTER_ADVANCED
 	help
 	  This module allows one to match packets based upon
 	  the ipv6 extension headers.
@@ -101,6 +109,7 @@ config IP6_NF_MATCH_IPV6HEADER
 config IP6_NF_MATCH_AH
 	tristate '"ah" match support'
 	depends on IP6_NF_IPTABLES
+	depends on NETFILTER_ADVANCED
 	help
 	  This module allows one to match AH packets.
 
@@ -109,6 +118,7 @@ config IP6_NF_MATCH_AH
 config IP6_NF_MATCH_MH
 	tristate '"mh" match support'
 	depends on IP6_NF_IPTABLES
+	depends on NETFILTER_ADVANCED
 	help
 	  This module allows one to match MH packets.
 
@@ -117,6 +127,7 @@ config IP6_NF_MATCH_MH
 config IP6_NF_MATCH_EUI64
 	tristate '"eui64" address check'
 	depends on IP6_NF_IPTABLES
+	depends on NETFILTER_ADVANCED
 	help
 	  This module performs checking on the IPv6 source address
 	  Compares the last 64 bits with the EUI64 (delivered
@@ -128,6 +139,7 @@ config IP6_NF_MATCH_EUI64
 config IP6_NF_FILTER
 	tristate "Packet filtering"
 	depends on IP6_NF_IPTABLES
+	default m if NETFILTER_ADVANCED=n
 	help
 	  Packet filtering defines a table `filter', which has a series of
 	  rules for simple packet filtering at local input, forwarding and
@@ -138,6 +150,7 @@ config IP6_NF_FILTER
 config IP6_NF_TARGET_LOG
 	tristate "LOG target support"
 	depends on IP6_NF_FILTER
+	default m if NETFILTER_ADVANCED=n
 	help
 	  This option adds a `LOG' target, which allows you to create rules in
 	  any iptables table which records the packet header to the syslog.
@@ -147,6 +160,7 @@ config IP6_NF_TARGET_LOG
 config IP6_NF_TARGET_REJECT
 	tristate "REJECT target support"
 	depends on IP6_NF_FILTER
+	default m if NETFILTER_ADVANCED=n
 	help
 	  The REJECT target allows a filtering rule to specify that an ICMPv6
 	  error should be issued in response to an incoming packet, rather
@@ -157,6 +171,7 @@ config IP6_NF_TARGET_REJECT
 config IP6_NF_MANGLE
 	tristate "Packet mangling"
 	depends on IP6_NF_IPTABLES
+	default m if NETFILTER_ADVANCED=n
 	help
 	  This option adds a `mangle' table to iptables: see the man page for
 	  iptables(8).  This table is used for various packet alterations
@@ -167,27 +182,29 @@ config IP6_NF_MANGLE
 config IP6_NF_TARGET_HL
 	tristate  'HL (hoplimit) target support'
 	depends on IP6_NF_MANGLE
+	depends on NETFILTER_ADVANCED
 	help
 	  This option adds a `HL' target, which enables the user to decrement
 	  the hoplimit value of the IPv6 header or set it to a given (lower)
 	  value.
-	
+
 	  While it is safe to decrement the hoplimit value, this option also
 	  enables functionality to increment and set the hoplimit value of the
 	  IPv6 header to arbitrary values.  This is EXTREMELY DANGEROUS since
 	  you can easily create immortal packets that loop forever on the
-	  network.  
+	  network.
 
 	  To compile it as a module, choose M here.  If unsure, say N.
 
 config IP6_NF_RAW
 	tristate  'raw table support (required for TRACE)'
 	depends on IP6_NF_IPTABLES
+	depends on NETFILTER_ADVANCED
 	help
 	  This option adds a `raw' table to ip6tables. This table is the very
 	  first in the netfilter framework and hooks in at the PREROUTING
 	  and OUTPUT chains.
-	
+
 	  If you want to compile it as a module, say M here and read
 	  <file:Documentation/kbuild/modules.txt>.  If unsure, say `N'.
 
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index bb61f83..96dbe9f 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -6,6 +6,7 @@ config NETFILTER_NETLINK
 
 config NETFILTER_NETLINK_QUEUE
 	tristate "Netfilter NFQUEUE over NFNETLINK interface"
+	depends on NETFILTER_ADVANCED
 	select NETFILTER_NETLINK
 	help
 	  If this option is enabled, the kernel will include support
@@ -13,6 +14,7 @@ config NETFILTER_NETLINK_QUEUE
 	  
 config NETFILTER_NETLINK_LOG
 	tristate "Netfilter LOG over NFNETLINK interface"
+	default m if NETFILTER_ADVANCED=n
 	select NETFILTER_NETLINK
 	help
 	  If this option is enabled, the kernel will include support
@@ -24,6 +26,7 @@ config NETFILTER_NETLINK_LOG
 
 config NF_CONNTRACK
 	tristate "Netfilter connection tracking support"
+	default m if NETFILTER_ADVANCED=n
 	help
 	  Connection tracking keeps a record of what packets have passed
 	  through your machine, in order to figure out how they are related
@@ -38,6 +41,7 @@ config NF_CONNTRACK
 
 config NF_CT_ACCT
 	bool "Connection tracking flow accounting"
+	depends on NETFILTER_ADVANCED
 	depends on NF_CONNTRACK
 	help
 	  If this option is enabled, the connection tracking code will
@@ -50,6 +54,7 @@ config NF_CT_ACCT
 
 config NF_CONNTRACK_MARK
 	bool  'Connection mark tracking support'
+	depends on NETFILTER_ADVANCED
 	depends on NF_CONNTRACK
 	help
 	  This option enables support for connection marks, used by the
@@ -60,6 +65,7 @@ config NF_CONNTRACK_MARK
 config NF_CONNTRACK_SECMARK
 	bool  'Connection tracking security mark support'
 	depends on NF_CONNTRACK && NETWORK_SECMARK
+	default m if NETFILTER_ADVANCED=n
 	help
 	  This option enables security markings to be applied to
 	  connections.  Typically they are copied to connections from
@@ -72,6 +78,7 @@ config NF_CONNTRACK_SECMARK
 config NF_CONNTRACK_EVENTS
 	bool "Connection tracking events (EXPERIMENTAL)"
 	depends on EXPERIMENTAL && NF_CONNTRACK
+	depends on NETFILTER_ADVANCED
 	help
 	  If this option is enabled, the connection tracking code will
 	  provide a notifier chain that can be used by other kernel code
@@ -86,7 +93,7 @@ config NF_CT_PROTO_GRE
 config NF_CT_PROTO_SCTP
 	tristate 'SCTP protocol connection tracking support (EXPERIMENTAL)'
 	depends on EXPERIMENTAL && NF_CONNTRACK
-	default n
+	depends on NETFILTER_ADVANCED
 	help
 	  With this option enabled, the layer 3 independent connection
 	  tracking code will be able to do state tracking on SCTP connections.
@@ -97,6 +104,7 @@ config NF_CT_PROTO_SCTP
 config NF_CT_PROTO_UDPLITE
 	tristate 'UDP-Lite protocol connection tracking support (EXPERIMENTAL)'
 	depends on EXPERIMENTAL && NF_CONNTRACK
+	depends on NETFILTER_ADVANCED
 	help
 	  With this option enabled, the layer 3 independent connection
 	  tracking code will be able to do state tracking on UDP-Lite
@@ -107,6 +115,7 @@ config NF_CT_PROTO_UDPLITE
 config NF_CONNTRACK_AMANDA
 	tristate "Amanda backup protocol support"
 	depends on NF_CONNTRACK
+	depends on NETFILTER_ADVANCED
 	select TEXTSEARCH
 	select TEXTSEARCH_KMP
 	help
@@ -122,6 +131,7 @@ config NF_CONNTRACK_AMANDA
 config NF_CONNTRACK_FTP
 	tristate "FTP protocol support"
 	depends on NF_CONNTRACK
+	default m if NETFILTER_ADVANCED=n
 	help
 	  Tracking FTP connections is problematic: special helpers are
 	  required for tracking them, and doing masquerading and other forms
@@ -136,6 +146,7 @@ config NF_CONNTRACK_FTP
 config NF_CONNTRACK_H323
 	tristate "H.323 protocol support (EXPERIMENTAL)"
 	depends on EXPERIMENTAL && NF_CONNTRACK && (IPV6 || IPV6=n)
+	depends on NETFILTER_ADVANCED
 	help
 	  H.323 is a VoIP signalling protocol from ITU-T. As one of the most
 	  important VoIP protocols, it is widely used by voice hardware and
@@ -155,6 +166,7 @@ config NF_CONNTRACK_H323
 config NF_CONNTRACK_IRC
 	tristate "IRC protocol support"
 	depends on NF_CONNTRACK
+	default m if NETFILTER_ADVANCED=n
 	help
 	  There is a commonly-used extension to IRC called
 	  Direct Client-to-Client Protocol (DCC).  This enables users to send
@@ -170,6 +182,7 @@ config NF_CONNTRACK_IRC
 config NF_CONNTRACK_NETBIOS_NS
 	tristate "NetBIOS name service protocol support (EXPERIMENTAL)"
 	depends on EXPERIMENTAL && NF_CONNTRACK
+	depends on NETFILTER_ADVANCED
 	help
 	  NetBIOS name service requests are sent as broadcast messages from an
 	  unprivileged port and responded to with unicast messages to the
@@ -189,6 +202,7 @@ config NF_CONNTRACK_NETBIOS_NS
 config NF_CONNTRACK_PPTP
 	tristate "PPtP protocol support"
 	depends on NF_CONNTRACK
+	depends on NETFILTER_ADVANCED
 	select NF_CT_PROTO_GRE
 	help
 	  This module adds support for PPTP (Point to Point Tunnelling
@@ -208,6 +222,7 @@ config NF_CONNTRACK_PPTP
 config NF_CONNTRACK_SANE
 	tristate "SANE protocol support (EXPERIMENTAL)"
 	depends on EXPERIMENTAL && NF_CONNTRACK
+	depends on NETFILTER_ADVANCED
 	help
 	  SANE is a protocol for remote access to scanners as implemented
 	  by the 'saned' daemon. Like FTP, it uses separate control and
@@ -221,6 +236,7 @@ config NF_CONNTRACK_SANE
 config NF_CONNTRACK_SIP
 	tristate "SIP protocol support (EXPERIMENTAL)"
 	depends on EXPERIMENTAL && NF_CONNTRACK
+	default m if NETFILTER_ADVANCED=n
 	help
 	  SIP is an application-layer control protocol that can establish,
 	  modify, and terminate multimedia sessions (conferences) such as
@@ -233,6 +249,7 @@ config NF_CONNTRACK_SIP
 config NF_CONNTRACK_TFTP
 	tristate "TFTP protocol support"
 	depends on NF_CONNTRACK
+	depends on NETFILTER_ADVANCED
 	help
 	  TFTP connection tracking helper, this is required depending
 	  on how restrictive your ruleset is.
@@ -246,11 +263,13 @@ config NF_CT_NETLINK
 	depends on EXPERIMENTAL && NF_CONNTRACK
 	select NETFILTER_NETLINK
 	depends on NF_NAT=n || NF_NAT
+	default m if NETFILTER_ADVANCED=n
 	help
 	  This option enables support for a netlink-based userspace interface
 
 config NETFILTER_XTABLES
 	tristate "Netfilter Xtables support (required for ip_tables)"
+	default m if NETFILTER_ADVANCED=n
 	help
 	  This is required if you intend to use any of ip_tables,
 	  ip6_tables or arp_tables.
@@ -260,6 +279,7 @@ config NETFILTER_XTABLES
 config NETFILTER_XT_TARGET_CLASSIFY
 	tristate '"CLASSIFY" target support'
 	depends on NETFILTER_XTABLES
+	depends on NETFILTER_ADVANCED
 	help
 	  This option adds a `CLASSIFY' target, which enables the user to set
 	  the priority of a packet. Some qdiscs can use this value for
@@ -274,12 +294,13 @@ config NETFILTER_XT_TARGET_CONNMARK
 	depends on NETFILTER_XTABLES
 	depends on IP_NF_MANGLE || IP6_NF_MANGLE
 	depends on NF_CONNTRACK
+	depends on NETFILTER_ADVANCED
 	select NF_CONNTRACK_MARK
 	help
 	  This option adds a `CONNMARK' target, which allows one to manipulate
 	  the connection mark value.  Similar to the MARK target, but
 	  affects the connection mark value rather than the packet mark value.
-	
+
 	  If you want to compile it as a module, say M here and read
 	  <file:Documentation/kbuild/modules.txt>.  The module will be called
 	  ipt_CONNMARK.ko.  If unsure, say `N'.
@@ -288,6 +309,7 @@ config NETFILTER_XT_TARGET_DSCP
 	tristate '"DSCP" and "TOS" target support'
 	depends on NETFILTER_XTABLES
 	depends on IP_NF_MANGLE || IP6_NF_MANGLE
+	depends on NETFILTER_ADVANCED
 	help
 	  This option adds a `DSCP' target, which allows you to manipulate
 	  the IPv4/IPv6 header DSCP field (differentiated services codepoint).
@@ -303,6 +325,7 @@ config NETFILTER_XT_TARGET_DSCP
 config NETFILTER_XT_TARGET_MARK
 	tristate '"MARK" target support'
 	depends on NETFILTER_XTABLES
+	default m if NETFILTER_ADVANCED=n
 	help
 	  This option adds a `MARK' target, which allows you to create rules
 	  in the `mangle' table which alter the netfilter mark (nfmark) field
@@ -316,6 +339,7 @@ config NETFILTER_XT_TARGET_MARK
 config NETFILTER_XT_TARGET_NFQUEUE
 	tristate '"NFQUEUE" target Support'
 	depends on NETFILTER_XTABLES
+	depends on NETFILTER_ADVANCED
 	help
 	  This target replaced the old obsolete QUEUE target.
 
@@ -327,6 +351,7 @@ config NETFILTER_XT_TARGET_NFQUEUE
 config NETFILTER_XT_TARGET_NFLOG
 	tristate '"NFLOG" target support'
 	depends on NETFILTER_XTABLES
+	default m if NETFILTER_ADVANCED=n
 	help
 	  This option enables the NFLOG target, which allows to LOG
 	  messages through the netfilter logging API, which can use
@@ -340,12 +365,13 @@ config NETFILTER_XT_TARGET_NOTRACK
 	depends on NETFILTER_XTABLES
 	depends on IP_NF_RAW || IP6_NF_RAW
 	depends on NF_CONNTRACK
+	depends on NETFILTER_ADVANCED
 	help
 	  The NOTRACK target allows a select rule to specify
 	  which packets *not* to enter the conntrack/NAT
 	  subsystem with all the consequences (no ICMP error tracking,
 	  no protocol helpers for the selected packets).
-	
+
 	  If you want to compile it as a module, say M here and read
 	  <file:Documentation/kbuild/modules.txt>.  If unsure, say `N'.
 
@@ -363,6 +389,7 @@ config NETFILTER_XT_TARGET_TRACE
 	tristate  '"TRACE" target support'
 	depends on NETFILTER_XTABLES
 	depends on IP_NF_RAW || IP6_NF_RAW
+	depends on NETFILTER_ADVANCED
 	help
 	  The TRACE target allows you to mark packets so that the kernel
 	  will log every rule which match the packets as those traverse
@@ -374,6 +401,7 @@ config NETFILTER_XT_TARGET_TRACE
 config NETFILTER_XT_TARGET_SECMARK
 	tristate '"SECMARK" target support'
 	depends on NETFILTER_XTABLES && NETWORK_SECMARK
+	default m if NETFILTER_ADVANCED=n
 	help
 	  The SECMARK target allows security marking of network
 	  packets, for use with security subsystems.
@@ -383,6 +411,7 @@ config NETFILTER_XT_TARGET_SECMARK
 config NETFILTER_XT_TARGET_CONNSECMARK
 	tristate '"CONNSECMARK" target support'
 	depends on NETFILTER_XTABLES && NF_CONNTRACK && NF_CONNTRACK_SECMARK
+	default m if NETFILTER_ADVANCED=n
 	help
 	  The CONNSECMARK target copies security markings from packets
 	  to connections, and restores security markings from connections
@@ -394,6 +423,7 @@ config NETFILTER_XT_TARGET_CONNSECMARK
 config NETFILTER_XT_TARGET_TCPMSS
 	tristate '"TCPMSS" target support'
 	depends on NETFILTER_XTABLES && (IPV6 || IPV6=n)
+	default m if NETFILTER_ADVANCED=n
 	---help---
 	  This option adds a `TCPMSS' target, which allows you to alter the
 	  MSS value of TCP SYN packets, to control the maximum size for that
@@ -421,6 +451,7 @@ config NETFILTER_XT_TARGET_TCPOPTSTRIP
 	tristate '"TCPOPTSTRIP" target support (EXPERIMENTAL)'
 	depends on EXPERIMENTAL && NETFILTER_XTABLES
 	depends on IP_NF_MANGLE || IP6_NF_MANGLE
+	depends on NETFILTER_ADVANCED
 	help
 	  This option adds a "TCPOPTSTRIP" target, which allows you to strip
 	  TCP options from TCP packets.
@@ -428,6 +459,7 @@ config NETFILTER_XT_TARGET_TCPOPTSTRIP
 config NETFILTER_XT_MATCH_COMMENT
 	tristate  '"comment" match support'
 	depends on NETFILTER_XTABLES
+	depends on NETFILTER_ADVANCED
 	help
 	  This option adds a `comment' dummy-match, which allows you to put
 	  comments in your iptables ruleset.
@@ -439,6 +471,7 @@ config NETFILTER_XT_MATCH_CONNBYTES
 	tristate  '"connbytes" per-connection counter match support'
 	depends on NETFILTER_XTABLES
 	depends on NF_CONNTRACK
+	depends on NETFILTER_ADVANCED
 	select NF_CT_ACCT
 	help
 	  This option adds a `connbytes' match, which allows you to match the
@@ -451,6 +484,7 @@ config NETFILTER_XT_MATCH_CONNLIMIT
 	tristate '"connlimit" match support"'
 	depends on NETFILTER_XTABLES
 	depends on NF_CONNTRACK
+	depends on NETFILTER_ADVANCED
 	---help---
 	  This match allows you to match against the number of parallel
 	  connections to a server per client IP address (or address block).
@@ -459,11 +493,12 @@ config NETFILTER_XT_MATCH_CONNMARK
 	tristate  '"connmark" connection mark match support'
 	depends on NETFILTER_XTABLES
 	depends on NF_CONNTRACK
+	depends on NETFILTER_ADVANCED
 	select NF_CONNTRACK_MARK
 	help
 	  This option adds a `connmark' match, which allows you to match the
 	  connection mark value previously set for the session by `CONNMARK'. 
-	
+
 	  If you want to compile it as a module, say M here and read
 	  <file:Documentation/kbuild/modules.txt>.  The module will be called
 	  ipt_connmark.ko.  If unsure, say `N'.
@@ -472,6 +507,7 @@ config NETFILTER_XT_MATCH_CONNTRACK
 	tristate '"conntrack" connection tracking match support'
 	depends on NETFILTER_XTABLES
 	depends on NF_CONNTRACK
+	default m if NETFILTER_ADVANCED=n
 	help
 	  This is a general conntrack match module, a superset of the state match.
 
@@ -484,6 +520,7 @@ config NETFILTER_XT_MATCH_CONNTRACK
 config NETFILTER_XT_MATCH_DCCP
 	tristate '"dccp" protocol match support'
 	depends on NETFILTER_XTABLES
+	depends on NETFILTER_ADVANCED
 	help
 	  With this option enabled, you will be able to use the iptables
 	  `dccp' match in order to match on DCCP source/destination ports
@@ -495,6 +532,7 @@ config NETFILTER_XT_MATCH_DCCP
 config NETFILTER_XT_MATCH_DSCP
 	tristate '"dscp" and "tos" match support'
 	depends on NETFILTER_XTABLES
+	depends on NETFILTER_ADVANCED
 	help
 	  This option adds a `DSCP' match, which allows you to match against
 	  the IPv4/IPv6 header DSCP field (differentiated services codepoint).
@@ -510,6 +548,7 @@ config NETFILTER_XT_MATCH_DSCP
 config NETFILTER_XT_MATCH_ESP
 	tristate '"esp" match support'
 	depends on NETFILTER_XTABLES
+	depends on NETFILTER_ADVANCED
 	help
 	  This match extension allows you to match a range of SPIs
 	  inside ESP header of IPSec packets.
@@ -520,6 +559,7 @@ config NETFILTER_XT_MATCH_HELPER
 	tristate '"helper" match support'
 	depends on NETFILTER_XTABLES
 	depends on NF_CONNTRACK
+	depends on NETFILTER_ADVANCED
 	help
 	  Helper matching allows you to match packets in dynamic connections
 	  tracked by a conntrack-helper, ie. ip_conntrack_ftp
@@ -529,6 +569,7 @@ config NETFILTER_XT_MATCH_HELPER
 config NETFILTER_XT_MATCH_LENGTH
 	tristate '"length" match support'
 	depends on NETFILTER_XTABLES
+	depends on NETFILTER_ADVANCED
 	help
 	  This option allows you to match the length of a packet against a
 	  specific value or range of values.
@@ -538,6 +579,7 @@ config NETFILTER_XT_MATCH_LENGTH
 config NETFILTER_XT_MATCH_LIMIT
 	tristate '"limit" match support'
 	depends on NETFILTER_XTABLES
+	depends on NETFILTER_ADVANCED
 	help
 	  limit matching allows you to control the rate at which a rule can be
 	  matched: mainly useful in combination with the LOG target ("LOG
@@ -548,6 +590,7 @@ config NETFILTER_XT_MATCH_LIMIT
 config NETFILTER_XT_MATCH_MAC
 	tristate '"mac" address match support'
 	depends on NETFILTER_XTABLES
+	depends on NETFILTER_ADVANCED
 	help
 	  MAC matching allows you to match packets based on the source
 	  Ethernet address of the packet.
@@ -557,6 +600,7 @@ config NETFILTER_XT_MATCH_MAC
 config NETFILTER_XT_MATCH_MARK
 	tristate '"mark" match support'
 	depends on NETFILTER_XTABLES
+	default m if NETFILTER_ADVANCED=n
 	help
 	  Netfilter mark matching allows you to match packets based on the
 	  `nfmark' value in the packet.  This can be set by the MARK target
@@ -567,6 +611,7 @@ config NETFILTER_XT_MATCH_MARK
 config NETFILTER_XT_MATCH_OWNER
 	tristate '"owner" match support'
 	depends on NETFILTER_XTABLES
+	depends on NETFILTER_ADVANCED
 	---help---
 	Socket owner matching allows you to match locally-generated packets
 	based on who created the socket: the user or group. It is also
@@ -575,6 +620,7 @@ config NETFILTER_XT_MATCH_OWNER
 config NETFILTER_XT_MATCH_POLICY
 	tristate 'IPsec "policy" match support'
 	depends on NETFILTER_XTABLES && XFRM
+	default m if NETFILTER_ADVANCED=n
 	help
 	  Policy matching allows you to match packets based on the
 	  IPsec policy that was used during decapsulation/will
@@ -585,6 +631,7 @@ config NETFILTER_XT_MATCH_POLICY
 config NETFILTER_XT_MATCH_MULTIPORT
 	tristate '"multiport" Multiple port match support'
 	depends on NETFILTER_XTABLES
+	depends on NETFILTER_ADVANCED
 	help
 	  Multiport matching allows you to match TCP or UDP packets based on
 	  a series of source or destination ports: normally a rule can only
@@ -595,6 +642,7 @@ config NETFILTER_XT_MATCH_MULTIPORT
 config NETFILTER_XT_MATCH_PHYSDEV
 	tristate '"physdev" match support'
 	depends on NETFILTER_XTABLES && BRIDGE && BRIDGE_NETFILTER
+	depends on NETFILTER_ADVANCED
 	help
 	  Physdev packet matching matches against the physical bridge ports
 	  the IP packet arrived on or will leave by.
@@ -604,6 +652,7 @@ config NETFILTER_XT_MATCH_PHYSDEV
 config NETFILTER_XT_MATCH_PKTTYPE
 	tristate '"pkttype" packet type match support'
 	depends on NETFILTER_XTABLES
+	depends on NETFILTER_ADVANCED
 	help
 	  Packet type matching allows you to match a packet by
 	  its "class", eg. BROADCAST, MULTICAST, ...
@@ -616,6 +665,7 @@ config NETFILTER_XT_MATCH_PKTTYPE
 config NETFILTER_XT_MATCH_QUOTA
 	tristate '"quota" match support'
 	depends on NETFILTER_XTABLES
+	depends on NETFILTER_ADVANCED
 	help
 	  This option adds a `quota' match, which allows to match on a
 	  byte counter.
@@ -636,20 +686,22 @@ config NETFILTER_XT_MATCH_RATEEST
 config NETFILTER_XT_MATCH_REALM
 	tristate  '"realm" match support'
 	depends on NETFILTER_XTABLES
+	depends on NETFILTER_ADVANCED
 	select NET_CLS_ROUTE
 	help
 	  This option adds a `realm' match, which allows you to use the realm
 	  key from the routing subsystem inside iptables.
-	
+
 	  This match pretty much resembles the CONFIG_NET_CLS_ROUTE4 option 
 	  in tc world.
-	
+
 	  If you want to compile it as a module, say M here and read
 	  <file:Documentation/kbuild/modules.txt>.  If unsure, say `N'.
 
 config NETFILTER_XT_MATCH_SCTP
 	tristate  '"sctp" protocol match support (EXPERIMENTAL)'
 	depends on NETFILTER_XTABLES && EXPERIMENTAL
+	depends on NETFILTER_ADVANCED
 	help
 	  With this option enabled, you will be able to use the 
 	  `sctp' match in order to match on SCTP source/destination ports
@@ -662,6 +714,7 @@ config NETFILTER_XT_MATCH_STATE
 	tristate '"state" match support'
 	depends on NETFILTER_XTABLES
 	depends on NF_CONNTRACK
+	default m if NETFILTER_ADVANCED=n
 	help
 	  Connection state matching allows you to match packets based on their
 	  relationship to a tracked connection (ie. previous packets).  This
@@ -672,6 +725,7 @@ config NETFILTER_XT_MATCH_STATE
 config NETFILTER_XT_MATCH_STATISTIC
 	tristate '"statistic" match support'
 	depends on NETFILTER_XTABLES
+	depends on NETFILTER_ADVANCED
 	help
 	  This option adds a `statistic' match, which allows you to match
 	  on packets periodically or randomly with a given percentage.
@@ -681,6 +735,7 @@ config NETFILTER_XT_MATCH_STATISTIC
 config NETFILTER_XT_MATCH_STRING
 	tristate  '"string" match support'
 	depends on NETFILTER_XTABLES
+	depends on NETFILTER_ADVANCED
 	select TEXTSEARCH
 	select TEXTSEARCH_KMP
 	select TEXTSEARCH_BM
@@ -694,6 +749,7 @@ config NETFILTER_XT_MATCH_STRING
 config NETFILTER_XT_MATCH_TCPMSS
 	tristate '"tcpmss" match support'
 	depends on NETFILTER_XTABLES
+	depends on NETFILTER_ADVANCED
 	help
 	  This option adds a `tcpmss' match, which allows you to examine the
 	  MSS value of TCP SYN packets, which control the maximum packet size
@@ -704,6 +760,7 @@ config NETFILTER_XT_MATCH_TCPMSS
 config NETFILTER_XT_MATCH_TIME
 	tristate '"time" match support'
 	depends on NETFILTER_XTABLES
+	depends on NETFILTER_ADVANCED
 	---help---
 	  This option adds a "time" match, which allows you to match based on
 	  the packet arrival time (at the machine which netfilter is running)
@@ -718,6 +775,7 @@ config NETFILTER_XT_MATCH_TIME
 config NETFILTER_XT_MATCH_U32
 	tristate '"u32" match support'
 	depends on NETFILTER_XTABLES
+	depends on NETFILTER_ADVANCED
 	---help---
 	  u32 allows you to extract quantities of up to 4 bytes from a packet,
 	  AND them with specified masks, shift them by specified amounts and
@@ -731,6 +789,7 @@ config NETFILTER_XT_MATCH_U32
 config NETFILTER_XT_MATCH_HASHLIMIT
 	tristate '"hashlimit" match support'
 	depends on NETFILTER_XTABLES && (IP6_NF_IPTABLES || IP6_NF_IPTABLES=n)
+	depends on NETFILTER_ADVANCED
 	help
 	  This option adds a `hashlimit' match.
 
