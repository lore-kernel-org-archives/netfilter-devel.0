From: Harald Welte <laforge@netfilter.org>
Subject: [PATCH 2.6 6/14]: "any" matching in ipt_helper
Date: Mon, 21 Jun 2004 21:41:08 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040621194108.GK24374@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="JjsO4Ft8DCMnlCnY"
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


--JjsO4Ft8DCMnlCnY
Content-Type: multipart/mixed; boundary="2MeieX8lS1K8IJ9W"
Content-Disposition: inline


--2MeieX8lS1K8IJ9W
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline

This patch for 2.6 changes ipt_helper to recognize the empty string as a
wildcard.

Author: Patrick McHardy <kaber@trash.net>

Signed-off-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: Harald Welte <laforge@netfilter.org>

--
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
============================================================================
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--2MeieX8lS1K8IJ9W
Content-Type: text/plain; charset=us-ascii; name="06.diff"
Content-Disposition: inline; filename="06.diff"
Content-Transfer-Encoding: quoted-printable

# This is a BitKeeper generated diff -Nru style patch.
#
# ChangeSet
#   2004/06/20 22:37:32+02:00 kaber@trash.net=20
#   [NETFILTER]: "any" matching in ipt_helper
#=20
# net/ipv4/netfilter/ipt_helper.c
#   2004/06/20 22:37:23+02:00 kaber@trash.net +5 -6
#   [NETFILTER]: "any" matching in ipt_helper
#=20
diff -Nru a/net/ipv4/netfilter/ipt_helper.c b/net/ipv4/netfilter/ipt_helper=
=2Ec
--- a/net/ipv4/netfilter/ipt_helper.c	2004-06-20 23:00:11 +02:00
+++ b/net/ipv4/netfilter/ipt_helper.c	2004-06-20 23:00:11 +02:00
@@ -71,8 +71,11 @@
 	DEBUGP("master's name =3D %s , info->name =3D %s\n",=20
 		exp->expectant->helper->name, info->name);
=20
-	ret ^=3D !strncmp(exp->expectant->helper->name, info->name,=20
-	                strlen(exp->expectant->helper->name));
+	if (info->name[0] =3D=3D '\0')
+		ret ^=3D 1;
+	else
+		ret ^=3D !strncmp(exp->expectant->helper->name, info->name,=20
+		                strlen(exp->expectant->helper->name));
 out_unlock:
 	READ_UNLOCK(&ip_conntrack_lock);
 	return ret;
@@ -92,10 +95,6 @@
 	if (matchsize !=3D IPT_ALIGN(sizeof(struct ipt_helper_info)))
 		return 0;
=20
-	/* verify that we actually should match anything */
-	if ( strlen(info->name) =3D=3D 0 )
-		return 0;
-=09
 	return 1;
 }
=20


--2MeieX8lS1K8IJ9W--

--JjsO4Ft8DCMnlCnY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFA1znUXaXGVTD0i/8RAhO2AJ44ldqCe6oHncBAyW+3yQEhgARLQACeP9fn
jLkzlPNYwJtWbiwd9BndmoY=
=cSiC
-----END PGP SIGNATURE-----

--JjsO4Ft8DCMnlCnY--
