Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E31115381F
	for <netfilter-devel@vger.kernel.org>; Tue, 18 Jun 2024 09:31:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718703101; cv=none; b=EgdCElM/mBRzLio5NmT879UKCQ7xRKa/ROa0I5L20R1l+0xNytZ6j35SAZavAgt0i54mF06PxhDvBEVHnx5rN/wAHY1zgprrLYuM1Tjzeh+q2G3k6uXhAwAJDr69aloy85albJisuCCHb46Q7hITYs0ENkooCf8KUA8tpveACqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718703101; c=relaxed/simple;
	bh=ngkfsmUl2liKiG8YCFD+nUQK7c40awoQWgHikrEjtSg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QJO6Hk+f1JwK/4/L+VkpzaYK7xcZy/1UcEWpELnVNe7VM2Pja2/4+21wCXfItM2ZqR2FKW7EeiiR4vWWwX/7zZ348s5LGsNA8tmUhVl0kBvagk4Kn2Z9IC9TdTrX9HzREd1L/5WvSAVFN6w8zYubbS4e+V8GkJlHRWdaqJmSgNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1sJVBf-0002I2-E1; Tue, 18 Jun 2024 11:31:35 +0200
Date: Tue, 18 Jun 2024 11:31:35 +0200
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: let nftables indicate incomplete dissections
Message-ID: <20240618093135.GC12262@breakpoint.cc>
References: <20240612075013.GA13354@breakpoint.cc>
 <ZnFBQmrX9FgTG8rb@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZnFBQmrX9FgTG8rb@calendula>
User-Agent: Mutt/1.10.1 (2018-07-13)

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > If backend (libnftl) could mark expressions as incomplete (from .parse
> > callbacks?), it would be then possible for the frontend (nft) to document
> > this, e.g. by adding something like "# unknown attributes", or similar.
> 
> ack, how do you plan to handle this?

Add a "bool incomplete" to libnftnl strnct nftnl_expr, then set it
from each expr->parse callback if there is a new netlink attribute that
we did not understand.

nft then checks if this is incomplete-marker is set.

> > Related problem: entity that is using the raw netlink interface, it
> > that case libnftnl might be able to parse everything but nft could
> > lack the ability to properly print this.
> 
> There are two options here:
> 
> - Add more raw expressions and dump them, eg. meta@15, where 15 is the type.
>   This is more compact. If there is a requirement to allow to restore
>   this from older nftables versions, then it might be not enough since
>   maybe there is a need for meta@type,somethingelse (as in the ct direction
>   case).

Yes, for attributes that libnftnl knows about but where nft lacks a name
mapping (i.e., we can decode its META_KEY 0x42 but we have no idea what
that means we could in fact add such a representation scheme.

> - Use a netlink representation as raw expression: meta@1,3,0x0x000000004
>   but this requires dumping the whole list of attributes which is chatty.

Yes.  Perhaps its better to consider adding a new tool (script?) that
can dump the netlink soup without interpretation.  IIRC libmnl debug
already provides this functionality.

Very chatty but it would be good enough to figure out what such
hypothetical raw client did.

> Or explore a combination of both.

Right.

> I am telling all this because I suspect maybe this "forward
> compatibility" (a.k.a. "old tools support the future") could rise the
> bar again and have a requirement to be able to load rulesets that
> contains features that old tools don't understand.

Well, I don't think we can do that.  Perhaps with a new tool
that allows to assemble raw expressions, but I'm not sure its worth
extending nft for this, the parser (and grammar) is already huge.

> > If noone has any objections, I would place this on my todo list and
> > start with adding to libnftnl the needed "expression is incomplete"
> > marking by extending the .parse callbacks.
> 
> Maybe it is worth exploring what I propose above instead of displaying
> "expression is incomplete"?

For cases where libnftnl is fine but nft lacks a human-readable name I
think such @meta,42 would be fine.

But I don't think its good to allow decoding something arbitary, I think
we would have to acknowledge that this can't be done unless you have
a textual parser for raw netlink descriptions (i.e., full/unreadable TLV soup).
