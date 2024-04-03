Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B829E6D1A1
	for <netfilter-devel@vger.kernel.org>; Wed,  3 Apr 2024 07:45:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712130349; cv=none; b=cldAjGkT9jC/GEAj1W9J8oc+F8qhaFVnUYybu773czymp3EjlaoUKGTNc6Rg94t47lKT//l4EnPBh2/dmmyPxIp7rBd+x4qfVuO/OFtlqPetD++qHQnixRX5ccZURQPWZimXxQkXEHAThVdLPLXLVFAdWT2VSfl7qiuqPYB7reM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712130349; c=relaxed/simple;
	bh=lL+Ule7i7ndmqxvU/yGj6EMJSFrVpkeL+sDNT/P1OCc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mz0kw6JCwcWANeyR3WZZDlPq6Uezdv8cxPhGe/wkcGVkKm7ko6Won9Cq0+tWtBBIRrwTHOcTnMxEDI7Ni4ObspChv4FvnhegohuZzNby7lHE2Jx9d4/LS/kgqrZLfogDWTZPQwdv76XRq0J+dQuzL9wd1s8+cixRLUwSHTPRxNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=azazel.net; spf=fail smtp.mailfrom=azazel.net; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=azazel.net
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=azazel.net
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.94.2)
	(envelope-from <jeremy@azazel.net>)
	id 1rrvCm-00CA4y-90; Wed, 03 Apr 2024 07:38:44 +0000
Date: Wed, 3 Apr 2024 08:38:41 +0100
From: Jeremy Sowden <jeremy@azazel.net>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nftables] evaluate: add support for variables in map
 expressions
Message-ID: <20240403073841.GA907770@celephais.dreamlands>
References: <20240324145908.2643098-1-jeremy@azazel.net>
 <ZgyJ8yUi8CyOpEHX@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="I4xTKe/mamtEVKEN"
Content-Disposition: inline
In-Reply-To: <ZgyJ8yUi8CyOpEHX@calendula>
X-Debian-User: azazel


--I4xTKe/mamtEVKEN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2024-04-03, at 00:42:59 +0200, Pablo Neira Ayuso wrote:
> On Sun, Mar 24, 2024 at 02:59:07PM +0000, Jeremy Sowden wrote:
> > It is possible to use a variable to initialize a map, which is then use=
d in a
> > map statement:
> >=20
> >   define m =3D { ::1234 : 5678 }
> >=20
> >   table ip6 nat {
> >     map m {
> >       typeof ip6 daddr : tcp dport;
> >       elements =3D $m
> >     }
> >     chain prerouting {
> >       ip6 nexthdr tcp redirect to ip6 daddr map @m
> >     }
> >   }
> >=20
> > However, if one tries to use the variable directly in the statement:
> >=20
> >   define m =3D { ::1234 : 5678 }
> >=20
> >   table ip6 nat {
> >     chain prerouting {
> >       ip6 nexthdr tcp redirect to ip6 daddr map $m
> >     }
> >   }
> >=20
> > nft rejects it:
> >=20
> >   /space/azazel/tmp/ruleset.1067161.nft:5:47-48: Error: invalid mapping=
 expression variable
> >       ip6 nexthdr tcp redirect to ip6 daddr map $m
> >                                   ~~~~~~~~~     ^^
> >=20
> > Extend `expr_evaluate_map` to allow it.
> >=20
> > Add a test-case.
>=20
> Thanks for your patch.
>=20
> > Link: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1067161
> > Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
> > ---
> >  src/evaluate.c                                |  1 +
> >  .../shell/testcases/maps/anonymous_snat_map_1 | 16 +++++
> >  .../maps/dumps/anonymous_snat_map_1.json-nft  | 58 +++++++++++++++++++
> >  .../maps/dumps/anonymous_snat_map_1.nft       |  5 ++
> >  4 files changed, 80 insertions(+)
> >  create mode 100755 tests/shell/testcases/maps/anonymous_snat_map_1
> >  create mode 100644 tests/shell/testcases/maps/dumps/anonymous_snat_map=
_1.json-nft
> >  create mode 100644 tests/shell/testcases/maps/dumps/anonymous_snat_map=
_1.nft
> >=20
> > diff --git a/src/evaluate.c b/src/evaluate.c
> > index 1682ba58989e..d49213f8d6bd 100644
> > --- a/src/evaluate.c
> > +++ b/src/evaluate.c
> > @@ -2061,6 +2061,7 @@ static int expr_evaluate_map(struct eval_ctx *ctx=
, struct expr **expr)
>=20
> expr_evaluate_objmap() also needs a similar fix.

Cool.  Will update and resend.

J.

> >  	mappings->set_flags |=3D NFT_SET_MAP;
> > =20
> >  	switch (map->mappings->etype) {
> > +	case EXPR_VARIABLE:
> >  	case EXPR_SET:
> >  		if (ctx->ectx.key && ctx->ectx.key->etype =3D=3D EXPR_CONCAT) {
> >  			key =3D expr_clone(ctx->ectx.key);

--I4xTKe/mamtEVKEN
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEbB20U2PvQDe9VtUXKYasCr3xBA0FAmYNB3oACgkQKYasCr3x
BA321g//X+02MUu2Yz0hEtKGHx0wzyL+4roPH+MrfAyZ03zMwEnF2UgZL1ho/p01
I6dIljceF7MX0SwaXaGXvXCnwy6438VFa7RpW68fwfLdqLYwL8MNG71z1DymkOxh
oK8GxLzhQ12IpKWwMuAfPCg5fzUKXIPMpPAI+CVG9IHokiQ7QNoZF/7RLZPswU+c
oblZPMNZBl/aUHRNQexyhC6dqRFcubyvkP7Qi0sAb5O83T8orMcErk/OZHGkP0sD
0OoTgQn4o4upUdvtqSG42lQe/xCuf66Ks1HwYxPBj0xBny1zEHZwAMf/VRjGjtDK
7SnTZEeLR+KcKa3+ocuMoeGdTLrDeDfGzF1Hlk3DTgmCCO713HzhiHBFIwz25pGY
iBqhBD+PGSNeJs20Ry1KTzVtMBn+xGy6RtMW3Y/LMxrCEG4+N6QlYpF3qf1fU2JI
/4u4Ulbhubvws8WBfJ/pSsx+z+Gmd2AxnPhyHkhUa1bA05MjBgMsMgHrZNZGrV+D
xj0p8xkPVFRPOtWY8wCylxDwNblLfLL51TS58ZsYpab8rGnORnJXlJcXjlzydAe+
MqB0VYhETdX0JZtLf/yCO8/BMLKGzoxH0vOEutBHOhZUnfYdWvD2DJlZWTcjVURq
s+kKTcnyeFE+UKexbkuXt31H0oaN7NptF3/94vftVUUOJF+P6b4=
=KHN8
-----END PGP SIGNATURE-----

--I4xTKe/mamtEVKEN--
