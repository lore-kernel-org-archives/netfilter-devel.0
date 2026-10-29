Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793273990;
	b=hF3XZTV6XwicrVdrN5yBcf1Z2i1d9DBDtJ+2NEGmKI6HNzcFCNLG0pOwX58+8FoDsPWr
	 VRPpjYWwK0wq1aZu76gMZhW9dGfzhv+B522R+b2LtExb2NSBGq0AcMP0J/e9Qys7BfjTh
	 4Nuezf/0rO+Jm/pQE76LEC8WRH87tz+e2RNCczRuxPD4GSnLtuKcmAVxRff2e0FEyZgVC
	 /5nw0FL+Osjvq2tzwq95vjaZy6RPlnAZqH1ZJkVqxnUQPfL49Hk/KUB0tNfoPh3aQiaVG
	 muekX62kmp/S73hyZH8y+Z1/duPujU+1DnSagXiJ1B+X2UzY7FgnMSEnWZVIvK05lrw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793273990;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Spam-Status:X-Spam-Checker-Version;
	bh=4qVIOp3pmSiZqTITEOaG/PxMYpI/KqERZzyZkg4DJ+0=;
	b=d8WyBL+y0foPxhpC39HK9tkfABIfcF1Kn6pYRnzFHBS9XWWirJ/6qo5zUIBad8j+y/lf
	 Wa7G4HR0JqplvbE4DnqPRj36N7aHaKSvda50wnqMpbfc78RS5EfAsrtzewRETC/hD5J6r
	 9NKkcAMZ3zocnVrIH9iTkjyLkk/UpSp9sRrKFKnXvD4O9p4Itbt1xRPebF9HoAZWgYQXZ
	 Id6BAz6J+6QomKnXbx6WY29EzVtGF1AMZp5iW5CMHiNWn7PpGM2778v5dekcl6XMWxCgx
	 j+pLG3IdtJn/gATEdXKuQU7cUzDrNmEEE4LKXL/SeYlmDDfjTQqC9py6bXMdUsMHIXg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=QpKASpZz;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 9DE1B606A31A
	for <netfilter-devel@vger.kernel.org>; Thu, 29 Oct 2026 11:39:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9DE1B606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=QpKASpZz
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1793273987;
	bh=4qVIOp3pmSiZqTITEOaG/PxMYpI/KqERZzyZkg4DJ+0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QpKASpZzG3a4ryCF2cMHPWm3SztitozsefuPoLV0v6toCNepCHRxHPRF2MjCXg2wQ
	 CZVrA0otJ+JP9Y37CIMRoAxQVPntQtGxO9tDkovpOlsxlaPzm+EvLzQlebCk4O/EiP
	 0K6sB3TkuhxSDOgMWLuINnFdUTUumodyNsEhPYfZOOgOotftIxxxejkwZydrJ2QXRs
	 w4j2a+UtNLfjaRbU9zF7VIGhRF+9rinaJwkKHukMkp8kyc8q32u3gpGvQzM/j09gpi
	 sIk8Gze5U9mU1BvO6gkv8Aj59B3jw2ptge/Bxcn171Im7Byle0WvykK6Q1u/waUYZV
	 bLWZ6ASN2XcUg==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 91BB86007B;
	Thu, 29 Oct 2026 12:39:47 +0100 (CET)
Date: Thu, 29 Oct 2026 12:39:45 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Lorenzo Bianconi <lorenzo@kernel.org>
Cc: netfilter-devel@vger.kernel.org, nbd@nbd.name
Subject: Re: [PATCH nf-next 1/2] netfilter: flowtable: retrieve stats on flow
 deletion
Message-ID: <auMwgf0zvDXZ0j1b@chamomile>
References: <20261029111431.179813-1-pablo@netfilter.org>
 <auMtIQQMWdjm4Bsp@lore-desk>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <auMtIQQMWdjm4Bsp@lore-desk>

