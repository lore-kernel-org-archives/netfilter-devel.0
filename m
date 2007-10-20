From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [PATCH] remove ipt_owner
Date: Sat, 20 Oct 2007 13:46:07 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0710201345560.1997@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: kaber@trash.net
To: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:38356 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758559AbXJTLqI (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 20 Oct 2007 07:46:08 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


Removes ipt_owner since there is now xt_owner.

Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>

---
 net/ipv4/netfilter/Kconfig  |    9 ---------
 net/ipv4/netfilter/Makefile |    1 -
 2 files changed, 10 deletions(-)

Index: gitone/net/ipv4/netfilter/Kconfig
===================================================================
--- gitone.orig/net/ipv4/netfilter/Kconfig
+++ gitone/net/ipv4/netfilter/Kconfig
@@ -102,15 +102,6 @@ config IP_NF_MATCH_TTL
 
 	  To compile it as a module, choose M here.  If unsure, say N.
 
-config IP_NF_MATCH_OWNER
-	tristate "Owner match support"
-	depends on IP_NF_IPTABLES
-	help
-	  Packet owner matching allows you to match locally-generated packets
-	  based on who created them: the user, group, process or session.
-
-	  To compile it as a module, choose M here.  If unsure, say N.
-
 config IP_NF_MATCH_ADDRTYPE
 	tristate  'address type match support'
 	depends on IP_NF_IPTABLES
Index: gitone/net/ipv4/netfilter/Makefile
===================================================================
--- gitone.orig/net/ipv4/netfilter/Makefile
+++ gitone/net/ipv4/netfilter/Makefile
@@ -45,7 +45,6 @@ obj-$(CONFIG_IP_NF_MATCH_ADDRTYPE) += ip
 obj-$(CONFIG_IP_NF_MATCH_AH) += ipt_ah.o
 obj-$(CONFIG_IP_NF_MATCH_ECN) += ipt_ecn.o
 obj-$(CONFIG_IP_NF_MATCH_IPRANGE) += ipt_iprange.o
-obj-$(CONFIG_IP_NF_MATCH_OWNER) += ipt_owner.o
 obj-$(CONFIG_IP_NF_MATCH_RECENT) += ipt_recent.o
 obj-$(CONFIG_IP_NF_MATCH_TTL) += ipt_ttl.o
 

