From: Harald Welte <laforge@netfilter.org>
Subject: [PATCH 2.6] NETFILTER(12/12): add conntrack runtime statistics
Date: Sat, 24 Jul 2004 11:23:47 -0400
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040724152347.GU2848@obroa-skai.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="36+Jv5wzUORg1Ut4"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: David Miller <davem@redhat.com>
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--36+Jv5wzUORg1Ut4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave!

This patch adds some runtime-statistics to the connection tracking core,
pretty similar to what 'rtstat' does for the routing cache.

This was the last patch in this incremental set.  The only thing I still
have pending at this time is the tcp window tracking code. =20

Signed-off-by: Martin Josefsson <gandalf@wlug.westbo.se>
Signed-off-by: Harald Welte <laforge@netfilter.org>


diff -Nru --exclude-from /space/home/laforge/scripts/dontdiff --exclude .de=
pend --exclude '*.o' --exclude '*.ko' --exclude '*.ver' --exclude '.*.flags=
' --exclude '*.orig' --exclude '*.rej' --exclude '*.cmd' --exclude '*.mod.c=
' --exclude '*~' linux-2.6.8-rc2-updates-modparm-expslab-ctacct-ctseq-sctp-=
natstatic-initctopt-error/include/linux/netfilter_ipv4/ip_conntrack.h linux=
-2.6.8-rc2-updates-modparm-expslab-ctacct-ctseq-sctp-natstatic-initctopt-er=
ror-ctstat/include/linux/netfilter_ipv4/ip_conntrack.h
--- linux-2.6.8-rc2-updates-modparm-expslab-ctacct-ctseq-sctp-natstatic-ini=
tctopt-error/include/linux/netfilter_ipv4/ip_conntrack.h	2004-07-24 10:36:3=
5.263939000 -0400
+++ linux-2.6.8-rc2-updates-modparm-expslab-ctacct-ctseq-sctp-natstatic-ini=
tctopt-error-ctstat/include/linux/netfilter_ipv4/ip_conntrack.h	2004-07-24 =
11:18:30.559556624 -0400
@@ -284,6 +284,26 @@
 }
=20
 extern unsigned int ip_conntrack_htable_size;
+=20
+struct ip_conntrack_stat
+{
+	unsigned int searched;
+	unsigned int found;
+	unsigned int new;
+	unsigned int invalid;
+	unsigned int ignore;
+	unsigned int delete;
+	unsigned int delete_list;
+	unsigned int insert;
+	unsigned int insert_failed;
+	unsigned int drop;
+	unsigned int early_drop;
+	unsigned int icmp_error;
+	unsigned int expect_new;
+	unsigned int expect_create;
+	unsigned int expect_delete;
+};
+
=20
 /* eg. PROVIDES_CONNTRACK(ftp); */
 #define PROVIDES_CONNTRACK(name)                        \
diff -Nru --exclude-from /space/home/laforge/scripts/dontdiff --exclude .de=
pend --exclude '*.o' --exclude '*.ko' --exclude '*.ver' --exclude '.*.flags=
' --exclude '*.orig' --exclude '*.rej' --exclude '*.cmd' --exclude '*.mod.c=
' --exclude '*~' linux-2.6.8-rc2-updates-modparm-expslab-ctacct-ctseq-sctp-=
natstatic-initctopt-error/net/ipv4/netfilter/ip_conntrack_core.c linux-2.6.=
8-rc2-updates-modparm-expslab-ctacct-ctseq-sctp-natstatic-initctopt-error-c=
tstat/net/ipv4/netfilter/ip_conntrack_core.c
--- linux-2.6.8-rc2-updates-modparm-expslab-ctacct-ctseq-sctp-natstatic-ini=
tctopt-error/net/ipv4/netfilter/ip_conntrack_core.c	2004-07-24 11:11:29.939=
500592 -0400
+++ linux-2.6.8-rc2-updates-modparm-expslab-ctacct-ctseq-sctp-natstatic-ini=
tctopt-error-ctstat/net/ipv4/netfilter/ip_conntrack_core.c	2004-07-24 11:19=
:31.954223216 -0400
@@ -35,6 +35,7 @@
 #include <linux/random.h>
 #include <linux/jhash.h>
 #include <linux/err.h>
+#include <linux/percpu.h>
 #include <linux/moduleparam.h>
