From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 09/49]: Use lowercase names for matches in Kconfig
Date: Tue,  4 Dec 2007 13:02:08 +0100 (MET)
Message-ID: <20071204120208.2442.73709.sendpatchset@localhost.localdomain>
References: <20071204120154.2442.91626.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:62124 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752764AbXLDMCJ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Dec 2007 07:02:09 -0500
In-Reply-To: <20071204120154.2442.91626.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: Use lowercase names for matches in Kconfig

Unify netfilter match kconfig descriptions

Consistently use lowercase for matches in kconfig one-line
descriptions and name the match module.

Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 08d5ebfa5d171ca207ccdd5086cc86eadf99ebea
tree 340cba3958d37cea7bf68e3a1e5fd49009f1a79c
parent aaa25832938c3900fc8711fc45dc753bc2885d06
author Jan Engelhardt <jengelh@computergmbh.de> Tue, 04 Dec 2007 10:47:01 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 04 Dec 2007 11:23:07 +0100

 net/ipv4/netfilter/Kconfig |   12 ++++++------
 net/ipv6/netfilter/Kconfig |   16 ++++++++--------
 net/netfilter/Kconfig      |    8 ++++----
 3 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/net/ipv4/netfilter/Kconfig b/net/ipv4/netfilter/Kconfig
index 6c563d9..244e91d 100644
--- a/net/ipv4/netfilter/Kconfig
+++ b/net/ipv4/netfilter/Kconfig
@@ -55,7 +55,7 @@ config IP_NF_IPTABLES
 
 # The matches.
 config IP_NF_MATCH_IPRANGE
-	tristate "IP range match support"
+	tristate '"iprange" match support'
 	depends on IP_NF_IPTABLES
 	help
 	  This option makes possible to match IP addresses against IP address
@@ -73,7 +73,7 @@ config IP_NF_MATCH_TOS
 	  To compile it as a module, choose M here.  If unsure, say N.
 
 config IP_NF_MATCH_RECENT
-	tristate "recent match support"
+	tristate '"recent" match support'
 	depends on IP_NF_IPTABLES
 	help
 	  This match is used for creating one or many lists of recently
@@ -85,7 +85,7 @@ config IP_NF_MATCH_RECENT
 	  To compile it as a module, choose M here.  If unsure, say N.
 
 config IP_NF_MATCH_ECN
