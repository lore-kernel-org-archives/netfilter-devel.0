From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [PATCH 1/7] Use %u format specifiers
Date: Fri, 7 Dec 2007 03:35:59 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0712070335240.1262@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:39365 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753037AbXLGCgA (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 6 Dec 2007 21:36:00 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Use %u format specifiers as ->family is unsigned.

Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>

---
 net/ipv4/netfilter/ipt_CLUSTERIP.c |    2 +-
 net/netfilter/xt_CONNMARK.c        |    2 +-
 net/netfilter/xt_CONNSECMARK.c     |    2 +-
 net/netfilter/xt_connbytes.c       |    2 +-
 net/netfilter/xt_connmark.c        |    2 +-
 net/netfilter/xt_conntrack.c       |    2 +-
 net/netfilter/xt_helper.c          |    2 +-
 net/netfilter/xt_state.c           |    2 +-
 8 files changed, 8 insertions(+), 8 deletions(-)

Index: linux-2.6/net/ipv4/netfilter/ipt_CLUSTERIP.c
===================================================================
--- linux-2.6.orig/net/ipv4/netfilter/ipt_CLUSTERIP.c
+++ linux-2.6/net/ipv4/netfilter/ipt_CLUSTERIP.c
@@ -414,7 +414,7 @@ clusterip_tg_check(const char *tablename
 
 	if (nf_ct_l3proto_try_module_get(target->family) < 0) {
 		printk(KERN_WARNING "can't load conntrack support for "
-				    "proto=%d\n", target->family);
+				    "proto=%u\n", target->family);
 		return false;
 	}
 
Index: linux-2.6/net/netfilter/xt_CONNMARK.c
===================================================================
--- linux-2.6.orig/net/netfilter/xt_CONNMARK.c
+++ linux-2.6/net/netfilter/xt_CONNMARK.c
@@ -95,7 +95,7 @@ connmark_tg_check(const char *tablename,
 	}
 	if (nf_ct_l3proto_try_module_get(target->family) < 0) {
 		printk(KERN_WARNING "can't load conntrack support for "
-				    "proto=%d\n", target->family);
+				    "proto=%u\n", target->family);
 		return false;
 	}
 	return true;
Index: linux-2.6/net/netfilter/xt_CONNSECMARK.c
===================================================================
--- linux-2.6.orig/net/netfilter/xt_CONNSECMARK.c
+++ linux-2.6/net/netfilter/xt_CONNSECMARK.c
@@ -103,7 +103,7 @@ connsecmark_tg_check(const char *tablena
 
 	if (nf_ct_l3proto_try_module_get(target->family) < 0) {
 		printk(KERN_WARNING "can't load conntrack support for "
-				    "proto=%d\n", target->family);
+				    "proto=%u\n", target->family);
 		return false;
 	}
 	return true;
Index: linux-2.6/net/netfilter/xt_connbytes.c
===================================================================
--- linux-2.6.orig/net/netfilter/xt_connbytes.c
+++ linux-2.6/net/netfilter/xt_connbytes.c
@@ -111,7 +111,7 @@ connbytes_mt_check(const char *tablename
 
 	if (nf_ct_l3proto_try_module_get(match->family) < 0) {
 		printk(KERN_WARNING "can't load conntrack support for "
-				    "proto=%d\n", match->family);
+				    "proto=%u\n", match->family);
 		return false;
 	}
 
Index: linux-2.6/net/netfilter/xt_connmark.c
===================================================================
--- linux-2.6.orig/net/netfilter/xt_connmark.c
+++ linux-2.6/net/netfilter/xt_connmark.c
@@ -61,7 +61,7 @@ connmark_mt_check(const char *tablename,
 	}
 	if (nf_ct_l3proto_try_module_get(match->family) < 0) {
 		printk(KERN_WARNING "can't load conntrack support for "
-				    "proto=%d\n", match->family);
+				    "proto=%u\n", match->family);
 		return false;
 	}
 	return true;
Index: linux-2.6/net/netfilter/xt_conntrack.c
===================================================================
--- linux-2.6.orig/net/netfilter/xt_conntrack.c
+++ linux-2.6/net/netfilter/xt_conntrack.c
@@ -117,7 +117,7 @@ conntrack_mt_check(const char *tablename
 {
 	if (nf_ct_l3proto_try_module_get(match->family) < 0) {
 		printk(KERN_WARNING "can't load conntrack support for "
-				    "proto=%d\n", match->family);
+				    "proto=%u\n", match->family);
 		return false;
 	}
 	return true;
Index: linux-2.6/net/netfilter/xt_helper.c
===================================================================
--- linux-2.6.orig/net/netfilter/xt_helper.c
+++ linux-2.6/net/netfilter/xt_helper.c
@@ -66,7 +66,7 @@ helper_mt_check(const char *tablename, c
 
 	if (nf_ct_l3proto_try_module_get(match->family) < 0) {
 		printk(KERN_WARNING "can't load conntrack support for "
-				    "proto=%d\n", match->family);
+				    "proto=%u\n", match->family);
 		return false;
 	}
 	info->name[29] = '\0';
Index: linux-2.6/net/netfilter/xt_state.c
===================================================================
--- linux-2.6.orig/net/netfilter/xt_state.c
+++ linux-2.6/net/netfilter/xt_state.c
@@ -47,7 +47,7 @@ state_mt_check(const char *tablename, co
 {
 	if (nf_ct_l3proto_try_module_get(match->family) < 0) {
 		printk(KERN_WARNING "can't load conntrack support for "
-				    "proto=%d\n", match->family);
+				    "proto=%u\n", match->family);
 		return false;
 	}
 	return true;

