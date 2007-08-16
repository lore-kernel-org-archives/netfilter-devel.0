From: Sven Wegener <Sven.Wegener@STEALER.net>
Subject: [RFC] [PATCH] ipset: New set type fullipmap, kernel part
Date: Thu, 16 Aug 2007 09:22:14 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0708160919260.13455@titan.stealer.net>
References: <Pine.LNX.4.64.0708160857080.13455@titan.stealer.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: netfilter-devel@lists.netfilter.org
To: kadlec@blackhole.kfki.hu
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.64.0708160857080.13455@titan.stealer.net>
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

--- /dev/null
+++ b/include/linux/netfilter_ipv4/ip_set_fullipmap.h
@@ -0,0 +1,24 @@
+#ifndef __IP_SET_FULLIPMAP_H
+#define __IP_SET_FULLIPMAP_H
+
+#include <linux/netfilter_ipv4/ip_set.h>
+
+#define SETTYPE_NAME "fullipmap"
+
+struct ip_set_fullipmap {
+#ifdef __KERNEL__
+	void **members;
+	void *dirty;
+	struct timer_list gc;
+#endif /* __KERNEL __ */
+};
+
+struct ip_set_req_fullipmap_create {
+};
+
+struct ip_set_req_fullipmap {
+	ip_set_ip_t start;
+	ip_set_ip_t end;
+};
+
+#endif /* __IP_SET_FULLIPMAP_H */
--- /dev/null
+++ b/net/ipv4/netfilter/ip_set_fullipmap.c
@@ -0,0 +1,538 @@
+/* Copyright (C) 2007 Sven Wegener <sven.wegener@stealer.net>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published by
+ * the Free Software Foundation.
+ */
+
+/* This code implements the fullipmap ipset type. It uses bitmaps to represent
+ * every single IPv4 IP address as a bit. Matching speed is very fast and has
+ * O(1) performance. It uses two global bitmaps for the none bit set and all
+ * bits set case, that are reused whenever appropriate. There is a per-set
+ * garbage collector running, that checks whether a bitmap can be replaced by
+ * one of the two above mentioned bitmaps. A bitmap that gets one or more bits
+ * changed is marked as dirty, so the garbage collector checks it on the next
+ * run. Worst case memory usage is 512 MiB for all bitmaps plus the memory
+ * needed for the index table and the dirty bitmap. This ipset type can be used
+ * to represent single IPv4 addresses, as well as ranges and networks, with
+ * high speed matching, adding and deleting operations. Downside of the bitmap
+ * approach is that we need to pass all bitmaps to userspace on list or save.
+ */
+
+#include <linux/module.h>
+#include <linux/ip.h>
+#include <linux/skbuff.h>
+#include <linux/netfilter_ipv4/ip_tables.h>
+#include <linux/netfilter_ipv4/ip_set.h>
+#include <linux/errno.h>
+#include <linux/vmalloc.h>
+#include <linux/delay.h>
+#include <linux/spinlock.h>
+#include <asm/bitops.h>
+
+#include <linux/netfilter_ipv4/ip_set_fullipmap.h>
+
+#define FULLIPMAP_BITS (11)
+#define FULLIPMAP_SIZE (1 << FULLIPMAP_BITS)
+#define FULLIPMAP_MASK (FULLIPMAP_SIZE - 1)
+#define FULLIPMAP_BYTES (FULLIPMAP_SIZE / 8)
+#define FULLIPMAP_INDEX_SIZE (1 << (32 - FULLIPMAP_BITS))
+#define FULLIPMAP_DIRTY_BYTES (FULLIPMAP_INDEX_SIZE / 8)
+
+#define FULLIPMAP_GC_TIME (5 * 60 * HZ)
+#define FULLIPMAP_DESTROY_SLEEP (100)
+
+#define MIN(a, b) (a < b ? a : b)
+#define MAX(a, b) (a > b ? a : b)
+
+static void *fullbitmap, *emptybitmap;
+
+static inline void
+set_bit_range(int start, int end, void *addr)
+{
+	int bit;
+
+	for (bit = start; bit <= end; bit++)
+		set_bit(bit, addr);
+}
+
+static inline void
+clear_bit_range(int start, int end, void *addr)
+{
+	int bit;
+
+	for (bit = start; bit <= end; bit++)
+		clear_bit(bit, addr);
+}
+
+static inline int
+is_bitmap_covered(unsigned int index, unsigned int index_start, unsigned int bit_start, unsigned int index_end, unsigned int bit_end)
+{
+	return (
+		(
+			/* Index is between start and end */
+			index < index_end
+			&& index > index_start
+		) || (
+			/* Index is at the beginning */
+			index == index_start
+			&& bit_start == 0
+			&& index_end > index_start
+		) || (
+			/* Index is at the end */
+			index == index_end
+			&& bit_end == FULLIPMAP_SIZE - 1
+			&& index_end > index_start
+		) || (
+			/* Whole index */
+			index_start == index_end
+			&& bit_start == 0
+			&& bit_end == FULLIPMAP_SIZE - 1
+		)
+	);
+}
+
+static inline int
+__testip(struct ip_set *set, ip_set_ip_t ip, ip_set_ip_t *hash_ip)
+{
+	struct ip_set_fullipmap *map = (struct ip_set_fullipmap *) set->data;
+	unsigned int index = ip >> FULLIPMAP_BITS;
+
+	*hash_ip = ip;
+
+	/* Shortcut if we know the state of all bits */
+	if (map->members[index] == emptybitmap) {
+		return 0;
+	} else if (map->members[index] == fullbitmap) {
+		return 1;
+	}
+
+	return !!test_bit(ip & FULLIPMAP_MASK, map->members[index]);
+}
+
+static int
+testip(struct ip_set *set, const void *data, size_t size, ip_set_ip_t *hash_ip)
+{
+	struct ip_set_req_fullipmap *req = (struct ip_set_req_fullipmap *) data;
+
+	if (size != sizeof(struct ip_set_req_fullipmap)) {
+		ip_set_printk("data length wrong (want %zu, have %zu)", sizeof(struct ip_set_req_fullipmap), size);
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
+__addip_single(struct ip_set *set, ip_set_ip_t ip, ip_set_ip_t *hash_ip)
+{
+	struct ip_set_fullipmap *map = (struct ip_set_fullipmap *) set->data;
+	unsigned int index = ip >> FULLIPMAP_BITS;
+
+	*hash_ip = ip;
+
+	if (map->members[index] == fullbitmap) {
+		return -EEXIST;
+	} else if (map->members[index] == emptybitmap) {
+		if (!(map->members[index] = kzalloc(FULLIPMAP_BYTES, GFP_ATOMIC))) {
+			map->members[index] = emptybitmap;
+			return -ENOMEM;
+		}
+
+		set_bit(ip & FULLIPMAP_MASK, map->members[index]);
+
+		return 0;
+	} else if (test_and_set_bit(ip & FULLIPMAP_MASK, map->members[index])) {
+		return -EEXIST;
+	}
+
+	set_bit(index, map->dirty);
+
+	return 0;
+}
+
+static inline int
+__addip_range(struct ip_set *set, ip_set_ip_t start, ip_set_ip_t end, ip_set_ip_t *hash_ip)
+{
+	struct ip_set_fullipmap *map = (struct ip_set_fullipmap *) set->data;
+	unsigned int index_start, index_end, index;
+	unsigned int bit_start, bit_end;
+
+	if (start == end)
+		return __addip_single(set, start, hash_ip);
+
+	*hash_ip = start;
+
+	index_start = start >> FULLIPMAP_BITS;
+	bit_start = start & FULLIPMAP_MASK;
+	index_end = end >> FULLIPMAP_BITS;
+	bit_end = end & FULLIPMAP_MASK;
+
+	for (index = index_start; index <= index_end; index++) {
+		if (map->members[index] == fullbitmap) {
+			continue;
+		} else if (is_bitmap_covered(index, index_start, bit_start, index_end, bit_end)) {
+			if (map->members[index] != emptybitmap)
+				kfree(map->members[index]);
+
+			map->members[index] = fullbitmap;
+			clear_bit(index, map->dirty);
+
+			continue;
+		} else if (map->members[index] == emptybitmap) {
+			if (!(map->members[index] = kzalloc(FULLIPMAP_BYTES, GFP_ATOMIC))) {
+				map->members[index] = emptybitmap;
+				return -ENOMEM;
+			}
+		}
+
+		if (index == index_start && index == index_end) {
+			set_bit_range(bit_start, bit_end, map->members[index]);
+		} else if (index == index_start && index_start < index_end) {
+			set_bit_range(bit_start, FULLIPMAP_SIZE - 1, map->members[index]);
+		} else if (index == index_end && index_end > index_start) {
+			set_bit_range(0, bit_end, map->members[index]);
+		}
+
+		set_bit(index, map->dirty);
+	}
+
+	return 0;
+}
+
+static int
+addip(struct ip_set *set, const void *data, size_t size, ip_set_ip_t *hash_ip)
+{
+	struct ip_set_req_fullipmap *req = (struct ip_set_req_fullipmap *) data;
+
+	if (size != sizeof(struct ip_set_req_fullipmap)) {
+		ip_set_printk("data length wrong (want %zu, have %zu)", sizeof(struct ip_set_req_fullipmap), size);
+		return -EINVAL;
+	}
+
+	return __addip_range(set, MIN(req->start, req->end), MAX(req->start, req->end), hash_ip);
+}
+
+static int
+addip_kernel(struct ip_set *set, const struct sk_buff *skb, ip_set_ip_t *hash_ip, const u_int32_t *flags, unsigned char index)
+{
+	return __addip_single(set, ntohl(flags[index] & IPSET_SRC ? skb->nh.iph->saddr : skb->nh.iph->daddr), hash_ip);
+}
+
+static inline int
+__delip_single(struct ip_set *set, ip_set_ip_t ip, ip_set_ip_t *hash_ip)
+{
+	struct ip_set_fullipmap *map = (struct ip_set_fullipmap *) set->data;
+	unsigned int index = ip >> FULLIPMAP_BITS;
+
+	*hash_ip = ip;
+
+	if (map->members[index] == emptybitmap) {
+		return -EEXIST;
+	} else if (map->members[index] == fullbitmap) {
+		if (!(map->members[index] = kmalloc(FULLIPMAP_BYTES, GFP_ATOMIC))) {
+			map->members[index] = fullbitmap;
+			return -ENOMEM;
+		}
+
+		memset(map->members[index], 0xff, FULLIPMAP_BYTES);
+		clear_bit(ip & FULLIPMAP_MASK, map->members[index]);
+
+		return 0;
+	} else if (!test_and_clear_bit(ip & FULLIPMAP_MASK, map->members[index])) {
+		return -EEXIST;
+	}
+
+	set_bit(index, map->dirty);
+
+	return 0;
+}
+
+static inline int
+__delip_range(struct ip_set *set, ip_set_ip_t start, ip_set_ip_t end, ip_set_ip_t *hash_ip)
+{
+	struct ip_set_fullipmap *map = (struct ip_set_fullipmap *) set->data;
+	unsigned int index_start, index_end, index;
+	unsigned int bit_start, bit_end;
+
+	if (start == end)
+		return __delip_single(set, start, hash_ip);
+
+	*hash_ip = start;
+
+	index_start = start >> FULLIPMAP_BITS;
+	bit_start = start & FULLIPMAP_MASK;
+	index_end = end >> FULLIPMAP_BITS;
+	bit_end = end & FULLIPMAP_MASK;
+
+	for (index = index_start; index <= index_end; index++) {
+		if (map->members[index] == emptybitmap) {
+			continue;
+		} else if (is_bitmap_covered(index, index_start, bit_start, index_end, bit_end)) {
+			if (map->members[index] != fullbitmap && map->members[index] != emptybitmap)
+				kfree(map->members[index]);
+
+			map->members[index] = emptybitmap;
+			clear_bit(index, map->dirty);
+
+			continue;
+		} else if (map->members[index] == fullbitmap) {
+			if (!(map->members[index] = kmalloc(FULLIPMAP_BYTES, GFP_ATOMIC))) {
+				map->members[index] = fullbitmap;
+				return -ENOMEM;
+			}
+
+			memset(map->members[index], 0xff, FULLIPMAP_BYTES);
+		}
+
+		if (index == index_start && index == index_end) {
+			clear_bit_range(bit_start, bit_end, map->members[index]);
+		} else if (index == index_start && index_start < index_end) {
+			clear_bit_range(bit_start, FULLIPMAP_SIZE - 1, map->members[index]);
+		} else if (index == index_end && index_end > index_start) {
+			clear_bit_range(0, bit_end, map->members[index]);
+		}
+
+		set_bit(index, map->dirty);
+	}
+
+	return 0;
+}
+
+static int
+delip(struct ip_set *set, const void *data, size_t size, ip_set_ip_t *hash_ip)
+{
+	struct ip_set_req_fullipmap *req = (struct ip_set_req_fullipmap *) data;
+
+	if (size != sizeof(struct ip_set_req_fullipmap)) {
+		ip_set_printk("data length wrong (want %zu, have %zu)", sizeof(struct ip_set_req_fullipmap), size);
+		return -EINVAL;
+	}
+
+	return __delip_range(set, MIN(req->start, req->end), MAX(req->start, req->end), hash_ip);
+}
+
+static int
+delip_kernel(struct ip_set *set, const struct sk_buff *skb, ip_set_ip_t *hash_ip, const u_int32_t *flags, unsigned char index)
+{
+	return __delip_single(set, ntohl(flags[index] & IPSET_SRC ? skb->nh.iph->saddr : skb->nh.iph->daddr), hash_ip);
+}
+
+static void
+gc(unsigned long addr)
+{
+	struct ip_set *set = (struct ip_set *) addr;
+	struct ip_set_fullipmap *map = (struct ip_set_fullipmap *) set->data;
+	int i;
+
+	for (i = 0; i < FULLIPMAP_INDEX_SIZE; i++) {
+		write_lock_bh(&set->lock);
+		if (
+			test_and_clear_bit(i, map->dirty)
+			&& map->members[i] != fullbitmap
+			&& map->members[i] != emptybitmap
+		) {
+			if (!memcmp(map->members[i], emptybitmap, FULLIPMAP_BYTES)) {
+				kfree(map->members[i]);
+				map->members[i] = emptybitmap;
+			} else if (!memcmp(map->members[i], fullbitmap, FULLIPMAP_BYTES)) {
+				kfree(map->members[i]);
+				map->members[i] = fullbitmap;
+			}
+		}
+		write_unlock_bh(&set->lock);
+	}
+
+	map->gc.expires = jiffies + FULLIPMAP_GC_TIME;
+	add_timer(&map->gc);
+}
+
+static inline void
+init_gc_timer(struct ip_set *set)
+{
+	struct ip_set_fullipmap *map = (struct ip_set_fullipmap *) set->data;
+
+	init_timer(&map->gc);
+	map->gc.data = (unsigned long) set;
+	map->gc.function = gc;
+	map->gc.expires = jiffies + FULLIPMAP_GC_TIME;
+	add_timer(&map->gc);
+}
+
+static int
+create(struct ip_set *set, const void *data, size_t size)
+{
+//	struct ip_set_req_fullipmap_create *req = (struct ip_set_req_fullipmap_create *) data;
+	struct ip_set_fullipmap *map;
+	int i;
+
+	if (size != sizeof(struct ip_set_req_fullipmap_create)) {
+		ip_set_printk("data length wrong (want %zu, have %zu)", sizeof(struct ip_set_req_fullipmap_create), size);
+		return -EINVAL;
+	}
+
+	if (!(map = kzalloc(sizeof(*map), GFP_KERNEL)))
+		goto out;
+
+	if (!(map->members = vmalloc(FULLIPMAP_INDEX_SIZE * sizeof(void *))))
+		goto outmap;
+
+	if (!(map->dirty = vmalloc(FULLIPMAP_DIRTY_BYTES)))
+		goto outmembers;
+
+	for (i = 0; i < FULLIPMAP_INDEX_SIZE; i++)
+		map->members[i] = emptybitmap;
+
+	memset(map->dirty, 0, FULLIPMAP_DIRTY_BYTES);
+
+	set->data = map;
+
+	init_gc_timer(set);
+
+	return 0;
+
+outmembers:
+	vfree(map->members);
+outmap:
+	kfree(map);
+out:
+	return -ENOMEM;
+}
+
+static void
+flush(struct ip_set *set)
+{
+	struct ip_set_fullipmap *map = (struct ip_set_fullipmap *) set->data;
+	int i;
+
+	while (!del_timer(&map->gc))
+		msleep(FULLIPMAP_DESTROY_SLEEP);
+
+	for (i = 0; i < FULLIPMAP_INDEX_SIZE; i++) {
+		if (map->members[i] != fullbitmap && map->members[i] != emptybitmap)
+			kfree(map->members[i]);
+		map->members[i] = emptybitmap;
+	}
+
+	memset(map->dirty, 0, FULLIPMAP_DIRTY_BYTES);
+
+	init_gc_timer(set);
+}
+
+static void
+destroy(struct ip_set *set)
+{
+	struct ip_set_fullipmap *map = (struct ip_set_fullipmap *) set->data;
+	int i;
+
+	while (!del_timer(&map->gc))
+		msleep(FULLIPMAP_DESTROY_SLEEP);
+
+	for (i = 0; i < FULLIPMAP_INDEX_SIZE; i++)
+		if (map->members[i] != fullbitmap && map->members[i] != emptybitmap)
+			kfree(map->members[i]);
+
+	vfree(map->dirty);
+	vfree(map->members);
+	kfree(map);
+
+	set->data = NULL;
+}
+
+static void
+list_header(const struct ip_set *set, void *data)
+{
+//	struct ip_set_fullipmap *map = (struct ip_set_fullipmap *) set->data;
+//	struct ip_set_req_fullipmap_create *header = (struct ip_set_req_fullipmap_create *) data;
+}
+
+static int
+list_members_size(const struct ip_set *set)
+{
+//	struct ip_set_fullipmap *map = (struct ip_set_fullipmap *) set->data;
+
+	return 0xffffffff / 8 + 1;
+}
+
+static void
+list_members(const struct ip_set *set, void *data)
+{
+	struct ip_set_fullipmap *map = (struct ip_set_fullipmap *) set->data;
+	int i;
+
+	for (i = 0; i < FULLIPMAP_INDEX_SIZE; i++)
+		memcpy(data + FULLIPMAP_BYTES * i, map->members[i], FULLIPMAP_BYTES);
+}
+
+static struct ip_set_type ip_set_fullipmap = {
+	.typename = SETTYPE_NAME,
+	.features = IPSET_TYPE_IP | IPSET_DATA_SINGLE,
+	.protocol_version = IP_SET_PROTOCOL_VERSION,
+	.create = &create,
+	.destroy = &destroy,
+	.flush = &flush,
+	.reqsize = sizeof(struct ip_set_req_fullipmap),
+	.addip = &addip,
+	.addip_kernel = &addip_kernel,
+	.delip = &delip,
+	.delip_kernel = &delip_kernel,
+	.testip = &testip,
+	.testip_kernel = &testip_kernel,
+	.header_size = sizeof(struct ip_set_req_fullipmap_create),
+	.list_header = &list_header,
+	.list_members_size = &list_members_size,
+	.list_members = &list_members,
+	.me = THIS_MODULE,
+};
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Sven Wegener <sven.wegener@webde.de>");
+MODULE_DESCRIPTION("fullipmap type of IP sets");
+
+static int __init
+init(void)
+{
+	int ret = -ENOMEM;
+
+	if (!(fullbitmap = kmalloc(FULLIPMAP_BYTES, GFP_KERNEL)))
+		goto out;
+
+	if (!(emptybitmap = kzalloc(FULLIPMAP_BYTES, GFP_KERNEL)))
+		goto outfull;
+
+	if (0 > (ret = ip_set_register_set_type(&ip_set_fullipmap)))
+		goto outempty;
+
+	memset(fullbitmap, 0xff, FULLIPMAP_BYTES);
+
+	return ret;
+
+outempty:
+	kfree(emptybitmap);
+outfull:
+	kfree(fullbitmap);
+out:
+
+	return ret;
+}
+
+static void __exit
+fini(void)
+{
+	ip_set_unregister_set_type(&ip_set_fullipmap);
+	kfree(emptybitmap);
+	kfree(fullbitmap);
+}
+
+module_init(init);
+module_exit(fini);
