From: Harald Welte <laforge@gnumonks.org>
Subject: [PATCH 2.6] netfilter resync with 2.4.x
Date: Fri, 20 Feb 2004 20:54:52 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040220195452.GM4797@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dnd11iroZwpv/0M5"
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


--dnd11iroZwpv/0M5
Content-Type: multipart/mixed; boundary="cW0eHRJ76X8TDo3d"
Content-Disposition: inline


--cW0eHRJ76X8TDo3d
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave!

The attached patch re-syncs 2.6.x netfilter with recent changes in
2.4.x.  Let's hope this is the last time we sync in this direction.

- update listhelp.h to benefit from prefetching
- more efficient selective_cleanup() implementation in conntrack
- export number of conntrack buckets via r/o sysctl

Please apply, thanks.

--=20
- Harald Welte <laforge@gnumonks.org>               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
Programming is like sex: One mistake and you have to support it your lifeti=
me

--cW0eHRJ76X8TDo3d
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="2.6.3-resync.diff"
Content-Transfer-Encoding: quoted-printable

diff -Nru --exclude .depend --exclude '*.o' --exclude '*.ko' --exclude '*.v=
er' --exclude '.*.flags' --exclude '*.orig' --exclude '*.rej' --exclude '*.=
cmd' --exclude '*.mod.c' --exclude '*~' linux-2.6.3-plain//include/linux/ne=
tfilter_ipv4/listhelp.h linux-2.6.3-nfsubmit/include/linux/netfilter_ipv4/l=
isthelp.h
--- linux-2.6.3-plain//include/linux/netfilter_ipv4/listhelp.h	2004-02-18 0=
4:57:16.000000000 +0100
+++ linux-2.6.3-nfsubmit/include/linux/netfilter_ipv4/listhelp.h	2004-02-20=
 20:53:43.000000000 +0100
