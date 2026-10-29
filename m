Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793274263;
	b=lwhtrsrXvx0d7gCI5AjFgP/yLRwarJRBi2y+RyWfh2fHDUaD4FnWBSa6zJQr8oTGDvYF
	 7kPH93eUEtkAbkXqoKM4gX3rxbgZwu5R5n/SulGadBhjZZ/OHwsIkcNgjEqB9eck36WNH
	 DJfa361UU4lg9yF8vByanCtmEpVCjvbA9dlqaY1qEdVuAqmxmC/y23EsqV61drPx6gd5t
	 6qhNK+AnW+B1Kbm5F3JRMaDQfABOSVEVEcoL6lstVVDiCg/TUsFspKxLbGiEG+EQneNRy
	 jbiUkdP7ogr/3HQalZ9LcD+hm+H30d1CXp9/sXYV1rk7gMLbMySwfHCt6PEslkEBjiw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793274263;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=L0WrM30mg3Qmd9sid3kLE9l2CeaHvYAh8gzOLcuKH78=;
	b=0IdByh8u50aztPk3yejPjv1nZkpLSYpAWeFvll9DNV3JcBTA8LZvemivbLTx06/eU3WX
	 KcmCKr/3IG+XobGnF1WVfUV1JSvxh0grF+nz1/Sw4HmdLD9NEJa57aHngpN3TE2qYMOjD
	 OJS/V3lUwIJSRMnw5JESyE5sS/lXyeKGWNvS/TlYCS1uMiCV0XnqNVewTRKdyigAYH3xj
	 wctoRwkOupQt8R/qYoGg+WSsIeVNpnw8aPV59UBh4nWbIFoHoNjSV2C9yuBk2KawFIP1y
	 fBkh9j2t8OgYP1GtvkMBImp9WkqtfGiApxJpXQcxjpHKj8u2GCUpF+bY/wTpY/10Gbg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cpMbXLuY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16313606A31C
	for <netfilter-devel@vger.kernel.org>; Thu, 29 Oct 2026 11:44:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cpMbXLuY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D5301F01825;
	Thu, 29 Oct 2026 11:44:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793274262;
	bh=L0WrM30mg3Qmd9sid3kLE9l2CeaHvYAh8gzOLcuKH78=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=cpMbXLuYl9C3hqxQ6s9XgMd756tY7sYdnwv6UUunA7WvaoVv9FMOFkNnj2QsqKixd
	 a8rZpcLj8weT8VBWAXCV2sPg/5OBlEDH3FgUYNBwZFVGvn1nlp7+Uk8ERYc+00d+Y8
	 bmAsv4dCkFBJdJgGgmQYuxfs3OZGHMHYVbP2r+xwj5MfbUqTSXxLUncwzGN4fGAeWd
	 sxuqlHss3rMFZMVE2PQD7DGwlzpW+dck6cDCjqOOz3+mx3jRzH6XwHKEgzBesxBUgM
	 6rNF/uy60cOtsIZbcBgWgl7lOwjOwUvB2I6LCcfghNHhD4EYLk+a4lLqzR4RmJ/G/4
	 fsehpvDi/nuEQ==
Date: Thu, 29 Oct 2026 12:44:20 +0100
From: Lorenzo Bianconi <lorenzo@kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, nbd@nbd.name
Subject: Re: [PATCH nf-next 1/2] netfilter: flowtable: retrieve stats on flow
 deletion
Message-ID: <auMxlOnGotXBPVQL@lore-desk>
References: <20261029111431.179813-1-pablo@netfilter.org>
 <auMtIQQMWdjm4Bsp@lore-desk>
 <auMwgf0zvDXZ0j1b@chamomile>
 <auMw17-5vPBgaANa@lore-desk>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="Rhh3xHi2fden1JfU"
Content-Disposition: inline
In-Reply-To: <auMw17-5vPBgaANa@lore-desk>

