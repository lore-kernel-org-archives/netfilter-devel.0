From: Tim Gardner <timg@tpi.com>
Subject: [PATCH] 1 of 3 for patch-o-matic-ng
Date: Wed, 17 Mar 2004 15:30:23 -0700
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200403171530.23435.timg@tpi.com>
Reply-To: timg@tpi.com
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="------------Boundary-00=_NURQCG21ZZ74MFRCWNB7"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: laforge@netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--------------Boundary-00=_NURQCG21ZZ74MFRCWNB7
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

This is the first of 3 patches for patch-o-matic-ng that I would like to=20
submit. It contains a general purpose hash table that is used by the matc=
h=20
filters in the next 2 patches.

I have tested these filters from the tip of the patch-o-matic-ng CVS tree=
 as=20
of this morning. I have noticed that there appear to be 2 deficiencies:

1) Dependencies in the info file appear to be ignored.
2) The iptables/extension test file, e.g., .foo-test, does not get copied=
 when=20
updating the iptables extension library.

Both of these match filters have been in use for about 6 weeks on over a=20
thousand units. PSDP on my primary firewall catches sometimes several=20
thousand attacks from unique IP source addresses in a 24 hour period.
--=20
Tim Gardner - timg@tpi.com
www.tpi.com 406-443-5357
--------------Boundary-00=_NURQCG21ZZ74MFRCWNB7
Content-Type: text/x-diff;
  charset="us-ascii";
  name="hash.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="hash.diff"

