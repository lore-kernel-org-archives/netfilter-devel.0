From: Harald Welte <laforge@netfilter.org>
Subject: [PATCH 2.6] Allow dynamic helper-port assignment
Date: Sun, 13 Feb 2005 17:56:38 +0100
Message-ID: <20050213165638.GM20269@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4IFtMBbmeqbTM/ox"
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Content-Disposition: inline
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


--4IFtMBbmeqbTM/ox
Content-Type: multipart/mixed; boundary="acOuGx3oQeOcSZJu"
Content-Disposition: inline


--acOuGx3oQeOcSZJu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

The recent problem with h323 made me again consider the old idea of
having runtime-configurable port assignments for helpers.=20

Ideally, we would actually have conntrack helpers be iptables targets,
this way allowing totally dynamic assignemnt.  Maybe yet another
pkttables todo.

Meanwhile, the following patch uses the same mechanism as CLUSTERIP:

Add port 2121 to ftp helper:
	echo "+2121" > /proc/net/ip_conntrack_helper/ftp

Remove port 6669 from irc helper:
	echo "-6669" > /proc/net/ip_conntrack_helper/irc

Show registered ports for amanda helper:
	cat /proc/net/ip_conntrack_helper/amanda

If nobody complains, we should push this for 2.6.12.

And yes, I'll do the nf_conntrack merge right now :)

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--acOuGx3oQeOcSZJu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment;
	filename="2.6.11-rc4-ip_conntrack_helper_proc.patch"
Content-Transfer-Encoding: quoted-printable

diff -Nru --exclude .depend --exclude '*.o' --exclude '*.ko' --exclude '*.v=
er' --exclude '.*.flags' --exclude '*.orig' --exclude '*.rej' --exclude '*.=
cmd' --exclude '*.mod.c' --exclude '*~' linux-2.6.11-rc4/include/linux/netf=
ilter_ipv4/ip_conntrack_core.h linux-2.6.11-rc4-helper_sysctl/include/linux=
/netfilter_ipv4/ip_conntrack_core.h
--- linux-2.6.11-rc4/include/linux/netfilter_ipv4/ip_conntrack_core.h	2005-=
02-13 13:52:05.000000000 +0100
+++ linux-2.6.11-rc4-helper_sysctl/include/linux/netfilter_ipv4/ip_conntrac=
k_core.h	2005-02-13 16:15:56.000000000 +0100
@@ -48,5 +48,10 @@
 extern struct list_head *ip_conntrack_hash;
 extern struct list_head ip_conntrack_expect_list;
 DECLARE_RWLOCK_EXTERN(ip_conntrack_lock);
+extern struct list_head ip_conntrack_unconfirmed;
+
+extern void __ip_ct_destroy_expect(struct ip_conntrack_expect *exp);
+extern void __ip_ct_unlink_expect(struct ip_conntrack_expect *exp);
+
 #endif /* _IP_CONNTRACK_CORE_H */
=20
diff -Nru --exclude .depend --exclude '*.o' --exclude '*.ko' --exclude '*.v=
er' --exclude '.*.flags' --exclude '*.orig' --exclude '*.rej' --exclude '*.=
cmd' --exclude '*.mod.c' --exclude '*~' linux-2.6.11-rc4/include/linux/netf=
ilter_ipv4/ip_conntrack_helper.h linux-2.6.11-rc4-helper_sysctl/include/lin=
ux/netfilter_ipv4/ip_conntrack_helper.h
--- linux-2.6.11-rc4/include/linux/netfilter_ipv4/ip_conntrack_helper.h	200=
5-02-13 13:52:05.000000000 +0100
+++ linux-2.6.11-rc4-helper_sysctl/include/linux/netfilter_ipv4/ip_conntrac=
k_helper.h	2005-02-13 16:44:16.000000000 +0100
@@ -15,6 +15,10 @@
 					 * expected connections */
 	unsigned int timeout;		/* timeout for expecteds */
=20
+#ifdef CONFIG_PROC_FS
+	struct proc_dir_entry	*pde;	/* proc file for port changes */
+#endif
+
 	/* Mask of things we will help (compared against server response) */
 	struct ip_conntrack_tuple tuple;
 	struct ip_conntrack_tuple mask;
@@ -29,6 +33,11 @@
 extern int ip_conntrack_helper_register(struct ip_conntrack_helper *);
 extern void ip_conntrack_helper_unregister(struct ip_conntrack_helper *);
=20
+extern int ip_conntrack_helper_add_port(struct ip_conntrack_helper *h,
+					u_int16_t port);
+extern int ip_conntrack_helper_del_port(struct ip_conntrack_helper *h,
+					u_int16_t port);
+
 /* Allocate space for an expectation: this is mandatory before calling=20
    ip_conntrack_expect_related. */
 extern struct ip_conntrack_expect *ip_conntrack_expect_alloc(void);
@@ -38,4 +47,10 @@
 extern int ip_conntrack_expect_related(struct ip_conntrack_expect *exp);
 extern void ip_conntrack_unexpect_related(struct ip_conntrack_expect *exp);
=20
+/* Find the helper for a for a particular tuple */
+extern struct ip_conntrack_helper *ip_ct_find_helper(const struct ip_connt=
rack_tuple *tuple);
+
+extern int ip_conntrack_helper_init(void);
+extern void ip_conntrack_helper_fini(void);
+
 #endif /*_IP_CONNTRACK_HELPER_H*/
