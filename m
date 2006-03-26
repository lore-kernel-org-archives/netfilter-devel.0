From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: [PATCH] fix ifdef for connmark support in nf_conntrack_netlink
Date: Sun, 26 Mar 2006 11:33:09 +0200
Message-ID: <1143365589.4015.8.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-ejhpWHDIl7XuO+KxZXqU"
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


--=-ejhpWHDIl7XuO+KxZXqU
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

When ctnetlink was ported from ip_conntrack to nf_conntrack two #ifdef's
for connmark support were left unchanged and this code was never
compiled.
Problem noticed by Daniel De Graaf.

Signed-off-by: Martin Josefsson <gandalf@wlug.westbo.se>


--- linux-2.6.16.orig/net/netfilter/nf_conntrack_netlink.c	2006-03-20 06:53=
:29.000000000 +0100
+++ linux-2.6.16/net/netfilter/nf_conntrack_netlink.c	2006-03-26 10:20:11.0=
00000000 +0200
@@ -1005,7 +1005,7 @@ ctnetlink_change_conntrack(struct nf_con
 			return err;
 	}
=20
-#if defined(CONFIG_IP_NF_CONNTRACK_MARK)
+#if defined(CONFIG_NF_CONNTRACK_MARK)
 	if (cda[CTA_MARK-1])
 		ct->mark =3D ntohl(*(u_int32_t *)NFA_DATA(cda[CTA_MARK-1]));
 #endif
@@ -1045,7 +1045,7 @@ ctnetlink_create_conntrack(struct nfattr
 			return err;
 	}
=20
-#if defined(CONFIG_IP_NF_CONNTRACK_MARK)
+#if defined(CONFIG_NF_CONNTRACK_MARK)
 	if (cda[CTA_MARK-1])
 		ct->mark =3D ntohl(*(u_int32_t *)NFA_DATA(cda[CTA_MARK-1]));
 #endif

--=20
/Martin

--=-ejhpWHDIl7XuO+KxZXqU
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQBEJl/VWm2vlfa207ERAvVkAKCLZRJlX9PB217EGLRYRpbdyw3tvACfb1Vb
qCKtG7/YzyTqAkVjIQmwk3I=
=it0a
-----END PGP SIGNATURE-----

--=-ejhpWHDIl7XuO+KxZXqU--
