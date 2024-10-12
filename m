Received: from azazel.net (taras.nevrast.org [35.176.194.208])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1CE52F870
	for <netfilter-devel@vger.kernel.org>; Sat, 12 Oct 2024 20:29:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.176.194.208
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728764980; cv=none; b=cgBwrVu4czOU5gh7T0n2QW7jtQ29MxNBd84JcyDi8TFkpqIwZWNGil1csw8WDUcjyvuAXnjFMFTv3MJr2WoGTOZslTp5QhwvecwafQUORcv/2v4a9DppjHoL4s8IDwnligUr3hqKhh4lgmyFvY6aRlEHtty4DOW7cJoAYEiIv7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728764980; c=relaxed/simple;
	bh=pZEPUuWQk1a7p8PhUa3cXPrH38ZVUuGlSh/7TxZoZe0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=A4BYKuA9OvjG8edbWJR3CSBCDyVKww9ismh9L1GNOSQjMDXB/QOGwQpJAtuDnxRI4oTqsqwpSG7vH+cGMhUrBZq28PVYOXB2V2ozhVwVYUOzEXBm2FFnXU+bS+ttohDj9mXQCnavmaymH6HPE9oy6YsnkLbWvDIk9EaE13woFgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=azazel.net; spf=pass smtp.mailfrom=azazel.net; dkim=pass (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b=r44FijEz; arc=none smtp.client-ip=35.176.194.208
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=azazel.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=azazel.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="r44FijEz"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
	s=20220717; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=jMpOeTdFyYPeumMweR8z12As/JYU4nWwSQR+zUtBiAA=; b=r44FijEz1hU/HB0vm3k85MheVy
	8X8vCc5XgAQLGRwG7SDenWU7nOkYoX/vFpIughvWQT2iIgk5kIVjYr869liJ+UjC/SH+9JRlv4qH+
	MORh3Q8fO+YaEANSAwozxaNWuC4zLG/O17mUdL2VZEeFVKCDebDAIYC2Jq99jW++lOM1N2A8qxrhC
	qJC6PBSxO37d1UieK/dwfQwXAHHjyNFL41ZfBlhEG2kRColrb1NRQzWtIPlZf4xEly2WxS6S8Xswk
	lZVCl4JjjKzOqmaxUF7SIwn/Svid/Xb+nS0HNszyCGC6W/I133KzNzsGzhMFk+tUCcdXTKMIe6UZo
	Qcm4CUbQ==;
Received: from celephais.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:3c21:9cff:fe2f:35f] helo=celephais.dreamlands)
	by taras.nevrast.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <jeremy@azazel.net>)
	id 1sziEk-009gfG-0O;
	Sat, 12 Oct 2024 20:57:14 +0100
Date: Sat, 12 Oct 2024 20:57:12 +0100
From: Jeremy Sowden <jeremy@azazel.net>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH conntrack 1/3] conntrack: improve --secmark,--id,--zone
 parser
Message-ID: <20241012195712.GB418319@celephais.dreamlands>
References: <20241012152957.30724-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="wldrZgTRBYozzq7v"
Content-Disposition: inline
In-Reply-To: <20241012152957.30724-1-pablo@netfilter.org>
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:3c21:9cff:fe2f:35f
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on taras.nevrast.org); SAEximRunCond expanded to false


--wldrZgTRBYozzq7v
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2024-10-12, at 17:29:55 +0200, Pablo Neira Ayuso wrote:
> strtoul() is called with no error checking at all, add a helper
> function to validate input is correct.
>=20
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
>  src/conntrack.c | 34 ++++++++++++++++++++++++++++------
>  1 file changed, 28 insertions(+), 6 deletions(-)
>=20
> diff --git a/src/conntrack.c b/src/conntrack.c
> index 9fa49869b553..f3725eefd5de 100644
> --- a/src/conntrack.c
> +++ b/src/conntrack.c
> @@ -1213,6 +1213,25 @@ parse_parameter_mask(const char *arg, unsigned int=
 *status, unsigned int *mask,
>  		exit_error(PARAMETER_PROBLEM, "Bad parameter `%s'", arg);
>  }
> =20
> +static int parse_value(const char *str, uint32_t *ret, uint64_t max)
> +{
> +	char *endptr;
> +	uint64_t val;
> +
> +	errno =3D 0;
> +	val =3D strtoul(str, &endptr, 0);
> +	if (endptr =3D=3D str ||
> +	    *endptr !=3D '\0' ||
> +	    (val =3D=3D ULONG_MAX && errno =3D=3D ERANGE) ||
> +	    (val =3D=3D 0 && errno =3D=3D ERANGE) ||
            ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

TTBOMK, this won't happen.

> +	    val > max)

Given that `*ret` is a `uint32_t`, would it make sense also to check
that `max <=3D UINT32_MAX`?

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
> @@ -2918,6 +2937,7 @@ static void do_parse(struct ct_cmd *ct_cmd, int arg=
c, char *argv[])
>  	struct ct_tmpl *tmpl;
>  	int res =3D 0, partial;
>  	union ct_address ad;
> +	uint32_t value;
>  	int c, cmd;
> =20
>  	/* we release these objects in the exit_error() path. */
> @@ -3078,17 +3098,19 @@ static void do_parse(struct ct_cmd *ct_cmd, int a=
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
>=20

--wldrZgTRBYozzq7v
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEbB20U2PvQDe9VtUXKYasCr3xBA0FAmcK1JIACgkQKYasCr3x
BA0u5RAAkabmMx6xx2GLnSwN1lW6pmD1R8kzTitwsmg6Y4ovwN7GWqPwc1kNbS/Q
Oti7F3t1K+CTwX9ZBvNjW4coY/ULlfqopOuE+AXwRKQd+qWBQRSHBBgPLlOKAS6e
Fq/cABfvQhPnIPca2GJZhKYH+UJeKr7Hne1lwgjptl0mfoHp8cP41593UrjzA7ew
gKIU7RFGKfXKLw5wbB0bLJEKErhdVg7A2z6JZki3h1oaQWNEz2YyEjWGxNaIhqql
vcYWijz47HYsbNPn33AMD9Nf1g2kTsdi4VEn3379Uxi7k8fO9guZNo55NuSSjfCj
yWSAHWtI3vVoJEjUHsc9DnHF4o9jmok7cfu62eNizJWOkGhJvL01E1LdC7OdYWuy
OMUYjXqTyHUrs0cHv7Bo3HieWS66pri1vcoEiFZwbO9Wf3KlX7o8YR5VRS9FmEcX
zLmINd/WHXPIl/+qGKEezH/n/MQcpjMbH/jGn16hPSByPRGRXyAlC+/72zm2y1Iq
mLpMJ0lqCgnETN/cu54zP2OC0JmwJyxDOFbqCi8r3n/B6mh4DlC/pEQOj81ZQjgQ
c40nn5TWxRjj3enR0e2NZYov/yT0DUNx2+XRCF8EqVWz2Rp8gt/tYFxvdGX/G6mz
wyGRaykiB/DRrwGBJAldICUoAuq6UN+gPYQZWiSVe40Wj58Ip2I=
=rrRq
-----END PGP SIGNATURE-----

--wldrZgTRBYozzq7v--
