From: Harald Welte <laforge@netfilter.org>
Subject: [PATCH] fix 'icmp-type all' problem in iptables
Date: Wed, 26 Feb 2003 19:26:09 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030226182609.GS8883@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="v4cNTr+tRGSs1txX"
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


--v4cNTr+tRGSs1txX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave!

Here is the first of yet another set of iptables bugfixes for 2.4.x and 2.5=
.x:

Up to now the problem was:
	'-p icmp ' matches all icmp packets
	'-p icmp -m icmp' matches _only_ ICMP type 0 :(

This is now fixed by initializing the field in userspace to the bogus
icmp type 0xFF.  Old kernels (prior to this patch) would then match
packets with icmp-type 255 [which should never happen since it is
undefined).  New kernels with this patch have an explicit check for the
'magic value' 0xFF.

See also: https://bugzilla.netfilter.org/cgi-bin/bugzilla/show_bug.cgi?id=
=3D37

Credits go to  Filip Sneppe (Cronos)" <filip.sneppe@cronos.be>

Please apply, thanks.

diff -urN linux-2.4.20/net/ipv4/netfilter/ip_tables.c linux-2.4.20-icmp/net=
/ipv4/netfilter/ip_tables.c
--- linux-2.4.20/net/ipv4/netfilter/ip_tables.c Fri Nov 29 00:53:15 2002
+++ linux-2.4.20-icmp/net/ipv4/netfilter/ip_tables.c    Sun Feb 23 12:58:32=
 2003
@@ -1630,7 +1630,7 @@
                     u_int8_t type, u_int8_t code,
                     int invert)
 {
-       return (type =3D=3D test_type && code >=3D min_code && code <=3D ma=
x_code)
+       return ((test_type =3D=3D 0xFF) || (type =3D=3D test_type && code >=
=3D min_code && code <=3D max_code))
                ^ invert;
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

--v4cNTr+tRGSs1txX
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+XQbBXaXGVTD0i/8RAvymAJ49GzgjAxjK+bO1e+7VaV3/7ZtOdACdEvAX
tAEa13zyLq4acqyZ/JpLhOM=
=VFqi
-----END PGP SIGNATURE-----

--v4cNTr+tRGSs1txX--
