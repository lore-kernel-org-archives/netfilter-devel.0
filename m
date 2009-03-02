From: Jan Engelhardt <jengelh@medozas.de>
Subject: ipset: replace RW_LOCK_UNLOCKED
Date: Mon, 2 Mar 2009 21:25:32 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0903022057290.17236@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:42141 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753016AbZCBUZf (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 2 Mar 2009 15:25:35 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


ipset uses RW_LOCK_UNLOCKED directly, but this is not quite right, and 
causes compilation errors with 2.6.29-rt.

---
 extensions/ipset/ip_set.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: xtables-addons-1.10/extensions/ipset/ip_set.c
===================================================================
--- xtables-addons-1.10.orig/extensions/ipset/ip_set.c
+++ xtables-addons-1.10/extensions/ipset/ip_set.c
@@ -877,7 +877,7 @@ ip_set_create(const char *name,
 	set = kmalloc(sizeof(struct ip_set), GFP_KERNEL);
 	if (!set)
 		return -ENOMEM;
-	set->lock = RW_LOCK_UNLOCKED;
+	rwlock_init(&set->lock);
 	strncpy(set->name, name, IP_SET_MAXNAMELEN);
 	set->binding = IP_SET_INVALID_ID;
 	atomic_set(&set->ref, 0);