diff -Nru --exclude .depend --exclude '*.o' --exclude '*.ko' --exclude '*.v=
er' --exclude '.*.flags' --exclude '*.orig' --exclude '*.rej' --exclude '*.=
cmd' --exclude '*.mod.c' --exclude '*~' linux-2.6.11-rc4/net/ipv4/netfilter=
/Makefile linux-2.6.11-rc4-helper_sysctl/net/ipv4/netfilter/Makefile
--- linux-2.6.11-rc4/net/ipv4/netfilter/Makefile	2005-02-13 13:52:06.000000=
000 +0100
+++ linux-2.6.11-rc4-helper_sysctl/net/ipv4/netfilter/Makefile	2005-02-13 1=
3:59:13.000000000 +0100
@@ -3,7 +3,7 @@
 #
=20
 # objects for the standalone - connection tracking / NAT
-ip_conntrack-objs	:=3D ip_conntrack_standalone.o ip_conntrack_core.o ip_co=
nntrack_proto_generic.o ip_conntrack_proto_tcp.o ip_conntrack_proto_udp.o i=
p_conntrack_proto_icmp.o
+ip_conntrack-objs	:=3D ip_conntrack_standalone.o ip_conntrack_core.o ip_co=
nntrack_helper.o ip_conntrack_proto_generic.o ip_conntrack_proto_tcp.o ip_c=
onntrack_proto_udp.o ip_conntrack_proto_icmp.o
 iptable_nat-objs	:=3D ip_nat_standalone.o ip_nat_rule.o ip_nat_core.o ip_n=
at_helper.o ip_nat_proto_unknown.o ip_nat_proto_tcp.o ip_nat_proto_udp.o ip=
_nat_proto_icmp.o
=20
 # connection tracking
diff -Nru --exclude .depend --exclude '*.o' --exclude '*.ko' --exclude '*.v=
er' --exclude '.*.flags' --exclude '*.orig' --exclude '*.rej' --exclude '*.=
cmd' --exclude '*.mod.c' --exclude '*~' linux-2.6.11-rc4/net/ipv4/netfilter=
/ip_conntrack_amanda.c linux-2.6.11-rc4-helper_sysctl/net/ipv4/netfilter/ip=
_conntrack_amanda.c
--- linux-2.6.11-rc4/net/ipv4/netfilter/ip_conntrack_amanda.c	2005-02-13 13=
:52:06.000000000 +0100
+++ linux-2.6.11-rc4-helper_sysctl/net/ipv4/netfilter/ip_conntrack_amanda.c=
	2005-02-13 17:41:38.000000000 +0100
@@ -160,7 +160,11 @@
=20
 static int __init init(void)
 {
-	return ip_conntrack_helper_register(&amanda_helper);
+	int ret =3D ip_conntrack_helper_register(&amanda_helper);
+	if (ret)
+		return ret;
+	return ip_conntrack_helper_add_port(&amanda_helper,
+				ntohs(amanda_helper.tuple.src.u.tcp.port));
 }
=20
 module_init(init);
diff -Nru --exclude .depend --exclude '*.o' --exclude '*.ko' --exclude '*.v=
er' --exclude '.*.flags' --exclude '*.orig' --exclude '*.rej' --exclude '*.=
cmd' --exclude '*.mod.c' --exclude '*~' linux-2.6.11-rc4/net/ipv4/netfilter=
/ip_conntrack_core.c linux-2.6.11-rc4-helper_sysctl/net/ipv4/netfilter/ip_c=
onntrack_core.c
--- linux-2.6.11-rc4/net/ipv4/netfilter/ip_conntrack_core.c	2005-02-13 13:5=
2:06.000000000 +0100
+++ linux-2.6.11-rc4-helper_sysctl/net/ipv4/netfilter/ip_conntrack_core.c	2=
005-02-13 17:01:40.000000000 +0100
@@ -49,7 +49,7 @@
 #include <linux/netfilter_ipv4/ip_conntrack_core.h>
 #include <linux/netfilter_ipv4/listhelp.h>
=20
-#define IP_CONNTRACK_VERSION	"2.1"
+#define IP_CONNTRACK_VERSION	"2.2"
=20
 #if 0
 #define DEBUGP printk
@@ -65,7 +65,6 @@
 void (*ip_conntrack_destroyed)(struct ip_conntrack *conntrack) =3D NULL;
 LIST_HEAD(ip_conntrack_expect_list);
 struct ip_conntrack_protocol *ip_ct_protos[MAX_IP_CT_PROTO];
-static LIST_HEAD(helpers);
 unsigned int ip_conntrack_htable_size =3D 0;
 int ip_conntrack_max;
 struct list_head *ip_conntrack_hash;
@@ -73,7 +72,7 @@
 static kmem_cache_t *ip_conntrack_expect_cachep;
 struct ip_conntrack ip_conntrack_untracked;
 unsigned int ip_ct_log_invalid;
-static LIST_HEAD(unconfirmed);
+LIST_HEAD(ip_conntrack_unconfirmed);
 static int ip_conntrack_vmalloc;
=20
 DEFINE_PER_CPU(struct ip_conntrack_stat, ip_conntrack_stat);
@@ -137,7 +136,7 @@
=20
=20
 /* ip_conntrack_expect helper functions */
-static void destroy_expect(struct ip_conntrack_expect *exp)
+void __ip_ct_destroy_expect(struct ip_conntrack_expect *exp)
 {
 	ip_conntrack_put(exp->master);
 	IP_NF_ASSERT(!timer_pending(&exp->timeout));
@@ -145,7 +144,7 @@
 	CONNTRACK_STAT_INC(expect_delete);
 }
