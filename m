From: "Dmitry V. Levin" <ldv@altlinux.org>
Subject: Re: [PATCH] build: resolve link failure for ip6t_NETMAP
Date: Sat, 12 Jan 2013 04:00:54 +0400
Message-ID: <20130112000054.GA20139@altlinux.org>
References: <alpine.LNX.2.01.1301020821230.16620@nerf07.vanv.qr> <1357116471-27433-1-git-send-email-jengelh@inai.de> <20130111233430.GA18124@altlinux.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="AhhlLboLdkugWU4S"
Cc: vapier@gentoo.org, netfilter-devel@vger.kernel.org,
	pablo@netfilter.org
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from vint.altlinux.org ([194.107.17.35]:37880 "EHLO
	vint.altlinux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754843Ab3ALAAz (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 11 Jan 2013 19:00:55 -0500
Content-Disposition: inline
In-Reply-To: <20130111233430.GA18124@altlinux.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--AhhlLboLdkugWU4S
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Jan 12, 2013 at 03:34:30AM +0400, Dmitry V. Levin wrote:
> Hi,
>=20
> On Wed, Jan 02, 2013 at 09:47:51AM +0100, Jan Engelhardt wrote:
> [...]
> > --- a/extensions/GNUmakefile.in
> > +++ b/extensions/GNUmakefile.in
> [...]
> > @@ -75,7 +76,7 @@ install: ${targets_install}
> >  	if test -n "${targets_install}"; then install -pm0755 $^ "${DESTDIR}$=
{xtlibdir}/"; fi;
>=20
> No, this is a regression.  If ${targets_install} shared objects are made
> by libtool, they are intermediate files not expected to be installed by
> hand (due to funny RPATHs and so on), so they have to be installed by
> libtool --mode=3Dinstall.
>=20
> Something like
> 	for f in $^; do ../libtool ${AM_LIBTOOL_SILENT} --tag=3DCC --mode=3Dinst=
all ${INSTALL} -pm0755 $${f/.so/.la} "${DESTDIR}${xtlibdir}/"; done
> would work.

No, it didn't work because of ${pfx_symlinks} modules which are not
libtool files.  I've managed to build it with a more complex yet reliable
rule:

	for f in $^; do la=3D"$${f/.so/.la}"; if test -f "$$la"; then ../libtool $=
{AM_LIBTOOL_SILENT} --tag=3DCC --mode=3Dinstall ${INSTALL} -pm0755 "$$la" "=
${DESTDIR}${xtlibdir}/"; elif test -L "$$f"; then cp -a "$$f" "${DESTDIR}${=
xtlibdir}/"; else exit 1; fi || exit; done


--=20
ldv

--AhhlLboLdkugWU4S
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAlDwp7YACgkQfKvmrJ41Nh5HBgCZAbiXx0hCghrYi77WlOXFackb
vQMAoI2A//VKWrxu9Mm5pKGcqh7GcuQv
=ei9Z
-----END PGP SIGNATURE-----

--AhhlLboLdkugWU4S--
