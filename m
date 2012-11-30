From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 3/3] netfilter: ctnetlink: allow userspace to set labels
Date: Fri, 30 Nov 2012 19:34:50 +0100
Message-ID: <20121130183450.GA27138@1984>
References: <1352994915-3859-1-git-send-email-fw@strlen.de>
 <1352994915-3859-4-git-send-email-fw@strlen.de>
 <20121127111838.GA28064@1984>
 <20121127115000.GA14156@breakpoint.cc>
 <20121127123149.GA2351@1984>
 <20121127130904.GB14156@breakpoint.cc>
 <20121127141317.GB9089@1984>
 <20121127142433.GE14156@breakpoint.cc>
 <20121130135806.GA7955@1984>
 <20121130140254.GB31969@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35367 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751736Ab2K3Sez (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 30 Nov 2012 13:34:55 -0500
Content-Disposition: inline
In-Reply-To: <20121130140254.GB31969@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Nov 30, 2012 at 03:02:54PM +0100, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > Quick idea: I think we can also support atomic replacement at word
> > size using xchg, so the replacement operation can still happen at word
> > level. Setting many bits at once would be also faster with that.
> 
> Unfortunately, no -- the interface is too rudimentary.
> Example: You want to set bis 0, 2, 6; but leave all other
> bit that are set intact.
> 
> So you first need to make a dump to fetch the current labels set.
> Then, you set bits 0, 2, 6 and send the new state to the kernel.
> 
> But between the dump and the set operation, a new bit might
> have been set.  So even when using xchg it will be un-set again...

what about cmpxchg inside a loop? I think we can assume that the
probability of interference while updating a word is low.
