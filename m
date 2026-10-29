Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793274075;
	b=1QC/wWvRQ04YfLT/3bJfV4xk2POktQZwoDyasf7k1gVG1zGZrORHFKsqvwDqkged3XEX
	 U7tN4LDRY+SMzHBMX5juEvx9yUUhNthHOoDdko5wdKqlWcAlQiyF8J4n6vAjmt+QnS7Is
	 n8vU72wAXJLXk1VaRvh4kblRUzg7p3xJ+d6dSCvNtR8mDLuaNVLUEC42ivn0vqtauAWqO
	 i+FtGyNkTPm4pr0j8Gz5G6iMqb+CC5S80xgNJHMFpGvRT29jyjOd30xmrKxv0P3aLSrIh
	 2tRQzgX94ygcAtv626PXpv3r28+kOOZd4XarRL3Myij2IJvfTvmy+DfGuoLZ65JsgtA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793274075;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=cQZ7MoWr5D+5HWQ355UBX4Sl5tIOQxNVmleAosnG+q0=;
	b=4klpYZY2HYaKxRE50p63sHe6mqWE0HURfxdq9MbKh7ujXCpHq2td9IxyJdyIGI1hGspG
	 jbPhfxK2jySq6ENFi8JIApyCWOgGSO7K5gMNvKqKYyD+asCZhl/Phn98WwJKCsmsUBBD4
	 qStXSPWhHjzbXCVhQdfeWJC9KFMa59rqdkrlkd/y2EsjdFXARFn5ZtpaVCdrVQzFH176a
	 g2lFjNTiDuIX6jCDh0T0hm8VjfOy4puiYYvCvXmWra5rTIaHU7m8NMpmwCpdlviWEsTqb
	 /++HntwkDoXtXtjbZ2G4v253/IbgZZmOD/IHK1w4s5WXB05fp0c/pdh4Gu+YuPgOfmA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hzV+x9lQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9D3E606A31A
	for <netfilter-devel@vger.kernel.org>; Thu, 29 Oct 2026 11:41:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hzV+x9lQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E26EB1F01825;
	Thu, 29 Oct 2026 11:41:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793274074;
	bh=cQZ7MoWr5D+5HWQ355UBX4Sl5tIOQxNVmleAosnG+q0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=hzV+x9lQa8n9hD5UloixRWjJx6d9OeSMFVdkeQqpGFa6yapnZL5qYn6C4M1ljYF5e
	 YnXgS6jekAJfHKWX58kIjgm/gcrSKbmi+dJeMqrT71cEL9WTkB6emZ3NnR9crm9FcA
	 FpqUewa9tR0rieJliCCvKXm8cUPFo8KCRPtk11MBEVXfNnklSOKerIQLzXa4OCyz4T
	 ri2ghfKGE0v6qjuI6rPB4g96Np0WkMqCol86f4UJHbKRu7MEoVh4cdAVpNh4aXEiDE
	 xYB24TKT2IDyBsbCY6p9d0pDKH/w1Sx2OfF02OBIGC9gdbEduaZEJSSq2bMu3/DYds
	 L1CmItsQsEWCw==
Date: Thu, 29 Oct 2026 12:41:11 +0100
From: Lorenzo Bianconi <lorenzo@kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, nbd@nbd.name
Subject: Re: [PATCH nf-next 1/2] netfilter: flowtable: retrieve stats on flow
 deletion
Message-ID: <auMw17-5vPBgaANa@lore-desk>
References: <20261029111431.179813-1-pablo@netfilter.org>
 <auMtIQQMWdjm4Bsp@lore-desk>
 <auMwgf0zvDXZ0j1b@chamomile>
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
	protocol="application/pgp-signature"; boundary="3csC/GiQ7XwfnWcx"
Content-Disposition: inline
In-Reply-To: <auMwgf0zvDXZ0j1b@chamomile>

