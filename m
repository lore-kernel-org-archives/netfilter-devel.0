From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER]: x_tables: add port of hashlimit match for IPv4 and IPv6
Date: Thu, 23 Nov 2006 14:02:18 +0100
Message-ID: <45659BDA.7010607@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------030402010006060109070306"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
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

This is a multi-part message in MIME format.
--------------030402010006060109070306
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

I plan to submit Martin's conntrack patches and a few other
patches soon, so here are the patches that haven't been sent
to the list before.


--------------030402010006060109070306
Content-Type: text/plain;
 name="x"
Content-Disposition: inline;
 filename="x"
Content-Transfer-Encoding: quoted-printable

[NETFILTER]: x_tables: add port of hashlimit match for IPv4 and IPv6

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 765cef2ab08e63bec8d0accc5b2f2c08bf4832e1
tree 6ff1f1263c8d1f0288072d0116fa50c73bc779d4
parent f68d7ad920d5391e584aa3775e78093e46597963
author Patrick McHardy <kaber@trash.net> Thu, 23 Nov 2006 13:37:32 +0100
committer Patrick McHardy <kaber@trash.net> Thu, 23 Nov 2006 13:45:19 +01=
00

 include/linux/netfilter/Kbuild               |    1=20
 include/linux/netfilter/xt_hashlimit.h       |   40 +
 include/linux/netfilter_ipv4/ipt_hashlimit.h |   42 -
 net/ipv4/netfilter/Kconfig                   |   14=20
 net/ipv4/netfilter/Makefile                  |    1=20
 net/ipv4/netfilter/ipt_hashlimit.c           |  733 --------------------=
-----
 net/netfilter/Kconfig                        |   14=20
 net/netfilter/Makefile                       |    1=20
 net/netfilter/xt_hashlimit.c                 |  772 ++++++++++++++++++++=
++++++
 9 files changed, 836 insertions(+), 782 deletions(-)

diff --git a/include/linux/netfilter/Kbuild b/include/linux/netfilter/Kbu=
ild
index 312bd2f..e379a2d 100644
--- a/include/linux/netfilter/Kbuild
+++ b/include/linux/netfilter/Kbuild
@@ -14,6 +14,7 @@ header-y +=3D xt_dscp.h
 header-y +=3D xt_DSCP.h
 header-y +=3D xt_esp.h
 header-y +=3D xt_helper.h
+header-y +=3D xt_hashlimit.h
 header-y +=3D xt_length.h
 header-y +=3D xt_limit.h
 header-y +=3D xt_mac.h
diff --git a/include/linux/netfilter/xt_hashlimit.h b/include/linux/netfi=
lter/xt_hashlimit.h
new file mode 100644
index 0000000..b4556b8
--- /dev/null
+++ b/include/linux/netfilter/xt_hashlimit.h
@@ -0,0 +1,40 @@
+#ifndef _XT_HASHLIMIT_H
+#define _XT_HASHLIMIT_H
+
+/* timings are in milliseconds. */
+#define XT_HASHLIMIT_SCALE 10000
+/* 1/10,000 sec period =3D> max of 10,000/sec.  Min rate is then 429490
+   seconds, or one every 59 hours. */
+
+/* details of this structure hidden by the implementation */
+struct xt_hashlimit_htable;
+
+#define XT_HASHLIMIT_HASH_DIP	0x0001
+#define XT_HASHLIMIT_HASH_DPT	0x0002
+#define XT_HASHLIMIT_HASH_SIP	0x0004
+#define XT_HASHLIMIT_HASH_SPT	0x0008
+
+struct hashlimit_cfg {
+	u_int32_t mode;	  /* bitmask of IPT_HASHLIMIT_HASH_* */
+	u_int32_t avg;    /* Average secs between packets * scale */
+	u_int32_t burst;  /* Period multiplier for upper limit. */
+
+	/* user specified */
+	u_int32_t size;		/* how many buckets */
+	u_int32_t max;		/* max number of entries */
+	u_int32_t gc_interval;	/* gc interval */
+	u_int32_t expire;	/* when do entries expire? */
+};
+
+struct xt_hashlimit_info {
+	char name [IFNAMSIZ];		/* name */
+	struct hashlimit_cfg cfg;
+	struct xt_hashlimit_htable *hinfo;
+
+	/* Used internally by the kernel */
+	union {
+		void *ptr;
+		struct xt_hashlimit_info *master;
+	} u;
+};
+#endif /*_XT_HASHLIMIT_H*/
diff --git a/include/linux/netfilter_ipv4/ipt_hashlimit.h b/include/linux=
/netfilter_ipv4/ipt_hashlimit.h
index ac2cb64..5662120 100644
--- a/include/linux/netfilter_ipv4/ipt_hashlimit.h
+++ b/include/linux/netfilter_ipv4/ipt_hashlimit.h
@@ -1,40 +1,14 @@
 #ifndef _IPT_HASHLIMIT_H
 #define _IPT_HASHLIMIT_H
=20
-/* timings are in milliseconds. */
-#define IPT_HASHLIMIT_SCALE 10000
-/* 1/10,000 sec period =3D> max of 10,000/sec.  Min rate is then 429490
-   seconds, or one every 59 hours. */
+#include <linux/netfilter/xt_hashlimit.h>
=20
-/* details of this structure hidden by the implementation */
-struct ipt_hashlimit_htable;
+#define IPT_HASHLIMIT_SCALE	XT_HASHLIMIT_SCALE
+#define IPT_HASHLIMIT_HASH_DIP	XT_HASHLIMIT_HASH_DIP
+#define IPT_HASHLIMIT_HASH_DPT	XT_HASHLIMIT_HASH_DPT
+#define IPT_HASHLIMIT_HASH_SIP	XT_HASHLIMIT_HASH_SIP
+#define IPT_HASHLIMIT_HASH_SPT	XT_HASHLIMIT_HASH_SPT
=20
-#define IPT_HASHLIMIT_HASH_DIP	0x0001
-#define IPT_HASHLIMIT_HASH_DPT	0x0002
-#define IPT_HASHLIMIT_HASH_SIP	0x0004
-#define IPT_HASHLIMIT_HASH_SPT	0x0008
+#define ipt_hashlimit_info xt_hashlimit_info
=20
-struct hashlimit_cfg {
-	u_int32_t mode;	  /* bitmask of IPT_HASHLIMIT_HASH_* */
-	u_int32_t avg;    /* Average secs between packets * scale */
-	u_int32_t burst;  /* Period multiplier for upper limit. */
-
-	/* user specified */
-	u_int32_t size;		/* how many buckets */
-	u_int32_t max;		/* max number of entries */
-	u_int32_t gc_interval;	/* gc interval */
-	u_int32_t expire;	/* when do entries expire? */
-};
-
-struct ipt_hashlimit_info {
-	char name [IFNAMSIZ];		/* name */
-	struct hashlimit_cfg cfg;
-	struct ipt_hashlimit_htable *hinfo;
-
-	/* Used internally by the kernel */
-	union {
-		void *ptr;
-		struct ipt_hashlimit_info *master;
-	} u;
-};
-#endif /*_IPT_HASHLIMIT_H*/
+#endif /* _IPT_HASHLIMIT_H */
diff --git a/net/ipv4/netfilter/Kconfig b/net/ipv4/netfilter/Kconfig
index d88c292..6f24d51 100644
--- a/net/ipv4/netfilter/Kconfig
+++ b/net/ipv4/netfilter/Kconfig
@@ -315,20 +315,6 @@ config IP_NF_MATCH_ADDRTYPE
 	  If you want to compile it as a module, say M here and read
 	  <file:Documentation/modules.txt>.  If unsure, say `N'.
=20
-config IP_NF_MATCH_HASHLIMIT
-	tristate  'hashlimit match support'
-	depends on IP_NF_IPTABLES
-	help
-	  This option adds a new iptables `hashlimit' match. =20
-
-	  As opposed to `limit', this match dynamically creates a hash table
-	  of limit buckets, based on your selection of source/destination
-	  ip addresses and/or ports.
-
-	  It enables you to express policies like `10kpps for any given
-	  destination IP' or `500pps from any given source IP'  with a single
-	  IPtables rule.
-
 # `filter', generic and specific targets
 config IP_NF_FILTER
 	tristate "Packet filtering"
diff --git a/net/ipv4/netfilter/Makefile b/net/ipv4/netfilter/Makefile
index 09aaed1..76d56b4 100644
--- a/net/ipv4/netfilter/Makefile
+++ b/net/ipv4/netfilter/Makefile
@@ -53,7 +53,6 @@ obj-$(CONFIG_IP_NF_NAT) +=3D iptable_nat.o
 obj-$(CONFIG_IP_NF_RAW) +=3D iptable_raw.o
