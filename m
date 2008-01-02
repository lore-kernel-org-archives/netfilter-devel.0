From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [PATCH 12/27] xt_hashlimit match, revision 1
Date: Wed, 2 Jan 2008 21:28:49 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0801022128370.14900@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0801022037090.14900@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:56926 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753905AbYABU2v (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 2 Jan 2008 15:28:51 -0500
In-Reply-To: <Pine.LNX.4.64.0801022037090.14900@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit 98815424093ca5426885218bc0afa5aa18f3e86e
Author: Jan Engelhardt <jengelh@computergmbh.de>
Date:   Wed Jan 2 17:58:05 2008 +0100

    [NETFILTER]: xt_hashlimit match, revision 1
   =20
    Introduces the xt_hashlimit match revision 1. It adds support for
    kernel-level inversion and grouping source and/or destination IP
    addresses, allowing to limit on a per-subnet basis. While this woul=
d
    technically obsolete xt_limit, xt_hashlimit is a more expensive due=
 to
    the hashbucketing.
   =20
    Kernel-level inversion: Previously you had to do user-level inversi=
on:
    	iptables -N foo
    	iptables -A foo -m hashlimit --hashlimit 5/s -j RETURN
    	iptables -A foo -j DROP
    	iptables -A INPUT -j foo
    now it is simpler:
    	iptables -A INPUT -m hashlimit --hashlimit-over 5/s -j DROP
   =20
    Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>

 include/linux/netfilter/xt_hashlimit.h |   37 +++-
 net/netfilter/xt_hashlimit.c           |  311 +++++++++++++++++++++---
 2 files changed, 315 insertions(+), 33 deletions(-)

diff --git a/include/linux/netfilter/xt_hashlimit.h b/include/linux/net=
filter/xt_hashlimit.h
index c19972e..f15b104 100644
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
+	struct xt_hashlimit_mtinfo1 *master;
+};
+
 #endif /*_XT_HASHLIMIT_H*/
diff --git a/net/netfilter/xt_hashlimit.c b/net/netfilter/xt_hashlimit.=
c
index 8439ee4..b747a74 100644
--- a/net/netfilter/xt_hashlimit.c
+++ b/net/netfilter/xt_hashlimit.c
@@ -1,9 +1,10 @@
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
+ *	Jan Engelhardt <jengelh@computergmbh.de>
  *
  * Development of this code was funded by Astaro AG, http://www.astaro=
=2Ecom/
  */
