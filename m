From: Harald Welte <laforge@netfilter.org>
Subject: [ulogd] [ANNOUNCE] ulogd-1.22 released
Date: Mon, 7 Mar 2005 14:42:11 +0100
Message-ID: <20050307134210.GG30487@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BrzieSmlpF6NDzIw"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	netfilter-announce@lists.netfilter.org
To: ulogd@lists.gnumonks.org
Content-Disposition: inline
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


--BrzieSmlpF6NDzIw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

I have released version 1.22 of the iptables userspace logging
daemon (ulogd).  This release is a bugfix to the recently-announced 1.21
release (which had broken posgresql support).

The new Version is available as tar.bz2 only and can be retrieved from:
ftp://ftp.netfilter.org/pub/ulogd/ulogd-1.22.tar.bz2

There is a GPG signature for verification of the authenticity of the=20
archive: ftp://ftp.netfilter.org/pub/ulogd/ulogd-1.22.tar.bz2.sig

Version 1.22 (2005-03-07)
- Fix postgresql endless loop (Jani Averbach)
- Add postgrsql schema support (Bob Hockney)

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

--BrzieSmlpF6NDzIw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)

iD8DBQFCLFoyXaXGVTD0i/8RAnEEAKCO4Sa1wRIGvVBPPAVOPGZ9Wfl5bgCeJx7K
+JDqdIRjzRlIIQ4TDZrY7C8=
=NfGZ
-----END PGP SIGNATURE-----

--BrzieSmlpF6NDzIw--
