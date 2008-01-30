From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 52/69]: xt_hashlimit match, revision 1
Date: Wed, 30 Jan 2008 21:18:14 +0100 (MET)
Message-ID: <20080130201811.29874.12657.sendpatchset@localhost.localdomain>
References: <20080130201650.29874.7456.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:60794 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933478AbYA3UST (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Jan 2008 15:18:19 -0500
In-Reply-To: <20080130201650.29874.7456.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: xt_hashlimit match, revision 1

Introduces the xt_hashlimit match revision 1. It adds support for
kernel-level inversion and grouping source and/or destination IP
addresses, allowing to limit on a per-subnet basis. While this would
technically obsolete xt_limit, xt_hashlimit is a more expensive due
to the hashbucketing.

Kernel-level inversion: Previously you had to do user-level inversion:

	iptables -N foo
	iptables -A foo -m hashlimit --hashlimit(-upto) 5/s -j RETURN
	iptables -A foo -j DROP
	iptables -A INPUT -j foo

now it is simpler:

	iptables -A INPUT -m hashlimit --hashlimit-over 5/s -j DROP

Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 778b1b410be9abb98c52ea4288c9708b2f01a626
tree c0eaf40a59ba93a507d93f3f0290ef887551b9b9
parent 589cbc737eef0c619fc75c099063861ec7540ec7
author Jan Engelhardt <jengelh@computergmbh.de> Tue, 29 Jan 2008 16:22:=
18 +0100
committer Patrick McHardy <kaber@trash.net> Wed, 30 Jan 2008 21:03:12 +=
0100

 include/linux/netfilter/xt_hashlimit.h |   37 +++-
 net/netfilter/xt_hashlimit.c           |  322 ++++++++++++++++++++++++=
++++----
 2 files changed, 318 insertions(+), 41 deletions(-)

diff --git a/include/linux/netfilter/xt_hashlimit.h b/include/linux/net=
filter/xt_hashlimit.h
index c19972e..58b818e 100644
--- a/include/linux/netfilter/xt_hashlimit.h
+++ b/include/linux/netfilter/xt_hashlimit.h
@@ -9,13 +9,16 @@
 /* details of this structure hidden by the implementation */
 struct xt_hashlimit_htable;
=20
-#define XT_HASHLIMIT_HASH_DIP	0x0001
-#define XT_HASHLIMIT_HASH_DPT	0x0002
-#define XT_HASHLIMIT_HASH_SIP	0x0004
-#define XT_HASHLIMIT_HASH_SPT	0x0008
+enum {
+	XT_HASHLIMIT_HASH_DIP =3D 1 << 0,
+	XT_HASHLIMIT_HASH_DPT =3D 1 << 1,
+	XT_HASHLIMIT_HASH_SIP =3D 1 << 2,
+	XT_HASHLIMIT_HASH_SPT =3D 1 << 3,
+	XT_HASHLIMIT_INVERT   =3D 1 << 4,
+};
=20
 struct hashlimit_cfg {
-	u_int32_t mode;	  /* bitmask of IPT_HASHLIMIT_HASH_* */
+	u_int32_t mode;	  /* bitmask of XT_HASHLIMIT_HASH_* */
 	u_int32_t avg;    /* Average secs between packets * scale */
 	u_int32_t burst;  /* Period multiplier for upper limit. */
=20
@@ -37,4 +40,28 @@ struct xt_hashlimit_info {
 		struct xt_hashlimit_info *master;
 	} u;
 };
+
+struct hashlimit_cfg1 {
+	u_int32_t mode;	  /* bitmask of XT_HASHLIMIT_HASH_* */
+	u_int32_t avg;    /* Average secs between packets * scale */
+	u_int32_t burst;  /* Period multiplier for upper limit. */
+
+	/* user specified */
+	u_int32_t size;		/* how many buckets */
+	u_int32_t max;		/* max number of entries */
+	u_int32_t gc_interval;	/* gc interval */
+	u_int32_t expire;	/* when do entries expire? */
+
+	u_int8_t srcmask, dstmask;
+};
+
+struct xt_hashlimit_mtinfo1 {
+	char name[IFNAMSIZ];
+	struct hashlimit_cfg1 cfg;
+
+	/* Used internally by the kernel */
+	struct xt_hashlimit_htable *hinfo __attribute__((aligned(8)));
+	struct xt_hashlimit_mtinfo1 *master __attribute__((aligned(8)));
+};
+
 #endif /*_XT_HASHLIMIT_H*/
diff --git a/net/netfilter/xt_hashlimit.c b/net/netfilter/xt_hashlimit.=
c
index b224b8f..54aaf5b 100644
--- a/net/netfilter/xt_hashlimit.c
+++ b/net/netfilter/xt_hashlimit.c
@@ -1,9 +1,9 @@
-/* iptables match extension to limit the number of packets per second
- * seperately for each hashbucket (sourceip/sourceport/dstip/dstport)
+/*
+ *	xt_hashlimit - Netfilter module to limit the number of packets per =
time
+ *	seperately for each hashbucket (sourceip/sourceport/dstip/dstport)
  *
- * (C) 2003-2004 by Harald Welte <laforge@netfilter.org>
- *
- * $Id: ipt_hashlimit.c 3244 2004-10-20 16:24:29Z laforge@netfilter.or=
g $
+ *	(C) 2003-2004 by Harald Welte <laforge@netfilter.org>
+ *	Copyright =C2=A9 CC Computer Consultants GmbH, 2007 - 2008
  *
  * Development of this code was funded by Astaro AG, http://www.astaro=
=2Ecom/
  */
@@ -35,6 +35,7 @@
=20
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Harald Welte <laforge@netfilter.org>");
+MODULE_AUTHOR("Jan Engelhardt <jengelh@computergmbh.de>");
 MODULE_DESCRIPTION("Xtables: per hash-bucket rate-limit match");
 MODULE_ALIAS("ipt_hashlimit");
 MODULE_ALIAS("ip6t_hashlimit");
@@ -57,7 +58,7 @@ struct dsthash_dst {
 			__be32 dst[4];
 		} ip6;
 #endif
-	} addr;
+	};
 	__be16 src_port;
 	__be16 dst_port;
 };
