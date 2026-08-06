Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 955A24562B1
	for <netfilter-devel@vger.kernel.org>; Thu,  6 Aug 2026 14:35:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786026926; cv=none; b=GOk9pDXbEcUqd09GFW33GqZykdnK057woAB9Zm+2xLdCfJJvxmnTtMJQGqjkJuCMrpI8JzjYuXR8v1Bv4ztg27FqXmLTWXK+zz1vQL3M2LkgNUGx4pHC8OsEKkTezDIGFJp7JcAWi+qc0lR8eVheY7cWDyzlfSN+O4yl6GW0oPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786026926; c=relaxed/simple;
	bh=zA8Vo1hbZlfJG9KFRFWQ1F07cSWdHKnNyKaf8iC/B88=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VD3iw+VzFr3ZRgbDEmesXUELXU34nn3mNAjl8h35511ESzK7Q/hAsRfE4u0D2XXeMu1NdQQJ/tXWa65ibwmh+R56jQ0Qh05m5F39N2fpnteCJejm7hl6X8CSJIFXL9JYxSqLN0tA/Dt5ZmkXq6LPDsns5S9Yi50D3f3LPmllXV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=qRO9IhAa; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="qRO9IhAa"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 4F06E60191;
	Thu,  6 Aug 2026 16:35:14 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1786026914;
	bh=TsdX9Wp5GAriemYfCIFOmwZkfc6qs5ghZ5jOxfy2dKA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qRO9IhAakhXHRbPavk5RKvbvvlG+y/ZuEl38qQVkx+gO5FdeoZJF502bGqtoeYHrt
	 Sfd+xX08Ts+1aBrpHwzg9SABFGWse/vO1m+dFXLalMaGDtDh6sd4mN18Z7H/vxLnVG
	 BYu4r4bZjhsy/0VLsbdPBIYuswMIbdJHJ8tkf52bwZBoBMuixYi/V/eDAvrYFTpTBR
	 LA42ZWMZapxbkeJtozF+NE2XMkQierF4hsdQan5MCMME9oXn5Wdona+f5x82mWS16N
	 KSgOgOrwJLWAM50Q+KMa4TEpV0eBOjzNevBjQ36oWjQW1LfEo0mfslMmw/DXCBEAM8
	 cqh7kB1ROELGQ==
Date: Thu, 6 Aug 2026 16:35:10 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Fernando Fernandez Mancera <fmancera@suse.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf,v2 2/2] netfilter: nf_tables: call set ops .commit
 when building new ruleset
Message-ID: <anR_NQJ_mJdAuOie@chamomile>
References: <20260805171115.250749-1-pablo@netfilter.org>
 <20260805171115.250749-2-pablo@netfilter.org>
 <e57417f4-b586-400c-97ad-fce9f0b6d0aa@suse.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <e57417f4-b586-400c-97ad-fce9f0b6d0aa@suse.de>

Hi Fernando,

On Thu, Aug 06, 2026 at 12:30:14PM +0200, Fernando Fernandez Mancera wrote:
> On 8/5/26 7:11 PM, Pablo Neira Ayuso wrote:
> > The rbtree set only builds the b-search array after the new ruleset has
> > been exposed through set ops .commit.
> > 
> > This is currently needed by pipapo because it purges the elements from
> > the clone after the transactions are handled, therefore, pipapo still
> > needs the delayed set ops .commit call after the transaction handling.
> > 
> > Allow the rbtree to call .commit before the transaction handling which
> > purges the stale elements from the frontend rbtree datastructure.
> > 
> > Update rbtree .commit to skip deactivated and expired elements when
> > building the new b-search array.
> > 
> > Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> > ---
> > sashiko: there is a timestamp that prevents elements from expiring while
> > handling the transaction.
> > 
> > v2: - use NFT_GENMASK_ANY for GC scan, theoretically no new element in
> >        this transaction can expire while handling the transaction but
> >        let's just skip either new element or deactivated elements from
> >        the GC scan.
> >      - remove incorrect reset of previous rbe when performing GC scan.
> > 
> >   net/netfilter/nf_tables_api.c  |  9 ++++++--
> >   net/netfilter/nft_set_rbtree.c | 38 ++++++++++++++++++++++++++++------
> >   2 files changed, 39 insertions(+), 8 deletions(-)
> > 
> > diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> > index 90a379533e08..a7006725c307 100644
> > --- a/net/netfilter/nf_tables_api.c
> > +++ b/net/netfilter/nf_tables_api.c
> > @@ -10853,11 +10853,14 @@ static void nf_tables_commit_audit_log(struct list_head *adl, u32 generation)
> >   	}
> >   }
> > -static void nft_set_commit_update(struct nftables_pernet *nft_net)
> > +static void nft_set_commit_update(struct nftables_pernet *nft_net, bool early_commit)
> >   {
> >   	struct nft_set *set, *next;
> >   	list_for_each_entry_safe(set, next, &nft_net->set_update_list, pending_update) {
> > +		if (set->ops->abort_skip_removal && early_commit)
> > +			continue;
> > +
> 
> Hi Pablo,
> 
> wouldn't it be better to add the early_commit flag to set->ops? This way we
> don't need to check abort_skip_removal flag.
> 
> I could foresee problems in the future using the same flag for this skip..
> 
> What about creating a nft_commit_phase enum:
> 
> enum nft_commit_phase {
> 	NFT_COMMIT_PHASE_EARLY,
> 	NFT_COMMIT_PHASE_DELAYED,
> };
> 
> and then we can use it in nft_set_commit_update() as argument, something
> like:
> 
> static void nft_set_commit_update(struct nftables_pernet *nft_net,
>                                   enum nft_commit_phase phase)
> 
> This way, early_commit makes sense on set->ops..
> 
> What do you think? I am trying to think in a way to make the code more
> readable.

The (ab)use of ->abort_skip_removal is hack to address the reported
regression with minimal changes.

I can add an .early_commit interface instead, but where I want to go
is to move .commit before transaction handling, but pipapo needs to be
revisited to make it. Because pipapo has the same issue reported here:

https://lore.kernel.org/netfilter-devel/589d243b-3d88-4138-9786-1bbb4347e79d@app.fastmail.com/

The update for pipapo would be targetted at the nf-next.

I can add a .early_commit, that would be cleaner and it is not a lot
more code.

Eventually, .early_commit will just become .commit once pipapo becomes
safe to be used before transaction handling.
