From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH v2] netfilter: nft_nth: match every n packets
Date: Thu, 28 Jul 2016 11:20:59 +0200
Message-ID: <20160728092059.GD2565@breakpoint.cc>
References: <20160727220053.GA26643@sonyv>
 <20160727230105.GC2565@breakpoint.cc>
 <20160728074252.GA28885@sonyv>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Laura Garcia <nevola@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:36912 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752006AbcG1JVF (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 28 Jul 2016 05:21:05 -0400
Content-Disposition: inline
In-Reply-To: <20160728074252.GA28885@sonyv>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Laura Garcia <nevola@gmail.com> wrote:
> On Thu, Jul 28, 2016 at 01:01:05AM +0200, Florian Westphal wrote:
> > How exactly is this used by nftables?
> > 
> > AFAIU usespace will check if ->dreg is 0 or not, but does that make
> > sense?
> > 
> > Seems to me it would be more straightforward to not use a dreg at all
> > and just NFT_BREAK if nval != 0?
> > 
> 
> The main idea is to provide a round robin like scheduling method, for
> example:
> 
> ip daddr <ipsaddr> dnat nth 3 map {
>         0: <ipdaddrA>,
>         1: <ipdaddrB>,
>         2: <ipdaddrC>
> }
> 

That makes sense, would be nice to place a small blurb in the commit
message.

> > Otherwise this looks good to me, except that I think we should consider
> > putting this in nft_meta.c instead of a new module.
> 
> AFAIK meta is more to set or get metainformation from a certain
> packet. I consider this expression is closer to counter, but with a
> resetting value.

Ok, fair enough.

Thanks,
Florian
