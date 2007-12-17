From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 57/64]: x_tables: use %u format specifiers
Date: Tue, 18 Dec 2007 00:47:30 +0100 (MET)
Message-ID: <20071217234730.23601.21553.sendpatchset@localhost.localdomain>
References: <20071217234612.23601.6979.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:39058 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933088AbXLQXrc (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Dec 2007 18:47:32 -0500
In-Reply-To: <20071217234612.23601.6979.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: x_tables: use %u format specifiers

Use %u format specifiers as ->family is unsigned.

Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 92c790e129d05df719f233ac8f4e45d736304b23
tree 05c76f78defe79f1dfa54036a9a584356ebce6ae
parent 47ebc04c5a75d528fe66549793aec32cb2d9e444
author Jan Engelhardt <jengelh@computergmbh.de> Mon, 17 Dec 2007 14:58:51 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 18 Dec 2007 00:25:00 +0100

 net/ipv4/netfilter/ipt_CLUSTERIP.c |    2 +-
 net/netfilter/xt_CONNMARK.c        |    2 +-
 net/netfilter/xt_CONNSECMARK.c     |    2 +-
 net/netfilter/xt_connbytes.c       |    2 +-
 net/netfilter/xt_connmark.c        |    2 +-
 net/netfilter/xt_conntrack.c       |    2 +-
 net/netfilter/xt_helper.c          |    2 +-
 net/netfilter/xt_state.c           |    2 +-
 8 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/net/ipv4/netfilter/ipt_CLUSTERIP.c b/net/ipv4/netfilter/ipt_CLUSTERIP.c
index dc1e7b4..a48e264 100644
--- a/net/ipv4/netfilter/ipt_CLUSTERIP.c
+++ b/net/ipv4/netfilter/ipt_CLUSTERIP.c
@@ -414,7 +414,7 @@ clusterip_tg_check(const char *tablename, const void *e_void,
 
 	if (nf_ct_l3proto_try_module_get(target->family) < 0) {
 		printk(KERN_WARNING "can't load conntrack support for "
-				    "proto=%d\n", target->family);
+				    "proto=%u\n", target->family);
 		return false;
 	}
 
diff --git a/net/netfilter/xt_CONNMARK.c b/net/netfilter/xt_CONNMARK.c
index d96ee3e..ec2eb34 100644
--- a/net/netfilter/xt_CONNMARK.c
+++ b/net/netfilter/xt_CONNMARK.c
@@ -95,7 +95,7 @@ connmark_tg_check(const char *tablename, const void *entry,
 	}
 	if (nf_ct_l3proto_try_module_get(target->family) < 0) {
 		printk(KERN_WARNING "can't load conntrack support for "
-				    "proto=%d\n", target->family);
+				    "proto=%u\n", target->family);
 		return false;
 	}
 	return true;
diff --git a/net/netfilter/xt_CONNSECMARK.c b/net/netfilter/xt_CONNSECMARK.c
index 2333f7e..024106b 100644
--- a/net/netfilter/xt_CONNSECMARK.c
+++ b/net/netfilter/xt_CONNSECMARK.c
@@ -106,7 +106,7 @@ connsecmark_tg_check(const char *tablename, const void *entry,
 
 	if (nf_ct_l3proto_try_module_get(target->family) < 0) {
 		printk(KERN_WARNING "can't load conntrack support for "
-				    "proto=%d\n", target->family);
+				    "proto=%u\n", target->family);
 		return false;
 	}
 	return true;
diff --git a/net/netfilter/xt_connbytes.c b/net/netfilter/xt_connbytes.c
index 752b7d8..7d4940a 100644
--- a/net/netfilter/xt_connbytes.c
+++ b/net/netfilter/xt_connbytes.c
@@ -111,7 +111,7 @@ connbytes_mt_check(const char *tablename, const void *ip,
 
 	if (nf_ct_l3proto_try_module_get(match->family) < 0) {
 		printk(KERN_WARNING "can't load conntrack support for "
-				    "proto=%d\n", match->family);
+				    "proto=%u\n", match->family);
 		return false;
 	}
 
diff --git a/net/netfilter/xt_connmark.c b/net/netfilter/xt_connmark.c
index b5c0f2f..8ad875b 100644
--- a/net/netfilter/xt_connmark.c
+++ b/net/netfilter/xt_connmark.c
@@ -61,7 +61,7 @@ connmark_mt_check(const char *tablename, const void *ip,
 	}
 	if (nf_ct_l3proto_try_module_get(match->family) < 0) {
 		printk(KERN_WARNING "can't load conntrack support for "
-				    "proto=%d\n", match->family);
+				    "proto=%u\n", match->family);
 		return false;
 	}
 	return true;
diff --git a/net/netfilter/xt_conntrack.c b/net/netfilter/xt_conntrack.c
index eb7e135..8c1d448 100644
--- a/net/netfilter/xt_conntrack.c
+++ b/net/netfilter/xt_conntrack.c
@@ -117,7 +117,7 @@ conntrack_mt_check(const char *tablename, const void *ip,
 {
 	if (nf_ct_l3proto_try_module_get(match->family) < 0) {
 		printk(KERN_WARNING "can't load conntrack support for "
-				    "proto=%d\n", match->family);
+				    "proto=%u\n", match->family);
 		return false;
 	}
 	return true;
diff --git a/net/netfilter/xt_helper.c b/net/netfilter/xt_helper.c
index 2b19e36..8e06ca1 100644
--- a/net/netfilter/xt_helper.c
+++ b/net/netfilter/xt_helper.c
@@ -66,7 +66,7 @@ helper_mt_check(const char *tablename, const void *inf,
 
 	if (nf_ct_l3proto_try_module_get(match->family) < 0) {
 		printk(KERN_WARNING "can't load conntrack support for "
-				    "proto=%d\n", match->family);
+				    "proto=%u\n", match->family);
 		return false;
 	}
 	info->name[29] = '\0';
diff --git a/net/netfilter/xt_state.c b/net/netfilter/xt_state.c
index 2e1716d..a776dc3 100644
--- a/net/netfilter/xt_state.c
+++ b/net/netfilter/xt_state.c
@@ -47,7 +47,7 @@ state_mt_check(const char *tablename, const void *inf,
 {
 	if (nf_ct_l3proto_try_module_get(match->family) < 0) {
 		printk(KERN_WARNING "can't load conntrack support for "
-				    "proto=%d\n", match->family);
+				    "proto=%u\n", match->family);
 		return false;
 	}
 	return true;
