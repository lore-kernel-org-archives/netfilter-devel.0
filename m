From: "Piotr =?iso-8859-2?Q?Gasid=B3o?="
	<quaker@pandora.barbara.ds.polsl.gliwice.pl>
Subject: Fix for u32 match, problems when parsing arguments
Date: Thu, 2 Sep 2004 14:28:02 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <20040902122802.GA6427@barbara.eu.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=_pandora.barbara.ds.polsl.gliwice.pl-23316-1094128082-0001-2"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_pandora.barbara.ds.polsl.gliwice.pl-23316-1094128082-0001-2
Content-Type: multipart/mixed; boundary="r5Pyd7+fXNt84Ff3"
Content-Disposition: inline


--r5Pyd7+fXNt84Ff3
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello,

I've found bug in u32 iptables helper library.

# iptables -A FORWARD -m u32 --u32 "0&0xffffffff=3D0"
iptables v1.2.11: u32: at char 2 error reading number

Attached patch, fixes problem.

--=20
Piotr 'QuakeR' Gasid=B3o, BOFH @ pandora.barbara.eu.org
############## sending lusers to /dev/null since 1998
##### Waiting for tomorrow, for a little ray of light
### Waiting for tomorrow just to see your smile again

--r5Pyd7+fXNt84Ff3
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: attachment; filename="libipt_u32_fix.diff"
Content-Transfer-Encoding: quoted-printable

diff -uNr iptables.orig/extensions/libipt_u32.c iptables/extensions/libipt_=
u32.c
--- iptables.orig/extensions/libipt_u32.c	Thu Sep  2 14:13:50 2004
+++ iptables/extensions/libipt_u32.c	Thu Sep  2 13:20:23 2004
@@ -85,7 +85,7 @@
 	char *end;
 	errno =3D 0;
=20
-	number =3D strtol(*s, &end, 0);
+	number =3D strtoul(*s, &end, 0);
 	if (end =3D=3D *s)
 		exit_error(PARAMETER_PROBLEM,=20
 			   "u32: at char %d expected number", pos);

--r5Pyd7+fXNt84Ff3--

--=_pandora.barbara.ds.polsl.gliwice.pl-23316-1094128082-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQFBNxHSgEmu6PNADqoRAjo9AJ9fyM1CLEAr5qH5VC+Wwa242HfhBgCfRm+5
1PLHqdb0v2g79yeajcrXMiI=
=HEk2
-----END PGP SIGNATURE-----

--=_pandora.barbara.ds.polsl.gliwice.pl-23316-1094128082-0001-2--
