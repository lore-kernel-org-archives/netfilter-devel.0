From: Harald Welte <laforge@netfilter.org>
Subject: [PATCH] fix ip_nat_ftp in 2.6.0-test1
Date: Thu, 17 Jul 2003 23:12:54 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030717211254.GA27685@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cWoXeonUoKmBZSoM"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>
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


--cWoXeonUoKmBZSoM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi DaveM!

This is a 2.6 only fix for the FTP NAT helper code.  The patch below
(by Martin Josefsson) also closes Bug 933 in the kernel bug tracker.

The bug was introduced while making the helper compliant to the recently
introduced support for nonlinear skb's in netfilter.

Thanks!

--- linux-2.5.75/net/ipv4/netfilter/ip_nat_helper.c.orig	2003-07-17 19:27:5=
3.000000000 +0200
+++ linux-2.5.75/net/ipv4/netfilter/ip_nat_helper.c	2003-07-17 19:30:29.000=
000000 +0200
@@ -191,7 +191,7 @@
 				   csum_partial((char *)tcph, tcph->doff*4,
 						(*pskb)->csum));
 	adjust_tcp_sequence(ntohl(tcph->seq),
-			    (int)match_len - (int)rep_len,
+			    (int)rep_len - (int)match_len,
 			    ct, ctinfo);
 	return 1;
 }

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--cWoXeonUoKmBZSoM
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQE/FxFWXaXGVTD0i/8RAl/TAJ9qngo+Q/wXe3YjyJpJbSsUVcOrFQCdFdKm
D0ib6i4JzbpE9l2xEEwfpi4=
=5BrF
-----END PGP SIGNATURE-----

--cWoXeonUoKmBZSoM--
