From: Harald Welte <laforge@netfilter.org>
Subject: [PATCH 1/5] NETFILTER: Add missing PPTP dependency
Date: Mon, 10 Oct 2005 00:12:05 +0200
Message-ID: <20051009221205.GA6493@rama.customers.eurospot.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xHFwDpU9dbj6ez1V"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: David Miller <davem@davemloft.net>
Content-Disposition: inline
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


--xHFwDpU9dbj6ez1V
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,

please apply this trivial fix to your tree:

[NETFILTER] PPTP helper: Add missing Kconfig dependency

PPTP should not be selectable without conntrack enabled

Signed-off-by: Harald Welte <laforge@netfilter.org>

---
commit 1170becbdb829a1e1120d93bc56b3ffe1a8ef22a
tree 8474d1e11358c4e0d66de5ab039f834b162b3c1c
parent 0b4f28e7d0a469b2877ac18619af9c9695972c09
author Harald Welte <laforge@netfilter.org> Sat, 08 Oct 2005 00:59:05 +0200
committer Harald Welte <laforge@netfilter.org> Sat, 08 Oct 2005 00:59:05 +0=
200

 net/ipv4/netfilter/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/net/ipv4/netfilter/Kconfig b/net/ipv4/netfilter/Kconfig
--- a/net/ipv4/netfilter/Kconfig
+++ b/net/ipv4/netfilter/Kconfig
@@ -139,6 +139,7 @@ config IP_NF_AMANDA
=20
 config IP_NF_PPTP
 	tristate  'PPTP protocol support'
+	depends on IP_NF_CONNTRACK
 	help
 	  This module adds support for PPTP (Point to Point Tunnelling
 	  Protocol, RFC2637) connection tracking and NAT.=20

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--xHFwDpU9dbj6ez1V
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQFDSZW1XaXGVTD0i/8RAuZ+AJ9x7Y99hdWpybjeEDP+/hcRZA5I0gCeNQqy
xlciTL5AYRRyDduEX3cR6P4=
=beAT
-----END PGP SIGNATURE-----

--xHFwDpU9dbj6ez1V--
