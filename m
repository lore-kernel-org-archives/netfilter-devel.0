From: Harald Welte <laforge@netfilter.org>
Subject: [PATCH] netfilter 2.5 fixes (all 7 in one patch)
Date: Tue, 24 Jun 2003 16:57:27 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030624145727.GK2645@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tBhgiDt8dP1efIIJ"
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


--tBhgiDt8dP1efIIJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave!

I've now created big cumulative 2.5.x patch to bring 2.5.73 in sync with
the 7 fixes for 2.4.21 I've sent you previously.
=20
diff -Nru --exclude .depend --exclude '*.o' --exclude '*.ko' --exclude '*.v=
er' --exclude '.*.flags' --exclude '*.orig' --exclude '*.rej' --exclude '*.=
cmd' --exclude '*.mod.c' --exclude '*~' linux-2.5.73-plain/include/linux/ne=
tfilter_ipv4/listhelp.h linux-2.5.73-nf_fixes/include/linux/netfilter_ipv4/=
listhelp.h
--- linux-2.5.73-plain/include/linux/netfilter_ipv4/listhelp.h	2003-06-22 2=
0:32:33.000000000 +0200
+++ linux-2.5.73-nf_fixes/include/linux/netfilter_ipv4/listhelp.h	2003-06-2=
4 16:45:54.000000000 +0200
@@ -39,6 +39,22 @@
 	(type)__i;				\
 })
