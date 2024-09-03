Received: from tarta.nabijaczleweli.xyz (tarta.nabijaczleweli.xyz [139.28.40.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F393316C453
	for <netfilter-devel@vger.kernel.org>; Tue,  3 Sep 2024 14:53:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=139.28.40.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725375240; cv=none; b=Ftz5FfeBjXv0i3+EdXVI/5vIVbUM6/B57YdOYB5tCwQ0H4sRowGreyeCRv0OQxVQYUid7AWv5nHJxWQ5RPP8NN84Qp76Mx7Ek7gRUPq6zT4xfa3cbcFtPyX7jT220E7r5rmn3MYluRqYXnLvY7mVhQ5lVTH3GuOWQ8jl5yKevWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725375240; c=relaxed/simple;
	bh=ezV5omP0vhOTzo7g7Is8FUQm5YnwYTTgpDYXKqJShRY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FurWvk26D4FBC3NeYzoFrvS6Ok7h7znESkJp3SeCe8aUIghgmVXBFk6QzFYmrATq9Bjrqin36NFdBMuI0XLZe8H7X+mWIAmE2g3bW96CJBsbmT51zGVTieNQWt9dWfGTN30+50BwsnDYTFY3bdJj+7R5Chz8JHyJsvtZzA3Y2OY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nabijaczleweli.xyz; spf=pass smtp.mailfrom=nabijaczleweli.xyz; dkim=pass (2048-bit key) header.d=nabijaczleweli.xyz header.i=@nabijaczleweli.xyz header.b=CzkPufay; arc=none smtp.client-ip=139.28.40.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nabijaczleweli.xyz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nabijaczleweli.xyz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nabijaczleweli.xyz header.i=@nabijaczleweli.xyz header.b="CzkPufay"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nabijaczleweli.xyz;
	s=202405; t=1725375227;
	bh=ezV5omP0vhOTzo7g7Is8FUQm5YnwYTTgpDYXKqJShRY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CzkPufay78zhGRDQ7s9nXCyLx/MZUDt+vFO9CsUGBjKGVEiNbH9YQ+M3lEnh7aGoN
	 JZMi2YWrMF2qGh6JFQaPExOF5oDaNnZLb9fm3Y6/39cYUgLv92Ou97HLE0/lWXi4E8
	 uDGN+62fuz9EgdSvsSgF+pMsuy8ZeD3wx0Epcq5lHXtzgZCPYVo9svQmbL3XyHtHnv
	 dyDPzqNquxSg816JdcQfNwSct3ufvXazVkuv9kwjh9Xq9Vr9Oj4ZeeoAfpoVw6qIzx
	 nKyPevtRgCkEXiiSrZuOxqo0ZTHpynT0nYKUc2dBEttJVf3etn3ZRgSBQ8lF0fUyn6
	 t0DNHYw7vjpOQ==
Received: from tarta.nabijaczleweli.xyz (unknown [192.168.1.250])
	by tarta.nabijaczleweli.xyz (Postfix) with ESMTPSA id 05C729BC;
	Tue,  3 Sep 2024 16:53:47 +0200 (CEST)
Date: Tue, 3 Sep 2024 16:53:46 +0200
From: 
	Ahelenia =?utf-8?Q?Ziemia=C5=84ska?= <nabijaczleweli@nabijaczleweli.xyz>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] conntrack: -L doesn't take a value, so don't discard one
 (same for -IUDGEFA)
Message-ID: <bymeee6fsub6oz64xtykfru25aq6xx4k2agjbeabekzfobu4jd@tarta.nabijaczleweli.xyz>
References: <hpsesrayjbjrtja3unjpw4a3tsou3vtu7yjhrcba7dfnrahwz2@tarta.nabijaczleweli.xyz>
 <ZtbHMe6STK_W6yfA@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="tbsa56woz2mmcfhm"
Content-Disposition: inline
In-Reply-To: <ZtbHMe6STK_W6yfA@calendula>
User-Agent: NeoMutt/20231221-2-4202cf-dirty


--tbsa56woz2mmcfhm
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 03, 2024 at 10:22:09AM +0200, Pablo Neira Ayuso wrote:
> On Tue, Sep 03, 2024 at 04:16:21AM +0200, Ahelenia Ziemia=C5=84ska wrote:
> > The manual says
> >    COMMANDS
> >        These options specify the particular operation to perform.
> >        Only one of them can be specified at any given time.
> >=20
> >        -L --dump
> >               List connection tracking or expectation table
> >=20
> > So, naturally, "conntrack -Lo extended" should work,
> > but it doesn't, it's equivalent to "conntrack -L",
> > and you need "conntrack -L -o extended".
> > This violates user expectations (borne of the Utility Syntax Guidelines)
> > and contradicts the manual.
> >=20
> > optarg is unused, anyway. Unclear why any of these were :: at all?
> Because this supports:
>         -L
>         -L conntrack
>         -L expect
Well that's not what :: does, though; we realise this, right?

"L::" means that getopt() will return
  "-L", "conntrack" -> 'L',optarg=3DNULL
  "-Lconntrack"     -> 'L',optarg=3D"conntrack"
and the parser for -L (&c.) doesn't... use optarg.

You don't parse the filter (table name? idk.) with getopt at all;
you can test this /right now/ by running precisely the thing you outlined:
  # conntrack -L > /dev/null
  conntrack v1.4.7 (conntrack-tools): 137 flow entries have been shown.
  # conntrack -L expect > /dev/null
  conntrack v1.4.7 (conntrack-tools): 0 expectations have been shown.
  # conntrack -Lexpect > /dev/null
  conntrack v1.4.7 (conntrack-tools): 152 flow entries have been shown.
and getopt returns, respectively
  'L',optarg=3DNULL
  'L',optarg=3DNULL; argv[optind]=3D"expect"
  'L',optarg=3D"expect"
=2E..and once again you discard the optarg for 'L' &c.

--tbsa56woz2mmcfhm
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEfWlHToQCjFzAxEFjvP0LAY0mWPEFAmbXIvgACgkQvP0LAY0m
WPEMYQ//SVeJLkCVIhV3p2TuT/0VTbRJZ3UCwBmtwrSii1XJGVRDe5BD5TKraqzk
7c6pg70Z7AraBnGT3Z6B/o4hTOah6AIa8VvIRj1hgdE9UDgxnhOrtuEjC/ViwFFH
qSxiPoqaldp6A4U456QWEdSQog+gZ6bbKLVTMrI0olW7UFgNZ1Ohb1lleKRvVEgw
HPw4atWKGXda47SgVqwDdELZfFgGemXTw7fEIguU5qUSFwUG9dd2qB4Zqb9XAgUq
3L0rxChsWat3BOP1lT6wuY52HqGG0CIrS37qD8q2T//G9tGv09RgdlP/lNmwmAOJ
CBdv9U/koTalToV0aOnOuy34HwoIPlsr6ZjeAcHisgXlawwswc70lDdk8JGn4M3c
O7WXyZQJ+5KdUJANizAMMY+lR13QhRdxAX7OpT+mvmradO4QXwFvxMGBkxpFtIFW
9szoHIHSnr+l33qP/Y5BnXTZmjJDtyC5kwMhcCWeG+/TRF6RgzYpVXA/byUoB7ih
H/11MmTdKyftwDPraoSkri7RkXeQqilDQyU0ooxs/QDZhaEK3r3bOdN5MpRWMr/I
Jvzz/6Ye9k49rDYRvh8zRTGdJpiEuYXZhhO5gxMNcpyQOKMBe+oWDeIqF5fiOU/Y
G9CAAhMazw+dxFtTkKJATM5M7ZDJtYo3pKuCFMbMQP3BAo+Rzdw=
=49ZT
-----END PGP SIGNATURE-----

--tbsa56woz2mmcfhm--