=20
 # matches
-obj-$(CONFIG_IP_NF_MATCH_HASHLIMIT) +=3D ipt_hashlimit.o
 obj-$(CONFIG_IP_NF_MATCH_IPRANGE) +=3D ipt_iprange.o
 obj-$(CONFIG_IP_NF_MATCH_OWNER) +=3D ipt_owner.o
 obj-$(CONFIG_IP_NF_MATCH_TOS) +=3D ipt_tos.o
diff --git a/net/ipv4/netfilter/ipt_hashlimit.c b/net/ipv4/netfilter/ipt_=
hashlimit.c
deleted file mode 100644
index 33ccdbf..0000000
--- a/net/ipv4/netfilter/ipt_hashlimit.c
+++ /dev/null
@@ -1,733 +0,0 @@
-/* iptables match extension to limit the number of packets per second
- * seperately for each hashbucket (sourceip/sourceport/dstip/dstport)
- *
- * (C) 2003-2004 by Harald Welte <laforge@netfilter.org>
- *
- * $Id: ipt_hashlimit.c 3244 2004-10-20 16:24:29Z laforge@netfilter.org =
$
- *
- * Development of this code was funded by Astaro AG, http://www.astaro.c=
om/
- *
- * based on ipt_limit.c by:
- * J=E9r=F4me de Vivie	<devivie@info.enserb.u-bordeaux.fr>
- * Herv=E9 Eychenne	<eychenne@info.enserb.u-bordeaux.fr>
- * Rusty Russell	<rusty@rustcorp.com.au>
- *
- * The general idea is to create a hash table for every dstip and have a
- * seperate limit counter per tuple.  This way you can do something like=
 'limit
- * the number of syn packets for each of my internal addresses.
- *
- * Ideally this would just be implemented as a general 'hash' match, whi=
ch would
- * allow us to attach any iptables target to it's hash buckets.  But thi=
s is
- * not possible in the current iptables architecture.  As always, pkttab=
les for
- * 2.7.x will help ;)
- */
-#include <linux/module.h>
-#include <linux/skbuff.h>
-#include <linux/spinlock.h>
-#include <linux/random.h>
-#include <linux/jhash.h>
-#include <linux/slab.h>
-#include <linux/vmalloc.h>
-#include <linux/proc_fs.h>
-#include <linux/seq_file.h>
-#include <linux/list.h>
-
-#include <linux/netfilter_ipv4/ip_tables.h>
-#include <linux/netfilter_ipv4/ipt_hashlimit.h>
-
-/* FIXME: this is just for IP_NF_ASSERRT */
-#include <linux/netfilter_ipv4/ip_conntrack.h>
-#include <linux/mutex.h>
-
-MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Harald Welte <laforge@netfilter.org>");
-MODULE_DESCRIPTION("iptables match for limiting per hash-bucket");
-
-/* need to declare this at the top */
-static struct proc_dir_entry *hashlimit_procdir;
-static struct file_operations dl_file_ops;
-
-/* hash table crap */
-
-struct dsthash_dst {
-	__be32 src_ip;
-	__be32 dst_ip;
-	/* ports have to be consecutive !!! */
-	__be16 src_port;
-	__be16 dst_port;
-};
-
-struct dsthash_ent {
-	/* static / read-only parts in the beginning */
-	struct hlist_node node;
-	struct dsthash_dst dst;
-
-	/* modified structure members in the end */
-	unsigned long expires;		/* precalculated expiry time */
-	struct {
-		unsigned long prev;	/* last modification */
-		u_int32_t credit;
-		u_int32_t credit_cap, cost;
-	} rateinfo;
-};
-
-struct ipt_hashlimit_htable {
-	struct hlist_node node;		/* global list of all htables */
-	atomic_t use;
-
-	struct hashlimit_cfg cfg;	/* config */
-
-	/* used internally */
-	spinlock_t lock;		/* lock for list_head */
-	u_int32_t rnd;			/* random seed for hash */
-	int rnd_initialized;
-	struct timer_list timer;	/* timer for gc */
-	atomic_t count;			/* number entries in table */
-
-	/* seq_file stuff */
-	struct proc_dir_entry *pde;
-
-	struct hlist_head hash[0];	/* hashtable itself */
-};
-
-static DEFINE_SPINLOCK(hashlimit_lock);	/* protects htables list */
-static DEFINE_MUTEX(hlimit_mutex);	/* additional checkentry protection *=
/
-static HLIST_HEAD(hashlimit_htables);
-static kmem_cache_t *hashlimit_cachep __read_mostly;
-
-static inline int dst_cmp(const struct dsthash_ent *ent, struct dsthash_=
dst *b)
-{
-	return (ent->dst.dst_ip =3D=3D b->dst_ip=20
-		&& ent->dst.dst_port =3D=3D b->dst_port
-		&& ent->dst.src_port =3D=3D b->src_port
-		&& ent->dst.src_ip =3D=3D b->src_ip);
-}
-
-static inline u_int32_t
-hash_dst(const struct ipt_hashlimit_htable *ht, const struct dsthash_dst=
 *dst)
-{
-	return (jhash_3words((__force u32)dst->dst_ip,
-			    ((__force u32)dst->dst_port<<16 |
-			     (__force u32)dst->src_port),
-			     (__force u32)dst->src_ip, ht->rnd) % ht->cfg.size);
-}
-
-static inline struct dsthash_ent *
-__dsthash_find(const struct ipt_hashlimit_htable *ht, struct dsthash_dst=
 *dst)
-{
-	struct dsthash_ent *ent;
-	struct hlist_node *pos;
-	u_int32_t hash =3D hash_dst(ht, dst);
-
-	if (!hlist_empty(&ht->hash[hash]))
-		hlist_for_each_entry(ent, pos, &ht->hash[hash], node) {
-			if (dst_cmp(ent, dst)) {
-				return ent;
-			}
-		}
-=09
-	return NULL;
-}
-
-/* allocate dsthash_ent, initialize dst, put in htable and lock it */
-static struct dsthash_ent *
-__dsthash_alloc_init(struct ipt_hashlimit_htable *ht, struct dsthash_dst=
 *dst)
-{
-	struct dsthash_ent *ent;
-
-	/* initialize hash with random val at the time we allocate
-	 * the first hashtable entry */
-	if (!ht->rnd_initialized) {
-		get_random_bytes(&ht->rnd, 4);
-		ht->rnd_initialized =3D 1;
-	}
-
-	if (ht->cfg.max &&
-	    atomic_read(&ht->count) >=3D ht->cfg.max) {
-		/* FIXME: do something. question is what.. */
-		if (net_ratelimit())
-			printk(KERN_WARNING=20
-				"ipt_hashlimit: max count of %u reached\n",=20
-				ht->cfg.max);
-		return NULL;
-	}
-
-	ent =3D kmem_cache_alloc(hashlimit_cachep, GFP_ATOMIC);
-	if (!ent) {
-		if (net_ratelimit())
-			printk(KERN_ERR=20
-				"ipt_hashlimit: can't allocate dsthash_ent\n");
-		return NULL;
-	}
-
-	atomic_inc(&ht->count);
-
-	ent->dst.dst_ip =3D dst->dst_ip;
-	ent->dst.dst_port =3D dst->dst_port;
-	ent->dst.src_ip =3D dst->src_ip;
-	ent->dst.src_port =3D dst->src_port;
-
-	hlist_add_head(&ent->node, &ht->hash[hash_dst(ht, dst)]);
-
-	return ent;
-}
-
-static inline void=20
-__dsthash_free(struct ipt_hashlimit_htable *ht, struct dsthash_ent *ent)
-{
-	hlist_del(&ent->node);
-	kmem_cache_free(hashlimit_cachep, ent);
-	atomic_dec(&ht->count);
-}
-static void htable_gc(unsigned long htlong);
-
-static int htable_create(struct ipt_hashlimit_info *minfo)
-{
-	int i;
-	unsigned int size;
-	struct ipt_hashlimit_htable *hinfo;
-
-	if (minfo->cfg.size)
-		size =3D minfo->cfg.size;
-	else {
-		size =3D (((num_physpages << PAGE_SHIFT) / 16384)
-			 / sizeof(struct list_head));
-		if (num_physpages > (1024 * 1024 * 1024 / PAGE_SIZE))
-			size =3D 8192;
-		if (size < 16)
-			size =3D 16;
-	}
-	/* FIXME: don't use vmalloc() here or anywhere else -HW */
-	hinfo =3D vmalloc(sizeof(struct ipt_hashlimit_htable)
-			+ (sizeof(struct list_head) * size));
-	if (!hinfo) {
-		printk(KERN_ERR "ipt_hashlimit: Unable to create hashtable\n");
-		return -1;
-	}
-	minfo->hinfo =3D hinfo;
-
-	/* copy match config into hashtable config */
-	memcpy(&hinfo->cfg, &minfo->cfg, sizeof(hinfo->cfg));
-	hinfo->cfg.size =3D size;
-	if (!hinfo->cfg.max)
-		hinfo->cfg.max =3D 8 * hinfo->cfg.size;
-	else if (hinfo->cfg.max < hinfo->cfg.size)
-		hinfo->cfg.max =3D hinfo->cfg.size;
-
-	for (i =3D 0; i < hinfo->cfg.size; i++)
-		INIT_HLIST_HEAD(&hinfo->hash[i]);
-
-	atomic_set(&hinfo->count, 0);
-	atomic_set(&hinfo->use, 1);
-	hinfo->rnd_initialized =3D 0;
-	spin_lock_init(&hinfo->lock);
-	hinfo->pde =3D create_proc_entry(minfo->name, 0, hashlimit_procdir);
-	if (!hinfo->pde) {
-		vfree(hinfo);
-		return -1;
-	}
-	hinfo->pde->proc_fops =3D &dl_file_ops;
-	hinfo->pde->data =3D hinfo;
-
-	init_timer(&hinfo->timer);
-	hinfo->timer.expires =3D jiffies + msecs_to_jiffies(hinfo->cfg.gc_inter=
val);
-	hinfo->timer.data =3D (unsigned long )hinfo;
-	hinfo->timer.function =3D htable_gc;
-	add_timer(&hinfo->timer);
-
-	spin_lock_bh(&hashlimit_lock);
-	hlist_add_head(&hinfo->node, &hashlimit_htables);
-	spin_unlock_bh(&hashlimit_lock);
-
-	return 0;
-}
-
-static int select_all(struct ipt_hashlimit_htable *ht, struct dsthash_en=
t *he)
-{
-	return 1;
-}
-
-static int select_gc(struct ipt_hashlimit_htable *ht, struct dsthash_ent=
 *he)
