From: Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 1/8] Netfilter:  Add a structure extension framework for
	connection tracking.
Date: Thu, 13 Jan 2005 07:53:09 +1100
Message-ID: <1105563189.12794.8.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Netfilter development mailing list <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
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

Name: Add a structure extension framework for connection tracking.
Status: Tested on 2.6.10-rc2-bk13
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

Create a ct_extend structure for adding random crap to structures
(intended for the ip_conntrack structures which hold a lot of extra
fields).

Don't use it for anything yet, but it will be protected by the
ip_conntrack_lock.  We can easily migrate this to RCU later.

Index: linux-2.6.10-bk14-Netfilter/net/ipv4/netfilter/ct_extend.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6.10-bk14-Netfilter/net/ipv4/netfilter/ct_extend.c	2005-01-12 23:36:24.671917744 +1100
@@ -0,0 +1,223 @@
+/* Structure dynamic extension infrastructure
+ * Copyright (C) 2004 Rusty Russell IBM Corporation
+ *
+ *      This program is free software; you can redistribute it and/or
+ *      modify it under the terms of the GNU General Public License
+ *      as published by the Free Software Foundation; either version
+ *      2 of the License, or (at your option) any later version.
+ */
+#include <linux/kernel.h>
+#include <linux/slab.h>
+#include <linux/module.h>
+#include <linux/netfilter_ipv4/ct_extend.h>
+
+static struct ct_extend_type cte_types[CTE_MAX];
+static spinlock_t cte_type_lock = SPIN_LOCK_UNLOCKED;
+
+/* Horrible trick to figure out smallest amount worth kmallocing. */
+#define CACHE(x) (x) + 0 *
+enum {
+	CT_EXTEND_MIN_SIZE = 
+#include <linux/kmalloc_sizes.h>
+	1 };
+#undef CACHE
+
+/* Find data offset of nth entry. */
+static unsigned int extend_offset(const struct ct_extend *ext, unsigned int n)
+{
+	unsigned int i, off;
+
+	off = sizeof(*ext);
+	for (i = 0; i < n; i++) {
+		struct ct_extend_type *t = &cte_types[ext->type[i]];
+		off = ALIGN(off, t->align) + t->len;
+	}
+	return ALIGN(off, cte_types[ext->type[n]].align)-sizeof(*ext);
+}
+
+void *__ct_extend_find(const struct ct_extend *ext, u8 type)
+{
+	u8 *p;
+
+	if (!ext)
+		return NULL;
+
+	p = memchr(ext->type, type, sizeof(ext->type));
+	if (!p)
+		return NULL;
+
+	return (void *)ext->data + extend_offset(ext, p - ext->type);
+}
+
+static unsigned int first_ext(const struct ct_extend *ext, unsigned int *i)
+{
+	unsigned int off = sizeof(*ext);
+
+	*i = 0;
+	if (ext->type[*i] == 0xFF)
+		return 0;
+	return ALIGN(off, cte_types[ext->type[*i]].align);
+}
+
+static unsigned int next_ext(const struct ct_extend *ext,
+		      unsigned int *i,
+		      unsigned int prev)
+{
+	if (ext->type[*i + 1] == 0xFF)
+		return 0;
+	prev += cte_types[ext->type[(*i)++]].len;
+	return ALIGN(prev, cte_types[ext->type[*i]].align);
+}
+
+void ct_extend_free(struct ct_extend *ext)
+{
+	unsigned int i, off;
+
+	for (off = first_ext(ext, &i); off; off = next_ext(ext, &i, off)) {
+		if (cte_types[ext->type[i]].free)
+			cte_types[ext->type[i]].free(ext, off-sizeof(*ext));
+	}
+	kfree(ext);
+}
+
+static unsigned int ct_extend_datalen(const struct ct_extend *ext)
+{
+	unsigned int i, off, dlen = 0;
+
+	for (off = first_ext(ext, &i); off; off = next_ext(ext, &i, off))
+		dlen = off-sizeof(*ext) + cte_types[ext->type[i]].len;
+
+	return dlen;
+}
+
+static void *cte_create(struct ct_extend **ext, enum ct_ext_type type, int gfp)
+{
+	unsigned int len;
+
+	len = ALIGN(sizeof(**ext), cte_types[type].align);
+	*ext = kmalloc(max_t(int, CT_EXTEND_MIN_SIZE,
+			     len + cte_types[type].len), gfp);
+	if (!*ext)
+		return NULL;
+ 
+	(*ext)->type[0] = type;
+	memset((*ext)->type+1, 0xFF, CTE_MAX-1);
+	return (void *)(*ext) + len;
+}
+
+void *__ct_extend_add(struct ct_extend **ext, enum ct_ext_type type, int gfp)
+{
+	struct ct_extend *new;
+	int i, len, newlen, newoff;
+
+	if (!*ext)
+		return cte_create(ext, type, gfp);
+
+	len = sizeof(*new) + ct_extend_datalen(*ext);
+	newoff = ALIGN(len, cte_types[type].align);
+	newlen = newoff + cte_types[type].len;
+
+	if (newlen >= CT_EXTEND_MIN_SIZE) {
+		int off;
+
+		new = kmalloc(newlen, gfp);
+		if (!new)
+			return NULL;
+		*new = **ext;
+
+		/* Copy one at a time, eg. two in same linked list. */
+		for (off = first_ext(new, &i);
+		     off;
+		     off = next_ext(new, &i, off)) {
+			struct ct_extend_type *t = &cte_types[new->type[i]];
+			memcpy((void *)new + off, (void *)*ext + off, t->len);
+			if (t->move)
+				t->move(new, off-sizeof(*new));
+		}
+		kfree(*ext);
+		*ext = new;
+	}
+
+	/* Find free slot. */
+	for (i = 0; i < CTE_MAX && (*ext)->type[i] != 0xFF; i++);
+	BUG_ON(i == CTE_MAX);
+
+	(*ext)->type[i] = type;
+	return (void *)(*ext) + newoff;
+}
+	
+struct ct_extend *ct_extend_del(struct ct_extend *ext,
+				  enum ct_ext_type type)
+{
+	unsigned int i, newi, off, nextoff, nexti, newoff;
+	enum ct_ext_type *p;
+
+	if (!ext)
+		return ext;
+
+	p = memchr(ext->type, type, sizeof(ext->type));
+	if (!p)
+		return ext;
+
+	/* If last one, simply drop free and return NULL. */
+	if (ext->type[1] == 0xFF) {
+		ct_extend_free(ext);
+		return NULL;
+	}
+
+	if (cte_types[type].free)
+		cte_types[type].free(ext, extend_offset(ext, p-ext->type));
+
+	newoff = sizeof(*ext);
+	newi = 0;
+	for (off = first_ext(ext, &i); off; off = nextoff, i = nexti) {
+		struct ct_extend_type *t = &cte_types[ext->type[i]];
+
+		/* Figure out next offset before we blatt type. */
+		nexti = i;
+		nextoff = next_ext(ext, &nexti, off);
+
+		/* Don't copy the one we're deleting. */
+		if (i == (p - ext->type))
+			continue;
+
+		/* Move type information and actual data. */
+		ext->type[newi] = ext->type[i];
+		newoff = ALIGN(newoff, t->align);
+		BUG_ON(newoff > off);
+		memmove((void *)ext + newoff, (void *)ext + off, t->len);
+		if (cte_types[ext->type[newi]].move)
+			cte_types[ext->type[newi]].move(ext,
+							newoff - sizeof(*ext));
+		newoff += t->len;
+		newi++;
+	}
+	while (newi < CTE_MAX)
+		ext->type[newi++] = 0xFF;
+	return ext;
+}
+
+void register_ct_extend_type(struct ct_extend_type *ext)
+{
+	spin_lock_irq(&cte_type_lock);
+	cte_types[ext->type] = *ext;
+	spin_unlock_irq(&cte_type_lock);
+}
+
+/* Presumably they don't care about the data any more, but we need to
+ * keep information about size and alignment so we can step across
+ * remaining instances. */
+void unregister_ct_extend_type(struct ct_extend_type *ext)
+{
+	spin_lock_irq(&cte_type_lock);
+	cte_types[ext->type].free = NULL;
+	cte_types[ext->type].move = NULL;
+	spin_unlock_irq(&cte_type_lock);
+}
+
+EXPORT_SYMBOL(ct_extend_find);
+EXPORT_SYMBOL(ct_extend_free);
+EXPORT_SYMBOL(ct_extend_add);
+EXPORT_SYMBOL(ct_extend_del);
+EXPORT_SYMBOL_GPL(register_ct_extend_type);
+EXPORT_SYMBOL_GPL(unregister_ct_extend_type);
Index: linux-2.6.10-bk14-Netfilter/net/ipv4/netfilter/Makefile
===================================================================
--- linux-2.6.10-bk14-Netfilter.orig/net/ipv4/netfilter/Makefile	2005-01-12 13:09:20.000000000 +1100
+++ linux-2.6.10-bk14-Netfilter/net/ipv4/netfilter/Makefile	2005-01-12 14:17:33.000000000 +1100
@@ -3,7 +3,7 @@
 #
 
 # objects for the standalone - connection tracking / NAT
