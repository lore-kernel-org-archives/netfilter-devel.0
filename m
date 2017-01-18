From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf-next] netfilter: ctnetlink: make more information
 available in DESTROY events
Date: Wed, 18 Jan 2017 16:07:45 +0100
Message-ID: <20170118150745.GG12001@breakpoint.cc>
References: <1484751272-5489-1-git-send-email-fw@strlen.de>
 <20170118150118.GA23289@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
        Jarno Rajahalme <jarno@ovn.org>,
        Victor Julien <lists@inliniac.net>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:33090 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751803AbdARPdo (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 18 Jan 2017 10:33:44 -0500
Content-Disposition: inline
In-Reply-To: <20170118150118.GA23289@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Wed, Jan 18, 2017 at 03:54:32PM +0100, Florian Westphal wrote:
> > destroy events currently don't contain the tcp state info and no
> > secmark and conntrack labels.
> > 
> > Quoting Victor:
> >  "I was hoping to get the last TCP state in a conntrack destroy event,
> >   however it seems to be unavailable."
> > 
> > Quoting Jarno:
> >  "I have a use case where we want to log terminating connections, but
> >  only if a specific label bit is set."
> > 
> > While at it, also include SECMARK in destroy events if one is available.
> 
> I'm fine with this.
> 
> But to remember the original problem is that netlink bandwidth is
> limited, so the more we load the netlink message, the more chances we
> have to hit ENOBUFS.
> 
> connlabel is optional, so you only get it if needed.

Yes, and only if there was a label change or at least one label bit is
set.

> But the protoinfo thing, I would prefer we just dump the state given
> this the usecase we have now.
> 
> Probably extend ->to_nlattr() to have a bool that indicates if this is
> a dump?

Could do that by it only avoids 4 attributes (so we only save 32bytes
per message).

If you still think its worth it I'll resend a v2 without the dump change
and will send do a followup change that flags the requested event dump
to the protocol backend.
