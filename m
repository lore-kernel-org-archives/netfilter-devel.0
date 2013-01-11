From: "Dmitry V. Levin" <ldv@altlinux.org>
Subject: Re: [PATCH] build: resolve link failure for ip6t_NETMAP
Date: Sat, 12 Jan 2013 03:34:30 +0400
Message-ID: <20130111233430.GA18124@altlinux.org>
References: <alpine.LNX.2.01.1301020821230.16620@nerf07.vanv.qr> <1357116471-27433-1-git-send-email-jengelh@inai.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="EeQfGwPcQSOJBaQU"
Cc: vapier@gentoo.org, netfilter-devel@vger.kernel.org,
	pablo@netfilter.org
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from vint.altlinux.org ([194.107.17.35]:36799 "EHLO
	vint.altlinux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754255Ab3AKXmj (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 11 Jan 2013 18:42:39 -0500
Content-Disposition: inline
In-Reply-To: <1357116471-27433-1-git-send-email-jengelh@inai.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--EeQfGwPcQSOJBaQU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Jan 02, 2013 at 09:47:51AM +0100, Jan Engelhardt wrote:
[...]
> --- a/extensions/GNUmakefile.in
> +++ b/extensions/GNUmakefile.in
[...]
> @@ -75,7 +76,7 @@ install: ${targets_install}
>  	if test -n "${targets_install}"; then install -pm0755 $^ "${DESTDIR}${x=
tlibdir}/"; fi;

No, this is a regression.  If ${targets_install} shared objects are made
by libtool, they are intermediate files not expected to be installed by
hand (due to funny RPATHs and so on), so they have to be installed by
libtool --mode=3Dinstall.

Something like
	for f in $^; do ../libtool ${AM_LIBTOOL_SILENT} --tag=3DCC --mode=3Dinstal=
l ${INSTALL} -pm0755 $${f/.so/.la} "${DESTDIR}${xtlibdir}/"; done
would work.

[...]
> @@ -89,19 +90,22 @@ init%.o: init%.c
>  #
>  #	Shared libraries
>  #
> -lib%.so: lib%.oo
> -	${AM_VERBOSE_CCLD} ${CCLD} ${AM_LDFLAGS} -shared ${LDFLAGS} -o $@ $< -L=
../libxtables/.libs -lxtables ${$*_LIBADD};
> +lib%.so: lib%.la
> +	${AM_VERBOSE_NULL} ln -fs .libs/$@ $@
> =20
> -lib%.oo: ${srcdir}/lib%.c
> -	${AM_VERBOSE_CC} ${CC} ${AM_CPPFLAGS} ${AM_DEPFLAGS} ${AM_CFLAGS} -D_IN=
IT=3Dlib$*_init -DPIC -fPIC ${CFLAGS} -o $@ -c $<;
> +lib%.la: lib%.lo
> +	${AM_VERBOSE_CCLD} ../libtool ${AM_LIBTOOL_SILENT} --tag=3DCC --mode=3D=
link ${CCLD} ${AM_LDFLAGS} -module ${LDFLAGS} -o $@ $< ../libxtables/libxta=
bles.la ${$*_LIBADD} -rpath ${xtlibdir}

Please also add -avoid-version along with -module, otherwise it produces
(and --mode=3Dinstall installs) useless symlinks.


--=20
ldv

--EeQfGwPcQSOJBaQU
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAlDwoYYACgkQfKvmrJ41Nh7IzQCglJwJieidCB6kPFraeNx8G0C6
CucAoIUThd3vRRzwXuMOYS5Ni9jTmqs8
=H5Fq
-----END PGP SIGNATURE-----

--EeQfGwPcQSOJBaQU--