=20
-static void unlink_expect(struct ip_conntrack_expect *exp)
+void __ip_ct_unlink_expect(struct ip_conntrack_expect *exp)
 {
 	MUST_BE_WRITE_LOCKED(&ip_conntrack_lock);
 	list_del(&exp->list);
@@ -158,9 +157,9 @@
 	struct ip_conntrack_expect *exp =3D (void *)ul_expect;
=20
 	WRITE_LOCK(&ip_conntrack_lock);
-	unlink_expect(exp);
+	__ip_ct_unlink_expect(exp);
 	WRITE_UNLOCK(&ip_conntrack_lock);
-	destroy_expect(exp);
+	__ip_ct_destroy_expect(exp);
 }
=20
 /* If an expectation for this connection is found, it gets delete from
@@ -179,7 +178,7 @@
 		if (ip_ct_tuple_mask_cmp(tuple, &i->tuple, &i->mask)
 		    && is_confirmed(i->master)
 		    && del_timer(&i->timeout)) {
-			unlink_expect(i);
+			__ip_ct_unlink_expect(i);
 			return i;
 		}
 	}
@@ -197,8 +196,8 @@
=20
 	list_for_each_entry_safe(i, tmp, &ip_conntrack_expect_list, list) {
 		if (i->master =3D=3D ct && del_timer(&i->timeout)) {
-			unlink_expect(i);
-			destroy_expect(i);
+			__ip_ct_unlink_expect(i);
+			__ip_ct_destroy_expect(i);
 		}
 	}
 }
@@ -439,19 +438,6 @@
 	return dropped;
 }
=20
-static inline int helper_cmp(const struct ip_conntrack_helper *i,
-			     const struct ip_conntrack_tuple *rtuple)
-{
-	return ip_ct_tuple_mask_cmp(rtuple, &i->tuple, &i->mask);
-}
-
-static struct ip_conntrack_helper *ip_ct_find_helper(const struct ip_connt=
rack_tuple *tuple)
-{
-	return LIST_FIND(&helpers, helper_cmp,
-			 struct ip_conntrack_helper *,
-			 tuple);
-}
-
 /* Allocate a new conntrack: we return -ENOMEM if classification
    failed due to stress.  Otherwise it really is unclassifiable. */
 static struct ip_conntrack_tuple_hash *
@@ -529,7 +515,8 @@
 	}
=20
 	/* Overload tuple linked list to put us in unconfirmed list. */
-	list_add(&conntrack->tuplehash[IP_CT_DIR_ORIGINAL].list, &unconfirmed);
+	list_add(&conntrack->tuplehash[IP_CT_DIR_ORIGINAL].list,
+		 &ip_conntrack_unconfirmed);
=20
 	atomic_inc(&ip_conntrack_count);
 	WRITE_UNLOCK(&ip_conntrack_lock);
@@ -537,7 +524,7 @@
 	if (exp) {
 		if (exp->expectfn)
 			exp->expectfn(conntrack, exp);
-		destroy_expect(exp);
+		__ip_ct_destroy_expect(exp);
 	}
=20
 	return &conntrack->tuplehash[IP_CT_DIR_ORIGINAL];
@@ -727,9 +714,9 @@
 	/* choose the the oldest expectation to evict */
 	list_for_each_entry_reverse(i, &ip_conntrack_expect_list, list) {
 		if (expect_matches(i, exp) && del_timer(&i->timeout)) {
-			unlink_expect(i);
+			__ip_ct_unlink_expect(i);
 			WRITE_UNLOCK(&ip_conntrack_lock);
-			destroy_expect(i);
+			__ip_ct_destroy_expect(i);
 			return;
 		}
 	}
@@ -781,8 +768,8 @@
 	list_for_each_entry_reverse(i, &ip_conntrack_expect_list, list) {
 		if (i->master =3D=3D master) {
 			if (del_timer(&i->timeout)) {
-				unlink_expect(i);
-				destroy_expect(i);
+				__ip_ct_unlink_expect(i);
+				__ip_ct_destroy_expect(i);
 			}
 			break;
 		}
@@ -854,50 +841,6 @@
 	WRITE_UNLOCK(&ip_conntrack_lock);
 }
=20
-int ip_conntrack_helper_register(struct ip_conntrack_helper *me)
-{
-	BUG_ON(me->timeout =3D=3D 0);
-	WRITE_LOCK(&ip_conntrack_lock);
-	list_prepend(&helpers, me);
-	WRITE_UNLOCK(&ip_conntrack_lock);
-
-	return 0;
-}
-
-static inline int unhelp(struct ip_conntrack_tuple_hash *i,
-			 const struct ip_conntrack_helper *me)
-{
-	if (tuplehash_to_ctrack(i)->helper =3D=3D me)
-		tuplehash_to_ctrack(i)->helper =3D NULL;
-	return 0;
-}
-
-void ip_conntrack_helper_unregister(struct ip_conntrack_helper *me)
-{
-	unsigned int i;
-	struct ip_conntrack_expect *exp, *tmp;
-
-	/* Need write lock here, to delete helper. */
-	WRITE_LOCK(&ip_conntrack_lock);
-	LIST_DELETE(&helpers, me);
-
-	/* Get rid of expectations */
-	list_for_each_entry_safe(exp, tmp, &ip_conntrack_expect_list, list) {
-		if (exp->master->helper =3D=3D me && del_timer(&exp->timeout)) {
-			unlink_expect(exp);
-			destroy_expect(exp);
-		}
-	}
-	/* Get rid of expecteds, set helpers to NULL. */
-	LIST_FIND_W(&unconfirmed, unhelp, struct ip_conntrack_tuple_hash*, me);
-	for (i =3D 0; i < ip_conntrack_htable_size; i++)
-		LIST_FIND_W(&ip_conntrack_hash[i], unhelp,
-			    struct ip_conntrack_tuple_hash *, me);
-	WRITE_UNLOCK(&ip_conntrack_lock);
-
-	/* Someone could be still looking at the helper in a bh. */
-	synchronize_net();
-}
=20
 static inline void ct_add_counters(struct ip_conntrack *ct,
 				   enum ip_conntrack_info ctinfo,
@@ -1017,7 +960,7 @@
 			break;
 	}
 	if (!h)
