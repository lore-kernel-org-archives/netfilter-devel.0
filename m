From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [PATCH 03/13] [NETFILTER]: xt_recent: IPv6 support
Date: Wed, 16 Apr 2008 17:30:55 +0200
Message-ID: <7461476d0771efb8c219ad873964208f18b5207a.1208359825.git.jengelh@computergmbh.de>
References: <1208359865-3022-1-git-send-email-jengelh@computergmbh.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:38081 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758306AbYDPPbH (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 16 Apr 2008 11:31:07 -0400
In-Reply-To: <1208359865-3022-1-git-send-email-jengelh@computergmbh.de>
In-Reply-To: <540dfb29c6c573830cbde9bf579ddef33657ed20.1208359825.git.jengelh@computergmbh.de>
References: <540dfb29c6c573830cbde9bf579ddef33657ed20.1208359825.git.jengelh@computergmbh.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This updates xt_recent to support the IPv6 address family.
The new /proc/net/xt_recent directory must be used for this.

Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
---
 Documentation/feature-removal-schedule.txt |    3 +
 net/netfilter/xt_recent.c                  |  287 ++++++++++++++++----
 2 files changed, 236 insertions(+), 54 deletions(-)

diff --git a/Documentation/feature-removal-schedule.txt b/Documentation=
/feature-removal-schedule.txt
index ee3cc8b..84ef5d7 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -246,6 +246,9 @@ What (Why):
 	- xt_mark match revision 0
 	  (superseded by xt_mark match revision 1)
=20
+	- xt_recent: the old ipt_recent proc dir
+	  (superseded by /proc/net/xt_recent)
+
 When:	January 2009 or Linux 2.7.0, whichever comes first
 Why:	Superseded by newer revisions or modules
 Who:	Jan Engelhardt <jengelh@computergmbh.de>
diff --git a/net/netfilter/xt_recent.c b/net/netfilter/xt_recent.c
index 15ddb6c..382691d 100644
--- a/net/netfilter/xt_recent.c
+++ b/net/netfilter/xt_recent.c
@@ -1,5 +1,6 @@
 /*
  * Copyright (c) 2006 Patrick McHardy <kaber@trash.net>
+ * Copyright =C2=A9 CC Computer Consultants GmbH, 2007 - 2008
  *
  * This program is free software; you can redistribute it and/or modif=
y
  * it under the terms of the GNU General Public License version 2 as
@@ -13,6 +14,8 @@
  */
 #include <linux/init.h>
 #include <linux/ip.h>
+#include <linux/ipv6.h>
+#include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/proc_fs.h>
 #include <linux/seq_file.h>
@@ -30,9 +33,11 @@
 #include <linux/netfilter/xt_recent.h>
=20
 MODULE_AUTHOR("Patrick McHardy <kaber@trash.net>");
+MODULE_AUTHOR("Jan Engelhardt <jengelh@computergmbh.de>");
 MODULE_DESCRIPTION("Xtables: \"recently-seen\" host matching for IPv4"=
);
 MODULE_LICENSE("GPL");
 MODULE_ALIAS("ipt_recent");
+MODULE_ALIAS("ip6t_recent");
=20
 static unsigned int ip_list_tot =3D 100;
 static unsigned int ip_pkt_list_tot =3D 20;
@@ -49,14 +54,15 @@ module_param(ip_list_gid, uint, 0400);
 MODULE_PARM_DESC(ip_list_tot, "number of IPs to remember per list");
 MODULE_PARM_DESC(ip_pkt_list_tot, "number of packets per IP to remembe=
r (max. 255)");
 MODULE_PARM_DESC(ip_list_hash_size, "size of hash table used to look u=
p IPs");
-MODULE_PARM_DESC(ip_list_perms, "permissions on /proc/net/ipt_recent/*=
 files");
-MODULE_PARM_DESC(ip_list_uid,"owner of /proc/net/ipt_recent/* files");
-MODULE_PARM_DESC(ip_list_gid,"owning group of /proc/net/ipt_recent/* f=
iles");
+MODULE_PARM_DESC(ip_list_perms, "permissions on /proc/net/xt_recent/* =
files");
+MODULE_PARM_DESC(ip_list_uid,"owner of /proc/net/xt_recent/* files");
+MODULE_PARM_DESC(ip_list_gid,"owning group of /proc/net/xt_recent/* fi=
les");
=20
 struct recent_entry {
 	struct list_head	list;
 	struct list_head	lru_list;
-	__be32			addr;
+	union nf_inet_addr	addr;
+	u_int16_t		family;
 	u_int8_t		ttl;
 	u_int8_t		index;
 	u_int16_t		nstamps;
@@ -67,7 +73,7 @@ struct recent_table {
 	struct list_head	list;
 	char			name[XT_RECENT_NAME_LEN];
 #ifdef CONFIG_PROC_FS
-	struct proc_dir_entry	*proc;
+	struct proc_dir_entry	*proc_old, *proc;
 #endif
 	unsigned int		refcnt;
 	unsigned int		entries;
@@ -80,31 +86,50 @@ static DEFINE_SPINLOCK(recent_lock);
 static DEFINE_MUTEX(recent_mutex);
=20
 #ifdef CONFIG_PROC_FS
-static struct proc_dir_entry	*proc_dir;
-static const struct file_operations	recent_fops;
+static struct proc_dir_entry *proc_old_dir, *recent_proc_dir;
+static const struct file_operations recent_old_fops, recent_mt_fops;
 #endif
=20
 static u_int32_t hash_rnd;
-static int hash_rnd_initted;
+static bool hash_rnd_initted;
=20
-static unsigned int recent_entry_hash(__be32 addr)
+static unsigned int recent_entry_hash4(const union nf_inet_addr *addr)
 {
 	if (!hash_rnd_initted) {
-		get_random_bytes(&hash_rnd, 4);
-		hash_rnd_initted =3D 1;
+		get_random_bytes(&hash_rnd, sizeof(hash_rnd));
+		hash_rnd_initted =3D true;
 	}
-	return jhash_1word((__force u32)addr, hash_rnd) & (ip_list_hash_size =
- 1);
+	return jhash_1word((__force u32)addr->ip, hash_rnd) &
+	       (ip_list_hash_size - 1);
+}
+
+static unsigned int recent_entry_hash6(const union nf_inet_addr *addr)
+{
+	if (!hash_rnd_initted) {
+		get_random_bytes(&hash_rnd, sizeof(hash_rnd));
+		hash_rnd_initted =3D true;
+	}
+	return jhash2((u32 *)addr->ip6, ARRAY_SIZE(addr->ip6), hash_rnd) &
+	       (ip_list_hash_size - 1);
 }
=20
 static struct recent_entry *
-recent_entry_lookup(const struct recent_table *table, __be32 addr, u_i=
nt8_t ttl)
+recent_entry_lookup(const struct recent_table *table,
+		    const union nf_inet_addr *addrp, u_int16_t family,
+		    u_int8_t ttl)
 {
 	struct recent_entry *e;
 	unsigned int h;
=20
-	h =3D recent_entry_hash(addr);
+	if (family =3D=3D AF_INET)
+		h =3D recent_entry_hash4(addrp);
+	else
+		h =3D recent_entry_hash6(addrp);
+
 	list_for_each_entry(e, &table->iphash[h], list)
-		if (e->addr =3D=3D addr && (ttl =3D=3D e->ttl || !ttl || !e->ttl))
+		if (e->family =3D=3D family &&
+		    memcmp(&e->addr, addrp, sizeof(e->addr)) =3D=3D 0 &&
+		    (ttl =3D=3D e->ttl || ttl =3D=3D 0 || e->ttl =3D=3D 0))
 			return e;
 	return NULL;
 }
@@ -118,7 +143,8 @@ static void recent_entry_remove(struct recent_table=
 *t, struct recent_entry *e)
 }
=20
 static struct recent_entry *
-recent_entry_init(struct recent_table *t, __be32 addr, u_int8_t ttl)
+recent_entry_init(struct recent_table *t, const union nf_inet_addr *ad=
dr,
+		  u_int16_t family, u_int8_t ttl)
 {
 	struct recent_entry *e;
=20
@@ -130,12 +156,16 @@ recent_entry_init(struct recent_table *t, __be32 =
addr, u_int8_t ttl)
 		    GFP_ATOMIC);
 	if (e =3D=3D NULL)
 		return NULL;
-	e->addr      =3D addr;
+	memcpy(&e->addr, addr, sizeof(e->addr));
 	e->ttl       =3D ttl;
 	e->stamps[0] =3D jiffies;
 	e->nstamps   =3D 1;
 	e->index     =3D 1;
-	list_add_tail(&e->list, &t->iphash[recent_entry_hash(addr)]);
+	e->family    =3D family;
+	if (family =3D=3D AF_INET)
+		list_add_tail(&e->list, &t->iphash[recent_entry_hash4(addr)]);
+	else
+		list_add_tail(&e->list, &t->iphash[recent_entry_hash6(addr)]);
 	list_add_tail(&e->lru_list, &t->lru_list);
 	t->entries++;
 	return e;
@@ -179,28 +209,42 @@ recent_mt(const struct sk_buff *skb, const struct=
 net_device *in,
 	const struct xt_recent_mtinfo *info =3D matchinfo;
 	struct recent_table *t;
 	struct recent_entry *e;
-	__be32 addr;
+	union nf_inet_addr addr =3D {};
 	u_int8_t ttl;
 	bool ret =3D info->invert;
=20
-	if (info->side =3D=3D XT_RECENT_DEST)
-		addr =3D ip_hdr(skb)->daddr;
-	else
-		addr =3D ip_hdr(skb)->saddr;
+	if (match->family =3D=3D AF_INET) {
+		const struct iphdr *iph =3D ip_hdr(skb);
+
+		if (info->side =3D=3D XT_RECENT_DEST)
+			addr.ip =3D iph->daddr;
+		else
+			addr.ip =3D iph->saddr;
+
+		ttl =3D iph->ttl;
+	} else {
+		const struct ipv6hdr *iph =3D ipv6_hdr(skb);
+
+		if (info->side =3D=3D XT_RECENT_DEST)
+			memcpy(&addr.in6, &iph->daddr, sizeof(addr.in6));
+		else
+			memcpy(&addr.in6, &iph->saddr, sizeof(addr.in6));
+
+		ttl =3D iph->hop_limit;
+	}
=20
-	ttl =3D ip_hdr(skb)->ttl;
 	/* use TTL as seen before forwarding */
 	if (out && !skb->sk)
 		ttl++;
=20
 	spin_lock_bh(&recent_lock);
 	t =3D recent_table_lookup(info->name);
-	e =3D recent_entry_lookup(t, addr,
-				info->check_set & XT_RECENT_TTL ? ttl : 0);
+	e =3D recent_entry_lookup(t, &addr, match->family,
+				(info->check_set & XT_RECENT_TTL) ? ttl : 0);
 	if (e =3D=3D NULL) {
 		if (!(info->check_set & XT_RECENT_SET))
 			goto out;
-		e =3D recent_entry_init(t, addr, ttl);
+		e =3D recent_entry_init(t, &addr, match->family, ttl);
 		if (e =3D=3D NULL)
 			*hotdrop =3D true;
 		ret =3D !ret;
@@ -277,11 +321,22 @@ recent_mt_check(const char *tablename, const void=
 *ip,
 	for (i =3D 0; i < ip_list_hash_size; i++)
 		INIT_LIST_HEAD(&t->iphash[i]);
 #ifdef CONFIG_PROC_FS
-	t->proc =3D proc_create(t->name, ip_list_perms, proc_dir, &recent_fop=
s);
+	t->proc =3D proc_create(t->name, ip_list_perms, recent_proc_dir,
+		  &recent_mt_fops);
 	if (t->proc =3D=3D NULL) {
 		kfree(t);
 		goto out;
 	}
+	t->proc_old =3D proc_create(t->name, ip_list_perms, proc_old_dir,
+		      &recent_old_fops);
+	if (t->proc_old =3D=3D NULL) {
+		remove_proc_entry(t->name, proc_old_dir);
+		kfree(t);
+		goto out;
+	}
+	t->proc_old->uid   =3D ip_list_uid;
+	t->proc_old->gid   =3D ip_list_gid;
+	t->proc_old->data  =3D t;
 	t->proc->uid       =3D ip_list_uid;
 	t->proc->gid       =3D ip_list_gid;
 	t->proc->data      =3D t;
@@ -308,7 +363,8 @@ static void recent_mt_destroy(const struct xt_match=
 *match, void *matchinfo)
 		spin_unlock_bh(&recent_lock);
 		recent_table_flush(t);
 #ifdef CONFIG_PROC_FS
-		remove_proc_entry(t->name, proc_dir);
+		remove_proc_entry(t->name, proc_old_dir);
+		remove_proc_entry(t->name, recent_proc_dir);
 #endif
 		kfree(t);
 	}
@@ -317,7 +373,7 @@ static void recent_mt_destroy(const struct xt_match=
 *match, void *matchinfo)
=20
 #ifdef CONFIG_PROC_FS
 struct recent_iter_state {
-	struct recent_table	*table;
+	const struct recent_table *table;
 	unsigned int		bucket;
 };
=20
@@ -342,8 +398,8 @@ static void *recent_seq_next(struct seq_file *seq, =
void *v, loff_t *pos)
 {
 	struct recent_iter_state *st =3D seq->private;
 	const struct recent_table *t =3D st->table;
-	struct recent_entry *e =3D v;
-	struct list_head *head =3D e->list.next;
+	const struct recent_entry *e =3D v;
+	const struct list_head *head =3D e->list.next;
=20
 	while (head =3D=3D &t->iphash[st->bucket]) {
 		if (++st->bucket >=3D ip_list_hash_size)
@@ -366,8 +422,14 @@ static int recent_seq_show(struct seq_file *seq, v=
oid *v)
 	unsigned int i;
=20
 	i =3D (e->index - 1) % ip_pkt_list_tot;
-	seq_printf(seq, "src=3D%u.%u.%u.%u ttl: %u last_seen: %lu oldest_pkt:=
 %u",
-		   NIPQUAD(e->addr), e->ttl, e->stamps[i], e->index);
+	if (e->family =3D=3D AF_INET)
+		seq_printf(seq, "src=3D" NIPQUAD_FMT " ttl: %u last_seen: %lu "
+			   "oldest_pkt: %u", NIPQUAD(e->addr.ip), e->ttl,
+			   e->stamps[i], e->index);
+	else
+		seq_printf(seq, "src=3D" NIP6_FMT " ttl: %u last_seen: %lu "
+			   "oldest_pkt: %u", NIP6(e->addr.in6), e->ttl,
+			   e->stamps[i], e->index);
 	for (i =3D 0; i < e->nstamps; i++)
 		seq_printf(seq, "%s %lu", i ? "," : "", e->stamps[i]);
 	seq_printf(seq, "\n");
@@ -394,8 +456,21 @@ static int recent_seq_open(struct inode *inode, st=
ruct file *file)
 	return 0;
 }
=20
-static ssize_t recent_proc_write(struct file *file, const char __user =
*input,
-				 size_t size, loff_t *loff)
+static int recent_old_seq_open(struct inode *inode, struct file *filp)
+{
+	static bool warned_of_old;
+
+	if (unlikely(!warned_of_old)) {
+		printk(KERN_INFO KBUILD_MODNAME ": Use of /proc/net/ipt_recent"
+		       " is deprecated; use /proc/net/xt_recent.\n");
+		warned_of_old =3D true;
+	}
+	return recent_seq_open(inode, filp);
+}
+
+static ssize_t recent_old_proc_write(struct file *file,
+				     const char __user *input,
+				     size_t size, loff_t *loff)
 {
 	const struct proc_dir_entry *pde =3D PDE(file->f_path.dentry->d_inode=
);
 	struct recent_table *t =3D pde->data;
@@ -408,6 +483,7 @@ static ssize_t recent_proc_write(struct file *file,=
 const char __user *input,
 		size =3D sizeof(buf);
 	if (copy_from_user(buf, input, size))
 		return -EFAULT;
+
 	while (isspace(*c))
 		c++;
=20
@@ -435,10 +511,10 @@ static ssize_t recent_proc_write(struct file *fil=
e, const char __user *input,
 	addr =3D in_aton(c);
=20
 	spin_lock_bh(&recent_lock);
-	e =3D recent_entry_lookup(t, addr, 0);
+	e =3D recent_entry_lookup(t, (const void *)&addr, PF_INET, 0);
 	if (e =3D=3D NULL) {
 		if (add)
-			recent_entry_init(t, addr, 0);
+			recent_entry_init(t, (const void *)&addr, PF_INET, 0);
 	} else {
 		if (add)
 			recent_entry_update(t, e);
@@ -449,23 +525,117 @@ static ssize_t recent_proc_write(struct file *fi=
le, const char __user *input,
 	return size;
 }
=20
-static const struct file_operations recent_fops =3D {
-	.open		=3D recent_seq_open,
+static const struct file_operations recent_old_fops =3D {
+	.open		=3D recent_old_seq_open,
 	.read		=3D seq_read,
-	.write		=3D recent_proc_write,
+	.write		=3D recent_old_proc_write,
 	.release	=3D seq_release_private,
 	.owner		=3D THIS_MODULE,
 };
+
+static ssize_t
+recent_mt_proc_write(struct file *file, const char __user *input,
+		     size_t size, loff_t *loff)
+{
+	const struct proc_dir_entry *pde =3D PDE(file->f_path.dentry->d_inode=
);
+	struct recent_table *t =3D pde->data;
+	struct recent_entry *e;
+	char buf[sizeof("+b335:1d35:1e55:dead:c0de:1715:5afe:c0de")];
+	const char *c =3D buf;
+	union nf_inet_addr addr;
+	u_int16_t family;
+	bool add, succ;
+
+	if (size =3D=3D 0)
+		return 0;
+	if (size > sizeof(buf))
+		size =3D sizeof(buf);
+	if (copy_from_user(buf, input, size) !=3D 0)
+		return -EFAULT;
+
+	/* Strict protocol! */
+	if (*loff !=3D 0)
+		return -ESPIPE;
+	switch (*c) {
+	case '/': /* flush table */
+		spin_lock_bh(&recent_lock);
+		recent_table_flush(t);
+		spin_unlock_bh(&recent_lock);
+		return size;
+	case '-': /* remove address */
+		add =3D false;
+		break;
+	case '+': /* add address */
+		add =3D true;
+		break;
+	default:
+		printk(KERN_INFO KBUILD_MODNAME ": Need +ip, -ip or /\n");
+		return -EINVAL;
+	}
+
+	++c;
+	--size;
+	if (strnchr(c, size, ':') !=3D NULL) {
+		family =3D AF_INET6;
+		succ   =3D in6_pton(c, size, (void *)&addr, '\n', NULL);
+	} else {
+		family =3D AF_INET;
+		succ   =3D in4_pton(c, size, (void *)&addr, '\n', NULL);
+	}
+
+	if (!succ) {
+		printk(KERN_INFO KBUILD_MODNAME ": illegal address written "
+		       "to procfs\n");
+		return -EINVAL;
+	}
+
+	spin_lock_bh(&recent_lock);
+	e =3D recent_entry_lookup(t, &addr, family, 0);
+	if (e =3D=3D NULL) {
+		if (add)
+			recent_entry_init(t, &addr, family, 0);
+	} else {
+		if (add)
+			recent_entry_update(t, e);
+		else
+			recent_entry_remove(t, e);
+	}
+	spin_unlock_bh(&recent_lock);
+	/* Note we removed one above */
+	*loff +=3D size + 1;
+	return size + 1;
+}
+
+static const struct file_operations recent_mt_fops =3D {
+	.open    =3D recent_seq_open,
+	.read    =3D seq_read,
+	.write   =3D recent_mt_proc_write,
+	.release =3D seq_release_private,
+	.owner   =3D THIS_MODULE,
+};
 #endif /* CONFIG_PROC_FS */
=20
-static struct xt_match recent_mt_reg __read_mostly =3D {
-	.name		=3D "recent",
-	.family		=3D AF_INET,
-	.match		=3D recent_mt,
-	.matchsize	=3D sizeof(struct xt_recent_mtinfo),
-	.checkentry	=3D recent_mt_check,
-	.destroy	=3D recent_mt_destroy,
-	.me		=3D THIS_MODULE,
+static struct xt_match recent_mt_reg[] __read_mostly =3D {
+	{
+		.name       =3D "recent",
+		.revision   =3D 0,
+		.family     =3D AF_INET,
+		.match      =3D recent_mt,
+		.matchsize  =3D sizeof(struct xt_recent_mtinfo),
+		.checkentry =3D recent_mt_check,
+		.destroy    =3D recent_mt_destroy,
+		.me         =3D THIS_MODULE,
+	},
+	{
+		.name       =3D "recent",
+		.revision   =3D 0,
+		.family     =3D AF_INET6,
+		.match      =3D recent_mt,
+		.matchsize  =3D sizeof(struct xt_recent_mtinfo),
+		.checkentry =3D recent_mt_check,
+		.destroy    =3D recent_mt_destroy,
+		.me         =3D THIS_MODULE,
+	},
 };
=20
 static int __init recent_mt_init(void)
@@ -476,13 +646,21 @@ static int __init recent_mt_init(void)
 		return -EINVAL;
 	ip_list_hash_size =3D 1 << fls(ip_list_tot);
=20
-	err =3D xt_register_match(&recent_mt_reg);
+	err =3D xt_register_matches(recent_mt_reg, ARRAY_SIZE(recent_mt_reg))=
;
 #ifdef CONFIG_PROC_FS
 	if (err)
 		return err;
-	proc_dir =3D proc_mkdir("ipt_recent", init_net.proc_net);
-	if (proc_dir =3D=3D NULL) {
-		xt_unregister_match(&recent_mt_reg);
+	recent_proc_dir =3D proc_mkdir("xt_recent", init_net.proc_net);
+	if (recent_proc_dir =3D=3D NULL) {
+		xt_unregister_matches(recent_mt_reg, ARRAY_SIZE(recent_mt_reg));
+		err =3D -ENOMEM;
+	}
+	if (err < 0)
+		return err;
+	proc_old_dir =3D proc_mkdir("ipt_recent", init_net.proc_net);
+	if (proc_old_dir =3D=3D NULL) {
+		remove_proc_entry("xt_recent", init_net.proc_net);
+		xt_unregister_matches(recent_mt_reg, ARRAY_SIZE(recent_mt_reg));
 		err =3D -ENOMEM;
 	}
 #endif
@@ -492,9 +670,10 @@ static int __init recent_mt_init(void)
 static void __exit recent_mt_exit(void)
 {
 	BUG_ON(!list_empty(&tables));
-	xt_unregister_match(&recent_mt_reg);
+	xt_unregister_matches(recent_mt_reg, ARRAY_SIZE(recent_mt_reg));
 #ifdef CONFIG_PROC_FS
 	remove_proc_entry("ipt_recent", init_net.proc_net);
+	remove_proc_entry("xt_recent", init_net.proc_net);
 #endif
 }
=20
--=20
1.5.5

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
