From: Harald Welte <laforge@netfilter.org>
Subject: [PATCH 2.6] netfilter NAT optimization
Date: Sun, 24 Aug 2003 10:56:00 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030824085600.GP6750@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Sf3MmCJcUNNLokcm"
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


--Sf3MmCJcUNNLokcm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave!

The following patch against 2.6.0-test4 (courtesy of Patrick McHardy)
optimizes the NAT code.  In the old implementation, the hash function
was passed to the LIST_DELETE macro, which resulted in it being called
two times instead of one.

This patch also applies to 2.4.x - but I think we should wait for
2.4.23-preX to come up first.  Do you want me to re-submit it for
2.4.23-preX, once it shows up?

Pleaes apply,

diff -Nru a/net/ipv4/netfilter/ip_nat_core.c b/net/ipv4/netfilter/ip_nat_co=
re.c
--- a/net/ipv4/netfilter/ip_nat_core.c	Sat Jul 12 04:57:07 2003
+++ b/net/ipv4/netfilter/ip_nat_core.c	Sat Jul 12 04:57:07 2003
@@ -67,6 +67,7 @@
 static void ip_nat_cleanup_conntrack(struct ip_conntrack *conn)
 {
 	struct ip_nat_info *info =3D &conn->nat.info;
+	unsigned int hs, hp;
=20
 	if (!info->initialized)
 		return;
@@ -74,21 +75,18 @@
 	IP_NF_ASSERT(info->bysource.conntrack);
 	IP_NF_ASSERT(info->byipsproto.conntrack);
=20
+	hs =3D hash_by_src(&conn->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src,
+	                 conn->tuplehash[IP_CT_DIR_ORIGINAL]
+	                 .tuple.dst.protonum);
+
+	hp =3D hash_by_ipsproto(conn->tuplehash[IP_CT_DIR_REPLY].tuple.src.ip,
+	                      conn->tuplehash[IP_CT_DIR_REPLY].tuple.dst.ip,
+	                      conn->tuplehash[IP_CT_DIR_REPLY]
+	                      .tuple.dst.protonum);
+
 	WRITE_LOCK(&ip_nat_lock);
-	LIST_DELETE(&bysource[hash_by_src(&conn->tuplehash[IP_CT_DIR_ORIGINAL]
-					  .tuple.src,
-					  conn->tuplehash[IP_CT_DIR_ORIGINAL]
-					  .tuple.dst.protonum)],
-		    &info->bysource);
-
-	LIST_DELETE(&byipsproto
-		    [hash_by_ipsproto(conn->tuplehash[IP_CT_DIR_REPLY]
-				      .tuple.src.ip,
-				      conn->tuplehash[IP_CT_DIR_REPLY]
-				      .tuple.dst.ip,
-				      conn->tuplehash[IP_CT_DIR_REPLY]
-				      .tuple.dst.protonum)],
-		    &info->byipsproto);
+	LIST_DELETE(&bysource[hs], &info->bysource);
+	LIST_DELETE(&byipsproto[hp], &info->byipsproto);
 	WRITE_UNLOCK(&ip_nat_lock);
 }
=20
@@ -244,11 +242,12 @@
 	   const struct ip_conntrack *conntrack)
 {
 	unsigned int score =3D 0;
+	unsigned int h;
=20
 	MUST_BE_READ_LOCKED(&ip_nat_lock);
-	LIST_FIND(&byipsproto[hash_by_ipsproto(src, dst, protonum)],
-		  fake_cmp, struct ip_nat_hash *, src, dst, protonum, &score,
-		  conntrack);
+	h =3D hash_by_ipsproto(src, dst, protonum);
+	LIST_FIND(&byipsproto[h], fake_cmp, struct ip_nat_hash *,
+	          src, dst, protonum, &score, conntrack);
=20
 	return score;
 }

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--Sf3MmCJcUNNLokcm
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.2 (GNU/Linux)

iD8DBQE/SH2gXaXGVTD0i/8RAgfrAJwKzGwkuVXwSqa+QlQEdabtkUGjCQCdFzOT
L5rNpl819Vug0upcgrPMJVA=
=NsHH
-----END PGP SIGNATURE-----

--Sf3MmCJcUNNLokcm--
