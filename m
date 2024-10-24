Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A953C1C07D8
	for <netfilter-devel@vger.kernel.org>; Thu, 24 Oct 2024 10:41:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729766469; cv=none; b=lDdNYWA80UIMS1TM2ldgTHRngEUZ0jEBsQH0MQqv50kPVE1QkmpUWzun++kWqG3SNRF8IncSQS2+ZEhsLN+RSTvkNUhRYw6OSTomcl0EnkCTtIc86sB3kQnJoYLkxbCuyWAynCvw7zb3onqQA5nh44BzUiqnrpE+9Y62og20Ho0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729766469; c=relaxed/simple;
	bh=D67y5SU324u6LPh3DdNNpdI20yQ6W/3eNBQY30nGw70=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YuD1w4i3++MauahqObesyEbAht7sO453ZZPYIXMfS4jG3YZINxt9g1+82ks69XnKr2kN3qaFfrWkg4MEBD7ZUaKcLfmb5f/Da82VHzjQIn5UWwtdwF7ZBF2AKJsxJSUfINU4kccxhcDB2pMiKi790ZIj1rO/L1F5TXCDy3buLT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1t3vH5-00072s-Kp; Thu, 24 Oct 2024 12:41:03 +0200
Date: Thu, 24 Oct 2024 12:41:03 +0200
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] doc: extend description of fib expression
Message-ID: <20241024104103.GA25923@breakpoint.cc>
References: <20241010133745.28765-1-fw@strlen.de>
 <ZwqlbhdH4Fw__daA@calendula>
 <20241018120825.GC28324@breakpoint.cc>
 <ZxeNzTZLxw1NdgL2@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZxeNzTZLxw1NdgL2@calendula>
User-Agent: Mutt/1.10.1 (2018-07-13)

Pablo Neira Ayuso <pablo@netfilter.org> wrote> > since _OIF and _OIFNAME was restricted to prerouting, nf hookfn has NULL
> > output interface, so there is nothing we could compare against.
> > 
> > Now its available in forward too so it could be selectively relaxed for
> > this, but, what is the use case?
> > 
> > Do a RPF in forward, then we need to compare vs. incoming interface.
> 
> This is for an esoteric scenario: Policy-based routing using input
> interface as key. The fib rule for RPF does not work from prerouting
> because iif cannot be inferred, there is no way to know if route in
> the reverse direction exists until the route lookup for this direction
> is done.

Yes, that internally sets fibs iif to the oif.

> > But for outgoing interface, we'd do a normal route lookup, but the stack
> > already did that for us (as packet is already being forwarded).
> >
> > So what would be the desired outcome for a 'fib daddr . oif' check?
> 
> Hm, this always evaluates true from forward and any later hook.
> 
> I missing now, what is the point of . oif in general?

Its for use with the 'type' output, i.e. consult fib to determine
the type of the daddr (multicast, broadcast etc).

I don't see an application for the fib case, with exception
of the 'rpf lookup in forward' case.