@@ -81,7 +82,7 @@ struct xt_hashlimit_htable {
 	atomic_t use;
 	int family;
=20
-	struct hashlimit_cfg cfg;	/* config */
+	struct hashlimit_cfg1 cfg;	/* config */
=20
 	/* used internally */
 	spinlock_t lock;		/* lock for list_head */
@@ -184,7 +185,7 @@ dsthash_free(struct xt_hashlimit_htable *ht, struct=
 dsthash_ent *ent)
 }
 static void htable_gc(unsigned long htlong);
=20
-static int htable_create(struct xt_hashlimit_info *minfo, int family)
+static int htable_create_v0(struct xt_hashlimit_info *minfo, int famil=
y)
 {
 	struct xt_hashlimit_htable *hinfo;
 	unsigned int size;
@@ -210,7 +211,18 @@ static int htable_create(struct xt_hashlimit_info =
*minfo, int family)
 	minfo->hinfo =3D hinfo;
=20
 	/* copy match config into hashtable config */
-	memcpy(&hinfo->cfg, &minfo->cfg, sizeof(hinfo->cfg));
+	hinfo->cfg.mode        =3D minfo->cfg.mode;
+	hinfo->cfg.avg         =3D minfo->cfg.avg;
+	hinfo->cfg.burst       =3D minfo->cfg.burst;
+	hinfo->cfg.max         =3D minfo->cfg.max;
+	hinfo->cfg.gc_interval =3D minfo->cfg.gc_interval;
+	hinfo->cfg.expire      =3D minfo->cfg.expire;
+
+	if (family =3D=3D AF_INET)
+		hinfo->cfg.srcmask =3D hinfo->cfg.dstmask =3D 32;
+	else
+		hinfo->cfg.srcmask =3D hinfo->cfg.dstmask =3D 128;
+
 	hinfo->cfg.size =3D size;
 	if (!hinfo->cfg.max)
 		hinfo->cfg.max =3D 8 * hinfo->cfg.size;
@@ -246,6 +258,70 @@ static int htable_create(struct xt_hashlimit_info =
*minfo, int family)
 	return 0;
 }