--Rhh3xHi2fden1JfU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Oct 29, Lorenzo Bianconi wrote:
> On Oct 29, Pablo Neira Ayuso wrote:
> > On Thu, Oct 29, 2026 at 12:25:21PM +0100, Lorenzo Bianconi wrote:
> > > > Retrieve stats too when deleting a flow from hardware. Apparently, =
the
> > > > existing approach is missing last stats sync with the conntrack ent=
ry.
> > > > Pass the stats object to the driver so it has a chance to populate =
it
> > > > at deletion time. Drivers need to be updated to use this new approa=
ch.
> > > >=20
> > > > Reported-by: Valentin Berezhnoy <dreyksmail@gmail.com>
> > > > Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> > > > ---
> > > >  net/netfilter/nf_flow_table_offload.c | 43 ++++++++++++++++-------=
----
> > > >  1 file changed, 26 insertions(+), 17 deletions(-)
> > > >=20
> > > > diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/=
nf_flow_table_offload.c
> > > > index 4365859220e6..53182323f73c 100644
> > > > --- a/net/netfilter/nf_flow_table_offload.c
> > > > +++ b/net/netfilter/nf_flow_table_offload.c
> > > > @@ -934,6 +934,27 @@ static int nf_flow_offload_tuple(struct nf_flo=
wtable *flowtable,
> > > >  	return i;
> > > >  }
> > > > =20
> > > > +static void flow_offload_update_stats(struct flow_offload_work *of=
fload,
> > > > +				      struct flow_stats *stats)
> > > > +{
> > > > +	u64 lastused;
> > > > +
> > > > +	lastused =3D max_t(u64, stats[0].lastused, stats[1].lastused);
> > > > +	offload->flow->timeout =3D max_t(u64, offload->flow->timeout,
> > > > +				       lastused + flow_offload_get_timeout(offload->flow));
> > > > +
> > > > +	if (offload->flowtable->flags & NF_FLOWTABLE_COUNTER) {
> > > > +		if (stats[0].pkts)
> > > > +			nf_ct_acct_add(offload->flow->ct,
> > > > +				       FLOW_OFFLOAD_DIR_ORIGINAL,
> > > > +				       stats[0].pkts, stats[0].bytes);
> > > > +		if (stats[1].pkts)
> > > > +			nf_ct_acct_add(offload->flow->ct,
> > > > +				       FLOW_OFFLOAD_DIR_REPLY,
> > > > +				       stats[1].pkts, stats[1].bytes);
> > > > +	}
> > > > +}
> > > > +
> > > >  static int flow_offload_tuple_add(struct flow_offload_work *offloa=
d,
> > > >  				  struct nf_flow_rule *flow_rule,
> > > >  				  enum flow_offload_tuple_dir dir)
> > > > @@ -948,10 +969,13 @@ static int flow_offload_tuple_add(struct flow=
_offload_work *offload,
> > > >  static void flow_offload_tuple_del(struct flow_offload_work *offlo=
ad,
> > > >  				   enum flow_offload_tuple_dir dir)
> > > >  {
> > > > +	struct flow_stats stats[FLOW_OFFLOAD_DIR_MAX] =3D {};
> > > > +
> > > >  	nf_flow_offload_tuple(offload->flowtable, offload->flow, NULL, di=
r,
> > > >  			      offload->flowtable->priority,
> > > > -			      FLOW_CLS_DESTROY, NULL,
> > > > +			      FLOW_CLS_DESTROY, stats,
> > > >  			      &offload->flowtable->flow_block.cb_list);
> > >=20
> > > according to my understanding nf_flow_offload_tuple() copies the stat=
s just if
> > > cmd is set to FLOW_CLS_STATS, right? Should we just check if stats is=
 not NULL
> > > in nf_flow_offload_tuple() instead?
> >=20
> > I posted a v2 with:
> >=20
> >         if (cmd =3D=3D FLOW_CLS_STATS ||
> >             cmd =3D=3D FLOW_CLS_DESTROY)
> >=20
> > but I can post a v3 with.
> >=20
> >         if (stats)
> >=20
> > instead as you suggest.
>=20
> up to you, same for me. I guess you can add even add the support for airo=
ha.
>=20
> Regards,
> Lorenzo

off-topic:

Can I post new revision for flowtable sit support for nf-next even if net-n=
ext is
closed at the moment?

Regards,
Lorenzo

>=20
> >=20
> > > Regards,
> > > Lorenzo
> > >=20
> > > > +	flow_offload_update_stats(offload, stats);
> > > >  }
> > > > =20
> > > >  static int flow_offload_rule_add(struct flow_offload_work *offload,
> > > > @@ -1011,27 +1035,12 @@ static void flow_offload_tuple_stats(struct=
 flow_offload_work *offload,
> > > >  static void flow_offload_work_stats(struct flow_offload_work *offl=
oad)
> > > >  {
> > > >  	struct flow_stats stats[FLOW_OFFLOAD_DIR_MAX] =3D {};
> > > > -	u64 lastused;
> > > > =20
> > > >  	flow_offload_tuple_stats(offload, FLOW_OFFLOAD_DIR_ORIGINAL, &sta=
ts[0]);
> > > >  	if (test_bit(NF_FLOW_HW_BIDIRECTIONAL, &offload->flow->flags))
> > > >  		flow_offload_tuple_stats(offload, FLOW_OFFLOAD_DIR_REPLY,
> > > >  					 &stats[1]);
> > > > -
> > > > -	lastused =3D max_t(u64, stats[0].lastused, stats[1].lastused);
> > > > -	offload->flow->timeout =3D max_t(u64, offload->flow->timeout,
> > > > -				       lastused + flow_offload_get_timeout(offload->flow));
> > > > -
> > > > -	if (offload->flowtable->flags & NF_FLOWTABLE_COUNTER) {
> > > > -		if (stats[0].pkts)
> > > > -			nf_ct_acct_add(offload->flow->ct,
> > > > -				       FLOW_OFFLOAD_DIR_ORIGINAL,
> > > > -				       stats[0].pkts, stats[0].bytes);
> > > > -		if (stats[1].pkts)
> > > > -			nf_ct_acct_add(offload->flow->ct,
> > > > -				       FLOW_OFFLOAD_DIR_REPLY,
> > > > -				       stats[1].pkts, stats[1].bytes);
> > > > -	}
> > > > +	flow_offload_update_stats(offload, stats);
> > > >  }
> > > > =20
> > > >  static void flow_offload_work_handler(struct work_struct *work)
> > > > --=20
> > > > 2.47.3
> > > >=20
> >=20
> >=20



--Rhh3xHi2fden1JfU
Content-Type: application/pgp-signature; name=signature.asc

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCauMxlAAKCRA6cBh0uS2t
rG1pAP9yIxp0mvRXK25Q9WFdJi6ivFI8dx59qnT6Vei36inCfwD/ee3lG2FzGmLT
MDFmBs/Odit0qhTTT0ijKotu17QLvgs=
=71ba
-----END PGP SIGNATURE-----

--Rhh3xHi2fden1JfU--
