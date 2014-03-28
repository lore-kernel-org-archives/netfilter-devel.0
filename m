From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH -next] netfilter: conntrack: remove timer from ecache
 extension
Date: Fri, 28 Mar 2014 12:14:40 +0100
Message-ID: <20140328111440.GA12728@localhost>
References: <1395943238-29319-1-git-send-email-fw@strlen.de>
 <20140328103203.GA12225@localhost>
 <20140328111031.GG21741@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44861 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752071AbaC1LOp (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 28 Mar 2014 07:14:45 -0400
Content-Disposition: inline
In-Reply-To: <20140328111031.GG21741@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Mar 28, 2014 at 12:10:31PM +0100, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > >  I'm mainly interested if you think timer removal is worthwile,
> > >  it works well in practice from usability POV.
> > 
> > Thanks for looking again into this. We definitely have to get rid of
> > that timer.
> > 
> > Regarding the new flag, perhaps we can avoid exposing this to
> > userspace? I mean, we can define some mask of internal flags that we
> > don't include via dump_status in ctnetlink.
> 
> What is your rationale for supressing this information?
> [ or, why is exposing this to userspace bad? ]

I think that flag provides no useful information to userspace.

> Is it so we don't have to keep dummy flag when we find a different
> solution later?

Right, that's another good reason not to expose that information to
userspace.
