From: Harald Welte <laforge@netfilter.org>
Subject: [PATCH 2.6] iptables AH/ESP fix (2/3)
Date: Sat, 2 Aug 2003 15:00:39 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030802130039.GG6894@naboo>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9hzSyicXuByfNYJd"
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


--9hzSyicXuByfNYJd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Davem!

The below patch (by Patrick McHardy) fixes the iptables 'ah' match to
use the same structure definition like the 2.5/2.6 in-kernel IPsec
implementation.

Please apply, thanks.

diff -Nru a/net/ipv4/netfilter/ipt_ah.c b/net/ipv4/netfilter/ipt_ah.c
--- a/net/ipv4/netfilter/ipt_ah.c	Thu May 22 01:35:36 2003
+++ b/net/ipv4/netfilter/ipt_ah.c	Mon Jul 21 02:48:59 2003
@@ -1,6 +1,7 @@
 /* Kernel module to match AH parameters. */
 #include <linux/module.h>
 #include <linux/skbuff.h>
+#include <linux/ip.h>
=20
 #include <linux/netfilter_ipv4/ipt_ah.h>
 #include <linux/netfilter_ipv4/ip_tables.h>
@@ -13,10 +14,6 @@
 #define duprintf(format, args...)
 #endif
=20
-struct ahhdr {
-	__u32   spi;
-};
-
 /* Returns 1 if the spi is matched by the range, 0 otherwise */
 static inline int
 spi_match(u_int32_t min, u_int32_t max, u_int32_t spi, int invert)
@@ -37,7 +34,7 @@
       int offset,
       int *hotdrop)
 {
-	struct ahhdr ah;
+	struct ip_auth_hdr ah;
 	const struct ipt_ah *ahinfo =3D matchinfo;
=20
 	/* Must not be a fragment. */
--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--9hzSyicXuByfNYJd
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.2 (GNU/Linux)

iD8DBQE/K7X3XaXGVTD0i/8RAr0lAJ9gBU/qYDr8xEhH3OxoNjiguxeF1gCdH5/L
iT5hhWG5GYdB9H+cjzIb/L8=
=Ubol
-----END PGP SIGNATURE-----

--9hzSyicXuByfNYJd--
