From: Harald Welte <laforge@netfilter.org>
Subject: [PATCH 2.6] fix SO_ORIGINAL_DST gestsockopt()
Date: Thu, 2 Oct 2003 18:39:55 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031002163955.GV5758@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+FEWvIKKURwZl3fO"
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


--+FEWvIKKURwZl3fO
Content-Type: multipart/mixed; boundary="+7V3F3RcKnYq8gpU"
Content-Disposition: inline


--+7V3F3RcKnYq8gpU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Davem!

Please apply the following patch to your 2.6 tree, thanks.


Author: Harald Welte <laforge@netfilter.org>

This patch fixes the SO_ORIGINAL_DST sockopt() call, which was broken by
endianness fixes that went in 2.4.22.

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--+7V3F3RcKnYq8gpU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="27_getorigdst-tuple-zero.patch"
Content-Transfer-Encoding: quoted-printable

--- linux-2.6.0-test4/net/ipv4/netfilter/ip_conntrack_core.c	2003-09-04 23:=
37:06.000000000 +0200
+++ linux-2.6.0-test4-getorigdst/net/ipv4/netfilter/ip_conntrack_core.c	200=
3-09-05 16:57:04.000000000 +0200
@@ -1275,11 +1275,14 @@
 {
 	struct inet_opt *inet =3D inet_sk(sk);
 	struct ip_conntrack_tuple_hash *h;
-	struct ip_conntrack_tuple tuple =3D { { inet->rcv_saddr,
-						{ .tcp =3D { inet->sport } } },
-					    { inet->daddr,
-						{ .tcp =3D { inet->dport } },
-					      IPPROTO_TCP } };
+	struct ip_conntrack_tuple tuple;
+=09
+	IP_CT_TUPLE_U_BLANK(&tuple);
+	tuple.src.ip =3D inet->rcv_saddr;
+	tuple.src.u.tcp.port =3D inet->sport;
+	tuple.dst.ip =3D inet->daddr;
+	tuple.dst.u.tcp.port =3D inet->dport;
+	tuple.dst.protonum =3D IPPROTO_TCP;
=20
 	/* We only do TCP at the moment: is there a better way? */
 	if (strcmp(sk->sk_prot->name, "TCP")) {
--- linux-2.6.0-test4/include/linux/netfilter_ipv4/ip_conntrack_tuple.h.ori=
g	2003-09-05 16:53:45.000000000 +0200
+++ linux-2.6.0-test4-getorigdst/include/linux/netfilter_ipv4/ip_conntrack_=
tuple.h	2003-09-05 16:59:05.000000000 +0200
@@ -62,6 +62,14 @@
 	} dst;
 };
=20
+/* This is optimized opposed to a memset of the whole structure.  Everythi=
ng we
+ * really care about is the  source/destination unions */
+#define IP_CT_TUPLE_U_BLANK(tuple) 				\
+	do {							\
+		(tuple)->src.u.all =3D 0;				\
+		(tuple)->dst.u.all =3D 0;				\
+	} while (0)
+
 enum ip_conntrack_dir
 {
 	IP_CT_DIR_ORIGINAL,

--+7V3F3RcKnYq8gpU--

--+FEWvIKKURwZl3fO
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.2 (GNU/Linux)

iD8DBQE/fFTbXaXGVTD0i/8RAovSAJ9iXI5BTrFUU6fGBaO9XZKt9Kmm7ACfRBiD
LMk1LOjo//XtdgfhAxJ3sQw=
=9dl3
-----END PGP SIGNATURE-----

--+FEWvIKKURwZl3fO--