-		h =3D LIST_FIND_W(&unconfirmed, do_iter,
+		h =3D LIST_FIND_W(&ip_conntrack_unconfirmed, do_iter,
 				struct ip_conntrack_tuple_hash *, iter, data);
 	if (h)
 		atomic_inc(&tuplehash_to_ctrack(h)->ct_general.use);
@@ -1141,6 +1084,7 @@
 	kmem_cache_destroy(ip_conntrack_expect_cachep);
 	free_conntrack_hash();
 	nf_unregister_sockopt(&so_getorigdst);
+	ip_conntrack_helper_fini();
 }
=20
 static int hashsize;
@@ -1234,8 +1178,14 @@
 	/*  - and look it like as a confirmed connection */
 	set_bit(IPS_CONFIRMED_BIT, &ip_conntrack_untracked.status);
=20
+	ret =3D ip_conntrack_helper_init();
+	if (ret !=3D 0)
+		goto err_free_exp_slab;
+
 	return ret;
=20
+err_free_exp_slab:
+	kmem_cache_destroy(ip_conntrack_expect_cachep);
 err_free_conntrack_slab:
 	kmem_cache_destroy(ip_conntrack_cachep);
 err_free_hash:
diff -Nru --exclude .depend --exclude '*.o' --exclude '*.ko' --exclude '*.v=
er' --exclude '.*.flags' --exclude '*.orig' --exclude '*.rej' --exclude '*.=
cmd' --exclude '*.mod.c' --exclude '*~' linux-2.6.11-rc4/net/ipv4/netfilter=
/ip_conntrack_helper.c linux-2.6.11-rc4-helper_sysctl/net/ipv4/netfilter/ip=
_conntrack_helper.c
--- linux-2.6.11-rc4/net/ipv4/netfilter/ip_conntrack_helper.c	1970-01-01 01=
:00:00.000000000 +0100
+++ linux-2.6.11-rc4-helper_sysctl/net/ipv4/netfilter/ip_conntrack_helper.c=
	2005-02-13 17:46:42.000000000 +0100