=20
+static int htable_create(struct xt_hashlimit_mtinfo1 *minfo,
+                         unsigned int family)
+{
+	struct xt_hashlimit_htable *hinfo;
+	unsigned int size;
+	unsigned int i;
+
+	if (minfo->cfg.size) {
+		size =3D minfo->cfg.size;
+	} else {
+		size =3D (num_physpages << PAGE_SHIFT) / 16384 /
+		       sizeof(struct list_head);
+		if (num_physpages > 1024 * 1024 * 1024 / PAGE_SIZE)
+			size =3D 8192;
+		if (size < 16)
+			size =3D 16;
+	}
+	/* FIXME: don't use vmalloc() here or anywhere else -HW */
+	hinfo =3D vmalloc(sizeof(struct xt_hashlimit_htable) +
+	                sizeof(struct list_head) * size);
+	if (hinfo =3D=3D NULL) {
+		printk(KERN_ERR "xt_hashlimit: unable to create hashtable\n");
+		return -1;
+	}
+	minfo->hinfo =3D hinfo;
+
+	/* copy match config into hashtable config */
+	memcpy(&hinfo->cfg, &minfo->cfg, sizeof(hinfo->cfg));
+	hinfo->cfg.size =3D size;
+	if (hinfo->cfg.max =3D=3D 0)
+		hinfo->cfg.max =3D 8 * hinfo->cfg.size;
+	else if (hinfo->cfg.max < hinfo->cfg.size)
+		hinfo->cfg.max =3D hinfo->cfg.size;
+
+	for (i =3D 0; i < hinfo->cfg.size; i++)
+		INIT_HLIST_HEAD(&hinfo->hash[i]);
+
+	atomic_set(&hinfo->use, 1);
+	hinfo->count =3D 0;
+	hinfo->family =3D family;
+	hinfo->rnd_initialized =3D 0;
+	spin_lock_init(&hinfo->lock);
+
+	hinfo->pde =3D create_proc_entry(minfo->name, 0,
+				       family =3D=3D AF_INET ? hashlimit_procdir4 :
+							   hashlimit_procdir6);
+	if (hinfo->pde =3D=3D NULL) {
+		vfree(hinfo);
+		return -1;
+	}
+	hinfo->pde->proc_fops =3D &dl_file_ops;
+	hinfo->pde->data =3D hinfo;
+
+	setup_timer(&hinfo->timer, htable_gc, (unsigned long)hinfo);
+	hinfo->timer.expires =3D jiffies + msecs_to_jiffies(hinfo->cfg.gc_int=
erval);
+	add_timer(&hinfo->timer);
+
+	spin_lock_bh(&hashlimit_lock);
+	hlist_add_head(&hinfo->node, &hashlimit_htables);
+	spin_unlock_bh(&hashlimit_lock);
+
+	return 0;
+}
+
 static bool select_all(const struct xt_hashlimit_htable *ht,
 		       const struct dsthash_ent *he)
 {
@@ -388,6 +464,46 @@ static inline void rateinfo_recalc(struct dsthash_=
ent *dh, unsigned long now)
 	dh->rateinfo.prev =3D now;
 }
