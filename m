From: Sven Wegener <sven.wegener@stealer.net>
Subject: [PATCH 3/6] ipset/iptreemap: Use non-atomic bit operations
Date: Sun, 29 Jun 2008 19:45:00 +0200
Message-ID: <1214761503-1713-4-git-send-email-sven.wegener@stealer.net>
References: <1214761503-1713-1-git-send-email-sven.wegener@stealer.net>
Cc: netfilter-devel@vger.kernel.org
To: kadlec@blackhole.kfki.hu
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp1.stealer.net ([88.198.224.204]:44954 "EHLO
	smtp1.stealer.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754158AbYF2RpR (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 29 Jun 2008 13:45:17 -0400
In-Reply-To: <1214761503-1713-1-git-send-email-sven.wegener@stealer.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

We can use the non-atomic bit operations, because we are already protected by a
per set rw spinlock.

Signed-off-by: Sven Wegener <sven.wegener@stealer.net>
---
 .../net/ipv4/netfilter/ip_set_iptreemap.c          |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/patchlets/set/linux-2.6/net/ipv4/netfilter/ip_set_iptreemap.c b/patchlets/set/linux-2.6/net/ipv4/netfilter/ip_set_iptreemap.c
index dfd486a..6045741 100644
--- a/patchlets/set/linux-2.6/net/ipv4/netfilter/ip_set_iptreemap.c
+++ b/patchlets/set/linux-2.6/net/ipv4/netfilter/ip_set_iptreemap.c
@@ -324,10 +324,10 @@ __addip_single(struct ip_set *set, ip_set_ip_t ip, ip_set_ip_t *hash_ip)
 	ADDIP_WALK(btree, b, ctree, struct ip_set_iptreemap_c, cachep_c, fullbitmap_c);
 	ADDIP_WALK(ctree, c, dtree, struct ip_set_iptreemap_d, cachep_d, fullbitmap_d);
 
-	if (test_and_set_bit(d, (void *) dtree->bitmap))
+	if (__test_and_set_bit(d, (void *) dtree->bitmap))
 		return -EEXIST;
 
-	set_bit(b, (void *) btree->dirty);
+	__set_bit(b, (void *) btree->dirty);
 
 	return 0;
 }
@@ -356,8 +356,8 @@ __addip_range(struct ip_set *set, ip_set_ip_t start, ip_set_ip_t end, ip_set_ip_
 		ADDIP_RANGE_LOOP(btree, b, GETVALUE1(a, a1, b1, 0), GETVALUE1(a, a2, b2, 255), CHECK2(a, b, a1, a2, b1, b2, c1, c2, d1, d2), ctree, fullbitmap_c, cachep_c, free_c) {
 			ADDIP_RANGE_LOOP(ctree, c, GETVALUE2(a, b, a1, b1, c1, 0), GETVALUE2(a, b, a2, b2, c2, 255), CHECK3(a, b, c, a1, a2, b1, b2, c1, c2, d1, d2), dtree, fullbitmap_d, cachep_d, free_d) {
 				for (d = GETVALUE3(a, b, c, a1, b1, c1, d1, 0); d <= GETVALUE3(a, b, c, a2, b2, c2, d2, 255); d++)
-					set_bit(d, (void *) dtree->bitmap);
-				set_bit(b, (void *) btree->dirty);
+					__set_bit(d, (void *) dtree->bitmap);
+				__set_bit(b, (void *) btree->dirty);
 			} ADDIP_RANGE_LOOP_END();
 		} ADDIP_RANGE_LOOP_END();
 	} ADDIP_RANGE_LOOP_END();
@@ -411,10 +411,10 @@ __delip_single(struct ip_set *set, ip_set_ip_t ip, ip_set_ip_t *hash_ip, unsigne
 	DELIP_WALK(btree, b, ctree, cachep_c, fullbitmap_c, flags);
 	DELIP_WALK(ctree, c, dtree, cachep_d, fullbitmap_d, flags);
 
-	if (!test_and_clear_bit(d, (void *) dtree->bitmap))
+	if (!__test_and_clear_bit(d, (void *) dtree->bitmap))
 		return -EEXIST;
 
-	set_bit(b, (void *) btree->dirty);
+	__set_bit(b, (void *) btree->dirty);
 
 	return 0;
 }
@@ -443,8 +443,8 @@ __delip_range(struct ip_set *set, ip_set_ip_t start, ip_set_ip_t end, ip_set_ip_
 		DELIP_RANGE_LOOP(btree, b, GETVALUE1(a, a1, b1, 0), GETVALUE1(a, a2, b2, 255), CHECK2(a, b, a1, a2, b1, b2, c1, c2, d1, d2), ctree, fullbitmap_c, cachep_c, free_c, flags) {
 			DELIP_RANGE_LOOP(ctree, c, GETVALUE2(a, b, a1, b1, c1, 0), GETVALUE2(a, b, a2, b2, c2, 255), CHECK3(a, b, c, a1, a2, b1, b2, c1, c2, d1, d2), dtree, fullbitmap_d, cachep_d, free_d, flags) {
 				for (d = GETVALUE3(a, b, c, a1, b1, c1, d1, 0); d <= GETVALUE3(a, b, c, a2, b2, c2, d2, 255); d++)
-					clear_bit(d, (void *) dtree->bitmap);
-				set_bit(b, (void *) btree->dirty);
+					__clear_bit(d, (void *) dtree->bitmap);
+				__set_bit(b, (void *) btree->dirty);
 			} DELIP_RANGE_LOOP_END();
 		} DELIP_RANGE_LOOP_END();
 	} DELIP_RANGE_LOOP_END();
@@ -514,7 +514,7 @@ gc(unsigned long addr)
 
 	LOOP_WALK_BEGIN_GC(map, a, btree, fullbitmap_b, cachep_b, i) {
 		LOOP_WALK_BEGIN_GC(btree, b, ctree, fullbitmap_c, cachep_c, j) {
-			if (!test_and_clear_bit(b, (void *) btree->dirty))
+			if (!__test_and_clear_bit(b, (void *) btree->dirty))
 				continue;
 			LOOP_WALK_BEGIN_GC(ctree, c, dtree, fullbitmap_d, cachep_d, k) {
 				switch (bitmap_status(dtree)) {
-- 
1.5.6.1

