Received: from azazel.net (taras.nevrast.org [35.176.194.208])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A31D92E1EE7
	for <netfilter-devel@vger.kernel.org>; Fri,  3 Apr 2026 15:53:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.176.194.208
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775231606; cv=none; b=YQC9XJ7C8BTfd7nHnLKDMruOY/CV9jgNtkJ4xB5vnvG+y1gwQnfZE6ODIN+JSLn/Q6SzRnbp5K8aZik2YRPnW9+lsICpQRMyeQAcyEcsWfQ+4GXdkSP9hTCEcAFuAsaHYqQxy2MSQC5GrDQwrjSYLY0Dl7clC8PupSfhyY9Wm2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775231606; c=relaxed/simple;
	bh=MjwxJvLLYZ1f7y8bbBxb5If0oh2osKSI/g5eC8H6dpA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OtvH+RoF61laXjroVvnYxlzrCb8oiATsItfkV22zyhiLN/MPdGAHd3EHeWiBFHyyPy2kr46xBBz+PyPN/wzmbagSnle7pzryFknTkw4c7NE58KEfJQ0EC8kKYDeAkn+lQMrynpCbbQYPccGEP6jYolhhTijbHFoS7BDVkKevyKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=azazel.net; spf=pass smtp.mailfrom=azazel.net; dkim=pass (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b=VmsJNkOm; arc=none smtp.client-ip=35.176.194.208
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=azazel.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=azazel.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="VmsJNkOm"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
	s=20220717; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=+M+gW0XOLNwATkZmrQ+4KSPsn2vv7qSO6D49Wf/sWUg=; b=VmsJNkOmINObrKyHqXxBrE3mcm
	YJuE/2bTaFRsph67/doa/zz7W8kW0Jd2kWFUsugftiroRV/9cayfF7i9NAd8LNlzFAxs3gNR8oznH
	UlXTs5LvfLWk34j33bte5dbujI8eVQ/KLngP3jM+qVyUDhimIvVkvcqU7oemL38oM5Z9i1YHK5BIb
	YxoAt5tWxk6thFJiKNixP7DUQcrpjIPEoH+NkCxaMOAzdgac32vm0WyDI6r66LoAWTSNKr2eXAzCf
	hqkflyIsVjbakXPFi0lC1+g7V3MWUFmWUOMRE4ns3H9VWVzLjMj0otT6z5IPvPsgfK7wfSApQeuRb
	jiRqYA5g==;
Received: from [2a00:23c8:a49f:6601:3e21:9cff:fe2f:35f] (helo=celephais.dreamlands)
	by taras.nevrast.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <jeremy@azazel.net>)
	id 1w8gpg-0000000EQCl-0BOi;
	Fri, 03 Apr 2026 16:53:16 +0100
Date: Fri, 3 Apr 2026 16:53:14 +0100
From: Jeremy Sowden <jeremy@azazel.net>
To: Phil Sutter <phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH 0/2] A bit of non-constant binop follow-up
Message-ID: <20260403155314.GC5449@celephais.dreamlands>
References: <20260402184320.14862-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="mb0THA/CW7hWSlR+"
Content-Disposition: inline
In-Reply-To: <20260402184320.14862-1-phil@nwl.cc>
X-SA-Exim-Connect-IP: 2a00:23c8:a49f:6601:3e21:9cff:fe2f:35f
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on taras.nevrast.org); SAEximRunCond expanded to false


--mb0THA/CW7hWSlR+
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2026-04-02, at 20:43:18 +0200, Phil Sutter wrote:
> When asked about how to translate ebtables' --arp-gratuitous match, I
> noticed that basically everything is there already but the parser
> rejects it.
>=20
> While we can't do a simple 'arp saddr ip =3D=3D arp daddr ip' because cmp
> expression requires for one side of the equation to be constant, using
> XOR on LHS we can work around this limitation:
>=20
> arp saddr ip ^ arp daddr ip =3D=3D 0.0.0.0
>=20
> Thanks to Jeremy's work on bitwise expression (which one might want to
> repeat for cmp),

