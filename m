From: Sven Schuster <schuster.sven@gmx.de>
Subject: Building conntrack
Date: Mon, 18 Jul 2005 20:09:14 +0200
Message-ID: <20050718180914.GA5666@zion.homelinux.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bp/iNruPH9dso1Pn"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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


--bp/iNruPH9dso1Pn
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


Hi everybody,

I'm currently trying to build conntrack from todays' svn, and getting
the following errors running autoconf:

# autoconf
configure.in:5: error: possibly undefined macro: AM_INIT_AUTOMAKE
      If this token and others are legitimate, please use m4_pattern_allow.
      See the Autoconf documentation.
configure.in:6: error: possibly undefined macro: AM_CONFIG_HEADER
configure.in:9: error: possibly undefined macro: AM_PROG_LIBTOOL

when I call autoconf a second time, it works without any error, but
when I then run configure, I get this errors:

# ./configure
checking build system type... i686-pc-linux-gnu
checking host system type... i686-pc-linux-gnu
checking target system type... i686-pc-linux-gnu
=2E/configure: line 1365: syntax error near unexpected token `conntrack,'
=2E/configure: line 1365: `AM_INIT_AUTOMAKE(conntrack, 0.63)'

Here's the version of autoconf I'm using:

# autoconf --version
autoconf (GNU Autoconf) 2.59
Written by David J. MacKenzie and Akim Demaille.

Copyright (C) 2003 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

I also tried using autoconf 2.13 on my machine, here I also get an
error:

# autoconf-2.13
autoconf: Undefined macros:
configure.in:73:               AC_HELP_STRING([--with-kernel=3DDIR],
# autoconf-2.13 --version
Autoconf version 2.13

Any hints how to get it right?? Am I doing something wrong??

Thanks in advance!


Regards,

Sven

--=20
Linux zion 2.6.13-rc3-mm1 #6 PREEMPT Mon Jul 18 19:42:52 CEST 2005 i686 ath=
lon i386 GNU/Linux
 20:03:42 up 16 min,  1 user,  load average: 0.02, 0.06, 0.08

--bp/iNruPH9dso1Pn
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQFC2/BJo4FAdB2PneQRAs2DAJ9JSneHHKmamQntfePwUrU9UMMLcwCfe1hs
3S2qFVOSfqZX6Bj7R/z0QoM=
=QxJk
-----END PGP SIGNATURE-----

--bp/iNruPH9dso1Pn--
