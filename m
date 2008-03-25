From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: commit 720350a38b1dbd43c907d5d81decd6edd6725d81
Date: Tue, 25 Mar 2008 19:06:20 +0100
Message-ID: <1206468391-368-18-git-send-email-jengelh@computergmbh.de>
References: <alpine.LNX.1.10.0803251903230.31276@fbirervta.pbzchgretzou.qr>
 <1206468391-368-1-git-send-email-jengelh@computergmbh.de>
 <1206468391-368-2-git-send-email-jengelh@computergmbh.de>
 <1206468391-368-3-git-send-email-jengelh@computergmbh.de>
 <1206468391-368-4-git-send-email-jengelh@computergmbh.de>
 <1206468391-368-5-git-send-email-jengelh@computergmbh.de>
 <1206468391-368-6-git-send-email-jengelh@computergmbh.de>
 <1206468391-368-7-git-send-email-jengelh@computergmbh.de>
 <1206468391-368-8-git-send-email-jengelh@computergmbh.de>
 <1206468391-368-9-git-send-email-jengelh@computergmbh.de>
 <1206468391-368-10-git-send-email-jengelh@computergmbh.de>
 <1206468391-368-11-git-send-email-jengelh@computergmbh.de>
 <1206468391-368-12-git-send-email-jengelh@computergmbh.de>
 <1206468391-368-13-git-send-email-jengelh@computergmbh.de>
 <1206468391-368-14-git-send-email-jengelh@computergmbh.de>
 <1206468391-368-15-git-send-email-jengelh@computergmbh.de>
 <1206468391-368-16-git-send-email-jengelh@computergmbh.de>
 <1206468391-368-17-git-send-email-jengelh@computergmbh.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:52541 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759219AbYCYSGh (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 25 Mar 2008 14:06:37 -0400
In-Reply-To: <1206468391-368-17-git-send-email-jengelh@computergmbh.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

    [NETFILTER]: xt_recent: IPv6 support
   =20
    This updates xt_recent to support IPv6 handling. It is sort of a fl=
ag
    day, as the new control directory is /proc/net/xt_recent with a new=
,
    more strict protocol (the string you ought to write into
    /proc/net/xt_recent/LIST). But on the other hand, I kept the binary
    interface towards iptables (which is quite memory consuming I must
    say) to keep the patch small.
   =20
    Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
---
 net/netfilter/xt_recent.c |  207 +++++++++++++++++++++++++------------
 1 files changed, 143 insertions(+), 64 deletions(-)

diff --git a/net/netfilter/xt_recent.c b/net/netfilter/xt_recent.c
index cc5472d..a614b34 100644
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
@@ -87,24 +93,43 @@ static const struct file_operations	recent_fops;
 static u_int32_t hash_rnd;
 static int hash_rnd_initted;
=20
-static unsigned int recent_entry_hash(__be32 addr)
+static unsigned int recent_entry_hash4(const union nf_inet_addr *addr)
 {
 	if (!hash_rnd_initted) {
-		get_random_bytes(&hash_rnd, 4);
+		get_random_bytes(&hash_rnd, sizeof(hash_rnd));
 		hash_rnd_initted =3D 1;
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
+		hash_rnd_initted =3D 1;
+	}
+	return jhash2((u32 *)addr->ip6, ARRAY_SIZE(addr->ip6), hash_rnd) &
+	       (ip_list_hash_size - 1);
 }
=20
 static struct recent_entry *
-recent_entry_lookup(const struct recent_table *table, __be32 addr, u_i=
nt8_t ttl)
+recent_entry_lookup(const struct recent_table *table,
+                    const union nf_inet_addr *addrp, u_int16_t family,
+                    u_int8_t ttl)
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
+                  u_int16_t family, u_int8_t ttl)
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
+	union nf_inet_addr addr;
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
+	e =3D recent_entry_lookup(t, &addr, match->family,
 				info->check_set & XT_RECENT_TTL ? ttl : 0);
 	if (e =3D=3D NULL) {
 		if (!(info->check_set & XT_RECENT_SET))
 			goto out;
-		e =3D recent_entry_init(t, addr, ttl);
+		e =3D recent_entry_init(t, &addr, match->family, ttl);
 		if (e =3D=3D NULL)
 			*hotdrop =3D true;
 		ret =3D !ret;
@@ -318,7 +362,7 @@ static void recent_mt_destroy(const struct xt_match=
 *match, void *matchinfo)
=20
 #ifdef CONFIG_PROC_FS
 struct recent_iter_state {
-	struct recent_table	*table;
+	const struct recent_table *table;
 	unsigned int		bucket;
 };
=20
@@ -343,8 +387,8 @@ static void *recent_seq_next(struct seq_file *seq, =
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
@@ -367,8 +411,14 @@ static int recent_seq_show(struct seq_file *seq, v=
oid *v)
 	unsigned int i;
=20
 	i =3D (e->index - 1) % ip_pkt_list_tot;
-	seq_printf(seq, "src=3D%u.%u.%u.%u ttl: %u last_seen: %lu oldest_pkt:=
 %u",
-		   NIPQUAD(e->addr), e->ttl, e->stamps[i], e->index);
+	if (e->family =3D=3D AF_INET)
+		seq_printf(seq, "src=3D" NIPQUAD_FMT " ttl: %u last_seen: %lu "
+		           "oldest_pkt: %u", NIPQUAD(e->addr.ip), e->ttl,
+			   e->stamps[i], e->index);
+	else
+		seq_printf(seq, "src=3D" NIP6_FMT " ttl: %u last_seen: %lu "
+		           "oldest_pkt: %u", NIP6(e->addr.in6), e->ttl,
+		           e->stamps[i], e->index);
 	for (i =3D 0; i < e->nstamps; i++)
 		seq_printf(seq, "%s %lu", i ? "," : "", e->stamps[i]);
 	seq_printf(seq, "\n");
@@ -401,45 +451,59 @@ static ssize_t recent_proc_write(struct file *fil=
e, const char __user *input,
 	const struct proc_dir_entry *pde =3D PDE(file->f_path.dentry->d_inode=
);
 	struct recent_table *t =3D pde->data;
 	struct recent_entry *e;
-	char buf[sizeof("+255.255.255.255")], *c =3D buf;
-	__be32 addr;
-	int add;
+	char buf[sizeof("+b335:1d35:1e55:dead:c0de:1715:5afe:c0de")], *c =3D =
buf;
+	union nf_inet_addr addr;
+	u_int16_t family;
+	bool add, succ;
=20
+	if (size =3D=3D 0)
+		return 0;
 	if (size > sizeof(buf))
 		size =3D sizeof(buf);
-	if (copy_from_user(buf, input, size))
+	if (copy_from_user(buf, input, size) !=3D 0)
 		return -EFAULT;
-	while (isspace(*c))
-		c++;
=20
-	if (size - (c - buf) < 5)
-		return c - buf;
-	if (!strncmp(c, "clear", 5)) {
-		c +=3D 5;
+	/* Strict protocol! */
+	if (*loff !=3D 0)
+		return -ESPIPE;
+	switch (*c) {
+	case '/': /* flush table */
 		spin_lock_bh(&recent_lock);
 		recent_table_flush(t);
 		spin_unlock_bh(&recent_lock);
-		return c - buf;
-	}
-
-	switch (*c) {
-	case '-':
-		add =3D 0;
-		c++;
+		return size;
+	case '-': /* remove address */
+		add =3D false;
 		break;
-	case '+':
-		c++;
-	default:
-		add =3D 1;
+	case '+': /* add address */
+		add =3D true;
 		break;
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
 	}
-	addr =3D in_aton(c);
=20
 	spin_lock_bh(&recent_lock);
-	e =3D recent_entry_lookup(t, addr, 0);
+	e =3D recent_entry_lookup(t, &addr, family, 0);
 	if (e =3D=3D NULL) {
 		if (add)
-			recent_entry_init(t, addr, 0);
+			recent_entry_init(t, &addr, family, 0);
 	} else {
 		if (add)
 			recent_entry_update(t, e);
@@ -447,7 +511,9 @@ static ssize_t recent_proc_write(struct file *file,=
 const char __user *input,
 			recent_entry_remove(t, e);
 	}
 	spin_unlock_bh(&recent_lock);
-	return size;
+	/* Note we removed one above */
+	*loff +=3D size + 1;
+	return size + 1;
 }
=20
 static const struct file_operations recent_fops =3D {
@@ -459,14 +525,27 @@ static const struct file_operations recent_fops =3D=
 {
 };
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
@@ -477,13 +556,13 @@ static int __init recent_mt_init(void)
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
+	proc_dir =3D proc_mkdir("xt_recent", init_net.proc_net);
 	if (proc_dir =3D=3D NULL) {
-		xt_unregister_match(&recent_mt_reg);
+		xt_unregister_matches(recent_mt_reg, ARRAY_SIZE(recent_mt_reg));
 		err =3D -ENOMEM;
 	}
 #endif
@@ -493,9 +572,9 @@ static int __init recent_mt_init(void)
 static void __exit recent_mt_exit(void)
 {
 	BUG_ON(!list_empty(&tables));
-	xt_unregister_match(&recent_mt_reg);
+	xt_unregister_matches(recent_mt_reg, ARRAY_SIZE(recent_mt_reg));
 #ifdef CONFIG_PROC_FS
-	remove_proc_entry("ipt_recent", init_net.proc_net);
+	remove_proc_entry("xt_recent", init_net.proc_net);
 #endif
 }
=20
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
