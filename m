Received: from azazel.net (taras.nevrast.org [35.176.194.208])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F1AB1F8EEC
	for <netfilter-devel@vger.kernel.org>; Mon, 21 Oct 2024 19:29:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.176.194.208
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729538976; cv=none; b=jyFQBfxDfajfcTmGI0JEQql/VKhVsO8/TqEEVScxDlc7PbxopYsa+QhJKGOdx6W1mizYdKmzdURl83qB0PVXZWRElEohngwdWwe6ZrMA3ZVbefZVuT8q2ICQZtHwzzJEY2N2SycS56JXhi/wk/b6Eq4vhqECK8cV0zlhGXMhNuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729538976; c=relaxed/simple;
	bh=fw0uAG0Y5/R1KngxNhlxN9D23soerl1mKSSMtG8+VgY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZHnqwxDa2pXVKjiJI0tpmCmKfBGJ7yGPLk68sUcPTJySOQX30BqTeOg8JZqZ4NezBEnOoVS536jSPvA4UI3Sj9wHVktOPH917dcx9lV6TUsbKgHx/bdSfdekzSAvYF6wrnV7VD2mWkKoQ5yymjG2Lgj87trTDs9u4MhJrXWKXgo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=azazel.net; spf=pass smtp.mailfrom=azazel.net; dkim=pass (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b=AWML1nfC; arc=none smtp.client-ip=35.176.194.208
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=azazel.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=azazel.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="AWML1nfC"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
	s=20220717; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=KNMtlhFKEhZb48P1MP4lq5TJjGbT5wYDkq/U2RkR7r4=; b=AWML1nfC7dGpyyr68ZH1zKlP16
	BPQv2j/ufLbyXclOP9/0zcNh3AHwFmC0styLzLPG15zbYmrfW0Evfqxpwx+RlwY2iXXwKQjVVXNAC
	TO0bwCYYZdQVc5b4YojaBXoaHd67rrnVj+6KrB6QheMrjZcDS4uzP0IYwtCcb9TPImv/MfXUnwjH0
	B4+6fxd677SSpHH/jeu9avcZjqbSia4vmZ4R/b7SdhjT5p4bNLtK9II+R6uvoGVTsL0st03FJrOsl
	a5UMruLH6TtNYv8bwn6HVwLzSmqPHXRiC0zwUzi0j/YFQc9zTvw/Mhrqh9YGQ7J7zVJvz5IToLH6X
	sbd4Z0Gg==;
Received: from celephais.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:3c21:9cff:fe2f:35f] helo=celephais.dreamlands)
	by taras.nevrast.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <jeremy@azazel.net>)
	id 1t2xnb-002f99-1i;
	Mon, 21 Oct 2024 20:10:39 +0100
Date: Mon, 21 Oct 2024 20:10:38 +0100
From: Jeremy Sowden <jeremy@azazel.net>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH conntrack,v2 1/2] conntrack: improve
 --secmark,--id,--zone parser
Message-ID: <20241021191038.GA1028786@celephais.dreamlands>
References: <20241012220030.51402-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="la+/81FvE8cgTN+I"
Content-Disposition: inline
In-Reply-To: <20241012220030.51402-1-pablo@netfilter.org>
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:3c21:9cff:fe2f:35f
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on taras.nevrast.org); SAEximRunCond expanded to false


--la+/81FvE8cgTN+I
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2024-10-13, at 00:00:29 +0200, Pablo Neira Ayuso wrote:
> strtoul() is called with no error checking at all, add a helper
> function to validate input is correct for values less than
> UINT32_MAX.
>=20
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
> v2: - remove value =3D=3D 0 && errno =3D=3D ERANGE check
>     - add assert to remember this only supports max up to UINT32_MAX

LGTM.

J.