-	tristate "ECN match support"
+	tristate '"ecn" match support'
 	depends on IP_NF_IPTABLES
 	help
 	  This option adds a `ECN' match, which allows you to match against
@@ -94,7 +94,7 @@ config IP_NF_MATCH_ECN
 	  To compile it as a module, choose M here.  If unsure, say N.
 
 config IP_NF_MATCH_AH
-	tristate "AH match support"
+	tristate '"ah" match support'
 	depends on IP_NF_IPTABLES
 	help
 	  This match extension allows you to match a range of SPIs
@@ -103,7 +103,7 @@ config IP_NF_MATCH_AH
 	  To compile it as a module, choose M here.  If unsure, say N.
 
 config IP_NF_MATCH_TTL
-	tristate "TTL match support"
+	tristate '"ttl" match support'
 	depends on IP_NF_IPTABLES
 	help
 	  This adds CONFIG_IP_NF_MATCH_TTL option, which enabled the user
@@ -112,7 +112,7 @@ config IP_NF_MATCH_TTL
 	  To compile it as a module, choose M here.  If unsure, say N.
 
 config IP_NF_MATCH_ADDRTYPE
-	tristate  'address type match support'
+	tristate '"addrtype" address type match support'
 	depends on IP_NF_IPTABLES
 	help
 	  This option allows you to match what routing thinks of an address,
diff --git a/net/ipv6/netfilter/Kconfig b/net/ipv6/netfilter/Kconfig
index 30d4852..5374c66 100644
--- a/net/ipv6/netfilter/Kconfig
+++ b/net/ipv6/netfilter/Kconfig
@@ -54,7 +54,7 @@ config IP6_NF_IPTABLES
 
 # The simple matches.
 config IP6_NF_MATCH_RT
-	tristate "Routing header match support"
+	tristate '"rt" Routing header match support'
 	depends on IP6_NF_IPTABLES
 	help
 	  rt matching allows you to match packets based on the routing
@@ -63,7 +63,7 @@ config IP6_NF_MATCH_RT
 	  To compile it as a module, choose M here.  If unsure, say N.
 
 config IP6_NF_MATCH_OPTS
-	tristate "Hop-by-hop and Dst opts header match support"
+	tristate '"hopbyhop" and "dst" opts header match support'
 	depends on IP6_NF_IPTABLES
 	help
 	  This allows one to match packets based on the hop-by-hop
@@ -72,7 +72,7 @@ config IP6_NF_MATCH_OPTS
 	  To compile it as a module, choose M here.  If unsure, say N.
 
 config IP6_NF_MATCH_FRAG
-	tristate "Fragmentation header match support"
+	tristate '"frag" Fragmentation header match support'
 	depends on IP6_NF_IPTABLES
 	help
 	  frag matching allows you to match packets based on the fragmentation
@@ -81,7 +81,7 @@ config IP6_NF_MATCH_FRAG
 	  To compile it as a module, choose M here.  If unsure, say N.
 
 config IP6_NF_MATCH_HL
-	tristate "HL match support"
+	tristate '"hl" match support'
 	depends on IP6_NF_IPTABLES
 	help
 	  HL matching allows you to match packets based on the hop
@@ -90,7 +90,7 @@ config IP6_NF_MATCH_HL
 	  To compile it as a module, choose M here.  If unsure, say N.
 
 config IP6_NF_MATCH_IPV6HEADER
-	tristate "IPv6 Extension Headers Match"
+	tristate '"ipv6header" IPv6 Extension Headers Match'
 	depends on IP6_NF_IPTABLES
 	help
 	  This module allows one to match packets based upon
@@ -99,7 +99,7 @@ config IP6_NF_MATCH_IPV6HEADER
 	  To compile it as a module, choose M here.  If unsure, say N.
 
 config IP6_NF_MATCH_AH
-	tristate "AH match support"
+	tristate '"ah" match support'
 	depends on IP6_NF_IPTABLES
 	help
 	  This module allows one to match AH packets.
@@ -107,7 +107,7 @@ config IP6_NF_MATCH_AH
 	  To compile it as a module, choose M here.  If unsure, say N.
 
 config IP6_NF_MATCH_MH
-	tristate "MH match support"
+	tristate '"mh" match support'
 	depends on IP6_NF_IPTABLES
 	help
 	  This module allows one to match MH packets.
@@ -115,7 +115,7 @@ config IP6_NF_MATCH_MH
 	  To compile it as a module, choose M here.  If unsure, say N.
 
 config IP6_NF_MATCH_EUI64
-	tristate "EUI64 address check"
+	tristate '"eui64" address check'
 	depends on IP6_NF_IPTABLES
 	help
 	  This module performs checking on the IPv6 source address
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 4bc0552..d220607 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -476,7 +476,7 @@ config NETFILTER_XT_MATCH_CONNTRACK
 	  To compile it as a module, choose M here.  If unsure, say N.
 
 config NETFILTER_XT_MATCH_DCCP
-	tristate  '"DCCP" protocol match support'
+	tristate '"dccp" protocol match support'
 	depends on NETFILTER_XTABLES
 	help
 	  With this option enabled, you will be able to use the iptables
@@ -487,7 +487,7 @@ config NETFILTER_XT_MATCH_DCCP
 	  <file:Documentation/kbuild/modules.txt>.  If unsure, say `N'.
 
 config NETFILTER_XT_MATCH_DSCP
-	tristate '"DSCP" match support'
+	tristate '"dscp" match support'
 	depends on NETFILTER_XTABLES
 	help
 	  This option adds a `DSCP' match, which allows you to match against
@@ -498,7 +498,7 @@ config NETFILTER_XT_MATCH_DSCP
 	  To compile it as a module, choose M here.  If unsure, say N.
 
 config NETFILTER_XT_MATCH_ESP
-	tristate '"ESP" match support'
+	tristate '"esp" match support'
 	depends on NETFILTER_XTABLES
 	help
 	  This match extension allows you to match a range of SPIs
@@ -573,7 +573,7 @@ config NETFILTER_XT_MATCH_POLICY
 	  To compile it as a module, choose M here.  If unsure, say N.
 
 config NETFILTER_XT_MATCH_MULTIPORT
-	tristate "Multiple port match support"
+	tristate '"multiport" Multiple port match support'
 	depends on NETFILTER_XTABLES
 	help
 	  Multiport matching allows you to match TCP or UDP packets based on
