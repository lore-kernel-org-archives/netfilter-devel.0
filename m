From: Harald Welte <laforge@netfilter.org>
Subject: [PATCH 2.4] iptables tftp uninitialized variable fix
Date: Sat, 2 Aug 2003 15:20:08 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030802132008.GJ6894@naboo>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="J+xDcZ1j08+V/OfU"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>
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


--J+xDcZ1j08+V/OfU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Davem!

The below patch fixes an uninitialized return variable in 2.4.x

Please apply, thanks.

# This is a BitKeeper generated patch for the following project:
# Project Name: Linux kernel tree
# This patch format is intended for GNU patch command version 2.5 or higher.
# This patch includes the following deltas:
#	           ChangeSet	1.1019  -> 1.1020=20
#	net/ipv4/netfilter/ip_nat_tftp.c	1.1     -> 1.2   =20
#
# The following is the BitKeeper ChangeSet Log
# --------------------------------------------
# 03/07/21	kaber@trash.net	1.1020
# [NETFILTER]: fix uninitialized return value in ip_nat_tftp.c
# --------------------------------------------
#
diff -Nru a/net/ipv4/netfilter/ip_nat_tftp.c b/net/ipv4/netfilter/ip_nat_tf=
tp.c
--- a/net/ipv4/netfilter/ip_nat_tftp.c	Mon Jul 21 02:20:24 2003
+++ b/net/ipv4/netfilter/ip_nat_tftp.c	Mon Jul 21 02:20:24 2003
@@ -153,7 +153,7 @@
=20
 static int __init init(void)
 {
-	int i, ret;
+	int i, ret =3D 0;
 	char *tmpname;
=20
 	if (!ports[0])
--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--J+xDcZ1j08+V/OfU
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.2 (GNU/Linux)

iD8DBQE/K7qHXaXGVTD0i/8RAtjoAJ9lPAUDZubuS0gHNvzB6RfO+7qoswCfb9vU
Mwqn+LdhlDUHVjcA0f0nrDc=
=Rbp4
-----END PGP SIGNATURE-----

--J+xDcZ1j08+V/OfU--