=20
 /* This rwlock protects the main hash table, protocol/helper/expected
@@ -58,6 +59,7 @@
=20
 DECLARE_RWLOCK(ip_conntrack_lock);
 DECLARE_RWLOCK(ip_conntrack_expect_tuple_lock);
+static atomic_t ip_conntrack_count =3D ATOMIC_INIT(0);
=20
 void (*ip_conntrack_destroyed)(struct ip_conntrack *conntrack) =3D NULL;
 LIST_HEAD(ip_conntrack_expect_list);
@@ -65,12 +67,13 @@
 static LIST_HEAD(helpers);
 unsigned int ip_conntrack_htable_size =3D 0;
 int ip_conntrack_max;
-static atomic_t ip_conntrack_count =3D ATOMIC_INIT(0);
 struct list_head *ip_conntrack_hash;
 static kmem_cache_t *ip_conntrack_cachep;
 static kmem_cache_t *ip_conntrack_expect_cachep;
 struct ip_conntrack ip_conntrack_untracked;
=20
+DEFINE_PER_CPU(struct ip_conntrack_stat, ip_conntrack_stat);
+
 extern struct ip_conntrack_protocol ip_conntrack_generic_protocol;
=20
 static inline int proto_cmpfn(const struct ip_conntrack_protocol *curr,
@@ -179,6 +182,7 @@
 	IP_NF_ASSERT(!timer_pending(&exp->timeout));
=20
 	kmem_cache_free(ip_conntrack_expect_cachep, exp);
+	__get_cpu_var(ip_conntrack_stat).expect_delete++;
 }
=20
 inline void ip_conntrack_expect_put(struct ip_conntrack_expect *exp)
@@ -347,12 +351,15 @@
 	DEBUGP("destroy_conntrack: returning ct=3D%p to slab\n", ct);
 	kmem_cache_free(ip_conntrack_cachep, ct);
 	atomic_dec(&ip_conntrack_count);
+	__get_cpu_var(ip_conntrack_stat).delete++;
 }
=20
 static void death_by_timeout(unsigned long ul_conntrack)
 {
 	struct ip_conntrack *ct =3D (void *)ul_conntrack;
=20
+	__get_cpu_var(ip_conntrack_stat).delete_list++;
+
 	WRITE_LOCK(&ip_conntrack_lock);
 	clean_from_lists(ct);
 	WRITE_UNLOCK(&ip_conntrack_lock);
@@ -375,13 +382,19 @@
 {
 	struct ip_conntrack_tuple_hash *h;
 	unsigned int hash =3D hash_conntrack(tuple);
+	/* use per_cpu() to avoid multiple calls to smp_processor_id() */
+	unsigned int cpu =3D smp_processor_id();
=20
 	MUST_BE_READ_LOCKED(&ip_conntrack_lock);
-	h =3D LIST_FIND(&ip_conntrack_hash[hash],
-		      conntrack_tuple_cmp,
-		      struct ip_conntrack_tuple_hash *,
-		      tuple, ignored_conntrack);
-	return h;
+	list_for_each_entry(h, &ip_conntrack_hash[hash], list) {
+		if (conntrack_tuple_cmp(h, tuple, ignored_conntrack)) {
+			per_cpu(ip_conntrack_stat, cpu).found++;
+			return h;
+		}
+		per_cpu(ip_conntrack_stat, cpu).searched++;
+	}
+
+	return NULL;
 }
=20
 /* Find a connection corresponding to a tuple. */
@@ -475,10 +488,12 @@
 		atomic_inc(&ct->ct_general.use);
 		set_bit(IPS_CONFIRMED_BIT, &ct->status);
 		WRITE_UNLOCK(&ip_conntrack_lock);
+	 	__get_cpu_var(ip_conntrack_stat).insert++;
 		return NF_ACCEPT;
 	}
=20
 	WRITE_UNLOCK(&ip_conntrack_lock);
+	__get_cpu_var(ip_conntrack_stat).insert_failed++;
 	return NF_DROP;
 }
=20
@@ -522,6 +537,7 @@
 	if (del_timer(&h->ctrack->timeout)) {
 		death_by_timeout((unsigned long)h->ctrack);
 		dropped =3D 1;
+		__get_cpu_var(ip_conntrack_stat).early_drop++;
 	}
 	ip_conntrack_put(h->ctrack);
 	return dropped;
@@ -650,11 +666,16 @@
=20
 		if (expected->expectfn)
 			expected->expectfn(conntrack);
+=09
+		__get_cpu_var(ip_conntrack_stat).expect_new++;
=20
 		goto ret;
-	} else=20
+	} else  {
 		conntrack->helper =3D ip_ct_find_helper(&repl_tuple);
=20
+		__get_cpu_var(ip_conntrack_stat).new++;
+	}
+
 end:	atomic_inc(&ip_conntrack_count);
 	WRITE_UNLOCK(&ip_conntrack_lock);