>  src/conntrack.c | 35 +++++++++++++++++++++++++++++------
>  1 file changed, 29 insertions(+), 6 deletions(-)
>=20
> diff --git a/src/conntrack.c b/src/conntrack.c
> index 9fa49869b553..18829dbf79bc 100644
> --- a/src/conntrack.c
> +++ b/src/conntrack.c
> @@ -1213,6 +1213,26 @@ parse_parameter_mask(const char *arg, unsigned int=
 *status, unsigned int *mask,
>  		exit_error(PARAMETER_PROBLEM, "Bad parameter `%s'", arg);
>  }
> =20
> +static int parse_value(const char *str, uint32_t *ret, uint64_t max)
> +{
> +	char *endptr;
> +	uint64_t val;
> +
> +	assert(max <=3D UINT32_MAX);
> +
> +	errno =3D 0;
> +	val =3D strtoul(str, &endptr, 0);
> +	if (endptr =3D=3D str ||
> +	    *endptr !=3D '\0' ||
> +	    (val =3D=3D ULONG_MAX && errno =3D=3D ERANGE) ||
> +	    val > max)
> +		return -1;
> +
> +	*ret =3D val;
> +
> +	return 0;
> +}
> +
>  static void
>  parse_u32_mask(const char *arg, struct u32_mask *m)
>  {
> @@ -2918,6 +2938,7 @@ static void do_parse(struct ct_cmd *ct_cmd, int arg=
c, char *argv[])
>  	struct ct_tmpl *tmpl;
>  	int res =3D 0, partial;
>  	union ct_address ad;
> +	uint32_t value;
>  	int c, cmd;
> =20
>  	/* we release these objects in the exit_error() path. */
> @@ -3078,17 +3099,19 @@ static void do_parse(struct ct_cmd *ct_cmd, int a=
rgc, char *argv[])
>  		case 'w':
>  		case '(':
>  		case ')':
> +			if (parse_value(optarg, &value, UINT16_MAX) < 0)
> +				exit_error(OTHER_PROBLEM, "unexpected value '%s' with -%c option", o=
ptarg, c);
> +
>  			options |=3D opt2type[c];
> -			nfct_set_attr_u16(tmpl->ct,
> -					  opt2attr[c],
> -					  strtoul(optarg, NULL, 0));
> +			nfct_set_attr_u16(tmpl->ct, opt2attr[c], value);
>  			break;
>  		case 'i':
>  		case 'c':
> +			if (parse_value(optarg, &value, UINT32_MAX) < 0)
> +				exit_error(OTHER_PROBLEM, "unexpected value '%s' with -%c option", o=
ptarg, c);
> +
>  			options |=3D opt2type[c];
> -			nfct_set_attr_u32(tmpl->ct,
> -					  opt2attr[c],
> -					  strtoul(optarg, NULL, 0));
> +			nfct_set_attr_u32(tmpl->ct, opt2attr[c], value);
>  			break;
>  		case 'm':
>  			options |=3D opt2type[c];
> --=20
> 2.30.2
>=20

--la+/81FvE8cgTN+I
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEbB20U2PvQDe9VtUXKYasCr3xBA0FAmcWpw0ACgkQKYasCr3x
BA0EKxAAlm0Ngk+9FWHL8VUHapxYg9N5+KM9Yb1PpEYF9kMIENh7c5TSK1v0H90S
AmYl/SaJW8uPZrZe+zWbVxCZBfRj1iNQh1tCI9tn4kXcdPVbOn01mbDClASDMDSW
O12uIAafq7ArszwfMz7nhTdV4QNGULhUhl9iYM7uIrwSvE13ZpBPGmgh4TpV7J4P
UBPTcLfJU0ttSh1GzT/+4EoVZC+hq4Iz7DZOuqJmsOOamQEFTNk8eKpOIeC0Qll8
plz8iGFvFGC7UUojF/7vhGBefuSgedEv55gCVoVcgy/ViEa8Zb+QRZU95xvaP3nt
lBgVDI44LpNc+WAPh8J+dnaWCfXGiZ5liUOHo7DVlZSRcBE9OJ9c+VeENPOj1fCD
MHJ0ThWo1/HGwD0a5droj0ner/O0pnGtY4p7WHdIWDQFMNb6eLxmQKWH7wH1/L5a
uzBlH4/efEivXWPoyob0VjJKdabWOBBIngEpx5zyGcDBJJNYdgthfy9PhpldzHBv
eVzF3JGwwzcbm35biHlWTKrdXNpgl7e+MTchXQgTJiKjhb4oXccHfZXukJyAbIcr
1yYD3sU5Hc0aNeOzn7sxicetRk5/N9JCVnvPY6oL6G+CbVGgxCfpqjsaNeY5Q8Tj
iX25DHwZjb2zFWFpS7MX5CaVozC1ol1PXTKfHW4XtFk42+04Mm4=
=up6U
-----END PGP SIGNATURE-----

--la+/81FvE8cgTN+I--
