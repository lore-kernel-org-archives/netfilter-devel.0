From: Harald Welte <laforge@netfilter.org>
Subject: [PATCH 2.6] iptables ipt_helper Kconfig fix
Date: Sat, 30 Aug 2003 21:34:02 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030830193402.GL17715@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vhOf6eAHdfH9MSjZ"
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


--vhOf6eAHdfH9MSjZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Davem!

Please apply the following patch (against 2.6.0-test4).  It fixes a bug
in Kconfig causing ipt_helper not to be compiled if ip_conntrack is a
module.

Thanks.

--- linux-2.6.0-test4-plain/net/ipv4/netfilter/Kconfig	2003-08-30 20:19:56.=
000000000 +0200
+++ linux-2.6.0-test4-kconf/net/ipv4/netfilter/Kconfig	2003-08-30 20:20:50.=
000000000 +0200
@@ -239,7 +239,7 @@
=20
 config IP_NF_MATCH_HELPER
 	tristate "Helper match support"
-	depends on IP_NF_CONNTRACK!=3Dn && IP_NF_IPTABLES
+	depends on IP_NF_CONNTRACK && IP_NF_IPTABLES
 	help
 	  Helper matching allows you to match packets in dynamic connections
 	  tracked by a conntrack-helper, ie. ip_conntrack_ftp
--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--vhOf6eAHdfH9MSjZ
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.2 (GNU/Linux)

iD8DBQE/UPwqXaXGVTD0i/8RAvDlAJ9cfj3Ll4TP2CBZSnvwf8VlGM3qbACfXkHg
M7hVPaOMrEMVaoA7MSnKXH8=
=aSNc
-----END PGP SIGNATURE-----

--vhOf6eAHdfH9MSjZ--
