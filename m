From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: commit 720350a38b1dbd43c907d5d81decd6edd6725d81
Date: Tue, 25 Mar 2008 19:06:13 +0100
Message-ID: <1206468391-368-11-git-send-email-jengelh@computergmbh.de>
References: <alpine.LNX.1.10.0803251903230.31276@fbirervta.pbzchgretzou.qr>
 <1206468391-368-1-git-send-email-jengelh@computergmbh.de>
 <1206468391-368-2-git-send-email-jengelh@computergmbh.de>
 <1206468391-368-3-git-send-email-jengelh@computergmbh.de>
 <1206468391-368-4-git-send-email-jengelh@computergmbh.de>
 <1206468391-368-5-git-send-email-jengelh@computergmbh.de>
 <1206468391-368-6-git-send-email-jengelh@computergmbh.de>
 <1206468391-368-7-git-send-email-jengelh@computergmbh.de>
 <1206468391-368-8-git-send-email-jengelh@computergmbh.de>
 <1206468391-368-9-git-send-email-jengelh@computergmbh.de>
 <1206468391-368-10-git-send-email-jengelh@computergmbh.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:52544 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757901AbYCYSGf (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 25 Mar 2008 14:06:35 -0400
In-Reply-To: <1206468391-368-10-git-send-email-jengelh@computergmbh.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

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