=20
@@ -755,8 +776,10 @@
 #endif
=20
 	/* Previously seen (loopback or untracked)?  Ignore. */
-	if ((*pskb)->nfct)
+	if ((*pskb)->nfct) {
+		__get_cpu_var(ip_conntrack_stat).ignore++;
 		return NF_ACCEPT;
+	}
=20
 	proto =3D ip_ct_find_proto((*pskb)->nh.iph->protocol);
=20
@@ -764,16 +787,22 @@
 	 * inverse of the return code tells to the netfilter
 	 * core what to do with the packet. */
 	if (proto->error !=3D NULL=20
-	    && (ret =3D proto->error(*pskb, &ctinfo, hooknum)) <=3D 0)
+	    && (ret =3D proto->error(*pskb, &ctinfo, hooknum)) <=3D 0) {
+		__get_cpu_var(ip_conntrack_stat).icmp_error++;
 		return -ret;
+	}
=20
-	if (!(ct =3D resolve_normal_ct(*pskb, proto,&set_reply,hooknum,&ctinfo)))
+	if (!(ct =3D resolve_normal_ct(*pskb, proto,&set_reply,hooknum,&ctinfo)))=
 {
 		/* Not valid part of a connection */
+		__get_cpu_var(ip_conntrack_stat).invalid++;
 		return NF_ACCEPT;
+	}
=20
-	if (IS_ERR(ct))
+	if (IS_ERR(ct)) {
 		/* Too stressed to deal. */
+		__get_cpu_var(ip_conntrack_stat).drop++;
 		return NF_DROP;
+	}
=20
 	IP_NF_ASSERT((*pskb)->nfct);
=20
@@ -782,6 +811,7 @@
 		/* Invalid */
 		nf_conntrack_put((*pskb)->nfct);
 		(*pskb)->nfct =3D NULL;
+		__get_cpu_var(ip_conntrack_stat).invalid++;
 		return NF_ACCEPT;
 	}
=20
@@ -789,6 +819,7 @@
 		ret =3D ct->helper->help(*pskb, ct, ctinfo);
 		if (ret =3D=3D -1) {
 			/* Invalid */
+			__get_cpu_var(ip_conntrack_stat).invalid++;
 			nf_conntrack_put((*pskb)->nfct);
 			(*pskb)->nfct =3D NULL;
 			return NF_ACCEPT;
@@ -992,6 +1023,8 @@
=20
 	WRITE_UNLOCK(&ip_conntrack_lock);
=20
+	__get_cpu_var(ip_conntrack_stat).expect_create++;
+
 	return ret;
 }
=20
diff -Nru --exclude-from /space/home/laforge/scripts/dontdiff --exclude .de=
pend --exclude '*.o' --exclude '*.ko' --exclude '*.ver' --exclude '.*.flags=
' --exclude '*.orig' --exclude '*.rej' --exclude '*.cmd' --exclude '*.mod.c=
' --exclude '*~' linux-2.6.8-rc2-updates-modparm-expslab-ctacct-ctseq-sctp-=
natstatic-initctopt-error/net/ipv4/netfilter/ip_conntrack_standalone.c linu=
x-2.6.8-rc2-updates-modparm-expslab-ctacct-ctseq-sctp-natstatic-initctopt-e=
rror-ctstat/net/ipv4/netfilter/ip_conntrack_standalone.c
--- linux-2.6.8-rc2-updates-modparm-expslab-ctacct-ctseq-sctp-natstatic-ini=
tctopt-error/net/ipv4/netfilter/ip_conntrack_standalone.c	2004-07-24 11:11:=
29.957497856 -0400
+++ linux-2.6.8-rc2-updates-modparm-expslab-ctacct-ctseq-sctp-natstatic-ini=
tctopt-error-ctstat/net/ipv4/netfilter/ip_conntrack_standalone.c	2004-07-24=
 11:18:30.587552368 -0400
@@ -21,6 +21,7 @@
 #include <linux/skbuff.h>
 #include <linux/proc_fs.h>
 #include <linux/seq_file.h>
+#include <linux/percpu.h>
 #ifdef CONFIG_SYSCTL
 #include <linux/sysctl.h>
 #endif
@@ -44,6 +45,9 @@
=20
 MODULE_LICENSE("GPL");
