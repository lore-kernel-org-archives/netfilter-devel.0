From: Harald Welte <laforge@gnumonks.org>
Subject: [PATCH] ipt_REJECT shouldn't send replies for wrong udp csum
Date: Thu, 9 Jan 2003 15:46:41 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030109144641.GI9467@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dRZtNaFcRiL7vj6v"
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


--dRZtNaFcRiL7vj6v
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave!

This is another patch of the series of patches you will receive from me tod=
ay.

Please apply to 2.4.x and 2.5.x, thanks.

Author: Patrick McHardy <kaber@trash.net>
ipt_REJECT sends unreachables in response to UDP packets with invalid
checksums, thereby exposing the existance of a firewall  (as described
in phrack #60, "broken crc firewall spotting" (or something like this),
www.phrack.com).  The patch makes ipt_REJECT verify UDP checksums if
set.                        =20


diff -urN linux-2.4.21-pre2-clean/net/ipv4/netfilter/ipt_REJECT.c linux-2.4=
.21-pre2/net/ipv4/netfilter/ipt_REJECT.c
--- linux-2.4.21-pre2-clean/net/ipv4/netfilter/ipt_REJECT.c	2002-11-29 00:5=
3:15.000000000 +0100
+++ linux-2.4.21-pre2/net/ipv4/netfilter/ipt_REJECT.c	2003-01-05 19:59:27.0=
00000000 +0100
@@ -6,6 +6,8 @@
 #include <linux/module.h>
 #include <linux/skbuff.h>
 #include <linux/ip.h>
+#include <linux/udp.h>
+#include <linux/icmp.h>
 #include <net/icmp.h>
 #include <net/ip.h>
 #include <net/tcp.h>
@@ -157,6 +159,7 @@
 static void send_unreach(struct sk_buff *skb_in, int code)
 {
 	struct iphdr *iph;
+	struct udphdr *udph;
 	struct icmphdr *icmph;
 	struct sk_buff *nskb;
 	u32 saddr;
@@ -186,6 +189,19 @@
 	if (iph->frag_off&htons(IP_OFFSET))
 		return;
=20
+	/* if UDP checksum is set, verify it's correct */
+	if (iph->protocol =3D=3D IPPROTO_UDP
+	    && skb_in->tail-(u8*)iph >=3D sizeof(struct udphdr)) {
+		int datalen =3D skb_in->len - (iph->ihl<<2);
+		udph =3D (struct udphdr *)((char *)iph + (iph->ihl<<2));
+		if (udph->check
+		    && csum_tcpudp_magic(iph->saddr, iph->daddr,
+		                         datalen, IPPROTO_UDP,
+		                         csum_partial((char *)udph, datalen,
+		                                      0)) !=3D 0)
+			return;
+	}
+		   =20
 	/* If we send an ICMP error to an ICMP error a mess would result.. */
 	if (iph->protocol =3D=3D IPPROTO_ICMP
 	    && skb_in->tail-(u8*)iph >=3D sizeof(struct icmphdr)) {

--=20
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
"If this were a dictatorship, it'd be a heck of a lot easier, just so long
 as I'm the dictator."  --  George W. Bush Dec 18, 2000

--dRZtNaFcRiL7vj6v
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+HYtRXaXGVTD0i/8RAgsbAKCJ1ihGrePE8WU3AVChiUqbOMihJwCfdxJo
MKOJr+tHBXLcF8QQ9PCoVtI=
=JzbA
-----END PGP SIGNATURE-----

--dRZtNaFcRiL7vj6v--
