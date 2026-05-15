Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF8AE23EAA4;
	Fri, 15 May 2026 12:48:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778849291; cv=none; b=RUYK7BsGOXrB+NIF4LB6QT2BxaENKo6IB3AIhZRiomm7oBWYWVpnn2I/CIOUlQhuUXOSyM0dvESs08KWhlMRjA8ew2g66S7UpANh1JOY99/ghfj/nG7jQdBMm4uHAuEibaHzxKO1S8tNxfUb+Ss0+Xl4WQG6sBq8ZNOtTnxjNKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778849291; c=relaxed/simple;
	bh=6JGDGmmwgA0OKG+d2hEn1s6MZ8gf5q+OXTINTevYihk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=X3wMLgWBtbrH+RcsPk/HFmxSzo+wwDuWNUGiKV6LRisOMxchY0VjZMm+U0gV73nFE6lHXUcXS5IwZgOPNeqOMLvHn9CExEIao3Xegn6WGkAsF+lmO4DRzgaJ1ignBGFGUq/oJqZV6hfNBrt0JY0W0eeUjCzn1zVSgn8AKIpgTjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id D06D860706; Fri, 15 May 2026 14:48:06 +0200 (CEST)
Date: Fri, 15 May 2026 14:48:05 +0200
From: Florian Westphal <fw@strlen.de>
To: Qi Tang <tpluszz77@gmail.com>
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
	pablo@netfilter.org, herbert@gondor.apana.org.au,
	michael.bommarito@gmail.com, lyutoon@gmail.com
Subject: Re: [RFC] netfilter: disable payload mangling in userns
Message-ID: <agcWBZNugohelNp6@strlen.de>
References: <20260515100411.3141-1-fw@strlen.de>
 <20260515114848.1105927-1-tpluszz77@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260515114848.1105927-1-tpluszz77@gmail.com>

Qi Tang <tpluszz77@gmail.com> wrote:
> I agree with the userns block.  I'll keep pushing the five
> consumer-side bounds-check patches: root in init userns can
> still install the same payload-set rule and trigger the same
> OOB at the re-read sites, so the underlying bug fix is still
> worth landing.
> 
> None of the five sites overlap with the relax wishlist (saddr/
> daddr, transport, linklayer).  Same class showed up in an
> earlier patch:
>   https://lore.kernel.org/netdev/20260514035802.1540395-1-tpluszz77@gmail.com/
> 
> These five are unlikely to be all of them; we think the
> consumer side warrants a broader audit.  Thoughts?

I think we have to do both.

For nft_payload/nft_exthdr:
1. Writes from !initial_userns are rejected (rule insert fails).
2. Writes for initial userns get validated at rule add time:
  - netdev ingress is allowed to alter everything, I think
  this is early enough to not introduce oddities that can't come
  from wire / untrusted peer.
 - bridge is allowed to alter everything: AFAICS there shouldn't
 be a problem with this, same as with ingress.
 - inet (ipv4/ip6): Check base (offset is unsigned and relative
   to ll/network header/transport header/payload
   - Allow modifications past transport header.
   - Allow modifications of transport header
   - Allow network header modifications for a subset of valid
     offsets/lengths: saddr, daddr, checksum, tos, id, ttl / hl.
     Reject everything else.
   - Allow link-layer; but check at from packetpath that
     offset + len don't write past start of the network header.
     Else: no-op.

nfqueue is the bigger problem: userspace gives us a whole new
packet data blob, not a delta that we should apply at offset x).

I think we have to update nfqueue to do rudimentary header revalidation
and drop the packet on failure, e.g. at least making sure tot_len is not
past skb->len.
