From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [PATCH] Fix forgotten module release in xt_CONNMARK and xt_CONNSECMARK
Date: Thu, 29 Nov 2007 23:18:23 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0711292314110.3089@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	davem@davemloft.net, stable@kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:44715 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756686AbXK2WSZ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 29 Nov 2007 17:18:25 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


This one is against davem's net-2.6.25 branch.

===Begins here===

Fix forgotten module release in xt_CONNMARK and xt_CONNSECMARK


When xt_CONNMARK is used outside the mangle table and the user specified
"--restore-mark", the connmark_tg_check() function will (correctly)
error out, but (incorrectly) forgets to release the L3 conntrack module.
Same for xt_CONNSECMARK.
Fix is to move the call to acquire the L3 module after the basic 
constraint checks.

Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>

---
 net/netfilter/xt_CONNMARK.c    |   10 +++++-----
 net/netfilter/xt_CONNSECMARK.c |   10 +++++-----
 2 files changed, 10 insertions(+), 10 deletions(-)

Index: linux-2.6/net/netfilter/xt_CONNMARK.c
===================================================================
--- linux-2.6.orig/net/netfilter/xt_CONNMARK.c
+++ linux-2.6/net/netfilter/xt_CONNMARK.c
@@ -81,11 +81,6 @@ connmark_tg_check(const char *tablename,
 {
 	const struct xt_connmark_target_info *matchinfo = targinfo;
 
-	if (nf_ct_l3proto_try_module_get(target->family) < 0) {
-		printk(KERN_WARNING "can't load conntrack support for "
-				    "proto=%d\n", target->family);
-		return false;
-	}
 	if (matchinfo->mode == XT_CONNMARK_RESTORE) {
 		if (strcmp(tablename, "mangle") != 0) {
 			printk(KERN_WARNING "CONNMARK: restore can only be "
@@ -98,6 +93,11 @@ connmark_tg_check(const char *tablename,
 		printk(KERN_WARNING "CONNMARK: Only supports 32bit mark\n");
 		return false;
 	}
+	if (nf_ct_l3proto_try_module_get(target->family) < 0) {
+		printk(KERN_WARNING "can't load conntrack support for "
+				    "proto=%d\n", target->family);
+		return false;
+	}
 	return true;
 }
 
Index: linux-2.6/net/netfilter/xt_CONNSECMARK.c
===================================================================
--- linux-2.6.orig/net/netfilter/xt_CONNSECMARK.c
+++ linux-2.6/net/netfilter/xt_CONNSECMARK.c
@@ -91,11 +91,6 @@ connsecmark_tg_check(const char *tablena
 {
 	const struct xt_connsecmark_target_info *info = targinfo;
 
-	if (nf_ct_l3proto_try_module_get(target->family) < 0) {
-		printk(KERN_WARNING "can't load conntrack support for "
-				    "proto=%d\n", target->family);
-		return false;
-	}
 	switch (info->mode) {
 	case CONNSECMARK_SAVE:
 	case CONNSECMARK_RESTORE:
@@ -106,6 +101,11 @@ connsecmark_tg_check(const char *tablena
 		return false;
 	}
 
+	if (nf_ct_l3proto_try_module_get(target->family) < 0) {
+		printk(KERN_WARNING "can't load conntrack support for "
+				    "proto=%d\n", target->family);
+		return false;
+	}
 	return true;
 }
 

