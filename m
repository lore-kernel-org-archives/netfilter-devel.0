From: Andreas Schultz <aschultz@warp10.net>
Subject: Re: [RFC][PATCH] ipset - remove hash_ip function parameter
Date: Fri, 02 Jan 2009 14:04:08 +0100
Message-ID: <1230901450.9673.1.camel@ws-aschultz>
References: <1230654806.10747.6.camel@ws-aschultz>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-SM34i6kg/QT8qULe2PgC"
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.tpip.net ([213.187.84.201]:48859 "EHLO mail.tpip.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756808AbZABNEY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 2 Jan 2009 08:04:24 -0500
In-Reply-To: <1230654806.10747.6.camel@ws-aschultz>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--=-SM34i6kg/QT8qULe2PgC
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hi,

This is a follow up on my 'ipset - remove binding support' patch.

After binding support is gone, the hash_ip parameter for the
add/del/test functions is no longer needed. This patch removes it.

Andreas

--=-SM34i6kg/QT8qULe2PgC
Content-Disposition: attachment; filename="ipset-simplify-api.patch"
Content-Type: text/x-patch; name="ipset-simplify-api.patch"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

Index: ipset/kernel/include/linux/netfilter_ipv4/ip_set.h
===================================================================
--- ipset.orig/kernel/include/linux/netfilter_ipv4/ip_set.h	2009-01-02 12:23:30.000000000 +0100
+++ ipset/kernel/include/linux/netfilter_ipv4/ip_set.h	2009-01-02 12:28:41.000000000 +0100
@@ -321,7 +321,6 @@
 	 */
 	int (*testip_kernel) (struct ip_set *set,
 			      const struct sk_buff * skb, 
-			      ip_set_ip_t *ip,
 			      const u_int32_t *flags,
 			      unsigned char index);
 
@@ -329,8 +328,7 @@
 	 * return 0 if not in set, 1 if in set.
 	 */
 	int (*testip) (struct ip_set *set,
-		       const void *data, size_t size,
-		       ip_set_ip_t *ip);
+		       const void *data, size_t size);
 
 	/*
 	 * Size of the data structure passed by when
@@ -344,8 +342,7 @@
 	 * If the address was not already in the set, 0 is returned.
 	 */
 	int (*addip) (struct ip_set *set, 
-		      const void *data, size_t size,
-		      ip_set_ip_t *ip);
+		      const void *data, size_t size);
 
 	/* Add IP into set (kernel: iptables ... -j SET set src|dst)
 	 * Return -EEXIST if the address is already in the set,
@@ -354,7 +351,6 @@
 	 */
 	int (*addip_kernel) (struct ip_set *set,
 			     const struct sk_buff * skb, 
-			     ip_set_ip_t *ip,
 			     const u_int32_t *flags,
 			     unsigned char index);
 
@@ -364,8 +360,7 @@
 	 * If the address really was in the set, 0 is returned.
 	 */
 	int (*delip) (struct ip_set *set, 
-		      const void *data, size_t size,
-		      ip_set_ip_t *ip);
+		      const void *data, size_t size);
 
 	/* remove IP from set (kernel: iptables ... -j SET --entry x)
 	 * Return -EEXIST if the address is NOT in the set,
@@ -374,7 +369,6 @@
 	 */
 	int (*delip_kernel) (struct ip_set *set,
 			     const struct sk_buff * skb, 
-			     ip_set_ip_t *ip,
 			     const u_int32_t *flags,
 			     unsigned char index);
 
@@ -477,12 +471,11 @@
 
 #define UADT0(type, adt, args...)					\
 static int								\