I'll take a look. :)

J.

> the above is possible in VM code:
>=20
> [ payload load 4b @ network header + 14 =3D> reg 1 ]
> [ payload load 4b @ network header + 24 =3D> reg 2 ]
> [ bitwise reg 1 =3D ( reg 1 ^ reg 2 ) ]
> [ cmp eq reg 1 0x00000000 ]
>=20
> Patch 2 of this series relaxes the parser so it accepts the input.
> Basically it undoes an old workaround needed before we introduced start
> conditions.
>=20
> Patch 1 removes a similar restriction in JSON parser. It is needed at
> least to accept the JSON equivalent of above match (conversion to JSON
> on output was already correct).
>=20
> Phil Sutter (2):
>   parser_json: Accept non-RHS expressions in binop RHS
>   parser_bison: Accept non-constant binop on LHS of relationals
>=20
>  doc/payload-expression.txt        |  6 ++++
>  src/parser_bison.y                | 16 +++++-----
>  src/parser_json.c                 |  2 +-
>  src/scanner.l                     |  2 +-
>  tests/py/arp/arp.t                |  4 +++
>  tests/py/arp/arp.t.json           | 51 +++++++++++++++++++++++++++++++
>  tests/py/arp/arp.t.payload        | 14 +++++++++
>  tests/py/arp/arp.t.payload.netdev | 18 +++++++++++
>  8 files changed, 104 insertions(+), 9 deletions(-)
>=20
> --=20
> 2.51.0
>=20
>=20

--mb0THA/CW7hWSlR+
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

wsG7BAABCgBvBYJpz+JjCRAphqwKvfEEDUcUAAAAAAAeACBzYWx0QG5vdGF0aW9u
cy5zZXF1b2lhLXBncC5vcmdZuH3Xvej0qIwfofYfaTJQCYgzsjDCldAK4hQ9N2S4
HxYhBGwdtFNj70A3vVbVFymGrAq98QQNAAAE8RAA0cTBfm9IwCgkxdt5N2WlDNOS
5f8NrQACveuB/0CjONCYqT4wdOZwv1Mnt0RXkDxZCrh9dNh7c03+3koikClGa6qe
0CElTGZT1JKVTqR08Tk/MxXpaw0I4jvKyDuOQwP6hZsbWJVFVcR+wQkl0cpa9/qm
fb4ujflpOjUvd7WsUmvXJ8M3476/I8a/+2COYp7cVU/RwE2fIzSqJ43IGjL3GI3H
lmYoZqR4CyBGXVnSnaWKQIWYpuvjCjHEvEf0MVEOhkwyr3gq4eD5y2yQ8XaBqb+K
enivFh0fOFCXvKV6bkjPJjTHATrZViBRkCa+EO4Yj1MYkJfnbBJl1M8QMR85MiXe
Yt2kgcpVyYmR09GOhVLKyUva6BZzMc7MI5bGygQ8Ivt9uUA1m2uC5iWkMlS5+yAK
Hout91X54HvQXFEO9RmicO7xlbgaRRR2Zv1KpGsh2JvKzhA+UFTnOitH/ynKdMCU
RIw2YC8H+SJ4jMPiTNhHxQdabxNOuKGiZCiFpLT0Fs/yDf4oE5obWfH7SgONcuWt
PodJ4e7dvBaaUQYhodO1ekA5LyuWrN8hUweTCdkwWtfAkoL/s+prBUBnBz3ge2f1
nLUAJ934Zn/YaNafNxsh1KOsU5WNwvynPdWX1IwJy/2XLtHXC6D9ADvDOZRQNgQ2
my9mFFgFoRj/n3Rer0s=
=Ace2
-----END PGP SIGNATURE-----

--mb0THA/CW7hWSlR+--
