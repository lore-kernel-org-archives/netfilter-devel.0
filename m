From: Sven Wegener <sven.wegener@stealer.net>
Subject: [RFC] ipset: New set type iptreemap, kernel part
Date: Mon, 20 Aug 2007 22:36:56 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0708202210010.14154@titan.stealer.net>
References: <Pine.LNX.4.64.0708202149370.14154@titan.stealer.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.64.0708202149370.14154@titan.stealer.net>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

  include/linux/netfilter_ipv4/ip_set_iptreemap.h |   40 +
  net/ipv4/netfilter/Kconfig                      |    8
  net/ipv4/netfilter/Makefile                     |    1
  net/ipv4/netfilter/ip_set_iptreemap.c           |  761 +++++++++++++++++++++++
  4 files changed, 810 insertions(+), 0 deletions(-)

diff --git a/include/linux/netfilter_ipv4/ip_set_iptreemap.h b/include/linux/netfilter_ipv4/ip_set_iptreemap.h
new file mode 100644
index 0000000..bef576a
--- /dev/null
+++ b/include/linux/netfilter_ipv4/ip_set_iptreemap.h
@@ -0,0 +1,40 @@
+#ifndef __IP_SET_IPTREEMAP_H
+#define __IP_SET_IPTREEMAP_H
+
+#include <linux/netfilter_ipv4/ip_set.h>
+
+#define SETTYPE_NAME "iptreemap"
+
+#ifdef __KERNEL__
+struct ip_set_iptreemap_d {
+	unsigned char bitmap[32]; /* x.x.x.y */
+};
+
+struct ip_set_iptreemap_c {
+	struct ip_set_iptreemap_d *tree[256]; /* x.x.y.x */
+};
+
+struct ip_set_iptreemap_b {
+	struct ip_set_iptreemap_c *tree[256]; /* x.y.x.x */
+	unsigned char dirty[32];
+};
+#endif
+
+struct ip_set_iptreemap {
+	unsigned int gc_interval;
+#ifdef __KERNEL__
+	struct timer_list gc;
+	struct ip_set_iptreemap_b *tree[256]; /* y.x.x.x */
+#endif
+};
+
+struct ip_set_req_iptreemap_create {
+	unsigned int gc_interval;
+};
+
+struct ip_set_req_iptreemap {
+	ip_set_ip_t start;
+	ip_set_ip_t end;
+};
+
+#endif /* __IP_SET_IPTREEMAP_H */
diff --git a/net/ipv4/netfilter/Kconfig b/net/ipv4/netfilter/Kconfig
index c97fb3f..bfd906f 100644
--- a/net/ipv4/netfilter/Kconfig
+++ b/net/ipv4/netfilter/Kconfig
@@ -695,6 +695,14 @@ config IP_NF_SET_IPTREE

  	  To compile it as a module, choose M here.  If unsure, say N.

+config IP_NF_SET_IPTREEMAP
+	tristate "iptreemap set support"
+	depends on IP_NF_SET
+	help
+	  This option adds the iptreemap set type support.
+
+	  To compile it as a module, choose M here.  If unsure, say N.
+
  config IP_NF_MATCH_SET
  	tristate "set match support"
  	depends on IP_NF_SET
diff --git a/net/ipv4/netfilter/Makefile b/net/ipv4/netfilter/Makefile
index 7c09bf3..ab7e3ca 100644
--- a/net/ipv4/netfilter/Makefile
+++ b/net/ipv4/netfilter/Makefile
@@ -89,6 +89,7 @@ obj-$(CONFIG_IP_NF_SET_IPHASH) += ip_set_iphash.o
  obj-$(CONFIG_IP_NF_SET_NETHASH) += ip_set_nethash.o
  obj-$(CONFIG_IP_NF_SET_IPPORTHASH) += ip_set_ipporthash.o
  obj-$(CONFIG_IP_NF_SET_IPTREE) += ip_set_iptree.o
+obj-$(CONFIG_IP_NF_SET_IPTREEMAP) += ip_set_iptreemap.o

  # generic ARP tables
  obj-$(CONFIG_IP_NF_ARPTABLES) += arp_tables.o