-FNAME(type,_u,adt)(struct ip_set *set, const void *data, size_t size,	\
-	     ip_set_ip_t *hash_ip)					\
+FNAME(type,_u,adt)(struct ip_set *set, const void *data, size_t size)	\
 {									\
 	const STRUCT(ip_set_req_,type) *req = data;			\
 									\
-	return FNAME(type,_,adt)(set, hash_ip , ## args);		\
+	return FNAME(type,_,adt)(set, ## args);				\
 }
 
 #define UADT(type, adt, args...)					\
@@ -492,14 +485,13 @@
 static int								\
 FNAME(type,_k,adt)(struct ip_set *set,					\
 	     const struct sk_buff *skb,					\
-	     ip_set_ip_t *hash_ip,					\
 	     const u_int32_t *flags,					\
 	     unsigned char index)					\
 {									\
 	ip_set_ip_t ip = getfn(skb, flags[index]);			\
 									\
 	KADT_CONDITION							\
-	return FNAME(type,_,adt)(set, hash_ip, ip , ##args);		\
+	return FNAME(type,_,adt)(set, ip , ##args);		\
 }
 
 #define REGISTER_MODULE(type)						\
Index: ipset/kernel/ip_set.c
===================================================================
--- ipset.orig/kernel/ip_set.c	2009-01-02 12:22:42.000000000 +0100
+++ ipset/kernel/ip_set.c	2009-01-02 12:30:12.000000000 +0100
@@ -78,7 +78,6 @@
 		     const u_int32_t *flags)
 {
 	struct ip_set *set;
-	ip_set_ip_t ip;
 	int res;
 	unsigned char i = 0;
 	
@@ -89,7 +88,7 @@
 		IP_SET_ASSERT(set);
 		DP("set %s, index %u", set->name, index);
 		read_lock_bh(&set->lock);
-		res = set->type->testip_kernel(set, skb, &ip, flags, i++);
+		res = set->type->testip_kernel(set, skb, flags, i++);
 		read_unlock_bh(&set->lock);
 		i += !!(set->type->features & IPSET_DATA_DOUBLE);
 	} while (res > 0
@@ -105,7 +104,6 @@
 		    const u_int32_t *flags)
 {
 	struct ip_set *set;
-	ip_set_ip_t ip;
 	int res;
 	unsigned char i = 0;
 
@@ -117,7 +115,7 @@
 		IP_SET_ASSERT(set);
 		DP("set %s, index %u", set->name, index);
 		write_lock_bh(&set->lock);
-		res = set->type->addip_kernel(set, skb, &ip, flags, i++);
+		res = set->type->addip_kernel(set, skb, flags, i++);
 		write_unlock_bh(&set->lock);
 		i += !!(set->type->features & IPSET_DATA_DOUBLE);
 	} while ((res == 0 || res == -EEXIST)
@@ -138,7 +136,6 @@
 		    const u_int32_t *flags)
 {
 	struct ip_set *set;
-	ip_set_ip_t ip;
 	int res;
 	unsigned char i = 0;
 
@@ -149,7 +146,7 @@
 		IP_SET_ASSERT(set);
 		DP("set %s, index %u", set->name, index);
 		write_lock_bh(&set->lock);
-		res = set->type->delip_kernel(set, skb, &ip, flags, i++);
+		res = set->type->delip_kernel(set, skb, flags, i++);
 		write_unlock_bh(&set->lock);
 		i += !!(set->type->features & IPSET_DATA_DOUBLE);
 	} while ((res == 0 || res == -EEXIST)
@@ -352,13 +349,12 @@
 static inline int
 __ip_set_testip(struct ip_set *set,
 	        const void *data,
-	        size_t size,
-	        ip_set_ip_t *ip)
+	        size_t size)
 {
 	int res;
 
 	read_lock_bh(&set->lock);
-	res = set->type->testip(set, data, size, ip);
+	res = set->type->testip(set, data, size);
 	read_unlock_bh(&set->lock);
 
 	return res;
@@ -370,13 +366,12 @@
 	       size_t size)
 {
 	struct ip_set *set = ip_set_list[index];
-	ip_set_ip_t ip;
 	int res;
 	
 	IP_SET_ASSERT(set);
 	do {
 		write_lock_bh(&set->lock);
-		res = set->type->addip(set, data, size, &ip);
+		res = set->type->addip(set, data, size);
 		write_unlock_bh(&set->lock);
 	} while (res == -EAGAIN
 		 && set->type->retry
@@ -411,7 +406,6 @@
 	     size_t size)
 {
 	struct ip_set *set = ip_set_list[index];
-	ip_set_ip_t ip;
 	int res;
 	
 	IP_SET_ASSERT(set);
@@ -425,8 +419,7 @@
 	write_lock_bh(&set->lock);
 	res = set->type->delip(set,
 			       data + sizeof(struct ip_set_req_adt),
-			       size - sizeof(struct ip_set_req_adt),
-			       &ip);
+			       size - sizeof(struct ip_set_req_adt));
 	write_unlock_bh(&set->lock);
 
 	return res;
@@ -438,7 +431,6 @@
 	      size_t size)
 {
 	struct ip_set *set = ip_set_list[index];
-	ip_set_ip_t ip;
 	int res;
 
 	IP_SET_ASSERT(set);
@@ -451,8 +443,7 @@
 	}
 	res = __ip_set_testip(set,
 			      data + sizeof(struct ip_set_req_adt),
-			      size - sizeof(struct ip_set_req_adt),
-			      &ip);
+			      size - sizeof(struct ip_set_req_adt));
 
 	return (res > 0 ? -EEXIST : res);
 }
Index: ipset/kernel/ip_set_iphash.c
===================================================================
--- ipset.orig/kernel/ip_set_iphash.c	2009-01-02 12:38:54.000000000 +0100
+++ ipset/kernel/ip_set_iphash.c	2009-01-02 12:43:33.000000000 +0100
@@ -25,22 +25,23 @@
 static int limit = MAX_RANGE;
 
 static inline __u32
-iphash_id(struct ip_set *set, ip_set_ip_t *hash_ip, ip_set_ip_t ip)
+iphash_id(struct ip_set *set, ip_set_ip_t ip)
 {
 	struct ip_set_iphash *map = set->data;
 	__u32 id;
 	u_int16_t i;
 	ip_set_ip_t *elem;
+	ip_set_ip_t hash_ip;
 
-	*hash_ip = ip & map->netmask;
+	hash_ip = ip & map->netmask;
 	DP("set: %s, ip:%u.%u.%u.%u, %u.%u.%u.%u, %u.%u.%u.%u",
-	   set->name, HIPQUAD(ip), HIPQUAD(*hash_ip), HIPQUAD(map->netmask));
+	   set->name, HIPQUAD(ip), HIPQUAD(hash_ip), HIPQUAD(map->netmask));
 	
 	for (i = 0; i < map->probes; i++) {
-		id = jhash_ip(map, i, *hash_ip) % map->hashsize;
+		id = jhash_ip(map, i, hash_ip) % map->hashsize;
 		DP("hash key: %u", id);
 		elem = HARRAY_ELEM(map->members, ip_set_ip_t *, id);
-		if (*elem == *hash_ip)
+		if (*elem == hash_ip)
 			return id;
 		/* No shortcut at testing - there can be deleted
 		 * entries. */
@@ -49,9 +50,9 @@
 }
 
 static inline int
-iphash_test(struct ip_set *set, ip_set_ip_t *hash_ip, ip_set_ip_t ip)
+iphash_test(struct ip_set *set, ip_set_ip_t ip)
 {
-	return (ip && iphash_id(set, hash_ip, ip) != UINT_MAX);
+	return (ip && iphash_id(set, ip) != UINT_MAX);
 }
 
 #define KADT_CONDITION
@@ -82,16 +83,17 @@
 }
 
 static inline int
-iphash_add(struct ip_set *set, ip_set_ip_t *hash_ip, ip_set_ip_t ip)
+iphash_add(struct ip_set *set, ip_set_ip_t ip)
 {
 	struct ip_set_iphash *map = set->data;
-	
+	ip_set_ip_t hash_ip;
+
 	if (!ip || map->elements >= limit)
 		return -ERANGE;
 
-	*hash_ip = ip & map->netmask;
+	hash_ip = ip & map->netmask;
 	
-	return __iphash_add(map, hash_ip);
+	return __iphash_add(map, &hash_ip);
 }
 
 UADT(iphash, add)
@@ -106,7 +108,7 @@
 HASH_RETRY(iphash, ip_set_ip_t)
 
 static inline int
