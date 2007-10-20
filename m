From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [PATCH] remove ipt_tos
Date: Sat, 20 Oct 2007 13:45:45 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0710201345340.1997@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: kaber@trash.net
To: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:38336 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758287AbXJTLpq (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 20 Oct 2007 07:45:46 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


Removes ipt_tos since there is now xt_tos.

Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>

---

 remove include/linux/netfilter_ipv4/ipt_tos.h
 remove net/ipv4/netfilter/ipt_tos.c

 net/ipv4/netfilter/Kconfig  |    9 ---------
 net/ipv4/netfilter/Makefile |    1 -
 2 files changed, 10 deletions(-)

Index: gitone/net/ipv4/netfilter/Kconfig
===================================================================
--- gitone.orig/net/ipv4/netfilter/Kconfig
+++ gitone/net/ipv4/netfilter/Kconfig
@@ -63,15 +63,6 @@ config IP_NF_MATCH_IPRANGE
 
 	  To compile it as a module, choose M here.  If unsure, say N.
 
-config IP_NF_MATCH_TOS
-	tristate "TOS match support"
-	depends on IP_NF_IPTABLES
-	help
-	  TOS matching allows you to match packets based on the Type Of
-	  Service fields of the IP packet.
-
-	  To compile it as a module, choose M here.  If unsure, say N.
-
 config IP_NF_MATCH_RECENT
 	tristate "recent match support"
 	depends on IP_NF_IPTABLES
Index: gitone/net/ipv4/netfilter/Makefile
===================================================================
--- gitone.orig/net/ipv4/netfilter/Makefile
+++ gitone/net/ipv4/netfilter/Makefile
@@ -47,7 +47,6 @@ obj-$(CONFIG_IP_NF_MATCH_ECN) += ipt_ecn
 obj-$(CONFIG_IP_NF_MATCH_IPRANGE) += ipt_iprange.o
 obj-$(CONFIG_IP_NF_MATCH_OWNER) += ipt_owner.o
 obj-$(CONFIG_IP_NF_MATCH_RECENT) += ipt_recent.o
-obj-$(CONFIG_IP_NF_MATCH_TOS) += ipt_tos.o
 obj-$(CONFIG_IP_NF_MATCH_TTL) += ipt_ttl.o
 
 # targets

