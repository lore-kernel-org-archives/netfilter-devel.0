From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH] fix correct_cache() in libiptc.c
Date: Sat, 5 Jul 2003 19:38:39 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030705173839.GH7073@sunbeam.de.gnumonks.org>
References: <1057411145.12437.128.camel@tux.rsn.bth.se>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IxlmieUzCzCqf3CN"
Cc: Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Martin Josefsson <gandalf@wlug.westbo.se>
Content-Disposition: inline
In-Reply-To: <1057411145.12437.128.camel@tux.rsn.bth.se>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--IxlmieUzCzCqf3CN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

What about this one?  I think it is a clener fix...=20


Index: libiptc.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
RCS file: /cvsroot/netfilter/userspace/libiptc/libiptc.c,v
retrieving revision 1.40
diff -u -r1.40 libiptc.c
--- libiptc.c	24 Jun 2003 17:37:21 -0000	1.40
+++ libiptc.c	5 Jul 2003 17:46:09 -0000
@@ -479,8 +479,12 @@
 				unsigned int size;
=20
 				h->cache_num_chains--;
-				if (i+1 >=3D h->cache_num_chains)
+
+				/* no need for memmove since we are=20
+				 * removing the last entry */
+				if (i >=3D h->cache_num_chains)
 					continue;
+
 				start =3D &h->cache_chain_heads[i+1];
 				size =3D (h->cache_num_chains-i)
 					* sizeof(struct chain_cache);
@@ -943,7 +947,7 @@
 	(*handle)->entries.size -=3D rules_size;
=20
 	/* Fix the chain cache */
-	if (!correct_cache(*handle, offset, -(int)rules_size))
+	if (!correct_cache(*handle, offset+rules_size, -(int)rules_size))
 		return 0;
=20
 	return set_verdict(offset, -(int)rules_size, handle);
--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--IxlmieUzCzCqf3CN
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQE/Bw0fXaXGVTD0i/8RArHWAKCoIJJsYZ5ok3wqWmg84Hmu44AOgACfWEuJ
7aC3AZGSQ8wAe9ThI86e/Z4=
=pApx
-----END PGP SIGNATURE-----

--IxlmieUzCzCqf3CN--
