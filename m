From: Harald Welte <laforge@netfilter.org>
Subject: [PATCH 2.4 9/10]: Remove broken check for cleared IP_DF flag on fragments in ipt_unclean
Date: Mon, 21 Jun 2004 21:54:51 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040621195450.GB24374@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cRly6ju5PXq2bKeG"
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


--cRly6ju5PXq2bKeG
Content-Type: multipart/mixed; boundary="c0HPpa7OPKmLGbgH"
Content-Disposition: inline


--c0HPpa7OPKmLGbgH
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline

This patch for 2.4 removes a broken check for cleared IP_DF flag on
fragments from ipt_owner. Linux NFS itself sends fragments with
IP_DF|IP_MF.

Author: Patrick McHardy <kaber@trash.net>

--
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
============================================================================
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--c0HPpa7OPKmLGbgH
Content-Type: text/plain; charset=us-ascii; name="09.diff"
Content-Disposition: inline; filename="09.diff"
Content-Transfer-Encoding: quoted-printable

# This is a BitKeeper generated diff -Nru style patch.
#
# ChangeSet
#   2004/06/20 22:50:06+02:00 kaber@trash.net=20
#   [NETFILTER]: Remove broken check for cleared IP_DF flag on fragments in=
 ipt_unclean
#=20
# net/ipv4/netfilter/ipt_unclean.c
#   2004/06/20 22:50:03+02:00 kaber@trash.net +0 -8
#   [NETFILTER]: Remove broken check for cleared IP_DF flag on fragments in=
 ipt_unclean
#=20
diff -Nru a/net/ipv4/netfilter/ipt_unclean.c b/net/ipv4/netfilter/ipt_uncle=
an.c
--- a/net/ipv4/netfilter/ipt_unclean.c	2004-06-20 23:03:01 +02:00
+++ b/net/ipv4/netfilter/ipt_unclean.c	2004-06-20 23:03:01 +02:00
@@ -478,14 +478,6 @@
 		return 0;
 	}
=20
-	/* CHECK: DF set and offset or MF set. */
-	if ((ntohs(iph->frag_off) & IP_DF)
-	    && (offset || (ntohs(iph->frag_off) & IP_MF))) {
-		limpk("DF set and offset=3D%u, MF=3D%u.\n",
-		      offset, ntohs(iph->frag_off) & IP_MF);
-		return 0;
-	}
-
 	/* CHECK: Zero-sized fragments. */
 	if ((offset || (ntohs(iph->frag_off) & IP_MF))
 	    && datalen =3D=3D 0) {


--c0HPpa7OPKmLGbgH--

--cRly6ju5PXq2bKeG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFA1z0KXaXGVTD0i/8RAoP6AJ4l0NNHka/BeLJsY54aemvmgpwYPwCfTijd
oj2rmJiJ20yyNcwHNHjKAaI=
=V5XK
-----END PGP SIGNATURE-----

--cRly6ju5PXq2bKeG--