@@ -0,0 +1,338 @@
+/* Dynamic conntrack helper to port binding
+ * (C) 2005 by Harald Welte <laforge@netfilter.org>
+ *
+ * Portions (C) 1999-2001 Paul `Rusty' Russell =20
+ * 	    (C) 2002-2005 Netfilter Core Team <coreteam@netfilter.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * 13 Feb 2005: Harald Welte <laforge@netfilter.org>
+ * 	- seperate out helper support from ip_conntrack_core
+ */
+
+#include <linux/module.h>
+#include <linux/config.h>
+#include <linux/proc_fs.h>
+#include <linux/seq_file.h>
+
+#include <linux/skbuff.h>
+#include <linux/netdevice.h>
+
+#define ASSERT_READ_LOCK(x) MUST_BE_READ_LOCKED(&ip_conntrack_lock)
+#define ASSERT_WRITE_LOCK(x) MUST_BE_WRITE_LOCKED(&ip_conntrack_lock)
+=20
+#include <linux/netfilter_ipv4/listhelp.h>
+#include <linux/netfilter_ipv4/ip_conntrack.h>
+#include <linux/netfilter_ipv4/ip_conntrack_core.h>
+#include <linux/netfilter_ipv4/ip_conntrack_helper.h>
+
+static LIST_HEAD(helpers);
+static LIST_HEAD(helper_ports);
+
+struct helper_port {
+	struct list_head		list;
+	struct ip_conntrack_helper	*helper;
+	struct ip_conntrack_tuple	tuple;
+};
+
+static struct helper_port *_hp_find_byport(struct ip_conntrack_helper *h,=
=20
+					   u_int16_t port)
+{
+	struct helper_port *hp;
+=09
+	/* Must be locked under ip_conntrack_lock */
+	list_for_each_entry(hp, &helper_ports, list) {
+		if (hp->helper =3D=3D h &&=20
+		    hp->tuple.src.u.tcp.port =3D=3D htons(port))
+			return hp;
+	}
+	return NULL;
+}
+
+int ip_conntrack_helper_add_port(struct ip_conntrack_helper *h, u_int16_t =
port)
+{
+	struct helper_port *hp;
+
+	hp =3D kmalloc(sizeof(*hp), GFP_KERNEL);
+	if (!hp)
+		return -ENOMEM;
+
+	/* Fill in the data */
+	hp->helper =3D h;
+	memcpy(&hp->tuple, &h->tuple, sizeof(struct ip_conntrack_tuple));
+	/* FIXME: this is a bit of a hack */
+	hp->tuple.src.u.tcp.port =3D htons(port);
+
+	WRITE_LOCK(&ip_conntrack_lock);
+
+	if (_hp_find_byport(h, port)) {
+		WRITE_UNLOCK(&ip_conntrack_lock);
+		kfree(hp);
+		return -EEXIST;
+	}
+
+	list_add(&hp->list, &helper_ports);
+
+	WRITE_UNLOCK(&ip_conntrack_lock);
+
+	return 0;
+}
+
+int ip_conntrack_helper_del_port(struct ip_conntrack_helper *h, u_int16_t =
port)
+{
+	struct helper_port *hp;
+
+	WRITE_LOCK(&ip_conntrack_lock);
+
+	hp =3D _hp_find_byport(h, port);
+
+	if (!hp) {
+		WRITE_UNLOCK(&ip_conntrack_lock);
+		return -ENODEV;
+	}
+
+	list_del(&hp->list);
+
+	WRITE_UNLOCK(&ip_conntrack_lock);
+
+	kfree(hp);
+
+	return 0;
+}
+
+#ifdef CONFIG_PROC_FS
+static struct proc_dir_entry *helper_procdir;
+
+static void *helper_seq_start(struct seq_file *s, loff_t *pos)
+{
+	struct proc_dir_entry *pde =3D s->private;
+	struct ip_conntrack_helper *h =3D pde->data;
+	struct helper_port *hp;
+	int i =3D 0;
+
+	/* strange seq_file aop calls stop even if start fails,
+	 * thus we need to unconditionally grab the lock */
+	READ_LOCK(&ip_conntrack_lock);
+
+	if (list_empty(&helper_ports))
+		return NULL;
+
+	list_for_each_entry(hp, &helper_ports, list) {
+		if (hp->helper =3D=3D h) {
+			if (i =3D=3D *pos)=20
+				return hp;
+			i++;
+		}
+	}
+
+	return NULL;
+}
+
+static void *helper_seq_next(struct seq_file *s, void *v, loff_t *pos)
+{
+	struct proc_dir_entry *pde =3D s->private;
+	struct ip_conntrack_helper *h =3D pde->data;
+	struct helper_port *hp =3D v;
+
+	(*pos)++;
+	list_for_each_entry(hp, &hp->list, list) {
+		/* end traversal at list head */
+		if ((struct list_head *) hp =3D=3D &helper_ports)
+			return NULL;
+		if (hp->helper =3D=3D h) {
+			return hp;
+		}
+	}
+
+	return NULL;
+}
+
+static void helper_seq_stop(struct seq_file *s, void *v)
+{
+	READ_UNLOCK(&ip_conntrack_lock);
+}
+
+static int helper_seq_show(struct seq_file *s, void *v)
+{
+	struct helper_port *hp =3D v;
+
+	return seq_printf(s, "%u\n", ntohs(hp->tuple.src.u.tcp.port));
+}
+
+static struct seq_operations helper_seq_ops =3D {
+	.start	=3D helper_seq_start,
+	.next	=3D helper_seq_next,
+	.stop	=3D helper_seq_stop,
+	.show	=3D helper_seq_show,
+};
+
+static int helper_proc_open(struct inode *inode, struct file *file)
+{
+	int ret =3D seq_open(file, &helper_seq_ops);
+
+	if (!ret) {
+		struct seq_file *sf =3D file->private_data;
+		struct proc_dir_entry *pde =3D PDE(inode);
+
+		sf->private =3D pde;
+		/* FIXME: do we have to increase usage count ?*/
+	}
+
+	return ret;
+}
+
+static int helper_proc_release(struct inode *inode, struct file *file)
+{
+	int ret;
+
+	ret =3D seq_release(inode, file);
+
+	return ret;
+}
+
+static ssize_t helper_proc_write(struct file *file, const char __user *inp=
ut,
+				 size_t size, loff_t *ofs)
+{
+#define PROC_WRITELEN	10
+	char buffer[PROC_WRITELEN+1];
+	struct proc_dir_entry *pde =3D PDE(file->f_dentry->d_inode);
+	struct ip_conntrack_helper *h =3D pde->data;
+	unsigned long port;
+
+	if (copy_from_user(buffer, input, PROC_WRITELEN))
+		return -EFAULT;
+
+	if (*buffer =3D=3D '+') {
+		port =3D simple_strtoul(buffer+1, NULL, 10);
+		if (ip_conntrack_helper_add_port(h, port))
+			return -EINVAL;
+	} else if (*buffer =3D=3D '-') {
+		port =3D simple_strtoul(buffer+1, NULL, 10);
+		if (ip_conntrack_helper_del_port(h, port))
+			return -EINVAL;
+	} else
+		return -EIO;
+
+	return size;
+}
+
+static struct file_operations helper_proc_fops =3D {
+	.owner	=3D THIS_MODULE,
+	.open	=3D helper_proc_open,
+	.read	=3D seq_read,
+	.write	=3D helper_proc_write,
+	.llseek	=3D seq_lseek,
+	.release =3D helper_proc_release,
+};
+
+#endif
+
+static inline int helper_cmp(const struct ip_conntrack_helper *i,
+			     const struct ip_conntrack_tuple *rtuple)
+{
+	return ip_ct_tuple_mask_cmp(rtuple, &i->tuple, &i->mask);
+}
+
+struct ip_conntrack_helper *ip_ct_find_helper(const struct ip_conntrack_tu=
ple *tuple)
+{
+	return LIST_FIND(&helpers, helper_cmp,
+			 struct ip_conntrack_helper *,
+			 tuple);
+}
+
+
+int ip_conntrack_helper_register(struct ip_conntrack_helper *me)
+{
+	BUG_ON(me->timeout =3D=3D 0);
+
+
+	WRITE_LOCK(&ip_conntrack_lock);
+	list_prepend(&helpers, me);
+	WRITE_UNLOCK(&ip_conntrack_lock);
+
+#ifdef CONFIG_PROC_FS
+	me->pde =3D create_proc_entry(me->name, S_IWUSR|S_IRUSR, helper_procdir);
+	if (!me->pde)
+		return 1;
+	me->pde->proc_fops =3D &helper_proc_fops;
+	me->pde->data =3D me;
+#endif
+
+	return 0;
+}
+
+static inline int unhelp(struct ip_conntrack_tuple_hash *i,
+			 const struct ip_conntrack_helper *me)
+{
+	if (tuplehash_to_ctrack(i)->helper =3D=3D me)
+		tuplehash_to_ctrack(i)->helper =3D NULL;
+	return 0;
+}
+
+void ip_conntrack_helper_unregister(struct ip_conntrack_helper *me)
+{
+	unsigned int i;
+	struct ip_conntrack_expect *exp, *tmp;
+	struct helper_port *hp, *hp2;
+
+#ifdef CONFIG_PROC_FS
+	remove_proc_entry(me->pde->name, me->pde->parent);
+#endif
+
+	/* Need write lock here, to delete helper. */
+	WRITE_LOCK(&ip_conntrack_lock);
+
+	/* First delete us from global list of helpers */
+	LIST_DELETE(&helpers, me);
+
+	/* Then delete us from helper_ports */
+	list_for_each_entry_safe(hp, hp2, &helper_ports, list) {
+		if (hp->helper =3D=3D me) {
+			list_del(&hp->list);
+			kfree(hp);
+		}
+	}
+
+	/* Get rid of expectations */
+	list_for_each_entry_safe(exp, tmp, &ip_conntrack_expect_list, list) {
+		if (exp->master->helper =3D=3D me && del_timer(&exp->timeout)) {
+			__ip_ct_unlink_expect(exp);
+			__ip_ct_destroy_expect(exp);
+		}
+	}
+	/* Get rid of expecteds, set helpers to NULL. */
+	LIST_FIND_W(&ip_conntrack_unconfirmed,=20
+		    unhelp, struct ip_conntrack_tuple_hash*, me);
+	for (i =3D 0; i < ip_conntrack_htable_size; i++)
+		LIST_FIND_W(&ip_conntrack_hash[i], unhelp,
+			    struct ip_conntrack_tuple_hash *, me);
+	WRITE_UNLOCK(&ip_conntrack_lock);
+
+	/* Someone could be still looking at the helper in a bh. */
+	synchronize_net();
+}
+
+int ip_conntrack_helper_init(void)
+{
+#ifdef CONFIG_PROC_FS
+	helper_procdir =3D proc_mkdir("ip_conntrack_helper", proc_net);
+	if (!helper_procdir) {
+		printk(KERN_ERR "ip_conntrack_helper: unable to create proc\n");
+		return -ENOMEM;
+	}
+#endif
+
+	return 0;
+}
+
+void ip_conntrack_helper_fini(void)
+{
+#ifdef CONFIG_PROC_FS
+	remove_proc_entry(helper_procdir->name, helper_procdir->parent);
+#endif
+}
+
+EXPORT_SYMBOL(ip_conntrack_helper_add_port);
+EXPORT_SYMBOL(ip_conntrack_helper_del_port);
diff -Nru --exclude .depend --exclude '*.o' --exclude '*.ko' --exclude '*.v=
er' --exclude '.*.flags' --exclude '*.orig' --exclude '*.rej' --exclude '*.=
cmd' --exclude '*.mod.c' --exclude '*~' linux-2.6.11-rc4/net/ipv4/netfilter=
/ip_conntrack_standalone.c linux-2.6.11-rc4-helper_sysctl/net/ipv4/netfilte=
r/ip_conntrack_standalone.c
--- linux-2.6.11-rc4/net/ipv4/netfilter/ip_conntrack_standalone.c	2005-02-1=
3 13:52:06.000000000 +0100
+++ linux-2.6.11-rc4-helper_sysctl/net/ipv4/netfilter/ip_conntrack_standalo=
ne.c	2005-02-13 16:14:26.000000000 +0100
@@ -918,3 +918,6 @@
 #ifdef CONFIG_IP_NF_NAT_NEEDED
 EXPORT_SYMBOL(ip_conntrack_tcp_update);
 #endif
