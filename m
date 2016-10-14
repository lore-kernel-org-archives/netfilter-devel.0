From: Florian Westphal <fw@strlen.de>
Subject: Re: routing table lookup
Date: Fri, 14 Oct 2016 13:44:21 +0200
Message-ID: <20161014114421.GB10404@breakpoint.cc>
References: <CAJO99TmN17PiMGs87HY=Awy=-QAMVLsCzBbvXZFzL8HDTakH=A@mail.gmail.com>
 <alpine.LSU.2.20.1610112023530.2014@nerf40.vanv.qr>
 <CAJO99Tn0yTE1=dFMO--vj9KpMt2kgRfURu8-GoXy=KZDRymOQw@mail.gmail.com>
 <alpine.LSU.2.20.1610112203020.5047@nerf40.vanv.qr>
 <CAJO99TnPeGz81C8iP_gg3uD4Y3epDBg5BwWex6RWT0YR93eceg@mail.gmail.com>
 <20161012061930.GA28142@unicorn.suse.cz>
 <CAJO99TnLzTbtTZP_DKE37eG_+X3T5b1g5rbhVTGz07RDgShDPw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 8bit
Cc: Michal Kubecek <mkubecek@suse.cz>,
        Jan Engelhardt <jengelh@inai.de>,
        netfilter-devel@vger.kernel.org
To: =?iso-8859-15?Q?Bj=F8rnar?= Ness <bjornar.ness@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:42070 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932238AbcJNLpf (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 14 Oct 2016 07:45:35 -0400
Content-Disposition: inline
In-Reply-To: <CAJO99TnLzTbtTZP_DKE37eG_+X3T5b1g5rbhVTGz07RDgShDPw@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Bjørnar Ness <bjornar.ness@gmail.com> wrote:
> 2016-10-12 8:19 GMT+02:00 Michal Kubecek <mkubecek@suse.cz>:
> > On Wed, Oct 12, 2016 at 12:17:24AM +0200, Bjørnar Ness wrote:
> >>
> >> Yeah, sortoff. But afaik rpfilter is a iptables module, and not
> >> available in nftables yet.
> >>
> >> Pablo: is the "lookup in routing table from nftables" a total waste of time?
> >
> > You may be interested in
> >
> >   https://www.youtube.com/watch?v=wfWMPlZHQBk&t=19m40s
> 
> Thanks, Michal, this is interesting, but not exactly what I am looking
> for. This fib module
> would as far as I can tell follow the routing from rules -> table ->
> decision, which will need
> both a src and dst address. What I want is to skip the rule matching,
> and check directly in
> a table, that way we only need a single address, and the following
> should potentially work
> from prerouting:
> 
> ip saddr rt_table 10 drop
> 
> comments?

I don't really understand why you would want this.

If you only want to match saddr, why not use ipset (or nftables set) for
this?

If you want to use the fib, why not use blackhole routes?

I'd like to understand why you need this 'rule skip' thing, seems we
would have to export some fib internals for this which I'd like to
avoid.
