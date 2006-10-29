From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: [PATCH] Add missing unlock in get_next_corpse()
Date: Sun, 29 Oct 2006 13:27:19 +0100
Message-ID: <1162124840.29771.2.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-55WRBsHujPxdKYUW9b9n"
Cc: netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


--=-55WRBsHujPxdKYUW9b9n
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Add missing unlock in get_next_corpse() in nf_conntrack. It was missed duri=
ng
the removal of listhelp.h . Also remove an unneeded use of
nf_ct_tuplehash_to_ctrack() in the same function.

Should be applied before 2.6.19 is released.

Signed-off-by: Martin Josefsson <gandalf@wlug.westbo.se>

---
 net/netfilter/nf_conntrack_core.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: linux-2.6.19-rc3-git4.quilt/net/netfilter/nf_conntrack_core.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux-2.6.19-rc3-git4.quilt.orig/net/netfilter/nf_conntrack_core.c	2006=
-10-29 11:47:09.000000000 +0100
+++ linux-2.6.19-rc3-git4.quilt/net/netfilter/nf_conntrack_core.c	2006-10-2=
9 11:47:41.000000000 +0100
@@ -1520,9 +1520,10 @@ get_next_corpse(int (*iter)(struct nf_co
 		if (iter(ct, data))
 			goto found;
 	}
+	write_unlock_bh(&nf_conntrack_lock);
 	return NULL;
 found:
-	atomic_inc(&nf_ct_tuplehash_to_ctrack(h)->ct_general.use);
+	atomic_inc(&ct->ct_general.use);
 	write_unlock_bh(&nf_conntrack_lock);
 	return ct;
 }

--=20
/Martin

--=-55WRBsHujPxdKYUW9b9n
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBFRJ4nWm2vlfa207ERAoRrAJ97FbzF1YYycbhSLA+j9aA/++jWSwCfWmNc
2JQcEd/cp8JojFc5mn6hjrY=
=uuFT
-----END PGP SIGNATURE-----

--=-55WRBsHujPxdKYUW9b9n--
