From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH V2 1/2] netfilter: rpfilter: skip locally generated
 bcast, too
Date: Fri, 19 Apr 2013 00:11:30 +0200
Message-ID: <20130418221130.GA6429@localhost>
References: <1366274725-16286-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44431 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752689Ab3DRWLj (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 18 Apr 2013 18:11:39 -0400
Content-Disposition: inline
In-Reply-To: <1366274725-16286-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Florian,

On Thu, Apr 18, 2013 at 10:45:24AM +0200, Florian Westphal wrote:
> Alex Efros reported rpfilter module doesn't match following packets:
> IN=br.qemu SRC=192.168.2.1 DST=192.168.2.255 [ .. ]
> (netfilter bugzilla #814).
> 
> Problem is that network stack arranges for the locally generated broadcasts
> to appear on the interface they were sent out, so the IFF_LOOPBACK check
> doesn't trigger.
> 
> As -m rpfilter is restricted to PREROUTING, we can check for existing
> rtable instead, it catches locally-generated broad/multicast case, too.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  Pablo,
> 
>  I did have a look at nf_conntrack_broadcast, but
>  1. I cannot check skb->sk (TPROXY can set that for incoming packets)
>  2. I don't want to test conntrack info to avoid dependency on conntrack
> 
>  So, this is pretty much the very same patch as V1, except that this
>  also checks for _LOCAL flag instead of just checking for presence of
>  skb_dst().
> 
>  Is this ok, or did you have something else in mind?

That's fine. I just wanted a bit further validation to avoid an easy
breakage in case this assumption is not fulfilled anymore.

I have made a comestic change: renamed is_local to rpfilter_is_local
just to stick to the corresponding function namespace.

Applied, thanks.