--3csC/GiQ7XwfnWcx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Oct 29, Pablo Neira Ayuso wrote:
> On Thu, Oct 29, 2026 at 12:25:21PM +0100, Lorenzo Bianconi wrote:
> > > Retrieve stats too when deleting a flow from hardware. Apparently, the
> > > existing approach is missing last stats sync with the conntrack entry.
> > > Pass the stats object to the driver so it has a chance to populate it
> > > at deletion time. Drivers need to be updated to use this new approach.
> > >=20
> > > Reported-by: Valentin Berezhnoy <dreyksmail@gmail.com>
> > > Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> > > ---
> > >  net/netfilter/nf_flow_table_offload.c | 43 ++++++++++++++++---------=
--
> > >  1 file changed, 26 insertions(+), 17 deletions(-)
> > >=20
> > > diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf=
_flow_table_offload.c
> > > index 4365859220e6..53182323f73c 100644
> > > --- a/net/netfilter/nf_flow_table_offload.c
> > > +++ b/net/netfilter/nf_flow_table_offload.c
> > > @@ -934,6 +934,27 @@ static int nf_flow_offload_tuple(struct nf_flowt=
able *flowtable,
> > >  	return i;
> > >  }
> > > =20
> > > +static void flow_offload_update_stats(struct flow_offload_work *offl=
oad,
> > > +				      struct flow_stats *stats)
> > > +{
> > > +	u64 lastused;
> > > +
> > > +	lastused =3D max_t(u64, stats[0].lastused, stats[1].lastused);
> > > +	offload->flow->timeout =3D max_t(u64, offload->flow->timeout,
> > > +				       lastused + flow_offload_get_timeout(offload->flow));
> > > +
> > > +	if (offload->flowtable->flags & NF_FLOWTABLE_COUNTER) {
> > > +		if (stats[0].pkts)
> > > +			nf_ct_acct_add(offload->flow->ct,
> > > +				       FLOW_OFFLOAD_DIR_ORIGINAL,
> > > +				       stats[0].pkts, stats[0].bytes);
> > > +		if (stats[1].pkts)
> > > +			nf_ct_acct_add(offload->flow->ct,
> > > +				       FLOW_OFFLOAD_DIR_REPLY,
> > > +				       stats[1].pkts, stats[1].bytes);
> > > +	}
> > > +}
> > > +
> > >  static int flow_offload_tuple_add(struct flow_offload_work *offload,
> > >  				  struct nf_flow_rule *flow_rule,
> > >  				  enum flow_offload_tuple_dir dir)
> > > @@ -948,10 +969,13 @@ static int flow_offload_tuple_add(struct flow_o=
ffload_work *offload,
> > >  static void flow_offload_tuple_del(struct flow_offload_work *offload,
> > >  				   enum flow_offload_tuple_dir dir)
> > >  {
> > > +	struct flow_stats stats[FLOW_OFFLOAD_DIR_MAX] =3D {};
> > > +
> > >  	nf_flow_offload_tuple(offload->flowtable, offload->flow, NULL, dir,
> > >  			      offload->flowtable->priority,
> > > -			      FLOW_CLS_DESTROY, NULL,
> > > +			      FLOW_CLS_DESTROY, stats,
> > >  			      &offload->flowtable->flow_block.cb_list);
> >=20
> > according to my understanding nf_flow_offload_tuple() copies the stats =
just if
> > cmd is set to FLOW_CLS_STATS, right? Should we just check if stats is n=
ot NULL
> > in nf_flow_offload_tuple() instead?
>=20
> I posted a v2 with:
>=20
>         if (cmd =3D=3D FLOW_CLS_STATS ||
>             cmd =3D=3D FLOW_CLS_DESTROY)
>=20
> but I can post a v3 with.
>=20
>         if (stats)
>=20
> instead as you suggest.

up to you, same for me. I guess you can add even add the support for airoha.

Regards,
Lorenzo

>=20
> > Regards,
> > Lorenzo
> >=20
> > > +	flow_offload_update_stats(offload, stats);
> > >  }
> > > =20
> > >  static int flow_offload_rule_add(struct flow_offload_work *offload,
> > > @@ -1011,27 +1035,12 @@ static void flow_offload_tuple_stats(struct f=
low_offload_work *offload,
> > >  static void flow_offload_work_stats(struct flow_offload_work *offloa=
d)
> > >  {
> > >  	struct flow_stats stats[FLOW_OFFLOAD_DIR_MAX] =3D {};
> > > -	u64 lastused;
> > > =20
> > >  	flow_offload_tuple_stats(offload, FLOW_OFFLOAD_DIR_ORIGINAL, &stats=
[0]);
> > >  	if (test_bit(NF_FLOW_HW_BIDIRECTIONAL, &offload->flow->flags))
> > >  		flow_offload_tuple_stats(offload, FLOW_OFFLOAD_DIR_REPLY,
> > >  					 &stats[1]);
> > > -
> > > -	lastused =3D max_t(u64, stats[0].lastused, stats[1].lastused);
> > > -	offload->flow->timeout =3D max_t(u64, offload->flow->timeout,
> > > -				       lastused + flow_offload_get_timeout(offload->flow));
> > > -
> > > -	if (offload->flowtable->flags & NF_FLOWTABLE_COUNTER) {
> > > -		if (stats[0].pkts)
> > > -			nf_ct_acct_add(offload->flow->ct,
> > > -				       FLOW_OFFLOAD_DIR_ORIGINAL,
> > > -				       stats[0].pkts, stats[0].bytes);
> > > -		if (stats[1].pkts)
> > > -			nf_ct_acct_add(offload->flow->ct,
> > > -				       FLOW_OFFLOAD_DIR_REPLY,
> > > -				       stats[1].pkts, stats[1].bytes);
> > > -	}
> > > +	flow_offload_update_stats(offload, stats);
> > >  }
> > > =20
> > >  static void flow_offload_work_handler(struct work_struct *work)
> > > --=20
> > > 2.47.3
> > >=20
>=20
>=20

--3csC/GiQ7XwfnWcx
Content-Type: application/pgp-signature; name=signature.asc

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCauMw1wAKCRA6cBh0uS2t
rLIyAQDbkQANE/XF6IEJUWNLEgMHxRJNNRNvu/6zb43dlYb/qAEAuKDQNgRibhRE
kDkhsHxHF0YUgE1sl8FBhgyOcDhm2gQ=
=FsU+
-----END PGP SIGNATURE-----

--3csC/GiQ7XwfnWcx--
