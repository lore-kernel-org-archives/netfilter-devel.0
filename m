From: Eric Leblond <eric@inl.fr>
Subject: Re: [libnetfilter_log patch] Fix minor memory leak.
Date: Mon, 15 Dec 2008 17:15:46 +0100
Message-ID: <1229357746.3810.16.camel@khasse.inl.fr>
References: <1228055643-21565-1-git-send-email-eric@inl.fr>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-2k48I4mi3cYFlYJKXN7g"
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 78-210-144-213.altitudetelecom.fr ([213.144.210.78]:39599 "EHLO
	fydelkass.inl.fr" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752946AbYLOQPs (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 15 Dec 2008 11:15:48 -0500
In-Reply-To: <1228055643-21565-1-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--=-2k48I4mi3cYFlYJKXN7g
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi,

This patch has been applied to libnetfilter_log git tree.

Le dimanche 30 novembre 2008 =C3=A0 15:34 +0100, Eric Leblond a =C3=A9crit =
:
> The nflog_handle is allocated in nflog_open(). This patch adds the missin=
g
> free in nflog_close().
>=20
> Signed-off-by: Eric Leblond <eric@inl.fr>
> ---
>  src/libnetfilter_log.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
>=20
> diff --git a/src/libnetfilter_log.c b/src/libnetfilter_log.c
> index 6c0936e..216cdb8 100644
> --- a/src/libnetfilter_log.c
> +++ b/src/libnetfilter_log.c
> @@ -237,7 +237,9 @@ int nflog_handle_packet(struct nflog_handle *h, char =
*buf, int len)
> =20
>  int nflog_close(struct nflog_handle *h)
>  {
> -	return nfnl_close(h->nfnlh);
> +	int ret =3D nfnl_close(h->nfnlh);
> +	free(h);
> +	return ret;
>  }
> =20
>  /* bind nf_queue from a specific protocol family */

BR,
--=20
=C3=89ric Leblond <eric@inl.fr>
INL, http://www.inl.fr/
NuFW, http://www.nufw.org

--=-2k48I4mi3cYFlYJKXN7g
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: Ceci est une partie de message
	=?ISO-8859-1?Q?num=E9riquement?= =?ISO-8859-1?Q?_sign=E9e?=

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAklGgq8ACgkQnxA7CdMWjzLzrQCfXlAnVN+jKaAqk6Hdt/9PH83y
CxsAnjWns1uOh4l4zJPAgUbZd4ia+ww5
=xrR5
-----END PGP SIGNATURE-----

--=-2k48I4mi3cYFlYJKXN7g--

