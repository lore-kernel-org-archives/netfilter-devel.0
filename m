From: Harald Welte <laforge@netfilter.org>
Subject: [PATCH 2.4] netfilter: fix UDP incremental checksumming
Date: Thu, 2 Oct 2003 16:15:09 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031002141509.GZ5758@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0aDCawMAyCa9mxHZ"
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


--0aDCawMAyCa9mxHZ
Content-Type: multipart/mixed; boundary="aKeOajaNu7w8cMvA"
Content-Disposition: inline


--aKeOajaNu7w8cMvA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Davem!

Please apply the following patchto your 2.4 tree and push it to Marcelo.
Thanks.


Author: Patrick McHardy <kaber@trash.net>
Status: Submitted for kernel inclusion at 2.4.23-pre5 time

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

--aKeOajaNu7w8cMvA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="78_nathelper-udp-csum.patch"
Content-Transfer-Encoding: quoted-printable

# This is a BitKeeper generated patch for the following project:
# Project Name: Linux kernel tree
# This patch format is intended for GNU patch command version 2.5 or higher.
# This patch includes the following deltas:
#	           ChangeSet	1.1133  -> 1.1134=20
#	net/ipv4/netfilter/ip_nat_helper.c	1.9     -> 1.10  =20
#
# The following is the BitKeeper ChangeSet Log
# --------------------------------------------
# 03/09/28	kaber@trash.net	1.1134
# [NETFILTER]: Fix UDP checksum in ip_nat_mangle_udp_packet, remove skb->cs=
um hacks
# --------------------------------------------
#
diff -Nru a/net/ipv4/netfilter/ip_nat_helper.c b/net/ipv4/netfilter/ip_nat_=
helper.c
--- a/net/ipv4/netfilter/ip_nat_helper.c	Sun Sep 28 04:40:05 2003
+++ b/net/ipv4/netfilter/ip_nat_helper.c	Sun Sep 28 04:40:05 2003
@@ -195,16 +195,11 @@
 		skb_trim(*skb, newlen);
 	}
=20
-	/* fix checksum information */
-
 	iph->tot_len =3D htons(newlen);
-	(*skb)->csum =3D csum_partial((char *)tcph + tcph->doff*4,
-				    newtcplen - tcph->doff*4, 0);
-
+	/* fix checksum information */
 	tcph->check =3D 0;
 	tcph->check =3D tcp_v4_check(tcph, newtcplen, iph->saddr, iph->daddr,
-				   csum_partial((char *)tcph, tcph->doff*4,
-					   (*skb)->csum));
+				   csum_partial((char *)tcph, newtcplen, 0));
 	ip_send_check(iph);
=20
 	return 1;
@@ -299,18 +294,12 @@
 	iph->tot_len =3D htons(newlen);
=20
 	/* fix udp checksum if udp checksum was previously calculated */
-	if ((*skb)->csum !=3D 0) {
-		(*skb)->csum =3D csum_partial((char *)udph +
-					    sizeof(struct udphdr),
-					    newudplen - sizeof(struct udphdr),
-					    0);
-
+	if (udph->check !=3D 0) {
 		udph->check =3D 0;
 		udph->check =3D csum_tcpudp_magic(iph->saddr, iph->daddr,
 						newudplen, IPPROTO_UDP,
 						csum_partial((char *)udph,
-							 sizeof(struct udphdr),
-							(*skb)->csum));
+						             newudplen, 0));
 	}
=20
 	ip_send_check(iph);

--aKeOajaNu7w8cMvA--

--0aDCawMAyCa9mxHZ
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.2 (GNU/Linux)

iD8DBQE/fDLtXaXGVTD0i/8RAk4AAJoCnQ4W5xvsV0h3xMaIl+v6yyOsMgCgqThf
s5pLyAFDI6oRtTXYwUaKIwQ=
=LULl
-----END PGP SIGNATURE-----

--0aDCawMAyCa9mxHZ--
