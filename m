From: Harald Welte <laforge@netfilter.org>
Subject: [PATCH] netfilter fix (7/7): don't call helpers expectfn() for unconfirmed connections
Date: Tue, 24 Jun 2003 16:07:01 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030624140701.GG2645@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3607uds81ZQvwCD0"
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


--3607uds81ZQvwCD0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave!

Here goes the seventh and last fix.


Author: Patrick McHardy <kaber@trash.net>

Do not delete timer / call expect function for connections matching
expectations from unconfirmed connections.

diff -Nru a/net/ipv4/netfilter/ip_conntrack_core.c b/net/ipv4/netfilter/ip_=
conntrack_core.c
--- a/net/ipv4/netfilter/ip_conntrack_core.c	Sun Jun 15 20:24:32 2003
+++ b/net/ipv4/netfilter/ip_conntrack_core.c	Sun Jun 15 20:24:32 2003
@@ -705,6 +705,14 @@
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
@@ -715,12 +723,7 @@
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

--3607uds81ZQvwCD0
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQE++FsFXaXGVTD0i/8RAj+TAKCkxRziHLDa03aumk9LKeVwqlr7owCfZHF7
EhmKZL4HQoP7t4PrSsn/PGU=
=nCR2
-----END PGP SIGNATURE-----

--3607uds81ZQvwCD0--
