From: Jonas Berlin <xkr47@outerspace.dyndns.org>
Subject: xtables-addons suggestions
Date: Tue, 16 Feb 2010 21:32:34 +0200
Message-ID: <20100216213234.330a6ff4@outerspace>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/T4FsPHd8aA83o8U2wRbWNXN";
 protocol="application/pgp-signature"; micalg=PGP-SHA1
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from slashbox.net ([82.118.210.13]:55332 "EHLO slashbox.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933254Ab0BPUAP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 16 Feb 2010 15:00:15 -0500
Received: from slashbox.net (localhost [127.0.0.1])
	by slashbox.net (Postfix) with ESMTP id AD9F11C0DB
	for <netfilter-devel@vger.kernel.org>; Tue, 16 Feb 2010 21:32:43 +0200 (EET)
Received: from outerspace (a88-114-29-229.elisa-laajakaista.fi [88.114.29.229])
	by slashbox.net (Postfix) with ESMTP id 745061C0B8
	for <netfilter-devel@vger.kernel.org>; Tue, 16 Feb 2010 21:32:43 +0200 (EET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

--Sig_/T4FsPHd8aA83o8U2wRbWNXN
Content-Type: multipart/mixed; boundary="MP_/.brf15Cqe7Jj2.Gh0GTSs58"

--MP_/.brf15Cqe7Jj2.Gh0GTSs58
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi, I am using xtables-addons-1.22 and needed to do some changes to get it =
to compile in my setup. I thus present a few suggestions below:

1. When using --with-xtables, I got problems at linking time, failing to fi=
nd libxtables.. By changing configure.ac like below I was able to solve the=
 issue.

  libxtables_LIBS=3D"-lxtables";
   to
  libxtables_LIBS=3D"-lxtables -L $xtables_location/lib";

Currently only the include search paths are affected by the --with-xtables =
argument. It seems there could have been an option to instruct pkg-config t=
o look for the xtables.pc file in the non-standard location, but I noticed =
that too late.

2. When using --with-kbuild, I got some strange compile errors which ended =
up being because it used header files from /usr/include/linux instead of fr=
om the path given to --with-kbuild. In fact, I was unable to find anything =
that would use the --with-kbuild argument. It ended up in the Makefiles as =
variables, but nobody used them. By changing Makefile.iptrules.in like belo=
w I was able to solve the issue.

  AM_CFLAGS         =3D ${regular_CFLAGS} ${libxtables_CFLAGS}
   to
  kinclude_CFLAGS   =3D @kinclude_CFLAGS@
  AM_CFLAGS         =3D ${regular_CFLAGS} ${libxtables_CFLAGS} ${kinclude_C=
FLAGS}

My suggestions as separate patches attached.

Thanks for a great product!

--=20
- xkr47

--MP_/.brf15Cqe7Jj2.Gh0GTSs58
Content-Type: text/x-patch
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment; filename=kbuild-to-searchpath.patch

diff -u xtables-addons-1.22-orig/configure.ac xtables-addons-1.22/configure=
.ac
--- xtables-addons-1.22-orig/configure.ac	2010-01-22 21:14:37.000000000 +02=
00
+++ xtables-addons-1.22/configure.ac	2010-02-16 20:37:54.000000000 +0200
@@ -51,7 +51,7 @@
 			AC_MSG_RESULT([no])
 		fi;
 	fi;
-	libxtables_LIBS=3D"-lxtables";
+	libxtables_LIBS=3D"-lxtables -L $xtables_location/lib";
 	AC_SUBST([libxtables_CFLAGS])
 	AC_SUBST([libxtables_LIBS])
 else

--MP_/.brf15Cqe7Jj2.Gh0GTSs58
Content-Type: text/x-patch
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment; filename=libxtables-to-searchpath.patch

diff -u xtables-addons-1.22-orig/Makefile.iptrules.in xtables-addons-1.22/M=
akefile.iptrules.in
--- xtables-addons-1.22-orig/Makefile.iptrules.in	2010-01-22 21:14:37.00000=
0000 +0200
+++ xtables-addons-1.22/Makefile.iptrules.in	2010-02-16 20:38:57.000000000 =
+0200
@@ -12,7 +12,8 @@
 regular_CFLAGS  =3D @regular_CFLAGS@
 libxtables_CFLAGS =3D @libxtables_CFLAGS@
 libxtables_LIBS   =3D @libxtables_LIBS@
-AM_CFLAGS         =3D ${regular_CFLAGS} ${libxtables_CFLAGS}
+kinclude_CFLAGS   =3D @kinclude_CFLAGS@
+AM_CFLAGS         =3D ${regular_CFLAGS} ${libxtables_CFLAGS} ${kinclude_CF=
LAGS}
 AM_DEPFLAGS     =3D -Wp,-MMD,$(@D)/.$(@F).d,-MT,$@
=20
 AM_DEFAULT_VERBOSITY =3D 0

--MP_/.brf15Cqe7Jj2.Gh0GTSs58--

--Sig_/T4FsPHd8aA83o8U2wRbWNXN
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.10 (GNU/Linux)

iEYEARECAAYFAkt68toACgkQxyF48ZTvn+64OQCggWNUkWobRXGtepLtfKGoXdAe
iF0An1yE3ud2pMZNALoEZ2HHe7ATMKTK
=v7Mf
-----END PGP SIGNATURE-----

--Sig_/T4FsPHd8aA83o8U2wRbWNXN--
