From: Harald Welte <laforge@gnumonks.org>
Subject: ulogd-1.00 released
Date: Thu, 6 Mar 2003 01:51:45 +0100
Sender: netfilter-announce-admin@lists.netfilter.org
Message-ID: <20030306005145.GK4880@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+HwY7O+GdaLKMYOv"
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


--+HwY7O+GdaLKMYOv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

I have finally released Version 1.00 of the iptables userspace logging
daemon (ulogd).=20

After being around for almost three years, and receiving lots of positive
reports, I have decided to make this new release the 1.00 release,
the first official stable release.

The new Version is available as tar.bz2 only and can be retrieved from:
ftp://ftp.netfilter.org/pub/ulogd/ulogd-1.00.tar.bz2

There is a GPG signature for verification of the authenticity of the=20
archive: ftp://ftp.netfilter.org/pub/ulogd/ulogd-1.00.tar.bz2.sig

ChangeLog (from 0.98):
- update documentation to reflect recent additions
- renamed LOCALTIME plugin to LOCAL plugin, since it now also returns
  the hostname
- cleanup #include statements
- tcp.window is a 16bit value
- always return tcp flags, even if they are not set [to not cause NULL entr=
ies
  in the database table
- cosmetic fixes to acommodate most compiler warnings
- moved location of conffile.h and ulog.h
- big update to ulogd_PGSQL.c
- more verbose error reporting when unable to load plugin
- print usage information
- add '--configfile' directive to allow multiple instances with multiple
  configfiles

Thanks for all your patience with my not-so-frequend release cycle.

--=20
- Harald Welte <laforge@gnumonks.org>               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
Programming is like sex: One mistake and you have to support it your lifeti=
me

--+HwY7O+GdaLKMYOv
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+ZpuhXaXGVTD0i/8RAj+vAJ9rW4+VSg9PMecYmTLqkALoQfYquQCfZpB3
WCMqXWWVRl4VvrKRMbwF5rU=
=59C1
-----END PGP SIGNATURE-----

--+HwY7O+GdaLKMYOv--