-iphash_del(struct ip_set *set, ip_set_ip_t *hash_ip, ip_set_ip_t ip)
+iphash_del(struct ip_set *set, ip_set_ip_t ip)
 {
 	struct ip_set_iphash *map = set->data;
 	ip_set_ip_t id, *elem;
@@ -114,7 +116,7 @@
 	if (!ip)
 		return -ERANGE;
 
-	id = iphash_id(set, hash_ip, ip);
+	id = iphash_id(set, ip);
 	if (id == UINT_MAX)
 		return -EEXIST;
 		
Index: ipset/kernel/ip_set_ipmap.c
===================================================================
--- ipset.orig/kernel/ip_set_ipmap.c	2009-01-02 12:24:21.000000000 +0100
+++ ipset/kernel/ip_set_ipmap.c	2009-01-02 12:33:55.000000000 +0100
@@ -26,17 +26,18 @@
 }
 
 static inline int
-ipmap_test(const struct ip_set *set, ip_set_ip_t *hash_ip, ip_set_ip_t ip)
+ipmap_test(const struct ip_set *set, ip_set_ip_t ip)
 {
 	const struct ip_set_ipmap *map = set->data;
-	
+	ip_set_ip_t hash_ip;
+
 	if (ip < map->first_ip || ip > map->last_ip)
 		return -ERANGE;
 
-	*hash_ip = ip & map->netmask;
+	hash_ip = ip & map->netmask;
 	DP("set: %s, ip:%u.%u.%u.%u, %u.%u.%u.%u",
-	   set->name, HIPQUAD(ip), HIPQUAD(*hash_ip));
-	return !!test_bit(ip_to_id(map, *hash_ip), map->members);
+	   set->name, HIPQUAD(ip), HIPQUAD(hash_ip));
+	return !!test_bit(ip_to_id(map, hash_ip), map->members);
 }
 
 #define KADT_CONDITION
@@ -45,16 +46,17 @@
 KADT(ipmap, test, ipaddr)
 
 static inline int