On Thu, Oct 29, 2026 at 12:25:21PM +0100, Lorenzo Bianconi wrote:
> > Retrieve stats too when deleting a flow from hardware. Apparently, the
> > existing approach is missing last stats sync with the conntrack entry.
> > Pass the stats object to the driver so it has a chance to populate it
> > at deletion time. Drivers need to be updated to use this new approach.
> > 
> > Reported-by: Valentin Berezhnoy <dreyksmail@gmail.com>
> > Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> > ---
> >  net/netfilter/nf_flow_table_offload.c | 43 ++++++++++++++++-----------
> >  1 file changed, 26 insertions(+), 17 deletions(-)
> > 
> > diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
> > index 4365859220e6..53182323f73c 100644
> > --- a/net/netfilter/nf_flow_table_offload.c
> > +++ b/net/netfilter/nf_flow_table_offload.c
> > @@ -934,6 +934,27 @@ static int nf_flow_offload_tuple(struct nf_flowtable *flowtable,
> >  	return i;
> >  }
> >  
> > +static void flow_offload_update_stats(struct flow_offload_work *offload,
> > +				      struct flow_stats *stats)
> > +{
> > +	u64 lastused;
> > +
> > +	lastused = max_t(u64, stats[0].lastused, stats[1].lastused);
> > +	offload->flow->timeout = max_t(u64, offload->flow->timeout,
> > +				       lastused + flow_offload_get_timeout(offload->flow));
> > +
> > +	if (offload->flowtable->flags & NF_FLOWTABLE_COUNTER) {
> > +		if (stats[0].pkts)
> > +			nf_ct_acct_add(offload->flow->ct,
> > +				       FLOW_OFFLOAD_DIR_ORIGINAL,
> > +				       stats[0].pkts, stats[0].bytes);
> > +		if (stats[1].pkts)
> > +			nf_ct_acct_add(offload->flow->ct,
> > +				       FLOW_OFFLOAD_DIR_REPLY,
> > +				       stats[1].pkts, stats[1].bytes);
> > +	}
> > +}
> > +
> >  static int flow_offload_tuple_add(struct flow_offload_work *offload,
> >  				  struct nf_flow_rule *flow_rule,
> >  				  enum flow_offload_tuple_dir dir)
> > @@ -948,10 +969,13 @@ static int flow_offload_tuple_add(struct flow_offload_work *offload,
> >  static void flow_offload_tuple_del(struct flow_offload_work *offload,
> >  				   enum flow_offload_tuple_dir dir)
> >  {
> > +	struct flow_stats stats[FLOW_OFFLOAD_DIR_MAX] = {};
> > +
> >  	nf_flow_offload_tuple(offload->flowtable, offload->flow, NULL, dir,
> >  			      offload->flowtable->priority,
> > -			      FLOW_CLS_DESTROY, NULL,
> > +			      FLOW_CLS_DESTROY, stats,
> >  			      &offload->flowtable->flow_block.cb_list);
> 
> according to my understanding nf_flow_offload_tuple() copies the stats just if
> cmd is set to FLOW_CLS_STATS, right? Should we just check if stats is not NULL
> in nf_flow_offload_tuple() instead?

I posted a v2 with:

        if (cmd == FLOW_CLS_STATS ||
            cmd == FLOW_CLS_DESTROY)

but I can post a v3 with.

        if (stats)

instead as you suggest.

> Regards,
> Lorenzo
> 
> > +	flow_offload_update_stats(offload, stats);
> >  }
> >  
> >  static int flow_offload_rule_add(struct flow_offload_work *offload,
> > @@ -1011,27 +1035,12 @@ static void flow_offload_tuple_stats(struct flow_offload_work *offload,
> >  static void flow_offload_work_stats(struct flow_offload_work *offload)
> >  {
> >  	struct flow_stats stats[FLOW_OFFLOAD_DIR_MAX] = {};
> > -	u64 lastused;
> >  
> >  	flow_offload_tuple_stats(offload, FLOW_OFFLOAD_DIR_ORIGINAL, &stats[0]);
> >  	if (test_bit(NF_FLOW_HW_BIDIRECTIONAL, &offload->flow->flags))
> >  		flow_offload_tuple_stats(offload, FLOW_OFFLOAD_DIR_REPLY,
> >  					 &stats[1]);
> > -
> > -	lastused = max_t(u64, stats[0].lastused, stats[1].lastused);
> > -	offload->flow->timeout = max_t(u64, offload->flow->timeout,
> > -				       lastused + flow_offload_get_timeout(offload->flow));
> > -
> > -	if (offload->flowtable->flags & NF_FLOWTABLE_COUNTER) {
> > -		if (stats[0].pkts)
> > -			nf_ct_acct_add(offload->flow->ct,
> > -				       FLOW_OFFLOAD_DIR_ORIGINAL,
> > -				       stats[0].pkts, stats[0].bytes);
> > -		if (stats[1].pkts)
> > -			nf_ct_acct_add(offload->flow->ct,
> > -				       FLOW_OFFLOAD_DIR_REPLY,
> > -				       stats[1].pkts, stats[1].bytes);
> > -	}
> > +	flow_offload_update_stats(offload, stats);
> >  }
> >  
> >  static void flow_offload_work_handler(struct work_struct *work)
> > -- 
> > 2.47.3
> > 


