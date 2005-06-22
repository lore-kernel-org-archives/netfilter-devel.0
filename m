From: Harald Welte <laforge@netfilter.org>
Subject: [PATCH 2.6] ipt_CLUSTERIP: fix ARP mangling
Date: Wed, 22 Jun 2005 14:29:02 +0200
Message-ID: <20050622122902.GI4551@obroa-skai.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BEa57a89OpeoUzGD"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: David Miller <davem@redhat.com>
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


--BEa57a89OpeoUzGD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave, please apply!

The patch below adds mangling of ARP requests (in addition to replies),
since ARP caches are made from snooping both requests and replies.

Signed-off-by: Harald Welte <laforge@netfilter.org>

Index: linux-2.6.12-ctnl/net/ipv4/netfilter/ipt_CLUSTERIP.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux-2.6.12-ctnl.orig/net/ipv4/netfilter/ipt_CLUSTERIP.c	2005-03-02 08=
:37:48.000000000 +0100
+++ linux-2.6.12-ctnl/net/ipv4/netfilter/ipt_CLUSTERIP.c	2005-06-22 14:23:2=
4.000000000 +0200
@@ -31,7 +31,7 @@
 #include <linux/netfilter_ipv4/ip_conntrack.h>
 #include <linux/netfilter_ipv4/lockhelp.h>
=20
-#define CLUSTERIP_VERSION "0.6"
+#define CLUSTERIP_VERSION "0.7"
=20
 #define DEBUG_CLUSTERIP
=20
@@ -523,8 +523,9 @@
 	    || arp->ar_pln !=3D 4 || arp->ar_hln !=3D ETH_ALEN)
 		return NF_ACCEPT;
=20
-	/* we only want to mangle arp replies */
-	if (arp->ar_op !=3D htons(ARPOP_REPLY))
+	/* we only want to mangle arp requests and replies */
+	if (arp->ar_op !=3D htons(ARPOP_REPLY)
+	    && arp->ar_op !=3D htons(ARPOP_REQUEST))
 		return NF_ACCEPT;
=20
 	payload =3D (void *)(arp+1);
--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--BEa57a89OpeoUzGD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFCuVmOXaXGVTD0i/8RAg7rAJ9TLmosXoEJlBOGQdVm77hTK+7xcgCdHeLk
R7N9Dyq79r5BF2IUpbpxugY=
=vyJ2
-----END PGP SIGNATURE-----

--BEa57a89OpeoUzGD--
