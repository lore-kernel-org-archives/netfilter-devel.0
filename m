From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH -next v2 0/6] netfilter: xtables: improve jumpstack
 handling
Date: Wed, 15 Jul 2015 20:52:24 +0200
Message-ID: <20150715185224.GJ25674@breakpoint.cc>
References: <1436889071-3637-1-git-send-email-fw@strlen.de>
 <20150715171749.GA4707@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
	eric.dumazet@gmail.com
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:53331 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752747AbbGOSw0 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 15 Jul 2015 14:52:26 -0400
Content-Disposition: inline
In-Reply-To: <20150715171749.GA4707@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> If we take this patch into the tree, I'd wait for quite some time to
> make sure nobody barfs to us with problems, so we can revert it.
> 
> Otherwise, the (unlikely) scenario would require several reverts in a
> row, starting from this to further suggested enhancements, right?

Yes, thats exactly the problem.
So for example if we'd switch to allocating the jumpstack in the percpu
area (rather than just a pointer as we do now) we would need to revert
that since percpu allocations have sie limitations (64k max iirc).

HOWEVER, the real problem is -- if you apply this, how long would
you propose to wait before we would leverage the limitation in further
patches?

I'd say 3 years minimum, and I'd rather see nft ready by then :)

So I'd say drop patch 6.
