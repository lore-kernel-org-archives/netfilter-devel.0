From: Harald Welte <laforge@netfilter.org>
Subject: [PATCH] multiple 2.4.x ipt_REJECT fixes
Date: Sun, 27 Apr 2003 12:46:03 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030427104603.GJ990@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="fckbADODYWZD5TdN"
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


--fckbADODYWZD5TdN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave!

Again another patch, courtesy of Patrick McHardy.  This time a 2.4.x
only patch (applies against 2.4.21-rc1).  The fix is incremental to a
change in early 2.4.21-preX days.

Please apply, Thanks


# This is a BitKeeper generated patch for the following project:
# Project Name: Linux kernel tree
# This patch format is intended for GNU patch command version 2.5 or higher.
# This patch includes the following deltas:
#	           ChangeSet	1.1101  -> 1.1102=20
#	net/ipv4/netfilter/ipt_REJECT.c	1.10    -> 1.11  =20
#
# The following is the BitKeeper ChangeSet Log
# --------------------------------------------
# 03/04/21	kaber@trash.net	1.1102
# - fix tcp-rst routing
# - fix memory leak
# - remove unecessary "struct in_device" declaration
# - remove RTO_CONN
# --------------------------------------------
#
diff -Nru a/net/ipv4/netfilter/ipt_REJECT.c b/net/ipv4/netfilter/ipt_REJECT=
.c
--- a/net/ipv4/netfilter/ipt_REJECT.c	Mon Apr 21 21:26:34 2003
+++ b/net/ipv4/netfilter/ipt_REJECT.c	Mon Apr 21 21:26:34 2003
@@ -11,7 +11,6 @@
 #include <net/icmp.h>
 #include <net/ip.h>
 #include <net/tcp.h>
-struct in_device;
 #include <net/route.h>
 #include <linux/netfilter_ipv4/ip_tables.h>
 #include <linux/netfilter_ipv4/ipt_REJECT.h>
@@ -65,10 +64,9 @@
 		return;
=20
 	/* Routing: if not headed for us, route won't like source */
-	if (ip_route_output(&rt, oldskb->nh.iph->daddr,
-			    local ? oldskb->nh.iph->saddr : 0,
-			    RT_TOS(oldskb->nh.iph->tos) | RTO_CONN,
-			    0) !=3D 0)
+	if (ip_route_output(&rt, oldskb->nh.iph->saddr,
+			    local ? oldskb->nh.iph->daddr : 0,
+			    RT_TOS(oldskb->nh.iph->tos), 0) !=3D 0)
 		return;
=20
 	hh_len =3D (rt->u.dst.dev->hard_header_len + 15)&~15;
@@ -80,8 +78,10 @@
 	   hh_len of incoming interface < hh_len of outgoing interface */
 	nskb =3D skb_copy_expand(oldskb, hh_len, skb_tailroom(oldskb),
 			       GFP_ATOMIC);
-	if (!nskb)
+	if (!nskb) {
+		dst_release(&rt->u.dst);
 		return;
+	}
=20
 	dst_release(nskb->dst);
 	nskb->dst =3D &rt->u.dst;
--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--fckbADODYWZD5TdN
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+q7TrXaXGVTD0i/8RAtiZAJ9uCoJ/nacgd1Lvvxm5t4gWxR606gCeKo1X
9bJaf+atfcoeXpZLjqr/Qt0=
=QsM9
-----END PGP SIGNATURE-----

--fckbADODYWZD5TdN--
