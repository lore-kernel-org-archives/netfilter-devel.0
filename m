From: Harald Welte <laforge@netfilter.org>
Subject: [PATCH 2.6] netfilter: fix REJECT in LOCAL_OUT case
Date: Thu, 2 Oct 2003 16:32:15 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031002143215.GF5758@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XwYplyRgqW9Nm5hN"
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


--XwYplyRgqW9Nm5hN
Content-Type: multipart/mixed; boundary="XT6GUpe1qJ5iRKjO"
Content-Disposition: inline


--XT6GUpe1qJ5iRKjO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Davem!

Please apply the following patch to your 2.6 tree and push it for kernel
inclusion, thanks.

Author: Patrick McHardy <kaber@trash.net>

Fix REJECT if used in LOCAL_OUT

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--XT6GUpe1qJ5iRKjO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="78_reject-localout.patch"
Content-Transfer-Encoding: quoted-printable

# This is a BitKeeper generated patch for the following project:
# Project Name: Linux kernel tree
# This patch format is intended for GNU patch command version 2.5 or higher.
# This patch includes the following deltas:
#	           ChangeSet	1.1358  -> 1.1359=20
#	net/ipv4/netfilter/ipt_REJECT.c	1.23    -> 1.24  =20
#
# The following is the BitKeeper ChangeSet Log
# --------------------------------------------
# 03/09/28	kaber@trash.net	1.1355
# [NETFILTER]: Fix REJECT in LOCAL_OUT
# --------------------------------------------
#
diff -Nru a/net/ipv4/netfilter/ipt_REJECT.c b/net/ipv4/netfilter/ipt_REJECT=
=2Ec
--- a/net/ipv4/netfilter/ipt_REJECT.c	Sun Sep 28 05:22:42 2003
+++ b/net/ipv4/netfilter/ipt_REJECT.c	Sun Sep 28 05:22:42 2003
@@ -40,16 +40,17 @@
 	}
 }
=20
-static inline struct rtable *route_reverse(struct sk_buff *skb, int local)
+static inline struct rtable *route_reverse(struct sk_buff *skb, int hook)
 {
 	struct iphdr *iph =3D skb->nh.iph;
 	struct dst_entry *odst;
 	struct flowi fl =3D {};
 	struct rtable *rt;
=20
-	if (local) {
+	if (hook !=3D NF_IP_FORWARD) {
 		fl.nl_u.ip4_u.daddr =3D iph->saddr;
-		fl.nl_u.ip4_u.saddr =3D iph->daddr;
+		if (hook =3D=3D NF_IP_LOCAL_IN)
+			fl.nl_u.ip4_u.saddr =3D iph->daddr;
 		fl.nl_u.ip4_u.tos =3D RT_TOS(iph->tos);
=20
 		if (ip_route_output_key(&rt, &fl) !=3D 0)
@@ -81,7 +82,7 @@
 }
=20
 /* Send RST reply */
-static void send_reset(struct sk_buff *oldskb, int local)
+static void send_reset(struct sk_buff *oldskb, int hook)
 {
 	struct sk_buff *nskb;
 	struct tcphdr otcph, *tcph;
@@ -104,7 +105,7 @@
 		return;
=20
 	/* FIXME: Check checksum --RR */
-	if ((rt =3D route_reverse(oldskb, local)) =3D=3D NULL)
+	if ((rt =3D route_reverse(oldskb, hook)) =3D=3D NULL)
 		return;
=20
 	hh_len =3D (rt->u.dst.dev->hard_header_len + 15)&~15;
@@ -390,7 +391,7 @@
 		send_unreach(*pskb, ICMP_PKT_FILTERED);
 		break;
 	case IPT_TCP_RESET:
-		send_reset(*pskb, hooknum =3D=3D NF_IP_LOCAL_IN);
+		send_reset(*pskb, hooknum);
 	case IPT_ICMP_ECHOREPLY:
 		/* Doesn't happen. */
 		break;

--XT6GUpe1qJ5iRKjO--

--XwYplyRgqW9Nm5hN
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.2 (GNU/Linux)

iD8DBQE/fDbvXaXGVTD0i/8RAgXrAKCCGXqH/iVb4Q3okfnUI5wsSccOVgCfSfmG
WJcoIvQzej/Uo36iI8N1V/M=
=8Tcd
-----END PGP SIGNATURE-----

--XwYplyRgqW9Nm5hN--
