From: Harald Welte <laforge@netfilter.org>
Subject: [PATCH 2.4] NETFILTER: fix broken debug assertion
Date: Mon, 2 Aug 2004 01:18:32 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040801231832.GH18758@sunbeam2>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/9ZOS6odDaRI+0hI"
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


--/9ZOS6odDaRI+0hI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave!

This patch fixes the broken netfilter assertions in 2.4.x.

Please apply, thanks.

# This is a BitKeeper generated diff -Nru style patch.
#
# ChangeSet
#   2004/06/23 00:25:21+02:00 kaber@trash.net=20
#   [NETFILTER]: Fix two more broken assertions
#  =20
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
#   Signed-off-by: Harald Welte <laforge@netfilter.org>
#=20
# net/ipv4/netfilter/ipt_MASQUERADE.c
#   2004/06/23 00:25:18+02:00 kaber@trash.net +2 -2
#   [NETFILTER]: Fix two more broken assertions
#=20
# net/ipv4/netfilter/ip_nat_rule.c
#   2004/06/23 00:25:18+02:00 kaber@trash.net +2 -1
#   [NETFILTER]: Fix two more broken assertions
#=20
diff -Nru a/net/ipv4/netfilter/ip_nat_rule.c b/net/ipv4/netfilter/ip_nat_ru=
le.c
--- a/net/ipv4/netfilter/ip_nat_rule.c	2004-06-23 00:26:25 +02:00
+++ b/net/ipv4/netfilter/ip_nat_rule.c	2004-06-23 00:26:25 +02:00
@@ -121,7 +121,8 @@
 	ct =3D ip_conntrack_get(*pskb, &ctinfo);
=20
 	/* Connection must be valid and new. */
-	IP_NF_ASSERT(ct && (ctinfo =3D=3D IP_CT_NEW || ctinfo =3D=3D IP_CT_RELATE=
D));
+	IP_NF_ASSERT(ct && (ctinfo =3D=3D IP_CT_NEW || ctinfo =3D=3D IP_CT_RELATED
+	                    || ctinfo =3D=3D IP_CT_RELATED + IP_CT_IS_REPLY));
 	IP_NF_ASSERT(out);
=20
 	return ip_nat_setup_info(ct, targinfo, hooknum);
diff -Nru a/net/ipv4/netfilter/ipt_MASQUERADE.c b/net/ipv4/netfilter/ipt_MA=
SQUERADE.c
--- a/net/ipv4/netfilter/ipt_MASQUERADE.c	2004-06-23 00:26:25 +02:00
+++ b/net/ipv4/netfilter/ipt_MASQUERADE.c	2004-06-23 00:26:25 +02:00
@@ -79,8 +79,8 @@
 		return NF_ACCEPT;
=20
 	ct =3D ip_conntrack_get(*pskb, &ctinfo);
-	IP_NF_ASSERT(ct && (ctinfo =3D=3D IP_CT_NEW
-				  || ctinfo =3D=3D IP_CT_RELATED));
+	IP_NF_ASSERT(ct && (ctinfo =3D=3D IP_CT_NEW || ctinfo =3D=3D IP_CT_RELATED
+	                    || ctinfo =3D=3D IP_CT_RELATED + IP_CT_IS_REPLY));
=20
 	mr =3D targinfo;
=20
--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--/9ZOS6odDaRI+0hI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFBDXpIXaXGVTD0i/8RAt9vAKCC1Lh79kQ7p3XAuz6Kskd2LWba6wCeOBIY
2kixf1NqIGI7uvv9wU9xpx0=
=JmYe
-----END PGP SIGNATURE-----

--/9ZOS6odDaRI+0hI--
