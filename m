From: Harald Welte <laforge@netfilter.org>
Subject: [PATCH 2.4+2.6] Use <net/checksum.h> instead of <asm/checksum.h>
Date: Sun, 21 Sep 2003 16:52:52 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030921145252.GD22223@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="sfyO1m2EN8ZOtJL6"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Matthew Wilcox <willy@debian.org>
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


--sfyO1m2EN8ZOtJL6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave!

Please apply the following trivial fix (by Matthew Wilcox) to 2.4 and
2.6.  Thanks.

diff -u -p -r1.3 ip_nat_snmp_basic.c
--- a/net/ipv4/netfilter/ip_nat_snmp_basic.c      8 Sep 2003 21:42:58 -0000=
      1.3
+++ b/net/ipv4/netfilter/ip_nat_snmp_basic.c      20 Sep 2003 00:15:46 -0000
@@ -51,9 +51,9 @@
 #include <linux/netfilter_ipv4/ip_nat.h>
 #include <linux/netfilter_ipv4/ip_nat_helper.h>
 #include <linux/ip.h>
+#include <net/checksum.h>
 #include <net/udp.h>
 #include <asm/uaccess.h>
-#include <asm/checksum.h>
=20
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("James Morris <jmorris@intercode.com.au>");



--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--sfyO1m2EN8ZOtJL6
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.2 (GNU/Linux)

iD8DBQE/bbtEXaXGVTD0i/8RAjp/AJwK06cl1K5G8cq8skeQjvaUzpS5YQCfewMV
34rVt3qfRVXwGNG/NOO7Zmc=
=iPIx
-----END PGP SIGNATURE-----

--sfyO1m2EN8ZOtJL6--
