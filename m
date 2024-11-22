Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3BAC5223
	for <netfilter-devel@vger.kernel.org>; Fri, 22 Nov 2024 13:35:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732282540; cv=none; b=tkCWj1KoD/Pk0WVJJxg5FL7JlWvs91V8Q9ISyIuV40lwI8iS+lyka+PGsFMOGKgBsb2EK3SwJ8drvNUM/tAjCcbgsE4DPcqSmnTfSz156cp7sNlScUzeCoACJ+JSmMjk/CehtsH4lCsh3krycHNRfBjO6GUCfLPKLHuCXlGL/Ko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732282540; c=relaxed/simple;
	bh=Hbf23LWnQPUnlTRYszsHVxlOW3NMPjUUR5Wd7mOtFYY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JuyH2conrqWk2lep5aXiJX04/x/9QvdolbbXV4jjBG6qMsU2aBohgl30sSEU3wXXeijyvNz6JcSqbqiyuVKWK0zvCERWSrmNdeJYQ3rdt58cWBZNK5C7Hu2QwIGi4Pm4Bj1cr1t6dXVtplZCFfiPFt3eYCziza46oFw2gDCFLPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.39.247] (port=41344 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1tEToj-000jAV-Uy; Fri, 22 Nov 2024 14:35:28 +0100
Date: Fri, 22 Nov 2024 14:35:24 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft 2/2] debug: include kernel set information on cache
 fill
Message-ID: <Z0CInEpuxYA1bxFq@calendula>
References: <20241120100221.11001-1-fw@strlen.de>
 <20241120100221.11001-2-fw@strlen.de>
 <Zz5w6NPQ2XsJrpHG@calendula>
 <20241120233854.GB31921@breakpoint.cc>
 <20241121092427.GA12619@breakpoint.cc>
 <Zz8EzBW2kzaq4jXr@calendula>
 <20241121120242.GB12619@breakpoint.cc>
 <Zz9N4CmuiLxQpaAH@calendula>
 <20241121171957.GA25690@breakpoint.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20241121171957.GA25690@breakpoint.cc>
X-Spam-Score: -1.9 (-)

Hi Florian,

On Thu, Nov 21, 2024 at 06:19:57PM +0100, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > AFAICS we only need to update < 10 dump files,
> > > so churn is not too bad.
> > >
> > > Alternative is to always store postprocessed
> > > dumps and then always run sed before diff, but I think
> > > its better to do the extra mile.
> > 
> > rbtree going leaks a raw count of independent interval values which is
> > going to be awkward to the user.
> 
> Sure, wasn't that the reason why you iniitially wanted to restrict this to
> --netlink=debug?  What made you change your mind?

With large garbage collection cycle, this counter provides a hint to
the user to understand that slots are still being consumed by expired
elements.

> Maybe apply the simpler, existing v1 patches only, i.e. no exposure?

My concern is that this is exposing this implementation detail of the
rbtree, forever. Can we agree to do heuristics to hide this detail:

Assuming initial 0.0.0.0 dummy element is in place (this can be
subtracted), then, division by two gives us the number of ranges.

> I can just send a v2 with the new attribute names and no getter for
> libnftnl.

Thanks.
