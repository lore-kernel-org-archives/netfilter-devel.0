From: Patrick McHardy <kaber@trash.net>
Subject: netfilter 68/79: xtables: sort extensions alphabetically in Kconfig
Date: Wed,  8 Oct 2008 12:47:52 +0200 (MEST)
Message-ID: <20081008104752.10423.82770.sendpatchset@x2.localnet>
References: <20081008104621.10423.12648.sendpatchset@x2.localnet>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:46071 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754825AbYJHKry (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 8 Oct 2008 06:47:54 -0400
In-Reply-To: <20081008104621.10423.12648.sendpatchset@x2.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit aba0d34800d7f56493b4d5548cc06498a4d69124
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Wed Oct 8 11:35:17 2008 +0200

    netfilter: xtables: sort extensions alphabetically in Kconfig
    
    Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
    Signed-off-by: Patrick McHardy <kaber@trash.net>

diff --git a/net/ipv4/netfilter/Kconfig b/net/ipv4/netfilter/Kconfig
index 07757ac..087b829 100644
--- a/net/ipv4/netfilter/Kconfig
+++ b/net/ipv4/netfilter/Kconfig
@@ -62,15 +62,16 @@ config IP_NF_IPTABLES
 	  To compile it as a module, choose M here.  If unsure, say N.
 
 # The matches.
-config IP_NF_MATCH_ECN
-	tristate '"ecn" match support'
+config IP_NF_MATCH_ADDRTYPE
+	tristate '"addrtype" address type match support'
 	depends on IP_NF_IPTABLES
 	depends on NETFILTER_ADVANCED
 	help
-	  This option adds a `ECN' match, which allows you to match against
-	  the IPv4 and TCP header ECN fields.
+	  This option allows you to match what routing thinks of an address,
+	  eg. UNICAST, LOCAL, BROADCAST, ...
 
-	  To compile it as a module, choose M here.  If unsure, say N.
+	  If you want to compile it as a module, say M here and read
+	  <file:Documentation/kbuild/modules.txt>.  If unsure, say `N'.
 
 config IP_NF_MATCH_AH
 	tristate '"ah" match support'
@@ -82,26 +83,25 @@ config IP_NF_MATCH_AH
 
 	  To compile it as a module, choose M here.  If unsure, say N.
 
-config IP_NF_MATCH_TTL
-	tristate '"ttl" match support'
+config IP_NF_MATCH_ECN
+	tristate '"ecn" match support'
 	depends on IP_NF_IPTABLES
 	depends on NETFILTER_ADVANCED
 	help
-	  This adds CONFIG_IP_NF_MATCH_TTL option, which enabled the user
-	  to match packets by their TTL value.
+	  This option adds a `ECN' match, which allows you to match against
+	  the IPv4 and TCP header ECN fields.
 
 	  To compile it as a module, choose M here.  If unsure, say N.
 
-config IP_NF_MATCH_ADDRTYPE
-	tristate '"addrtype" address type match support'
+config IP_NF_MATCH_TTL
+	tristate '"ttl" match support'
 	depends on IP_NF_IPTABLES
 	depends on NETFILTER_ADVANCED
 	help
-	  This option allows you to match what routing thinks of an address,
-	  eg. UNICAST, LOCAL, BROADCAST, ...
+	  This adds CONFIG_IP_NF_MATCH_TTL option, which enabled the user
+	  to match packets by their TTL value.
 
-	  If you want to compile it as a module, say M here and read
-	  <file:Documentation/kbuild/modules.txt>.  If unsure, say `N'.
+	  To compile it as a module, choose M here.  If unsure, say N.
 
 # `filter', generic and specific targets
 config IP_NF_FILTER
@@ -186,26 +186,26 @@ config IP_NF_TARGET_MASQUERADE
 
 	  To compile it as a module, choose M here.  If unsure, say N.
 
-config IP_NF_TARGET_REDIRECT
-	tristate "REDIRECT target support"
+config IP_NF_TARGET_NETMAP
+	tristate "NETMAP target support"
 	depends on NF_NAT
 	depends on NETFILTER_ADVANCED
 	help
-	  REDIRECT is a special case of NAT: all incoming connections are
-	  mapped onto the incoming interface's address, causing the packets to
-	  come to the local machine instead of passing through.  This is
-	  useful for transparent proxies.
+	  NETMAP is an implementation of static 1:1 NAT mapping of network
+	  addresses. It maps the network address part, while keeping the host
+	  address part intact.
 
 	  To compile it as a module, choose M here.  If unsure, say N.
 
-config IP_NF_TARGET_NETMAP
-	tristate "NETMAP target support"
+config IP_NF_TARGET_REDIRECT
+	tristate "REDIRECT target support"
 	depends on NF_NAT
 	depends on NETFILTER_ADVANCED
 	help
-	  NETMAP is an implementation of static 1:1 NAT mapping of network
-	  addresses. It maps the network address part, while keeping the host
-	  address part intact.
+	  REDIRECT is a special case of NAT: all incoming connections are
+	  mapped onto the incoming interface's address, causing the packets to
+	  come to the local machine instead of passing through.  This is
+	  useful for transparent proxies.
 
 	  To compile it as a module, choose M here.  If unsure, say N.
 
@@ -300,6 +300,19 @@ config IP_NF_MANGLE
 
 	  To compile it as a module, choose M here.  If unsure, say N.
 
+config IP_NF_TARGET_CLUSTERIP
+	tristate "CLUSTERIP target support (EXPERIMENTAL)"
+	depends on IP_NF_MANGLE && EXPERIMENTAL
+	depends on NF_CONNTRACK_IPV4
+	depends on NETFILTER_ADVANCED
+	select NF_CONNTRACK_MARK
+	help
+	  The CLUSTERIP target allows you to build load-balancing clusters of
+	  network servers without having a dedicated load-balancing
+	  router/server/switch.
+
+	  To compile it as a module, choose M here.  If unsure, say N.
+
 config IP_NF_TARGET_ECN
 	tristate "ECN target support"
 	depends on IP_NF_MANGLE
@@ -330,19 +343,6 @@ config IP_NF_TARGET_TTL
 
 	  To compile it as a module, choose M here.  If unsure, say N.
 
-config IP_NF_TARGET_CLUSTERIP
-	tristate "CLUSTERIP target support (EXPERIMENTAL)"
-	depends on IP_NF_MANGLE && EXPERIMENTAL
-	depends on NF_CONNTRACK_IPV4
-	depends on NETFILTER_ADVANCED
-	select NF_CONNTRACK_MARK
-	help
-	  The CLUSTERIP target allows you to build load-balancing clusters of
-	  network servers without having a dedicated load-balancing
-	  router/server/switch.
-	
-	  To compile it as a module, choose M here.  If unsure, say N.
-
 # raw + specific targets
 config IP_NF_RAW
 	tristate  'raw table support (required for NOTRACK/TRACE)'
diff --git a/net/ipv6/netfilter/Kconfig b/net/ipv6/netfilter/Kconfig
index fee881b..91ffba0 100644
--- a/net/ipv6/netfilter/Kconfig
+++ b/net/ipv6/netfilter/Kconfig
@@ -56,23 +56,23 @@ config IP6_NF_IPTABLES
 	  To compile it as a module, choose M here.  If unsure, say N.
 
 # The simple matches.
-config IP6_NF_MATCH_RT
-	tristate '"rt" Routing header match support'
+config IP6_NF_MATCH_AH
+	tristate '"ah" match support'
 	depends on IP6_NF_IPTABLES
 	depends on NETFILTER_ADVANCED
 	help
-	  rt matching allows you to match packets based on the routing
-	  header of the packet.
+	  This module allows one to match AH packets.
 
 	  To compile it as a module, choose M here.  If unsure, say N.
 
-config IP6_NF_MATCH_OPTS
-	tristate '"hbh" hop-by-hop and "dst" opts header match support'
+config IP6_NF_MATCH_EUI64
+	tristate '"eui64" address check'
 	depends on IP6_NF_IPTABLES
 	depends on NETFILTER_ADVANCED
 	help
-	  This allows one to match packets based on the hop-by-hop
-	  and destination options headers of a packet.
+	  This module performs checking on the IPv6 source address
+	  Compares the last 64 bits with the EUI64 (delivered
+	  from the MAC address) address
 
 	  To compile it as a module, choose M here.  If unsure, say N.
 
@@ -86,6 +86,16 @@ config IP6_NF_MATCH_FRAG
 
 	  To compile it as a module, choose M here.  If unsure, say N.
 
+config IP6_NF_MATCH_OPTS
+	tristate '"hbh" hop-by-hop and "dst" opts header match support'
+	depends on IP6_NF_IPTABLES
+	depends on NETFILTER_ADVANCED
+	help
+	  This allows one to match packets based on the hop-by-hop
+	  and destination options headers of a packet.
+
+	  To compile it as a module, choose M here.  If unsure, say N.
+
 config IP6_NF_MATCH_HL
 	tristate '"hl" match support'
 	depends on IP6_NF_IPTABLES
@@ -106,15 +116,6 @@ config IP6_NF_MATCH_IPV6HEADER
 
 	  To compile it as a module, choose M here.  If unsure, say N.
 
-config IP6_NF_MATCH_AH
-	tristate '"ah" match support'
-	depends on IP6_NF_IPTABLES
-	depends on NETFILTER_ADVANCED
-	help
-	  This module allows one to match AH packets.
-
-	  To compile it as a module, choose M here.  If unsure, say N.
-
 config IP6_NF_MATCH_MH
 	tristate '"mh" match support'
 	depends on IP6_NF_IPTABLES
@@ -124,14 +125,13 @@ config IP6_NF_MATCH_MH
 
 	  To compile it as a module, choose M here.  If unsure, say N.
 
-config IP6_NF_MATCH_EUI64
-	tristate '"eui64" address check'
+config IP6_NF_MATCH_RT
+	tristate '"rt" Routing header match support'
 	depends on IP6_NF_IPTABLES
 	depends on NETFILTER_ADVANCED
 	help
-	  This module performs checking on the IPv6 source address
-	  Compares the last 64 bits with the EUI64 (delivered
-	  from the MAC address) address
+	  rt matching allows you to match packets based on the routing
+	  header of the packet.
 
 	  To compile it as a module, choose M here.  If unsure, say N.
 
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index de18bba..9ad74e8 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -340,6 +340,18 @@ config NETFILTER_XT_TARGET_CONNMARK
 	  <file:Documentation/kbuild/modules.txt>.  The module will be called
 	  ipt_CONNMARK.ko.  If unsure, say `N'.
 
+config NETFILTER_XT_TARGET_CONNSECMARK
+	tristate '"CONNSECMARK" target support'
+	depends on NETFILTER_XTABLES && NF_CONNTRACK && NF_CONNTRACK_SECMARK
+	default m if NETFILTER_ADVANCED=n
+	help
+	  The CONNSECMARK target copies security markings from packets
+	  to connections, and restores security markings from connections
+	  to packets (if the packets are not already marked).  This would
+	  normally be used in conjunction with the SECMARK target.
+
+	  To compile it as a module, choose M here.  If unsure, say N.
+
 config NETFILTER_XT_TARGET_DSCP
 	tristate '"DSCP" and "TOS" target support'
 	depends on NETFILTER_XTABLES
@@ -371,18 +383,6 @@ config NETFILTER_XT_TARGET_MARK
 
 	  To compile it as a module, choose M here.  If unsure, say N.
 
-config NETFILTER_XT_TARGET_NFQUEUE
-	tristate '"NFQUEUE" target Support'
-	depends on NETFILTER_XTABLES
-	depends on NETFILTER_ADVANCED
-	help
-	  This target replaced the old obsolete QUEUE target.
-
-	  As opposed to QUEUE, it supports 65535 different queues,
-	  not just one.
-
-	  To compile it as a module, choose M here.  If unsure, say N.
-
 config NETFILTER_XT_TARGET_NFLOG
 	tristate '"NFLOG" target support'
 	depends on NETFILTER_XTABLES
@@ -395,6 +395,18 @@ config NETFILTER_XT_TARGET_NFLOG
 
 	  To compile it as a module, choose M here.  If unsure, say N.
 
+config NETFILTER_XT_TARGET_NFQUEUE
+	tristate '"NFQUEUE" target Support'
+	depends on NETFILTER_XTABLES
+	depends on NETFILTER_ADVANCED
+	help
+	  This target replaced the old obsolete QUEUE target.
+
+	  As opposed to QUEUE, it supports 65535 different queues,
+	  not just one.
+
+	  To compile it as a module, choose M here.  If unsure, say N.
+
 config NETFILTER_XT_TARGET_NOTRACK
 	tristate  '"NOTRACK" target support'
 	depends on NETFILTER_XTABLES
@@ -459,18 +471,6 @@ config NETFILTER_XT_TARGET_SECMARK
 
 	  To compile it as a module, choose M here.  If unsure, say N.
 
-config NETFILTER_XT_TARGET_CONNSECMARK
-	tristate '"CONNSECMARK" target support'
-	depends on NETFILTER_XTABLES && NF_CONNTRACK && NF_CONNTRACK_SECMARK
-	default m if NETFILTER_ADVANCED=n
-	help
-	  The CONNSECMARK target copies security markings from packets
-	  to connections, and restores security markings from connections
-	  to packets (if the packets are not already marked).  This would
-	  normally be used in conjunction with the SECMARK target.
-
-	  To compile it as a module, choose M here.  If unsure, say N.
-
 config NETFILTER_XT_TARGET_TCPMSS
 	tristate '"TCPMSS" target support'
 	depends on NETFILTER_XTABLES && (IPV6 || IPV6=n)
@@ -607,6 +607,21 @@ config NETFILTER_XT_MATCH_ESP
 
 	  To compile it as a module, choose M here.  If unsure, say N.
 
+config NETFILTER_XT_MATCH_HASHLIMIT
+	tristate '"hashlimit" match support'
+	depends on NETFILTER_XTABLES && (IP6_NF_IPTABLES || IP6_NF_IPTABLES=n)
+	depends on NETFILTER_ADVANCED
+	help
+	  This option adds a `hashlimit' match.
+
+	  As opposed to `limit', this match dynamically creates a hash table
+	  of limit buckets, based on your selection of source/destination
+	  addresses and/or ports.
+
+	  It enables you to express policies like `10kpps for any given
+	  destination address' or `500pps from any given source address'
+	  with a single rule.
+
 config NETFILTER_XT_MATCH_HELPER
 	tristate '"helper" match support'
 	depends on NETFILTER_XTABLES
@@ -671,6 +686,17 @@ config NETFILTER_XT_MATCH_MARK
 
 	  To compile it as a module, choose M here.  If unsure, say N.
 
+config NETFILTER_XT_MATCH_MULTIPORT
+	tristate '"multiport" Multiple port match support'
+	depends on NETFILTER_XTABLES
+	depends on NETFILTER_ADVANCED
+	help
+	  Multiport matching allows you to match TCP or UDP packets based on
+	  a series of source or destination ports: normally a rule can only
+	  match a single range of ports.
+
+	  To compile it as a module, choose M here.  If unsure, say N.
+
 config NETFILTER_XT_MATCH_OWNER
 	tristate '"owner" match support'
 	depends on NETFILTER_XTABLES
@@ -691,17 +717,6 @@ config NETFILTER_XT_MATCH_POLICY
 
 	  To compile it as a module, choose M here.  If unsure, say N.
 
-config NETFILTER_XT_MATCH_MULTIPORT
-	tristate '"multiport" Multiple port match support'
-	depends on NETFILTER_XTABLES
-	depends on NETFILTER_ADVANCED
-	help
-	  Multiport matching allows you to match TCP or UDP packets based on
-	  a series of source or destination ports: normally a rule can only
-	  match a single range of ports.
-
-	  To compile it as a module, choose M here.  If unsure, say N.
-
 config NETFILTER_XT_MATCH_PHYSDEV
 	tristate '"physdev" match support'
 	depends on NETFILTER_XTABLES && BRIDGE && BRIDGE_NETFILTER
@@ -884,20 +899,5 @@ config NETFILTER_XT_MATCH_U32
 
 	  Details and examples are in the kernel module source.
 
-config NETFILTER_XT_MATCH_HASHLIMIT
-	tristate '"hashlimit" match support'
-	depends on NETFILTER_XTABLES && (IP6_NF_IPTABLES || IP6_NF_IPTABLES=n)
-	depends on NETFILTER_ADVANCED
-	help
-	  This option adds a `hashlimit' match.
-
-	  As opposed to `limit', this match dynamically creates a hash table
-	  of limit buckets, based on your selection of source/destination
-	  addresses and/or ports.
-
-	  It enables you to express policies like `10kpps for any given
-	  destination address' or `500pps from any given source address'
-	  with a single rule.
-
 endmenu
 