-{
-	return (jiffies >=3D he->expires);
-}
-
-static void htable_selective_cleanup(struct ipt_hashlimit_htable *ht,
-		 		int (*select)(struct ipt_hashlimit_htable *ht,=20
-					      struct dsthash_ent *he))
-{
-	int i;
-
-	IP_NF_ASSERT(ht->cfg.size && ht->cfg.max);
-
-	/* lock hash table and iterate over it */
-	spin_lock_bh(&ht->lock);
-	for (i =3D 0; i < ht->cfg.size; i++) {
-		struct dsthash_ent *dh;
-		struct hlist_node *pos, *n;
-		hlist_for_each_entry_safe(dh, pos, n, &ht->hash[i], node) {
-			if ((*select)(ht, dh))
-				__dsthash_free(ht, dh);
-		}
-	}
-	spin_unlock_bh(&ht->lock);
-}
-
-/* hash table garbage collector, run by timer */
-static void htable_gc(unsigned long htlong)
-{
-	struct ipt_hashlimit_htable *ht =3D (struct ipt_hashlimit_htable *)htlo=
ng;
-
-	htable_selective_cleanup(ht, select_gc);
-
-	/* re-add the timer accordingly */
-	ht->timer.expires =3D jiffies + msecs_to_jiffies(ht->cfg.gc_interval);
-	add_timer(&ht->timer);
-}
-
-static void htable_destroy(struct ipt_hashlimit_htable *hinfo)
-{
-	/* remove timer, if it is pending */
-	if (timer_pending(&hinfo->timer))
-		del_timer(&hinfo->timer);
-
-	/* remove proc entry */
-	remove_proc_entry(hinfo->pde->name, hashlimit_procdir);
-
-	htable_selective_cleanup(hinfo, select_all);
-	vfree(hinfo);
-}
-
-static struct ipt_hashlimit_htable *htable_find_get(char *name)
-{
-	struct ipt_hashlimit_htable *hinfo;
-	struct hlist_node *pos;
-
-	spin_lock_bh(&hashlimit_lock);
-	hlist_for_each_entry(hinfo, pos, &hashlimit_htables, node) {
-		if (!strcmp(name, hinfo->pde->name)) {
-			atomic_inc(&hinfo->use);
-			spin_unlock_bh(&hashlimit_lock);
-			return hinfo;
-		}
-	}
-	spin_unlock_bh(&hashlimit_lock);
-
-	return NULL;
-}
-
-static void htable_put(struct ipt_hashlimit_htable *hinfo)
-{
-	if (atomic_dec_and_test(&hinfo->use)) {
-		spin_lock_bh(&hashlimit_lock);
-		hlist_del(&hinfo->node);
-		spin_unlock_bh(&hashlimit_lock);
-		htable_destroy(hinfo);
-	}
-}
-
-
-/* The algorithm used is the Simple Token Bucket Filter (TBF)
- * see net/sched/sch_tbf.c in the linux source tree
- */
-
-/* Rusty: This is my (non-mathematically-inclined) understanding of
-   this algorithm.  The `average rate' in jiffies becomes your initial
-   amount of credit `credit' and the most credit you can ever have
-   `credit_cap'.  The `peak rate' becomes the cost of passing the
-   test, `cost'.
-
-   `prev' tracks the last packet hit: you gain one credit per jiffy.
-   If you get credit balance more than this, the extra credit is
-   discarded.  Every time the match passes, you lose `cost' credits;
-   if you don't have that many, the test fails.
-
-   See Alexey's formal explanation in net/sched/sch_tbf.c.
-
-   To get the maximum range, we multiply by this factor (ie. you get N
-   credits per jiffy).  We want to allow a rate as low as 1 per day
-   (slowest userspace tool allows), which means
-   CREDITS_PER_JIFFY*HZ*60*60*24 < 2^32 ie.
-*/
-#define MAX_CPJ (0xFFFFFFFF / (HZ*60*60*24))
-
-/* Repeated shift and or gives us all 1s, final shift and add 1 gives
- * us the power of 2 below the theoretical max, so GCC simply does a
- * shift. */
-#define _POW2_BELOW2(x) ((x)|((x)>>1))
-#define _POW2_BELOW4(x) (_POW2_BELOW2(x)|_POW2_BELOW2((x)>>2))
-#define _POW2_BELOW8(x) (_POW2_BELOW4(x)|_POW2_BELOW4((x)>>4))
-#define _POW2_BELOW16(x) (_POW2_BELOW8(x)|_POW2_BELOW8((x)>>8))
-#define _POW2_BELOW32(x) (_POW2_BELOW16(x)|_POW2_BELOW16((x)>>16))
-#define POW2_BELOW32(x) ((_POW2_BELOW32(x)>>1) + 1)
-
-#define CREDITS_PER_JIFFY POW2_BELOW32(MAX_CPJ)
-
-/* Precision saver. */
-static inline u_int32_t
-user2credits(u_int32_t user)
-{
-	/* If multiplying would overflow... */
-	if (user > 0xFFFFFFFF / (HZ*CREDITS_PER_JIFFY))
-		/* Divide first. */
-		return (user / IPT_HASHLIMIT_SCALE) * HZ * CREDITS_PER_JIFFY;
-
-	return (user * HZ * CREDITS_PER_JIFFY) / IPT_HASHLIMIT_SCALE;
-}
-
-static inline void rateinfo_recalc(struct dsthash_ent *dh, unsigned long=
 now)
