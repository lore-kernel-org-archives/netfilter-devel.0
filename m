From: Harald Welte <laforge@netfilter.org>
Subject: [ANNOUNCE] ulogd-1.02 released
Date: Wed, 8 Oct 2003 22:38:55 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031008203855.GM25743@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cO2ZlOvi7VNgmdOy"
Cc: netfilter-announce@lists.netfilter.org,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: ulogd@lists.gnumonks.org
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


--cO2ZlOvi7VNgmdOy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

I have released version 1.02 of the iptables userspace logging
daemon (ulogd).  This release just fixes a single (obvious, stupid) bug
introduced in version 1.01

The new Version is available as tar.bz2 only and can be retrieved from:
ftp://ftp.netfilter.org/pub/ulogd/ulogd-1.02.tar.bz2

There is a GPG signature for verification of the authenticity of the=20
archive: ftp://ftp.netfilter.org/pub/ulogd/ulogd-1.02.tar.bz2.sig

Changes (since Version 1.01)
- fix printout of date in ulogd_LOCALTIME.c

Please direct any questions / bug reports to the
ulogd@lists.gnumonks.org mailinglist.

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--cO2ZlOvi7VNgmdOy
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQE/hHXfXaXGVTD0i/8RAp1wAJ9PrgY1ndAjJu1WUNXrTXWK2obPJQCfVN5u
YzqHHnkHlBuDkYqOH+JyHm4=
=8buK
-----END PGP SIGNATURE-----

--cO2ZlOvi7VNgmdOy--