@@ -71,7 +72,7 @@ struct xt_hashlimit_htable {
 	atomic_t use;
 	int family;
=20
-	struct hashlimit_cfg cfg;	/* config */
+	struct hashlimit_cfg1 cfg;	/* config */
=20
 	/* used internally */
 	spinlock_t lock;		/* lock for list_head */
@@ -174,7 +175,7 @@ dsthash_free(struct xt_hashlimit_htable *ht, struct=
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
@@ -200,7 +201,18 @@ static int htable_create(struct xt_hashlimit_info =
*minfo, int family)
 	minfo->hinfo =3D hinfo;
=20
 	/* copy match config into hashtable config */
-	memcpy(&hinfo->cfg, &minfo->cfg, sizeof(hinfo->cfg));
+	hinfo->cfg.mode        =3D minfo->cfg.mode;
+	hinfo->cfg.avg         =3D minfo->cfg.avg;
+	hinfo->cfg.burst       =3D hinfo->cfg.burst;
+	hinfo->cfg.max         =3D hinfo->cfg.max;
+	hinfo->cfg.gc_interval =3D hinfo->cfg.gc_interval;
+	hinfo->cfg.expire      =3D hinfo->cfg.expire;
+
+	if (family =3D=3D AF_INET)
+		hinfo->cfg.srcmask =3D hinfo->cfg.dstmask =3D 32;
+	else
+		hinfo->cfg.srcmask =3D hinfo->cfg.dstmask =3D 128;
+
 	hinfo->cfg.size =3D size;
 	if (!hinfo->cfg.max)
 		hinfo->cfg.max =3D 8 * hinfo->cfg.size;
@@ -236,6 +248,72 @@ static int htable_create(struct xt_hashlimit_info =
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
+	if (family =3D=3D AF_INET)
+		hinfo->pde =3D create_proc_entry(minfo->name,
+		             0, hashlimit_procdir4);
+	else
+		hinfo->pde =3D create_proc_entry(minfo->name,
+		             0, hashlimit_procdir6);
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
@@ -378,6 +456,46 @@ static inline void rateinfo_recalc(struct dsthash_=
ent *dh, unsigned long now)
 	dh->rateinfo.prev =3D now;
 }
=20
+static inline u_int32_t maskl(u_int32_t a, unsigned int l)
+{
+	return htonl(ntohl(a) & ~(~(u_int32_t)0 >> l));
+}
+
+static void hashlimit_ipv6_mask(__be32 *i, unsigned int p)
+{
+	switch (p) {
+		case 0:
+			i[0] =3D i[1] =3D 0;
+			i[2] =3D i[3] =3D 0;
+			break;
+		case 1 ... 31:
+			i[0] =3D maskl(i[0], p);
+			i[1] =3D i[2] =3D i[3] =3D 0;
+			break;
+		case 32:
+			i[1] =3D i[2] =3D i[3] =3D 0;
+			break;
+		case 33 ... 63:
+			i[1] =3D maskl(i[1], p - 32);
+			i[2] =3D i[3] =3D 0;
+			break;
+		case 64:
+			i[2] =3D i[3] =3D 0;
+			break;
+		case 65 ... 95:
+			i[2] =3D maskl(i[2], p - 64);
+			i[3] =3D 0;
+		case 96:
+			i[3] =3D 0;
+			break;
+		case 97 ... 127:
+			i[3] =3D maskl(i[3], p - 96);
+			break;
+		case 128:
+			break;
+	}
+}
+
 static int
 hashlimit_init_dst(const struct xt_hashlimit_htable *hinfo,
 		   struct dsthash_dst *dst,
@@ -390,10 +508,12 @@ hashlimit_init_dst(const struct xt_hashlimit_htab=
le *hinfo,
=20
 	switch (hinfo->family) {
 	case AF_INET:
+		if (hinfo->cfg.mode &  XT_HASHLIMIT_HASH_SIP)
+			dst->src.ip =3D maskl(ip_hdr(skb)->saddr,
+			              hinfo->cfg.srcmask);
 		if (hinfo->cfg.mode & XT_HASHLIMIT_HASH_DIP)
-			dst->dst.ip =3D ip_hdr(skb)->daddr;
-		if (hinfo->cfg.mode & XT_HASHLIMIT_HASH_SIP)
-			dst->src.ip =3D ip_hdr(skb)->saddr;
+			dst->dst.ip =3D maskl(ip_hdr(skb)->daddr,
+			              hinfo->cfg.dstmask);
=20
 		if (!(hinfo->cfg.mode &
 		      (XT_HASHLIMIT_HASH_DPT | XT_HASHLIMIT_HASH_SPT)))
@@ -402,12 +522,16 @@ hashlimit_init_dst(const struct xt_hashlimit_htab=
le *hinfo,
 		break;
 #if defined(CONFIG_IP6_NF_IPTABLES) || defined(CONFIG_IP6_NF_IPTABLES_=
MODULE)
 	case AF_INET6:
-		if (hinfo->cfg.mode & XT_HASHLIMIT_HASH_DIP)
-			memcpy(&dst->dst.in6, &ipv6_hdr(skb)->daddr,
-			       sizeof(dst->dst.in6));
-		if (hinfo->cfg.mode & XT_HASHLIMIT_HASH_SIP)
+		if (hinfo->cfg.mode & XT_HASHLIMIT_HASH_SIP) {
 			memcpy(&dst->src.in6, &ipv6_hdr(skb)->saddr,
 			       sizeof(dst->src.in6));
+			hashlimit_ipv6_mask(dst->dst.ip6, hinfo->cfg.dstmask);
+		}
+		if (hinfo->cfg.mode & XT_HASHLIMIT_HASH_DIP) {
+			memcpy(&dst->dst.in6, &ipv6_hdr(skb)->daddr,
+			       sizeof(dst->dst.in6));
+			hashlimit_ipv6_mask(dst->src.ip6, hinfo->cfg.srcmask);
+		}
=20
 		if (!(hinfo->cfg.mode &
 		      (XT_HASHLIMIT_HASH_DPT | XT_HASHLIMIT_HASH_SPT)))
@@ -447,10 +571,10 @@ hashlimit_init_dst(const struct xt_hashlimit_htab=
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
@@ -502,9 +626,62 @@ hotdrop:
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
@@ -536,7 +713,7 @@ hashlimit_mt_check(const char *tablename, const voi=
d *inf,
 	 * create duplicate proc files. -HW */
 	mutex_lock(&hlimit_mutex);
 	r->hinfo =3D htable_find_get(r->name, match->family);
-	if (!r->hinfo && htable_create(r, match->family) !=3D 0) {
+	if (!r->hinfo && htable_create_v0(r, match->family) !=3D 0) {
 		mutex_unlock(&hlimit_mutex);
 		return false;
 	}
@@ -547,33 +724,111 @@ hashlimit_mt_check(const char *tablename, const =
void *inf,
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
 static struct xt_match hashlimit_mt_reg[] __read_mostly =3D {
 	{
 		.name		=3D "hashlimit",
+		.revision	=3D 0,
 		.family		=3D AF_INET,
-		.match		=3D hashlimit_mt,
+		.match		=3D hashlimit_mt_v0,
+		.matchsize	=3D sizeof(struct xt_hashlimit_info),
+		.checkentry	=3D hashlimit_mt_check_v0,
+		.destroy	=3D hashlimit_mt_destroy_v0,
+		.me		=3D THIS_MODULE
+	},
+#if defined(CONFIG_IP6_NF_IPTABLES) || defined(CONFIG_IP6_NF_IPTABLES_=
MODULE)
+	{
+		.name		=3D "hashlimit",
+		.revision	=3D 0,
+		.family		=3D AF_INET6,
+		.match		=3D hashlimit_mt_v0,
 		.matchsize	=3D sizeof(struct xt_hashlimit_info),
+		.checkentry	=3D hashlimit_mt_check_v0,
+		.destroy	=3D hashlimit_mt_destroy_v0,
+		.me		=3D THIS_MODULE
+	},
+#endif
+	{
+		.name		=3D "hashlimit",
+		.revision	=3D 1,
+		.family		=3D AF_INET,
+		.match		=3D hashlimit_mt,
+		.matchsize	=3D sizeof(struct xt_hashlimit_mtinfo1),
 		.checkentry	=3D hashlimit_mt_check,
 		.destroy	=3D hashlimit_mt_destroy,
-		.me		=3D THIS_MODULE
+		.me		=3D THIS_MODULE,
 	},
 #if defined(CONFIG_IP6_NF_IPTABLES) || defined(CONFIG_IP6_NF_IPTABLES_=
MODULE)
 	{
 		.name		=3D "hashlimit",
+		.revision	=3D 1,
 		.family		=3D AF_INET6,
 		.match		=3D hashlimit_mt,
-		.matchsize	=3D sizeof(struct xt_hashlimit_info),
+		.matchsize	=3D sizeof(struct xt_hashlimit_mtinfo1),
 		.checkentry	=3D hashlimit_mt_check,
 		.destroy	=3D hashlimit_mt_destroy,
-		.me		=3D THIS_MODULE
+		.me		=3D THIS_MODULE,
 	},
 #endif
 };
-
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
