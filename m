From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 19/22] netfilter: ipset: use setup_timer() and mod_timer().
Date: Mon, 17 Oct 2016 14:51:36 +0200
Message-ID: <1476708699-32761-20-git-send-email-kadlec@blackhole.kfki.hu>
References: <1476708699-32761-1-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp2.kfki.hu ([148.6.0.28]:34603 "EHLO smtp2.kfki.hu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754981AbcJQNAU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 17 Oct 2016 09:00:20 -0400
In-Reply-To: <1476708699-32761-1-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Muhammad Falak R Wani <falakreyaz@gmail.com>

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
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_bitmap_gen.h b/net/netfilter/ipset/ip_set_bitmap_gen.h
index 5a9fa61..77dd415 100644
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
-- 
1.8.5.1

