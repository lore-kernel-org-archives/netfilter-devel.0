From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 02/03]: fix forgotten module release in xt_CONNMARK and xt_CONNSECMARK
Date: Fri, 30 Nov 2007 00:57:15 +0100 (MET)
Message-ID: <20071129235706.10108.75994.sendpatchset@localhost.localdomain>
References: <20071129235703.10108.7960.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:60354 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763596AbXK2X5Q (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 29 Nov 2007 18:57:16 -0500
In-Reply-To: <20071129235703.10108.7960.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

[NETFILTER]: fix forgotten module release in xt_CONNMARK and xt_CONNSECMARK

Fix forgotten module release in xt_CONNMARK and xt_CONNSECMARK

When xt_CONNMARK is used outside the mangle table and the user specified
"--restore-mark", the connmark_tg_check() function will (correctly)
error out, but (incorrectly) forgets to release the L3 conntrack module.
Same for xt_CONNSECMARK.

Fix is to move the call to acquire the L3 module after the basic
constraint checks.

Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 7f6c4730c53415caee7cb0ed4c1adad48de3bb07
tree 0a05c965d3e4a9a01586045991626c23b14fedca
parent 6d3d8a9e26a4322f7f6f2601742f7a669585f338
author Jan Engelhardt <jengelh@computergmbh.de> Thu, 29 Nov 2007 23:18:23 +0100
committer Patrick McHardy <kaber@trash.net> Thu, 29 Nov 2007 23:27:40 +0100

 net/netfilter/xt_CONNMARK.c    |   10 +++++-----
 net/netfilter/xt_CONNSECMARK.c |   10 +++++-----
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/net/netfilter/xt_CONNMARK.c b/net/netfilter/xt_CONNMARK.c
index 856793e..0621ca7 100644
--- a/net/netfilter/xt_CONNMARK.c
+++ b/net/netfilter/xt_CONNMARK.c
@@ -86,11 +86,6 @@ checkentry(const char *tablename,
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
@@ -103,6 +98,11 @@ checkentry(const char *tablename,
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
 
diff --git a/net/netfilter/xt_CONNSECMARK.c b/net/netfilter/xt_CONNSECMARK.c
index 021b5c8..d8feba9 100644
--- a/net/netfilter/xt_CONNSECMARK.c
+++ b/net/netfilter/xt_CONNSECMARK.c
@@ -90,11 +90,6 @@ static bool checkentry(const char *tablename, const void *entry,
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
@@ -105,6 +100,11 @@ static bool checkentry(const char *tablename, const void *entry,
 		return false;
 	}
 
+	if (nf_ct_l3proto_try_module_get(target->family) < 0) {
+		printk(KERN_WARNING "can't load conntrack support for "
+				    "proto=%d\n", target->family);
+		return false;
+	}
 	return true;
 }
 
