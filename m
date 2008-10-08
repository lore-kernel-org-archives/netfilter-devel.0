From: Patrick McHardy <kaber@trash.net>
Subject: netfilter 66/79: ip6tables: fix Kconfig entry dependency for ip6t_LOG
Date: Wed,  8 Oct 2008 12:47:50 +0200 (MEST)
Message-ID: <20081008104750.10423.28261.sendpatchset@x2.localnet>
References: <20081008104621.10423.12648.sendpatchset@x2.localnet>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:46058 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754788AbYJHKrv (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 8 Oct 2008 06:47:51 -0400
In-Reply-To: <20081008104621.10423.12648.sendpatchset@x2.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit 2203eb47603b01b15a4b1d5b1c7886da96158e74
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Wed Oct 8 11:35:17 2008 +0200

    netfilter: ip6tables: fix Kconfig entry dependency for ip6t_LOG
    
    ip6t_LOG does certainly not depend on the filter table.
    (Also, move it so that menuconfig still displays it correctly.)
    
    Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
    Signed-off-by: Patrick McHardy <kaber@trash.net>

diff --git a/net/ipv6/netfilter/Kconfig b/net/ipv6/netfilter/Kconfig
index f244324..fee881b 100644
--- a/net/ipv6/netfilter/Kconfig
+++ b/net/ipv6/netfilter/Kconfig
@@ -136,24 +136,24 @@ config IP6_NF_MATCH_EUI64
 	  To compile it as a module, choose M here.  If unsure, say N.
 
 # The targets
-config IP6_NF_FILTER
-	tristate "Packet filtering"
+config IP6_NF_TARGET_LOG
+	tristate "LOG target support"
 	depends on IP6_NF_IPTABLES
 	default m if NETFILTER_ADVANCED=n
 	help
-	  Packet filtering defines a table `filter', which has a series of
-	  rules for simple packet filtering at local input, forwarding and
-	  local output.  See the man page for iptables(8).
+	  This option adds a `LOG' target, which allows you to create rules in
+	  any iptables table which records the packet header to the syslog.
 
 	  To compile it as a module, choose M here.  If unsure, say N.
 
-config IP6_NF_TARGET_LOG
-	tristate "LOG target support"
-	depends on IP6_NF_FILTER
+config IP6_NF_FILTER
+	tristate "Packet filtering"
+	depends on IP6_NF_IPTABLES
 	default m if NETFILTER_ADVANCED=n
 	help
-	  This option adds a `LOG' target, which allows you to create rules in
-	  any iptables table which records the packet header to the syslog.
+	  Packet filtering defines a table `filter', which has a series of
+	  rules for simple packet filtering at local input, forwarding and
+	  local output.  See the man page for iptables(8).
 
 	  To compile it as a module, choose M here.  If unsure, say N.
 
