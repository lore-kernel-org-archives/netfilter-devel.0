From: Harald Welte <laforge@netfilter.org>
Subject: [PATCH 2.6] netfilter conntrack optimization (LIST_DELETE)
Date: Sun, 24 Aug 2003 10:57:42 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030824085742.GQ6750@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6zn93sY2JrH9m7VZ"
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


--6zn93sY2JrH9m7VZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave!

The following patch against 2.6.0-test4 (courtesy of Patrick McHardy)
optimizes the conntrack code.  In the old implementation, the hash function
was passed to the LIST_DELETE macro, which resulted in it being called
two times instead of one.

This patch also applies to 2.4.x - but I think we should wait for
2.4.23-preX to come up first.  Do you want me to re-submit it for
2.4.23-preX, once it shows up?

Please apply, thanks!


=3D=3D=3D=3D=3D net/ipv4/netfilter/ip_conntrack_core.c 1.25 vs edited =3D=
=3D=3D=3D=3D
--- 1.25/net/ipv4/netfilter/ip_conntrack_core.c	Fri Jul 25 23:14:23 2003
+++ edited/net/ipv4/netfilter/ip_conntrack_core.c	Mon Aug 18 16:31:22 2003
@@ -291,14 +291,15 @@
 static void
 clean_from_lists(struct ip_conntrack *ct)
 {
+	unsigned int ho, hr;
+=09
 	DEBUGP("clean_from_lists(%p)\n", ct);
 	MUST_BE_WRITE_LOCKED(&ip_conntrack_lock);
-	LIST_DELETE(&ip_conntrack_hash
-		    [hash_conntrack(&ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple)],
-		    &ct->tuplehash[IP_CT_DIR_ORIGINAL]);
-	LIST_DELETE(&ip_conntrack_hash
-		    [hash_conntrack(&ct->tuplehash[IP_CT_DIR_REPLY].tuple)],
-		    &ct->tuplehash[IP_CT_DIR_REPLY]);
+
+	ho =3D hash_conntrack(&ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple);
+	hr =3D hash_conntrack(&ct->tuplehash[IP_CT_DIR_REPLY].tuple);
+	LIST_DELETE(&ip_conntrack_hash[ho], &ct->tuplehash[IP_CT_DIR_ORIGINAL]);
+	LIST_DELETE(&ip_conntrack_hash[hr], &ct->tuplehash[IP_CT_DIR_REPLY]);
=20
 	/* Destroy all un-established, pending expectations */
 	remove_expectations(ct, 1);
@@ -370,9 +371,10 @@
 		    const struct ip_conntrack *ignored_conntrack)
 {
 	struct ip_conntrack_tuple_hash *h;
+	unsigned int hash =3D hash_conntrack(tuple);
=20
 	MUST_BE_READ_LOCKED(&ip_conntrack_lock);
-	h =3D LIST_FIND(&ip_conntrack_hash[hash_conntrack(tuple)],
+	h =3D LIST_FIND(&ip_conntrack_hash[hash],
 		      conntrack_tuple_cmp,
 		      struct ip_conntrack_tuple_hash *,
 		      tuple, ignored_conntrack);
--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--6zn93sY2JrH9m7VZ
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.2 (GNU/Linux)

iD8DBQE/SH4GXaXGVTD0i/8RAlSAAJ9Xzo7mMYVfmkl7Z4OAC7oxHaLxzgCeJHBJ
PhWnJV4DxhIweQe4AGb5aDY=
=dFAY
-----END PGP SIGNATURE-----

--6zn93sY2JrH9m7VZ--
