From: Sven Wegener <sven.wegener@stealer.net>
Subject: [PATCH 1/6] ipset/iptreemap: Remove needless casts of void pointers
Date: Sun, 29 Jun 2008 19:44:58 +0200
Message-ID: <1214761503-1713-2-git-send-email-sven.wegener@stealer.net>
References: <1214761503-1713-1-git-send-email-sven.wegener@stealer.net>
Cc: netfilter-devel@vger.kernel.org
To: kadlec@blackhole.kfki.hu
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp1.stealer.net ([88.198.224.204]:44947 "EHLO
	smtp1.stealer.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754082AbYF2RpP (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 29 Jun 2008 13:45:15 -0400
In-Reply-To: <1214761503-1713-1-git-send-email-sven.wegener@stealer.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Remove needless casts from and to void pointers.

Signed-off-by: Sven Wegener <sven.wegener@stealer.net>
---
 .../net/ipv4/netfilter/ip_set_iptreemap.c          |   34 ++++++++++----------
 1 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/patchlets/set/linux-2.6/net/ipv4/netfilter/ip_set_iptreemap.c b/patchlets/set/linux-2.6/net/ipv4/netfilter/ip_set_iptreemap.c
index 3825055..fcf882e 100644
--- a/patchlets/set/linux-2.6/net/ipv4/netfilter/ip_set_iptreemap.c
+++ b/patchlets/set/linux-2.6/net/ipv4/netfilter/ip_set_iptreemap.c
@@ -260,7 +260,7 @@ free_b(struct ip_set_iptreemap_b *map)
 static inline int
 __testip(struct ip_set *set, ip_set_ip_t ip, ip_set_ip_t *hash_ip)
 {
-	struct ip_set_iptreemap *map = (struct ip_set_iptreemap *) set->data;
+	struct ip_set_iptreemap *map = set->data;
 	struct ip_set_iptreemap_b *btree;
 	struct ip_set_iptreemap_c *ctree;
 	struct ip_set_iptreemap_d *dtree;
@@ -280,7 +280,7 @@ __testip(struct ip_set *set, ip_set_ip_t ip, ip_set_ip_t *hash_ip)
 static int
 testip(struct ip_set *set, const void *data, size_t size, ip_set_ip_t *hash_ip)
 {
-	struct ip_set_req_iptreemap *req = (struct ip_set_req_iptreemap *) data;
+	const struct ip_set_req_iptreemap *req = data;
 
 	if (size != sizeof(struct ip_set_req_iptreemap)) {
 		ip_set_printk("data length wrong (want %zu, have %zu)", sizeof(struct ip_set_req_iptreemap), size);
@@ -337,7 +337,7 @@ __addip_single(struct ip_set *set, ip_set_ip_t ip, ip_set_ip_t *hash_ip)
 static inline int
 __addip_range(struct ip_set *set, ip_set_ip_t start, ip_set_ip_t end, ip_set_ip_t *hash_ip)
 {
-	struct ip_set_iptreemap *map = (struct ip_set_iptreemap *) set->data;
+	struct ip_set_iptreemap *map = set->data;
 	struct ip_set_iptreemap_b *btree;
 	struct ip_set_iptreemap_c *ctree;
 	struct ip_set_iptreemap_d *dtree;
@@ -370,7 +370,7 @@ __addip_range(struct ip_set *set, ip_set_ip_t start, ip_set_ip_t end, ip_set_ip_
 static int
 addip(struct ip_set *set, const void *data, size_t size, ip_set_ip_t *hash_ip)
 {
-	struct ip_set_req_iptreemap *req = (struct ip_set_req_iptreemap *) data;
+	const struct ip_set_req_iptreemap *req = data;
 
 	if (size != sizeof(struct ip_set_req_iptreemap)) {
 		ip_set_printk("data length wrong (want %zu, have %zu)", sizeof(struct ip_set_req_iptreemap), size);
@@ -399,7 +399,7 @@ addip_kernel(struct ip_set *set, const struct sk_buff *skb, ip_set_ip_t *hash_ip
 static inline int
 __delip_single(struct ip_set *set, ip_set_ip_t ip, ip_set_ip_t *hash_ip, unsigned int __nocast flags)
 {
-	struct ip_set_iptreemap *map = (struct ip_set_iptreemap *) set->data;
+	struct ip_set_iptreemap *map = set->data;
 	struct ip_set_iptreemap_b *btree;
 	struct ip_set_iptreemap_c *ctree;
 	struct ip_set_iptreemap_d *dtree;
@@ -424,7 +424,7 @@ __delip_single(struct ip_set *set, ip_set_ip_t ip, ip_set_ip_t *hash_ip, unsigne
 static inline int
 __delip_range(struct ip_set *set, ip_set_ip_t start, ip_set_ip_t end, ip_set_ip_t *hash_ip, unsigned int __nocast flags)
 {
-	struct ip_set_iptreemap *map = (struct ip_set_iptreemap *) set->data;
+	struct ip_set_iptreemap *map = set->data;
 	struct ip_set_iptreemap_b *btree;
 	struct ip_set_iptreemap_c *ctree;
 	struct ip_set_iptreemap_d *dtree;
@@ -457,7 +457,7 @@ __delip_range(struct ip_set *set, ip_set_ip_t start, ip_set_ip_t end, ip_set_ip_
 static int
 delip(struct ip_set *set, const void *data, size_t size, ip_set_ip_t *hash_ip)
 {
-	struct ip_set_req_iptreemap *req = (struct ip_set_req_iptreemap *) data;
+	const struct ip_set_req_iptreemap *req = data;
 
 	if (size != sizeof(struct ip_set_req_iptreemap)) {
 		ip_set_printk("data length wrong (want %zu, have %zu)", sizeof(struct ip_set_req_iptreemap), size);
@@ -505,7 +505,7 @@ static void
 gc(unsigned long addr)
 {
 	struct ip_set *set = (struct ip_set *) addr;
-	struct ip_set_iptreemap *map = (struct ip_set_iptreemap *) set->data;
+	struct ip_set_iptreemap *map = set->data;
 	struct ip_set_iptreemap_b *btree;
 	struct ip_set_iptreemap_c *ctree;
 	struct ip_set_iptreemap_d *dtree;
@@ -544,7 +544,7 @@ gc(unsigned long addr)
 static inline void
 init_gc_timer(struct ip_set *set)
 {
-	struct ip_set_iptreemap *map = (struct ip_set_iptreemap *) set->data;
+	struct ip_set_iptreemap *map = set->data;
 
 	init_timer(&map->gc);
 	map->gc.data = (unsigned long) set;
@@ -555,7 +555,7 @@ init_gc_timer(struct ip_set *set)
 
 static int create(struct ip_set *set, const void *data, size_t size)
 {
-	struct ip_set_req_iptreemap_create *req = (struct ip_set_req_iptreemap_create *) data;
+	const struct ip_set_req_iptreemap_create *req = data;
 	struct ip_set_iptreemap *map;
 
 	if (size != sizeof(struct ip_set_req_iptreemap_create)) {
@@ -588,7 +588,7 @@ static inline void __flush(struct ip_set_iptreemap *map)
 
 static void destroy(struct ip_set *set)
 {
-	struct ip_set_iptreemap *map = (struct ip_set_iptreemap *) set->data;
+	struct ip_set_iptreemap *map = set->data;
 
 	while (!del_timer(&map->gc))
 		msleep(IPTREEMAP_DESTROY_SLEEP);
@@ -601,7 +601,7 @@ static void destroy(struct ip_set *set)
 
 static void flush(struct ip_set *set)
 {
-	struct ip_set_iptreemap *map = (struct ip_set_iptreemap *) set->data;
+	struct ip_set_iptreemap *map = set->data;
 
 	while (!del_timer(&map->gc))
 		msleep(IPTREEMAP_DESTROY_SLEEP);
@@ -615,15 +615,15 @@ static void flush(struct ip_set *set)
 
 static void list_header(const struct ip_set *set, void *data)
 {
-	struct ip_set_iptreemap *map = (struct ip_set_iptreemap *) set->data;
-	struct ip_set_req_iptreemap_create *header = (struct ip_set_req_iptreemap_create *) data;
+	struct ip_set_iptreemap *map = set->data;
+	struct ip_set_req_iptreemap_create *header = data;
 
 	header->gc_interval = map->gc_interval;
 }
 
 static int list_members_size(const struct ip_set *set)
 {
-	struct ip_set_iptreemap *map = (struct ip_set_iptreemap *) set->data;
+	struct ip_set_iptreemap *map = set->data;
 	struct ip_set_iptreemap_b *btree;
 	struct ip_set_iptreemap_c *ctree;
 	struct ip_set_iptreemap_d *dtree;
@@ -652,7 +652,7 @@ static int list_members_size(const struct ip_set *set)
 
 static inline size_t add_member(void *data, size_t offset, ip_set_ip_t start, ip_set_ip_t end)
 {
-	struct ip_set_req_iptreemap *entry = (struct ip_set_req_iptreemap *) (data + offset);
+	struct ip_set_req_iptreemap *entry = data + offset;
 
 	entry->start = start;
 	entry->end = end;
@@ -662,7 +662,7 @@ static inline size_t add_member(void *data, size_t offset, ip_set_ip_t start, ip
 
 static void list_members(const struct ip_set *set, void *data)
 {
-	struct ip_set_iptreemap *map = (struct ip_set_iptreemap *) set->data;
+	struct ip_set_iptreemap *map = set->data;
 	struct ip_set_iptreemap_b *btree;
 	struct ip_set_iptreemap_c *ctree;
 	struct ip_set_iptreemap_d *dtree;
-- 
1.5.6.1

