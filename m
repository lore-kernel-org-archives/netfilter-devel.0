From: Harald Welte <laforge@netfilter.org>
Subject: [PATCH 2.6] NETFILTER (10/x): init_conntrack() optimization
Date: Sat, 24 Jul 2004 11:01:18 -0400
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040724150117.GS2848@obroa-skai.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="65fUfJaAyj3QT6Mb"
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


--65fUfJaAyj3QT6Mb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave!

This patch optimizes the code path during init_conntrack()

Signed-off-by: Pablo Neira <pablo@eurodev.net>
Signed-off-by: Harald Welte <laforge@netfilter.org>

diff -Nru --exclude .depend --exclude '*.o' --exclude '*.ko' --exclude '*.v=
er' --exclude '.*.flags' --exclude '*.orig' --exclude '*.rej' --exclude '*.=
cmd' --exclude '*.mod.c' --exclude '*~' linux-2.6.3-old/net/ipv4/netfilter/=
ip_conntrack_core.c old-compiled/linux-2.6.3/net/ipv4/netfilter/ip_conntrac=
k_core.c
--- linux-2.6.3-old/net/ipv4/netfilter/ip_conntrack_core.c	2004-02-22 13:29=
:30.000000000 +0100
+++ linux-2.6.3/net/ipv4/netfilter/ip_conntrack_core.c	2004-02-25 13:02:35.=
000000000 +0100
@@ -691,41 +691,48 @@
 			     struct ip_conntrack_expect *, tuple);
 	READ_UNLOCK(&ip_conntrack_expect_tuple_lock);
=20
-	/* If master is not in hash table yet (ie. packet hasn't left
-	   this machine yet), how can other end know about expected?
-	   Hence these are not the droids you are looking for (if
-	   master ct never got confirmed, we'd hold a reference to it
-	   and weird things would happen to future packets). */
-	if (expected && !is_confirmed(expected->expectant))
-		expected =3D NULL;
-
-	/* Look up the conntrack helper for master connections only */
-	if (!expected)
-		conntrack->helper =3D ip_ct_find_helper(&repl_tuple);
-
-	/* If the expectation is dying, then this is a loser. */
-	if (expected
-	    && expected->expectant->helper->timeout
-	    && ! del_timer(&expected->timeout))
-		expected =3D NULL;
-
 	if (expected) {
-		DEBUGP("conntrack: expectation arrives ct=3D%p exp=3D%p\n",
-			conntrack, expected);
-		/* Welcome, Mr. Bond.  We've been expecting you... */
-		__set_bit(IPS_EXPECTED_BIT, &conntrack->status);
-		conntrack->master =3D expected;
-		expected->sibling =3D conntrack;
-		LIST_DELETE(&ip_conntrack_expect_list, expected);
-		expected->expectant->expecting--;
-		nf_conntrack_get(&master_ct(conntrack)->infos[0]);
-	}
-	atomic_inc(&ip_conntrack_count);
+		/* If master is not in hash table yet (ie. packet hasn't left
+		   this machine yet), how can other end know about expected?
+		   Hence these are not the droids you are looking for (if
+		   master ct never got confirmed, we'd hold a reference to it
+		   and weird things would happen to future packets). */
+		if (!is_confirmed(expected->expectant)) {
+			conntrack->helper =3D ip_ct_find_helper(&repl_tuple);
+			goto end;
+		}
+
+		/* Expectation is dying... */
+		if (expected->expectant->helper->timeout
+		    && !del_timer(&expected->timeout))
+			goto end;=09
+
+		DEBUGP("conntrack: expectation arrives ct=3D%p exp=3D%p\n",
+			conntrack, expected);
+		/* Welcome, Mr. Bond.  We've been expecting you... */
+		IP_NF_ASSERT(master_ct(conntrack));
+		__set_bit(IPS_EXPECTED_BIT, &conntrack->status);
+		conntrack->master =3D expected;
+		expected->sibling =3D conntrack;
+		LIST_DELETE(&ip_conntrack_expect_list, expected);
+		expected->expectant->expecting--;
+		nf_conntrack_get(&master_ct(conntrack)->infos[0]);
+
+		/* this is a braindead... --pablo */
+		atomic_inc(&ip_conntrack_count);
+		WRITE_UNLOCK(&ip_conntrack_lock);
+
+		if (expected->expectfn)
+			expected->expectfn(conntrack);
+
+		goto ret;
+	} else=20
+		conntrack->helper =3D ip_ct_find_helper(&repl_tuple);
+
+end:	atomic_inc(&ip_conntrack_count);
 	WRITE_UNLOCK(&ip_conntrack_lock);
=20
-	if (expected && expected->expectfn)
-		expected->expectfn(conntrack);
-	return &conntrack->tuplehash[IP_CT_DIR_ORIGINAL];
+ret:	return &conntrack->tuplehash[IP_CT_DIR_ORIGINAL];
 }
=20
 /* On success, returns conntrack ptr, sets skb->nfct and ctinfo */
--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--65fUfJaAyj3QT6Mb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFBAnm9XaXGVTD0i/8RAq4/AJsG6eT2tiqSXLo66CG2ln3k/4+F3QCaAwbL
rh7ipjPbmvzc8tSPprMvlQE=
=Tmgj
-----END PGP SIGNATURE-----

--65fUfJaAyj3QT6Mb--