-{
-	dh->rateinfo.credit +=3D (now - xchg(&dh->rateinfo.prev, now))=20
-					* CREDITS_PER_JIFFY;
-	if (dh->rateinfo.credit > dh->rateinfo.credit_cap)
-		dh->rateinfo.credit =3D dh->rateinfo.credit_cap;
-}
-
-static int
-hashlimit_match(const struct sk_buff *skb,
-		const struct net_device *in,
-		const struct net_device *out,
-		const struct xt_match *match,
-		const void *matchinfo,
-		int offset,
-		unsigned int protoff,
-		int *hotdrop)
-{
-	struct ipt_hashlimit_info *r =3D=20
-		((struct ipt_hashlimit_info *)matchinfo)->u.master;
-	struct ipt_hashlimit_htable *hinfo =3D r->hinfo;
-	unsigned long now =3D jiffies;
-	struct dsthash_ent *dh;
-	struct dsthash_dst dst;
-
-	/* build 'dst' according to hinfo->cfg and current packet */
-	memset(&dst, 0, sizeof(dst));
-	if (hinfo->cfg.mode & IPT_HASHLIMIT_HASH_DIP)
-		dst.dst_ip =3D skb->nh.iph->daddr;
-	if (hinfo->cfg.mode & IPT_HASHLIMIT_HASH_SIP)
-		dst.src_ip =3D skb->nh.iph->saddr;
-	if (hinfo->cfg.mode & IPT_HASHLIMIT_HASH_DPT
-	    ||hinfo->cfg.mode & IPT_HASHLIMIT_HASH_SPT) {
-		__be16 _ports[2], *ports;
-
-		switch (skb->nh.iph->protocol) {
-		case IPPROTO_TCP:
-		case IPPROTO_UDP:
-		case IPPROTO_SCTP:
-		case IPPROTO_DCCP:
-			ports =3D skb_header_pointer(skb, skb->nh.iph->ihl*4,
-						   sizeof(_ports), &_ports);
-			break;
-		default:
-			_ports[0] =3D _ports[1] =3D 0;
-			ports =3D _ports;
-			break;
-		}
-		if (!ports) {
-			/* We've been asked to examine this packet, and we
-		 	  can't.  Hence, no choice but to drop. */
-			*hotdrop =3D 1;
-			return 0;
-		}
-		if (hinfo->cfg.mode & IPT_HASHLIMIT_HASH_SPT)
-			dst.src_port =3D ports[0];
-		if (hinfo->cfg.mode & IPT_HASHLIMIT_HASH_DPT)
-			dst.dst_port =3D ports[1];
-	}=20
-
-	spin_lock_bh(&hinfo->lock);
-	dh =3D __dsthash_find(hinfo, &dst);
-	if (!dh) {
-		dh =3D __dsthash_alloc_init(hinfo, &dst);
-
-		if (!dh) {
-			/* enomem... don't match =3D=3D DROP */
-			if (net_ratelimit())
-				printk(KERN_ERR "%s: ENOMEM\n", __FUNCTION__);
-			spin_unlock_bh(&hinfo->lock);
-			return 0;
-		}
-
-		dh->expires =3D jiffies + msecs_to_jiffies(hinfo->cfg.expire);
-
-		dh->rateinfo.prev =3D jiffies;
-		dh->rateinfo.credit =3D user2credits(hinfo->cfg.avg *=20
-							hinfo->cfg.burst);
-		dh->rateinfo.credit_cap =3D user2credits(hinfo->cfg.avg *=20
-							hinfo->cfg.burst);
-		dh->rateinfo.cost =3D user2credits(hinfo->cfg.avg);
-	} else {
-		/* update expiration timeout */
-		dh->expires =3D now + msecs_to_jiffies(hinfo->cfg.expire);
-		rateinfo_recalc(dh, now);
-	}
-
-	if (dh->rateinfo.credit >=3D dh->rateinfo.cost) {
-		/* We're underlimit. */
-		dh->rateinfo.credit -=3D dh->rateinfo.cost;
-		spin_unlock_bh(&hinfo->lock);
-		return 1;
-	}
-
-       	spin_unlock_bh(&hinfo->lock);
-
-	/* default case: we're overlimit, thus don't match */
-	return 0;
-}
-
-static int
-hashlimit_checkentry(const char *tablename,
-		     const void *inf,
-		     const struct xt_match *match,
-		     void *matchinfo,
-		     unsigned int hook_mask)
-{
-	struct ipt_hashlimit_info *r =3D matchinfo;
-
-	/* Check for overflow. */
-	if (r->cfg.burst =3D=3D 0
-	    || user2credits(r->cfg.avg * r->cfg.burst) <=20
-	    				user2credits(r->cfg.avg)) {
-		printk(KERN_ERR "ipt_hashlimit: Overflow, try lower: %u/%u\n",
-		       r->cfg.avg, r->cfg.burst);
-		return 0;
-	}
-
-	if (r->cfg.mode =3D=3D 0=20
-	    || r->cfg.mode > (IPT_HASHLIMIT_HASH_DPT
-		          |IPT_HASHLIMIT_HASH_DIP
-			  |IPT_HASHLIMIT_HASH_SIP
-			  |IPT_HASHLIMIT_HASH_SPT))
-		return 0;
-
-	if (!r->cfg.gc_interval)
-		return 0;
-=09
-	if (!r->cfg.expire)
-		return 0;
-
-	if (r->name[sizeof(r->name) - 1] !=3D '\0')
-		return 0;
-
-	/* This is the best we've got: We cannot release and re-grab lock,
-	 * since checkentry() is called before ip_tables.c grabs ipt_mutex. =20
-	 * We also cannot grab the hashtable spinlock, since htable_create will=
=20
-	 * call vmalloc, and that can sleep.  And we cannot just re-search
-	 * the list of htable's in htable_create(), since then we would
-	 * create duplicate proc files. -HW */
-	mutex_lock(&hlimit_mutex);
-	r->hinfo =3D htable_find_get(r->name);
-	if (!r->hinfo && (htable_create(r) !=3D 0)) {
-		mutex_unlock(&hlimit_mutex);
-		return 0;
-	}
-	mutex_unlock(&hlimit_mutex);
-
-	/* Ugly hack: For SMP, we only want to use one set */
-	r->u.master =3D r;
-
-	return 1;
-}
-
-static void
-hashlimit_destroy(const struct xt_match *match, void *matchinfo)
-{
-	struct ipt_hashlimit_info *r =3D matchinfo;
-
-	htable_put(r->hinfo);
-}
-
-#ifdef CONFIG_COMPAT
-struct compat_ipt_hashlimit_info {
-	char name[IFNAMSIZ];
-	struct hashlimit_cfg cfg;
-	compat_uptr_t hinfo;
-	compat_uptr_t master;
-};
-
-static void compat_from_user(void *dst, void *src)
-{
-	int off =3D offsetof(struct compat_ipt_hashlimit_info, hinfo);
-
-	memcpy(dst, src, off);
-	memset(dst + off, 0, sizeof(struct compat_ipt_hashlimit_info) - off);
-}
-
-static int compat_to_user(void __user *dst, void *src)
-{
-	int off =3D offsetof(struct compat_ipt_hashlimit_info, hinfo);
-
-	return copy_to_user(dst, src, off) ? -EFAULT : 0;
-}
-#endif
-
-static struct ipt_match ipt_hashlimit =3D {
-	.name		=3D "hashlimit",
-	.match		=3D hashlimit_match,
-	.matchsize	=3D sizeof(struct ipt_hashlimit_info),
-#ifdef CONFIG_COMPAT
-	.compatsize	=3D sizeof(struct compat_ipt_hashlimit_info),
-	.compat_from_user =3D compat_from_user,
-	.compat_to_user	=3D compat_to_user,
-#endif
-	.checkentry	=3D hashlimit_checkentry,
-	.destroy	=3D hashlimit_destroy,
-	.me		=3D THIS_MODULE
-};
-
-/* PROC stuff */
-
-static void *dl_seq_start(struct seq_file *s, loff_t *pos)
-{
-	struct proc_dir_entry *pde =3D s->private;
-	struct ipt_hashlimit_htable *htable =3D pde->data;
-	unsigned int *bucket;
-
-	spin_lock_bh(&htable->lock);
-	if (*pos >=3D htable->cfg.size)
-		return NULL;
-
-	bucket =3D kmalloc(sizeof(unsigned int), GFP_ATOMIC);
-	if (!bucket)
-		return ERR_PTR(-ENOMEM);
-
-	*bucket =3D *pos;
-	return bucket;
-}
-
-static void *dl_seq_next(struct seq_file *s, void *v, loff_t *pos)
-{
-	struct proc_dir_entry *pde =3D s->private;
-	struct ipt_hashlimit_htable *htable =3D pde->data;
-	unsigned int *bucket =3D (unsigned int *)v;
-
-	*pos =3D ++(*bucket);
-	if (*pos >=3D htable->cfg.size) {
-		kfree(v);
-		return NULL;
-	}
-	return bucket;
-}
-
-static void dl_seq_stop(struct seq_file *s, void *v)
-{
-	struct proc_dir_entry *pde =3D s->private;
-	struct ipt_hashlimit_htable *htable =3D pde->data;
-	unsigned int *bucket =3D (unsigned int *)v;
-
-	kfree(bucket);
-
-	spin_unlock_bh(&htable->lock);
-}
-
-static inline int dl_seq_real_show(struct dsthash_ent *ent, struct seq_f=
ile *s)
-{
-	/* recalculate to show accurate numbers */
-	rateinfo_recalc(ent, jiffies);
-
-	return seq_printf(s, "%ld %u.%u.%u.%u:%u->%u.%u.%u.%u:%u %u %u %u\n",
-			(long)(ent->expires - jiffies)/HZ,
-			NIPQUAD(ent->dst.src_ip), ntohs(ent->dst.src_port),
-			NIPQUAD(ent->dst.dst_ip), ntohs(ent->dst.dst_port),
-			ent->rateinfo.credit, ent->rateinfo.credit_cap,
-			ent->rateinfo.cost);
-}
-
-static int dl_seq_show(struct seq_file *s, void *v)
-{
-	struct proc_dir_entry *pde =3D s->private;
-	struct ipt_hashlimit_htable *htable =3D pde->data;
-	unsigned int *bucket =3D (unsigned int *)v;
-	struct dsthash_ent *ent;
-	struct hlist_node *pos;
-
-	if (!hlist_empty(&htable->hash[*bucket]))
-		hlist_for_each_entry(ent, pos, &htable->hash[*bucket], node) {
-			if (dl_seq_real_show(ent, s)) {
-				/* buffer was filled and unable to print that tuple */
-				return 1;
-			}
-		}
-=09
-	return 0;
-}
-
-static struct seq_operations dl_seq_ops =3D {
-	.start =3D dl_seq_start,
-	.next  =3D dl_seq_next,
-	.stop  =3D dl_seq_stop,
-	.show  =3D dl_seq_show
-};
-
-static int dl_proc_open(struct inode *inode, struct file *file)
-{
-	int ret =3D seq_open(file, &dl_seq_ops);
-
-	if (!ret) {
-		struct seq_file *sf =3D file->private_data;
-		sf->private =3D PDE(inode);
-	}
-	return ret;
-}
-
-static struct file_operations dl_file_ops =3D {
-	.owner   =3D THIS_MODULE,
-	.open    =3D dl_proc_open,
-	.read    =3D seq_read,
-	.llseek  =3D seq_lseek,
-	.release =3D seq_release
-};
-
-static int init_or_fini(int fini)
-{
-	int ret =3D 0;
-
-	if (fini)
-		goto cleanup;
-
-	if (ipt_register_match(&ipt_hashlimit)) {
-		ret =3D -EINVAL;
-		goto cleanup_nothing;
-	}
-
-	hashlimit_cachep =3D kmem_cache_create("ipt_hashlimit",
-					    sizeof(struct dsthash_ent), 0,
-					    0, NULL, NULL);
-	if (!hashlimit_cachep) {
-		printk(KERN_ERR "Unable to create ipt_hashlimit slab cache\n");
-		ret =3D -ENOMEM;
-		goto cleanup_unreg_match;
-	}
-
-	hashlimit_procdir =3D proc_mkdir("ipt_hashlimit", proc_net);
-	if (!hashlimit_procdir) {
-		printk(KERN_ERR "Unable to create proc dir entry\n");
-		ret =3D -ENOMEM;
-		goto cleanup_free_slab;
-	}
-
-	return ret;
-
-cleanup:
-	remove_proc_entry("ipt_hashlimit", proc_net);
-cleanup_free_slab:
-	kmem_cache_destroy(hashlimit_cachep);
-cleanup_unreg_match:
-	ipt_unregister_match(&ipt_hashlimit);
-cleanup_nothing:
-	return ret;
-=09
-}
-
-static int __init ipt_hashlimit_init(void)
-{
-	return init_or_fini(0);
-}
-
-static void __exit ipt_hashlimit_fini(void)
-{
-	init_or_fini(1);
-}
-
-module_init(ipt_hashlimit_init);
-module_exit(ipt_hashlimit_fini);
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index f619c65..7e61254 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -464,5 +464,19 @@ config NETFILTER_XT_MATCH_TCPMSS
=20
 	  To compile it as a module, choose M here.  If unsure, say N.
