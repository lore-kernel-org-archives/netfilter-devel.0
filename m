Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99ED133A717
	for <netfilter-devel@vger.kernel.org>; Tue, 10 Mar 2026 17:39:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773164376; cv=none; b=Xoj2Ah8/0ue3ESXSKT8A4vutMmRP0hmuMgkAq76wIH3pwPh+0I14h+FzV9nTnO8zGAD4hriHGQnMkp+E8ZOOPEftVf/0j+4yz3KrmEZriQhYEVHBXXKDK7T5C+A2/dYLKVlQQOR3MKDPcKODE0bmFz/bVK/zssE7DvkEKGbroX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773164376; c=relaxed/simple;
	bh=FsRNjcVaKBsi7TyUdwUoOcPi+Pm0JE9XjWZ492SxO/c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jLZpIzUX7nBEehMIwiCl+nZSwHF2O/bfzlQol6DZZZouk69PzCV37JJGn3H3+YL2QQQ/KTl2uNNIfXEgV3lzoCbPytfPOF+NZOe9Y2V8W4ERBmkckHQz/oe9/jIQhYl42yj+Aa3Xwj1ESeCEUgeZrpODhnEAPQPnGZQmG4Lr4wg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id B598560516; Tue, 10 Mar 2026 18:39:33 +0100 (CET)
Date: Tue, 10 Mar 2026 18:39:34 +0100
From: Florian Westphal <fw@strlen.de>
To: Stefano Brivio <sbrivio@redhat.com>
Cc: netfilter-devel@vger.kernel.org, Yiming Qian <yimingqian591@gmail.com>
Subject: Re: [PATCH v2 nf] netfilter: nft_set_pipapo: split gc in unlink and
 reclaim phase
Message-ID: <abBXVm9Fh1ZjkKG6@strlen.de>
References: <20260304053611.15197-1-fw@strlen.de>
 <20260310170221.086297b2@elisabeth>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260310170221.086297b2@elisabeth>

Stefano Brivio <sbrivio@redhat.com> wrote:
> Sorry for the late review. Just one (perhaps dumb) question:

No problem, thanks for reviewing.

> >  	struct nft_pipapo *priv = nft_set_priv(set);
> >  	struct net *net = read_pnet(&set->net);
> > @@ -1697,6 +1697,8 @@ static void pipapo_gc(struct nft_set *set, struct nft_pipapo_match *m)
> >  	if (!gc)
> >  		return;
> >  
> > +	list_add(&gc->list, &priv->gc_head);
> 
> ...is there a reason why we need to do this unconditionally, or could
> we do this opportunistically if (__nft_set_elem_expired(&e->ext,
> tstamp)) below, including the nft_trans_gc_alloc() call?

Yes, its to make sure we run the catchall gc, which is external
to the pipapo core datastructure.

I admit we could be more clever and try to supress this
gc container allocation, but I preferred to keep it simpler for now.
