From: Eric Leblond <eleblond@inl.fr>
Subject: Re: [PATCH] Return true/false instead of ULOGD_IRET_OK/STOP
Date: Wed, 10 Dec 2008 11:57:25 +0100
Message-ID: <1228906645.2872.17.camel@khasse.inl.fr>
References: <1228760826-12886-1-git-send-email-jacob@internet24.de>
	 <1228760826-12886-2-git-send-email-jacob@internet24.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-QtGjkFOGev9me2fqXcN3"
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org
To: Thomas Jacob <jacob@internet24.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 78-210-144-213.altitudetelecom.fr ([213.144.210.78]:35436 "EHLO
	fydelkass.inl.fr" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1750735AbYLJK52 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Dec 2008 05:57:28 -0500
In-Reply-To: <1228760826-12886-2-git-send-email-jacob@internet24.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--=-QtGjkFOGev9me2fqXcN3
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi,

Le lundi 08 d=C3=A9cembre 2008 =C3=A0 19:27 +0100, Thomas Jacob a =C3=A9cri=
t :
> Signed-off-by: Thomas Jacob <jacob@internet24.de>
> ---
>  filter/raw2packet/ulogd_raw2packet_BASE.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)

> -		return ULOGD_IRET_OK;
> +		return 1;


Good catch, applied thanks !

BR,
--=20
=C3=89ric Leblond, eleblond@inl.fr
T=C3=A9l=C3=A9phone : +33 1 55 43 75 22, Fax : +33 9 57 21 48 75
INL, http://www.inl.fr

--=-QtGjkFOGev9me2fqXcN3
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: Ceci est une partie de message
	=?ISO-8859-1?Q?num=E9riquement?= =?ISO-8859-1?Q?_sign=E9e?=

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkk/oJIACgkQnxA7CdMWjzLLZACZAVSINZNi7KlBEkS8lPOAH5KZ
5bkAn1Sso23oauBoAN0fZtqogxa2RJAf
=BTos
-----END PGP SIGNATURE-----

--=-QtGjkFOGev9me2fqXcN3--