=20
+config NETFILTER_XT_MATCH_HASHLIMIT
+	tristate '"hashlimit" match support'
+	depends on NETFILTER_XTABLES
+	help
+	  This option adds a `hashlimit' match.
+
+	  As opposed to `limit', this match dynamically creates a hash table
+	  of limit buckets, based on your selection of source/destination
+	  addresses and/or ports.
+
+	  It enables you to express policies like `10kpps for any given
+	  destination address' or `500pps from any given source address'
+	  with a single rule.
+
 endmenu
=20
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index 627105d..b9355a2 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -58,3 +58,4 @@ obj-$(CONFIG_NETFILTER_XT_MATCH_STATISTI
 obj-$(CONFIG_NETFILTER_XT_MATCH_STRING) +=3D xt_string.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_TCPMSS) +=3D xt_tcpmss.o
 obj-$(CONFIG_NETFILTER_XT_MATCH_PHYSDEV) +=3D xt_physdev.o
+obj-$(CONFIG_NETFILTER_XT_MATCH_HASHLIMIT) +=3D xt_hashlimit.o
diff --git a/net/netfilter/xt_hashlimit.c b/net/netfilter/xt_hashlimit.c
new file mode 100644
index 0000000..46de566
--- /dev/null
+++ b/net/netfilter/xt_hashlimit.c
@@ -0,0 +1,772 @@
+/* iptables match extension to limit the number of packets per second
+ * seperately for each hashbucket (sourceip/sourceport/dstip/dstport)
+ *
+ * (C) 2003-2004 by Harald Welte <laforge@netfilter.org>
+ *
+ * $Id: ipt_hashlimit.c 3244 2004-10-20 16:24:29Z laforge@netfilter.org =
$
+ *
+ * Development of this code was funded by Astaro AG, http://www.astaro.c=
om/
+ */
+#include <linux/module.h>
+#include <linux/spinlock.h>
+#include <linux/random.h>
+#include <linux/jhash.h>
+#include <linux/slab.h>
+#include <linux/vmalloc.h>
+#include <linux/proc_fs.h>
+#include <linux/seq_file.h>
+#include <linux/list.h>
+#include <linux/skbuff.h>
+#include <linux/in.h>
+#include <linux/ip.h>
+#include <linux/ipv6.h>
+
+#include <linux/netfilter/x_tables.h>
+#include <linux/netfilter_ipv4/ip_tables.h>
+#include <linux/netfilter_ipv6/ip6_tables.h>
+#include <linux/netfilter/xt_hashlimit.h>
+#include <linux/mutex.h>
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Harald Welte <laforge@netfilter.org>");
+MODULE_DESCRIPTION("iptables match for limiting per hash-bucket");
+MODULE_ALIAS("ipt_hashlimit");
+MODULE_ALIAS("ip6t_hashlimit");
+
+/* need to declare this at the top */
+static struct proc_dir_entry *hashlimit_procdir4;
+static struct proc_dir_entry *hashlimit_procdir6;
+static struct file_operations dl_file_ops;
+
+/* hash table crap */
+struct dsthash_dst {
+	union {
+		struct {
+			__be32 src;
+			__be32 dst;
+		} ip;
+		struct {
+			__be32 src[4];
+			__be32 dst[4];
+		} ip6;
+	} addr;
+	__be16 src_port;
+	__be16 dst_port;
+};
+
+struct dsthash_ent {
+	/* static / read-only parts in the beginning */
+	struct hlist_node node;
+	struct dsthash_dst dst;
+
+	/* modified structure members in the end */
+	unsigned long expires;		/* precalculated expiry time */
+	struct {
+		unsigned long prev;	/* last modification */
+		u_int32_t credit;
+		u_int32_t credit_cap, cost;
+	} rateinfo;
+};
+
+struct xt_hashlimit_htable {
+	struct hlist_node node;		/* global list of all htables */
+	atomic_t use;
+	int family;
+
+	struct hashlimit_cfg cfg;	/* config */
+
+	/* used internally */
+	spinlock_t lock;		/* lock for list_head */
+	u_int32_t rnd;			/* random seed for hash */
+	int rnd_initialized;
+	unsigned int count;		/* number entries in table */
+	struct timer_list timer;	/* timer for gc */
+
+	/* seq_file stuff */
+	struct proc_dir_entry *pde;
+
+	struct hlist_head hash[0];	/* hashtable itself */
+};
+
+static DEFINE_SPINLOCK(hashlimit_lock);	/* protects htables list */
+static DEFINE_MUTEX(hlimit_mutex);	/* additional checkentry protection *=
/
+static HLIST_HEAD(hashlimit_htables);
+static kmem_cache_t *hashlimit_cachep __read_mostly;
+
+static inline int dst_cmp(const struct dsthash_ent *ent, struct dsthash_=
dst *b)
+{
+	return !memcmp(&ent->dst, b, sizeof(ent->dst));
+}
+
+static u_int32_t
+hash_dst(const struct xt_hashlimit_htable *ht, const struct dsthash_dst =
*dst)
+{
+	return jhash(dst, sizeof(*dst), ht->rnd) % ht->cfg.size;
+}
+
+static struct dsthash_ent *
+dsthash_find(const struct xt_hashlimit_htable *ht, struct dsthash_dst *d=
st)
+{
+	struct dsthash_ent *ent;
+	struct hlist_node *pos;
+	u_int32_t hash =3D hash_dst(ht, dst);
+
+	if (!hlist_empty(&ht->hash[hash])) {
+		hlist_for_each_entry(ent, pos, &ht->hash[hash], node)
+			if (dst_cmp(ent, dst))
+				return ent;
+	}
+	return NULL;
+}
+
+/* allocate dsthash_ent, initialize dst, put in htable and lock it */
+static struct dsthash_ent *
+dsthash_alloc_init(struct xt_hashlimit_htable *ht, struct dsthash_dst *d=
st)
+{
+	struct dsthash_ent *ent;
+
+	/* initialize hash with random val at the time we allocate
+	 * the first hashtable entry */
+	if (!ht->rnd_initialized) {
+		get_random_bytes(&ht->rnd, 4);
+		ht->rnd_initialized =3D 1;
+	}
+
+	if (ht->cfg.max && ht->count >=3D ht->cfg.max) {
+		/* FIXME: do something. question is what.. */
+		if (net_ratelimit())
+			printk(KERN_WARNING
+				"xt_hashlimit: max count of %u reached\n",
+				ht->cfg.max);
+		return NULL;
+	}
+
+	ent =3D kmem_cache_alloc(hashlimit_cachep, GFP_ATOMIC);
+	if (!ent) {
+		if (net_ratelimit())
+			printk(KERN_ERR
+				"xt_hashlimit: can't allocate dsthash_ent\n");
+		return NULL;
+	}
+	memcpy(&ent->dst, dst, sizeof(ent->dst));
+
+	hlist_add_head(&ent->node, &ht->hash[hash_dst(ht, dst)]);
+	ht->count++;
+	return ent;
+}
+
+static inline void
+dsthash_free(struct xt_hashlimit_htable *ht, struct dsthash_ent *ent)
+{
+	hlist_del(&ent->node);
+	kmem_cache_free(hashlimit_cachep, ent);
+	ht->count--;
+}
+static void htable_gc(unsigned long htlong);
+
+static int htable_create(struct xt_hashlimit_info *minfo, int family)
+{
+	struct xt_hashlimit_htable *hinfo;
+	unsigned int size;
+	unsigned int i;
+
+	if (minfo->cfg.size)
+		size =3D minfo->cfg.size;
+	else {
+		size =3D ((num_physpages << PAGE_SHIFT) / 16384) /
+		       sizeof(struct list_head);
+		if (num_physpages > (1024 * 1024 * 1024 / PAGE_SIZE))
+			size =3D 8192;
+		if (size < 16)
+			size =3D 16;
+	}
+	/* FIXME: don't use vmalloc() here or anywhere else -HW */
+	hinfo =3D vmalloc(sizeof(struct xt_hashlimit_htable) +
+			sizeof(struct list_head) * size);
+	if (!hinfo) {
+		printk(KERN_ERR "xt_hashlimit: unable to create hashtable\n");
+		return -1;
+	}
+	minfo->hinfo =3D hinfo;
+
+	/* copy match config into hashtable config */
+	memcpy(&hinfo->cfg, &minfo->cfg, sizeof(hinfo->cfg));
+	hinfo->cfg.size =3D size;
+	if (!hinfo->cfg.max)
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
+	hinfo->pde =3D create_proc_entry(minfo->name, 0,
+				       family =3D=3D AF_INET ? hashlimit_procdir4 :
+				       			   hashlimit_procdir6);
+	if (!hinfo->pde) {
+		vfree(hinfo);
+		return -1;
+	}
+	hinfo->pde->proc_fops =3D &dl_file_ops;
+	hinfo->pde->data =3D hinfo;
+
+	init_timer(&hinfo->timer);
+	hinfo->timer.expires =3D jiffies + msecs_to_jiffies(hinfo->cfg.gc_inter=
val);
+	hinfo->timer.data =3D (unsigned long )hinfo;
+	hinfo->timer.function =3D htable_gc;
+	add_timer(&hinfo->timer);
+
+	spin_lock_bh(&hashlimit_lock);
+	hlist_add_head(&hinfo->node, &hashlimit_htables);
+	spin_unlock_bh(&hashlimit_lock);
+
+	return 0;
+}
+
+static int select_all(struct xt_hashlimit_htable *ht, struct dsthash_ent=
 *he)
