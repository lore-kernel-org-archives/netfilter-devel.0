From: Harald Welte <laforge@netfilter.org>
Subject: [PATCH] netfilter fix (2/7): don't call nat helper for connection with no manips
Date: Tue, 24 Jun 2003 15:59:19 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030624135919.GB2645@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NMuMz9nt05w80d4+"
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


--NMuMz9nt05w80d4+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave!

Here goes the second...

Author: Jeff Hall <hall@vdata.com>, Harald Welte <laforge@netfilter.org>

This patch fixes two issues in the newnat core that are particularly releva=
nt
for the pptp helper:

1) Don't call a NAT helper for a connection without any nat manips
2) Really call NAT helper with IP_NAT_HELPER_F_ALWAYS always

diff -Nru --exclude .depend --exclude '*.o' --exclude '*.ver' --exclude '.*=
=2Eflags' --exclude '*.orig' --exclude '*.rej' --exclude '*~' linux-2.4.21-=
dropback/net/ipv4/netfilter/ip_nat_core.c linux-2.4.21-nohelper/net/ipv4/ne=
tfilter/ip_nat_core.c
--- linux-2.4.21-dropback/net/ipv4/netfilter/ip_nat_core.c	2003-06-13 16:51=
:39.000000000 +0200
+++ linux-2.4.21-nohelper/net/ipv4/netfilter/ip_nat_core.c	2003-06-24 15:52=
:56.000000000 +0200
@@ -756,6 +756,11 @@
 	enum ip_conntrack_dir dir =3D CTINFO2DIR(ctinfo);
 	int is_tcp =3D (*pskb)->nh.iph->protocol =3D=3D IPPROTO_TCP;
=20
+	/* Skip everything and don't call helpers if there are no
+	 * manips for this connection */
+	if (info->num_manips =3D=3D 0)
+		return NF_ACCEPT;
+
 	/* Need nat lock to protect against modification, but neither
 	   conntrack (referenced) and helper (deleted with
 	   synchronize_bh()) can vanish. */
@@ -796,6 +801,7 @@
 		struct ip_conntrack_expect *exp =3D NULL;
 		struct list_head *cur_item;
 		int ret =3D NF_ACCEPT;
+		int helper_called =3D 0;
=20
 		DEBUGP("do_bindings: helper existing for (%p)\n", ct);
=20
@@ -814,19 +820,21 @@
 				continue;
=20
 			if (exp_for_packet(exp, pskb)) {
-				/* FIXME: May be true multiple times in the case of UDP!! */
-				DEBUGP("calling nat helper (exp=3D%p) for packet\n",
-					exp);
+				/* FIXME: May be true multiple times in the
+				 * case of UDP!! */
+				DEBUGP("calling nat helper (exp=3D%p) for	packet\n", exp);
 				ret =3D helper->help(ct, exp, info, ctinfo,=20
 						   hooknum, pskb);
 				if (ret !=3D NF_ACCEPT) {
 					READ_UNLOCK(&ip_conntrack_lock);
 					return ret;
 				}
+				helper_called =3D 1;
 			}
 		}
-		/* Helper might want to manip the packet even when there is no expectati=
on */
-		if (!exp && helper->flags & IP_NAT_HELPER_F_ALWAYS) {
+		/* Helper might want to manip the packet even when there is no
+		 * matching expectation for this packet */
+		if (!helper_called && helper->flags & IP_NAT_HELPER_F_ALWAYS) {
 			DEBUGP("calling nat helper for packet without expectation\n");
 			ret =3D helper->help(ct, NULL, info, ctinfo,=20
 					   hooknum, pskb);
Please apply, thanks.

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--NMuMz9nt05w80d4+
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQE++Fk3XaXGVTD0i/8RAnRRAJ9gYC166KkTeh3XqYVOERejqfP+EACfRMXp
NSsYGYt5ShHGJEHWnZswJtU=
=25F3
-----END PGP SIGNATURE-----

--NMuMz9nt05w80d4+--
