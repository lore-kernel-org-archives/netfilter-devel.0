Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07CD778696
	for <netfilter-devel@vger.kernel.org>; Mon,  4 Mar 2024 18:39:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709577602; cv=none; b=cLYoecbdCsIuEApnPfj5+tzhybjW6QWRfovE/op1r0lkOEbjm1JJxemC6ypXvAoMrpuOpgRg8RmtQfRhxChF0B9gCFghdSqAMVBVJtm5xiOAQInqjBurmOPtFzeSTcN6LYWzHouLHWoCvxXkXeVhzSVcFVGgfKAz/bY9ma4FSqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709577602; c=relaxed/simple;
	bh=wfJd2E9ndLCVuje2navW4QMYRgFVA6mtOAqXiL4tMvw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UEiSjTdE8NkLkM6ljgWl1jFEVlTM+HP0iy/tk6U5HWzrbvOPixnWntfJQaYLWhaYYRENJzPD3itWJd60UmxQj7CuZSKZCStL2nJjTow25BzMnLcRRXwQoJdw5xck5aP4ArZsESP93STAlj1ShKD3K5tjzvSwoyUzXAnZNnSWkCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.33.11] (port=53718 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1rhDEB-00CeUx-VU; Mon, 04 Mar 2024 19:39:58 +0100
Date: Mon, 4 Mar 2024 19:39:54 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: nf_tables: mark set as dead when
 deactivating anonymous set
Message-ID: <ZeYVeh9AjJ4r-wxf@calendula>
References: <20240304175306.145996-1-pablo@netfilter.org>
 <20240304182227.GB19146@breakpoint.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240304182227.GB19146@breakpoint.cc>
X-Spam-Score: -1.9 (-)

On Mon, Mar 04, 2024 at 07:22:27PM +0100, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > While the rhashtable set gc runs asynchronously, a race allows it to
> > collect elements from an anonymous set while it is being released from
> > the abort path. This also seems possible from the rule error path.
> > 
> > Mingi Cho originally reported this issue in a different path in 6.1.x
> > with a pipapo set with low timeouts which is not possible upstream since
> > 7395dfacfff6 ("netfilter: nf_tables: use timestamp to check for set
> > element timeout").
> > 
> > Fix this by setting on the dead flag to signal set gc to skip anonymous
> > sets from prepare_error, abort and commit paths.
> 
> This seems to contradict what patch is doing, the flag gets toggled for
> all set types.

Setting set->dead for non-anonymous sets break those that remain in place.
This needs a v2.

> > Cc: stable@vger.kernel.org
> > Fixes: 5f68718b34a5 ("netfilter: nf_tables: GC transaction API to avoid race with control plane")
> > Reported-by: Mingi Cho <mgcho.minic@gmail.com>
> > Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> > ---
> >  net/netfilter/nf_tables_api.c | 2 ++
> >  1 file changed, 2 insertions(+)
> > 
> > diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> > index ca54d4c23123..26d33ce3b682 100644
> > --- a/net/netfilter/nf_tables_api.c
> > +++ b/net/netfilter/nf_tables_api.c
> > @@ -5513,6 +5513,7 @@ void nf_tables_deactivate_set(const struct nft_ctx *ctx, struct nft_set *set,
> >  			list_del_rcu(&binding->list);
> >  
> >  		nft_use_dec(&set->use);
> > +		set->dead = 1;
> >  		break;
> >  	case NFT_TRANS_PREPARE:
> >  		if (nft_set_is_anonymous(set)) {
> > @@ -5534,6 +5535,7 @@ void nf_tables_deactivate_set(const struct nft_ctx *ctx, struct nft_set *set,
> >  	default:
> >  		nf_tables_unbind_set(ctx, set, binding,
> >  				     phase == NFT_TRANS_COMMIT);
> > +		set->dead = 1;
> 
> Shouldn't that be restricted to nf_tables_unbind_set() anonymous-set
> branch?

Right, thanks for reviewing.

Preparing v2.
