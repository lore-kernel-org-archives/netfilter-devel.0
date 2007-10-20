From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [PATCH] Remove ipt_TOS
Date: Sat, 20 Oct 2007 13:45:56 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0710201345470.1997@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: kaber@trash.net
To: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:38347 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758451AbXJTLp5 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 20 Oct 2007 07:45:57 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


Removes ipt_TOS since there is now xt_TOS.

Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>

---

 remove include/linux/netfilter_ipv4/ipt_TOS.h
 remove net/ipv4/netfilter/ipt_TOS.c

 net/ipv4/netfilter/Kconfig  |   10 ----------
 net/ipv4/netfilter/Makefile |    1 -
 2 files changed, 11 deletions(-)

Index: gitone/net/ipv4/netfilter/Kconfig
===================================================================
--- gitone.orig/net/ipv4/netfilter/Kconfig
+++ gitone/net/ipv4/netfilter/Kconfig
@@ -302,16 +302,6 @@ config IP_NF_MANGLE
 
 	  To compile it as a module, choose M here.  If unsure, say N.
 
-config IP_NF_TARGET_TOS
-	tristate "TOS target support"
-	depends on IP_NF_MANGLE
-	help
-	  This option adds a `TOS' target, which allows you to create rules in
-	  the `mangle' table which alter the Type Of Service field of an IP
-	  packet prior to routing.
-
-	  To compile it as a module, choose M here.  If unsure, say N.
-
 config IP_NF_TARGET_ECN
 	tristate "ECN target support"
 	depends on IP_NF_MANGLE
Index: gitone/net/ipv4/netfilter/Makefile
===================================================================
--- gitone.orig/net/ipv4/netfilter/Makefile
+++ gitone/net/ipv4/netfilter/Makefile
@@ -58,7 +58,6 @@ obj-$(CONFIG_IP_NF_TARGET_NETMAP) += ipt
 obj-$(CONFIG_IP_NF_TARGET_REDIRECT) += ipt_REDIRECT.o
 obj-$(CONFIG_IP_NF_TARGET_REJECT) += ipt_REJECT.o
 obj-$(CONFIG_IP_NF_TARGET_SAME) += ipt_SAME.o
-obj-$(CONFIG_IP_NF_TARGET_TOS) += ipt_TOS.o
 obj-$(CONFIG_IP_NF_TARGET_TTL) += ipt_TTL.o
 obj-$(CONFIG_IP_NF_TARGET_ULOG) += ipt_ULOG.o
 

