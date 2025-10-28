Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33209340DA0
	for <netfilter-devel@vger.kernel.org>; Tue, 28 Oct 2025 17:26:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761672416; cv=none; b=A6KuRKZAA/z5c+uYKBfem9jHGkaWEOCtQRHCFGjZPLMeYeo+SRTD7IZ3atqQboIRYWO5+p1/CHigjegTefUIHNC+2fhNJ0PjUL7WNT3KPXKFqsa20qSAgve8yhsPVm13CBtS8BffYP4oAkV9HEFj7Pj4Tj5BXDUjV0WqOzW0y18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761672416; c=relaxed/simple;
	bh=jg+uL56XzfLvfrYBd1QD0j44/cnnlRta+//u2kH4V28=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CQpl1nAD3nBEYOM4tUaZ3IdK1MYivMrslQQouFaBlIWB+GheUi4wjOnh49rLUQVI6ypaJSUdwp4o0UanUYibqXyKQrQTPdMtWveweZ9cwN9fWiLkvqTs6VKQ/msD6jJTXbsACRwP/WmpTaVubAiYrxxOGGviQ/2DtXavuw5wwtY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 8C7136015E; Tue, 28 Oct 2025 18:26:52 +0100 (CET)
Date: Tue, 28 Oct 2025 18:26:47 +0100
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Fernando Fernandez Mancera <fmancera@suse.de>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	louis.t42@caramail.com
Subject: Re: [PATCH nf] netfilter: nft_connlimit: fix duplicated tracking of
 a connection
Message-ID: <aQD810keSBweNG66@strlen.de>
References: <20251027125730.3864-1-fmancera@suse.de>
 <aQD2R1fQSJtMmTJc@calendula>
 <aQD4J7pI-Fz1V3eC@strlen.de>
 <aQD5PUkG7M_sqUAv@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aQD5PUkG7M_sqUAv@calendula>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Tue, Oct 28, 2025 at 06:06:47PM +0100, Florian Westphal wrote:
> > Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > > -	if (nf_conncount_add(nft_net(pkt), priv->list, tuple_ptr, zone)) {
> > > > -		regs->verdict.code = NF_DROP;
> > > > -		return;
> > > > +	if (ctinfo == IP_CT_NEW) {
> > > 
> > > Quick question: Is this good enough to deal with retransmitted packets
> > > while in NEW state?
> > 
> > Good point, I did not consider retransmit case.
> > What about if (!nf_ct_is_confirmed(ct)) { ..?
> > 
> > Would need a small comment that this is there instead of NEW
> > check due to rexmit.
> > 
> > > > +		if (nf_conncount_add(nft_net(pkt), priv->list, tuple_ptr, zone)) {
> > > > +			regs->verdict.code = NF_DROP;
> > > > +			return;
> > > > +		}
> > > > +	} else {
> > > > +		local_bh_disable();
> > > > +		nf_conncount_gc_list(nft_net(pkt), priv->list);
> > > > +		local_bh_enable();
> > > >  	}
> > 
> > As this needs a respin anyway, what about removing the else
> > clause altogether?  Resp. what was the rationale for doing a gc call
> > here?
> 
> You mean, call gc for both cases, correct?

No, i meant this:

/* comment that explains this */
if (nf_ct_is_confirmed(ct))
	return;

if (nf_conncount_add(nft_net(pkt), priv->list, tuple_ptr, zone)) {
	regs->verdict.code = NF_DROP;
	return;
}

As we don't add anything for 'is confirmed' case, I don't see why
we would need to prune the existing list.

> > And, do we want same check in xt_connlimit?
> 
> Are you referring to the !nf_ct_is_confirmed() check?

Yes, AFAICS xt_connlimit has same issue as nft_conncount given
they use same backend.

Backend doesn't have access to nf_conn/ctinfo so no way to solve it there.
