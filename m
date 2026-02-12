Received: from mail-24426.protonmail.ch (mail-24426.protonmail.ch [109.224.244.26])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C6481C84A6
	for <netfilter-devel@vger.kernel.org>; Thu, 12 Feb 2026 19:34:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=109.224.244.26
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770924882; cv=none; b=NUEo6fDv11111xsDaSzsqBHv8Q31agy/+5T+7Kxi+Ivx/pIm85yCsSAc5IaUmFAZyAjiV57BOKXkX4KGaNXugkgSCZlMOUm02WrV9GwaZv9fAjBy6nmUMVXdMpvOXAKpqMGEU/vyEA7hE530bgSGaRJSjJtf8ioJ7uhCCHN6HZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770924882; c=relaxed/simple;
	bh=mqb2rtLMJPOHoy/Sg+7A0lcfEs17VWIlZc4eTas+35Y=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fcuhxuD7D713R6a+4lQJ0noV4pAMLR1GV4I6CmUVVXVsNt+g5EwAKRLXkDDEKxkOnw3SFhco159lUdVfSKCaKw7pdf53Zr/qPO9cXYFgH60vpP4kD8RtMEUVK5ngVbkHbEor1njxjqSOGOsWHYMo0YSUIaS+CXmpkX5tFZR3lLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=protonmail.com; spf=pass smtp.mailfrom=protonmail.com; dkim=pass (2048-bit key) header.d=protonmail.com header.i=@protonmail.com header.b=kb+xtoCp; arc=none smtp.client-ip=109.224.244.26
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=protonmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=protonmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=protonmail.com header.i=@protonmail.com header.b="kb+xtoCp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
	s=protonmail3; t=1770924872; x=1771184072;
	bh=mbb9toBspLjuIWRg9CHO+FfLiLLMISjVO31cACojoys=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=kb+xtoCpLT2B1xX+gbyHdYoafKgoYtCYLVJEHiR9HFnLDXkzx6j/T/8bmz5LgSsnv
	 e2yOE6BzZ1/xfJm2bpez7QCN/70cTcUnNj4y6fXQBeIPTqDY0ToYLiZHA6J0zGoZwF
	 gBPo0Jc3WQev6lAsvOTSEsGrJmrS4/N66qqcywOHrV+6MCLswOzwBp7+2yNrO2o1bt
	 ZFiS2wvuiKLxftj4c4mqKqiQbEbqNmmEaymaHXtIVMzvZFGA0iRFR2LSUb/72l2BXV
	 faslPNWYt2Jmhf3e3/ef3taFs2QODqwWmWMTJYhqW19c4jCVQniy5f+e34lJzu4bnQ
	 wB7svd6kgB6Mg==
Date: Thu, 12 Feb 2026 19:34:29 +0000
To: Phil Sutter <phil@nwl.cc>
From: "Remy D. Farley" <one-d-wide@protonmail.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, Jozsef Kadlecsik <kadlec@netfilter.org>, Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Subject: [PATCH] iptables: fix null dereference parsing bitwise operations
Message-ID: <wsfxGCi6FNb3Qj2_tw3b9WZS2spw8DyUe34OgpSzj8UQg7tNdw0RReS7iwQBnoVIHfZOIFoCUFf6mVAVOAGCSabgUgWBa9yABVwyAzNI_lc=@protonmail.com>
In-Reply-To: <aYz2eUev4mUdN7uX@orbyte.nwl.cc>
References: <20260202101408.745532-1-one-d-wide@protonmail.com> <aYz2eUev4mUdN7uX@orbyte.nwl.cc>
Feedback-ID: 59017272:user:proton
X-Pm-Message-ID: fc3c8ce49783a234273b9af3b9e0488abb9f49c7
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Wednesday, February 11th, 2026 at 21:37, Phil Sutter <phil@nwl.cc> wrote=
:

> On Mon, Feb 02, 2026 at 10:14:52AM +0000, Remy D. Farley wrote:
> > diff --git a/iptables/nft-ruleparse.c b/iptables/nft-ruleparse.c
> > index cdf1af4f..1a9084e3 100644
> > --- a/iptables/nft-ruleparse.c
> > +++ b/iptables/nft-ruleparse.c
> > @@ -232,6 +232,11 @@ static void nft_parse_bitwise(struct nft_xt_ctx *c=
tx, struct nftnl_expr *e)
> >  =09const void *data;
> >  =09uint32_t len;
> >
> > +=09if (nftnl_expr_get_u32(e, NFTNL_EXPR_BITWISE_OP) !=3D 0 /* empty or=
 MASK_XOR */) {
> > +=09=09ctx->errmsg =3D "unsupported bitwise operation";
> > +=09=09return;
> > +=09}
> > +
>=20
> This is redundant wrt. the stricter compatibility check below, right? Or
> did you find a call to nft_rule_to_iptables_command_state() which is not
> guarded by nft_is_table_compatible()?


Yeah, I wasn't sure that was the case. I'll remove this check.


> Anyway, I would add two checks to that function like so:
>=20
> | if (!data) {
> | =09ctx->errmsg =3D "missing bitwise xor attribute";
> | =09return;
> | }
>=20
> (And the same for bitwise mask.) It will sanitize the function's code
> irrespective of expression content, readers won't have to be aware of
> (and rely upon) bitwise expression semantics with NFTNL_EXPR_BITWISE_OP
> attribute value being zero.
>=20
> >  =09if (!sreg)
> >  =09=09return;
> >
> > diff --git a/iptables/nft.c b/iptables/nft.c
> > index 85080a6d..661fac29 100644
> > --- a/iptables/nft.c
> > +++ b/iptables/nft.c
> > @@ -4029,7 +4029,6 @@ static const char *supported_exprs[] =3D {
> >  =09"payload",
> >  =09"meta",
> >  =09"cmp",
> > -=09"bitwise",
> >  =09"counter",
> >  =09"immediate",
> >  =09"lookup",
> > @@ -4056,6 +4055,10 @@ static int nft_is_expr_compatible(struct nftnl_e=
xpr *expr, void *data)
> >  =09    nftnl_expr_is_set(expr, NFTNL_EXPR_LOG_GROUP))
> >  =09=09return 0;
> >
> > +=09if (!strcmp(name, "bitwise") &&
> > +=09    nftnl_expr_get_u32(expr, NFTNL_EXPR_BITWISE_OP) =3D=3D 0 /* emp=
ty or MASK_XOR */)
>=20
> '=3D=3D NFT_BITWISE_MASK_XOR' and drop the comment.


It took me a while to realize iptables/linux headers are quite outdated,
so NFT_BITWISE_MASK_XOR is still called NFT_BITWISE_BOOL in there.


>
> Thanks, Phil