=20
+static inline __be32 maskl(__be32 a, unsigned int l)
+{
+	return htonl(ntohl(a) & ~(~(u_int32_t)0 >> l));
+}
+
+static void hashlimit_ipv6_mask(__be32 *i, unsigned int p)
+{
+	switch (p) {
+	case 0:
+		i[0] =3D i[1] =3D 0;
+		i[2] =3D i[3] =3D 0;
+		break;
+	case 1 ... 31:
+		i[0] =3D maskl(i[0], p);
+		i[1] =3D i[2] =3D i[3] =3D 0;
+		break;
+	case 32:
+		i[1] =3D i[2] =3D i[3] =3D 0;
+		break;
+	case 33 ... 63:
+		i[1] =3D maskl(i[1], p - 32);
+		i[2] =3D i[3] =3D 0;
+		break;
+	case 64:
+		i[2] =3D i[3] =3D 0;
+		break;
+	case 65 ... 95:
+		i[2] =3D maskl(i[2], p - 64);
+		i[3] =3D 0;
+	case 96:
+		i[3] =3D 0;
+		break;
+	case 97 ... 127:
+		i[3] =3D maskl(i[3], p - 96);
+		break;
+	case 128:
+		break;
+	}
+}
+
 static int
 hashlimit_init_dst(const struct xt_hashlimit_htable *hinfo,
 		   struct dsthash_dst *dst,
@@ -401,9 +517,11 @@ hashlimit_init_dst(const struct xt_hashlimit_htabl=
e *hinfo,
 	switch (hinfo->family) {
 	case AF_INET:
 		if (hinfo->cfg.mode & XT_HASHLIMIT_HASH_DIP)
-			dst->addr.ip.dst =3D ip_hdr(skb)->daddr;
+			dst->ip.dst =3D maskl(ip_hdr(skb)->daddr,
+			              hinfo->cfg.dstmask);
 		if (hinfo->cfg.mode & XT_HASHLIMIT_HASH_SIP)
-			dst->addr.ip.src =3D ip_hdr(skb)->saddr;
+			dst->ip.src =3D maskl(ip_hdr(skb)->saddr,
+			              hinfo->cfg.srcmask);
=20
 		if (!(hinfo->cfg.mode &
 		      (XT_HASHLIMIT_HASH_DPT | XT_HASHLIMIT_HASH_SPT)))
@@ -412,12 +530,16 @@ hashlimit_init_dst(const struct xt_hashlimit_htab=
le *hinfo,
 		break;
 #if defined(CONFIG_IP6_NF_IPTABLES) || defined(CONFIG_IP6_NF_IPTABLES_=
MODULE)
 	case AF_INET6:
-		if (hinfo->cfg.mode & XT_HASHLIMIT_HASH_DIP)
-			memcpy(&dst->addr.ip6.dst, &ipv6_hdr(skb)->daddr,
-			       sizeof(dst->addr.ip6.dst));
-		if (hinfo->cfg.mode & XT_HASHLIMIT_HASH_SIP)
-			memcpy(&dst->addr.ip6.src, &ipv6_hdr(skb)->saddr,
-			       sizeof(dst->addr.ip6.src));
+		if (hinfo->cfg.mode & XT_HASHLIMIT_HASH_DIP) {
+			memcpy(&dst->ip6.dst, &ipv6_hdr(skb)->daddr,
+			       sizeof(dst->ip6.dst));
+			hashlimit_ipv6_mask(dst->ip6.dst, hinfo->cfg.dstmask);
+		}
+		if (hinfo->cfg.mode & XT_HASHLIMIT_HASH_SIP) {
+			memcpy(&dst->ip6.src, &ipv6_hdr(skb)->saddr,
+			       sizeof(dst->ip6.src));
+			hashlimit_ipv6_mask(dst->ip6.src, hinfo->cfg.srcmask);
+		}
=20
 		if (!(hinfo->cfg.mode &
 		      (XT_HASHLIMIT_HASH_DPT | XT_HASHLIMIT_HASH_SPT)))
@@ -457,10 +579,10 @@ hashlimit_init_dst(const struct xt_hashlimit_htab=
le *hinfo,
 }
=20
 static bool
-hashlimit_mt(const struct sk_buff *skb, const struct net_device *in,
-             const struct net_device *out, const struct xt_match *matc=
h,
-             const void *matchinfo, int offset, unsigned int protoff,
-             bool *hotdrop)
+hashlimit_mt_v0(const struct sk_buff *skb, const struct net_device *in=
,
+                const struct net_device *out, const struct xt_match *m=
atch,
+                const void *matchinfo, int offset, unsigned int protof=
f,
+                bool *hotdrop)
 {
 	const struct xt_hashlimit_info *r =3D
 		((const struct xt_hashlimit_info *)matchinfo)->u.master;
@@ -512,9 +634,62 @@ hotdrop:
 }
=20
 static bool
-hashlimit_mt_check(const char *tablename, const void *inf,
-                   const struct xt_match *match, void *matchinfo,
-                   unsigned int hook_mask)
+hashlimit_mt(const struct sk_buff *skb, const struct net_device *in,
+             const struct net_device *out, const struct xt_match *matc=
h,
+             const void *matchinfo, int offset, unsigned int protoff,
+             bool *hotdrop)
+{
+	const struct xt_hashlimit_mtinfo1 *info =3D matchinfo;
+	struct xt_hashlimit_htable *hinfo =3D info->hinfo;
+	unsigned long now =3D jiffies;
+	struct dsthash_ent *dh;
+	struct dsthash_dst dst;
+
+	if (hashlimit_init_dst(hinfo, &dst, skb, protoff) < 0)
+		goto hotdrop;
+
+	spin_lock_bh(&hinfo->lock);
+	dh =3D dsthash_find(hinfo, &dst);
+	if (dh =3D=3D NULL) {
+		dh =3D dsthash_alloc_init(hinfo, &dst);
+		if (dh =3D=3D NULL) {
+			spin_unlock_bh(&hinfo->lock);
+			goto hotdrop;
+		}
+
+		dh->expires =3D jiffies + msecs_to_jiffies(hinfo->cfg.expire);
+		dh->rateinfo.prev =3D jiffies;
+		dh->rateinfo.credit =3D user2credits(hinfo->cfg.avg *
+		                      hinfo->cfg.burst);
+		dh->rateinfo.credit_cap =3D user2credits(hinfo->cfg.avg *
+		                          hinfo->cfg.burst);
+		dh->rateinfo.cost =3D user2credits(hinfo->cfg.avg);
+	} else {
+		/* update expiration timeout */
+		dh->expires =3D now + msecs_to_jiffies(hinfo->cfg.expire);
+		rateinfo_recalc(dh, now);
+	}
+
+	if (dh->rateinfo.credit >=3D dh->rateinfo.cost) {
+		/* below the limit */
+		dh->rateinfo.credit -=3D dh->rateinfo.cost;
+		spin_unlock_bh(&hinfo->lock);
+		return !(info->cfg.mode & XT_HASHLIMIT_INVERT);
+	}
+
+	spin_unlock_bh(&hinfo->lock);
+	/* default match is underlimit - so over the limit, we need to invert=
 */
+	return info->cfg.mode & XT_HASHLIMIT_INVERT;
+
+ hotdrop:
+	*hotdrop =3D true;
+	return false;
+}
+
+static bool
+hashlimit_mt_check_v0(const char *tablename, const void *inf,
+                      const struct xt_match *match, void *matchinfo,
+                      unsigned int hook_mask)
 {
 	struct xt_hashlimit_info *r =3D matchinfo;
=20
@@ -546,7 +721,7 @@ hashlimit_mt_check(const char *tablename, const voi=
d *inf,
 	 * create duplicate proc files. -HW */
 	mutex_lock(&hlimit_mutex);
 	r->hinfo =3D htable_find_get(r->name, match->family);
-	if (!r->hinfo && htable_create(r, match->family) !=3D 0) {
+	if (!r->hinfo && htable_create_v0(r, match->family) !=3D 0) {
 		mutex_unlock(&hlimit_mutex);
 		return false;
 	}
@@ -557,14 +732,68 @@ hashlimit_mt_check(const char *tablename, const v=
oid *inf,
 	return true;
 }
=20
+static bool
+hashlimit_mt_check(const char *tablename, const void *inf,
+                   const struct xt_match *match, void *matchinfo,
+                   unsigned int hook_mask)
+{
+	struct xt_hashlimit_mtinfo1 *info =3D matchinfo;
+
+	/* Check for overflow. */
+	if (info->cfg.burst =3D=3D 0 ||
+	    user2credits(info->cfg.avg * info->cfg.burst) <
+	    user2credits(info->cfg.avg)) {
+		printk(KERN_ERR "xt_hashlimit: overflow, try lower: %u/%u\n",
+		       info->cfg.avg, info->cfg.burst);
+		return false;
+	}
+	if (info->cfg.gc_interval =3D=3D 0 || info->cfg.expire =3D=3D 0)
+		return false;
+	if (info->name[sizeof(info->name)-1] !=3D '\0')
+		return false;
+	if (match->family =3D=3D AF_INET) {
+		if (info->cfg.srcmask > 32 || info->cfg.dstmask > 32)
+			return false;
+	} else {
+		if (info->cfg.srcmask > 128 || info->cfg.dstmask > 128)
+			return false;
+	}
+
+	/* This is the best we've got: We cannot release and re-grab lock,
+	 * since checkentry() is called before x_tables.c grabs xt_mutex.
+	 * We also cannot grab the hashtable spinlock, since htable_create wi=
ll
+	 * call vmalloc, and that can sleep.  And we cannot just re-search
+	 * the list of htable's in htable_create(), since then we would
+	 * create duplicate proc files. -HW */
+	mutex_lock(&hlimit_mutex);
+	info->hinfo =3D htable_find_get(info->name, match->family);
+	if (!info->hinfo && htable_create(info, match->family) !=3D 0) {
+		mutex_unlock(&hlimit_mutex);
+		return false;
+	}
+	mutex_unlock(&hlimit_mutex);
+
+	/* Ugly hack: For SMP, we only want to use one set */
+	info->master =3D info;
+	return true;
+}
+
 static void
-hashlimit_mt_destroy(const struct xt_match *match, void *matchinfo)
+hashlimit_mt_destroy_v0(const struct xt_match *match, void *matchinfo)
 {
 	const struct xt_hashlimit_info *r =3D matchinfo;
=20
 	htable_put(r->hinfo);
 }
=20
+static void
+hashlimit_mt_destroy(const struct xt_match *match, void *matchinfo)
+{
+	const struct xt_hashlimit_mtinfo1 *info =3D matchinfo;
+
+	htable_put(info->hinfo);
+}
+
 #ifdef CONFIG_COMPAT
 struct compat_xt_hashlimit_info {
 	char name[IFNAMSIZ];
@@ -592,33 +821,54 @@ static int hashlimit_mt_compat_to_user(void __use=
r *dst, void *src)
 static struct xt_match hashlimit_mt_reg[] __read_mostly =3D {
 	{
 		.name		=3D "hashlimit",
+		.revision	=3D 0,
 		.family		=3D AF_INET,
-		.match		=3D hashlimit_mt,
+		.match		=3D hashlimit_mt_v0,
 		.matchsize	=3D sizeof(struct xt_hashlimit_info),
 #ifdef CONFIG_COMPAT
 		.compatsize	=3D sizeof(struct compat_xt_hashlimit_info),
 		.compat_from_user =3D hashlimit_mt_compat_from_user,
 		.compat_to_user	=3D hashlimit_mt_compat_to_user,
 #endif
-		.checkentry	=3D hashlimit_mt_check,
-		.destroy	=3D hashlimit_mt_destroy,
+		.checkentry	=3D hashlimit_mt_check_v0,
+		.destroy	=3D hashlimit_mt_destroy_v0,
 		.me		=3D THIS_MODULE
 	},
+	{
+		.name           =3D "hashlimit",
+		.revision       =3D 1,
+		.family         =3D AF_INET,
+		.match          =3D hashlimit_mt,
+		.matchsize      =3D sizeof(struct xt_hashlimit_mtinfo1),
+		.checkentry     =3D hashlimit_mt_check,
+		.destroy        =3D hashlimit_mt_destroy,
+		.me             =3D THIS_MODULE,
+	},
 #if defined(CONFIG_IP6_NF_IPTABLES) || defined(CONFIG_IP6_NF_IPTABLES_=
MODULE)
 	{
 		.name		=3D "hashlimit",
 		.family		=3D AF_INET6,
-		.match		=3D hashlimit_mt,
+		.match		=3D hashlimit_mt_v0,
 		.matchsize	=3D sizeof(struct xt_hashlimit_info),
 #ifdef CONFIG_COMPAT
 		.compatsize	=3D sizeof(struct compat_xt_hashlimit_info),
 		.compat_from_user =3D hashlimit_mt_compat_from_user,
 		.compat_to_user	=3D hashlimit_mt_compat_to_user,
 #endif
-		.checkentry	=3D hashlimit_mt_check,
-		.destroy	=3D hashlimit_mt_destroy,
+		.checkentry	=3D hashlimit_mt_check_v0,
+		.destroy	=3D hashlimit_mt_destroy_v0,
 		.me		=3D THIS_MODULE
 	},
+	{
+		.name           =3D "hashlimit",
+		.revision       =3D 1,
+		.family         =3D AF_INET6,
+		.match          =3D hashlimit_mt,
+		.matchsize      =3D sizeof(struct xt_hashlimit_mtinfo1),
+		.checkentry     =3D hashlimit_mt_check,
+		.destroy        =3D hashlimit_mt_destroy,
+		.me             =3D THIS_MODULE,
+	},
 #endif
 };
=20
@@ -678,9 +928,9 @@ static int dl_seq_real_show(struct dsthash_ent *ent=
, int family,
 		return seq_printf(s, "%ld %u.%u.%u.%u:%u->"
 				     "%u.%u.%u.%u:%u %u %u %u\n",
 				 (long)(ent->expires - jiffies)/HZ,
-				 NIPQUAD(ent->dst.addr.ip.src),
+				 NIPQUAD(ent->dst.ip.src),
 				 ntohs(ent->dst.src_port),
-				 NIPQUAD(ent->dst.addr.ip.dst),
+				 NIPQUAD(ent->dst.ip.dst),
 				 ntohs(ent->dst.dst_port),
 				 ent->rateinfo.credit, ent->rateinfo.credit_cap,
 				 ent->rateinfo.cost);
@@ -689,9 +939,9 @@ static int dl_seq_real_show(struct dsthash_ent *ent=
, int family,
 		return seq_printf(s, "%ld " NIP6_FMT ":%u->"
 				     NIP6_FMT ":%u %u %u %u\n",
 				 (long)(ent->expires - jiffies)/HZ,
-				 NIP6(*(struct in6_addr *)&ent->dst.addr.ip6.src),
+				 NIP6(*(struct in6_addr *)&ent->dst.ip6.src),
 				 ntohs(ent->dst.src_port),
-				 NIP6(*(struct in6_addr *)&ent->dst.addr.ip6.dst),
+				 NIP6(*(struct in6_addr *)&ent->dst.ip6.dst),
 				 ntohs(ent->dst.dst_port),
 				 ent->rateinfo.credit, ent->rateinfo.credit_cap,
 				 ent->rateinfo.cost);
-
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
