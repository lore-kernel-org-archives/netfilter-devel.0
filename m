From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 21/22] netfilter: ipset: use setup_timer() and mod_timer().
Date: Thu, 10 Nov 2016 13:57:55 +0100
Message-ID: <1478782676-9770-22-git-send-email-kadlec@blackhole.kfki.hu>
References: <1478782676-9770-1-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp1.kfki.hu ([148.6.0.26]:36201 "EHLO smtp1.kfki.hu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933187AbcKJM6D (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 10 Nov 2016 07:58:03 -0500
In-Reply-To: <1478782676-9770-1-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Use setup_timer() and instead of init_timer(), being the preferred way
of setting up a timer.

Also, quoting the mod_timer() function comment:
-> mod_timer() is a more efficient way to update the expire field of an
   active timer (if the timer is inactive it will be activated).

Use setup_timer() and mod_timer() to setup and arm a timer, making the
code compact and easier to read.

Signed-off-by: Muhammad Falak R Wani <falakreyaz@gmail.com>
Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
---
 net/netfilter/ipset/ip_set_bitmap_gen.h | 7 ++-----
 net/netfilter/ipset/ip_set_hash_gen.h   | 7 ++-----
 net/netfilter/ipset/ip_set_list_set.c   | 7 ++-----
 3 files changed, 6 insertions(+), 15 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_bitmap_gen.h b/net/netfilter/ipset/ip_set_bitmap_gen.h
index f8ea26c..6f09a99 100644
--- a/net/netfilter/ipset/ip_set_bitmap_gen.h
+++ b/net/netfilter/ipset/ip_set_bitmap_gen.h
@@ -41,11 +41,8 @@
 {
 	struct mtype *map = set->data;
 
-	init_timer(&map->gc);
-	map->gc.data = (unsigned long)set;
-	map->gc.function = gc;
-	map->gc.expires = jiffies + IPSET_GC_PERIOD(set->timeout) * HZ;
-	add_timer(&map->gc);
+	setup_timer(&map->gc, gc, (unsigned long)set);
+	mod_timer(&map->gc, jiffies + IPSET_GC_PERIOD(set->timeout) * HZ);
 }
 
 static void
diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/ip_set_hash_gen.h
index 88b70fc..1b05d4a 100644
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -433,11 +433,8 @@ struct htype {
 {
 	struct htype *h = set->data;
 
-	init_timer(&h->gc);
-	h->gc.data = (unsigned long)set;
-	h->gc.function = gc;
-	h->gc.expires = jiffies + IPSET_GC_PERIOD(set->timeout) * HZ;
-	add_timer(&h->gc);
+	setup_timer(&h->gc, gc, (unsigned long)set);
+	mod_timer(&h->gc, jiffies + IPSET_GC_PERIOD(set->timeout) * HZ);
 	pr_debug("gc initialized, run in every %u\n",
 		 IPSET_GC_PERIOD(set->timeout));
 }
diff --git a/net/netfilter/ipset/ip_set_list_set.c b/net/netfilter/ipset/ip_set_list_set.c
index dede343..51077c5 100644
--- a/net/netfilter/ipset/ip_set_list_set.c
+++ b/net/netfilter/ipset/ip_set_list_set.c
@@ -586,11 +586,8 @@ struct list_set {
 {
 	struct list_set *map = set->data;
 
-	init_timer(&map->gc);
-	map->gc.data = (unsigned long)set;
-	map->gc.function = gc;
-	map->gc.expires = jiffies + IPSET_GC_PERIOD(set->timeout) * HZ;
-	add_timer(&map->gc);
+	setup_timer(&map->gc, gc, (unsigned long)set);
+	mod_timer(&map->gc, jiffies + IPSET_GC_PERIOD(set->timeout) * HZ);
 }
 
 /* Create list:set type of sets */
-- 
1.8.5.1