=20
+extern atomic_t ip_conntrack_count;
+DECLARE_PER_CPU(struct ip_conntrack_stat, ip_conntrack_stat);
+
 static int kill_proto(const struct ip_conntrack *i, void *data)
 {
 	return (i->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.protonum =3D=3D=20
@@ -283,6 +287,86 @@
 	.release =3D seq_release
 };
=20
+static void *ct_cpu_seq_start(struct seq_file *seq, loff_t *pos)
+{
+	int cpu;
+
+	for (cpu =3D *pos; cpu < NR_CPUS; ++cpu) {
+		if (!cpu_possible(cpu))
+			continue;
+		*pos =3D cpu;
+		return &per_cpu(ip_conntrack_stat, cpu);
+	}
+
+	return NULL;
+}
+
+static void *ct_cpu_seq_next(struct seq_file *seq, void *v, loff_t *pos)
+{
+	int cpu;
+
+	for (cpu =3D *pos + 1; cpu < NR_CPUS; ++cpu) {
+		if (!cpu_possible(cpu))
+			continue;
+		*pos =3D cpu;
+		return &per_cpu(ip_conntrack_stat, cpu);
+	}
+
+	return NULL;
+}
+
+static void ct_cpu_seq_stop(struct seq_file *seq, void *v)
+{
+}
+
+static int ct_cpu_seq_show(struct seq_file *seq, void *v)
+{
+	unsigned int nr_conntracks =3D atomic_read(&ip_conntrack_count);
+	struct ip_conntrack_stat *st =3D v;
+
+	seq_printf(seq, "%08x  %08x %08x %08x %08x %08x %08x %08x "
+			"%08x %08x %08x %08x %08x  %08x %08x %08x \n",
+		   nr_conntracks,
+		   st->searched,
+		   st->found,
+		   st->new,
+		   st->invalid,
+		   st->ignore,
+		   st->delete,
+		   st->delete_list,
+		   st->insert,
+		   st->insert_failed,
+		   st->drop,
+		   st->early_drop,
+		   st->icmp_error,
+
+		   st->expect_new,
+		   st->expect_create,
+		   st->expect_delete
+		);
+	return 0;
+}
+
+static struct seq_operations ct_cpu_seq_ops =3D {
+	.start  =3D ct_cpu_seq_start,
+	.next   =3D ct_cpu_seq_next,
+	.stop   =3D ct_cpu_seq_stop,
+	.show   =3D ct_cpu_seq_show,
+};
+
+static int ct_cpu_seq_open(struct inode *inode, struct file *file)
+{
+	return seq_open(file, &ct_cpu_seq_ops);
+}
+
+static struct file_operations ct_cpu_seq_fops =3D {
+	.owner   =3D THIS_MODULE,
+	.open    =3D ct_cpu_seq_open,
+	.read    =3D seq_read,
+	.llseek  =3D seq_lseek,
+	.release =3D seq_release_private,
+};
+
 static unsigned int ip_confirm(unsigned int hooknum,
 			       struct sk_buff **pskb,
 			       const struct net_device *in,
@@ -608,7 +692,7 @@
 #endif
 static int init_or_cleanup(int init)
 {
-	struct proc_dir_entry *proc, *proc_exp;
+	struct proc_dir_entry *proc, *proc_exp, *proc_stat;
 	int ret =3D 0;
=20
 	if (!init) goto cleanup;
@@ -625,10 +709,16 @@
 	if (!proc_exp) goto cleanup_proc;
 	proc_exp->proc_fops =3D &exp_file_ops;
=20
+	proc_stat =3D proc_net_fops_create("ip_conntrack_stat", S_IRUGO,
+					 &ct_cpu_seq_fops);
+	if (!proc_stat)
+		goto cleanup_proc_exp;
+	proc_stat->owner =3D THIS_MODULE;
+
 	ret =3D nf_register_hook(&ip_conntrack_defrag_ops);
 	if (ret < 0) {
 		printk("ip_conntrack: can't register pre-routing defrag hook.\n");
-		goto cleanup_proc_exp;
+		goto cleanup_proc_stat;
 	}
 	ret =3D nf_register_hook(&ip_conntrack_defrag_local_out_ops);
 	if (ret < 0) {
@@ -680,6 +770,8 @@
 	nf_unregister_hook(&ip_conntrack_defrag_local_out_ops);
  cleanup_defragops:
 	nf_unregister_hook(&ip_conntrack_defrag_ops);
+ cleanup_proc_stat:
+	proc_net_remove("ip_conntrack_stat");
 cleanup_proc_exp:
 	proc_net_remove("ip_conntrack_exp");
  cleanup_proc:
--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--36+Jv5wzUORg1Ut4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFBAn8DXaXGVTD0i/8RAmmTAJ0Wk+sb0m9tXUVHReyUmGTjPk7yvwCfbSIi
GxaInfT0vvBVpp5S5SQSePA=
=N+xc
-----END PGP SIGNATURE-----

--36+Jv5wzUORg1Ut4--
