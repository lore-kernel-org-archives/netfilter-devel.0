From: Jan Engelhardt <jengelh@medozas.de>
Subject: [1/2] ipset 3.0 changes audit: printf types
Date: Wed, 27 May 2009 14:35:45 +0200 (CEST)
Message-ID: <alpine.LSU.2.00.0905271400540.26986@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:48489 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761128AbZE0Mfq (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 27 May 2009 08:35:46 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,


today I looked at the changes introduced by 3.0, and noticed a few bits 
that warranted patches.

BTW I just see that git tags are missing -------v


parent 027dc5fb9021ce3f814a345b17c56d899733569a ()
commit a1b31451f546a536fc3a37647437a048bda6601a
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Wed May 27 14:31:40 2009 +0200

ipset: correct format specifiers

The diff between 2.5.0..3.0 highlighted some changes that were incorrect
(some before, and some afterwards too).

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 .../include/linux/netfilter_ipv4/ip_set_bitmaps.h  |    2 +-
 .../include/linux/netfilter_ipv4/ip_set_hashes.h   |    8 +++---
 kernel/ip_set.c                                    |   14 ++++++------
 kernel/ip_set_iptree.c                             |    4 +-
 4 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/kernel/include/linux/netfilter_ipv4/ip_set_bitmaps.h b/kernel/include/linux/netfilter_ipv4/ip_set_bitmaps.h
index d537639..90e87e3 100644
--- a/kernel/include/linux/netfilter_ipv4/ip_set_bitmaps.h
+++ b/kernel/include/linux/netfilter_ipv4/ip_set_bitmaps.h
@@ -19,7 +19,7 @@ type##_create(struct ip_set *set, const void *data, u_int32_t size)	\
 									\
 	map = kmalloc(sizeof(struct ip_set_##type), GFP_KERNEL);	\
 	if (!map) {							\
-		DP("out of memory for %lu bytes",			\
+		DP("out of memory for %zu bytes",			\
 		   sizeof(struct ip_set_##type));			\
 		return -ENOMEM;						\
 	}								\
diff --git a/kernel/include/linux/netfilter_ipv4/ip_set_hashes.h b/kernel/include/linux/netfilter_ipv4/ip_set_hashes.h
index 4ca8431..f7d6a69 100644
--- a/kernel/include/linux/netfilter_ipv4/ip_set_hashes.h
+++ b/kernel/include/linux/netfilter_ipv4/ip_set_hashes.h
@@ -36,14 +36,14 @@ type##_retry(struct ip_set *set)					\
 	tmp = kmalloc(sizeof(struct ip_set_##type)			\
 		      + map->probes * sizeof(initval_t), GFP_ATOMIC);	\
 	if (!tmp) {							\
-		DP("out of memory for %lu bytes",			\
+		DP("out of memory for %zu bytes",			\
 		   sizeof(struct ip_set_##type)				\
 		   + map->probes * sizeof(initval_t));			\
 		return -ENOMEM;						\
 	}								\
 	tmp->members = harray_malloc(hashsize, sizeof(dtype), GFP_ATOMIC);\
 	if (!tmp->members) {						\
-		DP("out of memory for %lu bytes", hashsize * sizeof(dtype));\
+		DP("out of memory for %zu bytes", hashsize * sizeof(dtype));\
 		kfree(tmp);						\
 		return -ENOMEM;						\
 	}								\
@@ -109,7 +109,7 @@ type##_create(struct ip_set *set, const void *data, u_int32_t size)	\
 	map = kmalloc(sizeof(struct ip_set_##type)			\
 		      + req->probes * sizeof(initval_t), GFP_KERNEL);	\
 	if (!map) {							\
-		DP("out of memory for %lu bytes",			\
+		DP("out of memory for %zu bytes",			\
 		   sizeof(struct ip_set_##type)				\
 		   + req->probes * sizeof(initval_t));			\
 		return -ENOMEM;						\
@@ -126,7 +126,7 @@ type##_create(struct ip_set *set, const void *data, u_int32_t size)	\
 	}								\
 	map->members = harray_malloc(map->hashsize, sizeof(dtype), GFP_KERNEL);\
 	if (!map->members) {						\
-		DP("out of memory for %lu bytes", map->hashsize * sizeof(dtype));\
+		DP("out of memory for %zu bytes", map->hashsize * sizeof(dtype));\
 		kfree(map);						\
 		return -ENOMEM;						\
 	}								\
diff --git a/kernel/ip_set.c b/kernel/ip_set.c
index f94d0e0..8b9ee3a 100644
--- a/kernel/ip_set.c
+++ b/kernel/ip_set.c
@@ -536,7 +536,7 @@ ip_set_addip(ip_set_id_t index,
 	IP_SET_ASSERT(set);
 
 	if (size - sizeof(struct ip_set_req_adt) != set->type->reqsize) {
-		ip_set_printk("data length wrong (want %lu, have %lu)",
+		ip_set_printk("data length wrong (want %lu, have %zu)",
 			      (long unsigned)set->type->reqsize,
 			      size - sizeof(struct ip_set_req_adt));
 		return -EINVAL;
@@ -558,7 +558,7 @@ ip_set_delip(ip_set_id_t index,
 	IP_SET_ASSERT(set);
 
 	if (size - sizeof(struct ip_set_req_adt) != set->type->reqsize) {
-		ip_set_printk("data length wrong (want %lu, have %lu)",
+		ip_set_printk("data length wrong (want %lu, have %zu)",
 			      (long unsigned)set->type->reqsize,
 			      size - sizeof(struct ip_set_req_adt));
 		return -EINVAL;
@@ -585,7 +585,7 @@ ip_set_testip(ip_set_id_t index,
 	IP_SET_ASSERT(set);
 	
 	if (size - sizeof(struct ip_set_req_adt) != set->type->reqsize) {
-		ip_set_printk("data length wrong (want %lu, have %lu)",
+		ip_set_printk("data length wrong (want %lu, have %zu)",
 			      (long unsigned)set->type->reqsize,
 			      size - sizeof(struct ip_set_req_adt));
 		return -EINVAL;
@@ -1329,7 +1329,7 @@ static int ip_set_restore(void *data,
 	while (1) {
 		line++;
 		
-		DP("%i %lu %i", used, sizeof(struct ip_set_restore), len);
+		DP("%i %zu %i", used, sizeof(struct ip_set_restore), len);
 		/* Get and ensure header size */
 		if (used + sizeof(struct ip_set_restore) > len)
 			return line;
@@ -1939,14 +1939,14 @@ ip_set_sockfn_get(struct sock *sk, int optval, void *user, int *len)
 
 		if (*len < sizeof(struct ip_set_req_setnames)
 		    || *len != req_restore->size) {
-			ip_set_printk("invalid RESTORE (want =%lu, got %u)",
+			ip_set_printk("invalid RESTORE (want =%lu, got %d)",
 				      (long unsigned)req_restore->size, *len);
 			res = -EINVAL;
 			goto done;
 		}
 		line = ip_set_restore(data + sizeof(struct ip_set_req_setnames),
 				      req_restore->size - sizeof(struct ip_set_req_setnames));
-		DP("ip_set_restore: %u", line);
+		DP("ip_set_restore: %d", line);
 		if (line != 0) {
 			res = -EAGAIN;
 			req_restore->size = line;
@@ -1961,7 +1961,7 @@ ip_set_sockfn_get(struct sock *sk, int optval, void *user, int *len)
 	}	/* end of switch(op) */
 
     copy:
-   	DP("set %s, copylen %u", index != IP_SET_INVALID_ID
+   	DP("set %s, copylen %d", index != IP_SET_INVALID_ID
    	             		 && ip_set_list[index]
    	             ? ip_set_list[index]->name
    	             : ":all:", copylen);
diff --git a/kernel/ip_set_iptree.c b/kernel/ip_set_iptree.c
index 08b9118..1ef8263 100644
--- a/kernel/ip_set_iptree.c
+++ b/kernel/ip_set_iptree.c
@@ -282,7 +282,7 @@ iptree_create(struct ip_set *set, const void *data, u_int32_t size)
 	struct ip_set_iptree *map;
 
 	if (size != sizeof(struct ip_set_req_iptree_create)) {
-		ip_set_printk("data length wrong (want %lu, have %lu)",
+		ip_set_printk("data length wrong (want %zu, have %lu)",
 			      sizeof(struct ip_set_req_iptree_create),
 			      (unsigned long)size);
 		return -EINVAL;
@@ -290,7 +290,7 @@ iptree_create(struct ip_set *set, const void *data, u_int32_t size)
 
 	map = kmalloc(sizeof(struct ip_set_iptree), GFP_KERNEL);
 	if (!map) {
-		DP("out of memory for %lu bytes",
+		DP("out of memory for %zu bytes",
 		   sizeof(struct ip_set_iptree));
 		return -ENOMEM;
 	}
-- 
# Created with git-export-patch
