From: Eric Leblond <eric@inl.fr>
Subject: Re: [PATCH 3/4] Add new output plugin DBI
Date: Wed, 10 Dec 2008 12:04:04 +0100
Message-ID: <1228907044.2872.26.camel@khasse.inl.fr>
References: <1228135316-12578-1-git-send-email-chifflier@inl.fr>
	 <1228135316-12578-4-git-send-email-chifflier@inl.fr>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-OBQM1hN5EpHmJXvETyB1"
Cc: netfilter-devel@vger.kernel.org
To: Pierre Chifflier <chifflier@inl.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 78-210-144-213.altitudetelecom.fr ([213.144.210.78]:41955 "EHLO
	fydelkass.inl.fr" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1750809AbYLJLEH (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Dec 2008 06:04:07 -0500
In-Reply-To: <1228135316-12578-4-git-send-email-chifflier@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--=-OBQM1hN5EpHmJXvETyB1
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi,

Le lundi 01 d=C3=A9cembre 2008 =C3=A0 13:41 +0100, Pierre Chifflier a =C3=
=A9crit :
> libdbi implements a database-independent abstraction layer in C, similar =
to
> the DBI/DBD layer in Perl.
> This module brings support for all database types supported by libdbi.
>=20
> Signed-off-by: Pierre Chifflier <chifflier@inl.fr>
> ---
>  configure.in                  |    1 +
>  output/Makefile.am            |    2 +-
>  output/dbi/Makefile.am        |   12 ++
>  output/dbi/ulogd_output_DBI.c |  313 +++++++++++++++++++++++++++++++++++=
++++++
>  ulogd.conf.in                 |   10 ++
>  5 files changed, 337 insertions(+), 1 deletions(-)
>  create mode 100644 output/dbi/Makefile.am
>  create mode 100644 output/dbi/ulogd_output_DBI.c

> +		const char *errptr;
> +		dbi_conn_error(pi->dbh, &errptr);
> +		ulogd_log(ULOGD_DEBUG, "execute failed (%s)\n",
> +			  errptr);

Hmm, this is more an error message than a debug one.

> +		ulogd_log(ULOGD_DEBUG, "failed query: [%s]\n",
> +			  stmt);

Applied with the above modifications, thanks.

BR,
--=20
=C3=89ric Leblond <eric@inl.fr>
INL, http://www.inl.fr/
NuFW, http://www.nufw.org

--=-OBQM1hN5EpHmJXvETyB1
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: Ceci est une partie de message
	=?ISO-8859-1?Q?num=E9riquement?= =?ISO-8859-1?Q?_sign=E9e?=

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkk/oiEACgkQnxA7CdMWjzLPyQCbB6c+cP3xOcOdTY9Q2BqZaXEY
EFkAniWZENQmX72R3BVqjuRnTgELHFMr
=ZE/C
-----END PGP SIGNATURE-----

--=-OBQM1hN5EpHmJXvETyB1--

