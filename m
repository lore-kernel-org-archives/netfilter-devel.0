From: Harald Welte <laforge@netfilter.org>
Subject: [PATCH 2.6] destroy_conntrack optimization
Date: Thu, 2 Oct 2003 16:25:04 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031002142504.GB5758@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VZGTJogoWKdbG5sF"
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


--VZGTJogoWKdbG5sF
Content-Type: multipart/mixed; boundary="QKFUq+IbM9AW97yF"
Content-Disposition: inline


--QKFUq+IbM9AW97yF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Davem!

Please apply the following patch to your 2.6 tree and push it to Marcelo.
Thanks.

Author: Patrick McHardy <kaber@trash.net>

Don't call ip_conntrack_put with ip_conntrack_lock held

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--QKFUq+IbM9AW97yF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="77_destroy-conntrack.patch"
Content-Transfer-Encoding: quoted-printable

# This is a BitKeeper generated patch for the following project:
# Project Name: Linux kernel tree
# This patch format is intended for GNU patch command version 2.5 or higher.
# This patch includes the following deltas:
#	           ChangeSet	1.1357  -> 1.1358=20
#	net/ipv4/netfilter/ip_conntrack_core.c	1.37    -> 1.38  =20
#
# The following is the BitKeeper ChangeSet Log
# --------------------------------------------
# 03/09/27	kaber@trash.net	1.1358
# [NETFILTER]: Don't call ip_conntrack_put with ip_conntrack_lock held
# --------------------------------------------
#
diff -Nru a/net/ipv4/netfilter/ip_conntrack_core.c b/net/ipv4/netfilter/ip_=
conntrack_core.c
--- a/net/ipv4/netfilter/ip_conntrack_core.c	Sat Sep 27 21:09:18 2003
+++ b/net/ipv4/netfilter/ip_conntrack_core.c	Sat Sep 27 21:09:18 2003
@@ -301,7 +301,7 @@
 static void
 destroy_conntrack(struct nf_conntrack *nfct)
 {
-	struct ip_conntrack *ct =3D (struct ip_conntrack *)nfct;
+	struct ip_conntrack *ct =3D (struct ip_conntrack *)nfct, *master =3D NULL;
 	struct ip_conntrack_protocol *proto;
=20
 	DEBUGP("destroy_conntrack(%p)\n", ct);
@@ -328,11 +328,14 @@
 			/* can't call __unexpect_related here,
 			 * since it would screw up expect_list */
 			list_del(&ct->master->expected_list);
-			ip_conntrack_put(ct->master->expectant);
+			master =3D ct->master->expectant;
 		}
 		kfree(ct->master);
 	}
 	WRITE_UNLOCK(&ip_conntrack_lock);
+
+	if (master)
+		ip_conntrack_put(master);
=20
 	DEBUGP("destroy_conntrack: returning ct=3D%p to slab\n", ct);
 	kmem_cache_free(ip_conntrack_cachep, ct);

--QKFUq+IbM9AW97yF--

--VZGTJogoWKdbG5sF
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.2 (GNU/Linux)

iD8DBQE/fDVAXaXGVTD0i/8RAgYNAJ4gTAMfR3RtQ2wcnKFQ3XHnMbC0sACgpuYW
MFzLwdH7ZnnPkD+krbzBZJQ=
=Ad7V
-----END PGP SIGNATURE-----

--VZGTJogoWKdbG5sF--
