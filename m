From: Harald Welte <laforge@netfilter.org>
Subject: [ANNOUNCE] ulogd-1.21 released
Date: Wed, 16 Feb 2005 13:56:34 +0100
Message-ID: <20050216125634.GT3829@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OY4z34RctfP64Hws"
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


--OY4z34RctfP64Hws
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

I have released version 1.21 of the iptables userspace logging
daemon (ulogd).  This release is a minur bugfix update to the 'brown
paper bag' release 1.20. 1.20 was probably one of the last 'new feature'
updates for ulogd, since I'm already working on ulogd2, which includes
support for plugin stacks, IPFIX and ct_acct.

The new Version is available as tar.bz2 only and can be retrieved from:
ftp://ftp.netfilter.org/pub/ulogd/ulogd-1.21.tar.bz2

There is a GPG signature for verification of the authenticity of the=20
archive: ftp://ftp.netfilter.org/pub/ulogd/ulogd-1.21.tar.bz2.sig

Changes (since Version 1.02)
- Add SYSLOG output plugin for real syslogging (Harald Welte)
- Add SQLITE3 Output Plugin (Ben La Monica)
- Change format of configuration file.  Now every plugin has it's own
  section in the config file, making the whole parsing procedure easier
  and eliminating multiple loading of .so plugins. (Magnus Boden)
- Make the config file format completely syntax compatible with
  .ini style files
- Add tcp 'port' option to mysql and postgresql plugins (Sven Schuster)
- Cosmetic changes (c99 initializers, coding style)
- Add support for seteuid() after startup (Nicolas Pougetoux)
- Fix multiple buffer overflows in the postgresql plugin (Harald Welte)

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

--OY4z34RctfP64Hws
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)

iD8DBQFCE0MCXaXGVTD0i/8RAg6mAJ9yoO9yjG08GNKB/19uT/est2wWMACgjtnU
ze2V1jevoQe/2xXottKnIv0=
=aIeY
-----END PGP SIGNATURE-----

--OY4z34RctfP64Hws--
