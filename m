From: Harald Welte <laforge@gnumonks.org>
Subject: ulogd-1.01 released
Date: Sat, 23 Aug 2003 20:14:26 +0200
Sender: netfilter-announce-admin@lists.netfilter.org
Message-ID: <20030823181426.GA5107@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mYCpIKhGyMATD0i+"
Cc: netfilter-announce@lists.netfilter.org,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-announce-admin@lists.netfilter.org>
To: ulogd@lists.gnumonks.org
Content-Disposition: inline
Errors-To: netfilter-announce-admin@lists.netfilter.org
List-Help: <mailto:netfilter-announce-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-announce@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-announce>,
	<mailto:netfilter-announce-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-announce>,
	<mailto:netfilter-announce-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-announce/>
List-Id: netfilter-devel.vger.kernel.org


--mYCpIKhGyMATD0i+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

I have released Version 1.01 of the iptables userspace logging
daemon (ulogd).=20

The new Version is available as tar.bz2 only and can be retrieved from:
ftp://ftp.netfilter.org/pub/ulogd/ulogd-1.01.tar.bz2

There is a GPG signature for verification of the authenticity of the=20
archive: ftp://ftp.netfilter.org/pub/ulogd/ulogd-1.01.tar.bz2.sig

Changes (since Version 1.00)
- use $(LD) macro in order to provide cross-compiling/linking support
- add 'rmem' configuration key to set the netlink socket rmem buffsize
- don't use kernel header files for IP/TCP header definitions
- various cosmetic cleanup to compile with -Wall
- fix usage of libmysqlclient: call mysql_init() before mysql_real_connect()
- don't have LOGEMU read the system time, ulogd_LOCAL.so does this already

Please direct any questions / bug reports to the
ulogd@lists.gnumonks.org mailinglist.

Thanks for all your patience with my not-so-frequend release cycle.

--=20
- Harald Welte <laforge@gnumonks.org>               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
Programming is like sex: One mistake and you have to support it your lifeti=
me

--mYCpIKhGyMATD0i+
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.2 (GNU/Linux)

iD8DBQE/R68CXaXGVTD0i/8RApU4AJ9CIkAy0+XJJl5yj0W7aw6mByPwcACeP/sn
wstqwSaDeTB/rNZPgt671G4=
=PPdN
-----END PGP SIGNATURE-----

--mYCpIKhGyMATD0i+--
