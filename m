From: Harald Welte <laforge@gnumonks.org>
Subject: [PATCH 2.4] fix ECN target / cloned skb problem
Date: Fri, 20 Feb 2004 21:01:06 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040220200106.GN4797@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8+odlFQADydc3R4z"
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


--8+odlFQADydc3R4z
Content-Type: multipart/mixed; boundary="w+rhPQc/K9ract27"
Content-Disposition: inline


--w+rhPQc/K9ract27
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave!

The attached patch fixes a 2.4-only problem in the ECN target - we miss
to re-set some pointers after uncloning the skb.

Thanks to Maciej Soltysiak for spotting that problem and preparing the
patch.

Please apply, thanks

--=20
- Harald Welte <laforge@gnumonks.org>               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
Programming is like sex: One mistake and you have to support it your lifeti=
me

--w+rhPQc/K9ract27
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="60_ecn_raw_unclone.patch"
Content-Transfer-Encoding: quoted-printable

--- linux/net/ipv4/netfilter/ipt_ECN.c	2003-12-13 09:54:14.000000000 +0100
+++ linux-new/net/ipv4/netfilter/ipt_ECN.c	2003-12-13 09:56:35.000000000 +0=
100
@@ -4,7 +4,7 @@
  *=20
  * This software is distributed under GNU GPL v2, 1991
  *=20
- * ipt_ECN.c,v 1.4 2002/08/05 19:36:51 laforge Exp
+ * ipt_ECN.c,v 1.7 2003/12/15 15:18:06 laforge Exp=20
 */
=20
 #include <linux/module.h>
@@ -59,8 +59,8 @@
 	    const struct ipt_ECN_info *einfo)
 {
=20
-	struct tcphdr *tcph =3D (void *) iph + iph->ihl * 4;
-	u_int16_t *tcpflags =3D (u_int16_t *)tcph + 6;
+	struct tcphdr *tcph;
+	u_int16_t *tcpflags;
 	u_int16_t diffs[2];
=20
 	/* raw socket (tcpdump) may have clone of incoming
@@ -71,9 +71,12 @@
 			return NF_DROP;
 		kfree_skb(*pskb);
 		*pskb =3D nskb;
-		iph =3D (*pskb)->nh.iph;
 	}
=20
+	iph =3D (*pskb)->nh.iph;
+	tcph =3D (void *) iph + iph->ihl * 4;
+	tcpflags =3D (u_int16_t *)tcph + 6;
+
 	diffs[0] =3D *tcpflags;
=20
 	if (einfo->operation & IPT_ECN_OP_SET_ECE

--w+rhPQc/K9ract27--

--8+odlFQADydc3R4z
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFANmeCXaXGVTD0i/8RAmv5AJ9HSJZ/5cHhAyKF7eA8NKbH+ywoewCfTgmI
gWvK1+jDfv1UI+tZ2WXEkQI=
=1Y8X
-----END PGP SIGNATURE-----

--8+odlFQADydc3R4z--