+{
+	return 1;
+}
+
+static int select_gc(struct xt_hashlimit_htable *ht, struct dsthash_ent =
*he)
+{
+	return (jiffies >=3D he->expires);
+}
+
+static void htable_selective_cleanup(struct xt_hashlimit_htable *ht,
+		 		int (*select)(struct xt_hashlimit_htable *ht,
+					      struct dsthash_ent *he))
+{
+	unsigned int i;
+
+	/* lock hash table and iterate over it */
+	spin_lock_bh(&ht->lock);
+	for (i =3D 0; i < ht->cfg.size; i++) {
+		struct dsthash_ent *dh;
+		struct hlist_node *pos, *n;
+		hlist_for_each_entry_safe(dh, pos, n, &ht->hash[i], node) {
+			if ((*select)(ht, dh))
+				dsthash_free(ht, dh);
+		}
+	}
+	spin_unlock_bh(&ht->lock);
+}
+
+/* hash table garbage collector, run by timer */
+static void htable_gc(unsigned long htlong)
+{
+	struct xt_hashlimit_htable *ht =3D (struct xt_hashlimit_htable *)htlong=
;
+
+	htable_selective_cleanup(ht, select_gc);
+
+	/* re-add the timer accordingly */
+	ht->timer.expires =3D jiffies + msecs_to_jiffies(ht->cfg.gc_interval);
+	add_timer(&ht->timer);
+}
+
+static void htable_destroy(struct xt_hashlimit_htable *hinfo)
+{
+	/* remove timer, if it is pending */
+	if (timer_pending(&hinfo->timer))
+		del_timer(&hinfo->timer);
+
+	/* remove proc entry */
+	remove_proc_entry(hinfo->pde->name,
+			  hinfo->family =3D=3D AF_INET ? hashlimit_procdir4 :
+			  			     hashlimit_procdir6);
+	htable_selective_cleanup(hinfo, select_all);
+	vfree(hinfo);
+}
+
+static struct xt_hashlimit_htable *htable_find_get(char *name, int famil=
y)
+{
+	struct xt_hashlimit_htable *hinfo;
+	struct hlist_node *pos;
+
+	spin_lock_bh(&hashlimit_lock);
+	hlist_for_each_entry(hinfo, pos, &hashlimit_htables, node) {
+		if (!strcmp(name, hinfo->pde->name) &&
+		    hinfo->family =3D=3D family) {
+			atomic_inc(&hinfo->use);
+			spin_unlock_bh(&hashlimit_lock);
+			return hinfo;
+		}
+	}
+	spin_unlock_bh(&hashlimit_lock);
+	return NULL;
+}
+
+static void htable_put(struct xt_hashlimit_htable *hinfo)
+{
+	if (atomic_dec_and_test(&hinfo->use)) {
+		spin_lock_bh(&hashlimit_lock);
+		hlist_del(&hinfo->node);
+		spin_unlock_bh(&hashlimit_lock);
+		htable_destroy(hinfo);
+	}
+}
+
+/* The algorithm used is the Simple Token Bucket Filter (TBF)
+ * see net/sched/sch_tbf.c in the linux source tree
+ */
+
+/* Rusty: This is my (non-mathematically-inclined) understanding of
+   this algorithm.  The `average rate' in jiffies becomes your initial
+   amount of credit `credit' and the most credit you can ever have
+   `credit_cap'.  The `peak rate' becomes the cost of passing the
+   test, `cost'.
+
+   `prev' tracks the last packet hit: you gain one credit per jiffy.
+   If you get credit balance more than this, the extra credit is
+   discarded.  Every time the match passes, you lose `cost' credits;
+   if you don't have that many, the test fails.
+
+   See Alexey's formal explanation in net/sched/sch_tbf.c.
+
+   To get the maximum range, we multiply by this factor (ie. you get N
+   credits per jiffy).  We want to allow a rate as low as 1 per day
+   (slowest userspace tool allows), which means
+   CREDITS_PER_JIFFY*HZ*60*60*24 < 2^32 ie.
+*/
+#define MAX_CPJ (0xFFFFFFFF / (HZ*60*60*24))
+
+/* Repeated shift and or gives us all 1s, final shift and add 1 gives
+ * us the power of 2 below the theoretical max, so GCC simply does a
+ * shift. */
+#define _POW2_BELOW2(x) ((x)|((x)>>1))
+#define _POW2_BELOW4(x) (_POW2_BELOW2(x)|_POW2_BELOW2((x)>>2))
+#define _POW2_BELOW8(x) (_POW2_BELOW4(x)|_POW2_BELOW4((x)>>4))
+#define _POW2_BELOW16(x) (_POW2_BELOW8(x)|_POW2_BELOW8((x)>>8))
+#define _POW2_BELOW32(x) (_POW2_BELOW16(x)|_POW2_BELOW16((x)>>16))
+#define POW2_BELOW32(x) ((_POW2_BELOW32(x)>>1) + 1)
+
+#define CREDITS_PER_JIFFY POW2_BELOW32(MAX_CPJ)
+
+/* Precision saver. */
+static inline u_int32_t
+user2credits(u_int32_t user)
+{
+	/* If multiplying would overflow... */
+	if (user > 0xFFFFFFFF / (HZ*CREDITS_PER_JIFFY))
+		/* Divide first. */
+		return (user / XT_HASHLIMIT_SCALE) * HZ * CREDITS_PER_JIFFY;
+
+	return (user * HZ * CREDITS_PER_JIFFY) / XT_HASHLIMIT_SCALE;
+}
+
+static inline void rateinfo_recalc(struct dsthash_ent *dh, unsigned long=
 now)
