Received: from tarta.nabijaczleweli.xyz (tarta.nabijaczleweli.xyz [139.28.40.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 903181D555
	for <netfilter-devel@vger.kernel.org>; Wed, 25 Sep 2024 15:19:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=139.28.40.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727277559; cv=none; b=Gvef8FIzMbF9zNXF3EMlJPHbml1fQQC/CxoSqg1uSV4qJWMLMjT2tpTszNojNaVgS4Vrh6xrRnAUBFnS3mvSuovYl9aWUn5psB03Q6j/WDxnCBY389paexAnbaF5Vv6jz/fBSGC1LMTvN9TkPZJZHvXKhYDxOU4uQPR1a5Htv9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727277559; c=relaxed/simple;
	bh=0R+Rd9U8BpPQ4C2k7foOua/j9SqZDF579LWx8H7t0mA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fQ32hoa/B1oPlZm4VQEW+XDveBUiLLwWkM6Y81mYaCJf22hRboCkZ1ncNkN14oPN5begT8lQa8jslw81zkwFdLPznUTKmo6AICyQtGRkqHbuhh2jU0fGeOa4psabh4eob3RHakBm4IDsndAUkHeJlXXCvZCyxBgRiTzQWJkCTNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nabijaczleweli.xyz; spf=pass smtp.mailfrom=nabijaczleweli.xyz; dkim=pass (2048-bit key) header.d=nabijaczleweli.xyz header.i=@nabijaczleweli.xyz header.b=daJEcCGT; arc=none smtp.client-ip=139.28.40.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nabijaczleweli.xyz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nabijaczleweli.xyz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nabijaczleweli.xyz header.i=@nabijaczleweli.xyz header.b="daJEcCGT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nabijaczleweli.xyz;
	s=202405; t=1727277061;
	bh=0R+Rd9U8BpPQ4C2k7foOua/j9SqZDF579LWx8H7t0mA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=daJEcCGTNhgfJ5VFTQWJou0630LfHsYq9dnF83XkyuH0Y5B3Yecjv+nNpIKE9DuBS
	 7eLM0JZP0LMn8vDeN+VxoPQLo75SyIJJCo3N0KkV5jnZQip09sQPHMoNl+WUKj/u0T
	 e/vLI4HWR6gJ9SU/b3GIYqWMhjUlN27xH7YkeZYR0V0EulLyuUrnVtrLucOslz2tI4
	 Mkp3OA/ZdgMXq4HJCRzMwxNKoJPesBH7/2nQ15qMBuoZzBIyvfwJvmjrm3yJgTivKh
	 X/C7PVXrlq6Lw4tdT+gl3acjvwrNfDU0dupVtsrITz5i7jf1osdBuELxyasy9EwqI4
	 aX86TQY2NnEVg==
Received: from tarta.nabijaczleweli.xyz (unknown [192.168.1.250])
	by tarta.nabijaczleweli.xyz (Postfix) with ESMTPSA id E2D0137C;
	Wed, 25 Sep 2024 17:11:01 +0200 (CEST)
Date: Wed, 25 Sep 2024 17:11:01 +0200
From: 
	Ahelenia =?utf-8?Q?Ziemia=C5=84ska?= <nabijaczleweli@nabijaczleweli.xyz>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] conntrack: -L doesn't take a value, so don't discard one
 (same for -IUDGEFA)
Message-ID: <qe4cxltrompmuajfgfkedrecefkyy2eopi3erttlm7c3xigs2g@tarta.nabijaczleweli.xyz>
References: <hpsesrayjbjrtja3unjpw4a3tsou3vtu7yjhrcba7dfnrahwz2@tarta.nabijaczleweli.xyz>
 <ZtbHMe6STK_W6yfA@calendula>
 <bymeee6fsub6oz64xtykfru25aq6xx4k2agjbeabekzfobu4jd@tarta.nabijaczleweli.xyz>
 <ZvQj_TOKcN7A9kmz@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="at5wpnzhofck5wnq"
Content-Disposition: inline
In-Reply-To: <ZvQj_TOKcN7A9kmz@calendula>
User-Agent: NeoMutt/20231221-2-4202cf-dirty


--at5wpnzhofck5wnq
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 25, 2024 at 04:53:49PM +0200, Pablo Neira Ayuso wrote:
> On Tue, Sep 03, 2024 at 04:53:46PM +0200, Ahelenia Ziemia=C5=84ska wrote:
> > On Tue, Sep 03, 2024 at 10:22:09AM +0200, Pablo Neira Ayuso wrote:
> > > On Tue, Sep 03, 2024 at 04:16:21AM +0200, Ahelenia Ziemia=C5=84ska wr=
ote:
> > > > The manual says
> > > >    COMMANDS
> > > >        These options specify the particular operation to perform.
> > > >        Only one of them can be specified at any given time.
> > > >=20
> > > >        -L --dump
> > > >               List connection tracking or expectation table
> > > >=20
> > > > So, naturally, "conntrack -Lo extended" should work,
> > > > but it doesn't, it's equivalent to "conntrack -L",
> > > > and you need "conntrack -L -o extended".
> > > > This violates user expectations (borne of the Utility Syntax Guidel=
ines)
> > > > and contradicts the manual.
> > > >=20
> > > > optarg is unused, anyway. Unclear why any of these were :: at all?
> > > Because this supports:
> > >         -L
> > >         -L conntrack
> > >         -L expect
> > Well that's not what :: does, though; we realise this, right?
> >=20
> > "L::" means that getopt() will return
> >   "-L", "conntrack" -> 'L',optarg=3DNULL
> >   "-Lconntrack"     -> 'L',optarg=3D"conntrack"
> > and the parser for -L (&c.) doesn't... use optarg.
> Are you sure it does not use optarg?
>=20
> static unsigned int check_type(int argc, char *argv[])
> {
>         const char *table =3D get_optional_arg(argc, argv);
>=20
> and get_optional_arg() uses optarg.

This I've missed, but actually my diagnosis still holds:
  static unsigned int check_type(int argc, char *argv[])
  {
  	const char *table =3D get_optional_arg(argc, argv);
 =20
  	/* default to conntrack subsystem if nothing has been specified. */
  	if (table =3D=3D NULL)
  		return CT_TABLE_CONNTRACK;

  static char *get_optional_arg(int argc, char *argv[])
  {
  	char *arg =3D NULL;
 =20
  	/* Nasty bug or feature in getopt_long ?
  	 * It seems that it behaves badly with optional arguments.
  	 * Fortunately, I just stole the fix from iptables ;) */
  	if (optarg)
  		return arg;

So, if you say -Lanything, then
  optarg=3Danything
  get_optional_arg=3D(null)
(notice that it says "return arg;", not "return optarg;",
 i.e. this is "return NULL").

It /doesn't/ use optarg, because it explicitly treats an optarg as no optar=
g.

It's unclear to me what the comment is referencing,
but I'm assuming some sort of confusion with what :: does?
Anyway, that if(){ can be removed now, since it can never be taken now.

--at5wpnzhofck5wnq
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEfWlHToQCjFzAxEFjvP0LAY0mWPEFAmb0KAUACgkQvP0LAY0m
WPFVgA/+ICcca/UrrHpeOyH1b8Wc3MyuASqzXvpLWumcITwyqKz9kTcKviH0W4On
eQE6L2LTknb8lkqzAQ6mzlGO9tPFabwMGnhrsdCqcSnMDoJfxySAw8Qe5xg8AK5H
P+c7+gGwEIadgSYZcUsoN4CBkckOVyZmodu/ARJted6xs308sm51o8jPbkHZVgXm
75yVUitYp4gtmxdedYdP7aD5RopiBTHfPtrDighIzWtC+9ulmQATkisAWuHXoUxl
py6dgl74RUAHGVzuIX1aJ5ZCyVe9cYQKfUtcvvqgbQxNIclULCdQpuISXe+T5t2K
wkYmk5b+dyEPDo9jj/h2yMtEInQh7fUPjag4tBxgJIRyAA3nJ7hvZC60UG1fTWys
M+V+w/a1Rx6MCA8jogAAixBvmK0gBpzXPpRaOwaiXsthPbqumFDqUJC5FSE5VPqf
K5BunCEid218P51+v99vzCIlldgnGFWO/58BO32qXeqbK3R/moKXt/XbEbgnW0LJ
HI8aXqoR5J8SWVOBQMXDfaMEH2eMgPexuQQfvc91c+WdCCyiMEpseAKwLzPT8EvS
IYYmT2odG2vuO6C6IQyPXlFH6hsymKzWCNxp8cF7YIE0SySpY/RvPcwP++BMbU0Q
k1pkVsbiPR7ea65PxyD0iPUQGEkNe18P+lhxGW+Ro1CSHp6Vp+M=
=5tWT
-----END PGP SIGNATURE-----

--at5wpnzhofck5wnq--
