From: Harald Welte <laforge@netfilter.org>
Subject: [PATCH 2.4] netfilter: fix UDP incremental checksumming
Date: Thu, 2 Oct 2003 16:26:46 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031002142646.GC5758@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/pwFaPbQJiTDEB5I"
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


--/pwFaPbQJiTDEB5I
Content-Type: multipart/mixed; boundary="iiGw1pLv4Q7HfyNL"
Content-Disposition: inline


--iiGw1pLv4Q7HfyNL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Davem!

Please apply the following patchto your 2.4 tree and push it to Marcelo.
Thanks.


Author: Patrick McHardy <kaber@trash.net>

Add size check to ip_nat_mangle_udp_packet

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--iiGw1pLv4Q7HfyNL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="79_mangle_udp-sizecheck.patch"
Content-Transfer-Encoding: quoted-printable

# This is a BitKeeper generated patch for the following project:
# Project Name: Linux kernel tree
# This patch format is intended for GNU patch command version 2.5 or higher.
# This patch includes the following deltas:
#	           ChangeSet	1.1134  -> 1.1135=20
#	net/ipv4/netfilter/ip_nat_helper.c	1.10    -> 1.11  =20
#
# The following is the BitKeeper ChangeSet Log
# --------------------------------------------
# 03/09/28	kaber@trash.net	1.1135
# [NETFILTER]: Add size check to ip_nat_mangle_udp_packet
# --------------------------------------------
#
diff -Nru a/net/ipv4/netfilter/ip_nat_helper.c b/net/ipv4/netfilter/ip_nat_=
helper.c
--- a/net/ipv4/netfilter/ip_nat_helper.c	Sun Sep 28 04:40:29 2003
+++ b/net/ipv4/netfilter/ip_nat_helper.c	Sun Sep 28 04:40:29 2003
@@ -233,6 +233,13 @@
 	newudplen =3D udplen - match_len + rep_len;
 	newlen =3D iph->ihl*4 + newudplen;
=20
+	/* UDP helpers might accidentally mangle the wrong packet */
+	if (udplen < sizeof(*udph) + match_offset + match_len) {
+		if (net_ratelimit())
+			printk("ip_nat_mangle_udp_packet: undersized packet\n");
+		return 0;
+	}
+
 	if (newlen > 65535) {
 		if (net_ratelimit())
 			printk("ip_nat_mangle_udp_packet: nat'ed packet "

--iiGw1pLv4Q7HfyNL--

--/pwFaPbQJiTDEB5I
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.2 (GNU/Linux)

iD8DBQE/fDWmXaXGVTD0i/8RAu3BAJ9RDO5D4zUhFPhZ0qihaEC84oUf/gCfb94f
XnDqU0HhEjlBoRTjYMnSfCI=
=AOLg
-----END PGP SIGNATURE-----

--/pwFaPbQJiTDEB5I--
