Received: from azazel.net (taras.nevrast.org [35.176.194.208])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C73B2209B
	for <netfilter-devel@vger.kernel.org>; Mon, 21 Oct 2024 19:10:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.176.194.208
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729537869; cv=none; b=haM0iLk5g1XdzAYNoa9R0moMZq+z1In936K4zyTBUP07d5PWp/yJIyAQ4CHX0MM1RJIcX/gkA6jZiTFsyjCffhnQ7Azd/9gWjYS/iIiP5a4Bn/leQscaWaCwbMKI6PsP49iiIbaVvSVCmSNjuQC2WEusmm4pFWfVtptC/IulJBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729537869; c=relaxed/simple;
	bh=yTLkUUBWdl45fddl6tU9JlBOvh9JoQo6OThdQWC5ZVQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WQHU/S+v2qeQi3SAPy8TkIfbnWaFqXC1V5JyuPlH8zEcF2ECXsIayWCb1In97leGnI1a0jSgTEDdnuQy7qOh6GLsiMMPQL4RCO3yxT+f06K3Bo3dZLpYqF46j/X+iUbaKnHQPGdsppmos45QDn/XhRVauN3eilaryufLV4N+t94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=azazel.net; spf=pass smtp.mailfrom=azazel.net; dkim=pass (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b=CBipstEu; arc=none smtp.client-ip=35.176.194.208
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=azazel.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=azazel.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="CBipstEu"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
	s=20220717; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=fVOil9tnbcauDymXgHCwsSf1/WrmGm8/0C1ObeqP9Jc=; b=CBipstEugwd/85qJursJFH+ozP
	KoyIluY0VS5uyMhBgdRflCI08cU+1ECZPbkCedKfjiR399Mj7NaN4CO8MPb5l8hWYTxfPs52/gh9d
	nTFk9SIe3iXJ3kd4XR5cbIifj4/2DEizNZFu522hzldzIxCw9g4lXgohzV0wbtqsHi7VE+Af/XFt2
	WOnJis3WWoRN1lR/9aKYKBUBHVA/KBrtYckhT4XSPvewtot1epqakla/bccCv0ChvwZJXNll2Yyuh
	z4oeeGGGHl/tJsNIEotbx5WkNP56TigiqXrsb83/xRUo9AYrViDhtqHyVpcYLnLfGdbG/FmFRajtU
	i/w7Pa3A==;
Received: from celephais.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:3c21:9cff:fe2f:35f] helo=celephais.dreamlands)
	by taras.nevrast.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <jeremy@azazel.net>)
	id 1t2xnt-002f9M-1t;
	Mon, 21 Oct 2024 20:10:57 +0100
Date: Mon, 21 Oct 2024 20:10:56 +0100
From: Jeremy Sowden <jeremy@azazel.net>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH conntrack,v2 2/2] conntrack: improve --mark parser
Message-ID: <20241021191056.GB1028786@celephais.dreamlands>
References: <20241012220030.51402-1-pablo@netfilter.org>
 <20241012220030.51402-2-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="fnNLzFIhFsV91iWR"
Content-Disposition: inline
In-Reply-To: <20241012220030.51402-2-pablo@netfilter.org>
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:3c21:9cff:fe2f:35f
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on taras.nevrast.org); SAEximRunCond expanded to false