+{
+	dh->rateinfo.credit +=3D (now - dh->rateinfo.prev) * CREDITS_PER_JIFFY;
+	if (dh->rateinfo.credit > dh->rateinfo.credit_cap)
+		dh->rateinfo.credit =3D dh->rateinfo.credit_cap;
+	dh->rateinfo.prev =3D now;
+}
+
+static int
+hashlimit_init_dst(struct xt_hashlimit_htable *hinfo, struct dsthash_dst=
 *dst,
+		   const struct sk_buff *skb, unsigned int protoff)
+{
+	__be16 _ports[2], *ports;
+	int nexthdr;
+
+	memset(dst, 0, sizeof(*dst));
+
+	switch (hinfo->family) {
+	case AF_INET:
+		if (hinfo->cfg.mode & XT_HASHLIMIT_HASH_DIP)
+			dst->addr.ip.dst =3D skb->nh.iph->daddr;
+		if (hinfo->cfg.mode & XT_HASHLIMIT_HASH_SIP)
+			dst->addr.ip.src =3D skb->nh.iph->saddr;
+
+		if (!(hinfo->cfg.mode &
+		      (XT_HASHLIMIT_HASH_DPT | XT_HASHLIMIT_HASH_SPT)))
+			return 0;
+		nexthdr =3D skb->nh.iph->protocol;
+		break;
+#if defined(CONFIG_IPV6) || defined(CONFIG_IPV6_MODULE)
+	case AF_INET6:
+		if (hinfo->cfg.mode & XT_HASHLIMIT_HASH_DIP)
+			memcpy(&dst->addr.ip6.dst, &skb->nh.ipv6h->daddr,
+			       sizeof(dst->addr.ip6.dst));
+		if (hinfo->cfg.mode & XT_HASHLIMIT_HASH_SIP)
+			memcpy(&dst->addr.ip6.src, &skb->nh.ipv6h->saddr,
+			       sizeof(dst->addr.ip6.src));
+
+		if (!(hinfo->cfg.mode &
+		      (XT_HASHLIMIT_HASH_DPT | XT_HASHLIMIT_HASH_SPT)))
+			return 0;
+		nexthdr =3D ipv6_find_hdr(skb, &protoff, -1, NULL);
+		if (nexthdr < 0)
+			return -1;
+		break;
+#endif
+	default:
+		BUG();
+		return 0;
+	}
+
+	switch (nexthdr) {
+	case IPPROTO_TCP:
+	case IPPROTO_UDP:
+	case IPPROTO_SCTP:
+	case IPPROTO_DCCP:
+		ports =3D skb_header_pointer(skb, protoff, sizeof(_ports),
+					   &_ports);
+		break;
+	default:
+		_ports[0] =3D _ports[1] =3D 0;
+		ports =3D _ports;
+		break;
+	}
+	if (!ports)
+		return -1;
+	if (hinfo->cfg.mode & XT_HASHLIMIT_HASH_SPT)
+		dst->src_port =3D ports[0];
+	if (hinfo->cfg.mode & XT_HASHLIMIT_HASH_DPT)
+		dst->dst_port =3D ports[1];
+	return 0;
+}
+
+static int
+hashlimit_match(const struct sk_buff *skb,
+		const struct net_device *in,
+		const struct net_device *out,
+		const struct xt_match *match,
+		const void *matchinfo,
+		int offset,
+		unsigned int protoff,
+		int *hotdrop)
+{
+	struct xt_hashlimit_info *r =3D
+		((struct xt_hashlimit_info *)matchinfo)->u.master;
+	struct xt_hashlimit_htable *hinfo =3D r->hinfo;
+	unsigned long now =3D jiffies;
+	struct dsthash_ent *dh;
+	struct dsthash_dst dst;
+
+	if (hashlimit_init_dst(hinfo, &dst, skb, protoff) < 0)
+		goto hotdrop;
+
+	spin_lock_bh(&hinfo->lock);
+	dh =3D dsthash_find(hinfo, &dst);
+	if (!dh) {
+		dh =3D dsthash_alloc_init(hinfo, &dst);
+		if (!dh) {
+			spin_unlock_bh(&hinfo->lock);
+			goto hotdrop;
+		}
+
+		dh->expires =3D jiffies + msecs_to_jiffies(hinfo->cfg.expire);
+		dh->rateinfo.prev =3D jiffies;
+		dh->rateinfo.credit =3D user2credits(hinfo->cfg.avg *
+						   hinfo->cfg.burst);
+		dh->rateinfo.credit_cap =3D user2credits(hinfo->cfg.avg *
+						       hinfo->cfg.burst);
+		dh->rateinfo.cost =3D user2credits(hinfo->cfg.avg);
+	} else {
+		/* update expiration timeout */
+		dh->expires =3D now + msecs_to_jiffies(hinfo->cfg.expire);
+		rateinfo_recalc(dh, now);
+	}
+
+	if (dh->rateinfo.credit >=3D dh->rateinfo.cost) {
+		/* We're underlimit. */
+		dh->rateinfo.credit -=3D dh->rateinfo.cost;
+		spin_unlock_bh(&hinfo->lock);
+		return 1;
+	}
+
+       	spin_unlock_bh(&hinfo->lock);
+
+	/* default case: we're overlimit, thus don't match */
+	return 0;
+
+hotdrop:
+	*hotdrop =3D 1;
+	return 0;
+}
+
+static int
+hashlimit_checkentry(const char *tablename,
+		     const void *inf,
+		     const struct xt_match *match,
+		     void *matchinfo,
+		     unsigned int hook_mask)
+{
+	struct xt_hashlimit_info *r =3D matchinfo;
+
+	/* Check for overflow. */
+	if (r->cfg.burst =3D=3D 0 ||
+	    user2credits(r->cfg.avg * r->cfg.burst) < user2credits(r->cfg.avg))=
 {
+		printk(KERN_ERR "xt_hashlimit: overflow, try lower: %u/%u\n",
+		       r->cfg.avg, r->cfg.burst);
+		return 0;
+	}
+	if (r->cfg.mode =3D=3D 0 ||
+	    r->cfg.mode > (XT_HASHLIMIT_HASH_DPT |
+			   XT_HASHLIMIT_HASH_DIP |
+			   XT_HASHLIMIT_HASH_SIP |
+			   XT_HASHLIMIT_HASH_SPT))
+		return 0;
+	if (!r->cfg.gc_interval)
+		return 0;
+	if (!r->cfg.expire)
+		return 0;
+	if (r->name[sizeof(r->name) - 1] !=3D '\0')
+		return 0;
+
+	/* This is the best we've got: We cannot release and re-grab lock,
+	 * since checkentry() is called before x_tables.c grabs xt_mutex.
+	 * We also cannot grab the hashtable spinlock, since htable_create will
+	 * call vmalloc, and that can sleep.  And we cannot just re-search
+	 * the list of htable's in htable_create(), since then we would
+	 * create duplicate proc files. -HW */
+	mutex_lock(&hlimit_mutex);
+	r->hinfo =3D htable_find_get(r->name, match->family);
+	if (!r->hinfo && htable_create(r, match->family) !=3D 0) {
+		mutex_unlock(&hlimit_mutex);
+		return 0;
+	}
+	mutex_unlock(&hlimit_mutex);
+
+	/* Ugly hack: For SMP, we only want to use one set */
+	r->u.master =3D r;
+	return 1;
+}
+
+static void
+hashlimit_destroy(const struct xt_match *match, void *matchinfo)
+{
+	struct xt_hashlimit_info *r =3D matchinfo;
+
+	htable_put(r->hinfo);
+}
+
+#ifdef CONFIG_COMPAT
+struct compat_xt_hashlimit_info {
+	char name[IFNAMSIZ];
+	struct hashlimit_cfg cfg;
+	compat_uptr_t hinfo;
+	compat_uptr_t master;
+};
+
+static void compat_from_user(void *dst, void *src)
+{
+	int off =3D offsetof(struct compat_xt_hashlimit_info, hinfo);
+
+	memcpy(dst, src, off);
+	memset(dst + off, 0, sizeof(struct compat_xt_hashlimit_info) - off);
+}
+
+static int compat_to_user(void __user *dst, void *src)
+{
+	int off =3D offsetof(struct compat_xt_hashlimit_info, hinfo);
+
+	return copy_to_user(dst, src, off) ? -EFAULT : 0;
+}
+#endif
+
+static struct xt_match xt_hashlimit[] =3D {
+	{
+		.name		=3D "hashlimit",
+		.family		=3D AF_INET,
+		.match		=3D hashlimit_match,
+		.matchsize	=3D sizeof(struct xt_hashlimit_info),
+#ifdef CONFIG_COMPAT
+		.compatsize	=3D sizeof(struct compat_xt_hashlimit_info),
+		.compat_from_user =3D compat_from_user,
+		.compat_to_user	=3D compat_to_user,
+#endif
+		.checkentry	=3D hashlimit_checkentry,
+		.destroy	=3D hashlimit_destroy,
+		.me		=3D THIS_MODULE
+	},
+	{
+		.name		=3D "hashlimit",
+		.family		=3D AF_INET6,
+		.match		=3D hashlimit_match,
+		.matchsize	=3D sizeof(struct xt_hashlimit_info),
+#ifdef CONFIG_COMPAT
+		.compatsize	=3D sizeof(struct compat_xt_hashlimit_info),
+		.compat_from_user =3D compat_from_user,
+		.compat_to_user	=3D compat_to_user,
+#endif
+		.checkentry	=3D hashlimit_checkentry,
+		.destroy	=3D hashlimit_destroy,
+		.me		=3D THIS_MODULE
+	},
+};
+
+/* PROC stuff */
+static void *dl_seq_start(struct seq_file *s, loff_t *pos)
+{
+	struct proc_dir_entry *pde =3D s->private;
+	struct xt_hashlimit_htable *htable =3D pde->data;
+	unsigned int *bucket;
+
+	spin_lock_bh(&htable->lock);
+	if (*pos >=3D htable->cfg.size)
+		return NULL;
+
+	bucket =3D kmalloc(sizeof(unsigned int), GFP_ATOMIC);
+	if (!bucket)
+		return ERR_PTR(-ENOMEM);
+
+	*bucket =3D *pos;
+	return bucket;
+}
+
+static void *dl_seq_next(struct seq_file *s, void *v, loff_t *pos)
+{
+	struct proc_dir_entry *pde =3D s->private;
+	struct xt_hashlimit_htable *htable =3D pde->data;
+	unsigned int *bucket =3D (unsigned int *)v;
+
+	*pos =3D ++(*bucket);
+	if (*pos >=3D htable->cfg.size) {
+		kfree(v);
+		return NULL;
+	}
+	return bucket;
+}
+
+static void dl_seq_stop(struct seq_file *s, void *v)
+{
+	struct proc_dir_entry *pde =3D s->private;
+	struct xt_hashlimit_htable *htable =3D pde->data;
+	unsigned int *bucket =3D (unsigned int *)v;
+
+	kfree(bucket);
+	spin_unlock_bh(&htable->lock);
+}
+
+static int dl_seq_real_show(struct dsthash_ent *ent, int family,
+				   struct seq_file *s)
+{
+	/* recalculate to show accurate numbers */
+	rateinfo_recalc(ent, jiffies);
+
+	switch (family) {
+	case AF_INET:
+		return seq_printf(s, "%ld %u.%u.%u.%u:%u->"
+				     "%u.%u.%u.%u:%u %u %u %u\n",
+				 (long)(ent->expires - jiffies)/HZ,
+				 NIPQUAD(ent->dst.addr.ip.src),
+				 ntohs(ent->dst.src_port),
+				 NIPQUAD(ent->dst.addr.ip.dst),
+				 ntohs(ent->dst.dst_port),
+				 ent->rateinfo.credit, ent->rateinfo.credit_cap,
+				 ent->rateinfo.cost);
+	case AF_INET6:
+		return seq_printf(s, "%ld " NIP6_FMT ":%u->"
+				     NIP6_FMT ":%u %u %u %u\n",
+				 (long)(ent->expires - jiffies)/HZ,
+				 NIP6(*(struct in6_addr *)&ent->dst.addr.ip6.src),
+				 ntohs(ent->dst.src_port),
+				 NIP6(*(struct in6_addr *)&ent->dst.addr.ip6.dst),
+				 ntohs(ent->dst.dst_port),
+				 ent->rateinfo.credit, ent->rateinfo.credit_cap,
+				 ent->rateinfo.cost);
+	default:
+		BUG();
+		return 0;
+	}
+}
+
+static int dl_seq_show(struct seq_file *s, void *v)
+{
+	struct proc_dir_entry *pde =3D s->private;
+	struct xt_hashlimit_htable *htable =3D pde->data;
+	unsigned int *bucket =3D (unsigned int *)v;
+	struct dsthash_ent *ent;
+	struct hlist_node *pos;
+
+	if (!hlist_empty(&htable->hash[*bucket])) {
+		hlist_for_each_entry(ent, pos, &htable->hash[*bucket], node)
+			if (dl_seq_real_show(ent, htable->family, s))
+				return 1;
+	}
+	return 0;
+}
+
+static struct seq_operations dl_seq_ops =3D {
+	.start =3D dl_seq_start,
+	.next  =3D dl_seq_next,
+	.stop  =3D dl_seq_stop,
+	.show  =3D dl_seq_show
+};
+
+static int dl_proc_open(struct inode *inode, struct file *file)
+{
+	int ret =3D seq_open(file, &dl_seq_ops);
+
+	if (!ret) {
+		struct seq_file *sf =3D file->private_data;
+		sf->private =3D PDE(inode);
+	}
+	return ret;
+}
+
+static struct file_operations dl_file_ops =3D {
+	.owner   =3D THIS_MODULE,
+	.open    =3D dl_proc_open,
+	.read    =3D seq_read,
+	.llseek  =3D seq_lseek,
+	.release =3D seq_release
+};
+
+static int __init xt_hashlimit_init(void)
+{
+	int err;
+
+	err =3D xt_register_matches(xt_hashlimit, ARRAY_SIZE(xt_hashlimit));
+	if (err < 0)
+		goto err1;
+
+	err =3D -ENOMEM;
+	hashlimit_cachep =3D kmem_cache_create("xt_hashlimit",
+					    sizeof(struct dsthash_ent), 0, 0,
+					    NULL, NULL);
+	if (!hashlimit_cachep) {
+		printk(KERN_ERR "xt_hashlimit: unable to create slab cache\n");
+		goto err2;
+	}
+	hashlimit_procdir4 =3D proc_mkdir("ipt_hashlimit", proc_net);
+	if (!hashlimit_procdir4) {
+		printk(KERN_ERR "xt_hashlimit: unable to create proc dir "
+				"entry\n");
+		goto err3;
+	}
+	hashlimit_procdir6 =3D proc_mkdir("ip6t_hashlimit", proc_net);
+	if (!hashlimit_procdir6) {
+		printk(KERN_ERR "xt_hashlimit: tnable to create proc dir "
+				"entry\n");
+		goto err4;
+	}
+	return 0;
+err4:
+	remove_proc_entry("ipt_hashlimit", proc_net);
+err3:
+	kmem_cache_destroy(hashlimit_cachep);
+err2:
+	xt_unregister_matches(xt_hashlimit, ARRAY_SIZE(xt_hashlimit));
+err1:
+	return err;
+
+}
+
+static void __exit xt_hashlimit_fini(void)
+{
+	remove_proc_entry("ipt_hashlimit", proc_net);
+	remove_proc_entry("ip6t_hashlimit", proc_net);
+	kmem_cache_destroy(hashlimit_cachep);
+	xt_unregister_matches(xt_hashlimit, ARRAY_SIZE(xt_hashlimit));
+}
+
+module_init(xt_hashlimit_init);
+module_exit(xt_hashlimit_fini);

--------------030402010006060109070306--
