From: Harald Welte <laforge@netfilter.org>
Subject: [PATCH 2.6] netfilter Documentation/Changes
Date: Tue, 27 Jan 2004 22:53:26 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040127215326.GF11761@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mXWEJCq0x1D2MX0F"
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


--mXWEJCq0x1D2MX0F
Content-Type: multipart/mixed; boundary="qpqR4wE1CEr+Roqx"
Content-Disposition: inline


--qpqR4wE1CEr+Roqx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave!

Please apply the following patch to your 2.6.x tree.=20

It makes the Changes file actually match what happened with 2.6.x.

Thanks.

--
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--qpqR4wE1CEr+Roqx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="2.6.0-documentation-changes.patch"
Content-Transfer-Encoding: quoted-printable

--- a/Documentation/Changes	2003-09-29 21:20:11.000000000 +0200
+++ b/Documentation/Changes	2003-11-02 09:56:09.000000000 +0100
@@ -237,13 +237,15 @@
 General changes
 ---------------
=20
-The IP firewalling and NAT code has been replaced again.  The new
-netfilter software (including ipfwadm and ipchains backwards-
-compatible modules) is currently distributed separately.
-
 If you have advanced network configuration needs, you should probably
 consider using the network tools from ip-route2.
=20
+Packet Filter / NAT
+-------------------
+The packet filtering and NAT code uses the same tools like the previous 2.=
4.x
+kernel series (iptables).  It still includes backwards-compatibility modul=
es
+for 2.2.x-style ipchains and 2.0.x-style ipfwadm.
+
 PPP
 ---
=20
@@ -400,11 +402,9 @@
 ---------
 o  <http://sourceforge.net/project/showfiles.php?group_id=3D14>
=20
-Netfilter
----------
-o  <http://netfilter.filewatcher.org/iptables-1.2.tar.bz2>
-o  <http://netfilter.samba.org/iptables-1.2.tar.bz2>
-o  <http://netfilter.kernelnotes.org/iptables-1.2.tar.bz2>
+Iptables
+--------
+o  <http://www.iptables.org/downloads.html>
=20
 Ip-route2
 ---------

--qpqR4wE1CEr+Roqx--

--mXWEJCq0x1D2MX0F
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQFAFt3WXaXGVTD0i/8RAgLxAJ4w3Szvlb8upGG/gWCk6tueXzLDLwCfZDIj
IoFUZbxzXYszIoLhMIyPjTI=
=Gsq0
-----END PGP SIGNATURE-----

--mXWEJCq0x1D2MX0F--
