From: Harald Welte <laforge@netfilter.org>
Subject: [PATCH 2.6] netfilter: fix UDP incremental checksumming
Date: Thu, 2 Oct 2003 16:24:02 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031002142402.GA5758@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="op1wyikMGa8+7dN1"
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


--op1wyikMGa8+7dN1
Content-Type: multipart/mixed; boundary="Xuy7d2Tq97A7mj7l"
Content-Disposition: inline


--Xuy7d2Tq97A7mj7l
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Davem!

Please apply the following patchto your 2.6 tree and push it to Marcelo.
Thanks.


Author: Patrick McHardy <kaber@trash.net>

Fix UDP checksum in ip_nat_mangle_udp_packet, remove skb->csum hacks

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--Xuy7d2Tq97A7mj7l
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="75_nathelper-udp-csum.patch"
Content-Transfer-Encoding: quoted-printable

# This is a BitKeeper generated patch for the following project:
# Project Name: Linux kernel tree
# This patch format is intended for GNU patch command version 2.5 or higher.
# This patch includes the following deltas:
#	           ChangeSet	1.1354  -> 1.1355=20
#	net/ipv4/netfilter/ip_nat_helper.c	1.17    -> 1.18  =20
#
# The following is the BitKeeper ChangeSet Log
# --------------------------------------------
# 03/09/27	kaber@trash.net	1.1355
# [NETFILTER]: Fix UDP checksum in ip_nat_mangle_udp_packet, remove skb->cs=
um hacks
# --------------------------------------------
#
diff -Nru a/net/ipv4/netfilter/ip_nat_helper.c b/net/ipv4/netfilter/ip_nat_=
helper.c
--- a/net/ipv4/netfilter/ip_nat_helper.c	Sat Sep 27 21:07:35 2003
+++ b/net/ipv4/netfilter/ip_nat_helper.c	Sat Sep 27 21:07:35 2003
@@ -122,7 +122,6 @@
 	/* fix IP hdr checksum information */
 	skb->nh.iph->tot_len =3D htons(skb->len);
 	ip_send_check(skb->nh.iph);
-	skb->csum =3D csum_partial(data, skb->len - dataoff, 0);
 }
=20
 /* Unusual, but possible case. */
@@ -167,6 +166,7 @@
 {
 	struct iphdr *iph;
 	struct tcphdr *tcph;
+	int datalen;
=20
 	if (!skb_ip_make_writable(pskb, (*pskb)->len))
 		return 0;
@@ -184,11 +184,11 @@
 	mangle_contents(*pskb, iph->ihl*4 + tcph->doff*4,
 			match_offset, match_len, rep_buffer, rep_len);
=20
+	datalen =3D (*pskb)->len - iph->ihl*4;
 	tcph->check =3D 0;
-	tcph->check =3D tcp_v4_check(tcph, (*pskb)->len - iph->ihl*4,
-				   iph->saddr, iph->daddr,
-				   csum_partial((char *)tcph, tcph->doff*4,
-						(*pskb)->csum));
+	tcph->check =3D tcp_v4_check(tcph, datalen, iph->saddr, iph->daddr,
+				   csum_partial((char *)tcph, datalen, 0));
+
 	adjust_tcp_sequence(ntohl(tcph->seq),
 			    (int)rep_len - (int)match_len,
 			    ct, ctinfo);
@@ -216,7 +216,6 @@
 {
 	struct iphdr *iph;
 	struct udphdr *udph;
-	int need_csum =3D ((*pskb)->csum !=3D 0);
=20
 	if (!skb_ip_make_writable(pskb, (*pskb)->len))
 		return 0;
@@ -235,17 +234,15 @@
 	udph->len =3D htons((*pskb)->len - iph->ihl*4);
=20
 	/* fix udp checksum if udp checksum was previously calculated */
-	if (need_csum) {
+	if (udph->check) {
+		int datalen =3D (*pskb)->len - iph->ihl * 4;
 		udph->check =3D 0;
-		udph->check
-			=3D csum_tcpudp_magic(iph->saddr, iph->daddr,
-					    (*pskb)->len - iph->ihl*4,
-					    IPPROTO_UDP,
-					    csum_partial((char *)udph,
-							 sizeof(struct udphdr),
-							 (*pskb)->csum));
-	} else
-		(*pskb)->csum =3D 0;
+		udph->check =3D csum_tcpudp_magic(iph->saddr, iph->daddr,
+		                                datalen, IPPROTO_UDP,
+		                                csum_partial((char *)udph,
+		                                             datalen, 0));
+	}
+
 	return 1;
 }
=20

--Xuy7d2Tq97A7mj7l--

--op1wyikMGa8+7dN1
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.2 (GNU/Linux)

iD8DBQE/fDUCXaXGVTD0i/8RAu5RAKCEnONE8obGv0+OkM28ys+d/fXu7wCdFKkG
dlJOwkBI6kDMg2UHeeIojno=
=JPlW
-----END PGP SIGNATURE-----

--op1wyikMGa8+7dN1--
