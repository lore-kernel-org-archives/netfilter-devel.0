From: Harald Welte <laforge@gnumonks.org>
Subject: [PATCH] fixes for ipt_unclean.c
Date: Mon, 14 Oct 2002 13:22:37 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20021014132237.N13233@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tJbPEdXFtLQcWY9B"
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


--tJbPEdXFtLQcWY9B
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave!

Below are two fixes for the EXPERIMENTAL ipt_unclean.c

It fixes two bugs:

- packets with UDP sport =3D=3D 0 are OK according to RFC768
- UDP checksum is optional (old code required packet to have a checksum)

Please apply, thanks.

diff -uNr linux-2.4.19-vanilla/net/ipv4/netfilter/ipt_unclean.c linux/net/i=
pv4/netfilter/ipt_unclean.c
--- linux-2.4.19-vanilla/net/ipv4/netfilter/ipt_unclean.c	2002-09-10 16:06:=
50.000000000 +0200
+++ linux/net/ipv4/netfilter/ipt_unclean.c	2002-09-10 16:22:57.000000000 +0=
200
@@ -211,7 +211,7 @@
=20
 	/* Bad checksum?  Don't print, just say it's unclean. */
 	/* FIXME: SRC ROUTE packets won't match checksum --RR */
-	if (!more_frags && !embedded
+	if (!more_frags && !embedded && udph->check
 	    && csum_tcpudp_magic(iph->saddr, iph->daddr, datalen, IPPROTO_UDP,
 				 csum_partial((char *)udph, datalen, 0)) !=3D 0)
 		return 0;

--- linux-2.4.19-vanilla/net/ipv4/netfilter/ipt_unclean.c	2002-09-10 16:06:=
50.000000000 +0200
+++ linux/net/ipv4/netfilter/ipt_unclean.c	2002-10-12 00:56:09.000000000 +0=
200
@@ -216,10 +216,9 @@
 				 csum_partial((char *)udph, datalen, 0)) !=3D 0)
 		return 0;
=20
-	/* CHECK: Ports can't be zero. */
-	if (!udph->source || !udph->dest) {
-		limpk("UDP zero ports %u/%u\n",
-		      ntohs(udph->source), ntohs(udph->dest));
+	/* CHECK: Destination port can't be zero. */
+	if (!udph->dest) {
+		limpk("UDP zero destination port\n");
 		return 0;
 	}
=20
--=20
Live long and prosper
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
"If this were a dictatorship, it'd be a heck of a lot easier, just so long
 as I'm the dictator."  --  George W. Bush Dec 18, 2000

--tJbPEdXFtLQcWY9B
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE9qqj9XaXGVTD0i/8RAmPcAJ9eJkJtFXXkTSZBMeWFCxv5BixavwCfWDvw
5BFBW7t9cnKY4qq1wST9FtY=
=AMel
-----END PGP SIGNATURE-----

--tJbPEdXFtLQcWY9B--
