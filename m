From: Harald Welte <laforge@netfilter.org>
Subject: [PATCH] netfilter fix (5/7): conntrack 64bit bigendian fixes
Date: Tue, 24 Jun 2003 16:04:36 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030624140436.GE2645@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zaRBsRFn0XYhEU69"
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


--zaRBsRFn0XYhEU69
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave!

Here goes the fifth...


Author: Jakub Bogusz <qboosh@pld.org.pl>

This patch fixes bugs related to machine endianess (harmless on
little-endians, but causing that some of conntrack modules don't
work on big-endian machines).


diff -Nru --exclude .depend --exclude '*.o' --exclude '*.ver' --exclude '.*=
=2Eflags' --exclude '*.orig' --exclude '*.rej' --exclude '*~' linux-2.4.21-=
ip6t_alignment/net/ipv4/netfilter/ip_conntrack_core.c linux-2.4.21-ct_bigen=
dian/net/ipv4/netfilter/ip_conntrack_core.c
--- linux-2.4.21-ip6t_alignment/net/ipv4/netfilter/ip_conntrack_core.c	2003=
-06-24 15:50:53.000000000 +0200
+++ linux-2.4.21-ct_bigendian/net/ipv4/netfilter/ip_conntrack_core.c	2003-0=
6-24 15:56:23.000000000 +0200
@@ -174,8 +174,8 @@
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
@@ -1309,8 +1309,8 @@
 getorigdst(struct sock *sk, int optval, void *user, int *len)
 {
 	struct ip_conntrack_tuple_hash *h;
-	struct ip_conntrack_tuple tuple =3D { { sk->rcv_saddr, { sk->sport } },
-					    { sk->daddr, { sk->dport },
+	struct ip_conntrack_tuple tuple =3D { { sk->rcv_saddr, { .tcp =3D { sk->s=
port } } },
+					    { sk->daddr, { .tcp =3D { sk->dport } },
 					      IPPROTO_TCP } };
=20
 	/* We only do TCP at the moment: is there a better way? */
diff -Nru --exclude .depend --exclude '*.o' --exclude '*.ver' --exclude '.*=
=2Eflags' --exclude '*.orig' --exclude '*.rej' --exclude '*~' linux-2.4.21-=
ip6t_alignment/net/ipv4/netfilter/ip_conntrack_ftp.c linux-2.4.21-ct_bigend=
ian/net/ipv4/netfilter/ip_conntrack_ftp.c
--- linux-2.4.21-ip6t_alignment/net/ipv4/netfilter/ip_conntrack_ftp.c	2003-=
06-13 16:51:39.000000000 +0200
+++ linux-2.4.21-ct_bigendian/net/ipv4/netfilter/ip_conntrack_ftp.c	2003-06=
-24 15:56:23.000000000 +0200
@@ -366,11 +366,11 @@
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
diff -Nru --exclude .depend --exclude '*.o' --exclude '*.ver' --exclude '.*=
=2Eflags' --exclude '*.orig' --exclude '*.rej' --exclude '*~' linux-2.4.21-=
ip6t_alignment/net/ipv4/netfilter/ip_conntrack_irc.c linux-2.4.21-ct_bigend=
ian/net/ipv4/netfilter/ip_conntrack_irc.c
--- linux-2.4.21-ip6t_alignment/net/ipv4/netfilter/ip_conntrack_irc.c	2003-=
06-13 16:51:39.000000000 +0200
+++ linux-2.4.21-ct_bigendian/net/ipv4/netfilter/ip_conntrack_irc.c	2003-06=
-24 15:56:23.000000000 +0200
@@ -209,11 +209,11 @@
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

--zaRBsRFn0XYhEU69
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQE++FpzXaXGVTD0i/8RAt5tAKCl6OHJQ7xWG2/cl5iYrfHLmhgdgwCfbnUx
vQgqZUY7V8yppl+DUUw/Ask=
=AVoO
-----END PGP SIGNATURE-----

--zaRBsRFn0XYhEU69--
