From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [PATCH 02/13] [NETFILTER]: Rename ipt_recent to xt_recent
Date: Wed, 16 Apr 2008 17:30:54 +0200
Message-ID: <1099ccd0a2963e03dd599b2fefe99f871f27865e.1208359825.git.jengelh@computergmbh.de>
References: <1208359865-3022-1-git-send-email-jengelh@computergmbh.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:38079 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757211AbYDPPbH (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 16 Apr 2008 11:31:07 -0400
In-Reply-To: <1208359865-3022-1-git-send-email-jengelh@computergmbh.de>
In-Reply-To: <540dfb29c6c573830cbde9bf579ddef33657ed20.1208359825.git.jengelh@computergmbh.de>
References: <540dfb29c6c573830cbde9bf579ddef33657ed20.1208359825.git.jengelh@computergmbh.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Like with other modules (such as ipt_state), ipt_recent.h is changed
to forward definitions to (IOW include) xt_recent.h, and xt_recent.c
is changed to use the new constant names.

Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
---
 include/linux/netfilter/xt_recent.h       |   26 +
 include/linux/netfilter_ipv4/ipt_recent.h |   28 +-
 net/ipv4/netfilter/Kconfig                |   13 -
 net/ipv4/netfilter/Makefile               |    1 -
 net/ipv4/netfilter/ipt_recent.c           |  501 --------------------
 net/netfilter/Kconfig                     |   11 +
 net/netfilter/Makefile                    |    1 +
 net/netfilter/xt_recent.c                 |  502 +++++++++++++++++++++
 8 files changed, 551 insertions(+), 532 deletions(-)
 create mode 100644 include/linux/netfilter/xt_recent.h
 delete mode 100644 net/ipv4/netfilter/ipt_recent.c
 create mode 100644 net/netfilter/xt_recent.c

diff --git a/include/linux/netfilter/xt_recent.h b/include/linux/netfilter/xt_recent.h
new file mode 100644
index 0000000..5cfeb81
--- /dev/null
+++ b/include/linux/netfilter/xt_recent.h
@@ -0,0 +1,26 @@
+#ifndef _LINUX_NETFILTER_XT_RECENT_H
+#define _LINUX_NETFILTER_XT_RECENT_H 1
+
+enum {
+	XT_RECENT_CHECK    = 1 << 0,
+	XT_RECENT_SET      = 1 << 1,
+	XT_RECENT_UPDATE   = 1 << 2,
+	XT_RECENT_REMOVE   = 1 << 3,
+	XT_RECENT_TTL      = 1 << 4,
+
+	XT_RECENT_SOURCE   = 0,
+	XT_RECENT_DEST     = 1,
+
+	XT_RECENT_NAME_LEN = 200,
+};
+
+struct xt_recent_mtinfo {
+	u_int32_t seconds;
+	u_int32_t hit_count;
+	u_int8_t check_set;
+	u_int8_t invert;
+	char name[XT_RECENT_NAME_LEN];
+	u_int8_t side;
+};
+
+#endif /* _LINUX_NETFILTER_XT_RECENT_H */
diff --git a/include/linux/netfilter_ipv4/ipt_recent.h b/include/linux/netfilter_ipv4/ipt_recent.h
index 6508a45..d636cca 100644
--- a/include/linux/netfilter_ipv4/ipt_recent.h
+++ b/include/linux/netfilter_ipv4/ipt_recent.h
@@ -1,27 +1,21 @@
 #ifndef _IPT_RECENT_H
 #define _IPT_RECENT_H
 
-#define RECENT_NAME	"ipt_recent"
-#define RECENT_VER	"v0.3.1"
+#include <linux/netfilter/xt_recent.h>
 
-#define IPT_RECENT_CHECK  1
-#define IPT_RECENT_SET    2
-#define IPT_RECENT_UPDATE 4
-#define IPT_RECENT_REMOVE 8
-#define IPT_RECENT_TTL   16
+#define ipt_recent_info xt_recent_mtinfo
 
-#define IPT_RECENT_SOURCE 0
-#define IPT_RECENT_DEST   1
+enum {
+	IPT_RECENT_CHECK    = XT_RECENT_CHECK,
+	IPT_RECENT_SET      = XT_RECENT_SET,
+	IPT_RECENT_UPDATE   = XT_RECENT_UPDATE,
+	IPT_RECENT_REMOVE   = XT_RECENT_REMOVE,
+	IPT_RECENT_TTL      = XT_RECENT_TTL,
 
-#define IPT_RECENT_NAME_LEN 200
+	IPT_RECENT_SOURCE   = XT_RECENT_SOURCE,
+	IPT_RECENT_DEST     = XT_RECENT_DEST,
 
-struct ipt_recent_info {
-	u_int32_t   seconds;
-	u_int32_t   hit_count;
-	u_int8_t    check_set;
-	u_int8_t    invert;
-	char        name[IPT_RECENT_NAME_LEN];
-	u_int8_t    side;
+	IPT_RECENT_NAME_LEN = XT_RECENT_NAME_LEN,
 };
 
 #endif /*_IPT_RECENT_H*/
diff --git a/net/ipv4/netfilter/Kconfig b/net/ipv4/netfilter/Kconfig
index 0c95cd5..9ec4823 100644
--- a/net/ipv4/netfilter/Kconfig
+++ b/net/ipv4/netfilter/Kconfig
@@ -57,19 +57,6 @@ config IP_NF_IPTABLES
 	  To compile it as a module, choose M here.  If unsure, say N.
 
 # The matches.
-config IP_NF_MATCH_RECENT
-	tristate '"recent" match support'
-	depends on IP_NF_IPTABLES
-	depends on NETFILTER_ADVANCED
-	help
-	  This match is used for creating one or many lists of recently
-	  used addresses and then matching against that/those list(s).
-
-	  Short options are available by using 'iptables -m recent -h'
-	  Official Website: <http://snowman.net/projects/ipt_recent/>
-
-	  To compile it as a module, choose M here.  If unsure, say N.
-
 config IP_NF_MATCH_ECN
 	tristate '"ecn" match support'
 	depends on IP_NF_IPTABLES
diff --git a/net/ipv4/netfilter/Makefile b/net/ipv4/netfilter/Makefile
index d9b92fb..481a4ed 100644
--- a/net/ipv4/netfilter/Makefile
+++ b/net/ipv4/netfilter/Makefile
@@ -47,7 +47,6 @@ obj-$(CONFIG_IP_NF_RAW) += iptable_raw.o
 obj-$(CONFIG_IP_NF_MATCH_ADDRTYPE) += ipt_addrtype.o
 obj-$(CONFIG_IP_NF_MATCH_AH) += ipt_ah.o
 obj-$(CONFIG_IP_NF_MATCH_ECN) += ipt_ecn.o
-obj-$(CONFIG_IP_NF_MATCH_RECENT) += ipt_recent.o
 obj-$(CONFIG_IP_NF_MATCH_TTL) += ipt_ttl.o
 
 # targets
diff --git a/net/ipv4/netfilter/ipt_recent.c b/net/ipv4/netfilter/ipt_recent.c
deleted file mode 100644
index 21cb053..0000000
--- a/net/ipv4/netfilter/ipt_recent.c
+++ /dev/null
@@ -1,501 +0,0 @@
-/*
- * Copyright (c) 2006 Patrick McHardy <kaber@trash.net>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- *
- * This is a replacement of the old ipt_recent module, which carried the
- * following copyright notice:
- *
- * Author: Stephen Frost <sfrost@snowman.net>
- * Copyright 2002-2003, Stephen Frost, 2.5.x port by laforge@netfilter.org
- */
-#include <linux/init.h>
-#include <linux/ip.h>
-#include <linux/moduleparam.h>
-#include <linux/proc_fs.h>
-#include <linux/seq_file.h>
-#include <linux/string.h>
-#include <linux/ctype.h>
-#include <linux/list.h>
-#include <linux/random.h>
-#include <linux/jhash.h>
-#include <linux/bitops.h>
-#include <linux/skbuff.h>
-#include <linux/inet.h>
-#include <net/net_namespace.h>
-
-#include <linux/netfilter/x_tables.h>
-#include <linux/netfilter_ipv4/ipt_recent.h>
-
-MODULE_AUTHOR("Patrick McHardy <kaber@trash.net>");
-MODULE_DESCRIPTION("Xtables: \"recently-seen\" host matching for IPv4");
-MODULE_LICENSE("GPL");
-
-static unsigned int ip_list_tot = 100;
-static unsigned int ip_pkt_list_tot = 20;
-static unsigned int ip_list_hash_size = 0;
-static unsigned int ip_list_perms = 0644;
-static unsigned int ip_list_uid = 0;
-static unsigned int ip_list_gid = 0;
-module_param(ip_list_tot, uint, 0400);
-module_param(ip_pkt_list_tot, uint, 0400);
-module_param(ip_list_hash_size, uint, 0400);
-module_param(ip_list_perms, uint, 0400);
-module_param(ip_list_uid, uint, 0400);
-module_param(ip_list_gid, uint, 0400);
-MODULE_PARM_DESC(ip_list_tot, "number of IPs to remember per list");
-MODULE_PARM_DESC(ip_pkt_list_tot, "number of packets per IP to remember (max. 255)");
-MODULE_PARM_DESC(ip_list_hash_size, "size of hash table used to look up IPs");
-MODULE_PARM_DESC(ip_list_perms, "permissions on /proc/net/ipt_recent/* files");
-MODULE_PARM_DESC(ip_list_uid,"owner of /proc/net/ipt_recent/* files");
-MODULE_PARM_DESC(ip_list_gid,"owning group of /proc/net/ipt_recent/* files");
-
-struct recent_entry {
-	struct list_head	list;
-	struct list_head	lru_list;
-	__be32			addr;
-	u_int8_t		ttl;
-	u_int8_t		index;
-	u_int16_t		nstamps;
-	unsigned long		stamps[0];
-};
-
-struct recent_table {
-	struct list_head	list;
-	char			name[IPT_RECENT_NAME_LEN];
-#ifdef CONFIG_PROC_FS
-	struct proc_dir_entry	*proc;
-#endif
-	unsigned int		refcnt;
-	unsigned int		entries;
-	struct list_head	lru_list;
-	struct list_head	iphash[0];
-};
-
-static LIST_HEAD(tables);
-static DEFINE_SPINLOCK(recent_lock);
-static DEFINE_MUTEX(recent_mutex);
-
-#ifdef CONFIG_PROC_FS
-static struct proc_dir_entry	*proc_dir;
-static const struct file_operations	recent_fops;
-#endif
-
-static u_int32_t hash_rnd;
-static int hash_rnd_initted;
-
-static unsigned int recent_entry_hash(__be32 addr)
-{
-	if (!hash_rnd_initted) {
-		get_random_bytes(&hash_rnd, 4);
-		hash_rnd_initted = 1;
-	}
-	return jhash_1word((__force u32)addr, hash_rnd) & (ip_list_hash_size - 1);
-}
-
-static struct recent_entry *
-recent_entry_lookup(const struct recent_table *table, __be32 addr, u_int8_t ttl)
-{
-	struct recent_entry *e;
-	unsigned int h;
-
-	h = recent_entry_hash(addr);
-	list_for_each_entry(e, &table->iphash[h], list)
-		if (e->addr == addr && (ttl == e->ttl || !ttl || !e->ttl))
-			return e;
-	return NULL;
-}
-
-static void recent_entry_remove(struct recent_table *t, struct recent_entry *e)
-{
-	list_del(&e->list);
-	list_del(&e->lru_list);
-	kfree(e);
-	t->entries--;
-}
-
-static struct recent_entry *
-recent_entry_init(struct recent_table *t, __be32 addr, u_int8_t ttl)
-{
-	struct recent_entry *e;
-
-	if (t->entries >= ip_list_tot) {
-		e = list_entry(t->lru_list.next, struct recent_entry, lru_list);
-		recent_entry_remove(t, e);
-	}
-	e = kmalloc(sizeof(*e) + sizeof(e->stamps[0]) * ip_pkt_list_tot,
-		    GFP_ATOMIC);
-	if (e == NULL)
-		return NULL;
-	e->addr      = addr;
-	e->ttl       = ttl;
-	e->stamps[0] = jiffies;
-	e->nstamps   = 1;
-	e->index     = 1;
-	list_add_tail(&e->list, &t->iphash[recent_entry_hash(addr)]);
-	list_add_tail(&e->lru_list, &t->lru_list);
-	t->entries++;
-	return e;
-}
-
-static void recent_entry_update(struct recent_table *t, struct recent_entry *e)
-{
-	e->stamps[e->index++] = jiffies;
-	if (e->index > e->nstamps)
-		e->nstamps = e->index;
-	e->index %= ip_pkt_list_tot;
-	list_move_tail(&e->lru_list, &t->lru_list);
-}
-
-static struct recent_table *recent_table_lookup(const char *name)
-{
-	struct recent_table *t;
-
-	list_for_each_entry(t, &tables, list)
-		if (!strcmp(t->name, name))
-			return t;
-	return NULL;
-}
-
-static void recent_table_flush(struct recent_table *t)
-{
-	struct recent_entry *e, *next;
-	unsigned int i;
-
-	for (i = 0; i < ip_list_hash_size; i++)
-		list_for_each_entry_safe(e, next, &t->iphash[i], list)
-			recent_entry_remove(t, e);
-}
-
-static bool
-recent_mt(const struct sk_buff *skb, const struct net_device *in,
-          const struct net_device *out, const struct xt_match *match,
-          const void *matchinfo, int offset, unsigned int protoff,
-          bool *hotdrop)
-{
-	const struct ipt_recent_info *info = matchinfo;
-	struct recent_table *t;
-	struct recent_entry *e;
-	__be32 addr;
-	u_int8_t ttl;
-	bool ret = info->invert;
-
-	if (info->side == IPT_RECENT_DEST)
-		addr = ip_hdr(skb)->daddr;
-	else
-		addr = ip_hdr(skb)->saddr;
-
-	ttl = ip_hdr(skb)->ttl;
-	/* use TTL as seen before forwarding */
-	if (out && !skb->sk)
-		ttl++;
-
-	spin_lock_bh(&recent_lock);
-	t = recent_table_lookup(info->name);
-	e = recent_entry_lookup(t, addr,
-				info->check_set & IPT_RECENT_TTL ? ttl : 0);
-	if (e == NULL) {
-		if (!(info->check_set & IPT_RECENT_SET))
-			goto out;
-		e = recent_entry_init(t, addr, ttl);
-		if (e == NULL)
-			*hotdrop = true;
-		ret = !ret;
-		goto out;
-	}
-
-	if (info->check_set & IPT_RECENT_SET)
-		ret = !ret;
-	else if (info->check_set & IPT_RECENT_REMOVE) {
-		recent_entry_remove(t, e);
-		ret = !ret;
-	} else if (info->check_set & (IPT_RECENT_CHECK | IPT_RECENT_UPDATE)) {
-		unsigned long time = jiffies - info->seconds * HZ;
-		unsigned int i, hits = 0;
-
-		for (i = 0; i < e->nstamps; i++) {
-			if (info->seconds && time_after(time, e->stamps[i]))
-				continue;
-			if (++hits >= info->hit_count) {
-				ret = !ret;
-				break;
-			}
-		}
-	}
-
-	if (info->check_set & IPT_RECENT_SET ||
-	    (info->check_set & IPT_RECENT_UPDATE && ret)) {
-		recent_entry_update(t, e);
-		e->ttl = ttl;
-	}
-out:
-	spin_unlock_bh(&recent_lock);
-	return ret;
-}
-
-static bool
-recent_mt_check(const char *tablename, const void *ip,
-                const struct xt_match *match, void *matchinfo,
-                unsigned int hook_mask)
-{
-	const struct ipt_recent_info *info = matchinfo;
-	struct recent_table *t;
-	unsigned i;
-	bool ret = false;
-
-	if (hweight8(info->check_set &
-		     (IPT_RECENT_SET | IPT_RECENT_REMOVE |
-		      IPT_RECENT_CHECK | IPT_RECENT_UPDATE)) != 1)
-		return false;
-	if ((info->check_set & (IPT_RECENT_SET | IPT_RECENT_REMOVE)) &&
-	    (info->seconds || info->hit_count))
-		return false;
-	if (info->hit_count > ip_pkt_list_tot)
-		return false;
-	if (info->name[0] == '\0' ||
-	    strnlen(info->name, IPT_RECENT_NAME_LEN) == IPT_RECENT_NAME_LEN)
-		return false;
-
-	mutex_lock(&recent_mutex);
-	t = recent_table_lookup(info->name);
-	if (t != NULL) {
-		t->refcnt++;
-		ret = true;
-		goto out;
-	}
-
-	t = kzalloc(sizeof(*t) + sizeof(t->iphash[0]) * ip_list_hash_size,
-		    GFP_KERNEL);
-	if (t == NULL)
-		goto out;
-	t->refcnt = 1;
-	strcpy(t->name, info->name);
-	INIT_LIST_HEAD(&t->lru_list);
-	for (i = 0; i < ip_list_hash_size; i++)
-		INIT_LIST_HEAD(&t->iphash[i]);
-#ifdef CONFIG_PROC_FS
-	t->proc = proc_create(t->name, ip_list_perms, proc_dir, &recent_fops);
-	if (t->proc == NULL) {
-		kfree(t);
-		goto out;
-	}
-	t->proc->uid       = ip_list_uid;
-	t->proc->gid       = ip_list_gid;
-	t->proc->data      = t;
-#endif
-	spin_lock_bh(&recent_lock);
-	list_add_tail(&t->list, &tables);
-	spin_unlock_bh(&recent_lock);
-	ret = true;
-out:
-	mutex_unlock(&recent_mutex);
-	return ret;
-}
-
-static void recent_mt_destroy(const struct xt_match *match, void *matchinfo)
-{
-	const struct ipt_recent_info *info = matchinfo;
-	struct recent_table *t;
-
-	mutex_lock(&recent_mutex);
-	t = recent_table_lookup(info->name);
-	if (--t->refcnt == 0) {
-		spin_lock_bh(&recent_lock);
-		list_del(&t->list);
-		spin_unlock_bh(&recent_lock);
-		recent_table_flush(t);
-#ifdef CONFIG_PROC_FS
-		remove_proc_entry(t->name, proc_dir);
-#endif
-		kfree(t);
-	}
-	mutex_unlock(&recent_mutex);
-}
-
-#ifdef CONFIG_PROC_FS
-struct recent_iter_state {
-	struct recent_table	*table;
-	unsigned int		bucket;
-};
-
-static void *recent_seq_start(struct seq_file *seq, loff_t *pos)
-	__acquires(recent_lock)
-{
-	struct recent_iter_state *st = seq->private;
-	const struct recent_table *t = st->table;
-	struct recent_entry *e;
-	loff_t p = *pos;
-
-	spin_lock_bh(&recent_lock);
-
-	for (st->bucket = 0; st->bucket < ip_list_hash_size; st->bucket++)
-		list_for_each_entry(e, &t->iphash[st->bucket], list)
-			if (p-- == 0)
-				return e;
-	return NULL;
-}
-
-static void *recent_seq_next(struct seq_file *seq, void *v, loff_t *pos)
-{
-	struct recent_iter_state *st = seq->private;
-	const struct recent_table *t = st->table;
-	struct recent_entry *e = v;
-	struct list_head *head = e->list.next;
-
-	while (head == &t->iphash[st->bucket]) {
-		if (++st->bucket >= ip_list_hash_size)
-			return NULL;
-		head = t->iphash[st->bucket].next;
-	}
-	(*pos)++;
-	return list_entry(head, struct recent_entry, list);
-}
-
-static void recent_seq_stop(struct seq_file *s, void *v)
-	__releases(recent_lock)
-{
-	spin_unlock_bh(&recent_lock);
-}
-
-static int recent_seq_show(struct seq_file *seq, void *v)
-{
-	const struct recent_entry *e = v;
-	unsigned int i;
-
-	i = (e->index - 1) % ip_pkt_list_tot;
-	seq_printf(seq, "src=%u.%u.%u.%u ttl: %u last_seen: %lu oldest_pkt: %u",
-		   NIPQUAD(e->addr), e->ttl, e->stamps[i], e->index);
-	for (i = 0; i < e->nstamps; i++)
-		seq_printf(seq, "%s %lu", i ? "," : "", e->stamps[i]);
-	seq_printf(seq, "\n");
-	return 0;
-}
-
-static const struct seq_operations recent_seq_ops = {
-	.start		= recent_seq_start,
-	.next		= recent_seq_next,
-	.stop		= recent_seq_stop,
-	.show		= recent_seq_show,
-};
-
-static int recent_seq_open(struct inode *inode, struct file *file)
-{
-	struct proc_dir_entry *pde = PDE(inode);
-	struct recent_iter_state *st;
-
-	st = __seq_open_private(file, &recent_seq_ops, sizeof(*st));
-	if (st == NULL)
-		return -ENOMEM;
-
-	st->table    = pde->data;
-	return 0;
-}
-
-static ssize_t recent_proc_write(struct file *file, const char __user *input,
-				 size_t size, loff_t *loff)
-{
-	const struct proc_dir_entry *pde = PDE(file->f_path.dentry->d_inode);
-	struct recent_table *t = pde->data;
-	struct recent_entry *e;
-	char buf[sizeof("+255.255.255.255")], *c = buf;
-	__be32 addr;
-	int add;
-
-	if (size > sizeof(buf))
-		size = sizeof(buf);
-	if (copy_from_user(buf, input, size))
-		return -EFAULT;
-	while (isspace(*c))
-		c++;
-
-	if (size - (c - buf) < 5)
-		return c - buf;
-	if (!strncmp(c, "clear", 5)) {
-		c += 5;
-		spin_lock_bh(&recent_lock);
-		recent_table_flush(t);
-		spin_unlock_bh(&recent_lock);
-		return c - buf;
-	}
-
-	switch (*c) {
-	case '-':
-		add = 0;
-		c++;
-		break;
-	case '+':
-		c++;
-	default:
-		add = 1;
-		break;
-	}
-	addr = in_aton(c);
-
-	spin_lock_bh(&recent_lock);
-	e = recent_entry_lookup(t, addr, 0);
-	if (e == NULL) {
-		if (add)
-			recent_entry_init(t, addr, 0);
-	} else {
-		if (add)
-			recent_entry_update(t, e);
-		else
-			recent_entry_remove(t, e);
-	}
-	spin_unlock_bh(&recent_lock);
-	return size;
-}
-
-static const struct file_operations recent_fops = {
-	.open		= recent_seq_open,
-	.read		= seq_read,
-	.write		= recent_proc_write,
-	.release	= seq_release_private,
-	.owner		= THIS_MODULE,
-};
-#endif /* CONFIG_PROC_FS */
-
-static struct xt_match recent_mt_reg __read_mostly = {
-	.name		= "recent",
-	.family		= AF_INET,
-	.match		= recent_mt,
-	.matchsize	= sizeof(struct ipt_recent_info),
-	.checkentry	= recent_mt_check,
-	.destroy	= recent_mt_destroy,
-	.me		= THIS_MODULE,
-};
-
-static int __init recent_mt_init(void)
-{
-	int err;
-
-	if (!ip_list_tot || !ip_pkt_list_tot || ip_pkt_list_tot > 255)
-		return -EINVAL;
-	ip_list_hash_size = 1 << fls(ip_list_tot);
-
-	err = xt_register_match(&recent_mt_reg);
-#ifdef CONFIG_PROC_FS
-	if (err)
-		return err;
-	proc_dir = proc_mkdir("ipt_recent", init_net.proc_net);
-	if (proc_dir == NULL) {
-		xt_unregister_match(&recent_mt_reg);
-		err = -ENOMEM;
-	}
-#endif
-	return err;
-}
-
-static void __exit recent_mt_exit(void)
-{
-	BUG_ON(!list_empty(&tables));
-	xt_unregister_match(&recent_mt_reg);
-#ifdef CONFIG_PROC_FS
-	remove_proc_entry("ipt_recent", init_net.proc_net);
-#endif
-}
-
-module_init(recent_mt_init);
-module_exit(recent_mt_exit);
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index c1fc0f1..292269d 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -721,6 +721,17 @@ config NETFILTER_XT_MATCH_REALM
 	  If you want to compile it as a module, say M here and read
 	  <file:Documentation/kbuild/modules.txt>.  If unsure, say `N'.
 
+config NETFILTER_XT_MATCH_RECENT
+	tristate '"recent" match support'
+	depends on NETFILTER_XTABLES
+	depends on NETFILTER_ADVANCED
+	---help---
+	This match is used for creating one or many lists of recently
+	used addresses and then matching against that/those list(s).
+
+	Short options are available by using 'iptables -m recent -h'
+	Official Website: <http://snowman.net/projects/ipt_recent/>
+
 config NETFILTER_XT_MATCH_SCTP
 	tristate  '"sctp" protocol match support (EXPERIMENTAL)'
 	depends on NETFILTER_XTABLES && EXPERIMENTAL
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index 5c4b183..b8ea59f 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -76,6 +76,7 @@ obj-$(CONFIG_NETFILTER_XT_MATCH_POLICY) += xt_policy.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_QUOTA) += xt_quota.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_RATEEST) += xt_rateest.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_REALM) += xt_realm.o
+obj-$(CONFIG_NETFILTER_XT_MATCH_RECENT) += xt_recent.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_SCTP) += xt_sctp.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_STATE) += xt_state.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_STATISTIC) += xt_statistic.o
diff --git a/net/netfilter/xt_recent.c b/net/netfilter/xt_recent.c
new file mode 100644
index 0000000..15ddb6c
--- /dev/null
+++ b/net/netfilter/xt_recent.c
@@ -0,0 +1,502 @@
+/*
+ * Copyright (c) 2006 Patrick McHardy <kaber@trash.net>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This is a replacement of the old ipt_recent module, which carried the
+ * following copyright notice:
+ *
+ * Author: Stephen Frost <sfrost@snowman.net>
+ * Copyright 2002-2003, Stephen Frost, 2.5.x port by laforge@netfilter.org
+ */
+#include <linux/init.h>
+#include <linux/ip.h>
+#include <linux/moduleparam.h>
+#include <linux/proc_fs.h>
+#include <linux/seq_file.h>
+#include <linux/string.h>
+#include <linux/ctype.h>
+#include <linux/list.h>
+#include <linux/random.h>
+#include <linux/jhash.h>
+#include <linux/bitops.h>
+#include <linux/skbuff.h>
+#include <linux/inet.h>
+#include <net/net_namespace.h>
+
+#include <linux/netfilter/x_tables.h>
+#include <linux/netfilter/xt_recent.h>
+
+MODULE_AUTHOR("Patrick McHardy <kaber@trash.net>");
+MODULE_DESCRIPTION("Xtables: \"recently-seen\" host matching for IPv4");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("ipt_recent");
+
+static unsigned int ip_list_tot = 100;
+static unsigned int ip_pkt_list_tot = 20;
+static unsigned int ip_list_hash_size = 0;
+static unsigned int ip_list_perms = 0644;
+static unsigned int ip_list_uid = 0;
+static unsigned int ip_list_gid = 0;
+module_param(ip_list_tot, uint, 0400);
+module_param(ip_pkt_list_tot, uint, 0400);
+module_param(ip_list_hash_size, uint, 0400);
+module_param(ip_list_perms, uint, 0400);
+module_param(ip_list_uid, uint, 0400);
+module_param(ip_list_gid, uint, 0400);
+MODULE_PARM_DESC(ip_list_tot, "number of IPs to remember per list");
+MODULE_PARM_DESC(ip_pkt_list_tot, "number of packets per IP to remember (max. 255)");
+MODULE_PARM_DESC(ip_list_hash_size, "size of hash table used to look up IPs");
+MODULE_PARM_DESC(ip_list_perms, "permissions on /proc/net/ipt_recent/* files");
+MODULE_PARM_DESC(ip_list_uid,"owner of /proc/net/ipt_recent/* files");
+MODULE_PARM_DESC(ip_list_gid,"owning group of /proc/net/ipt_recent/* files");
+
+struct recent_entry {
+	struct list_head	list;
+	struct list_head	lru_list;
+	__be32			addr;
+	u_int8_t		ttl;
+	u_int8_t		index;
+	u_int16_t		nstamps;
+	unsigned long		stamps[0];
+};
+
+struct recent_table {
+	struct list_head	list;
+	char			name[XT_RECENT_NAME_LEN];
+#ifdef CONFIG_PROC_FS
+	struct proc_dir_entry	*proc;
+#endif
+	unsigned int		refcnt;
+	unsigned int		entries;
+	struct list_head	lru_list;
+	struct list_head	iphash[0];
+};
+
+static LIST_HEAD(tables);
+static DEFINE_SPINLOCK(recent_lock);
+static DEFINE_MUTEX(recent_mutex);
+
+#ifdef CONFIG_PROC_FS
+static struct proc_dir_entry	*proc_dir;
+static const struct file_operations	recent_fops;
+#endif
+
+static u_int32_t hash_rnd;
+static int hash_rnd_initted;
+
+static unsigned int recent_entry_hash(__be32 addr)
+{
+	if (!hash_rnd_initted) {
+		get_random_bytes(&hash_rnd, 4);
+		hash_rnd_initted = 1;
+	}
+	return jhash_1word((__force u32)addr, hash_rnd) & (ip_list_hash_size - 1);
+}
+
+static struct recent_entry *
+recent_entry_lookup(const struct recent_table *table, __be32 addr, u_int8_t ttl)
+{
+	struct recent_entry *e;
+	unsigned int h;
+
+	h = recent_entry_hash(addr);
+	list_for_each_entry(e, &table->iphash[h], list)
+		if (e->addr == addr && (ttl == e->ttl || !ttl || !e->ttl))
+			return e;
+	return NULL;
+}
+
+static void recent_entry_remove(struct recent_table *t, struct recent_entry *e)
+{
+	list_del(&e->list);
+	list_del(&e->lru_list);
+	kfree(e);
+	t->entries--;
+}
+
+static struct recent_entry *
+recent_entry_init(struct recent_table *t, __be32 addr, u_int8_t ttl)
+{
+	struct recent_entry *e;
+
+	if (t->entries >= ip_list_tot) {
+		e = list_entry(t->lru_list.next, struct recent_entry, lru_list);
+		recent_entry_remove(t, e);
+	}
+	e = kmalloc(sizeof(*e) + sizeof(e->stamps[0]) * ip_pkt_list_tot,
+		    GFP_ATOMIC);
+	if (e == NULL)
+		return NULL;
+	e->addr      = addr;
+	e->ttl       = ttl;
+	e->stamps[0] = jiffies;
+	e->nstamps   = 1;
+	e->index     = 1;
+	list_add_tail(&e->list, &t->iphash[recent_entry_hash(addr)]);
+	list_add_tail(&e->lru_list, &t->lru_list);
+	t->entries++;
+	return e;
+}
+
+static void recent_entry_update(struct recent_table *t, struct recent_entry *e)
+{
+	e->stamps[e->index++] = jiffies;
+	if (e->index > e->nstamps)
+		e->nstamps = e->index;
+	e->index %= ip_pkt_list_tot;
+	list_move_tail(&e->lru_list, &t->lru_list);
+}
+
+static struct recent_table *recent_table_lookup(const char *name)
+{
+	struct recent_table *t;
+
+	list_for_each_entry(t, &tables, list)
+		if (!strcmp(t->name, name))
+			return t;
+	return NULL;
+}
+
+static void recent_table_flush(struct recent_table *t)
+{
+	struct recent_entry *e, *next;
+	unsigned int i;
+
+	for (i = 0; i < ip_list_hash_size; i++)
+		list_for_each_entry_safe(e, next, &t->iphash[i], list)
+			recent_entry_remove(t, e);
+}
+
+static bool
+recent_mt(const struct sk_buff *skb, const struct net_device *in,
+          const struct net_device *out, const struct xt_match *match,
+          const void *matchinfo, int offset, unsigned int protoff,
+          bool *hotdrop)
+{
+	const struct xt_recent_mtinfo *info = matchinfo;
+	struct recent_table *t;
+	struct recent_entry *e;
+	__be32 addr;
+	u_int8_t ttl;
+	bool ret = info->invert;
+
+	if (info->side == XT_RECENT_DEST)
+		addr = ip_hdr(skb)->daddr;
+	else
+		addr = ip_hdr(skb)->saddr;
+
+	ttl = ip_hdr(skb)->ttl;
+	/* use TTL as seen before forwarding */
+	if (out && !skb->sk)
+		ttl++;
+
+	spin_lock_bh(&recent_lock);
+	t = recent_table_lookup(info->name);
+	e = recent_entry_lookup(t, addr,
+				info->check_set & XT_RECENT_TTL ? ttl : 0);
+	if (e == NULL) {
+		if (!(info->check_set & XT_RECENT_SET))
+			goto out;
+		e = recent_entry_init(t, addr, ttl);
+		if (e == NULL)
+			*hotdrop = true;
+		ret = !ret;
+		goto out;
+	}
+
+	if (info->check_set & XT_RECENT_SET)
+		ret = !ret;
+	else if (info->check_set & XT_RECENT_REMOVE) {
+		recent_entry_remove(t, e);
+		ret = !ret;
+	} else if (info->check_set & (XT_RECENT_CHECK | XT_RECENT_UPDATE)) {
+		unsigned long time = jiffies - info->seconds * HZ;
+		unsigned int i, hits = 0;
+
+		for (i = 0; i < e->nstamps; i++) {
+			if (info->seconds && time_after(time, e->stamps[i]))
+				continue;
+			if (++hits >= info->hit_count) {
+				ret = !ret;
+				break;
+			}
+		}
+	}
+
+	if (info->check_set & XT_RECENT_SET ||
+	    (info->check_set & XT_RECENT_UPDATE && ret)) {
+		recent_entry_update(t, e);
+		e->ttl = ttl;
+	}
+out:
+	spin_unlock_bh(&recent_lock);
+	return ret;
+}
+
+static bool
+recent_mt_check(const char *tablename, const void *ip,
+                const struct xt_match *match, void *matchinfo,
+                unsigned int hook_mask)
+{
+	const struct xt_recent_mtinfo *info = matchinfo;
+	struct recent_table *t;
+	unsigned i;
+	bool ret = false;
+
+	if (hweight8(info->check_set &
+		     (XT_RECENT_SET | XT_RECENT_REMOVE |
+		      XT_RECENT_CHECK | XT_RECENT_UPDATE)) != 1)
+		return false;
+	if ((info->check_set & (XT_RECENT_SET | XT_RECENT_REMOVE)) &&
+	    (info->seconds || info->hit_count))
+		return false;
+	if (info->hit_count > ip_pkt_list_tot)
+		return false;
+	if (info->name[0] == '\0' ||
+	    strnlen(info->name, XT_RECENT_NAME_LEN) == XT_RECENT_NAME_LEN)
+		return false;
+
+	mutex_lock(&recent_mutex);
+	t = recent_table_lookup(info->name);
+	if (t != NULL) {
+		t->refcnt++;
+		ret = true;
+		goto out;
+	}
+
+	t = kzalloc(sizeof(*t) + sizeof(t->iphash[0]) * ip_list_hash_size,
+		    GFP_KERNEL);
+	if (t == NULL)
+		goto out;
+	t->refcnt = 1;
+	strcpy(t->name, info->name);
+	INIT_LIST_HEAD(&t->lru_list);
+	for (i = 0; i < ip_list_hash_size; i++)
+		INIT_LIST_HEAD(&t->iphash[i]);
+#ifdef CONFIG_PROC_FS
+	t->proc = proc_create(t->name, ip_list_perms, proc_dir, &recent_fops);
+	if (t->proc == NULL) {
+		kfree(t);
+		goto out;
+	}
+	t->proc->uid       = ip_list_uid;
+	t->proc->gid       = ip_list_gid;
+	t->proc->data      = t;
+#endif
+	spin_lock_bh(&recent_lock);
+	list_add_tail(&t->list, &tables);
+	spin_unlock_bh(&recent_lock);
+	ret = true;
+out:
+	mutex_unlock(&recent_mutex);
+	return ret;
+}
+
+static void recent_mt_destroy(const struct xt_match *match, void *matchinfo)
+{
+	const struct xt_recent_mtinfo *info = matchinfo;
+	struct recent_table *t;
+
+	mutex_lock(&recent_mutex);
+	t = recent_table_lookup(info->name);
+	if (--t->refcnt == 0) {
+		spin_lock_bh(&recent_lock);
+		list_del(&t->list);
+		spin_unlock_bh(&recent_lock);
+		recent_table_flush(t);
+#ifdef CONFIG_PROC_FS
+		remove_proc_entry(t->name, proc_dir);
+#endif
+		kfree(t);
+	}
+	mutex_unlock(&recent_mutex);
+}
+
+#ifdef CONFIG_PROC_FS
+struct recent_iter_state {
+	struct recent_table	*table;
+	unsigned int		bucket;
+};
+
+static void *recent_seq_start(struct seq_file *seq, loff_t *pos)
+	__acquires(recent_lock)
+{
+	struct recent_iter_state *st = seq->private;
+	const struct recent_table *t = st->table;
+	struct recent_entry *e;
+	loff_t p = *pos;
+
+	spin_lock_bh(&recent_lock);
+
+	for (st->bucket = 0; st->bucket < ip_list_hash_size; st->bucket++)
+		list_for_each_entry(e, &t->iphash[st->bucket], list)
+			if (p-- == 0)
+				return e;
+	return NULL;
+}
+
+static void *recent_seq_next(struct seq_file *seq, void *v, loff_t *pos)
+{
+	struct recent_iter_state *st = seq->private;
+	const struct recent_table *t = st->table;
+	struct recent_entry *e = v;
+	struct list_head *head = e->list.next;
+
+	while (head == &t->iphash[st->bucket]) {
+		if (++st->bucket >= ip_list_hash_size)
+			return NULL;
+		head = t->iphash[st->bucket].next;
+	}
+	(*pos)++;
+	return list_entry(head, struct recent_entry, list);
+}
+
+static void recent_seq_stop(struct seq_file *s, void *v)
+	__releases(recent_lock)
+{
+	spin_unlock_bh(&recent_lock);
+}
+
+static int recent_seq_show(struct seq_file *seq, void *v)
+{
+	const struct recent_entry *e = v;
+	unsigned int i;
+
+	i = (e->index - 1) % ip_pkt_list_tot;
+	seq_printf(seq, "src=%u.%u.%u.%u ttl: %u last_seen: %lu oldest_pkt: %u",
+		   NIPQUAD(e->addr), e->ttl, e->stamps[i], e->index);
+	for (i = 0; i < e->nstamps; i++)
+		seq_printf(seq, "%s %lu", i ? "," : "", e->stamps[i]);
+	seq_printf(seq, "\n");
+	return 0;
+}
+
+static const struct seq_operations recent_seq_ops = {
+	.start		= recent_seq_start,
+	.next		= recent_seq_next,
+	.stop		= recent_seq_stop,
+	.show		= recent_seq_show,
+};
+
+static int recent_seq_open(struct inode *inode, struct file *file)
+{
+	struct proc_dir_entry *pde = PDE(inode);
+	struct recent_iter_state *st;
+
+	st = __seq_open_private(file, &recent_seq_ops, sizeof(*st));
+	if (st == NULL)
+		return -ENOMEM;
+
+	st->table    = pde->data;
+	return 0;
+}
+
+static ssize_t recent_proc_write(struct file *file, const char __user *input,
+				 size_t size, loff_t *loff)
+{
+	const struct proc_dir_entry *pde = PDE(file->f_path.dentry->d_inode);
+	struct recent_table *t = pde->data;
+	struct recent_entry *e;
+	char buf[sizeof("+255.255.255.255")], *c = buf;
+	__be32 addr;
+	int add;
+
+	if (size > sizeof(buf))
+		size = sizeof(buf);
+	if (copy_from_user(buf, input, size))
+		return -EFAULT;
+	while (isspace(*c))
+		c++;
+
+	if (size - (c - buf) < 5)
+		return c - buf;
+	if (!strncmp(c, "clear", 5)) {
+		c += 5;
+		spin_lock_bh(&recent_lock);
+		recent_table_flush(t);
+		spin_unlock_bh(&recent_lock);
+		return c - buf;
+	}
+
+	switch (*c) {
+	case '-':
+		add = 0;
+		c++;
+		break;
+	case '+':
+		c++;
+	default:
+		add = 1;
+		break;
+	}
+	addr = in_aton(c);
+
+	spin_lock_bh(&recent_lock);
+	e = recent_entry_lookup(t, addr, 0);
+	if (e == NULL) {
+		if (add)
+			recent_entry_init(t, addr, 0);
+	} else {
+		if (add)
+			recent_entry_update(t, e);
+		else
+			recent_entry_remove(t, e);
+	}
+	spin_unlock_bh(&recent_lock);
+	return size;
+}
+
+static const struct file_operations recent_fops = {
+	.open		= recent_seq_open,
+	.read		= seq_read,
+	.write		= recent_proc_write,
+	.release	= seq_release_private,
+	.owner		= THIS_MODULE,
+};
+#endif /* CONFIG_PROC_FS */
+
+static struct xt_match recent_mt_reg __read_mostly = {
+	.name		= "recent",
+	.family		= AF_INET,
+	.match		= recent_mt,
+	.matchsize	= sizeof(struct xt_recent_mtinfo),
+	.checkentry	= recent_mt_check,
+	.destroy	= recent_mt_destroy,
+	.me		= THIS_MODULE,
+};
+
+static int __init recent_mt_init(void)
+{
+	int err;
+
+	if (!ip_list_tot || !ip_pkt_list_tot || ip_pkt_list_tot > 255)
+		return -EINVAL;
+	ip_list_hash_size = 1 << fls(ip_list_tot);
+
+	err = xt_register_match(&recent_mt_reg);
+#ifdef CONFIG_PROC_FS
+	if (err)
+		return err;
+	proc_dir = proc_mkdir("ipt_recent", init_net.proc_net);
+	if (proc_dir == NULL) {
+		xt_unregister_match(&recent_mt_reg);
+		err = -ENOMEM;
+	}
+#endif
+	return err;
+}
+
+static void __exit recent_mt_exit(void)
+{
+	BUG_ON(!list_empty(&tables));
+	xt_unregister_match(&recent_mt_reg);
+#ifdef CONFIG_PROC_FS
+	remove_proc_entry("ipt_recent", init_net.proc_net);
+#endif
+}
+
+module_init(recent_mt_init);
+module_exit(recent_mt_exit);
-- 
1.5.5

