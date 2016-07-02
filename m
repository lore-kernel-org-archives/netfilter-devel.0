From: Nick Vinson <nvinson234@gmail.com>
Subject: Re: [PATCH 1/1 rev. 1] nft: configure.ac: Replace magic dblatex dep.
Date: Sat, 2 Jul 2016 11:37:50 -0700
Message-ID: <49591697-d895-7723-a20f-21b9712aed70@gmail.com>
References: <20160702183420.18609-1-nvinson234@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="rHnobeCnbM9HkjAJJdoHGhMj8vQSpw562"
Cc: Nicholas Vinson <nvinson234@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f66.google.com ([209.85.220.66]:36689 "EHLO
	mail-pa0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750746AbcGBSh4 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 2 Jul 2016 14:37:56 -0400
Received: by mail-pa0-f66.google.com with SMTP id lm4so1104759pab.3
        for <netfilter-devel@vger.kernel.org>; Sat, 02 Jul 2016 11:37:56 -0700 (PDT)
In-Reply-To: <20160702183420.18609-1-nvinson234@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--rHnobeCnbM9HkjAJJdoHGhMj8vQSpw562
Content-Type: multipart/mixed; boundary="LgiWT6Ocd8kBe9nfxdONl9C98A9SqfOnU"
From: Nick Vinson <nvinson234@gmail.com>
To: netfilter-devel@vger.kernel.org
Cc: Nicholas Vinson <nvinson234@gmail.com>
Message-ID: <49591697-d895-7723-a20f-21b9712aed70@gmail.com>
Subject: Re: [PATCH 1/1 rev. 1] nft: configure.ac: Replace magic dblatex dep.
References: <20160702183420.18609-1-nvinson234@gmail.com>
In-Reply-To: <20160702183420.18609-1-nvinson234@gmail.com>

--LgiWT6Ocd8kBe9nfxdONl9C98A9SqfOnU
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

The difference between this patch and the original one is that this
patch defaults pdf documentation generation to 'disabled' instead of
'enabled'.

Thanks,
Nicholas Vinson

On 07/02/2016 11:34 AM, Nicholas Vinson wrote:
> Add a configure switch to enable and disable PDF document generation.
> This switch is to replace the current method of automatically detecting=

> dblatex and building the PDF documentation when present.
>=20
> Signed-off-by: Nicholas Vinson <nvinson234@gmail.com>
> ---
>  configure.ac | 19 +++++++++++++------
>  1 file changed, 13 insertions(+), 6 deletions(-)
>=20
> diff --git a/configure.ac b/configure.ac
> index 0e7edcf..877f530 100644
> --- a/configure.ac
> +++ b/configure.ac
> @@ -29,6 +29,12 @@ AC_ARG_ENABLE([debug],
>  AC_SUBST(with_debug)
>  AM_CONDITIONAL([BUILD_DEBUG], [test "x$with_debug" !=3D xno])
> =20
> +AC_ARG_ENABLE([pdf-doc],
> +	      AS_HELP_STRING([--enable-pdf-doc], [Enable PDF documentation]),=

> +	      AS_IF([test "x$enable_pdf_doc" =3D "xno"], [enable_pdf_doc=3Dno=
],
> +	      [enable_pdf_doc=3Dyes]), [enable_pdf_doc=3Dno])
> +AM_CONDITIONAL([BUILD_PDF], [test "x$enable_pdf_doc" =3D=3D "xyes" ])
> +
>  # Checks for programs.
>  AC_PROG_CC
>  AC_PROG_MKDIR_P
> @@ -63,11 +69,11 @@ AS_IF([test "$DOCBOOK2X_MAN" !=3D "no"], [DB2MAN=3D=
"$DOCBOOK2X_MAN"],
>  AC_SUBST(DB2MAN)
>  AM_CONDITIONAL([BUILD_MAN], [test -n "$DB2MAN"])
> =20
> -AC_CHECK_PROG(DBLATEX, [dblatex], [found], [no])
> -AS_IF([test "$DBLATEX" =3D=3D "no"],
> -	[AC_MSG_WARN([dblatex not found, no PDF manpages will be built])]
> -)
> -AM_CONDITIONAL([BUILD_PDF], [test "$DBLATEX" =3D=3D "found"])
> +AM_COND_IF([BUILD_PDF], [
> +	AC_CHECK_PROG(DBLATEX, [dblatex], [found], [no])
> +	AS_IF([test "$DBLATEX" =3D=3D "no"],
> +	      [AC_MSG_ERROR([dblatex not found])])
> +])
> =20
>  # Checks for libraries.
>  PKG_CHECK_MODULES([LIBMNL], [libmnl >=3D 1.0.3])
> @@ -136,4 +142,5 @@ echo "
>  nft configuration:
>    cli support:			${with_cli}
>    enable debugging:		${with_debug}
> -  use mini-gmp:			${with_mini_gmp}"
> +  use mini-gmp:			${with_mini_gmp}
> +  enable pdf documentation:	${enable_pdf_doc}"
>=20


--LgiWT6Ocd8kBe9nfxdONl9C98A9SqfOnU--

--rHnobeCnbM9HkjAJJdoHGhMj8vQSpw562
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJXeAn/AAoJEAQpRPZaa5gq6o8P/3m7HnVwTlH1vpPNPPmmJREK
EaFNlkE/QgdAV6mxUJQk4SE6G6xP6Xq7e/Fqpp+3eN/m1Jypg54anP6dZR2DqJvN
FPElA/sOT9reXqXZVM2k6cuksMLR0Yhr8VPd6ZHqyYxJznRXTiv/A9SOMg2ZEGKR
d/byZ3bQjvBp0UZNbi9QrndfiDT51QfWFPsZa3Dwomj6K8P5wt4geL1F+Tcp1bWt
q9kDozG6MYdkHIPCJp62hGlqiXPNnUiAg+OBN5WnFT6I16t+xNjlgp7xG0A6w3dh
tiVZPmyfce44HtlKnLB1Nb4E6vJuIdBgtT4ST9i8bAXKFQrWhqdLOS37V1S49gAq
PyLrxmFgx4P2+XPpUcAzqbf5JXkfKPj5s/Y1egCszwudTRM1+XKW/EjLJQViCJVf
aAH7FsfQ6GFvB2eTYH4kfx4z9bxwFNCgs1noP43n4mbNk7SesZE1AjGqh0EHC0QA
HVXA/AyctLWmA01jd7eTGjXS3WePtpjAARsRwNq5nAwqf8Unqq7cntC9k2EpKUpC
NIfewSImwajlw9Rg3q/6NtMbprbKFuvmQ3wTyyMQ7zf2Cgham36dCVlYryFL23iP
Sayp94c/TaoNNclK03EH0yU4kP964PlPpnF+UKCEaFdnxlpsio/0lw7m3mwmlbkm
RoH+XVN/Gx4ws+2NHf7D
=gT0v
-----END PGP SIGNATURE-----

--rHnobeCnbM9HkjAJJdoHGhMj8vQSpw562--
