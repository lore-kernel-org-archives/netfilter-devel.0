From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [PATCH 11/21] [NETFILTER]: remove arpt_(un)register_target indirection
 macros
Date: Tue, 4 Mar 2008 17:34:12 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0803041733460.7660@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0803040519150.7660@fbirervta.pbzchgretzou.qr>
 <47CD6296.90303@trash.net> <Pine.LNX.4.64.0803041630440.7660@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:47324 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765653AbYCDQeO (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Mar 2008 11:34:14 -0500
In-Reply-To: <Pine.LNX.4.64.0803041630440.7660@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit 2db5fb8a2523983a12f2193f620208cc83d87c46
Author: Jan Engelhardt <jengelh@computergmbh.de>
Date:   Sat Feb 9 00:45:44 2008 +0100

    [NETFILTER]: remove arpt_(un)register_target indirection macros
    
    Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
---
 include/linux/netfilter_arp/arp_tables.h |    5 -----
 net/ipv4/netfilter/arpt_mangle.c         |    8 +++-----
 2 files changed, 3 insertions(+), 10 deletions(-)

diff --git a/include/linux/netfilter_arp/arp_tables.h b/include/linux/netfilter_arp/arp_tables.h
index 1cb698b..493dcd2 100644
--- a/include/linux/netfilter_arp/arp_tables.h
+++ b/include/linux/netfilter_arp/arp_tables.h
@@ -259,11 +259,6 @@ struct arpt_error
 	.target.errorname = "ERROR",					       \
 }
 
-#define arpt_register_target(tgt) 	\
-({	(tgt)->family = NF_ARP;		\
- 	xt_register_target(tgt); })
-#define arpt_unregister_target(tgt) xt_unregister_target(tgt)
-
 extern struct xt_table *
 arpt_register_table(struct net *net, struct xt_table *table,
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