diff --git a/net/ipv4/netfilter/ip_set_iptreemap.c b/net/ipv4/netfilter/ip_set_iptreemap.c
new file mode 100644
index 0000000..4f319c5
--- /dev/null
+++ b/net/ipv4/netfilter/ip_set_iptreemap.c
@@ -0,0 +1,761 @@
+/* Copyright (C) 2007 Sven Wegener <sven.wegener@stealer.net>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published by
+ * the Free Software Foundation.
+ */
+
+/* This modules implements the iptreemap ipset type. It uses bitmaps to
+ * represent every single IPv4 address as a single bit. The bitmaps are managed
+ * in a tree structure, where the first three octets of an addresses are used
+ * as an index to find the bitmap and the last octet is used as the bit number.
+ */
+
+#include <linux/module.h>
+#include <linux/ip.h>
+#include <linux/skbuff.h>
+#include <linux/slab.h>
+#include <linux/delay.h>
+#include <linux/netfilter_ipv4/ip_tables.h>
+#include <linux/netfilter_ipv4/ip_set.h>
+#include <linux/errno.h>
+#include <asm/uaccess.h>
+#include <asm/bitops.h>
+#include <linux/spinlock.h>
+
+#include <linux/netfilter_ipv4/ip_set_iptreemap.h>
+
+#define IPTREEMAP_DEFAULT_GC_TIME (5 * 60)
+#define IPTREEMAP_DESTROY_SLEEP (100)
+
+static kmem_cache_t *cachep_b;
+static kmem_cache_t *cachep_c;
+static kmem_cache_t *cachep_d;
+
+static struct ip_set_iptreemap_d *fullbitmap_d;
+static struct ip_set_iptreemap_c *fullbitmap_c;
+static struct ip_set_iptreemap_b *fullbitmap_b;
+
+#define ABCD(a, b, c, d, addr) \
+	do { \
+		a = ((unsigned char *)addr)[3]; \
+		b = ((unsigned char *)addr)[2]; \
+		c = ((unsigned char *)addr)[1]; \
+		d = ((unsigned char *)addr)[0]; \
+	} while (0)
+
+#define TESTIP_WALK(map, elem, branch, full) \
+	do { \
+		branch = (map)->tree[elem]; \
+		if (!branch) \
+			return 0; \
+		else if (branch == full) \
+			return 1; \
+	} while (0)
+
+#define ADDIP_WALK(map, elem, branch, type, cachep, full, flags) \
+	do { \
+		branch = (map)->tree[elem]; \
+		if (!branch) { \
+			branch = (type *) kmem_cache_alloc(cachep, flags); \
+			if (!branch) \
+				return -ENOMEM; \
+			memset(branch, 0, sizeof(*branch)); \
+			(map)->tree[elem] = branch; \
+		} else if (branch == full) { \
+			return -EEXIST; \
+		} \
+	} while (0)
+
+#define ADDIP_RANGE_LOOP(map, a, a1, a2, hint, branch, full, cachep, free, flags) \
+	for (a = a1; a <= a2; a++) { \
+		branch = (map)->tree[a]; \
+		if (branch != full) { \
+			if ((a > a1 && a < a2) || (hint)) { \
+				if (branch) \
+					free(branch); \
+				(map)->tree[a] = full; \
+				continue; \
+			} else if (!branch) { \
+				branch = kmem_cache_alloc(cachep, flags); \
+				if (!branch) \
+					return -ENOMEM; \
+				memset(branch, 0, sizeof(*branch)); \
+				(map)->tree[a] = branch; \
+			}
+
+#define ADDIP_RANGE_LOOP_END() \
+		} \
+	}
+
+#define DELIP_WALK(map, elem, branch, cachep, full, flags) \
+	do { \
+		branch = (map)->tree[elem]; \
+		if (!branch) { \
+			return -EEXIST; \
+		} else if (branch == full) { \
+			branch = kmem_cache_alloc(cachep, flags); \
+			if (!branch) \
+				return -ENOMEM; \
+			memcpy(branch, full, sizeof(*full)); \
+			(map)->tree[elem] = branch; \
+		} \
+	} while (0)
+
+#define DELIP_RANGE_LOOP(map, a, a1, a2, hint, branch, full, cachep, free, flags) \
+	for (a = a1; a <= a2; a++) { \
+		branch = (map)->tree[a]; \
+		if (branch) { \
+			if ((a > a1 && a < a2) || (hint)) { \
+				if (branch != full) \
+					free(branch); \
+				(map)->tree[a] = NULL; \
+				continue; \
+			} else if (branch == full) { \
+				branch = kmem_cache_alloc(cachep, flags); \
+				if (!branch) \
+					return -ENOMEM; \
+				memcpy(branch, full, sizeof(*branch)); \
+				(map)->tree[a] = branch; \
+			}
+
+#define DELIP_RANGE_LOOP_END() \
+		} \
+	}
+
+#define LOOP_WALK_BEGIN(map, i, branch) \
+	for (i = 0; i < 256; i++) { \
+		branch = (map)->tree[i]; \
+		if (likely(!branch)) \
+			continue;
+
+#define LOOP_WALK_END() \
+	}
+
+#define LOOP_WALK_BEGIN_GC(map, i, branch, full, cachep, count) \
+	count = -256; \
+	for (i = 0; i < 256; i++) { \
+		branch = (map)->tree[i]; \
+		if (likely(!branch)) \
+			continue; \
+		count++; \
+		if (branch == full) { \
+			count++; \
+			continue; \
+		}
+
+#define LOOP_WALK_END_GC(map, i, branch, full, cachep, count) \
+		if (-256 == count) { \
+			kmem_cache_free(cachep, branch); \
+			(map)->tree[i] = NULL; \
+		} else if (256 == count) { \
+			kmem_cache_free(cachep, branch); \
+			(map)->tree[i] = full; \
+		} \
+	}
+
+#define LOOP_WALK_BEGIN_COUNT(map, i, branch, inrange, count) \
+	for (i = 0; i < 256; i++) { \
+		if (!(map)->tree[i]) { \
+			if (inrange) { \
+				count++; \
+				inrange = 0; \
+			} \
+			continue; \
+		} \
+		branch = (map)->tree[i];
+
+#define LOOP_WALK_END_COUNT() \
+	}
+
+#define MIN(a, b) (a < b ? a : b)
+#define MAX(a, b) (a > b ? a : b)
+
+#define GETVALUE1(a, a1, b1, r) \
+	(a == a1 ? b1 : r)
+
+#define GETVALUE2(a, b, a1, b1, c1, r) \
+	(a == a1 && b == b1 ? c1 : r)
+
+#define GETVALUE3(a, b, c, a1, b1, c1, d1, r) \
+	(a == a1 && b == b1 && c == c1 ? d1 : r)
+
+#define CHECK1(a, a1, a2, b1, b2, c1, c2, d1, d2) \
+	( \
+		GETVALUE1(a, a1, b1, 0) == 0 \
+		&& GETVALUE1(a, a2, b2, 255) == 255 \
+		&& c1 == 0 \
+		&& c2 == 255 \
+		&& d1 == 0 \
+		&& d2 == 255 \
+	)
+
+#define CHECK2(a, b, a1, a2, b1, b2, c1, c2, d1, d2) \
+	( \
+		GETVALUE2(a, b, a1, b1, c1, 0) == 0 \
+		&& GETVALUE2(a, b, a2, b2, c2, 255) == 255 \
+		&& d1 == 0 \
+		&& d2 == 255 \
+	)
+
+#define CHECK3(a, b, c, a1, a2, b1, b2, c1, c2, d1, d2) \
+	( \
+		GETVALUE3(a, b, c, a1, b1, c1, d1, 0) == 0 \
+		&& GETVALUE3(a, b, c, a2, b2, c2, d2, 255) == 255 \
+	)
+
+
+static inline void
+free_d(struct ip_set_iptreemap_d *map)
+{
+	kmem_cache_free(cachep_d, map);
+}
+
+static inline void
+free_c(struct ip_set_iptreemap_c *map)
+{
+	struct ip_set_iptreemap_d *dtree;
+	unsigned int i;
+
+	LOOP_WALK_BEGIN(map, i, dtree) {
+		if (dtree != fullbitmap_d)
+			free_d(dtree);
+	} LOOP_WALK_END();
+
+	kmem_cache_free(cachep_c, map);
+}
+
+static inline void
+free_b(struct ip_set_iptreemap_b *map)
+{
+	struct ip_set_iptreemap_c *ctree;
+	unsigned int i;
+
+	LOOP_WALK_BEGIN(map, i, ctree) {
+		if (ctree != fullbitmap_c)
+			free_c(ctree);
+	} LOOP_WALK_END();
+
+	kmem_cache_free(cachep_b, map);
+}
+
+static inline int
+__testip(struct ip_set *set, ip_set_ip_t ip, ip_set_ip_t *hash_ip)
+{
+	struct ip_set_iptreemap *map = (struct ip_set_iptreemap *) set->data;
+	struct ip_set_iptreemap_b *btree;
+	struct ip_set_iptreemap_c *ctree;
+	struct ip_set_iptreemap_d *dtree;
+	unsigned char a, b, c, d;
+
+	*hash_ip = ip;
+
+	ABCD(a, b, c, d, hash_ip);
+
+	TESTIP_WALK(map, a, btree, fullbitmap_b);
+	TESTIP_WALK(btree, b, ctree, fullbitmap_c);
+	TESTIP_WALK(ctree, c, dtree, fullbitmap_d);
+
+	return !!test_bit(d, (void *) dtree->bitmap);
+}
+
+static int
+testip(struct ip_set *set, const void *data, size_t size, ip_set_ip_t *hash_ip)
+{
+	struct ip_set_req_iptreemap *req = (struct ip_set_req_iptreemap *) data;
+
+	if (size != sizeof(struct ip_set_req_iptreemap)) {
+		ip_set_printk("data length wrong (want %zu, have %zu)", sizeof(struct ip_set_req_iptreemap), size);
+		return -EINVAL;
+	}
+
+	return __testip(set, req->start, hash_ip);
+}
+
+static int
+testip_kernel(struct ip_set *set, const struct sk_buff *skb, ip_set_ip_t *hash_ip, const u_int32_t *flags, unsigned char index)
+{
+	int res;
+
+	res = __testip(set, ntohl(flags[index] & IPSET_SRC ? skb->nh.iph->saddr : skb->nh.iph->daddr), hash_ip);
+
+	return (res < 0 ? 0 : res);
+}
+
+static inline int
+__addip_single(struct ip_set *set, ip_set_ip_t ip, ip_set_ip_t *hash_ip, unsigned int __nocast flags)
+{
+	struct ip_set_iptreemap *map = (struct ip_set_iptreemap *) set->data;
+	struct ip_set_iptreemap_b *btree;
+	struct ip_set_iptreemap_c *ctree;
+	struct ip_set_iptreemap_d *dtree;
+	unsigned char a, b, c, d;
+
+	*hash_ip = ip;
+
+	ABCD(a, b, c, d, hash_ip);
+
+	ADDIP_WALK(map, a, btree, struct ip_set_iptreemap_b, cachep_b, fullbitmap_b, flags);
+	ADDIP_WALK(btree, b, ctree, struct ip_set_iptreemap_c, cachep_c, fullbitmap_c, flags);
+	ADDIP_WALK(ctree, c, dtree, struct ip_set_iptreemap_d, cachep_d, fullbitmap_d, flags);
+
+	if (test_and_set_bit(d, (void *) dtree->bitmap))
+		return -EEXIST;
+
+	set_bit(b, (void *) btree->dirty);
+
+	return 0;
+}
+
+static inline int
+__addip_range(struct ip_set *set, ip_set_ip_t start, ip_set_ip_t end, ip_set_ip_t *hash_ip, unsigned int __nocast flags)
+{
+	struct ip_set_iptreemap *map = (struct ip_set_iptreemap *) set->data;
+	struct ip_set_iptreemap_b *btree;
+	struct ip_set_iptreemap_c *ctree;
+	struct ip_set_iptreemap_d *dtree;
+	unsigned int a, b, c, d;
+	unsigned char a1, b1, c1, d1;
+	unsigned char a2, b2, c2, d2;
+
+	if (start == end)
+		return __addip_single(set, start, hash_ip, flags);
+
+	*hash_ip = start;
+
+	ABCD(a1, b1, c1, d1, &start);
+	ABCD(a2, b2, c2, d2, &end);
+
+	/* This is sooo ugly... */
+	ADDIP_RANGE_LOOP(map, a, a1, a2, CHECK1(a, a1, a2, b1, b2, c1, c2, d1, d2), btree, fullbitmap_b, cachep_b, free_b, flags) {
+		ADDIP_RANGE_LOOP(btree, b, GETVALUE1(a, a1, b1, 0), GETVALUE1(a, a2, b2, 255), CHECK2(a, b, a1, a2, b1, b2, c1, c2, d1, d2), ctree, fullbitmap_c, cachep_c, free_c, flags) {
+			ADDIP_RANGE_LOOP(ctree, c, GETVALUE2(a, b, a1, b1, c1, 0), GETVALUE2(a, b, a2, b2, c2, 255), CHECK3(a, b, c, a1, a2, b1, b2, c1, c2, d1, d2), dtree, fullbitmap_d, cachep_d, free_d, flags) {
+				for (d = GETVALUE3(a, b, c, a1, b1, c1, d1, 0); d <= GETVALUE3(a, b, c, a2, b2, c2, d2, 255); d++)
+					set_bit(d, (void *) dtree->bitmap);
+				set_bit(b, (void *) btree->dirty);
+			} ADDIP_RANGE_LOOP_END();
+		} ADDIP_RANGE_LOOP_END();
+	} ADDIP_RANGE_LOOP_END();
+
+	return 0;
+}
+
+static int
+addip(struct ip_set *set, const void *data, size_t size, ip_set_ip_t *hash_ip)
+{
+//	struct ip_set_iptreemap *map = (struct ip_set_iptreemap *) set->data;
+	struct ip_set_req_iptreemap *req = (struct ip_set_req_iptreemap *) data;
+
+	if (size != sizeof(struct ip_set_req_iptreemap)) {
+		ip_set_printk("data length wrong (want %zu, have %zu)", sizeof(struct ip_set_req_iptreemap), size);
+		return -EINVAL;
+	}
+
+	return __addip_range(set, MIN(req->start, req->end), MAX(req->start, req->end), hash_ip, GFP_KERNEL);
+}
+
+static int
+addip_kernel(struct ip_set *set, const struct sk_buff *skb, ip_set_ip_t *hash_ip, const u_int32_t *flags, unsigned char index)
+{
+//	struct ip_set_iptreemap *map = (struct ip_set_iptreemap *) set->data;
+
+	return __addip_single(set, ntohl(flags[index] & IPSET_SRC ? skb->nh.iph->saddr : skb->nh.iph->daddr), hash_ip, GFP_ATOMIC);
+}
+
+static inline int
+__delip_single(struct ip_set *set, ip_set_ip_t ip, ip_set_ip_t *hash_ip, unsigned int __nocast flags)
+{
+	struct ip_set_iptreemap *map = (struct ip_set_iptreemap *) set->data;
+	struct ip_set_iptreemap_b *btree;
+	struct ip_set_iptreemap_c *ctree;
+	struct ip_set_iptreemap_d *dtree;
+	unsigned char a,b,c,d;
+
+	*hash_ip = ip;
+
+	ABCD(a, b, c, d, hash_ip);
+
+	DELIP_WALK(map, a, btree, cachep_b, fullbitmap_b, flags);
+	DELIP_WALK(btree, b, ctree, cachep_c, fullbitmap_c, flags);
+	DELIP_WALK(ctree, c, dtree, cachep_d, fullbitmap_d, flags);
+
+	if (!test_and_clear_bit(d, (void *) dtree->bitmap))
+		return -EEXIST;
+
+	set_bit(b, (void *) btree->dirty);
+
+	return 0;
+}
+
+static inline int
+__delip_range(struct ip_set *set, ip_set_ip_t start, ip_set_ip_t end, ip_set_ip_t *hash_ip, unsigned int __nocast flags)
+{
+	struct ip_set_iptreemap *map = (struct ip_set_iptreemap *) set->data;
+	struct ip_set_iptreemap_b *btree;
+	struct ip_set_iptreemap_c *ctree;
+	struct ip_set_iptreemap_d *dtree;
+	unsigned int a, b, c, d;
+	unsigned char a1, b1, c1, d1;
+	unsigned char a2, b2, c2, d2;
+
+	if (start == end)
+		return __delip_single(set, start, hash_ip, flags);
+
+	*hash_ip = start;
+
+	ABCD(a1, b1, c1, d1, &start);
+	ABCD(a2, b2, c2, d2, &end);
+
+	/* This is sooo ugly... */
+	DELIP_RANGE_LOOP(map, a, a1, a2, CHECK1(a, a1, a2, b1, b2, c1, c2, d1, d2), btree, fullbitmap_b, cachep_b, free_b, flags) {
+		DELIP_RANGE_LOOP(btree, b, GETVALUE1(a, a1, b1, 0), GETVALUE1(a, a2, b2, 255), CHECK2(a, b, a1, a2, b1, b2, c1, c2, d1, d2), ctree, fullbitmap_c, cachep_c, free_c, flags) {
+			DELIP_RANGE_LOOP(ctree, c, GETVALUE2(a, b, a1, b1, c1, 0), GETVALUE2(a, b, a2, b2, c2, 255), CHECK3(a, b, c, a1, a2, b1, b2, c1, c2, d1, d2), dtree, fullbitmap_d, cachep_d, free_d, flags) {
+				for (d = GETVALUE3(a, b, c, a1, b1, c1, d1, 0); d <= GETVALUE3(a, b, c, a2, b2, c2, d2, 255); d++)
+					clear_bit(d, (void *) dtree->bitmap);
+				set_bit(b, (void *) btree->dirty);
+			} DELIP_RANGE_LOOP_END();
+		} DELIP_RANGE_LOOP_END();
+	} DELIP_RANGE_LOOP_END();
+
+	return 0;
+}
+
+static int
+delip(struct ip_set *set, const void *data, size_t size, ip_set_ip_t *hash_ip)
+{
+	struct ip_set_req_iptreemap *req = (struct ip_set_req_iptreemap *) data;
+
+	if (size != sizeof(struct ip_set_req_iptreemap)) {
+		ip_set_printk("data length wrong (want %zu, have %zu)", sizeof(struct ip_set_req_iptreemap), size);
+		return -EINVAL;
+	}
+
+	return __delip_range(set, MIN(req->start, req->end), MAX(req->start, req->end), hash_ip, GFP_KERNEL);
+}
+
+static int
+delip_kernel(struct ip_set *set, const struct sk_buff *skb, ip_set_ip_t *hash_ip, const u_int32_t *flags, unsigned char index)
+{
+	return __delip_single(set, ntohl(flags[index] & IPSET_SRC ? skb->nh.iph->saddr : skb->nh.iph->daddr), hash_ip, GFP_ATOMIC);
+}
+
+/* Check the status of the bitmap
+ * -1 == all bits cleared
+ *  1 == all bits set
+ *  0 == anything else
+ */
+static inline int
+bitmap_status(struct ip_set_iptreemap_d *dtree)
+{
+	unsigned char first = dtree->bitmap[0];
+	int a;
+
+	for (a = 1; a < 32; a++)
+		if (dtree->bitmap[a] != first)
+			return 0;
+
+	return (first == 0 ? -1 : (first == 255 ? 1 : 0));
+}
+
+static void
+gc(unsigned long addr)
+{
+	struct ip_set *set = (struct ip_set *) addr;
+	struct ip_set_iptreemap *map = (struct ip_set_iptreemap *) set->data;
+	struct ip_set_iptreemap_b *btree;
+	struct ip_set_iptreemap_c *ctree;
+	struct ip_set_iptreemap_d *dtree;
+	unsigned int a, b, c;
+	int i, j, k;
+
+	write_lock_bh(&set->lock);
+
+	LOOP_WALK_BEGIN_GC(map, a, btree, fullbitmap_b, cachep_b, i) {
+		LOOP_WALK_BEGIN_GC(btree, b, ctree, fullbitmap_c, cachep_c, j) {
+			if (!test_and_clear_bit(b, (void *) btree->dirty))
+				continue;
+			LOOP_WALK_BEGIN_GC(ctree, c, dtree, fullbitmap_d, cachep_d, k) {
+				switch (bitmap_status(dtree)) {
+					case -1:
+						kmem_cache_free(cachep_d, dtree);
+						ctree->tree[c] = NULL;
+						k--;
+					break;
+					case 1:
+						kmem_cache_free(cachep_d, dtree);
+						ctree->tree[c] = fullbitmap_d;
+						k++;
+					break;
+				}
+			} LOOP_WALK_END();
+		} LOOP_WALK_END_GC(btree, b, ctree, fullbitmap_c, cachep_c, k);
+	} LOOP_WALK_END_GC(map, a, btree, fullbitmap_b, cachep_b, j);
+
+	write_unlock_bh(&set->lock);
+
+	map->gc.expires = jiffies + map->gc_interval * HZ;
+	add_timer(&map->gc);
+}
+
+static inline void
+init_gc_timer(struct ip_set *set)
+{
+	struct ip_set_iptreemap *map = (struct ip_set_iptreemap *) set->data;
+
+	init_timer(&map->gc);
+	map->gc.data = (unsigned long) set;
+	map->gc.function = gc;
+	map->gc.expires = jiffies + map->gc_interval * HZ;
+	add_timer(&map->gc);
+}
+
+static int create(struct ip_set *set, const void *data, size_t size)
+{
+	struct ip_set_req_iptreemap_create *req = (struct ip_set_req_iptreemap_create *) data;
+	struct ip_set_iptreemap *map;
+
+	if (size != sizeof(struct ip_set_req_iptreemap_create)) {
+		ip_set_printk("data length wrong (want %zu, have %zu)", sizeof(struct ip_set_req_iptreemap_create), size);
+		return -EINVAL;
+	}
+
+	map = kzalloc(sizeof(*map), GFP_KERNEL);
+	if (!map)
+		return -ENOMEM;
+
+	map->gc_interval = req->gc_interval ? req->gc_interval : IPTREEMAP_DEFAULT_GC_TIME;
+	set->data = map;
+
+	init_gc_timer(set);
+
+	return 0;
+}
+
+static inline void __flush(struct ip_set_iptreemap *map)
+{
+	struct ip_set_iptreemap_b *btree;
+	unsigned int a;
+
+	LOOP_WALK_BEGIN(map, a, btree);
+		if (btree != fullbitmap_b)
+			free_b(btree);
+	LOOP_WALK_END();
+}
+
+static void destroy(struct ip_set *set)
+{
+	struct ip_set_iptreemap *map = (struct ip_set_iptreemap *) set->data;
+
+	while (!del_timer(&map->gc))
+		msleep(IPTREEMAP_DESTROY_SLEEP);
+
+	__flush(map);
+	kfree(map);
+
+	set->data = NULL;
+}
+
+static void flush(struct ip_set *set)
+{
+	struct ip_set_iptreemap *map = (struct ip_set_iptreemap *) set->data;
+
+	while (!del_timer(&map->gc))
+		msleep(IPTREEMAP_DESTROY_SLEEP);
+
+	__flush(map);
+
+	memset(map, 0, sizeof(*map));
+
+	init_gc_timer(set);
+}
+
+static void list_header(const struct ip_set *set, void *data)
+{
+	struct ip_set_iptreemap *map = (struct ip_set_iptreemap *) set->data;
+	struct ip_set_req_iptreemap_create *header = (struct ip_set_req_iptreemap_create *) data;
+
+	header->gc_interval = map->gc_interval;
+}
+
+static int list_members_size(const struct ip_set *set)
+{
+	struct ip_set_iptreemap *map = (struct ip_set_iptreemap *) set->data;
+	struct ip_set_iptreemap_b *btree;
+	struct ip_set_iptreemap_c *ctree;
+	struct ip_set_iptreemap_d *dtree;
+	unsigned int a, b, c, d, inrange = 0, count = 0;
+
+	LOOP_WALK_BEGIN_COUNT(map, a, btree, inrange, count) {
+		LOOP_WALK_BEGIN_COUNT(btree, b, ctree, inrange, count) {
+			LOOP_WALK_BEGIN_COUNT(ctree, c, dtree, inrange, count) {
+				for (d = 0; d < 256; d++) {
+					if (test_bit(d, (void *) dtree->bitmap)) {
+						inrange = 1;
+					} else if (inrange) {
+						count++;
+						inrange = 0;
+					}
+				}
+			} LOOP_WALK_END_COUNT();
+		} LOOP_WALK_END_COUNT();
+	} LOOP_WALK_END_COUNT();
+
+	if (inrange)
+		count++;
+
+	return (count * sizeof(struct ip_set_req_iptreemap));
+}
+
+static inline size_t add_member(void *data, size_t offset, ip_set_ip_t start, ip_set_ip_t end)
+{
+	struct ip_set_req_iptreemap *entry = (struct ip_set_req_iptreemap *) (data + offset);
+
+	entry->start = start;
+	entry->end = end;
+
+	return sizeof(*entry);
+}
+
+static void list_members(const struct ip_set *set, void *data)
+{
+	struct ip_set_iptreemap *map = (struct ip_set_iptreemap *) set->data;
+	struct ip_set_iptreemap_b *btree;
+	struct ip_set_iptreemap_c *ctree;
+	struct ip_set_iptreemap_d *dtree;
+	unsigned int a, b, c, d, inrange = 0;
+	size_t offset = 0;
+	ip_set_ip_t start = 0, end = 0, ip;
+
+	LOOP_WALK_BEGIN(map, a, btree) {
+		LOOP_WALK_BEGIN(btree, b, ctree) {
+			LOOP_WALK_BEGIN(ctree, c, dtree) {
+				for (d = 0; d < 256; d++) {
+					if (test_bit(d, (void *) dtree->bitmap)) {
+						ip = ((a << 24) | (b << 16) | (c << 8) | d);
+						if (!inrange) {
+							inrange = 1;
+							start = ip;
+						} else if (end < ip - 1) {
+							offset += add_member(data, offset, start, end);
+							start = ip;
+						}
+						end = ip;
+					} else if (inrange) {
+						offset += add_member(data, offset, start, end);
+						inrange = 0;
+					}
+				}
+			} LOOP_WALK_END();
+		} LOOP_WALK_END();
+	} LOOP_WALK_END();
+
+	if (inrange)
+		add_member(data, offset, start, end);
+}
+
+static struct ip_set_type ip_set_iptreemap = {
+	.typename		= SETTYPE_NAME,
+	.features		= IPSET_TYPE_IP | IPSET_DATA_SINGLE,
+	.protocol_version	= IP_SET_PROTOCOL_VERSION,
+	.create			= create,
+	.destroy		= destroy,
+	.flush			= flush,
+	.reqsize		= sizeof(struct ip_set_req_iptreemap),
+	.addip			= addip,
+	.addip_kernel		= addip_kernel,
+	.delip			= delip,
+	.delip_kernel		= delip_kernel,
+	.testip			= testip,
+	.testip_kernel		= testip_kernel,
+	.header_size		= sizeof(struct ip_set_req_iptreemap_create),
+	.list_header		= list_header,
+	.list_members_size	= list_members_size,
+	.list_members		= list_members,
+	.me			= THIS_MODULE,
+};
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Sven Wegener <sven.wegener@stealer.net>");
+MODULE_DESCRIPTION("iptreemap type of IP sets");
+
+static int __init init(void)
+{
+	int ret = -ENOMEM;
+	int a;
+
+	cachep_b = kmem_cache_create("ip_set_iptreemap_b", sizeof(struct ip_set_iptreemap_b), 0, 0, NULL, NULL);
+	if (!cachep_b) {
+		ip_set_printk("Unable to create ip_set_iptreemap_b slab cache");
+		goto out;
+	}
+
+	cachep_c = kmem_cache_create("ip_set_iptreemap_c", sizeof(struct ip_set_iptreemap_c), 0, 0, NULL, NULL);
+	if (!cachep_c) {
+		ip_set_printk("Unable to create ip_set_iptreemap_c slab cache");
+		goto outb;
+	}
+
+	cachep_d = kmem_cache_create("ip_set_iptreemap_d", sizeof(struct ip_set_iptreemap_d), 0, 0, NULL, NULL);
+	if (!cachep_d) {
+		ip_set_printk("Unable to create ip_set_iptreemap_d slab cache");
+		goto outc;
+	}
+
+	fullbitmap_d = kmem_cache_alloc(cachep_d, GFP_KERNEL);
+	if (!fullbitmap_d)
+		goto outd;
+
+	fullbitmap_c = kmem_cache_alloc(cachep_c, GFP_KERNEL);
+	if (!fullbitmap_c)
+		goto outbitmapd;
+
+	fullbitmap_b = kmem_cache_alloc(cachep_b, GFP_KERNEL);
+	if (!fullbitmap_b)
+		goto outbitmapc;
+
+	ret = ip_set_register_set_type(&ip_set_iptreemap);
+	if (0 > ret)
+		goto outbitmapb;
+
+	/* Now init our global bitmaps */
+	memset(fullbitmap_d->bitmap, 0xff, sizeof(fullbitmap_d->bitmap));
+
+	for (a = 0; a < 256; a++)
+		fullbitmap_c->tree[a] = fullbitmap_d;
+
+	for (a = 0; a < 256; a++)
+		fullbitmap_b->tree[a] = fullbitmap_c;
+	memset(fullbitmap_b->dirty, 0, sizeof(fullbitmap_b->dirty));
+
+	return 0;
+
+outbitmapb:
+	kmem_cache_free(cachep_b, fullbitmap_b);
+outbitmapc:
+	kmem_cache_free(cachep_c, fullbitmap_c);
+outbitmapd:
+	kmem_cache_free(cachep_d, fullbitmap_d);
+outd:
+	kmem_cache_destroy(cachep_d);
+outc:
+	kmem_cache_destroy(cachep_c);
+outb:
+	kmem_cache_destroy(cachep_b);
+out:
+
+	return ret;
+}
+
+static void __exit fini(void)
+{
+	ip_set_unregister_set_type(&ip_set_iptreemap);
+	kmem_cache_free(cachep_d, fullbitmap_d);
+	kmem_cache_free(cachep_c, fullbitmap_c);
+	kmem_cache_free(cachep_b, fullbitmap_b);
+	kmem_cache_destroy(cachep_d);
+	kmem_cache_destroy(cachep_c);
+	kmem_cache_destroy(cachep_b);
+}
+
+module_init(init);
+module_exit(fini);