+EXPORT_SYMBOL(__ip_ct_unlink_expect);
+EXPORT_SYMBOL(__ip_ct_destroy_expect);
+EXPORT_SYMBOL(ip_conntrack_unconfirmed);


--acOuGx3oQeOcSZJu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment;
	filename="2.6.11-rc4-ip_conntrack_helper_proc-helpers.patch"
Content-Transfer-Encoding: quoted-printable

diff -Nru --exclude .depend --exclude '*.o' --exclude '*.ko' --exclude '*.v=
er' --exclude '.*.flags' --exclude '*.orig' --exclude '*.rej' --exclude '*.=
cmd' --exclude '*.mod.c' --exclude '*~' linux-2.6.11-rc4/net/ipv4/netfilter=
/ip_conntrack_ftp.c linux-2.6.11-rc4-helper_sysctl/net/ipv4/netfilter/ip_co=
nntrack_ftp.c
--- linux-2.6.11-rc4/net/ipv4/netfilter/ip_conntrack_ftp.c	2005-02-13 13:52=
:06.000000000 +0100
+++ linux-2.6.11-rc4-helper_sysctl/net/ipv4/netfilter/ip_conntrack_ftp.c	20=
05-02-13 17:39:03.000000000 +0100
@@ -1,7 +1,7 @@
 /* FTP extension for IP connection tracking. */
