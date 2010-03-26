From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: debugging kernel during packet drops
Date: Fri, 26 Mar 2010 12:21:48 +0100
Message-ID: <1269602508.2839.16.camel@edumazet-laptop>
References: <4BA74950.6000305@infopact.nl> <4BA7A5D8.5080101@trash.net>
	 <4BA8DAC5.6050002@infopact.nl> <1269364893.2983.296.camel@edumazet-laptop>
	 <4BAA2DC5.7000409@infopact.nl>  <1269447674.3213.64.camel@edumazet-laptop>
	 <1269509574.3626.9.camel@edumazet-laptop>  <4BAC8F42.7090706@infopact.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Jorrit Kronjee <j.kronjee@infopact.nl>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-bw0-f209.google.com ([209.85.218.209]:37379 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753232Ab0CZLVz (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 26 Mar 2010 07:21:55 -0400
Received: by bwz1 with SMTP id 1so1696722bwz.21
        for <netfilter-devel@vger.kernel.org>; Fri, 26 Mar 2010 04:21:54 -0700 (PDT)
In-Reply-To: <4BAC8F42.7090706@infopact.nl>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Le vendredi 26 mars 2010 =C3=A0 11:41 +0100, Jorrit Kronjee a =C3=A9cri=
t :
>   =20
> Eric,
>=20

Hi Jorrit

> Awesome work, thanks for the effort! I've tried the patch and got som=
e
> results. The drop rate was reduced dramatically after I activated RPS=
=2E
>=20
> I did the same test I did before, namely I rebooted and started flood=
ing
> the machine immediately after with 300 kpps. After 5 minutes, perf to=
p
> looked like this:
>=20
> ---------------------------------------------------------------------=
----------------------------------------------------
>    PerfTop:    1962 irqs/sec  kernel:99.3% [1000Hz cycles],  (all, 4 =
CPUs)
> ---------------------------------------------------------------------=
----------------------------------------------------
>=20

we can see cpu power is better used now


>              samples  pcnt function                 DSO
>              _______ _____ ________________________
> _____________________________________________________________________
>=20
>              4501.00 14.0% __ticket_spin_lock     =20
> /lib/modules/2.6.34-rc1-net-next/build/vmlinux

strange... it could be goot to try a callgraph report to check where we
spend so much time in spinlock

>              2985.00  9.3% dsthash_find           =20
> /lib/modules/2.6.34-rc1-net-next/kernel/net/netfilter/xt_hashlimit.ko
>              2346.00  7.3% __ticket_spin_unlock   =20
> /lib/modules/2.6.34-rc1-net-next/build/vmlinux
>              1354.00  4.2% e1000_xmit_frame       =20
> /lib/modules/2.6.34-rc1-net-next/kernel/drivers/net/e1000e/e1000e.ko
>              1070.00  3.3% __slab_free            =20
> /lib/modules/2.6.34-rc1-net-next/build/vmlinux
>               997.00  3.1% memcpy                 =20
> /lib/modules/2.6.34-rc1-net-next/build/vmlinux
>               809.00  2.5% dev_queue_xmit         =20
> /lib/modules/2.6.34-rc1-net-next/build/vmlinux
>               791.00  2.5% nf_iterate             =20
> /lib/modules/2.6.34-rc1-net-next/build/vmlinux
>               705.00  2.2% e1000_clean_tx_irq     =20
> /lib/modules/2.6.34-rc1-net-next/kernel/drivers/net/e1000e/e1000e.ko
>               634.00  2.0% nf_hook_slow           =20
> /lib/modules/2.6.34-rc1-net-next/build/vmlinux
>               624.00  1.9% skb_release_head_state =20
> /lib/modules/2.6.34-rc1-net-next/build/vmlinux
>               584.00  1.8% e1000_intr             =20
> /lib/modules/2.6.34-rc1-net-next/kernel/drivers/net/e1000/e1000.ko
>               536.00  1.7% br_nf_pre_routing_finish
> /lib/modules/2.6.34-rc1-net-next/kernel/net/bridge/bridge.ko
>               528.00  1.6% nommu_map_page         =20
> /lib/modules/2.6.34-rc1-net-next/build/vmlinux
>               499.00  1.6% kfree                  =20
> /lib/modules/2.6.34-rc1-net-next/build/vmlinux
>               494.00  1.5% __netif_receive_skb    =20
> /lib/modules/2.6.34-rc1-net-next/build/vmlinux
>               472.00  1.5% __alloc_skb            =20
> /lib/modules/2.6.34-rc1-net-next/build/vmlinux
>               448.00  1.4% br_fdb_update          =20
> /lib/modules/2.6.34-rc1-net-next/kernel/net/bridge/bridge.ko
>               437.00  1.4% __slab_alloc           =20
> /lib/modules/2.6.34-rc1-net-next/build/vmlinux
>               428.00  1.3% ipt_do_table             [ip_tables]
>               403.00  1.3% memset                 =20
> /lib/modules/2.6.34-rc1-net-next/build/vmlinux
>               402.00  1.3% br_handle_frame        =20
> /lib/modules/2.6.34-rc1-net-next/kernel/net/bridge/bridge.ko
>               389.00  1.2% e1000_clean_rx_irq     =20
> /lib/modules/2.6.34-rc1-net-next/kernel/drivers/net/e1000/e1000.ko
>               388.00  1.2% e1000_clean            =20
> /lib/modules/2.6.34-rc1-net-next/kernel/drivers/net/e1000/e1000.ko
>               381.00  1.2% uhci_irq               =20
> /lib/modules/2.6.34-rc1-net-next/build/vmlinux
>               366.00  1.1% get_rps_cpu            =20
> /lib/modules/2.6.34-rc1-net-next/build/vmlinux
>               365.00  1.1% br_nf_pre_routing      =20
> /lib/modules/2.6.34-rc1-net-next/kernel/net/bridge/bridge.ko
>               349.00  1.1% dst_release            =20
> /lib/modules/2.6.34-rc1-net-next/build/vmlinux
>=20
> And iptables-save -c produced this:
> # Generated by iptables-save v1.4.4 on Fri Mar 26 11:24:59 2010
> *filter
> :INPUT ACCEPT [1043:60514]
> :FORWARD ACCEPT [0:0]
> :OUTPUT ACCEPT [942:282723]
> [99563191:3783420610] -A FORWARD -m hashlimit --hashlimit-upto 10000/=
sec
> --hashlimit-burst 100 --hashlimit-mode dstip --hashlimit-name hashtab=
le
> --hashlimit-htable-max 131072 --hashlimit-htable-expire 1000 -j ACCEP=
T

Hmm, maybe you should add --hashlimit-htable-size 32768  (or 65536)

Because the default is probably too small for your case.

> [0:0] -A FORWARD -m limit --limit 5/sec -j LOG --log-prefix "HASHLIMI=
TED
> -- "
> [0:0] -A FORWARD -j DROP
> COMMIT
> # Completed on Fri Mar 26 11:24:59 2010
>=20
> And /proc/interrupts looked like this:
>      CPU0       CPU1       CPU2       CPU3
>   0:         47          0          1          0   IO-APIC-edge      =
timer
>   1:          0          1          0          1   IO-APIC-edge      =
i8042
>   6:          1          1          0          0   IO-APIC-edge      =
floppy
>   8:          1          0          0          0   IO-APIC-edge      =
rtc0
>   9:          0          0          0          0   IO-APIC-fasteoi   =
acpi
>  12:          0          1          1          2   IO-APIC-edge      =
i8042
>  14:         21         22         22         21   IO-APIC-edge    =20
> ata_piix
>  15:          0          0          0          0   IO-APIC-edge    =20
> ata_piix
>  16:        492        464        463        474   IO-APIC-fasteoi   =
arcmsr
>  17:          0          0          0          0   IO-APIC-fasteoi =20
> ehci_hcd:usb1
>  18:     971171     971391     948171     948663   IO-APIC-fasteoi =20
> uhci_hcd:usb3, uhci_hcd:usb7, eth3
>  19:          0          0          0          0   IO-APIC-fasteoi =20
> uhci_hcd:usb6
>  21:          0          0          0          0   IO-APIC-fasteoi =20
> ata_piix, uhci_hcd:usb4
>  23:          1          0          1          0   IO-APIC-fasteoi =20
> ehci_hcd:usb2, uhci_hcd:usb5
>  27:    1003145    1002952    1026174    1025671   PCI-MSI-edge      =
eth4
> NMI:     202553     185135     134999     185071   Non-maskable inter=
rupts
> LOC:      20270      19227      17387      23282   Local timer interr=
upts
> SPU:          0          0          0          0   Spurious interrupt=
s
> PMI:     202553     185135     134999     185071   Performance
> monitoring interrupts
> PND:     201464     183939     134067     184098   Performance pendin=
g work
> RES:       2216       2449       1212       1432   Rescheduling inter=
rupts
> CAL:    2223380    2226493    2233481    2228957   Function call inte=
rrupts
> TLB:        606        584       1274       1216   TLB shootdowns
> TRM:          0          0          0          0   Thermal event inte=
rrupts
> THR:          0          0          0          0   Threshold APIC int=
errupts
> MCE:          0          0          0          0   Machine check exce=
ptions
> MCP:          2          2          2          2   Machine check poll=
s
> ERR:          3
> MIS:          0
>=20
> ifconfig reported only 2 drops after these 5 minutes. I'm thinking ab=
out
> removing/changing the hashing algorithm to make dsthash_find faster. =
All
> I need after all is a match against a destination IP address. Also, I=
'd
> like the limit of 10kpps to be a bit higher. I'll see if I can work o=
n
> that during the weekend.
>=20

Nice !

I have another patch version (but not yet tested) that now is able to
make dynamic key, so that its length is shortened. In your case, only
dst is matched, key length is one u32.

So time to build key is short, time to compare is also short (not using
slow memcmp())

Its probably buggy as hell, dont even try it !

diff --git a/net/netfilter/xt_hashlimit.c b/net/netfilter/xt_hashlimit.=
c
index 9e9c489..09211fa 100644
--- a/net/netfilter/xt_hashlimit.c
+++ b/net/netfilter/xt_hashlimit.c
@@ -41,6 +41,54 @@ MODULE_DESCRIPTION("Xtables: per hash-bucket rate-li=
mit match");
 MODULE_ALIAS("ipt_hashlimit");
 MODULE_ALIAS("ip6t_hashlimit");
=20
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
 struct hashlimit_net {
 	struct hlist_head	htables;
 	struct proc_dir_entry	*ipt_hashlimit;
@@ -56,36 +104,23 @@ static inline struct hashlimit_net *hashlimit_pern=
et(struct net *net)
 /* need to declare this at the top */
 static const struct file_operations dl_file_ops;
=20
-/* hash table crap */
-struct dsthash_dst {
-	union {
-		struct {
-			__be32 src;
-			__be32 dst;
-		} ip;
 #if defined(CONFIG_IP6_NF_IPTABLES) || defined(CONFIG_IP6_NF_IPTABLES_=
MODULE)
-		struct {
-			__be32 src[4];
-			__be32 dst[4];
-		} ip6;
+#define MAXKEYSIZE (4 + 4 + 1)
+#else
+#define MAXKEYSIZE (1 + 1 + 1)
 #endif
-	};
-	__be16 src_port;
-	__be16 dst_port;
-};
=20
 struct dsthash_ent {
-	/* static / read-only parts in the beginning */
-	struct hlist_node node;
-	struct dsthash_dst dst;
-
-	/* modified structure members in the end */
+	struct rcu_head rcu;
+	spinlock_t lock;
 	unsigned long expires;		/* precalculated expiry time */
 	struct {
 		unsigned long prev;	/* last modification */
 		u_int32_t credit;
-		u_int32_t credit_cap, cost;
+		u_int32_t cost;
 	} rateinfo;
+	struct hlist_node node;
+	u32    key[MAXKEYSIZE];
 };
=20
 struct xt_hashlimit_htable {
@@ -95,10 +130,13 @@ struct xt_hashlimit_htable {
 	bool rnd_initialized;
=20
 	struct hashlimit_cfg1 cfg;	/* config */
-
+	u_int32_t credit_cap;
+	__be32    ndstmask;
+	__be32    nsrcmask;
 	/* used internally */
-	spinlock_t lock;		/* lock for list_head */
 	u_int32_t rnd;			/* random seed for hash */
+	unsigned int sz32;		/* number of u32 in key[0] */
+	spinlock_t hlock;		/* lock for writes to hash[]/count/rnd */
 	unsigned int count;		/* number entries in table */
 	struct timer_list timer;	/* timer for gc */
=20
@@ -112,18 +150,19 @@ struct xt_hashlimit_htable {
 static DEFINE_MUTEX(hashlimit_mutex);	/* protects htables list */
 static struct kmem_cache *hashlimit_cachep __read_mostly;
=20
-static inline bool dst_cmp(const struct dsthash_ent *ent,
-			   const struct dsthash_dst *b)
+static bool key_cmp(const struct dsthash_ent *ent, const u32 *key,
+		    unsigned int sz32)
 {
-	return !memcmp(&ent->dst, b, sizeof(ent->dst));
+	unsigned int i;
+	u32 res =3D 0;
+	for (i =3D 0; i < sz32; i++)
+		res |=3D (ent->key[i] ^ key[i]);
+	return res =3D=3D 0;
 }
=20
-static u_int32_t
-hash_dst(const struct xt_hashlimit_htable *ht, const struct dsthash_ds=
t *dst)
+static u32 hash_func(const struct xt_hashlimit_htable *ht, const u32 *=
key)
 {
-	u_int32_t hash =3D jhash2((const u32 *)dst,
-				sizeof(*dst)/sizeof(u32),
-				ht->rnd);
+	u32 hash =3D jhash2(key, ht->sz32, ht->rnd);
 	/*
 	 * Instead of returning hash % ht->cfg.size (implying a divide)
 	 * we return the high 32 bits of the (hash * ht->cfg.size) that will
@@ -135,62 +174,32 @@ hash_dst(const struct xt_hashlimit_htable *ht, co=
nst struct dsthash_dst *dst)
=20
 static struct dsthash_ent *
 dsthash_find(const struct xt_hashlimit_htable *ht,
-	     const struct dsthash_dst *dst)
+	     const u32 *key, u32 hash)
 {
 	struct dsthash_ent *ent;
 	struct hlist_node *pos;
-	u_int32_t hash =3D hash_dst(ht, dst);
=20
-	if (!hlist_empty(&ht->hash[hash])) {
-		hlist_for_each_entry(ent, pos, &ht->hash[hash], node)
-			if (dst_cmp(ent, dst))
-				return ent;
-	}
+	hlist_for_each_entry_rcu(ent, pos, &ht->hash[hash], node)
+		if (key_cmp(ent, key, ht->sz32)) {
+			spin_lock(&ent->lock);
+			return ent;
+		}
+
 	return NULL;
 }
=20
-/* allocate dsthash_ent, initialize dst, put in htable and lock it */
-static struct dsthash_ent *
-dsthash_alloc_init(struct xt_hashlimit_htable *ht,
-		   const struct dsthash_dst *dst)
-{
-	struct dsthash_ent *ent;
-
-	/* initialize hash with random val at the time we allocate
-	 * the first hashtable entry */
-	if (!ht->rnd_initialized) {
-		get_random_bytes(&ht->rnd, sizeof(ht->rnd));
-		ht->rnd_initialized =3D true;
-	}
-
-	if (ht->cfg.max && ht->count >=3D ht->cfg.max) {
-		/* FIXME: do something. question is what.. */
-		if (net_ratelimit())
-			printk(KERN_WARNING
-				"xt_hashlimit: max count of %u reached\n",
-				ht->cfg.max);
-		return NULL;
-	}
=20
-	ent =3D kmem_cache_alloc(hashlimit_cachep, GFP_ATOMIC);
-	if (!ent) {
-		if (net_ratelimit())
-			printk(KERN_ERR
-				"xt_hashlimit: can't allocate dsthash_ent\n");
-		return NULL;
-	}
-	memcpy(&ent->dst, dst, sizeof(ent->dst));
+static void dsthash_free_rcu(struct rcu_head *head)
+{
+	struct dsthash_ent *ent =3D container_of(head, struct dsthash_ent, rc=
u);
=20
-	hlist_add_head(&ent->node, &ht->hash[hash_dst(ht, dst)]);
-	ht->count++;
-	return ent;
+	kmem_cache_free(hashlimit_cachep, ent);
 }
=20
-static inline void
-dsthash_free(struct xt_hashlimit_htable *ht, struct dsthash_ent *ent)
+static void dsthash_free(struct xt_hashlimit_htable *ht, struct dsthas=
h_ent *ent)
 {
-	hlist_del(&ent->node);
-	kmem_cache_free(hashlimit_cachep, ent);
+	hlist_del_rcu(&ent->node);
+	call_rcu_bh(&ent->rcu, dsthash_free_rcu);
 	ht->count--;
 }
 static void htable_gc(unsigned long htlong);
@@ -216,7 +225,7 @@ static int htable_create_v0(struct net *net, struct=
 xt_hashlimit_info *minfo, u_
 	hinfo =3D vmalloc(sizeof(struct xt_hashlimit_htable) +
 			sizeof(struct list_head) * size);
 	if (!hinfo) {
-		printk(KERN_ERR "xt_hashlimit: unable to create hashtable\n");
+		pr_err("xt_hashlimit: unable to create hashtable\n");
 		return -1;
 	}
 	minfo->hinfo =3D hinfo;
@@ -229,9 +238,10 @@ static int htable_create_v0(struct net *net, struc=
t xt_hashlimit_info *minfo, u_
 	hinfo->cfg.gc_interval =3D minfo->cfg.gc_interval;
 	hinfo->cfg.expire      =3D minfo->cfg.expire;
=20
-	if (family =3D=3D NFPROTO_IPV4)
+	if (family =3D=3D NFPROTO_IPV4) {
 		hinfo->cfg.srcmask =3D hinfo->cfg.dstmask =3D 32;
-	else
+		hinfo->nsrcmask =3D hinfo->ndstmask =3D 0xFFFFFFFF;
+	} else
 		hinfo->cfg.srcmask =3D hinfo->cfg.dstmask =3D 128;
=20
 	hinfo->cfg.size =3D size;
@@ -243,11 +253,16 @@ static int htable_create_v0(struct net *net, stru=
ct xt_hashlimit_info *minfo, u_
 	for (i =3D 0; i < hinfo->cfg.size; i++)
 		INIT_HLIST_HEAD(&hinfo->hash[i]);
=20
+	hinfo->credit_cap =3D user2credits(hinfo->cfg.avg * hinfo->cfg.burst)=
;
 	hinfo->use =3D 1;
 	hinfo->count =3D 0;
 	hinfo->family =3D family;
 	hinfo->rnd_initialized =3D false;
-	spin_lock_init(&hinfo->lock);
+
+	hinfo->sz32 =3D (family =3D=3D NFPROTO_IPV4) ? (1 + 1) : (4 + 4);=20
+	if (hinfo->cfg.mode & (XT_HASHLIMIT_HASH_DPT | XT_HASHLIMIT_HASH_SPT)=
)
+		hinfo->sz32++;
+	spin_lock_init(&hinfo->hlock);
 	hinfo->pde =3D proc_create_data(minfo->name, 0,
 		(family =3D=3D NFPROTO_IPV4) ?
 		hashlimit_net->ipt_hashlimit : hashlimit_net->ip6t_hashlimit,
@@ -289,7 +304,7 @@ static int htable_create(struct net *net, struct xt=
_hashlimit_mtinfo1 *minfo,
 	hinfo =3D vmalloc(sizeof(struct xt_hashlimit_htable) +
 	                sizeof(struct list_head) * size);
 	if (hinfo =3D=3D NULL) {
-		printk(KERN_ERR "xt_hashlimit: unable to create hashtable\n");
+		pr_err("xt_hashlimit: unable to create hashtable\n");
 		return -1;
 	}
 	minfo->hinfo =3D hinfo;
@@ -302,14 +317,22 @@ static int htable_create(struct net *net, struct =
xt_hashlimit_mtinfo1 *minfo,
 	else if (hinfo->cfg.max < hinfo->cfg.size)
 		hinfo->cfg.max =3D hinfo->cfg.size;
=20
+	if (family =3D=3D NFPROTO_IPV4) {
+		hinfo->nsrcmask =3D htonl(~0 << (32 - hinfo->cfg.srcmask));
+		hinfo->ndstmask =3D htonl(~0 << (32 - hinfo->cfg.dstmask));
+	}
 	for (i =3D 0; i < hinfo->cfg.size; i++)
 		INIT_HLIST_HEAD(&hinfo->hash[i]);
=20
+	hinfo->credit_cap =3D user2credits(hinfo->cfg.avg * hinfo->cfg.burst)=
;
 	hinfo->use =3D 1;
 	hinfo->count =3D 0;
 	hinfo->family =3D family;
 	hinfo->rnd_initialized =3D false;
-	spin_lock_init(&hinfo->lock);
+	hinfo->sz32 =3D (family =3D=3D NFPROTO_IPV4) ? (1 + 1) : (4 + 4);=20
+	if (hinfo->cfg.mode & (XT_HASHLIMIT_HASH_DPT | XT_HASHLIMIT_HASH_SPT)=
)
+		hinfo->sz32++;
+	spin_lock_init(&hinfo->hlock);
=20
 	hinfo->pde =3D proc_create_data(minfo->name, 0,
 		(family =3D=3D NFPROTO_IPV4) ?
@@ -349,7 +372,7 @@ static void htable_selective_cleanup(struct xt_hash=
limit_htable *ht,
 	unsigned int i;
=20
 	/* lock hash table and iterate over it */
-	spin_lock_bh(&ht->lock);
+	spin_lock_bh(&ht->hlock);
 	for (i =3D 0; i < ht->cfg.size; i++) {
 		struct dsthash_ent *dh;
 		struct hlist_node *pos, *n;
@@ -358,7 +381,7 @@ static void htable_selective_cleanup(struct xt_hash=
limit_htable *ht,
 				dsthash_free(ht, dh);
 		}
 	}
-	spin_unlock_bh(&ht->lock);
+	spin_unlock_bh(&ht->hlock);
 }
=20
 /* hash table garbage collector, run by timer */
@@ -417,109 +440,54 @@ static void htable_put(struct xt_hashlimit_htabl=
e *hinfo)
 	mutex_unlock(&hashlimit_mutex);
 }
=20
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
-		return (user / XT_HASHLIMIT_SCALE) * HZ * CREDITS_PER_JIFFY;
-
-	return (user * HZ * CREDITS_PER_JIFFY) / XT_HASHLIMIT_SCALE;
-}
-
-static inline void rateinfo_recalc(struct dsthash_ent *dh, unsigned lo=
ng now)
+static inline void rateinfo_recalc(struct dsthash_ent *dh, unsigned lo=
ng now,
+				   struct xt_hashlimit_htable *hinfo)
 {
 	dh->rateinfo.credit +=3D (now - dh->rateinfo.prev) * CREDITS_PER_JIFF=
Y;
-	if (dh->rateinfo.credit > dh->rateinfo.credit_cap)
-		dh->rateinfo.credit =3D dh->rateinfo.credit_cap;
+	if (dh->rateinfo.credit > hinfo->credit_cap)
+		dh->rateinfo.credit =3D hinfo->credit_cap;
 	dh->rateinfo.prev =3D now;
 }
=20
-static inline __be32 maskl(__be32 a, unsigned int l)
+#if defined(CONFIG_IP6_NF_IPTABLES) || defined(CONFIG_IP6_NF_IPTABLES_=
MODULE)
+static u32 *ipv6_addr_partial_copy(u32 *key, __be32 *addr,
+				   unsigned int leading_words, __be32 lastmask)
 {
-	return l ? htonl(ntohl(a) & ~0 << (32 - l)) : 0;
+	switch (leading_words) {
+	case 3: *key++ =3D *addr++;
+	case 2: *key++ =3D *addr++;
+	case 1: *key++ =3D *addr++;
+	}
+	*key++ =3D lastmask & *addr;
+	return key;
 }
=20
-#if defined(CONFIG_IP6_NF_IPTABLES) || defined(CONFIG_IP6_NF_IPTABLES_=
MODULE)
-static void hashlimit_ipv6_mask(__be32 *i, unsigned int p)
+static const u32 *ipv6_addr_rebuild(const u32 *key, __be32 *addr, unsi=
gned int leading_words)
 {
-	switch (p) {
-	case 0 ... 31:
-		i[0] =3D maskl(i[0], p);
-		i[1] =3D i[2] =3D i[3] =3D 0;
-		break;
-	case 32 ... 63:
-		i[1] =3D maskl(i[1], p - 32);
-		i[2] =3D i[3] =3D 0;
-		break;
-	case 64 ... 95:
-		i[2] =3D maskl(i[2], p - 64);
-		i[3] =3D 0;
-	case 96 ... 127:
-		i[3] =3D maskl(i[3], p - 96);
-		break;
-	case 128:
-		break;
+	memset(addr, 0, 16);
+
+	while (leading_words) {
+		*addr++ =3D *key++;
+		leading_words--;
 	}
+	*addr =3D *key++;
+	return key;
 }
 #endif
=20
 static int
-hashlimit_init_dst(const struct xt_hashlimit_htable *hinfo,
-		   struct dsthash_dst *dst,
+hashlimit_init_key(const struct xt_hashlimit_htable *hinfo, u32 *key,
 		   const struct sk_buff *skb, unsigned int protoff)
 {
 	__be16 _ports[2], *ports;
 	u8 nexthdr;
=20
-	memset(dst, 0, sizeof(*dst));
-
 	switch (hinfo->family) {
 	case NFPROTO_IPV4:
 		if (hinfo->cfg.mode & XT_HASHLIMIT_HASH_DIP)
-			dst->ip.dst =3D maskl(ip_hdr(skb)->daddr,
-			              hinfo->cfg.dstmask);
+			*key++ =3D ip_hdr(skb)->daddr & hinfo->ndstmask;
 		if (hinfo->cfg.mode & XT_HASHLIMIT_HASH_SIP)
-			dst->ip.src =3D maskl(ip_hdr(skb)->saddr,
-			              hinfo->cfg.srcmask);
+			*key++ =3D ip_hdr(skb)->saddr & hinfo->nsrcmask;
=20
 		if (!(hinfo->cfg.mode &
 		      (XT_HASHLIMIT_HASH_DPT | XT_HASHLIMIT_HASH_SPT)))
@@ -528,16 +496,14 @@ hashlimit_init_dst(const struct xt_hashlimit_htab=
le *hinfo,
 		break;
 #if defined(CONFIG_IP6_NF_IPTABLES) || defined(CONFIG_IP6_NF_IPTABLES_=
MODULE)
 	case NFPROTO_IPV6:
-		if (hinfo->cfg.mode & XT_HASHLIMIT_HASH_DIP) {
-			memcpy(&dst->ip6.dst, &ipv6_hdr(skb)->daddr,
-			       sizeof(dst->ip6.dst));
-			hashlimit_ipv6_mask(dst->ip6.dst, hinfo->cfg.dstmask);
-		}
-		if (hinfo->cfg.mode & XT_HASHLIMIT_HASH_SIP) {
-			memcpy(&dst->ip6.src, &ipv6_hdr(skb)->saddr,
-			       sizeof(dst->ip6.src));
-			hashlimit_ipv6_mask(dst->ip6.src, hinfo->cfg.srcmask);
-		}
+		if (hinfo->cfg.mode & XT_HASHLIMIT_HASH_DIP)
+			key =3D ipv6_addr_partial_copy(key, ipv6_hdr(skb)->daddr.s6_addr32,
+						     hinfo->cfg.dstmask >> 5,
+						     hinfo->ndstmask);
+		if (hinfo->cfg.mode & XT_HASHLIMIT_HASH_SIP)
+			key =3D ipv6_addr_partial_copy(key, ipv6_hdr(skb)->saddr.s6_addr32,
+						     hinfo->cfg.srcmask >> 5,
+						     hinfo->nsrcmask);
=20
 		if (!(hinfo->cfg.mode &
 		      (XT_HASHLIMIT_HASH_DPT | XT_HASHLIMIT_HASH_SPT)))
@@ -563,19 +529,60 @@ hashlimit_init_dst(const struct xt_hashlimit_htab=
le *hinfo,
 					   &_ports);
 		break;
 	default:
-		_ports[0] =3D _ports[1] =3D 0;
-		ports =3D _ports;
-		break;
+		return 0;
 	}
 	if (!ports)
 		return -1;
-	if (hinfo->cfg.mode & XT_HASHLIMIT_HASH_SPT)
-		dst->src_port =3D ports[0];
+	*key =3D (hinfo->cfg.mode & XT_HASHLIMIT_HASH_SPT) ? (ports[0] << 16)=
 : 0;
 	if (hinfo->cfg.mode & XT_HASHLIMIT_HASH_DPT)
-		dst->dst_port =3D ports[1];
+		*key |=3D ports[1];
 	return 0;
 }
=20
+/* allocate dsthash_ent, initialize dst, put in htable and lock it */
+static struct dsthash_ent *
+dsthash_alloc_init(struct xt_hashlimit_htable *ht,
+		   const u32 *key, u32 hash)
+{
+	struct dsthash_ent *ent =3D NULL;
+
+	spin_lock(&ht->hlock);
+
+	/* initialize hash with random val at the time we allocate
+	 * the first hashtable entry. In this case, recompute hash value.
+	 */
+	if (unlikely(!ht->rnd_initialized)) {
+		get_random_bytes(&ht->rnd, sizeof(ht->rnd));
+		ht->rnd_initialized =3D true;
+		hash =3D hash_func(ht, key);
+	}
+
+	if (ht->cfg.max && ht->count >=3D ht->cfg.max) {
+		/* FIXME: do something. question is what.. */
+		if (net_ratelimit())
+			pr_warning("xt_hashlimit: max count of %u reached\n",
+				   ht->cfg.max);
+	} else=20
+		ent =3D kmem_cache_alloc(hashlimit_cachep, GFP_ATOMIC);
+	if (!ent) {
+		if (net_ratelimit())
+			pr_err("xt_hashlimit: can't allocate dsthash_ent\n");
+	} else {
+		memcpy(&ent->key, key, ht->sz32 * sizeof(u32));
+		spin_lock_init(&ent->lock);
+		ent->expires =3D jiffies + msecs_to_jiffies(ht->cfg.expire);
+		ent->rateinfo.prev =3D jiffies;
+		ent->rateinfo.credit =3D ht->credit_cap;
+		ent->rateinfo.cost =3D user2credits(ht->cfg.avg);
+		spin_lock(&ent->lock);
+
+		hlist_add_head_rcu(&ent->node, &ht->hash[hash]);
+		ht->count++;
+	}
+	spin_unlock(&ht->hlock);
+	return ent;
+}
+
 static bool
 hashlimit_mt_v0(const struct sk_buff *skb, const struct xt_match_param=
 *par)
 {
@@ -583,43 +590,36 @@ hashlimit_mt_v0(const struct sk_buff *skb, const =
struct xt_match_param *par)
 	struct xt_hashlimit_htable *hinfo =3D r->hinfo;
 	unsigned long now =3D jiffies;
 	struct dsthash_ent *dh;
-	struct dsthash_dst dst;
+	u32 key[MAXKEYSIZE], hash;
=20
-	if (hashlimit_init_dst(hinfo, &dst, skb, par->thoff) < 0)
+	if (hashlimit_init_key(hinfo, key, skb, par->thoff) < 0)
 		goto hotdrop;
=20
-	spin_lock_bh(&hinfo->lock);
-	dh =3D dsthash_find(hinfo, &dst);
+	hash =3D hash_func(hinfo, key);
+	rcu_read_lock_bh();
+	dh =3D dsthash_find(hinfo, key, hash);
 	if (!dh) {
-		dh =3D dsthash_alloc_init(hinfo, &dst);
+		dh =3D dsthash_alloc_init(hinfo, key, hash);
 		if (!dh) {
-			spin_unlock_bh(&hinfo->lock);
+			rcu_read_unlock_bh();
 			goto hotdrop;
 		}
-
-		dh->expires =3D jiffies + msecs_to_jiffies(hinfo->cfg.expire);
-		dh->rateinfo.prev =3D jiffies;
-		dh->rateinfo.credit =3D user2credits(hinfo->cfg.avg *
-						   hinfo->cfg.burst);
-		dh->rateinfo.credit_cap =3D user2credits(hinfo->cfg.avg *
-						       hinfo->cfg.burst);
-		dh->rateinfo.cost =3D user2credits(hinfo->cfg.avg);
 	} else {
 		/* update expiration timeout */
 		dh->expires =3D now + msecs_to_jiffies(hinfo->cfg.expire);
-		rateinfo_recalc(dh, now);
+		rateinfo_recalc(dh, now, hinfo);
 	}
=20
 	if (dh->rateinfo.credit >=3D dh->rateinfo.cost) {
 		/* We're underlimit. */
 		dh->rateinfo.credit -=3D dh->rateinfo.cost;
-		spin_unlock_bh(&hinfo->lock);
+		spin_unlock(&dh->lock);
+		rcu_read_unlock_bh();
 		return true;
 	}
=20
-	spin_unlock_bh(&hinfo->lock);
-
-	/* default case: we're overlimit, thus don't match */
+	spin_unlock(&dh->lock);
+	rcu_read_unlock_bh();
 	return false;
=20
 hotdrop:
@@ -634,45 +634,41 @@ hashlimit_mt(const struct sk_buff *skb, const str=
uct xt_match_param *par)
 	struct xt_hashlimit_htable *hinfo =3D info->hinfo;
 	unsigned long now =3D jiffies;
 	struct dsthash_ent *dh;
-	struct dsthash_dst dst;
+	u32 key[MAXKEYSIZE], hash;
=20
-	if (hashlimit_init_dst(hinfo, &dst, skb, par->thoff) < 0)
+	if (hashlimit_init_key(hinfo, key, skb, par->thoff) < 0)
 		goto hotdrop;
=20
-	spin_lock_bh(&hinfo->lock);
-	dh =3D dsthash_find(hinfo, &dst);
+	hash =3D hash_func(hinfo, key);
+	rcu_read_lock_bh();
+	dh =3D dsthash_find(hinfo, key, hash);
 	if (dh =3D=3D NULL) {
-		dh =3D dsthash_alloc_init(hinfo, &dst);
+		dh =3D dsthash_alloc_init(hinfo, key, hash);
 		if (dh =3D=3D NULL) {
-			spin_unlock_bh(&hinfo->lock);
+			rcu_read_unlock_bh();
 			goto hotdrop;
 		}
=20
-		dh->expires =3D jiffies + msecs_to_jiffies(hinfo->cfg.expire);
-		dh->rateinfo.prev =3D jiffies;
-		dh->rateinfo.credit =3D user2credits(hinfo->cfg.avg *
-		                      hinfo->cfg.burst);
-		dh->rateinfo.credit_cap =3D user2credits(hinfo->cfg.avg *
-		                          hinfo->cfg.burst);
-		dh->rateinfo.cost =3D user2credits(hinfo->cfg.avg);
 	} else {
 		/* update expiration timeout */
 		dh->expires =3D now + msecs_to_jiffies(hinfo->cfg.expire);
-		rateinfo_recalc(dh, now);
+		rateinfo_recalc(dh, now, hinfo);
 	}
=20
 	if (dh->rateinfo.credit >=3D dh->rateinfo.cost) {
 		/* below the limit */
 		dh->rateinfo.credit -=3D dh->rateinfo.cost;
-		spin_unlock_bh(&hinfo->lock);
+		spin_unlock(&dh->lock);
+		rcu_read_unlock_bh();
 		return !(info->cfg.mode & XT_HASHLIMIT_INVERT);
 	}
=20
-	spin_unlock_bh(&hinfo->lock);
+	spin_unlock(&dh->lock);
+	rcu_read_unlock_bh();
 	/* default match is underlimit - so over the limit, we need to invert=
 */
 	return info->cfg.mode & XT_HASHLIMIT_INVERT;
=20
- hotdrop:
+hotdrop:
 	*par->hotdrop =3D true;
 	return false;
 }
@@ -685,7 +681,7 @@ static bool hashlimit_mt_check_v0(const struct xt_m=
tchk_param *par)
 	/* Check for overflow. */
 	if (r->cfg.burst =3D=3D 0 ||
 	    user2credits(r->cfg.avg * r->cfg.burst) < user2credits(r->cfg.avg=
)) {
-		printk(KERN_ERR "xt_hashlimit: overflow, try lower: %u/%u\n",
+		pr_err("xt_hashlimit: overflow, try lower: %u/%u\n",
 		       r->cfg.avg, r->cfg.burst);
 		return false;
 	}
@@ -722,7 +718,7 @@ static bool hashlimit_mt_check(const struct xt_mtch=
k_param *par)
 	if (info->cfg.burst =3D=3D 0 ||
 	    user2credits(info->cfg.avg * info->cfg.burst) <
 	    user2credits(info->cfg.avg)) {
-		printk(KERN_ERR "xt_hashlimit: overflow, try lower: %u/%u\n",
+		pr_err("xt_hashlimit: overflow, try lower: %u/%u\n",
 		       info->cfg.avg, info->cfg.burst);
 		return false;
 	}
@@ -843,16 +839,17 @@ static struct xt_match hashlimit_mt_reg[] __read_=
mostly =3D {
=20
 /* PROC stuff */
 static void *dl_seq_start(struct seq_file *s, loff_t *pos)
-	__acquires(htable->lock)
+	__acquires(htable->hlock)
 {
 	struct xt_hashlimit_htable *htable =3D s->private;
-	unsigned int *bucket;
+	unsigned int *bucket =3D kmalloc(sizeof(unsigned int), GFP_KERNEL);
=20
-	spin_lock_bh(&htable->lock);
-	if (*pos >=3D htable->cfg.size)
-		return NULL;
+	spin_lock_bh(&htable->hlock);
=20
-	bucket =3D kmalloc(sizeof(unsigned int), GFP_ATOMIC);
+	if (*pos >=3D htable->cfg.size) {
+		kfree(bucket);
+		return NULL;
+	}
 	if (!bucket)
 		return ERR_PTR(-ENOMEM);
=20
@@ -874,46 +871,68 @@ static void *dl_seq_next(struct seq_file *s, void=
 *v, loff_t *pos)
 }
=20
 static void dl_seq_stop(struct seq_file *s, void *v)
-	__releases(htable->lock)
+	__releases(htable->hlock)
 {
 	struct xt_hashlimit_htable *htable =3D s->private;
 	unsigned int *bucket =3D (unsigned int *)v;
=20
-	kfree(bucket);
-	spin_unlock_bh(&htable->lock);
+	if (!IS_ERR(bucket))
+		kfree(bucket);
+	spin_unlock_bh(&htable->hlock);
 }
=20
 static int dl_seq_real_show(struct dsthash_ent *ent, u_int8_t family,
-				   struct seq_file *s)
+				   struct seq_file *s, struct xt_hashlimit_htable *htable)
 {
+	int res =3D 0;
+	__be32 ports;
+	const u32 *key =3D ent->key;
+
+	spin_lock(&ent->lock);
 	/* recalculate to show accurate numbers */
-	rateinfo_recalc(ent, jiffies);
+	rateinfo_recalc(ent, jiffies, htable);
=20
 	switch (family) {
 	case NFPROTO_IPV4:
-		return seq_printf(s, "%ld %pI4:%u->%pI4:%u %u %u %u\n",
+		{
+		__be32 src =3D (htable->cfg.mode & XT_HASHLIMIT_HASH_DIP) ? *key++ :=
 0;
+		__be32 dst =3D (htable->cfg.mode & XT_HASHLIMIT_HASH_SIP) ? *key++ :=
 0;
+
+		ports =3D (htable->cfg.mode & (XT_HASHLIMIT_HASH_DPT | XT_HASHLIMIT_=
HASH_SPT)) ?
+			*key : 0;
+		res =3D seq_printf(s, "%ld %pI4:%u->%pI4:%u %u %u %u\n",
 				 (long)(ent->expires - jiffies)/HZ,
-				 &ent->dst.ip.src,
-				 ntohs(ent->dst.src_port),
-				 &ent->dst.ip.dst,
-				 ntohs(ent->dst.dst_port),
-				 ent->rateinfo.credit, ent->rateinfo.credit_cap,
+				 &src, ntohs(ports >> 16),
+				 &dst, ntohs(ports & 0xFFFF),
+				 ent->rateinfo.credit, htable->credit_cap,
 				 ent->rateinfo.cost);
+		break;
+		}
 #if defined(CONFIG_IP6_NF_IPTABLES) || defined(CONFIG_IP6_NF_IPTABLES_=
MODULE)
 	case NFPROTO_IPV6:
-		return seq_printf(s, "%ld %pI6:%u->%pI6:%u %u %u %u\n",
+		{
+		struct in6_addr src;
+		struct in6_addr dst;
+		if (htable->cfg.mode & XT_HASHLIMIT_HASH_DIP)
+			key =3D ipv6_addr_rebuild(key, src.s6_addr32, htable->cfg.dstmask >=
> 5);
+		if (htable->cfg.mode & XT_HASHLIMIT_HASH_SIP)
+			key =3D ipv6_addr_rebuild(key, dst.s6_addr32, htable->cfg.srcmask >=
> 5);
+		ports =3D (htable->cfg.mode & (XT_HASHLIMIT_HASH_DPT | XT_HASHLIMIT_=
HASH_SPT)) ?
+			*key : 0;
+		res =3D seq_printf(s, "%ld %pI6:%u->%pI6:%u %u %u %u\n",
 				 (long)(ent->expires - jiffies)/HZ,
-				 &ent->dst.ip6.src,
-				 ntohs(ent->dst.src_port),
-				 &ent->dst.ip6.dst,
-				 ntohs(ent->dst.dst_port),
-				 ent->rateinfo.credit, ent->rateinfo.credit_cap,
+				 &src, ntohs(ports >> 16),
+				 &dst, ntohs(ports & 0xFFFF),
+				 ent->rateinfo.credit, htable->credit_cap,
 				 ent->rateinfo.cost);
+		break;
+		}
 #endif
 	default:
 		BUG();
-		return 0;
 	}
+	spin_unlock(&ent->lock);
+	return res;
 }
=20
 static int dl_seq_show(struct seq_file *s, void *v)
@@ -925,7 +944,7 @@ static int dl_seq_show(struct seq_file *s, void *v)
=20
 	if (!hlist_empty(&htable->hash[*bucket])) {
 		hlist_for_each_entry(ent, pos, &htable->hash[*bucket], node)
-			if (dl_seq_real_show(ent, htable->family, s))
+			if (dl_seq_real_show(ent, htable->family, s, htable))
 				return -1;
 	}
 	return 0;
@@ -1022,7 +1041,7 @@ static int __init hashlimit_mt_init(void)
 					    sizeof(struct dsthash_ent), 0, 0,
 					    NULL);
 	if (!hashlimit_cachep) {
-		printk(KERN_ERR "xt_hashlimit: unable to create slab cache\n");
+		pr_err("xt_hashlimit: unable to create slab cache\n");
 		goto err2;
 	}
 	return 0;
@@ -1037,9 +1056,9 @@ err1:
=20
 static void __exit hashlimit_mt_exit(void)
 {
-	kmem_cache_destroy(hashlimit_cachep);
 	xt_unregister_matches(hashlimit_mt_reg, ARRAY_SIZE(hashlimit_mt_reg))=
;
 	unregister_pernet_subsys(&hashlimit_net_ops);
+	kmem_cache_destroy(hashlimit_cachep);
 }
=20
 module_init(hashlimit_mt_init);


--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