--fnNLzFIhFsV91iWR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2024-10-13, at 00:00:30 +0200, Pablo Neira Ayuso wrote:
> Enhance helper function to parse mark and mask (if available), bail out
> if input is not correct.
>=20
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
> v2: - remove value =3D=3D 0 && errno =3D=3D ERANGE check
>=20
>  src/conntrack.c | 34 +++++++++++++++++++++++++++-------
>  1 file changed, 27 insertions(+), 7 deletions(-)
>=20
> diff --git a/src/conntrack.c b/src/conntrack.c
> index 18829dbf79bc..5bd966cad657 100644
> --- a/src/conntrack.c
> +++ b/src/conntrack.c
> @@ -1233,17 +1233,35 @@ static int parse_value(const char *str, uint32_t =
*ret, uint64_t max)
>  	return 0;
>  }
> =20
> -static void
> +static int
>  parse_u32_mask(const char *arg, struct u32_mask *m)
>  {
> -	char *end;
> +	uint64_t val, mask;
> +	char *endptr;
> +
> +	val =3D strtoul(arg, &endptr, 0);
> +	if (endptr =3D=3D arg ||
> +	    (*endptr !=3D '\0' && *endptr !=3D '/') ||
> +	    (val =3D=3D ULONG_MAX && errno =3D=3D ERANGE) ||
> +	    val > UINT32_MAX)
> +		return -1;
> =20
> -	m->value =3D (uint32_t) strtoul(arg, &end, 0);
> +	m->value =3D val;
> =20
> -	if (*end =3D=3D '/')
> -		m->mask =3D (uint32_t) strtoul(end+1, NULL, 0);
> -	else
> +	if (*endptr =3D=3D '/') {
> +		mask =3D (uint32_t) strtoul(endptr + 1, &endptr, 0);
                       ^^^^^^^^^^

No need for this cast.

J.

> +		if (endptr =3D=3D arg ||
> +		    *endptr !=3D '\0' ||
> +		    (val =3D=3D ULONG_MAX && errno =3D=3D ERANGE) ||
> +		    val > UINT32_MAX)
> +			return -1;
> +
> +		m->mask =3D mask;
> +	} else {
>  		m->mask =3D ~0;
> +	}
> +
> +	return 0;
>  }
> =20
>  static int
> @@ -3115,7 +3133,9 @@ static void do_parse(struct ct_cmd *ct_cmd, int arg=
c, char *argv[])
>  			break;
>  		case 'm':
>  			options |=3D opt2type[c];
> -			parse_u32_mask(optarg, &tmpl->mark);
> +			if (parse_u32_mask(optarg, &tmpl->mark) < 0)
> +				exit_error(OTHER_PROBLEM, "unexpected value '%s' with -%c option", o=
ptarg, c);
> +
>  			tmpl->filter_mark_kernel.val =3D tmpl->mark.value;
>  			tmpl->filter_mark_kernel.mask =3D tmpl->mark.mask;
>  			tmpl->filter_mark_kernel_set =3D true;
> --=20
> 2.30.2
>=20

--fnNLzFIhFsV91iWR
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEbB20U2PvQDe9VtUXKYasCr3xBA0FAmcWpz8ACgkQKYasCr3x
BA1eQQ/6A5bB9+nZVl1tg/s63hYplJKX/+3h88vlk99gfj6eNQgVX7xob1o22r7u
BEoM4ha+mHtPLNvUjfAL3PdxC8TGrIOUwoo3lOisLWX0kasMUP2t2ip+2wZMZ6BE
G91qXBaf96Iypp3MjF2+mv5b8B+L6Re6fR4etUlaWu9P3Y3CdJQRMU3hUVSscDKp
IWTIxhpddZbQEsUvOiPcAQeeKsq/1hyUEFRZXJFFGJPqoipnUviOaFDR7wgy0ixJ
slwcnlDrax+m0SSDpoe+EJP4wtFstlBfmd22loa6mGFXuId+rQqfYwfE9GRX8n0Q
Uo28ivSkgTbZy97rgiHt/hojmFG6V+YasFYeDGrw2jewjr9ZhuBp88Q8xqpnKowz
vDmRxszBeCfQ/b3vz15eE/RWgU1oWwXDAj0vFxa1v5Gq88aYBXbdUVbIpiGW7gnA
BNYFk0b3e+6JLQ5S0BWNFzMPfvYVHTVnvoSooEjeKENuHOjQWYbGsgtCNVDw8/Ev
iXKf2I5DUmD5vKFrLufxhe6DNSh1BsXEUkBlFkwC+ov96w0ohS/d6m2JimSwHv+6
qCPUOApegfywN3eh70/uVt4HWh94w4WdvMYzEZA5g5civ2TAU1OqwRbDX3HayzUf
52ZEsIiLZaTTIVs5xB0IRkhHIhQNJIYfgqFd/UmKN0G0Uz7ikWA=
=d5+s
-----END PGP SIGNATURE-----

--fnNLzFIhFsV91iWR--
