From: Sven Schuster <schuster.sven@gmx.de>
Subject: [resend] Building conntrack
Date: Mon, 8 Aug 2005 13:10:06 +0200
Message-ID: <20050808111006.GA24825@zion.homelinux.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8t9RHnE3ZwKMSgU+"
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


--8t9RHnE3ZwKMSgU+
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


Hi everybody,

I'm resending this message because I didn't get any response to my
first try, and in the meantime I've managed to update my machine
=66rom redhat 9 with many self-built RPMS to stay up to date to a
freshly installed fedora core 4 machine. But I still get the same
errors as described below, but now (because of the fresh install)
I can at least be sure that it's not because of some broken
autoconf- or whatever-packages:

I'm currently trying to build conntrack from todays' svn, and getting
the following errors running autoconf:

# autoconf

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


This is autoconf-2.59-5 from FC4.

Any hints how to get it right?? Am I doing something wrong??

Thanks in advance!


Regards,

Sven

--=20
Linux zion.homelinux.com 2.6.12-1.1398_FC4 #1 Fri Jul 15 00:52:32 EDT 2005 =
i686 athlon i386 GNU/Linux
 13:04:29 up 14:12,  1 user,  load average: 0.03, 0.06, 0.01

--8t9RHnE3ZwKMSgU+
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFC9z2Oo4FAdB2PneQRAsmvAJ95FnRFTcskMwLF+zFzAoqrUMIjkgCdGzpn
KS2kbrxndZAEqyI8LGMJa1A=
=Z+KL
-----END PGP SIGNATURE-----

--8t9RHnE3ZwKMSgU+--
