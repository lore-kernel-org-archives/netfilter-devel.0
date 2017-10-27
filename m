From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft 1/8] tests: adjust output to silence warnings
Date: Fri, 27 Oct 2017 16:07:19 +0200
Message-ID: <20171027140719.GC25244@salvia>
References: <20171026230611.14269-1-fw@strlen.de>
 <20171026230611.14269-2-fw@strlen.de>
 <20171027102906.GA14147@salvia>
 <20171027125202.GO19457@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48750 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750714AbdJ0OHY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 27 Oct 2017 10:07:24 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 12ECA6EAD7
        for <netfilter-devel@vger.kernel.org>; Fri, 27 Oct 2017 16:07:23 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id ED32DDA7B9
        for <netfilter-devel@vger.kernel.org>; Fri, 27 Oct 2017 16:07:22 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20171027125202.GO19457@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Oct 27, 2017 at 02:52:02PM +0200, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > index 43ac0909195f..91f7b9e1c472 100644
> > > --- a/tests/py/inet/icmpX.t
> > > +++ b/tests/py/inet/icmpX.t
> > > @@ -3,8 +3,8 @@
> > >  *inet;test-inet;input
> > >  
> > >  ip protocol icmp icmp type echo-request;ok;icmp type echo-request
> > > -icmp type echo-request;ok
> > > +icmp type echo-request;ok;meta nfproto ipv4 icmp type echo-request
> > 
> > I read a couple of times your description above and I must be
> > overlooking anything.
> > 
> > To me, "icmp type echo-request" in bridge/inet/netdev should result in
> > two implicit dependencies, so this ends up looking like this:
> > 
> > 1) check for IPv4, then...
> > 2) check for ICMP in iph->protocol, then...
> > 3) check for ICMP type.
> > 
> > This would be the default reasonable behaviour.
> > 
> > Then, we have to deal with specific corner cases, where we should
> > cancel dependencies.
> > 
> > Am I missing anything?
> 
> Sorry, I overlooked this on my first reply.
> 
> Your assesment is correct, that is indeed the default reasonable
> behaviour, but, when removing, we have limited information on
> the rule at the moment.
>
> So this is really:
> 
> 1) check for IPv4, then...
> 2) check for some l4 protocol
> 
> ... from a dependency removal perspective.
> and 2) doesn't provide enough information to decide if the dependency
> is needed or not.

We probably need to make an initial pass of the entire rule, populate
context, then kill these dependencies once we have a global view on
what is being expressed there. Make sense to you?