diff -r -u --new-file patch-o-matic-ng/hash/help patch-o-matic-ng.psdp.fuzzyp/hash/help
--- patch-o-matic-ng/hash/help	1969-12-31 17:00:00.000000000 -0700
+++ patch-o-matic-ng.psdp.fuzzyp/hash/help	2004-03-17 12:04:50.000000000 -0700
@@ -0,0 +1,2 @@
+This module adds general purpose hash table functionality. In particular, the
+filters psdp and fuzzyp depend on this module.
diff -r -u --new-file patch-o-matic-ng/hash/info patch-o-matic-ng.psdp.fuzzyp/hash/info
--- patch-o-matic-ng/hash/info	1969-12-31 17:00:00.000000000 -0700
+++ patch-o-matic-ng.psdp.fuzzyp/hash/info	2004-03-17 12:04:14.000000000 -0700
@@ -0,0 +1,4 @@
+Title: General pupose hash table API.
+Author: Tim Gardner <timg@tpi.com>
+Status: Stable
+Repository: extra
diff -r -u --new-file patch-o-matic-ng/hash/linux/net/ipv4/netfilter/Config.in.ladd patch-o-matic-ng.psdp.fuzzyp/hash/linux/net/ipv4/netfilter/Config.in.ladd
--- patch-o-matic-ng/hash/linux/net/ipv4/netfilter/Config.in.ladd	1969-12-31 17:00:00.000000000 -0700
+++ patch-o-matic-ng.psdp.fuzzyp/hash/linux/net/ipv4/netfilter/Config.in.ladd	2004-01-01 20:23:12.000000000 -0700
@@ -0,0 +1,2 @@
+# The simple matches.
+dep_tristate '  Hash table support for some filters.' CONFIG_IP_NF_HASH $CONFIG_IP_NF_IPTABLES
diff -r -u --new-file patch-o-matic-ng/hash/linux/net/ipv4/netfilter/ipt_hash.c patch-o-matic-ng.psdp.fuzzyp/hash/linux/net/ipv4/netfilter/ipt_hash.c
--- patch-o-matic-ng/hash/linux/net/ipv4/netfilter/ipt_hash.c	1969-12-31 17:00:00.000000000 -0700
+++ patch-o-matic-ng.psdp.fuzzyp/hash/linux/net/ipv4/netfilter/ipt_hash.c	2004-01-01 19:02:35.000000000 -0700
@@ -0,0 +1,433 @@
+/*
+
+  This file implements a general purpose hash table.
+
+  Copyright (C) 2003 Tim Gardner <timg@tpi.com>, TriplePoint, Inc.
+
+  This file is distributed under the terms of the GNU General Public
+  License (GPL). Copies of the GPL can be obtained from: http://www.gnu.org
+
+ Theory of use is as follows:
+
+ ipt_hash_create_table - A hash table is created by calling ipt_hash_create_table(). Parameters
+ are hash table size, hash key length, user supplied hash key function, and the size of
+ the element structure. The hash table size is rounded up to the nearest power of 2. Note that
+ at the minimum, a hash table consumes (hash length)*sizeof(struct list_head) bytes.
+
+ Hash table protection must be provided by the hash table user, e.g., spin locking or
+ whatever exclusion method is appropriate.
+
+ ipt_hash_create_entry - A hash table element is a block of memory of N bytes that is
+ keyed using a user supplied hash key function. The hash key is stored seperately from
+ the user structure, but within the hash element. For example, if you wanted to hash
+ to your elements using an IP address as a key, then your hash key function might look like:
+
+	__u32 hash_func(void *key)
+	{
+		return(ntohl(*(__u32 *)key));
+	}
+
+ The value returned by your hash key function is used as an index into the hash table after it
+ is masked to the length of the hash table. Therefore, it is necessary to develop your hash key
+ function with the type and range of key data in mind. The computed index is used to reference
+ a list of hash elements. The list is then searched linearly for an exact match on the hash key.
+ It is important to develop the hash key function such that there are few hash key collisions.
+
+ The pointer returned by ipt_hash_create_entry() is a paragraph aligned block of memory of N
+ bytes where N was specified during ipt_hash_create_table().
+
+ ipt_hash_find_entry - In order to retrieve a single hash element, then you must know the key.
+ This function returns a pointer to the user sized element if the hash key exists, NULL otherwise.
+
+ ipt_hash_delete_entry - This function frees the resources consumed by this element. Prior to
+ this, the user must delete all dynamically allocated resources that are reference by this
+ element.
+
+ ipt_hash_traverse - You can search the hash table linearly. This function requires an initialized
+ structure that keeps track of search state across calls. For example:
+
+	struct user_def			*s;
+	struct ipt_hash_location   	loc;
+	ipt_hash_traverse_init(&loc);
+	while ((s=(struct user_def *)ipt_hash_traverse(hash_tab,&loc)) != NULL)
+	{
+		do your thing here.
+	}
+
+ Items found by this linear seach can be removed by calling ipt_hash_delete_entry() without adverse
+ effect. The search can also be restarted by reinitilizing the hash location struction, e.g.,
+ ipt_hash_traverse_init(&loc).
+
+ ipt_hash_delete_table - The hash table and all associated resources can be deleted by calling
+ this function. However, it is incumbent upon the user to first search the hash table linearly and
+ free any dynamically allocated resources.
+
+*/
+
+#include "ipt_hash.h"
+#include <linux/version.h>
+
+#define PARA(_l) (((_l)+15) & (~15))
+
+#define HASH_SANITY_CHECK 0
+
+#if HASH_SANITY_CHECK
+STATIC __u32 csum(unsigned char *s, __u32 len)
+{
+	__u32 sum=0;
+	while (len)
+	{
+		sum += (((__u32)*s) << ((len & 3)*8));
+		s++;
+		len--;
+	}
+	return(sum);
+}
+
+STATIC int hash_sanity_check(
+	struct ipt_hash_table	*hash_table
+	)
+{
+	__u32 i;
+
+	if (hash_table->csum !=
+		csum((unsigned char *)(hash_table),
+			sizeof(struct ipt_hash_table)-sizeof(__u32)))
+	{
+		IPT_DBG_ASSERT(0);
+		return(-1);
+	}
+
+	for (i=0; i<hash_table->hash_tab_size; i++)
+	{
+		struct list_head	*l;
+		struct list_head	*t;
+		struct list_head	*h;
+
+		h = &hash_table->hash_tab[i];
+
+		list_for_each_safe(l,t,h)
+		{
+			struct ipt_hash_entry *entry;
+
+			entry = list_entry(l,struct ipt_hash_entry,next);
+			if (entry->magic != IPT_HASH_MAGIC)
+			{
+				DBG_PRINT("index %u entry %08x magic %08x\n",
+					i,(__u32)entry,entry->magic);
+				return(-1);
+			}
+		}
+	}
+
+	return(0);
+}
+
+#define ASSERT_HASH_TABLE_MAGIC(_t) IPT_DBG_ASSERT(hash_sanity_check((_t)) >= 0)
+#else
+#define ASSERT_HASH_TABLE_MAGIC(_t) IPT_DBG_ASSERT((_t)->csum == HASH_TABLE_MAGIC)
+#endif
+
+struct ipt_hash_table *ipt_hash_create_table(
+	__u32			hash_tab_size,
+	IPT_HASH_FUNC	hash_func,
+	__u32			private_data_len,
+	__u32			hash_key_len
+	)
+{
+	struct ipt_hash_table	*hash_table;
+	__u32					i;
+	__u32					len;
+	__u32					_hash_tab_size;
+
+	IPT_DBG_ASSERT(hash_func);
+	IPT_DBG_ASSERT(hash_tab_size);
+	IPT_DBG_ASSERT(hash_key_len);
+	IPT_DBG_ASSERT(private_data_len);
+
+	/*
+	 * Find that magic boundary.
+	 */
+	_hash_tab_size = 1;
+	while (_hash_tab_size < hash_tab_size)
+	{
+		_hash_tab_size <<= 1;
+	}
+
+	/*
+	 * Make sure the hash_tab array starts on a paragraph boundary.
+	 */
+	len = PARA(sizeof(struct ipt_hash_table));
+
+	i = len + (_hash_tab_size * sizeof(struct list_head));
+
+	if (!(hash_table=(struct ipt_hash_table *)kmalloc(i,GFP_ATOMIC)))
+	{
+		printk(KERN_ERR "%s Could not allocate %u bytes for hash table.\n",__FUNCTION__,i);
+		return(NULL);
+	}
+	memset(hash_table,0,i);
+
+	hash_table->hash_tab			= (struct list_head *)(((__u32)hash_table)+len);
+	hash_table->hash_tab_size		= _hash_tab_size;
+	hash_table->hash_tab_size_mask	= (_hash_tab_size-1);
+	hash_table->hash_func			= hash_func;
+	hash_table->hash_key_len		= hash_key_len;
+	hash_table->private_data_len	= private_data_len;
+	hash_table->num_entries		 = 0;
+
+	/*
+	 * The hash entry structure is followed by the hash key and hash consumer's private
+	 * data structure. Both are on a paragraph boundary to avoid alignment issues.
+	 */
+	hash_table->total_hash_entry_len = PARA(sizeof(struct ipt_hash_entry));
+	hash_table->total_hash_entry_len += PARA(hash_table->hash_key_len);
+	hash_table->total_hash_entry_len += PARA(hash_table->private_data_len);
+
+
+#if HASH_SANITY_CHECK
+	hash_table->csum = csum((unsigned char *)hash_table,sizeof(struct ipt_hash_table)-sizeof(__u32));
+#else
+	hash_table->csum = HASH_TABLE_MAGIC;
+#endif
+
+	for (i=0; i<hash_table->hash_tab_size; i++)
+	{
+		INIT_LIST_HEAD(&hash_table->hash_tab[i]);
+	}
+
+	return(hash_table);
+}
+
+STATIC __u32 hash_index(
+	struct ipt_hash_table	*hash_tab,
+	void					*hash_key
+	)
+{
+	__u32 index;
+
+	ASSERT_HASH_TABLE_MAGIC(hash_tab);
+
+	index = (*hash_tab->hash_func)(hash_key);
+	index &= hash_tab->hash_tab_size_mask;
+	return(index);
+}
+
+STATIC struct ipt_hash_entry *__ipt_hash_find_entry(
+	struct ipt_hash_table	*hash_tab,
+	void					*hash_key
+	)
+{
+	struct list_head		*h;
+	struct list_head		*e;
+	__u32					index;
+	struct ipt_hash_entry	*entry;
+
+	ASSERT_HASH_TABLE_MAGIC(hash_tab);
+
+	index = hash_index(hash_tab,hash_key);
+	IPT_DBG_ASSERT(index < hash_tab->hash_tab_size);
+
+	h = &hash_tab->hash_tab[index];
+
+	IPT_DBG_ASSERT(h->next);
+	IPT_DBG_ASSERT(h->prev);
+
+	list_for_each(e,h)
+	{
+		entry = list_entry(e,struct ipt_hash_entry,next);
+		ASSERT_HASH_ENTRY_MAGIC(entry);
+
+		if (!memcmp(entry->hash_key,hash_key,hash_tab->hash_key_len))
+		{
+			return(entry);
+		}
+	}
+	return(NULL);
+}
+
+void *ipt_hash_create_entry(
+	struct ipt_hash_table	*hash_tab,
+	void					*hash_key
+	)
+{
+	struct list_head		*l;
+	__u32					index;
+	struct ipt_hash_entry	*entry;
+
+	ASSERT_HASH_TABLE_MAGIC(hash_tab);
+
+#ifdef IPT_HASH_DEBUG
+	{
+		void *priv;
+		if ((priv = ipt_hash_find_entry(hash_tab,hash_key)))
+		{
+			IPT_DBG("hash entry already exists.\n");
+			return(priv);
+		}
+	}
+#endif
+
+	index = hash_index(hash_tab,hash_key);
+
+	l = &hash_tab->hash_tab[index];
+
+	if (!(entry = (struct ipt_hash_entry *)kmalloc(hash_tab->total_hash_entry_len,GFP_ATOMIC)))
+	{
+		printk(KERN_ERR "%s Could not allocate %u bytes\n",__FUNCTION__,hash_tab->total_hash_entry_len);
+		return(NULL);
+	}
+	memset(entry,0,hash_tab->total_hash_entry_len);
+
+	entry->magic = IPT_HASH_MAGIC;
+	entry->hash_key = (void *)(((__u32)entry) + PARA(sizeof(struct ipt_hash_entry)));
+	memcpy(entry->hash_key,hash_key,hash_tab->hash_key_len);
+
+	entry->private_data = (void *)(((__u32)entry->hash_key) + PARA(hash_tab->hash_key_len));
+
+#ifdef IPT_HASH_DEBUG
+	if (!list_empty(l))
+	{
+		IPT_DBG("Hash collision, index %u, private data %08x\n",index,(__u32)entry->private_data);
+	}
+#endif
+
+	list_add_tail(&entry->next,l);
+	hash_tab->num_entries += 1;
+
+	return(entry->private_data);
+}
+
+void ipt_hash_delete_entry(
+	struct ipt_hash_table	*hash_tab,
+	void					*hash_key
+	)
+{
+	struct ipt_hash_entry		*entry;
+
+	ASSERT_HASH_TABLE_MAGIC(hash_tab);
+
+	if (!(entry=__ipt_hash_find_entry(hash_tab,hash_key)))
+	{
+		DBG_PRINT("Could not delete hash entry.\n");
+		return;
+	}
+
+	ASSERT_HASH_ENTRY_MAGIC(entry);
+
+	IPT_DBG_ASSERT(hash_tab->num_entries);
+
+	list_del(&entry->next);
+	hash_tab->num_entries -= 1;
+
+	memset(entry,0,hash_tab->total_hash_entry_len);
+
+	kfree(entry);
+}
+
+void *ipt_hash_find_entry(
+	struct ipt_hash_table	*hash_tab,
+	void					*hash_key
+	)
+{
+	struct ipt_hash_entry		*entry;
+
+	ASSERT_HASH_TABLE_MAGIC(hash_tab);
+
+	if (!(entry=__ipt_hash_find_entry(hash_tab,hash_key)))
+	{
+		return(NULL);
+	}
+
+	ASSERT_HASH_ENTRY_MAGIC(entry);
+
+	return(entry->private_data);
+}
+
+STATIC struct ipt_hash_entry *__ipt_hash_traverse(
+	struct ipt_hash_table		*hash_tab,
+	struct ipt_hash_location	*loc
+	)
+{
+	struct ipt_hash_entry		*entry;
+
+	ASSERT_HASH_TABLE_MAGIC(hash_tab);
+	ASSERT_IPT_HASH_LOC_MAGIC(loc);
+
+	while (loc->index < hash_tab->hash_tab_size)
+	{
+		struct list_head *head = &hash_tab->hash_tab[loc->index];
+
+		loc->num_searches++;
+
+		if (loc->elem == head)
+		{
+			loc->elem = NULL;
+		}
+		else if (!list_empty(head))
+		{
+			if (loc->elem == NULL)
+			{
+				loc->elem = head->next;
+			}
+
+			entry = list_entry(loc->elem,struct ipt_hash_entry,next);
+			ASSERT_HASH_ENTRY_MAGIC(entry);
+
+			/*
+			 * The caller of this function could delete the entry,
+			 * in which case loc_elem already points to the next
+			 * in the list.
+			 */
+			loc->elem = loc->elem->next;
+			return(entry);
+		}
+
+		loc->index += 1;
+		loc->elem = (struct list_head *)NULL;
+	}
+
+	ipt_hash_traverse_init(loc);
+	return(NULL);
+}
+
+void *ipt_hash_traverse(
+	struct ipt_hash_table		*hash_tab,
+	struct ipt_hash_location	*loc
+	)
+{
+	struct ipt_hash_entry *entry;
+
+	ASSERT_HASH_TABLE_MAGIC(hash_tab);
+	ASSERT_IPT_HASH_LOC_MAGIC(loc);
+
+	if ((entry = __ipt_hash_traverse(hash_tab,loc)))
+	{
+		ASSERT_HASH_ENTRY_MAGIC(entry);
+		return(entry->private_data);
+	}
+	return(NULL);
+}
+
+void ipt_hash_delete_table(
+	struct ipt_hash_table	*hash_tab
+	)
+{
+	struct ipt_hash_location	loc;
+	struct ipt_hash_entry		*entry;
+
+	ASSERT_HASH_TABLE_MAGIC(hash_tab);
+
+	ipt_hash_traverse_init(&loc);
+
+	while ((entry = __ipt_hash_traverse(hash_tab,&loc)))
+	{
+		ASSERT_HASH_ENTRY_MAGIC(entry);
+		ipt_hash_delete_entry(hash_tab,entry->hash_key);
+		ipt_hash_traverse_init(&loc);
+	}
+
+	kfree(hash_tab);
+}
+
+
diff -r -u --new-file patch-o-matic-ng/hash/linux/net/ipv4/netfilter/ipt_hash.h patch-o-matic-ng.psdp.fuzzyp/hash/linux/net/ipv4/netfilter/ipt_hash.h
--- patch-o-matic-ng/hash/linux/net/ipv4/netfilter/ipt_hash.h	1969-12-31 17:00:00.000000000 -0700
+++ patch-o-matic-ng.psdp.fuzzyp/hash/linux/net/ipv4/netfilter/ipt_hash.h	2004-01-01 19:03:58.000000000 -0700
@@ -0,0 +1,129 @@
+/*
+
+	Copyright (C) 2003 Tim Gardner <timg@tpi.com>, TriplePoint, Inc.
+
+	This file is distributed under the terms of the GNU General Public
+	License (GPL). Copies of the GPL can be obtained from: http://www.gnu.org
+
+*/
+#ifndef _IPT_HASH_
+#define _IPT_HASH_
+
+#include <linux/list.h>
+#include <linux/kernel.h>
+#include <linux/string.h>
+#include <linux/slab.h>
+
+//#define IPT_HASH_DEBUG 1
+//#define IPT_ASSERTS 1
+
+#ifdef IPT_HASH_DEBUG
+#define IPT_DBG(S...) printk(KERN_ERR "%s: ",__FUNCTION__);printk(S);
+#else
+#define IPT_DBG(S...)
+#endif
+
+#ifdef IPT_ASSERTS
+#define IPT_DBG_ASSERT(exp) if (!(exp)) {printk( KERN_ERR "ASSERT(%s) -- %s#%d (%s)\n", #exp,__FILE__,__LINE__,__FUNCTION__);}
+#define STATIC
+#define STATIC_INLINE
+#else
+#define IPT_DBG_ASSERT(exp)
+#define STATIC static
+#define STATIC_INLINE static __inline__
+#endif
+
+
+#define DBG_PRINT(S...) printk(KERN_ERR " IPT: ");printk(S);
+
+#define IPT_HASH_MAGIC	0xdeadbeef
+#define ASSERT_HASH_ENTRY_MAGIC(_e) IPT_DBG_ASSERT((_e)->magic == IPT_HASH_MAGIC)
+
+struct ipt_hash_entry
+{
+	struct list_head	next;
+	__u32				magic;
+	void				*hash_key;
+	void				*private_data;
+};
+
+#define ASSERT_IPT_HASH_LOC_MAGIC(_l) IPT_DBG_ASSERT((_l)->magic == IPT_HASH_MAGIC)
+
+struct ipt_hash_location
+{
+	__u32				magic;
+	__u32				index;
+	struct list_head	*elem;
+	__u32				num_searches;
+};
+
+typedef __u32 (*IPT_HASH_FUNC)(void *hash_data);
+
+#define HASH_TABLE_MAGIC	(~IPT_HASH_MAGIC)
+
+struct ipt_hash_table
+{
+	struct list_head	*hash_tab;
+	__u32				hash_tab_size;
+	__u32				hash_tab_size_mask;
+	__u32				num_entries;
+	IPT_HASH_FUNC		hash_func;
+	__u32				hash_key_len;
+	__u32				private_data_len;
+	__u32				total_hash_entry_len;
+	__u32				csum;
+};
+
+extern
+struct ipt_hash_table *ipt_hash_create_table(
+	__u32 hash_tab_size,
+	IPT_HASH_FUNC hash_func,
+	__u32 private_data_len,
+	__u32 hash_key_len
+	);
+
+extern
+void ipt_hash_delete_table(
+	struct ipt_hash_table	*hash_tab
+	);
+
+extern
+void *ipt_hash_create_entry(
+	struct ipt_hash_table	*hash_tab,
+	void			*hash_key
+	);
+
+extern
+void ipt_hash_delete_entry(
+	struct ipt_hash_table	*hash_tab,
+	void			*hash_key
+	);
+
+extern
+void *ipt_hash_find_entry(
+	struct ipt_hash_table	*hash_tab,
+	void			*hash_key
+	);
+
+/*
+ * For first time, clear *loc.
+ */
+static __inline__ void ipt_hash_traverse_init(struct ipt_hash_location *loc)
+{
+	memset(loc,0,sizeof(struct ipt_hash_location));
+	loc->magic = IPT_HASH_MAGIC;
+}
+
+static __inline__ __u32 ipt_hash_num_entries(struct ipt_hash_table *hash_tab)
+{
+	return(hash_tab->num_entries);
+}
+
+extern
+void *ipt_hash_traverse(
+	struct ipt_hash_table		*hash_tab,
+	struct ipt_hash_location	*loc
+	);
+
+#endif
+
diff -r -u --new-file patch-o-matic-ng/hash/linux/net/ipv4/netfilter/Kconfig.ladd patch-o-matic-ng.psdp.fuzzyp/hash/linux/net/ipv4/netfilter/Kconfig.ladd
--- patch-o-matic-ng/hash/linux/net/ipv4/netfilter/Kconfig.ladd	1969-12-31 17:00:00.000000000 -0700
+++ patch-o-matic-ng.psdp.fuzzyp/hash/linux/net/ipv4/netfilter/Kconfig.ladd	2004-03-17 12:41:02.000000000 -0700
@@ -0,0 +1,5 @@
+config IP_NF_HASH
+	tristate "IP tables hash support. (required for some filters.)"
+	help
+	  These hash functions are required for some filters. If unsure, say Y.
+
diff -r -u --new-file patch-o-matic-ng/hash/linux/net/ipv4/netfilter/Makefile.ladd patch-o-matic-ng.psdp.fuzzyp/hash/linux/net/ipv4/netfilter/Makefile.ladd
--- patch-o-matic-ng/hash/linux/net/ipv4/netfilter/Makefile.ladd	1969-12-31 17:00:00.000000000 -0700
+++ patch-o-matic-ng.psdp.fuzzyp/hash/linux/net/ipv4/netfilter/Makefile.ladd	2004-03-17 14:40:54.000000000 -0700
@@ -0,0 +1,2 @@
+# the three instances of ip_tables
+obj-$(CONFIG_IP_NF_HASH) += ipt_hash.o


--------------Boundary-00=_NURQCG21ZZ74MFRCWNB7--
