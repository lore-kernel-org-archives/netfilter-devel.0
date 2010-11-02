From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [ipset-5: 6/9] Resizing converted to run under read-locking of the set
Date: Tue,  2 Nov 2010 15:35:31 +0100
Message-ID: <1288708534-14510-7-git-send-email-kadlec@blackhole.kfki.hu>
References: <1288708534-14510-1-git-send-email-kadlec@blackhole.kfki.hu>
 <1288708534-14510-2-git-send-email-kadlec@blackhole.kfki.hu>
 <1288708534-14510-3-git-send-email-kadlec@blackhole.kfki.hu>
 <1288708534-14510-4-git-send-email-kadlec@blackhole.kfki.hu>
 <1288708534-14510-5-git-send-email-kadlec@blackhole.kfki.hu>
 <1288708534-14510-6-git-send-email-kadlec@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------1.7.0.4"
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp1.kfki.hu ([148.6.0.26]:46740 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752991Ab0KBOfg (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 2 Nov 2010 10:35:36 -0400
Received: from localhost (localhost [127.0.0.1])
	by smtp1.kfki.hu (Postfix) with ESMTP id 43430188162
	for <netfilter-devel@vger.kernel.org>; Tue,  2 Nov 2010 15:35:35 +0100 (CET)
Received: from smtp1.kfki.hu ([127.0.0.1])
	by localhost (smtp1.kfki.hu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id uYDo9ZsFTbkl for <netfilter-devel@vger.kernel.org>;
	Tue,  2 Nov 2010 15:35:35 +0100 (CET)
Received: from blackhole.kfki.hu (blackhole.kfki.hu [148.6.0.114])
	by smtp1.kfki.hu (Postfix) with ESMTP id 2B143188157
	for <netfilter-devel@vger.kernel.org>; Tue,  2 Nov 2010 15:35:35 +0100 (CET)
In-Reply-To: <1288708534-14510-6-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------1.7.0.4
Content-Type: text/plain; charset=UTF-8; format=fixed
Content-Transfer-Encoding: 8bit


With restricting resizing so that it can be triggered by an add
from userspace only, we can modify it so that it uses read-locking
instead of write-locking. Thus the matching in the set can run parallel
with resizing.

Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
---
 kernel/include/linux/netfilter/ip_set_chash.h |  184 ++++++++++++++-----------
 kernel/ip_set_hash_ip.c                       |   16 ++-
 kernel/ip_set_hash_ipport.c                   |   15 ++-
 kernel/ip_set_hash_ipportip.c                 |   15 ++-
 kernel/ip_set_hash_ipportnet.c                |   15 ++-
 kernel/ip_set_hash_net.c                      |   15 ++-
 kernel/ip_set_hash_netport.c                  |   15 ++-
 7 files changed, 157 insertions(+), 118 deletions(-)


--------------1.7.0.4
Content-Type: text/x-patch; name="0006-Resizing-converted-to-run-under-read-locking-of-the-.patch"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline; filename="0006-Resizing-converted-to-run-under-read-locking-of-the-.patch"

diff --git a/kernel/include/linux/netfilter/ip_set_chash.h b/kernel/include/linux/netfilter/ip_set_chash.h
index f0ef580..f223275 100644
--- a/kernel/include/linux/netfilter/ip_set_chash.h
+++ b/kernel/include/linux/netfilter/ip_set_chash.h
@@ -23,14 +23,18 @@ struct chash_nets {
 	u32 nets;		/* number of elements per cidr */
 };
 
+struct htable {
+	u8 htable_bits;		/* size of hash table == 2^htable_bits */
+	struct slist htable[0];	/* hashtable of single linked lists */
+};
+
 struct chash {
-	struct slist *htable;	/* Hashtable of single linked lists */
-	u32 maxelem;		/* Max elements in the hash */
-	u32 elements;		/* Current element (vs timeout) */
+	struct htable *table;	/* the hash table */
+	u32 maxelem;		/* max elements in the hash */
+	u32 elements;		/* current element (vs timeout) */
 	u32 initval;		/* random jhash init value */
 	u32 timeout;		/* timeout value, if enabled */
 	struct timer_list gc;	/* garbage collection when timeout enabled */
-	u8 htable_bits;		/* size of hash table == 2^htable_bits */
 	u8 array_size;		/* number of elements in an array */
 	u8 chain_limit;		/* max number of arrays */
 #ifdef IP_SET_HASH_WITH_NETMASK
@@ -105,17 +109,17 @@ del_cidr(struct chash *h, u8 cidr, u8 host_mask)
 
 /* Destroy the hashtable part of the set */
 static void
-chash_destroy(struct slist *t, u8 htable_bits)
+chash_destroy(struct htable *ht)
 {
 	struct slist *n, *tmp;
 	u32 i;
 	
-	for (i = 0; i < jhash_size(htable_bits); i++)
-		slist_for_each_safe(n, tmp, &t[i])
+	for (i = 0; i < jhash_size(ht->htable_bits); i++)
+		slist_for_each_safe(n, tmp, &ht->htable[i])
 			/* FIXME: use slab cache */
 			kfree(n);
 
-	ip_set_free(t);
+	ip_set_free(ht);
 }
 
 /* Calculate the actual memory size of the set data */
@@ -124,14 +128,15 @@ chash_memsize(const struct chash *h, size_t dsize, u8 host_mask)
 {
 	struct slist *n;
 	u32 i;
+	struct htable *ht = h->table;
 	size_t memsize = sizeof(*h)
 #ifdef IP_SET_HASH_WITH_NETS
 			 + sizeof(struct chash_nets) * host_mask
 #endif
-			 + jhash_size(h->htable_bits) * sizeof(struct slist);
+			 + jhash_size(ht->htable_bits) * sizeof(struct slist);
 	
-	for (i = 0; i < jhash_size(h->htable_bits); i++)
-		slist_for_each(n, &h->htable[i])
+	for (i = 0; i < jhash_size(ht->htable_bits); i++)
+		slist_for_each(n, &ht->htable[i])
 			memsize += sizeof(struct slist)
 				+ h->array_size * dsize;
 	
@@ -143,14 +148,15 @@ static void
 ip_set_hash_flush(struct ip_set *set)
 {
 	struct chash *h = set->data;
+	struct htable *ht = h->table;
 	struct slist *n, *tmp;
 	u32 i;
 	
-	for (i = 0; i < jhash_size(h->htable_bits); i++) {
-		slist_for_each_safe(n, tmp, &h->htable[i])
+	for (i = 0; i < jhash_size(ht->htable_bits); i++) {
+		slist_for_each_safe(n, tmp, &ht->htable[i])
 			/* FIXME: slab cache */
 			kfree(n);
-		h->htable[i].next = NULL;
+		ht->htable[i].next = NULL;
 	}
 #ifdef IP_SET_HASH_WITH_NETS
 	memset(h->nets, 0, sizeof(struct chash_nets)
@@ -168,7 +174,7 @@ ip_set_hash_destroy(struct ip_set *set)
 	if (with_timeout(h->timeout))
 		del_timer_sync(&h->gc);
 
-	chash_destroy(h->htable, h->htable_bits);
+	chash_destroy(h->table);
 	kfree(h);
 	
 	set->data = NULL;
@@ -241,16 +247,17 @@ ip_set_hash_destroy(struct ip_set *set)
 /* Add an element to the hash table when resizing the set:
  * we spare the maintenance of the internal counters. */
 static int
-type_pf_chash_readd(struct chash *h, struct slist *t, u8 htable_bits,
-		    const struct type_pf_elem *value, gfp_t gfp_flags)
+type_pf_chash_readd(struct chash *h, struct htable *ht,
+		    const struct type_pf_elem *value,
+		    gfp_t gfp_flags)
 {
 	struct slist *n, *prev;
 	struct type_pf_elem *data;
 	void *tmp;
 	int i = 0, j = 0;
-	u32 hash = JHASH2(value, h->initval, htable_bits);
+	u32 hash = JHASH2(value, h->initval, ht->htable_bits);
 
-	slist_for_each_prev(prev, n, &t[hash]) {
+	slist_for_each_prev(prev, n, &ht->htable[hash]) {
 		for (i = 0; i < h->array_size; i++) {
 			data = chash_data(n, i);
 			if (type_pf_data_isnull(data)) {
@@ -325,8 +332,9 @@ static int
 type_pf_resize(struct ip_set *set, gfp_t gfp_flags, bool retried)
 {
 	struct chash *h = set->data;
-	u8 htable_bits = h->htable_bits;
-	struct slist *t, *n;
+	struct htable *ht, *orig = h->table;
+	u8 htable_bits = orig->htable_bits;
+	struct slist *n;
 	const struct type_pf_elem *data;
 	u32 i, j;
 	int ret;
@@ -337,26 +345,28 @@ retry:
 	if (!htable_bits)
 		/* In case we have plenty of memory :-) */
 		return -IPSET_ERR_HASH_FULL;
-	t = ip_set_alloc(jhash_size(htable_bits) * sizeof(struct slist),
-			 GFP_KERNEL);
-	if (!t)
+	ht = ip_set_alloc(sizeof(*ht)
+			  + jhash_size(htable_bits) * sizeof(struct slist),
+			  GFP_KERNEL);
+	if (!ht)
 		return -ENOMEM;
+	ht->htable_bits = htable_bits;
 
-	write_lock_bh(&set->lock);
+	read_lock_bh(&set->lock);
 next_slot:
-	for (; i < jhash_size(h->htable_bits); i++) {
-		slist_for_each(n, &h->htable[i]) {
+	for (; i < jhash_size(orig->htable_bits); i++) {
+		slist_for_each(n, &orig->htable[i]) {
 			for (j = 0; j < h->array_size; j++) {
 				data = chash_data(n, j);
 				if (type_pf_data_isnull(data)) {
 					i++;
 					goto next_slot;
 				}
-				ret = type_pf_chash_readd(h, t, htable_bits,
+				ret = type_pf_chash_readd(h, ht,
 							  data, gfp_flags);
 				if (ret < 0) {
-					write_unlock_bh(&set->lock);
-					chash_destroy(t, htable_bits);
+					read_unlock_bh(&set->lock);
+					chash_destroy(ht);
 					if (ret == -EAGAIN)
 						goto retry;
 					return ret;
@@ -365,14 +375,13 @@ next_slot:
 		}
 	}
 
-	n = h->htable;
-	i = h->htable_bits;
+	h->table = ht;
+	read_unlock_bh(&set->lock);
 	
-	h->htable = t;
-	h->htable_bits = htable_bits;
-	write_unlock_bh(&set->lock);
+	/* Give time to other users of the set */
+	synchronize_net();
 
-	chash_destroy(n, i);
+	chash_destroy(orig);
 	
 	return 0;
 }
@@ -385,7 +394,8 @@ type_pf_chash_add(struct ip_set *set, void *value,
 {
 	struct chash *h = set->data;
 	const struct type_pf_elem *d = value;
-	struct slist *n, *prev, *t = h->htable;
+	struct slist *n, *prev;
+	struct htable *ht = h->table;
 	struct type_pf_elem *data;
 	void *tmp;
 	int i = 0, j = 0;
@@ -394,8 +404,8 @@ type_pf_chash_add(struct ip_set *set, void *value,
 	if (h->elements >= h->maxelem)
 		return -IPSET_ERR_HASH_FULL;
 
-	hash = JHASH2(value, h->initval, h->htable_bits);
-	slist_for_each_prev(prev, n, &t[hash]) {
+	hash = JHASH2(value, h->initval, ht->htable_bits);
+	slist_for_each_prev(prev, n, &ht->htable[hash]) {
 		for (i = 0; i < h->array_size; i++) {
 			data = chash_data(n, i);
 			if (type_pf_data_isnull(data)) {
@@ -434,12 +444,13 @@ type_pf_chash_del(struct ip_set *set, void *value,
 {
 	struct chash *h = set->data;
 	const struct type_pf_elem *d = value;
+	struct htable *ht = h->table;
 	struct slist *n, *prev;
 	int i;
 	struct type_pf_elem *data;
-	u32 hash = JHASH2(value, h->initval, h->htable_bits);
+	u32 hash = JHASH2(value, h->initval, ht->htable_bits);
 
-	slist_for_each_prev(prev, n, &h->htable[hash])
+	slist_for_each_prev(prev, n, &ht->htable[hash])
 		for (i = 0; i < h->array_size; i++) {
 			data = chash_data(n, i);
 			if (type_pf_data_isnull(data))
@@ -463,6 +474,7 @@ type_pf_chash_test_cidrs(struct ip_set *set,
 			 gfp_t gfp_flags, u32 timeout)
 {
 	struct chash *h = set->data;
+	struct htable *ht = h->table;
 	struct slist *n;
 	const struct type_pf_elem *data;
 	int i, j = 0;
@@ -473,8 +485,8 @@ retry:
 	pr_debug("test by nets");
 	for (; j < host_mask && h->nets[j].cidr; j++) {
 		type_pf_data_netmask(d, h->nets[j].cidr);
-		hash = JHASH2(d, h->initval, h->htable_bits);
-		slist_for_each(n, &h->htable[hash])
+		hash = JHASH2(d, h->initval, ht->htable_bits);
+		slist_for_each(n, &ht->htable[hash])
 			for (i = 0; i < h->array_size; i++) {
 				data = chash_data(n, i);
 				if (type_pf_data_isnull(data)) {
@@ -495,6 +507,7 @@ type_pf_chash_test(struct ip_set *set, void *value,
 		   gfp_t gfp_flags, u32 timeout)
 {
 	struct chash *h = set->data;
+	struct htable *ht = h->table;
 	struct type_pf_elem *d = value;
 	struct slist *n;
 	const struct type_pf_elem *data;
@@ -508,8 +521,8 @@ type_pf_chash_test(struct ip_set *set, void *value,
 		return type_pf_chash_test_cidrs(set, d, gfp_flags, timeout);
 #endif
 
-	hash = JHASH2(d, h->initval, h->htable_bits);
-	slist_for_each(n, &h->htable[hash])
+	hash = JHASH2(d, h->initval, ht->htable_bits);
+	slist_for_each(n, &ht->htable[hash])
 		for (i = 0; i < h->array_size; i++) {
 			data = chash_data(n, i);
 			if (type_pf_data_isnull(data))
@@ -539,7 +552,7 @@ type_pf_head(struct ip_set *set, struct sk_buff *skb)
 	if (!nested)
 		goto nla_put_failure;
 	NLA_PUT_NET32(skb, IPSET_ATTR_HASHSIZE,
-		      htonl(jhash_size(h->htable_bits)));
+		      htonl(jhash_size(h->table->htable_bits)));
 	NLA_PUT_NET32(skb, IPSET_ATTR_MAXELEM, htonl(h->maxelem));
 #ifdef IP_SET_HASH_WITH_NETMASK
 	if (h->netmask != HOST_MASK)
@@ -563,6 +576,7 @@ type_pf_list(struct ip_set *set,
 	     struct sk_buff *skb, struct netlink_callback *cb)
 {
 	const struct chash *h = set->data;
+	const struct htable *ht = h->table;
 	struct nlattr *atd, *nested;
 	struct slist *n;
 	const struct type_pf_elem *data;
@@ -575,9 +589,9 @@ type_pf_list(struct ip_set *set,
 	if (!atd)
 		return -EFAULT;
 	pr_debug("list hash set %s", set->name);
-	for (; cb->args[2] < jhash_size(h->htable_bits); cb->args[2]++) {
+	for (; cb->args[2] < jhash_size(ht->htable_bits); cb->args[2]++) {
 		incomplete = skb_tail_pointer(skb);
-		slist_for_each(n, &h->htable[cb->args[2]]) {
+		slist_for_each(n, &ht->htable[cb->args[2]]) {
 			for (i = 0; i < h->array_size; i++) {
 				data = chash_data(n, i);
 				if (type_pf_data_isnull(data))
@@ -681,7 +695,7 @@ type_pf_data_timeout_set(struct type_pf_elem *data, u32 timeout)
 }
 
 static int
-type_pf_chash_treadd(struct chash *h, struct slist *t, u8 htable_bits,
+type_pf_chash_treadd(struct chash *h, struct htable *ht,
 		     const struct type_pf_elem *value,
 		     gfp_t gfp_flags, u32 timeout)
 {
@@ -689,9 +703,9 @@ type_pf_chash_treadd(struct chash *h, struct slist *t, u8 htable_bits,
 	struct type_pf_elem *data;
 	void *tmp;
 	int i = 0, j = 0;
-	u32 hash = JHASH2(value, h->initval, htable_bits);
+	u32 hash = JHASH2(value, h->initval, ht->htable_bits);
 
-	slist_for_each_prev(prev, n, &t[hash]) {
+	slist_for_each_prev(prev, n, &ht->htable[hash]) {
 		for (i = 0; i < h->array_size; i++) {
 			data = chash_tdata(n, i);
 			if (type_pf_data_isnull(data)) {
@@ -764,13 +778,14 @@ type_pf_chash_del_telem(struct chash *h, struct slist *prev,
 static void
 type_pf_chash_expire(struct chash *h)
 {
+	struct htable *ht = h->table;
 	struct slist *n, *prev;
 	struct type_pf_elem *data;
 	u32 i;
 	int j;
 	
-	for (i = 0; i < jhash_size(h->htable_bits); i++)
-		slist_for_each_prev(prev, n, &h->htable[i])
+	for (i = 0; i < jhash_size(ht->htable_bits); i++)
+		slist_for_each_prev(prev, n, &ht->htable[i])
 			for (j = 0; j < h->array_size; j++) {
 				data = chash_tdata(n, j);
 				if (type_pf_data_isnull(data))
@@ -786,8 +801,9 @@ static int
 type_pf_tresize(struct ip_set *set, gfp_t gfp_flags, bool retried)
 {
 	struct chash *h = set->data;
-	u8 htable_bits = h->htable_bits;
-	struct slist *t, *n;
+	struct htable *ht, *orig = h->table;
+	u8 htable_bits = orig->htable_bits;
+	struct slist *n;
 	const struct type_pf_elem *data;
 	u32 i, j;
 	int ret;
@@ -808,27 +824,29 @@ retry:
 	if (!htable_bits)
 		/* In case we have plenty of memory :-) */
 		return -IPSET_ERR_HASH_FULL;
-	t = ip_set_alloc(jhash_size(htable_bits) * sizeof(struct slist),
+	ht = ip_set_alloc(sizeof(*ht)
+			 + jhash_size(htable_bits) * sizeof(struct slist),
 			 GFP_KERNEL);
-	if (!t)
+	if (!ht)
 		return -ENOMEM;
+	ht->htable_bits = htable_bits;
 
-	write_lock_bh(&set->lock);
+	read_lock_bh(&set->lock);
 next_slot:
-	for (; i < jhash_size(h->htable_bits); i++) {
-		slist_for_each(n, &h->htable[i]) {
+	for (; i < jhash_size(orig->htable_bits); i++) {
+		slist_for_each(n, &orig->htable[i]) {
 			for (j = 0; j < h->array_size; j++) {
 				data = chash_tdata(n, j);
 				if (type_pf_data_isnull(data)) {
 					i++;
 					goto next_slot;
 				}
-				ret = type_pf_chash_treadd(h, t, htable_bits,
+				ret = type_pf_chash_treadd(h, ht,
 						data, gfp_flags,
 						type_pf_data_timeout(data));
 				if (ret < 0) {
-					write_unlock_bh(&set->lock);
-					chash_destroy(t, htable_bits);
+					read_unlock_bh(&set->lock);
+					chash_destroy(ht);
 					if (ret == -EAGAIN)
 						goto retry;
 					return ret;
@@ -837,14 +855,13 @@ next_slot:
 		}
 	}
 
-	n = h->htable;
-	i = h->htable_bits;
-	
-	h->htable = t;
-	h->htable_bits = htable_bits;
-	write_unlock_bh(&set->lock);
+	h->table = ht;
+	read_unlock_bh(&set->lock);
 
-	chash_destroy(n, i);
+	/* Give time to other users of the set */
+	synchronize_net();
+
+	chash_destroy(orig);
 	
 	return 0;
 }
@@ -855,7 +872,8 @@ type_pf_chash_tadd(struct ip_set *set, void *value,
 {	
 	struct chash *h = set->data;
 	const struct type_pf_elem *d = value;
-	struct slist *n, *prev, *t = h->htable;
+	struct slist *n, *prev;
+	struct htable *ht = h->table;
 	struct type_pf_elem *data;
 	void *tmp;
 	int i = 0, j = 0;
@@ -867,8 +885,8 @@ type_pf_chash_tadd(struct ip_set *set, void *value,
 	if (h->elements >= h->maxelem)
 		return -IPSET_ERR_HASH_FULL;
 
-	hash = JHASH2(d, h->initval, h->htable_bits);
-	slist_for_each_prev(prev, n, &t[hash]) {
+	hash = JHASH2(d, h->initval, ht->htable_bits);
+	slist_for_each_prev(prev, n, &ht->htable[hash]) {
 		for (i = 0; i < h->array_size; i++) {
 			data = chash_tdata(n, i);
 			if (type_pf_data_isnull(data)
@@ -911,13 +929,14 @@ type_pf_chash_tdel(struct ip_set *set, void *value,
 		   gfp_t gfp_flags, u32 timeout)
 {
 	struct chash *h = set->data;
+	struct htable *ht = h->table;
 	const struct type_pf_elem *d = value;
 	struct slist *n, *prev;
 	int i, ret = 0;
 	struct type_pf_elem *data;
-	u32 hash = JHASH2(value, h->initval, h->htable_bits);
+	u32 hash = JHASH2(value, h->initval, ht->htable_bits);
 
-	slist_for_each_prev(prev, n, &h->htable[hash])
+	slist_for_each_prev(prev, n, &ht->htable[hash])
 		for (i = 0; i < h->array_size; i++) {
 			data = chash_tdata(n, i);
 			if (type_pf_data_isnull(data))
@@ -940,6 +959,7 @@ type_pf_chash_ttest_cidrs(struct ip_set *set,
 			  gfp_t gfp_flags, u32 timeout)
 {
 	struct chash *h = set->data;
+	struct htable *ht = h->table;
 	struct type_pf_elem *data;
 	struct slist *n;
 	int i, j = 0;
@@ -949,8 +969,8 @@ type_pf_chash_ttest_cidrs(struct ip_set *set,
 retry:
 	for (; j < host_mask && h->nets[j].cidr; j++) {
 		type_pf_data_netmask(d, h->nets[j].cidr);
-		hash = JHASH2(d, h->initval, h->htable_bits);
-		slist_for_each(n, &h->htable[hash])
+		hash = JHASH2(d, h->initval, ht->htable_bits);
+		slist_for_each(n, &ht->htable[hash])
 			for (i = 0; i < h->array_size; i++) {
 				data = chash_tdata(n, i);
 				if (type_pf_data_isnull(data)) {
@@ -970,6 +990,7 @@ type_pf_chash_ttest(struct ip_set *set, void *value,
 		    gfp_t gfp_flags, u32 timeout)
 {
 	struct chash *h = set->data;
+	struct htable *ht = h->table;
 	struct type_pf_elem *data, *d = value;
 	struct slist *n;
 	int i;
@@ -980,8 +1001,8 @@ type_pf_chash_ttest(struct ip_set *set, void *value,
 		return type_pf_chash_ttest_cidrs(set, d, gfp_flags,
 						 timeout);
 #endif
-	hash = JHASH2(d, h->initval, h->htable_bits);
-	slist_for_each(n, &h->htable[hash])
+	hash = JHASH2(d, h->initval, ht->htable_bits);
+	slist_for_each(n, &ht->htable[hash])
 		for (i = 0; i < h->array_size; i++) {
 			data = chash_tdata(n, i);
 			if (type_pf_data_isnull(data))
@@ -997,6 +1018,7 @@ type_pf_tlist(struct ip_set *set,
 	      struct sk_buff *skb, struct netlink_callback *cb)
 {
 	const struct chash *h = set->data;
+	const struct htable *ht = h->table;
 	struct nlattr *atd, *nested;
 	struct slist *n;
 	const struct type_pf_elem *data;
@@ -1008,9 +1030,9 @@ type_pf_tlist(struct ip_set *set,
 	atd = ipset_nest_start(skb, IPSET_ATTR_ADT);
 	if (!atd)
 		return -EFAULT;
-	for (; cb->args[2] < jhash_size(h->htable_bits); cb->args[2]++) {
+	for (; cb->args[2] < jhash_size(ht->htable_bits); cb->args[2]++) {
 		incomplete = skb_tail_pointer(skb);
-		slist_for_each(n, &h->htable[cb->args[2]]) {
+		slist_for_each(n, &ht->htable[cb->args[2]]) {
 			for (i = 0; i < h->array_size; i++) {
 				data = chash_tdata(n, i);
 				pr_debug("list %p %u", n, i);
diff --git a/kernel/ip_set_hash_ip.c b/kernel/ip_set_hash_ip.c
index 6fad300..32093fc 100644
--- a/kernel/ip_set_hash_ip.c
+++ b/kernel/ip_set_hash_ip.c
@@ -387,7 +387,7 @@ hash_ip_create(struct ip_set *set, struct nlattr *head, int len, u32 flags)
 {
 	struct nlattr *tb[IPSET_ATTR_CREATE_MAX+1];
 	u32 hashsize = IPSET_DEFAULT_HASHSIZE, maxelem = IPSET_DEFAULT_MAXELEM;
-	u8 netmask;
+	u8 netmask, hbits;
 	struct chash *h;
 
 	if (!(set->family == AF_INET || set->family == AF_INET6))
@@ -424,19 +424,21 @@ hash_ip_create(struct ip_set *set, struct nlattr *head, int len, u32 flags)
 
 	h->maxelem = maxelem;
 	h->netmask = netmask;
-	h->htable_bits = htable_bits(hashsize);
 	h->array_size = CHASH_DEFAULT_ARRAY_SIZE;
 	h->chain_limit = CHASH_DEFAULT_CHAIN_LIMIT;
 	get_random_bytes(&h->initval, sizeof(h->initval));
 	h->timeout = IPSET_NO_TIMEOUT;
 
-	h->htable = ip_set_alloc(
-			jhash_size(h->htable_bits) * sizeof(struct slist),
+	hbits = htable_bits(hashsize);
+	h->table = ip_set_alloc(
+			sizeof(struct htable)
+			+ jhash_size(hbits) * sizeof(struct slist),
 			GFP_KERNEL);
-	if (!h->htable) {
+	if (!h->table) {
 		kfree(h);
 		return -ENOMEM;
 	}
+	h->table->htable_bits = hbits;
 
 	set->data = h;
 
@@ -456,8 +458,8 @@ hash_ip_create(struct ip_set *set, struct nlattr *head, int len, u32 flags)
 	}
 	
 	pr_debug("create %s hashsize %u (%u) maxelem %u: %p(%p)",
-		 set->name, jhash_size(h->htable_bits),
-		 h->htable_bits, h->maxelem, set->data, h->htable);
+		 set->name, jhash_size(h->table->htable_bits),
+		 h->table->htable_bits, h->maxelem, set->data, h->table);
 	   
 	return 0;
 }
diff --git a/kernel/ip_set_hash_ipport.c b/kernel/ip_set_hash_ipport.c
index 1dd8187..ddd0d28 100644
--- a/kernel/ip_set_hash_ipport.c
+++ b/kernel/ip_set_hash_ipport.c
@@ -416,6 +416,7 @@ hash_ipport_create(struct ip_set *set, struct nlattr *head, int len, u32 flags)
 	struct nlattr *tb[IPSET_ATTR_CREATE_MAX+1];
 	struct chash *h;
 	u32 hashsize = IPSET_DEFAULT_HASHSIZE, maxelem = IPSET_DEFAULT_MAXELEM;
+	u8 hbits;
 
 	if (!(set->family == AF_INET || set->family == AF_INET6))
 		return -IPSET_ERR_INVALID_FAMILY;
@@ -438,19 +439,21 @@ hash_ipport_create(struct ip_set *set, struct nlattr *head, int len, u32 flags)
 		return -ENOMEM;
 
 	h->maxelem = maxelem;
-	h->htable_bits = htable_bits(hashsize);
 	h->array_size = CHASH_DEFAULT_ARRAY_SIZE;
 	h->chain_limit = CHASH_DEFAULT_CHAIN_LIMIT;
 	get_random_bytes(&h->initval, sizeof(h->initval));
 	h->timeout = IPSET_NO_TIMEOUT;
 
-	h->htable = ip_set_alloc(
-			jhash_size(h->htable_bits) * sizeof(struct slist),
+	hbits = htable_bits(hashsize);
+	h->table = ip_set_alloc(
+			sizeof(struct htable)
+			+ jhash_size(hbits) * sizeof(struct slist),
 			GFP_KERNEL);
-	if (!h->htable) {
+	if (!h->table) {
 		kfree(h);
 		return -ENOMEM;
 	}
+	h->table->htable_bits = hbits;
 
 	set->data = h;
 
@@ -470,8 +473,8 @@ hash_ipport_create(struct ip_set *set, struct nlattr *head, int len, u32 flags)
 	}
 	
 	pr_debug("create %s hashsize %u (%u) maxelem %u: %p(%p)",
-		 set->name, jhash_size(h->htable_bits),
-		 h->htable_bits, h->maxelem, set->data, h->htable);
+		 set->name, jhash_size(h->table->htable_bits),
+		 h->table->htable_bits, h->maxelem, set->data, h->table);
 	   
 	return 0;
 }
diff --git a/kernel/ip_set_hash_ipportip.c b/kernel/ip_set_hash_ipportip.c
index a20f1ef..0e46268 100644
--- a/kernel/ip_set_hash_ipportip.c
+++ b/kernel/ip_set_hash_ipportip.c
@@ -437,6 +437,7 @@ hash_ipportip_create(struct ip_set *set, struct nlattr *head,
 	struct nlattr *tb[IPSET_ATTR_CREATE_MAX+1];
 	struct chash *h;
 	u32 hashsize = IPSET_DEFAULT_HASHSIZE, maxelem = IPSET_DEFAULT_MAXELEM;
+	u8 hbits;
 
 	if (!(set->family == AF_INET || set->family == AF_INET6))
 		return -IPSET_ERR_INVALID_FAMILY;
@@ -459,19 +460,21 @@ hash_ipportip_create(struct ip_set *set, struct nlattr *head,
 		return -ENOMEM;
 
 	h->maxelem = maxelem;
-	h->htable_bits = htable_bits(hashsize);
 	h->array_size = CHASH_DEFAULT_ARRAY_SIZE;
 	h->chain_limit = CHASH_DEFAULT_CHAIN_LIMIT;
 	get_random_bytes(&h->initval, sizeof(h->initval));
 	h->timeout = IPSET_NO_TIMEOUT;
 
-	h->htable = ip_set_alloc(
-			jhash_size(h->htable_bits) * sizeof(struct slist),
+	hbits = htable_bits(hashsize);
+	h->table = ip_set_alloc(
+			sizeof(struct htable)
+			+ jhash_size(hbits) * sizeof(struct slist),
 			GFP_KERNEL);
-	if (!h->htable) {
+	if (!h->table) {
 		kfree(h);
 		return -ENOMEM;
 	}
+	h->table->htable_bits = hbits;
 
 	set->data = h;
 
@@ -491,8 +494,8 @@ hash_ipportip_create(struct ip_set *set, struct nlattr *head,
 	}
 	
 	pr_debug("create %s hashsize %u (%u) maxelem %u: %p(%p)",
-		 set->name, jhash_size(h->htable_bits),
-		 h->htable_bits, h->maxelem, set->data, h->htable);
+		 set->name, jhash_size(h->table->htable_bits),
+		 h->table->htable_bits, h->maxelem, set->data, h->table);
 	   
 	return 0;
 }
diff --git a/kernel/ip_set_hash_ipportnet.c b/kernel/ip_set_hash_ipportnet.c
index 3904168..4151135 100644
--- a/kernel/ip_set_hash_ipportnet.c
+++ b/kernel/ip_set_hash_ipportnet.c
@@ -500,6 +500,7 @@ hash_ipportnet_create(struct ip_set *set, struct nlattr *head,
 	struct nlattr *tb[IPSET_ATTR_CREATE_MAX+1];
 	struct chash *h;
 	u32 hashsize = IPSET_DEFAULT_HASHSIZE, maxelem = IPSET_DEFAULT_MAXELEM;
+	u8 hbits;
 
 	if (!(set->family == AF_INET || set->family == AF_INET6))
 		return -IPSET_ERR_INVALID_FAMILY;
@@ -524,19 +525,21 @@ hash_ipportnet_create(struct ip_set *set, struct nlattr *head,
 		return -ENOMEM;
 
 	h->maxelem = maxelem;
-	h->htable_bits = htable_bits(hashsize);
 	h->array_size = CHASH_DEFAULT_ARRAY_SIZE;
 	h->chain_limit = CHASH_DEFAULT_CHAIN_LIMIT;
 	get_random_bytes(&h->initval, sizeof(h->initval));
 	h->timeout = IPSET_NO_TIMEOUT;
 
-	h->htable = ip_set_alloc(
-			jhash_size(h->htable_bits) * sizeof(struct slist),
+	hbits = htable_bits(hashsize);
+	h->table = ip_set_alloc(
+			sizeof(struct htable)
+			+ jhash_size(hbits) * sizeof(struct slist),
 			GFP_KERNEL);
-	if (!h->htable) {
+	if (!h->table) {
 		kfree(h);
 		return -ENOMEM;
 	}
+	h->table->htable_bits = hbits;
 
 	set->data = h;
 
@@ -557,8 +560,8 @@ hash_ipportnet_create(struct ip_set *set, struct nlattr *head,
 	}
 	
 	pr_debug("create %s hashsize %u (%u) maxelem %u: %p(%p)",
-		 set->name, jhash_size(h->htable_bits),
-		 h->htable_bits, h->maxelem, set->data, h->htable);
+		 set->name, jhash_size(h->table->htable_bits),
+		 h->table->htable_bits, h->maxelem, set->data, h->table);
 	   
 	return 0;
 }
diff --git a/kernel/ip_set_hash_net.c b/kernel/ip_set_hash_net.c
index 27191f2..4cb57ac 100644
--- a/kernel/ip_set_hash_net.c
+++ b/kernel/ip_set_hash_net.c
@@ -399,6 +399,7 @@ hash_net_create(struct ip_set *set, struct nlattr *head, int len, u32 flags)
 	struct nlattr *tb[IPSET_ATTR_CREATE_MAX+1];
 	u32 hashsize = IPSET_DEFAULT_HASHSIZE, maxelem = IPSET_DEFAULT_MAXELEM;
 	struct chash *h;
+	u8 hbits;
 
 	if (!(set->family == AF_INET || set->family == AF_INET6))
 		return -IPSET_ERR_INVALID_FAMILY;
@@ -423,19 +424,21 @@ hash_net_create(struct ip_set *set, struct nlattr *head, int len, u32 flags)
 		return -ENOMEM;
 
 	h->maxelem = maxelem;
-	h->htable_bits = htable_bits(hashsize);
 	h->array_size = CHASH_DEFAULT_ARRAY_SIZE;
 	h->chain_limit = CHASH_DEFAULT_CHAIN_LIMIT;
 	get_random_bytes(&h->initval, sizeof(h->initval));
 	h->timeout = IPSET_NO_TIMEOUT;
 
-	h->htable = ip_set_alloc(
-			jhash_size(h->htable_bits) * sizeof(struct slist),
+	hbits = htable_bits(hashsize);
+	h->table = ip_set_alloc(
+			sizeof(struct htable)
+			+ jhash_size(hbits) * sizeof(struct slist),
 			GFP_KERNEL);
-	if (!h->htable) {
+	if (!h->table) {
 		kfree(h);
 		return -ENOMEM;
 	}
+	h->table->htable_bits = hbits;
 
 	set->data = h;
 
@@ -455,8 +458,8 @@ hash_net_create(struct ip_set *set, struct nlattr *head, int len, u32 flags)
 	}
 	
 	pr_debug("create %s hashsize %u (%u) maxelem %u: %p(%p)",
-		 set->name, jhash_size(h->htable_bits),
-		 h->htable_bits, h->maxelem, set->data, h->htable);
+		 set->name, jhash_size(h->table->htable_bits),
+		 h->table->htable_bits, h->maxelem, set->data, h->table);
 	   
 	return 0;
 }
diff --git a/kernel/ip_set_hash_netport.c b/kernel/ip_set_hash_netport.c
index f7f43b8..db4d2f5 100644
--- a/kernel/ip_set_hash_netport.c
+++ b/kernel/ip_set_hash_netport.c
@@ -477,6 +477,7 @@ hash_netport_create(struct ip_set *set, struct nlattr *head, int len, u32 flags)
 	struct nlattr *tb[IPSET_ATTR_CREATE_MAX+1];
 	struct chash *h;
 	u32 hashsize = IPSET_DEFAULT_HASHSIZE, maxelem = IPSET_DEFAULT_MAXELEM;
+	u8 hbits;
 
 	if (!(set->family == AF_INET || set->family == AF_INET6))
 		return -IPSET_ERR_INVALID_FAMILY;
@@ -501,19 +502,21 @@ hash_netport_create(struct ip_set *set, struct nlattr *head, int len, u32 flags)
 		return -ENOMEM;
 
 	h->maxelem = maxelem;
-	h->htable_bits = htable_bits(hashsize);
 	h->array_size = CHASH_DEFAULT_ARRAY_SIZE;
 	h->chain_limit = CHASH_DEFAULT_CHAIN_LIMIT;
 	get_random_bytes(&h->initval, sizeof(h->initval));
 	h->timeout = IPSET_NO_TIMEOUT;
 
-	h->htable = ip_set_alloc(
-			jhash_size(h->htable_bits) * sizeof(struct slist),
+	hbits = htable_bits(hashsize);
+	h->table = ip_set_alloc(
+			sizeof(struct htable)
+			+ jhash_size(hbits) * sizeof(struct slist),
 			GFP_KERNEL);
-	if (!h->htable) {
+	if (!h->table) {
 		kfree(h);
 		return -ENOMEM;
 	}
+	h->table->htable_bits = hbits;
 
 	set->data = h;
 
@@ -533,8 +536,8 @@ hash_netport_create(struct ip_set *set, struct nlattr *head, int len, u32 flags)
 	}
 	
 	pr_debug("create %s hashsize %u (%u) maxelem %u: %p(%p)",
-		 set->name, jhash_size(h->htable_bits),
-		 h->htable_bits, h->maxelem, set->data, h->htable);
+		 set->name, jhash_size(h->table->htable_bits),
+		 h->table->htable_bits, h->maxelem, set->data, h->table);
 	   
 	return 0;
 }

--------------1.7.0.4--