-ipmap_add(struct ip_set *set, ip_set_ip_t *hash_ip, ip_set_ip_t ip)
+ipmap_add(struct ip_set *set, ip_set_ip_t ip)
 {
 	struct ip_set_ipmap *map = set->data;
+	ip_set_ip_t hash_ip;
 
 	if (ip < map->first_ip || ip > map->last_ip)
 		return -ERANGE;
 
-	*hash_ip = ip & map->netmask;
-	DP("%u.%u.%u.%u, %u.%u.%u.%u", HIPQUAD(ip), HIPQUAD(*hash_ip));
-	if (test_and_set_bit(ip_to_id(map, *hash_ip), map->members))
+	hash_ip = ip & map->netmask;
+	DP("%u.%u.%u.%u, %u.%u.%u.%u", HIPQUAD(ip), HIPQUAD(hash_ip));
+	if (test_and_set_bit(ip_to_id(map, hash_ip), map->members))
 		return -EEXIST;
 
 	return 0;
@@ -64,16 +66,17 @@
 KADT(ipmap, add, ipaddr)
 
 static inline int
-ipmap_del(struct ip_set *set, ip_set_ip_t *hash_ip, ip_set_ip_t ip)
+ipmap_del(struct ip_set *set, ip_set_ip_t ip)
 {
 	struct ip_set_ipmap *map = set->data;
+	ip_set_ip_t hash_ip;
 
 	if (ip < map->first_ip || ip > map->last_ip)
 		return -ERANGE;
 
-	*hash_ip = ip & map->netmask;
-	DP("%u.%u.%u.%u, %u.%u.%u.%u", HIPQUAD(ip), HIPQUAD(*hash_ip));
-	if (!test_and_clear_bit(ip_to_id(map, *hash_ip), map->members))
+	hash_ip = ip & map->netmask;
+	DP("%u.%u.%u.%u, %u.%u.%u.%u", HIPQUAD(ip), HIPQUAD(hash_ip));
+	if (!test_and_clear_bit(ip_to_id(map, hash_ip), map->members))
 		return -EEXIST;
 	
 	return 0;
Index: ipset/kernel/ip_set_ipporthash.c
===================================================================
--- ipset.orig/kernel/ip_set_ipporthash.c	2009-01-02 12:47:05.000000000 +0100
+++ ipset/kernel/ip_set_ipporthash.c	2009-01-02 13:04:26.000000000 +0100
@@ -28,26 +28,27 @@
 static int limit = MAX_RANGE;
 
 static inline __u32
-ipporthash_id(struct ip_set *set, ip_set_ip_t *hash_ip,
+ipporthash_id(struct ip_set *set,
 	      ip_set_ip_t ip, ip_set_ip_t port)
 {
 	struct ip_set_ipporthash *map = set->data;
 	__u32 id;
 	u_int16_t i;
 	ip_set_ip_t *elem;
+	ip_set_ip_t hash_ip;
 
-	*hash_ip = pack_ip_port(map, ip, port);
+	hash_ip = pack_ip_port(map, ip, port);
 		
 	DP("set: %s, ipport:%u.%u.%u.%u:%u, %u.%u.%u.%u",
-	   set->name, HIPQUAD(ip), port, HIPQUAD(*hash_ip));
-	if (!*hash_ip)
+	   set->name, HIPQUAD(ip), port, HIPQUAD(hash_ip));
+	if (!hash_ip)
 		return UINT_MAX;
 	
 	for (i = 0; i < map->probes; i++) {
-		id = jhash_ip(map, i, *hash_ip) % map->hashsize;
+		id = jhash_ip(map, i, hash_ip) % map->hashsize;
 		DP("hash key: %u", id);
 		elem = HARRAY_ELEM(map->members, ip_set_ip_t *, id);
-		if (*elem == *hash_ip)
+		if (*elem == hash_ip)
 			return id;
 		/* No shortcut at testing - there can be deleted
 		 * entries. */
@@ -56,7 +57,7 @@
 }
 
 static inline int
-ipporthash_test(struct ip_set *set, ip_set_ip_t *hash_ip,
+ipporthash_test(struct ip_set *set,
 		ip_set_ip_t ip, ip_set_ip_t port)
 {
 	struct ip_set_ipporthash *map = set->data;
@@ -64,7 +65,7 @@
 	if (ip < map->first_ip || ip > map->last_ip)
 		return -ERANGE;
 
-	return (ipporthash_id(set, hash_ip, ip, port) != UINT_MAX);
+	return (ipporthash_id(set, ip, port) != UINT_MAX);
 }
 
 #define KADT_CONDITION						\
@@ -104,21 +105,23 @@
 }
 
 static inline int
-ipporthash_add(struct ip_set *set, ip_set_ip_t *hash_ip,
+ipporthash_add(struct ip_set *set,
 	       ip_set_ip_t ip, ip_set_ip_t port)
 {
 	struct ip_set_ipporthash *map = set->data;
+	ip_set_ip_t hash_ip;
+
 	if (map->elements > limit)
 		return -ERANGE;
 	if (ip < map->first_ip || ip > map->last_ip)
 		return -ERANGE;
 
-	*hash_ip = pack_ip_port(map, ip, port);
+	hash_ip = pack_ip_port(map, ip, port);
 
-	if (!*hash_ip)
+	if (!hash_ip)
 		return -ERANGE;
 	
-	return __ipporthash_add(map, hash_ip);
+	return __ipporthash_add(map, &hash_ip);
 }
 
 UADT(ipporthash, add, req->port)
@@ -135,7 +138,7 @@
 HASH_RETRY(ipporthash, ip_set_ip_t)
 
 static inline int
-ipporthash_del(struct ip_set *set, ip_set_ip_t *hash_ip,
+ipporthash_del(struct ip_set *set,
 	       ip_set_ip_t ip, ip_set_ip_t port)
 {
 	struct ip_set_ipporthash *map = set->data;
@@ -145,7 +148,7 @@
 	if (ip < map->first_ip || ip > map->last_ip)
 		return -ERANGE;
 
-	id = ipporthash_id(set, hash_ip, ip, port);
+	id = ipporthash_id(set, ip, port);
 
 	if (id == UINT_MAX)
 		return -EEXIST;
Index: ipset/kernel/ip_set_ipportnethash.c
===================================================================
--- ipset.orig/kernel/ip_set_ipportnethash.c	2009-01-02 12:51:38.000000000 +0100
+++ ipset/kernel/ip_set_ipportnethash.c	2009-01-02 12:54:13.000000000 +0100
@@ -31,7 +31,7 @@
 	jhash_2words(ipport, ip1, *(map->initval + i))
 
 static inline __u32
-ipportnethash_id_cidr(struct ip_set *set, ip_set_ip_t *hash_ip,
+ipportnethash_id_cidr(struct ip_set *set,
 		      ip_set_ip_t ip, ip_set_ip_t port,
 		      ip_set_ip_t ip1, uint8_t cidr)
 {
@@ -39,19 +39,20 @@
 	__u32 id;
 	u_int16_t i;
 	struct ipportip *elem;
+	ip_set_ip_t hash_ip;
 
-	*hash_ip = pack_ip_port(map, ip, port);
+	hash_ip = pack_ip_port(map, ip, port);
 	DP("set: %s, ipport:%u.%u.%u.%u:%u, %u.%u.%u.%u",
 	   set->name, HIPQUAD(ip), port, HIPQUAD(*hash_ip));
 	ip1 = pack_ip_cidr(ip1, cidr);
-	if (!(*hash_ip || ip1))
+	if (!(hash_ip || ip1))
 		return UINT_MAX;
 	
 	for (i = 0; i < map->probes; i++) {
-		id = jhash_ip2(map, i, *hash_ip, ip1) % map->hashsize;
+		id = jhash_ip2(map, i, hash_ip, ip1) % map->hashsize;
 		DP("hash key: %u", id);
 		elem = HARRAY_ELEM(map->members, struct ipportip *, id);
-		if (elem->ip == *hash_ip && elem->ip1 == ip1)
+		if (elem->ip == hash_ip && elem->ip1 == ip1)
 			return id;
 		/* No shortcut at testing - there can be deleted
 		 * entries. */
@@ -60,7 +61,7 @@
 }
 
 static inline __u32
-ipportnethash_id(struct ip_set *set, ip_set_ip_t *hash_ip,
+ipportnethash_id(struct ip_set *set,
 		 ip_set_ip_t ip, ip_set_ip_t port, ip_set_ip_t ip1)
 {
 	struct ip_set_ipportnethash *map = set->data;
@@ -68,7 +69,7 @@
 	int i;
 
 	for (i = 0; i < 30 && map->cidr[i]; i++) {
-		id = ipportnethash_id_cidr(set, hash_ip, ip, port, ip1, 
+		id = ipportnethash_id_cidr(set, ip, port, ip1, 
 					   map->cidr[i]);
 		if (id != UINT_MAX)
 			break;
@@ -77,7 +78,7 @@
 }
 
 static inline int
-ipportnethash_test_cidr(struct ip_set *set, ip_set_ip_t *hash_ip,
+ipportnethash_test_cidr(struct ip_set *set,
 			ip_set_ip_t ip, ip_set_ip_t port,
 			ip_set_ip_t ip1, uint8_t cidr)
 {
@@ -86,12 +87,12 @@
 	if (ip < map->first_ip || ip > map->last_ip)
 		return -ERANGE;
 
-	return (ipportnethash_id_cidr(set, hash_ip, ip, port, ip1,
+	return (ipportnethash_id_cidr(set, ip, port, ip1,
 				      cidr) != UINT_MAX);
 }
 
 static inline int
-ipportnethash_test(struct ip_set *set, ip_set_ip_t *hash_ip,
+ipportnethash_test(struct ip_set *set,
 		  ip_set_ip_t ip, ip_set_ip_t port, ip_set_ip_t ip1)
 {
 	struct ip_set_ipportnethash *map = set->data;
@@ -99,21 +100,20 @@
 	if (ip < map->first_ip || ip > map->last_ip)
 		return -ERANGE;
 
-	return (ipportnethash_id(set, hash_ip, ip, port, ip1) != UINT_MAX);
+	return (ipportnethash_id(set, ip, port, ip1) != UINT_MAX);
 }
 
 static int
-ipportnethash_utest(struct ip_set *set, const void *data, size_t size,
-		    ip_set_ip_t *hash_ip)
+ipportnethash_utest(struct ip_set *set, const void *data, size_t size)
 {
 	const struct ip_set_req_ipportnethash *req = data;
 
 	if (req->cidr <= 0 || req->cidr > 32)
 		return -EINVAL;
 	return (req->cidr == 32 
-		? ipportnethash_test(set, hash_ip, req->ip, req->port,
+		? ipportnethash_test(set, req->ip, req->port,
 				     req->ip1)
-		: ipportnethash_test_cidr(set, hash_ip, req->ip, req->port,
+		: ipportnethash_test_cidr(set, req->ip, req->port,
 					  req->ip1, req->cidr));
 }
 
@@ -163,14 +163,15 @@
 }
 
 static inline int
-ipportnethash_add(struct ip_set *set, ip_set_ip_t *hash_ip,
+ipportnethash_add(struct ip_set *set,
 		 ip_set_ip_t ip, ip_set_ip_t port,
 		 ip_set_ip_t ip1, uint8_t cidr)
 {
 	struct ip_set_ipportnethash *map = set->data;
 	struct ipportip;
+	ip_set_ip_t hash_ip;
 	int ret;
-	
+
 	if (map->elements > limit)
 		return -ERANGE;
 	if (ip < map->first_ip || ip > map->last_ip)
@@ -180,12 +181,12 @@
 	if (map->nets[cidr-1] == UINT16_MAX)
 		return -ERANGE;
 
-	*hash_ip = pack_ip_port(map, ip, port);
+	hash_ip = pack_ip_port(map, ip, port);
 	ip1 = pack_ip_cidr(ip1, cidr);
-	if (!(*hash_ip || ip1))
+	if (!(hash_ip || ip1))
 		return -ERANGE;
 	
-	ret =__ipportnet_add(map, *hash_ip, ip1);
+	ret =__ipportnet_add(map, hash_ip, ip1);
 	if (ret == 0) {
 		if (!map->nets[cidr-1]++)
 			add_cidr_size(map->cidr, cidr);
@@ -225,7 +226,7 @@
 HASH_RETRY2(ipportnethash, struct ipportip)
 
 static inline int
-ipportnethash_del(struct ip_set *set, ip_set_ip_t *hash_ip,
+ipportnethash_del(struct ip_set *set,
 	          ip_set_ip_t ip, ip_set_ip_t port,
 	          ip_set_ip_t ip1, uint8_t cidr)
 {
@@ -240,7 +241,7 @@
 	if (cidr <= 0 || cidr >= 32)
 		return -EINVAL;	
 
-	id = ipportnethash_id_cidr(set, hash_ip, ip, port, ip1, cidr);
+	id = ipportnethash_id_cidr(set, ip, port, ip1, cidr);
 
 	if (id == UINT_MAX)
 		return -EEXIST;
Index: ipset/kernel/ip_set_iptree.c
===================================================================
--- ipset.orig/kernel/ip_set_iptree.c	2009-01-02 12:54:23.000000000 +0100
+++ ipset/kernel/ip_set_iptree.c	2009-01-02 12:56:04.000000000 +0100
@@ -61,7 +61,7 @@
 } while (0)
 
 static inline int
-iptree_test(struct ip_set *set, ip_set_ip_t *hash_ip, ip_set_ip_t ip)
+iptree_test(struct ip_set *set, ip_set_ip_t ip)
 {
 	struct ip_set_iptree *map = set->data;
 	struct ip_set_iptreeb *btree;
@@ -72,8 +72,7 @@
 	if (!ip)
 		return -ERANGE;
 	
-	*hash_ip = ip;
-	ABCD(a, b, c, d, hash_ip);
+	ABCD(a, b, c, d, &ip);
 	DP("%u %u %u %u timeout %u", a, b, c, d, map->timeout);
 	TESTIP_WALK(map, a, btree);
 	TESTIP_WALK(btree, b, ctree);
@@ -105,7 +104,7 @@
 } while (0)	
 
 static inline int
-iptree_add(struct ip_set *set, ip_set_ip_t *hash_ip,
+iptree_add(struct ip_set *set,
 	   ip_set_ip_t ip, unsigned int timeout)
 {
 	struct ip_set_iptree *map = set->data;
@@ -120,8 +119,7 @@
 		 * but it's probably overkill */
 		return -ERANGE;
 	
-	*hash_ip = ip;
-	ABCD(a, b, c, d, hash_ip);
+	ABCD(a, b, c, d, &ip);
 	DP("%u %u %u %u timeout %u", a, b, c, d, timeout);
 	ADDIP_WALK(map, a, btree, struct ip_set_iptreeb, branch_cachep);
 	ADDIP_WALK(btree, b, ctree, struct ip_set_iptreec, branch_cachep);
@@ -152,7 +150,7 @@
 } while (0)
 
 static inline int
-iptree_del(struct ip_set *set, ip_set_ip_t *hash_ip, ip_set_ip_t ip)
+iptree_del(struct ip_set *set, ip_set_ip_t ip)
 {
 	struct ip_set_iptree *map = set->data;
 	struct ip_set_iptreeb *btree;
@@ -163,8 +161,7 @@
 	if (!ip)
 		return -ERANGE;
 		
-	*hash_ip = ip;
-	ABCD(a, b, c, d, hash_ip);
+	ABCD(a, b, c, d, &ip);
 	DELIP_WALK(map, a, btree);
 	DELIP_WALK(btree, b, ctree);
 	DELIP_WALK(ctree, c, dtree);
Index: ipset/kernel/ip_set_iptreemap.c
===================================================================
--- ipset.orig/kernel/ip_set_iptreemap.c	2009-01-02 12:56:17.000000000 +0100
+++ ipset/kernel/ip_set_iptreemap.c	2009-01-02 12:57:52.000000000 +0100
@@ -250,7 +250,7 @@
 }
 
 static inline int
-iptreemap_test(struct ip_set *set, ip_set_ip_t *hash_ip, ip_set_ip_t ip)
+iptreemap_test(struct ip_set *set, ip_set_ip_t ip)
 {
 	struct ip_set_iptreemap *map = set->data;
 	struct ip_set_iptreemap_b *btree;
@@ -258,9 +258,7 @@
 	struct ip_set_iptreemap_d *dtree;
 	unsigned char a, b, c, d;
 
-	*hash_ip = ip;
-
-	ABCD(a, b, c, d, hash_ip);
+	ABCD(a, b, c, d, &ip);
 
 	TESTIP_WALK(map, a, btree, fullbitmap_b);
 	TESTIP_WALK(btree, b, ctree, fullbitmap_c);
@@ -275,7 +273,7 @@
 KADT(iptreemap, test, ipaddr)
 
 static inline int
-__addip_single(struct ip_set *set, ip_set_ip_t *hash_ip, ip_set_ip_t ip)
+__addip_single(struct ip_set *set, ip_set_ip_t ip)
 {
 	struct ip_set_iptreemap *map = (struct ip_set_iptreemap *) set->data;
 	struct ip_set_iptreemap_b *btree;
@@ -283,9 +281,7 @@
 	struct ip_set_iptreemap_d *dtree;
 	unsigned char a, b, c, d;
 
-	*hash_ip = ip;
-
-	ABCD(a, b, c, d, hash_ip);
+	ABCD(a, b, c, d, &ip);
 
 	ADDIP_WALK(map, a, btree, struct ip_set_iptreemap_b, cachep_b, fullbitmap_b);
 	ADDIP_WALK(btree, b, ctree, struct ip_set_iptreemap_c, cachep_c, fullbitmap_c);
@@ -300,7 +296,7 @@
 }
 
 static inline int
-iptreemap_add(struct ip_set *set, ip_set_ip_t *hash_ip,
+iptreemap_add(struct ip_set *set,
 	      ip_set_ip_t start, ip_set_ip_t end)
 {
 	struct ip_set_iptreemap *map = set->data;
@@ -312,9 +308,7 @@
 	unsigned char a2, b2, c2, d2;
 
 	if (start == end)
-		return __addip_single(set, hash_ip, start);
-
-	*hash_ip = start;
+		return __addip_single(set, start);
 
 	ABCD(a1, b1, c1, d1, &start);
 	ABCD(a2, b2, c2, d2, &end);
@@ -337,7 +331,7 @@
 KADT(iptreemap, add, ipaddr, ip)
 
 static inline int
-__delip_single(struct ip_set *set, ip_set_ip_t *hash_ip,
+__delip_single(struct ip_set *set,
 	       ip_set_ip_t ip, unsigned int __nocast flags)
 {
 	struct ip_set_iptreemap *map = set->data;
@@ -346,9 +340,7 @@
 	struct ip_set_iptreemap_d *dtree;
 	unsigned char a,b,c,d;
 
-	*hash_ip = ip;
-
-	ABCD(a, b, c, d, hash_ip);
+	ABCD(a, b, c, d, &ip);
 
 	DELIP_WALK(map, a, btree, cachep_b, fullbitmap_b, flags);
 	DELIP_WALK(btree, b, ctree, cachep_c, fullbitmap_c, flags);
@@ -363,7 +355,7 @@
 }
 
 static inline int
-iptreemap_del(struct ip_set *set, ip_set_ip_t *hash_ip,
+iptreemap_del(struct ip_set *set,
 	      ip_set_ip_t start, ip_set_ip_t end, unsigned int __nocast flags)
 {
 	struct ip_set_iptreemap *map = set->data;
@@ -375,9 +367,7 @@
 	unsigned char a2, b2, c2, d2;
 
 	if (start == end)
-		return __delip_single(set, hash_ip, start, flags);
-
-	*hash_ip = start;
+		return __delip_single(set, start, flags);
 
 	ABCD(a1, b1, c1, d1, &start);
 	ABCD(a2, b2, c2, d2, &end);
Index: ipset/kernel/ip_set_macipmap.c
===================================================================
--- ipset.orig/kernel/ip_set_macipmap.c	2009-01-02 12:34:15.000000000 +0100
+++ ipset/kernel/ip_set_macipmap.c	2009-01-02 12:36:02.000000000 +0100
@@ -22,8 +22,7 @@
 #include <linux/netfilter_ipv4/ip_set_macipmap.h>
 
 static int
-macipmap_utest(struct ip_set *set, const void *data, size_t size,
-	       ip_set_ip_t *hash_ip)
+macipmap_utest(struct ip_set *set, const void *data, size_t size)
 {
 	const struct ip_set_macipmap *map = set->data;
 	const struct ip_set_macip *table = map->members;	
@@ -32,9 +31,8 @@
 	if (req->ip < map->first_ip || req->ip > map->last_ip)
 		return -ERANGE;
 
-	*hash_ip = req->ip;
 	DP("set: %s, ip:%u.%u.%u.%u, %u.%u.%u.%u",
-	   set->name, HIPQUAD(req->ip), HIPQUAD(*hash_ip));		
+	   set->name, HIPQUAD(req->ip), HIPQUAD(req->ip));		
 	if (test_bit(IPSET_MACIP_ISSET,
 		     (void *) &table[req->ip - map->first_ip].flags)) {
 		return (memcmp(req->ethernet,
@@ -48,7 +46,6 @@
 static int
 macipmap_ktest(struct ip_set *set,
 	       const struct sk_buff *skb,
-	       ip_set_ip_t *hash_ip,
 	       const u_int32_t *flags,
 	       unsigned char index)
 {
@@ -61,9 +58,8 @@
 	if (ip < map->first_ip || ip > map->last_ip)
 		return 0;
 
-	*hash_ip = ip;	
 	DP("set: %s, ip:%u.%u.%u.%u, %u.%u.%u.%u",
-	   set->name, HIPQUAD(ip), HIPQUAD(*hash_ip));		
+	   set->name, HIPQUAD(ip), HIPQUAD(ip));		
 	if (test_bit(IPSET_MACIP_ISSET,
 	    (void *) &table[ip - map->first_ip].flags)) {
 		/* Is mac pointer valid?
@@ -80,7 +76,7 @@
 
 /* returns 0 on success */
 static inline int
-macipmap_add(struct ip_set *set, ip_set_ip_t *hash_ip,
+macipmap_add(struct ip_set *set,
 	     ip_set_ip_t ip, const unsigned char *ethernet)
 {
 	struct ip_set_macipmap *map = set->data;
@@ -92,8 +88,7 @@
 			     (void *) &table[ip - map->first_ip].flags))
 		return -EEXIST;
 
-	*hash_ip = ip;
-	DP("%u.%u.%u.%u, %u.%u.%u.%u", HIPQUAD(ip), HIPQUAD(*hash_ip));
+	DP("%u.%u.%u.%u, %u.%u.%u.%u", HIPQUAD(ip), HIPQUAD(ip));
 	memcpy(&table[ip - map->first_ip].ethernet, ethernet, ETH_ALEN);
 	return 0;
 }
@@ -107,7 +102,7 @@
 KADT(macipmap, add, ipaddr, eth_hdr(skb)->h_source)
 
 static inline int
-macipmap_del(struct ip_set *set, ip_set_ip_t *hash_ip, ip_set_ip_t ip)
+macipmap_del(struct ip_set *set, ip_set_ip_t ip)
 {
 	struct ip_set_macipmap *map = set->data;
 	struct ip_set_macip *table = map->members;
@@ -118,8 +113,7 @@
 				(void *)&table[ip - map->first_ip].flags))
 		return -EEXIST;
 
-	*hash_ip = ip;
-	DP("%u.%u.%u.%u, %u.%u.%u.%u", HIPQUAD(ip), HIPQUAD(*hash_ip));
+	DP("%u.%u.%u.%u, %u.%u.%u.%u", HIPQUAD(ip), HIPQUAD(ip));
 	return 0;
 }
 
Index: ipset/kernel/ip_set_nethash.c
===================================================================
--- ipset.orig/kernel/ip_set_nethash.c	2009-01-02 12:46:44.000000000 +0100
+++ ipset/kernel/ip_set_nethash.c	2009-01-02 12:46:04.000000000 +0100
@@ -26,37 +26,37 @@
 
 static inline __u32
 nethash_id_cidr(const struct ip_set_nethash *map,
-		ip_set_ip_t *hash_ip,
 		ip_set_ip_t ip,
 		uint8_t cidr)
 {
 	__u32 id;
 	u_int16_t i;
 	ip_set_ip_t *elem;
+	ip_set_ip_t hash_ip;
 
-	*hash_ip = pack_ip_cidr(ip, cidr);
-	if (!*hash_ip)
+	hash_ip = pack_ip_cidr(ip, cidr);
+	if (!hash_ip)
 		return MAX_RANGE;
 	
 	for (i = 0; i < map->probes; i++) {
-		id = jhash_ip(map, i, *hash_ip) % map->hashsize;
+		id = jhash_ip(map, i, hash_ip) % map->hashsize;
 	   	DP("hash key: %u", id);
 		elem = HARRAY_ELEM(map->members, ip_set_ip_t *, id);
-	   	if (*elem == *hash_ip)
+	   	if (*elem == hash_ip)
 			return id;
 	}
 	return UINT_MAX;
 }
 
 static inline __u32
-nethash_id(struct ip_set *set, ip_set_ip_t *hash_ip, ip_set_ip_t ip)
+nethash_id(struct ip_set *set, ip_set_ip_t ip)
 {
 	const struct ip_set_nethash *map = set->data;
 	__u32 id = UINT_MAX;
 	int i;
 
 	for (i = 0; i < 30 && map->cidr[i]; i++) {
-		id = nethash_id_cidr(map, hash_ip, ip, map->cidr[i]);
+		id = nethash_id_cidr(map, ip, map->cidr[i]);
 		if (id != UINT_MAX)
 			break;
 	}
@@ -64,30 +64,29 @@
 }
 
 static inline int
-nethash_test_cidr(struct ip_set *set, ip_set_ip_t *hash_ip,
+nethash_test_cidr(struct ip_set *set,
 		  ip_set_ip_t ip, uint8_t cidr)
 {
 	const struct ip_set_nethash *map = set->data;
 
-	return (nethash_id_cidr(map, hash_ip, ip, cidr) != UINT_MAX);
+	return (nethash_id_cidr(map, ip, cidr) != UINT_MAX);
 }
 
 static inline int
-nethash_test(struct ip_set *set, ip_set_ip_t *hash_ip, ip_set_ip_t ip)
+nethash_test(struct ip_set *set, ip_set_ip_t ip)
 {
-	return (nethash_id(set, hash_ip, ip) != UINT_MAX);
+	return (nethash_id(set, ip) != UINT_MAX);
 }
 
 static int
-nethash_utest(struct ip_set *set, const void *data, size_t size,
-	      ip_set_ip_t *hash_ip)
+nethash_utest(struct ip_set *set, const void *data, size_t size)
 {
 	const struct ip_set_req_nethash *req = data;
 
 	if (req->cidr <= 0 || req->cidr > 32)
 		return -EINVAL;
-	return (req->cidr == 32 ? nethash_test(set, hash_ip, req->ip)
-		: nethash_test_cidr(set, hash_ip, req->ip, req->cidr));
+	return (req->cidr == 32 ? nethash_test(set, req->ip)
+		: nethash_test_cidr(set, req->ip, req->cidr));
 }
 
 #define KADT_CONDITION
@@ -116,10 +115,11 @@
 }
 
 static inline int
-nethash_add(struct ip_set *set, ip_set_ip_t *hash_ip,
+nethash_add(struct ip_set *set,
 	    ip_set_ip_t ip, uint8_t cidr)
 {
 	struct ip_set_nethash *map = set->data;
+	ip_set_ip_t hash_ip;
 	int ret;
 	
 	if (map->elements >= limit || map->nets[cidr-1] == UINT16_MAX)
@@ -127,12 +127,12 @@
 	if (cidr <= 0 || cidr >= 32)
 		return -EINVAL;
 
-	*hash_ip = pack_ip_cidr(ip, cidr);
-	DP("%u.%u.%u.%u/%u, %u.%u.%u.%u", HIPQUAD(ip), cidr, HIPQUAD(*hash_ip));
-	if (!*hash_ip)
+	hash_ip = pack_ip_cidr(ip, cidr);
+	DP("%u.%u.%u.%u/%u, %u.%u.%u.%u", HIPQUAD(ip), cidr, HIPQUAD(hash_ip));
+	if (!hash_ip)
 		return -ERANGE;
 	
-	ret = __nethash_add(map, hash_ip);
+	ret = __nethash_add(map, &hash_ip);
 	if (ret == 0) {
 		if (!map->nets[cidr-1]++)
 			add_cidr_size(map->cidr, cidr);
@@ -160,7 +160,7 @@
 HASH_RETRY(nethash, ip_set_ip_t)
 
 static inline int
-nethash_del(struct ip_set *set, ip_set_ip_t *hash_ip,
+nethash_del(struct ip_set *set,
 	    ip_set_ip_t ip, uint8_t cidr)
 {
 	struct ip_set_nethash *map = set->data;
@@ -169,7 +169,7 @@
 	if (cidr <= 0 || cidr >= 32)
 		return -EINVAL;	
 	
-	id = nethash_id_cidr(map, hash_ip, ip, cidr);
+	id = nethash_id_cidr(map, ip, cidr);
 	if (id == UINT_MAX)
 		return -EEXIST;
 		
Index: ipset/kernel/ip_set_portmap.c
===================================================================
--- ipset.orig/kernel/ip_set_portmap.c	2009-01-02 12:36:17.000000000 +0100
+++ ipset/kernel/ip_set_portmap.c	2009-01-02 12:37:11.000000000 +0100
@@ -23,16 +23,14 @@
 #include <linux/netfilter_ipv4/ip_set_getport.h>
 
 static inline int
-portmap_test(const struct ip_set *set, ip_set_ip_t *hash_port,
-	     ip_set_ip_t port)
+portmap_test(const struct ip_set *set, ip_set_ip_t port)
 {
 	const struct ip_set_portmap *map = set->data;
 
 	if (port < map->first_ip || port > map->last_ip)
 		return -ERANGE;
 		
-	*hash_port = port;
-	DP("set: %s, port:%u, %u", set->name, port, *hash_port);
+	DP("set: %s, port:%u, %u", set->name, port, port);
 	return !!test_bit(port - map->first_ip, map->members);
 }
 
@@ -44,7 +42,7 @@
 KADT(portmap, test, get_port)
 
 static inline int
-portmap_add(struct ip_set *set, ip_set_ip_t *hash_port, ip_set_ip_t port)
+portmap_add(struct ip_set *set, ip_set_ip_t port)
 {
 	struct ip_set_portmap *map = set->data;
 
@@ -53,7 +51,6 @@
 	if (test_and_set_bit(port - map->first_ip, map->members))
 		return -EEXIST;
 		
-	*hash_port = port;
 	DP("port %u", port);
 	return 0;
 }
@@ -62,7 +59,7 @@
 KADT(portmap, add, get_port)
 
 static inline int
-portmap_del(struct ip_set *set, ip_set_ip_t *hash_port, ip_set_ip_t port)
+portmap_del(struct ip_set *set, ip_set_ip_t port)
 {
 	struct ip_set_portmap *map = set->data;
 
@@ -71,7 +68,6 @@
 	if (!test_and_clear_bit(port - map->first_ip, map->members))
 		return -EEXIST;
 		
-	*hash_port = port;
 	DP("port %u", port);
 	return 0;
 }
Index: ipset/kernel/ip_set_setlist.c
===================================================================
--- ipset.orig/kernel/ip_set_setlist.c	2009-01-02 12:24:21.000000000 +0100
+++ ipset/kernel/ip_set_setlist.c	2009-01-02 12:59:26.000000000 +0100
@@ -28,8 +28,7 @@
 }
 
 static int
-setlist_utest(struct ip_set *set, const void *data, size_t size,
-	       ip_set_ip_t *hash_ip)
+setlist_utest(struct ip_set *set, const void *data, size_t size)
 {
 	const struct ip_set_setlist *map = set->data;
 	const struct ip_set_req_setlist *req = data;
@@ -75,7 +74,6 @@
 static int
 setlist_ktest(struct ip_set *set,
 	       const struct sk_buff *skb,
-	       ip_set_ip_t *hash_ip,
 	       const u_int32_t *flags,
 	       unsigned char index)
 {
@@ -109,8 +107,7 @@
 }
 
 static int
-setlist_uadd(struct ip_set *set, const void *data, size_t size,
-	     ip_set_ip_t *hash_ip)
+setlist_uadd(struct ip_set *set, const void *data, size_t size)
 {
 	struct ip_set_setlist *map = set->data;
 	const struct ip_set_req_setlist *req = data;
@@ -158,7 +155,6 @@
 static int
 setlist_kadd(struct ip_set *set,
 	     const struct sk_buff *skb,
-	     ip_set_ip_t *hash_ip,
 	     const u_int32_t *flags,
 	     unsigned char index)
 {
@@ -184,8 +180,7 @@
 }
 
 static int
-setlist_udel(struct ip_set *set, const void *data, size_t size,
-	     ip_set_ip_t *hash_ip)
+setlist_udel(struct ip_set *set, const void *data, size_t size)
 {
 	struct ip_set_setlist *map = set->data;
 	const struct ip_set_req_setlist *req = data;
@@ -236,7 +231,6 @@
 static int
 setlist_kdel(struct ip_set *set,
 	     const struct sk_buff *skb,
-	     ip_set_ip_t *hash_ip,
 	     const u_int32_t *flags,
 	     unsigned char index)
 {

--=-SM34i6kg/QT8qULe2PgC--