=20
+/* Just like LIST_FIND but we search backwards */
+#define LIST_FIND_B(head, cmpfn, type, args...)		\
+({							\
+	const struct list_head *__i =3D (head);		\
+							\
+	ASSERT_READ_LOCK(head);				\
+	do {						\
+		__i =3D __i->prev;			\
+		if (__i =3D=3D (head)) {			\
+			__i =3D NULL;			\
+			break;				\
+		}					\
+	} while (!cmpfn((const type)__i , ## args));	\
+	(type)__i;					\
+})
+
 static inline int
 __list_cmp_same(const void *p1, const void *p2) { return p1 =3D=3D p2; }
=20
diff -Nru --exclude .depend --exclude '*.o' --exclude '*.ko' --exclude '*.v=
er' --exclude '.*.flags' --exclude '*.orig' --exclude '*.rej' --exclude '*.=
cmd' --exclude '*.mod.c' --exclude '*~' linux-2.5.73-plain/include/linux/ne=
tfilter_ipv4/lockhelp.h linux-2.5.73-nf_fixes/include/linux/netfilter_ipv4/=
lockhelp.h
--- linux-2.5.73-plain/include/linux/netfilter_ipv4/lockhelp.h	2003-06-22 2=
0:32:32.000000000 +0200
+++ linux-2.5.73-nf_fixes/include/linux/netfilter_ipv4/lockhelp.h	2003-06-2=
4 16:49:42.000000000 +0200
@@ -42,22 +42,22 @@
 	printk("ASSERT %s:%u %s locked\n", __FILE__, __LINE__, #l);	\
 } while(0)
=20
-/* Write locked OK as well. */						    \
+/* Write locked OK as well. */
 #define MUST_BE_READ_LOCKED(l)						    \
-do { if (!((l)->read_locked_map & (1 << smp_processor_id()))		    \
-	 && !((l)->write_locked_map & (1 << smp_processor_id())))	    \
+do { if (!((l)->read_locked_map & (1UL << smp_processor_id()))		    \
+	 && !((l)->write_locked_map & (1UL << smp_processor_id())))	    \
 	printk("ASSERT %s:%u %s not readlocked\n", __FILE__, __LINE__, #l); \
 } while(0)
=20
 #define MUST_BE_WRITE_LOCKED(l)						     \
-do { if (!((l)->write_locked_map & (1 << smp_processor_id())))		     \
+do { if (!((l)->write_locked_map & (1UL << smp_processor_id())))	     \
 	printk("ASSERT %s:%u %s not writelocked\n", __FILE__, __LINE__, #l); \
 } while(0)
=20
 #define MUST_BE_READ_WRITE_UNLOCKED(l)					  \
-do { if ((l)->read_locked_map & (1 << smp_processor_id()))		  \
+do { if ((l)->read_locked_map & (1UL << smp_processor_id()))		  \
 	printk("ASSERT %s:%u %s readlocked\n", __FILE__, __LINE__, #l);	  \
- else if ((l)->write_locked_map & (1 << smp_processor_id()))		  \
+ else if ((l)->write_locked_map & (1UL << smp_processor_id()))		  \
 	 printk("ASSERT %s:%u %s writelocked\n", __FILE__, __LINE__, #l); \
 } while(0)
=20
@@ -91,7 +91,7 @@
=20
 #define READ_UNLOCK(lk)							\
 do {									\
-	if (!((lk)->read_locked_map & (1 << smp_processor_id())))	\
+	if (!((lk)->read_locked_map & (1UL << smp_processor_id())))	\
 		printk("ASSERT: %s:%u %s not readlocked\n", 		\
 		       __FILE__, __LINE__, #lk);			\
 	clear_bit(smp_processor_id(), &(lk)->read_locked_map);		\
diff -Nru --exclude .depend --exclude '*.o' --exclude '*.ko' --exclude '*.v=
er' --exclude '.*.flags' --exclude '*.orig' --exclude '*.rej' --exclude '*.=
cmd' --exclude '*.mod.c' --exclude '*~' linux-2.5.73-plain/net/ipv4/netfilt=
er/ip_conntrack_core.c linux-2.5.73-nf_fixes/net/ipv4/netfilter/ip_conntrac=
k_core.c
--- linux-2.5.73-plain/net/ipv4/netfilter/ip_conntrack_core.c	2003-06-22 20=
:32:27.000000000 +0200
+++ linux-2.5.73-nf_fixes/net/ipv4/netfilter/ip_conntrack_core.c	2003-06-24=
 16:58:24.000000000 +0200
@@ -168,8 +168,8 @@
 static void
 destroy_expect(struct ip_conntrack_expect *exp)
 {
-	DEBUGP("destroy_expect(%p) use=3D%d\n", exp, atomic_read(exp->use));
-	IP_NF_ASSERT(atomic_read(exp->use));
+	DEBUGP("destroy_expect(%p) use=3D%d\n", exp, atomic_read(&exp->use));
+	IP_NF_ASSERT(atomic_read(&exp->use));
 	IP_NF_ASSERT(!timer_pending(&exp->timeout));
=20
 	kfree(exp);
@@ -576,7 +576,7 @@
 	int dropped =3D 0;
=20
 	READ_LOCK(&ip_conntrack_lock);
-	h =3D LIST_FIND(chain, unreplied, struct ip_conntrack_tuple_hash *);
+	h =3D LIST_FIND_B(chain, unreplied, struct ip_conntrack_tuple_hash *);
 	if (h)
 		atomic_inc(&h->ctrack->ct_general.use);
 	READ_UNLOCK(&ip_conntrack_lock);
@@ -685,6 +685,14 @@
 			     struct ip_conntrack_expect *, tuple);
 	READ_UNLOCK(&ip_conntrack_expect_tuple_lock);
=20
+	/* If master is not in hash table yet (ie. packet hasn't left
+	   this machine yet), how can other end know about expected?
+	   Hence these are not the droids you are looking for (if
+	   master ct never got confirmed, we'd hold a reference to it
+	   and weird things would happen to future packets). */
+	if (expected && !is_confirmed(expected->expectant))
+		expected =3D NULL;
+
 	/* Look up the conntrack helper for master connections only */
 	if (!expected)
 		conntrack->helper =3D ip_ct_find_helper(&repl_tuple);
@@ -695,12 +703,7 @@
 	    && ! del_timer(&expected->timeout))
 		expected =3D NULL;
=20
-	/* If master is not in hash table yet (ie. packet hasn't left
-	   this machine yet), how can other end know about expected?
-	   Hence these are not the droids you are looking for (if
-	   master ct never got confirmed, we'd hold a reference to it
-	   and weird things would happen to future packets). */
-	if (expected && is_confirmed(expected->expectant)) {
+	if (expected) {
 		DEBUGP("conntrack: expectation arrives ct=3D%p exp=3D%p\n",
 			conntrack, expected);
 		/* Welcome, Mr. Bond.  We've been expecting you... */
@@ -1282,9 +1285,9 @@
 	struct inet_opt *inet =3D inet_sk(sk);
 	struct ip_conntrack_tuple_hash *h;
 	struct ip_conntrack_tuple tuple =3D { { inet->rcv_saddr,
-						{ inet->sport } },
+						{ .tcp =3D { inet->sport } } },
 					    { inet->daddr,
-						{ inet->dport },
+						{ .tcp =3D { inet->dport } },
 					      IPPROTO_TCP } };
=20
 	/* We only do TCP at the moment: is there a better way? */
diff -Nru --exclude .depend --exclude '*.o' --exclude '*.ko' --exclude '*.v=
er' --exclude '.*.flags' --exclude '*.orig' --exclude '*.rej' --exclude '*.=
cmd' --exclude '*.mod.c' --exclude '*~' linux-2.5.73-plain/net/ipv4/netfilt=
er/ip_conntrack_ftp.c linux-2.5.73-nf_fixes/net/ipv4/netfilter/ip_conntrack=
_ftp.c
--- linux-2.5.73-plain/net/ipv4/netfilter/ip_conntrack_ftp.c	2003-06-22 20:=
33:07.000000000 +0200
+++ linux-2.5.73-nf_fixes/net/ipv4/netfilter/ip_conntrack_ftp.c	2003-06-24 =
16:49:56.000000000 +0200
@@ -367,11 +367,11 @@
 		    { 0 } },
 		  { htonl((array[0] << 24) | (array[1] << 16)
 			  | (array[2] << 8) | array[3]),
-		    { htons(array[4] << 8 | array[5]) },
+		    { .tcp =3D { htons(array[4] << 8 | array[5]) } },
 		    IPPROTO_TCP }});
 	exp->mask =3D ((struct ip_conntrack_tuple)
 		{ { 0xFFFFFFFF, { 0 } },
-		  { 0xFFFFFFFF, { 0xFFFF }, 0xFFFF }});
+		  { 0xFFFFFFFF, { .tcp =3D { 0xFFFF } }, 0xFFFF }});
=20
 	exp->expectfn =3D NULL;
=20
diff -Nru --exclude .depend --exclude '*.o' --exclude '*.ko' --exclude '*.v=
er' --exclude '.*.flags' --exclude '*.orig' --exclude '*.rej' --exclude '*.=
cmd' --exclude '*.mod.c' --exclude '*~' linux-2.5.73-plain/net/ipv4/netfilt=
er/ip_conntrack_irc.c linux-2.5.73-nf_fixes/net/ipv4/netfilter/ip_conntrack=
_irc.c
--- linux-2.5.73-plain/net/ipv4/netfilter/ip_conntrack_irc.c	2003-06-22 20:=
33:07.000000000 +0200
+++ linux-2.5.73-nf_fixes/net/ipv4/netfilter/ip_conntrack_irc.c	2003-06-24 =
16:49:56.000000000 +0200
@@ -192,11 +192,11 @@
=20
 			exp->tuple =3D ((struct ip_conntrack_tuple)
 				{ { 0, { 0 } },
-				  { htonl(dcc_ip), { htons(dcc_port) },
+				  { htonl(dcc_ip), { .tcp =3D { htons(dcc_port) } },
 				    IPPROTO_TCP }});
 			exp->mask =3D ((struct ip_conntrack_tuple)
 				{ { 0, { 0 } },
-				  { 0xFFFFFFFF, { 0xFFFF }, 0xFFFF }});
+				  { 0xFFFFFFFF, { .tcp =3D { 0xFFFF } }, 0xFFFF }});
=20
 			exp->expectfn =3D NULL;
=20
diff -Nru --exclude .depend --exclude '*.o' --exclude '*.ko' --exclude '*.v=
er' --exclude '.*.flags' --exclude '*.orig' --exclude '*.rej' --exclude '*.=
cmd' --exclude '*.mod.c' --exclude '*~' linux-2.5.73-plain/net/ipv4/netfilt=
er/ip_nat_amanda.c linux-2.5.73-nf_fixes/net/ipv4/netfilter/ip_nat_amanda.c
--- linux-2.5.73-plain/net/ipv4/netfilter/ip_nat_amanda.c	2003-06-22 20:32:=
36.000000000 +0200
+++ linux-2.5.73-nf_fixes/net/ipv4/netfilter/ip_nat_amanda.c	2003-06-24 16:=
51:42.000000000 +0200
@@ -84,7 +84,7 @@
 		mr.range[0].flags |=3D IP_NAT_RANGE_PROTO_SPECIFIED;
 		mr.range[0].min =3D mr.range[0].max
 			=3D ((union ip_conntrack_manip_proto)
-				{ htons(port) });
+				{ .udp =3D { htons(port) } });
 	}
=20
 	return ip_nat_setup_info(ct, &mr, hooknum);
diff -Nru --exclude .depend --exclude '*.o' --exclude '*.ko' --exclude '*.v=
er' --exclude '.*.flags' --exclude '*.orig' --exclude '*.rej' --exclude '*.=
cmd' --exclude '*.mod.c' --exclude '*~' linux-2.5.73-plain/net/ipv4/netfilt=
er/ip_nat_core.c linux-2.5.73-nf_fixes/net/ipv4/netfilter/ip_nat_core.c
--- linux-2.5.73-plain/net/ipv4/netfilter/ip_nat_core.c	2003-06-22 20:32:34=
=2E000000000 +0200
+++ linux-2.5.73-nf_fixes/net/ipv4/netfilter/ip_nat_core.c	2003-06-24 16:49=
:08.000000000 +0200
@@ -763,6 +763,11 @@
 	enum ip_conntrack_dir dir =3D CTINFO2DIR(ctinfo);
 	int proto =3D (*pskb)->nh.iph->protocol;
=20
+	/* Skip everything and don't call helpers if there are no
+	 * manips for this connection */
+	if (info->num_manips =3D=3D 0)
+		return NF_ACCEPT;
+
 	/* Need nat lock to protect against modification, but neither
 	   conntrack (referenced) and helper (deleted with
 	   synchronize_bh()) can vanish. */
@@ -791,6 +796,7 @@
 		struct ip_conntrack_expect *exp =3D NULL;
 		struct list_head *cur_item;
 		int ret =3D NF_ACCEPT;
+		int helper_called =3D 0;
=20
 		DEBUGP("do_bindings: helper existing for (%p)\n", ct);
=20
@@ -809,19 +815,21 @@
 				continue;
=20
 			if (exp_for_packet(exp, *pskb)) {
-				/* FIXME: May be true multiple times in the case of UDP!! */
-				DEBUGP("calling nat helper (exp=3D%p) for packet\n",
-					exp);
+				/* FIXME: May be true multiple times in the
+				 * case of UDP!! */
+				DEBUGP("calling nat helper (exp=3D%p) for packet\n", exp);
 				ret =3D helper->help(ct, exp, info, ctinfo,=20
 						   hooknum, pskb);
 				if (ret !=3D NF_ACCEPT) {
 					READ_UNLOCK(&ip_conntrack_lock);
 					return ret;
 				}
+				helper_called =3D 1;
 			}
 		}
-		/* Helper might want to manip the packet even when there is no expectati=
on */
-		if (!exp && helper->flags & IP_NAT_HELPER_F_ALWAYS) {
+		/* Helper might want to manip the packet even when there is no
+		 * matching expectation for this packet */
+		if (!helper_called && helper->flags & IP_NAT_HELPER_F_ALWAYS) {
 			DEBUGP("calling nat helper for packet without expectation\n");
 			ret =3D helper->help(ct, NULL, info, ctinfo,=20
 					   hooknum, pskb);
diff -Nru --exclude .depend --exclude '*.o' --exclude '*.ko' --exclude '*.v=
er' --exclude '.*.flags' --exclude '*.orig' --exclude '*.rej' --exclude '*.=
cmd' --exclude '*.mod.c' --exclude '*~' linux-2.5.73-plain/net/ipv4/netfilt=
er/ip_nat_ftp.c linux-2.5.73-nf_fixes/net/ipv4/netfilter/ip_nat_ftp.c
--- linux-2.5.73-plain/net/ipv4/netfilter/ip_nat_ftp.c	2003-06-22 20:32:58.=
000000000 +0200
+++ linux-2.5.73-nf_fixes/net/ipv4/netfilter/ip_nat_ftp.c	2003-06-24 16:51:=
42.000000000 +0200
@@ -84,7 +84,7 @@
 		mr.range[0].flags |=3D IP_NAT_RANGE_PROTO_SPECIFIED;
 		mr.range[0].min =3D mr.range[0].max
 			=3D ((union ip_conntrack_manip_proto)
-				{ htons(exp_ftp_info->port) });
+				{ .tcp =3D { htons(exp_ftp_info->port) } });
 	}
 	return ip_nat_setup_info(ct, &mr, hooknum);
 }
diff -Nru --exclude .depend --exclude '*.o' --exclude '*.ko' --exclude '*.v=
er' --exclude '.*.flags' --exclude '*.orig' --exclude '*.rej' --exclude '*.=
cmd' --exclude '*.mod.c' --exclude '*~' linux-2.5.73-plain/net/ipv4/netfilt=
er/ip_nat_snmp_basic.c linux-2.5.73-nf_fixes/net/ipv4/netfilter/ip_nat_snmp=
_basic.c
--- linux-2.5.73-plain/net/ipv4/netfilter/ip_nat_snmp_basic.c	2003-06-22 20=
:33:08.000000000 +0200
+++ linux-2.5.73-nf_fixes/net/ipv4/netfilter/ip_nat_snmp_basic.c	2003-06-24=
 16:51:42.000000000 +0200
@@ -1308,9 +1308,9 @@
 	"snmp",
 	0,
 	THIS_MODULE,
-	{ { 0, { __constant_htons(SNMP_PORT) } },
+	{ { 0, { .udp =3D { __constant_htons(SNMP_PORT) } } },
 	  { 0, { 0 }, IPPROTO_UDP } },
-	{ { 0, { 0xFFFF } },
+	{ { 0, { .udp =3D { 0xFFFF } } },
 	  { 0, { 0 }, 0xFFFF } },
 	nat_help, NULL };
 =20
@@ -1319,9 +1319,9 @@
 	"snmp_trap",
 	0,
 	THIS_MODULE,
-	{ { 0, { __constant_htons(SNMP_TRAP_PORT) } },
+	{ { 0, { .udp =3D { __constant_htons(SNMP_TRAP_PORT) } } },
 	  { 0, { 0 }, IPPROTO_UDP } },
-	{ { 0, { 0xFFFF } },
+	{ { 0, { .udp =3D { 0xFFFF } } },
 	  { 0, { 0 }, 0xFFFF } },
 	nat_help, NULL };
=20
diff -Nru --exclude .depend --exclude '*.o' --exclude '*.ko' --exclude '*.v=
er' --exclude '.*.flags' --exclude '*.orig' --exclude '*.rej' --exclude '*.=
cmd' --exclude '*.mod.c' --exclude '*~' linux-2.5.73-plain/net/ipv6/netfilt=
er/ip6_tables.c linux-2.5.73-nf_fixes/net/ipv6/netfilter/ip6_tables.c
--- linux-2.5.73-plain/net/ipv6/netfilter/ip6_tables.c	2003-06-22 20:33:16.=
000000000 +0200
+++ linux-2.5.73-nf_fixes/net/ipv6/netfilter/ip6_tables.c	2003-06-24 16:49:=
49.000000000 +0200
@@ -101,10 +101,8 @@
 	unsigned int hook_entry[NF_IP6_NUMHOOKS];
 	unsigned int underflow[NF_IP6_NUMHOOKS];
=20
-	char padding[SMP_ALIGN((NF_IP6_NUMHOOKS*2+2)*sizeof(unsigned int))];
-
 	/* ip6t_entry tables: one per CPU */
-	char entries[0];
+	char entries[0] ____cacheline_aligned;
 };
=20
 static LIST_HEAD(ip6t_target);
@@ -1451,7 +1449,7 @@
 	int ret;
 	struct ip6t_table_info *newinfo;
 	static struct ip6t_table_info bootstrap
-		=3D { 0, 0, 0, { 0 }, { 0 }, { }, { } };
+		=3D { 0, 0, 0, { 0 }, { 0 }, { } };
=20
 	newinfo =3D vmalloc(sizeof(struct ip6t_table_info)
 			  + SMP_ALIGN(table->table->size) * NR_CPUS);

Please apply, thanks.

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--tBhgiDt8dP1efIIJ
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQE++GbXXaXGVTD0i/8RAnMkAKCM6iSn8rUROSGSdymm9QK9EpBWJwCeJp01
EvzaVVKdq/EzwUT2kzZapow=
=U4eA
-----END PGP SIGNATURE-----

--tBhgiDt8dP1efIIJ--