=20
 /* (C) 1999-2001 Paul `Rusty' Russell =20
- * (C) 2002-2004 Netfilter Core Team <coreteam@netfilter.org>
+ * (C) 2002-2005 Netfilter Core Team <coreteam@netfilter.org>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -446,48 +446,43 @@
 	return ret;
 }
=20
-static struct ip_conntrack_helper ftp[MAX_PORTS];
-static char ftp_names[MAX_PORTS][10];
+static struct ip_conntrack_helper ftp =3D {
+	.name 		=3D "ftp",
+	.help 		=3D &help,
+	.me 		=3D THIS_MODULE,
+	.timeout	=3D 5 * 60,	/* 5 minutes */
+	.max_expected	=3D 1,
+	.mask		=3D {=20
+			.dst.protonum 	=3D 0xff,=20
+			.src.u.tcp.port	=3D 0xffff,
+		},
+	.tuple		=3D {=20
+			.dst.protonum 	=3D IPPROTO_TCP,
+			.src.u.tcp.port	=3D __constant_htons(21),
+		},
+};
=20
 /* Not __exit: called from init() */
 static void fini(void)
 {
-	int i;
-	for (i =3D 0; i < ports_c; i++) {
-		DEBUGP("ip_ct_ftp: unregistering helper for port %d\n",
-				ports[i]);
-		ip_conntrack_helper_unregister(&ftp[i]);
-	}
+	ip_conntrack_helper_unregister(&ftp);
 }
