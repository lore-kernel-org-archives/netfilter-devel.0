From: Harald Welte <laforge@netfilter.org>
Subject: [ulogd] [ANNOUNCE] ulogd-1.23 released
Date: Mon, 18 Apr 2005 16:53:44 +0200
Message-ID: <20050418145344.GZ15942@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ksW2gnyJUpgiZE5W"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	netfilter-announce@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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


--ksW2gnyJUpgiZE5W
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

I have released version 1.23 of the iptables userspace logging
daemon (ulogd).  This release is a minor feature enhancement to the
recently-announced 1.22 release.

The new Version is available as tar.bz2 only and can be retrieved from:
ftp://ftp.netfilter.org/pub/ulogd/ulogd-1.23.tar.bz2

There is a GPG signature for verification of the authenticity of the=20
archive: ftp://ftp.netfilter.org/pub/ulogd/ulogd-1.23.tar.bz2.sig

Version 1.23 (2005-04-18)
- Add supprt for ulogd logging in syslog (the daemon log, not packet log)

Please direct any questions / bug reports to the
ulogd@lists.gnumonks.org mailinglist.

btw: Work in ulogd2 for packet- and flow- based logging) is going quite
well, expect news in one to two weeks.

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--ksW2gnyJUpgiZE5W
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.0 (GNU/Linux)

iD8DBQFCY8n4XaXGVTD0i/8RAv+vAJ0fCcbMKoPocbuZyNZqrJgyPPyrxwCcDc1t
X/igA2b7ue0ZCZOiv58a42A=
=IrTG
-----END PGP SIGNATURE-----

--ksW2gnyJUpgiZE5W--
