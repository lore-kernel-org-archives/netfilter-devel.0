From: Eric Leblond <eric@regit.org>
Subject: Re: [Ulog2 PATCH] Exec libmnl config check only if nfacct is enabled
Date: Sun, 12 May 2013 11:58:10 +0200
Message-ID: <1368352690.22387.23.camel@ice-age.regit.org>
References: <1365179294-24481-1-git-send-email-victor@inliniac.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-PqAw+/XBWD2uC7tIFVkw"
Cc: netfilter-devel@vger.kernel.org
To: Victor Julien <victor@inliniac.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:38566 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752216Ab3ELJ6T (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 12 May 2013 05:58:19 -0400
In-Reply-To: <1365179294-24481-1-git-send-email-victor@inliniac.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--=-PqAw+/XBWD2uC7tIFVkw
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable

Hello,

Le vendredi 05 avril 2013 =E0 18:28 +0200, Victor Julien a =E9crit :
> In case nfacct is not enabled in ulogd2, libmnl is not used. So it should=
n't
> be a hard global dependency, but instead only a dependency in case nfacct=
 is
> enabled.
> ---
>  configure.ac |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/configure.ac b/configure.ac
> index c94704b..54a08aa 100644
> --- a/configure.ac
> +++ b/configure.ac
> @@ -49,7 +49,6 @@ AC_SUBST([regular_CFLAGS])
> =20
>  dnl Check for the right nfnetlink version
>  PKG_CHECK_MODULES([LIBNFNETLINK], [libnfnetlink >=3D 1.0.1])
> -PKG_CHECK_MODULES([LIBMNL], [libmnl >=3D 1.0.3])
>  AC_ARG_ENABLE(nflog,
>         AS_HELP_STRING([--enable-nflog], [Enable nflog module [default=3D=
yes]]),,[enable_nflog=3Dyes])
>  AS_IF([test "x$enable_nflog" =3D "xyes"], [
> @@ -67,6 +66,7 @@ AM_CONDITIONAL([BUILD_NFCT], [test "x$enable_nfct" =3D =
"xyes"])
>  AC_ARG_ENABLE(nfacct,
>         AS_HELP_STRING([--enable-nfacct], [Enable nfacct module [default=
=3Dyes]]),,[enable_nfacct=3Dyes])
>  AS_IF([test "x$enable_nfacct" =3D "xyes"], [
> +    PKG_CHECK_MODULES([LIBMNL], [libmnl >=3D 1.0.3])
>      PKG_CHECK_MODULES([LIBNETFILTER_ACCT], [libnetfilter_acct >=3D 1.0.1=
])
>      AC_DEFINE([BUILD_NFACCT], [1], [Building nfacct module])
>  ])

It seems fine to me. Applied to my tree. I will pushed it soon.

PS: sorry for the delay

BR,
--
Eric


--=-PqAw+/XBWD2uC7tIFVkw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iD8DBQBRj2eynxA7CdMWjzIRAi32AJ4lkJTizvwmAYNoLgJqvw/hE8X7xwCfYBCd
QT0JfO1a0H9rPXjeeEHaulI=
=xhKO
-----END PGP SIGNATURE-----

--=-PqAw+/XBWD2uC7tIFVkw--