=20
 static int __init init(void)
 {
 	int i, ret;
-	char *tmpname;
=20
-	if (ports_c =3D=3D 0)
-		ports[ports_c++] =3D FTP_PORT;
+	if (ports_c =3D=3D 0) {
+		ports[0] =3D 21;
+		ports_c =3D 1;
+	}
+=09
+	ret =3D ip_conntrack_helper_register(&ftp);
=20
 	for (i =3D 0; i < ports_c; i++) {
-		ftp[i].tuple.src.u.tcp.port =3D htons(ports[i]);
-		ftp[i].tuple.dst.protonum =3D IPPROTO_TCP;
-		ftp[i].mask.src.u.tcp.port =3D 0xFFFF;
-		ftp[i].mask.dst.protonum =3D 0xFF;
-		ftp[i].max_expected =3D 1;
-		ftp[i].timeout =3D 5 * 60; /* 5 minutes */
-		ftp[i].me =3D THIS_MODULE;
-		ftp[i].help =3D help;
-
-		tmpname =3D &ftp_names[i][0];
-		if (ports[i] =3D=3D FTP_PORT)
-			sprintf(tmpname, "ftp");
-		else
-			sprintf(tmpname, "ftp-%d", ports[i]);
-		ftp[i].name =3D tmpname;
-
 		DEBUGP("ip_ct_ftp: registering helper for port %d\n",=20
 				ports[i]);
-		ret =3D ip_conntrack_helper_register(&ftp[i]);
+		ret =3D ip_conntrack_helper_add_port(&ftp, ports[i]);
=20
 		if (ret) {
 			fini();
diff -Nru --exclude .depend --exclude '*.o' --exclude '*.ko' --exclude '*.v=
er' --exclude '.*.flags' --exclude '*.orig' --exclude '*.rej' --exclude '*.=
cmd' --exclude '*.mod.c' --exclude '*~' linux-2.6.11-rc4/net/ipv4/netfilter=
/ip_conntrack_irc.c linux-2.6.11-rc4-helper_sysctl/net/ipv4/netfilter/ip_co=
nntrack_irc.c
--- linux-2.6.11-rc4/net/ipv4/netfilter/ip_conntrack_irc.c	2005-02-13 13:52=
:06.000000000 +0100
+++ linux-2.6.11-rc4-helper_sysctl/net/ipv4/netfilter/ip_conntrack_irc.c	20=
05-02-13 17:39:29.000000000 +0100
@@ -1,5 +1,5 @@
 /* IRC extension for IP connection tracking, Version 1.21
- * (C) 2000-2002 by Harald Welte <laforge@gnumonks.org>
+ * (C) 2000-2005 by Harald Welte <laforge@gnumonks.org>
  * based on RR's ip_conntrack_ftp.c=09
  *
  * ip_conntrack_irc.c,v 1.21 2002/02/05 14:49:26 laforge Exp
@@ -241,16 +241,25 @@
 	return ret;
 }
=20
-static struct ip_conntrack_helper irc_helpers[MAX_PORTS];
-static char irc_names[MAX_PORTS][10];
+static struct ip_conntrack_helper irc_helper =3D {
+	.name		=3D "irc",
+	.help		=3D &help,
+	.me		=3D THIS_MODULE,
+	.mask		=3D {
+			.dst.protonum	=3D 0xff,
+			.src.u.tcp.port	=3D 0xffff,
+		},
+	.tuple		=3D {
+			.dst.protonum	=3D IPPROTO_TCP,
+			.src.u.tcp.port	=3D __constant_htons(6667),
+		},
+};
=20
 static void fini(void);
=20
 static int __init init(void)
 {
 	int i, ret;
-	struct ip_conntrack_helper *hlpr;
-	char *tmpname;
=20
 	if (max_dcc_channels < 1) {
 		printk("ip_conntrack_irc: max_dcc_channels must be a positive integer\n"=
);
@@ -260,32 +269,19 @@
 		printk("ip_conntrack_irc: dcc_timeout must be a positive integer\n");
 		return -EBUSY;
 	}
-=09
-	/* If no port given, default to standard irc port */
-	if (ports_c =3D=3D 0)
-		ports[ports_c++] =3D IRC_PORT;
=20
-	for (i =3D 0; i < ports_c; i++) {
-		hlpr =3D &irc_helpers[i];
-		hlpr->tuple.src.u.tcp.port =3D htons(ports[i]);
-		hlpr->tuple.dst.protonum =3D IPPROTO_TCP;
-		hlpr->mask.src.u.tcp.port =3D 0xFFFF;
-		hlpr->mask.dst.protonum =3D 0xFF;
-		hlpr->max_expected =3D max_dcc_channels;
-		hlpr->timeout =3D dcc_timeout;
-		hlpr->me =3D THIS_MODULE;
-		hlpr->help =3D help;
-
-		tmpname =3D &irc_names[i][0];
-		if (ports[i] =3D=3D IRC_PORT)
-			sprintf(tmpname, "irc");
-		else
-			sprintf(tmpname, "irc-%d", i);
-		hlpr->name =3D tmpname;
+	irc_helper.timeout =3D dcc_timeout;
+	irc_helper.max_expected =3D max_dcc_channels;
+=09
+	if (ports_c =3D=3D 0) {
+		ports[0] =3D 6667;
+		ports_c =3D 1;
+	}
=20
-		DEBUGP("port #%d: %d\n", i, ports[i]);
+	ret =3D ip_conntrack_helper_register(&irc_helper);
=20
-		ret =3D ip_conntrack_helper_register(hlpr);
+	for (i =3D 0; i < ports_c; i++) {
+		ret =3D ip_conntrack_helper_add_port(&irc_helper, ports[i]);
=20
 		if (ret) {
 			printk("ip_conntrack_irc: ERROR registering port %d\n",
@@ -301,12 +297,7 @@
  * it is needed by the init function */
 static void fini(void)
 {
-	int i;
-	for (i =3D 0; i < ports_c; i++) {
-		DEBUGP("unregistering port %d\n",
-		       ports[i]);
-		ip_conntrack_helper_unregister(&irc_helpers[i]);
-	}
+	ip_conntrack_helper_unregister(&irc_helper);
 }
=20
 module_init(init);
diff -Nru --exclude .depend --exclude '*.o' --exclude '*.ko' --exclude '*.v=
er' --exclude '.*.flags' --exclude '*.orig' --exclude '*.rej' --exclude '*.=
cmd' --exclude '*.mod.c' --exclude '*~' linux-2.6.11-rc4/net/ipv4/netfilter=
/ip_conntrack_tftp.c linux-2.6.11-rc4-helper_sysctl/net/ipv4/netfilter/ip_c=
onntrack_tftp.c
--- linux-2.6.11-rc4/net/ipv4/netfilter/ip_conntrack_tftp.c	2005-02-13 13:5=
2:06.000000000 +0100
+++ linux-2.6.11-rc4-helper_sysctl/net/ipv4/netfilter/ip_conntrack_tftp.c	2=
005-02-13 17:44:55.000000000 +0100
@@ -100,51 +100,38 @@
 	return NF_ACCEPT;
 }
=20
-static struct ip_conntrack_helper tftp[MAX_PORTS];
-static char tftp_names[MAX_PORTS][10];
+static struct ip_conntrack_helper tftp_helper =3D {
+	.name 		=3D "tftp",
+	.help		=3D &tftp_help,
+	.me		=3D THIS_MODULE,
+	.timeout	=3D 5 * 60,	/* 5 minutes */
+	.max_expected	=3D 1,
+	.mask		=3D {
+			.src.u.udp.port =3D 0xffff,
+			.dst.protonum	=3D 0xff,
+		},
+	.tuple		=3D {
+			.src.u.udp.port =3D TFTP_PORT,
+			.dst.protonum	=3D IPPROTO_UDP,
+		},
+};
=20
 static void fini(void)
 {
-	int i;
-
-	for (i =3D 0 ; i < ports_c; i++) {
-		DEBUGP("unregistering helper for port %d\n",
-			ports[i]);
-		ip_conntrack_helper_unregister(&tftp[i]);
-	}=20
+	ip_conntrack_helper_unregister(&tftp_helper);
 }
=20
 static int __init init(void)
 {
 	int i, ret;
-	char *tmpname;
=20
 	if (ports_c =3D=3D 0)
 		ports[ports_c++] =3D TFTP_PORT;
=20
 	for (i =3D 0; i < ports_c; i++) {
-		/* Create helper structure */
-		memset(&tftp[i], 0, sizeof(struct ip_conntrack_helper));
-
-		tftp[i].tuple.dst.protonum =3D IPPROTO_UDP;
-		tftp[i].tuple.src.u.udp.port =3D htons(ports[i]);
-		tftp[i].mask.dst.protonum =3D 0xFF;
-		tftp[i].mask.src.u.udp.port =3D 0xFFFF;
-		tftp[i].max_expected =3D 1;
-		tftp[i].timeout =3D 5 * 60; /* 5 minutes */
-		tftp[i].me =3D THIS_MODULE;
-		tftp[i].help =3D tftp_help;
-
-		tmpname =3D &tftp_names[i][0];
-		if (ports[i] =3D=3D TFTP_PORT)
-			sprintf(tmpname, "tftp");
-		else
-			sprintf(tmpname, "tftp-%d", i);
-		tftp[i].name =3D tmpname;
-
 		DEBUGP("port #%d: %d\n", i, ports[i]);
=20
-		ret=3Dip_conntrack_helper_register(&tftp[i]);
+		ret =3D ip_conntrack_helper_add_port(&tftp_helper, ports[i]);
 		if (ret) {
 			printk("ERROR registering helper for port %d\n",
 				ports[i]);

--acOuGx3oQeOcSZJu--

--4IFtMBbmeqbTM/ox
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)

iD8DBQFCD4bGXaXGVTD0i/8RApAbAJ9pggcqjumBzVnJOHzccj49UX+BmQCbB3XD
IhKBIvf15hZki/z+reXofqs=
=nb7M
-----END PGP SIGNATURE-----

--4IFtMBbmeqbTM/ox--