-ip_conntrack-objs	:= ip_conntrack_standalone.o ip_conntrack_core.o ip_conntrack_proto_generic.o ip_conntrack_proto_tcp.o ip_conntrack_proto_udp.o ip_conntrack_proto_icmp.o
+ip_conntrack-objs	:= ip_conntrack_standalone.o ip_conntrack_core.o ip_conntrack_proto_generic.o ip_conntrack_proto_tcp.o ip_conntrack_proto_udp.o ip_conntrack_proto_icmp.o ct_extend.o
 iptable_nat-objs	:= ip_nat_standalone.o ip_nat_rule.o ip_nat_core.o ip_nat_helper.o ip_nat_proto_unknown.o ip_nat_proto_tcp.o ip_nat_proto_udp.o ip_nat_proto_icmp.o
 
 # connection tracking
Index: linux-2.6.10-bk14-Netfilter/include/linux/netfilter_ipv4/ct_extend.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ linux-2.6.10-bk14-Netfilter/include/linux/netfilter_ipv4/ct_extend.h	2005-01-12 23:39:17.013717808 +1100
@@ -0,0 +1,44 @@
+#ifndef _LINUX_CT_EXTEND_H
+#define _LINUX_CT_EXTEND_H
+#include <asm/atomic.h>
+
+enum ct_ext_type
+{
+	CTE_MAX,
+} __attribute__((packed));
+
+/* Extensions: optional stuff which isn't permanently in struct. */
+struct ct_extend {
+	enum ct_ext_type type[CTE_MAX];
+	char data[0];
+};
+
+#define ct_extend_find(ext, type) ((type##_TYPE *)__ct_extend_find(ext, type))
+void *__ct_extend_find(const struct ct_extend *ext, enum ct_ext_type type);
+void ct_extend_free(struct ct_extend *ext);
+
+/* Add this type, returns pointer to data or NULL. */
+#define ct_extend_add(ext, type, gfp) \
+	((type##_TYPE *)__ct_extend_add(ext, type, gfp))
+void *__ct_extend_add(struct ct_extend **ext, enum ct_ext_type type, int gfp);
+
+/* Assumes ct_extend is not shared: if all deleted, will return NULL */
+struct ct_extend *ct_extend_del(struct ct_extend *ext, enum ct_ext_type type);
+
+struct ct_extend_type
+{
+	/* Length and min alignment. */
+	u16 len;
+	u16 align;
+
+	/* Free operation (can be NULL). */
+	void (*free)(struct ct_extend *ext, unsigned int dataoff);
+	/* Move operation (can be NULL).  Has already been moved. */
+	void (*move)(struct ct_extend *ext, unsigned int dataoff);
+
+	enum ct_ext_type type;
+};
+
+void register_ct_extend_type(struct ct_extend_type *);
+void unregister_ct_extend_type(struct ct_extend_type *);
+#endif /* _LINUX_CT_EXTEND_H */
