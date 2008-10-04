From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 05/16] [NETFILTER]: Fix Kconfig entry dependency for ip6t_LOG
Date: Sat,  4 Oct 2008 15:41:19 -0400
Message-ID: <c975fcce712055d4381e6ee11a605e08de1e7030.1223149287.git.jengelh@medozas.de>
References: <67e1140a1db2e8aa9a4b6c80289039487c5445cb.1223149287.git.jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:34303 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753248AbYJDTld (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 4 Oct 2008 15:41:33 -0400
In-Reply-To: <67e1140a1db2e8aa9a4b6c80289039487c5445cb.1223149287.git.jengelh@medozas.de>
In-Reply-To: <67e1140a1db2e8aa9a4b6c80289039487c5445cb.1223149287.git.jengelh@medozas.de>
References: <67e1140a1db2e8aa9a4b6c80289039487c5445cb.1223149287.git.jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

ip6t_LOG does certainly not depend on the filter table.
(Also, move it so that menuconfig still displays it correctly.)

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 net/ipv6/netfilter/Kconfig |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)

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
 
-- 
1.6.0.1

