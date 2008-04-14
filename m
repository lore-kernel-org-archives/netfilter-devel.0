From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 13/41]: remove arpt_(un)register_target indirection macros
Date: Mon, 14 Apr 2008 12:16:36 +0200 (MEST)
Message-ID: <20080414101632.32717.23835.sendpatchset@localhost.localdomain>
References: <20080414101614.32717.35526.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:36269 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751921AbYDNKQh (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Apr 2008 06:16:37 -0400
In-Reply-To: <20080414101614.32717.35526.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: remove arpt_(un)register_target indirection macros

Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 1915da7080f836cb560552d3a5949eee60fb6e5e
tree 3765c53fcc167a7faf2964f0f1a4530a130e4c7e
parent 6e5de8e607daf200cab5e3061903ba71b825324f
author Jan Engelhardt <jengelh@computergmbh.de> Mon, 14 Apr 2008 12:10:46 +0200
committer Patrick McHardy <kaber@trash.net> Mon, 14 Apr 2008 12:10:46 +0200

 include/linux/netfilter_arp/arp_tables.h |    5 -----
 net/ipv4/netfilter/arpt_mangle.c         |    8 +++-----
 2 files changed, 3 insertions(+), 10 deletions(-)

diff --git a/include/linux/netfilter_arp/arp_tables.h b/include/linux/netfilter_arp/arp_tables.h
index 782b83e..dd9c97f 100644
--- a/include/linux/netfilter_arp/arp_tables.h
+++ b/include/linux/netfilter_arp/arp_tables.h
@@ -264,11 +264,6 @@ struct arpt_error
 	.target.errorname = "ERROR",					       \
 }
 
-#define arpt_register_target(tgt) 	\
-({	(tgt)->family = NF_ARP;		\
- 	xt_register_target(tgt); })
-#define arpt_unregister_target(tgt) xt_unregister_target(tgt)
-
 extern struct xt_table *arpt_register_table(struct net *net,
 					    struct xt_table *table,
 					    const struct arpt_replace *repl);
diff --git a/net/ipv4/netfilter/arpt_mangle.c b/net/ipv4/netfilter/arpt_mangle.c
index f9c102a..a385959 100644
--- a/net/ipv4/netfilter/arpt_mangle.c
+++ b/net/ipv4/netfilter/arpt_mangle.c
@@ -75,6 +75,7 @@ checkentry(const char *tablename, const void *e, const struct xt_target *target,
 
 static struct xt_target arpt_mangle_reg __read_mostly = {
 	.name		= "mangle",
+	.family		= NF_ARP,
 	.target		= target,
 	.targetsize	= sizeof(struct arpt_mangle),
 	.checkentry	= checkentry,
@@ -83,15 +84,12 @@ static struct xt_target arpt_mangle_reg __read_mostly = {
 
 static int __init arpt_mangle_init(void)
 {
-	if (arpt_register_target(&arpt_mangle_reg))
-		return -EINVAL;
-
-	return 0;
+	return xt_register_target(&arpt_mangle_reg);
 }
 
 static void __exit arpt_mangle_fini(void)
 {
-	arpt_unregister_target(&arpt_mangle_reg);
+	xt_unregister_target(&arpt_mangle_reg);
 }
 
 module_init(arpt_mangle_init);
