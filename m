Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46380DF76
	for <netfilter-devel@vger.kernel.org>; Sun, 12 Oct 2025 12:26:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760271984; cv=none; b=uXq12YRLLvcks0MyqauH8PdoOHzKDXUCU8tgqE5kvbBcdcAjmVoJFAVt/rGSQUGCLnuYY10mIeZ/b4UvV9E64hg7mDh/ul16zFZWJdFt8sEU0TF6UV+bPgz0IVdNmjvQkx0Z9l96eR1b/yxwJPmRJXOPJM9vpNqjoq3H52iPlfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760271984; c=relaxed/simple;
	bh=Kmyk+GsjGfkx5yfuGje5teZrrF6mnToWv5a6376NyBw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UwaU2alfUBJz3SVbJNKc64F3YlQYKlZrO+Gu56lZAYPSn8w2sSFEAsSvyLiw6n571xQ4cA4kjx82RI8CFAVmG+P+iuwdw43ykdFgaXAanvyaLvXsrJTXufkBXQMNhqkoPURIqdq7OUcdfOobJWhdZvh6OBgHaytrsWU+nLf8DIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id A88E560329; Sun, 12 Oct 2025 14:26:20 +0200 (CEST)
Date: Sun, 12 Oct 2025 14:26:20 +0200
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next 2/5] netfilter: flowtable: consolidate xmit path
Message-ID: <aOuebEc_iHm6r3u0@strlen.de>
References: <20251010111825.6723-1-pablo@netfilter.org>
 <20251010111825.6723-3-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251010111825.6723-3-pablo@netfilter.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> Use dev_queue_xmit() for the XMIT_NEIGH case. Store the interface index
> of the real device behind the vlan/pppoe device, this introduces  an
> extra lookup for the real device in the xmit path because rt->dst.dev
> provides the vlan/pppoe device.

Will this scale?  netdev_by_index only has a fixed table of 256 slots,
so with 8k vlans or so this will have a 30-ish netdev list walk.

[ EDIT: I see now that nf_flow_queue_xmit() already does that.
  So I guess its either not an issue or not yet and it can be
  optimized later.  So disregard this ]

>  	case FLOW_OFFLOAD_XMIT_NEIGH:
>  		rt = dst_rtable(tuplehash->tuple.dst_cache);
> -		outdev = rt->dst.dev;
> -		skb->dev = outdev;
> -		nexthop = rt_nexthop(rt, flow->tuplehash[!dir].tuple.src_v4.s_addr);
> +		xmit.outdev = dev_get_by_index_rcu(state->net, tuplehash->tuple.ifidx);

Why do this if we already have dst_cache?

The above explanation (rt->dst.dev could be a tunnel device, whereas
the latter fetches phyical / lowest device) from the commit message
makes that clear; but I think a short comment would help.
