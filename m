From: Harald Welte <laforge@netfilter.org>
Subject: [PATCH 2.6 5/14]: Fix inverted matching in ipt_helper
Date: Mon, 21 Jun 2004 21:40:48 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040621194048.GJ24374@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="171LwGa4zcdgM9o6"
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


--171LwGa4zcdgM9o6
Content-Type: multipart/mixed; boundary="/sFzBD2UPiMqxCFT"
Content-Disposition: inline


--/sFzBD2UPiMqxCFT
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline

This patch for 2.6 fixes inverted matching in ipt_helper.

Author: Patrick McHardy <kaber@trash.net>

Signed-off-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: Harald Welte <laforge@netfilter.org>

--
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
============================================================================
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--/sFzBD2UPiMqxCFT
Content-Type: text/plain; charset=us-ascii; name="05.diff"
Content-Disposition: inline; filename="05.diff"
Content-Transfer-Encoding: quoted-printable

# This is a BitKeeper generated diff -Nru style patch.
#
# ChangeSet
#   2004/06/20 22:36:48+02:00 kaber@trash.net=20
#   [NETFILTER]: Fix inverted matching in ipt_helper
#=20
# net/ipv4/netfilter/ipt_helper.c
#   2004/06/20 22:36:38+02:00 kaber@trash.net +5 -6
#   [NETFILTER]: Fix inverted matching in ipt_helper
#=20
diff -Nru a/net/ipv4/netfilter/ipt_helper.c b/net/ipv4/netfilter/ipt_helper=
=2Ec
--- a/net/ipv4/netfilter/ipt_helper.c	2004-06-20 23:00:01 +02:00
+++ b/net/ipv4/netfilter/ipt_helper.c	2004-06-20 23:00:01 +02:00
@@ -41,17 +41,17 @@
 	struct ip_conntrack_expect *exp;
 	struct ip_conntrack *ct;
 	enum ip_conntrack_info ctinfo;
-	int ret =3D 0;
+	int ret =3D info->invert;
 =09
 	ct =3D ip_conntrack_get((struct sk_buff *)skb, &ctinfo);
 	if (!ct) {
 		DEBUGP("ipt_helper: Eek! invalid conntrack?\n");
-		return 0;
+		return ret;
 	}
=20
 	if (!ct->master) {
 		DEBUGP("ipt_helper: conntrack %p has no master\n", ct);
-		return 0;
+		return ret;
 	}
=20
 	exp =3D ct->master;
@@ -71,8 +71,8 @@
 	DEBUGP("master's name =3D %s , info->name =3D %s\n",=20
 		exp->expectant->helper->name, info->name);
=20
-	ret =3D !strncmp(exp->expectant->helper->name, info->name,=20
-	               strlen(exp->expectant->helper->name)) ^ info->invert;
+	ret ^=3D !strncmp(exp->expectant->helper->name, info->name,=20
+	                strlen(exp->expectant->helper->name));
 out_unlock:
 	READ_UNLOCK(&ip_conntrack_lock);
 	return ret;
@@ -108,7 +108,6 @@
=20
 static int __init init(void)
 {
-	need_ip_conntrack();
 	return ipt_register_match(&helper_match);
 }
=20


--/sFzBD2UPiMqxCFT--

--171LwGa4zcdgM9o6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFA1znAXaXGVTD0i/8RAqQjAJsE6ZElfwBD3ct1vTLkkCrg7GVW0ACgq68V
1C3OKkF3aBTYjwZeSkW4TLs=
=+m0G
-----END PGP SIGNATURE-----

--171LwGa4zcdgM9o6--