@@ -11,48 +11,42 @@
    required to allow inlining of cmpfn. */
 #define LIST_FIND(head, cmpfn, type, args...)		\
 ({							\
-	const struct list_head *__i =3D (head);		\
+	const struct list_head *__i, *__j =3D NULL;	\
 							\
 	ASSERT_READ_LOCK(head);				\
-	do {						\
-		__i =3D __i->next;			\
-		if (__i =3D=3D (head)) {			\
-			__i =3D NULL;			\
+	list_for_each(__i, (head))			\
+		if (cmpfn((const type)__i , ## args)) {	\
+			__j =3D __i;			\
 			break;				\
 		}					\
-	} while (!cmpfn((const type)__i , ## args));	\
-	(type)__i;					\
+	(type)__j;					\
 })
=20
-#define LIST_FIND_W(head, cmpfn, type, args...)	\
-({						\
-	const struct list_head *__i =3D (head);	\
-						\
-	ASSERT_WRITE_LOCK(head);		\
-	do {					\
-		__i =3D __i->next;		\
-		if (__i =3D=3D (head)) {		\
-			__i =3D NULL;		\
-			break;			\
-		}				\
-	} while (!cmpfn((type)__i , ## args));	\
-	(type)__i;				\
+#define LIST_FIND_W(head, cmpfn, type, args...)		\
+({							\
+	const struct list_head *__i, *__j =3D NULL;	\
+							\
+	ASSERT_WRITE_LOCK(head);			\
+	list_for_each(__i, (head))			\
+		if (cmpfn((type)__i , ## args)) {	\
+			__j =3D __i;			\
+			break;				\
+		}					\
+	(type)__j;					\
 })
=20
 /* Just like LIST_FIND but we search backwards */
 #define LIST_FIND_B(head, cmpfn, type, args...)		\
 ({							\
-	const struct list_head *__i =3D (head);		\
+	const struct list_head *__i, *__j =3D NULL;	\
 							\
 	ASSERT_READ_LOCK(head);				\
-	do {						\
-		__i =3D __i->prev;			\
-		if (__i =3D=3D (head)) {			\
-			__i =3D NULL;			\
+	list_for_each_prev(__i, (head))			\
+		if (cmpfn((const type)__i , ## args)) {	\
+			__j =3D __i;			\
 			break;				\
 		}					\
-	} while (!cmpfn((const type)__i , ## args));	\
-	(type)__i;					\
+	(type)__j;					\
 })
=20
 static inline int
@@ -100,9 +94,9 @@
 do {								\
 	struct list_head *__i;					\
 	ASSERT_WRITE_LOCK(head);				\
-	for (__i =3D (head)->next;				\
-	     !cmpfn((new), (typeof (new))__i) && __i !=3D (head);	\
-	     __i =3D __i->next);					\
+	list_for_each(__i, (head))				\
+		if ((new), (typeof (new))__i)			\
+			break;					\
 	list_add((struct list_head *)(new), __i->prev);		\
 } while(0)
=20
diff -Nru --exclude .depend --exclude '*.o' --exclude '*.ko' --exclude '*.v=
er' --exclude '.*.flags' --exclude '*.orig' --exclude '*.rej' --exclude '*.=
cmd' --exclude '*.mod.c' --exclude '*~' linux-2.6.3-plain//net/ipv4/netfilt=
er/ip_conntrack_core.c linux-2.6.3-nfsubmit/net/ipv4/netfilter/ip_conntrack=
_core.c
--- linux-2.6.3-plain//net/ipv4/netfilter/ip_conntrack_core.c	2004-02-18 04=
:57:11.000000000 +0100
+++ linux-2.6.3-nfsubmit/net/ipv4/netfilter/ip_conntrack_core.c	2004-02-20 =
20:54:43.000000000 +0100
@@ -1240,14 +1240,13 @@
 /* Bring out ya dead! */
 static struct ip_conntrack_tuple_hash *
 get_next_corpse(int (*kill)(const struct ip_conntrack *i, void *data),
-		void *data)
+		void *data, unsigned int *bucket)
 {
 	struct ip_conntrack_tuple_hash *h =3D NULL;
-	unsigned int i;
=20
 	READ_LOCK(&ip_conntrack_lock);
-	for (i =3D 0; !h && i < ip_conntrack_htable_size; i++) {
-		h =3D LIST_FIND(&ip_conntrack_hash[i], do_kill,
+	for (; !h && *bucket < ip_conntrack_htable_size; (*bucket)++) {
+		h =3D LIST_FIND(&ip_conntrack_hash[*bucket], do_kill,
 			      struct ip_conntrack_tuple_hash *, kill, data);
 	}
 	if (h)
@@ -1262,9 +1261,9 @@
 			void *data)
 {
 	struct ip_conntrack_tuple_hash *h;
+	unsigned int bucket =3D 0;
=20
-	/* This is order n^2, by the way. */
-	while ((h =3D get_next_corpse(kill, data)) !=3D NULL) {
+	while ((h =3D get_next_corpse(kill, data, &bucket)) !=3D NULL) {
 		/* Time to push up daises... */
 		if (del_timer(&h->ctrack->timeout))
 			death_by_timeout((unsigned long)h->ctrack);
diff -Nru --exclude .depend --exclude '*.o' --exclude '*.ko' --exclude '*.v=
er' --exclude '.*.flags' --exclude '*.orig' --exclude '*.rej' --exclude '*.=
cmd' --exclude '*.mod.c' --exclude '*~' linux-2.6.3-plain//net/ipv4/netfilt=
er/ip_conntrack_standalone.c linux-2.6.3-nfsubmit/net/ipv4/netfilter/ip_con=
ntrack_standalone.c
--- linux-2.6.3-plain//net/ipv4/netfilter/ip_conntrack_standalone.c	2004-02=
-18 04:57:46.000000000 +0100
+++ linux-2.6.3-nfsubmit/net/ipv4/netfilter/ip_conntrack_standalone.c	2004-=
02-20 20:55:14.000000000 +0100
@@ -275,6 +275,7 @@
=20
 /* From ip_conntrack_core.c */
 extern int ip_conntrack_max;
+extern unsigned int ip_conntrack_htable_size;
=20
 /* From ip_conntrack_proto_tcp.c */
 extern unsigned long ip_ct_tcp_timeout_syn_sent;
@@ -302,6 +303,9 @@
 	{NET_IPV4_NF_CONNTRACK_MAX, "ip_conntrack_max",
 	 &ip_conntrack_max, sizeof(int), 0644, NULL,
 	 &proc_dointvec},
+	{NET_IPV4_NF_CONNTRACK_BUCKETS, "ip_conntrack_buckets",
+	 &ip_conntrack_htable_size, sizeof(unsigned int), 0444, NULL,
+	 &proc_dointvec},
 	{NET_IPV4_NF_CONNTRACK_TCP_TIMEOUT_SYN_SENT, "ip_conntrack_tcp_timeout_sy=
n_sent",
 	 &ip_ct_tcp_timeout_syn_sent, sizeof(unsigned int), 0644, NULL,
 	 &proc_dointvec_jiffies},

--cW0eHRJ76X8TDo3d--

--dnd11iroZwpv/0M5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFANmYMXaXGVTD0i/8RAkkxAJ4z2PIbSHX9U/wNz6ZbyP983k6iaQCgnzgQ
GeoMKoqfB0XpD60NVfJj2mM=
=wIsp
-----END PGP SIGNATURE-----

--dnd11iroZwpv/0M5--
