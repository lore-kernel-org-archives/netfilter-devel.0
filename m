From: Florian Westphal <fw@strlen.de>
Subject: Re: xt_addrtype limit-iface-in is broken for ipv6
Date: Tue, 7 May 2013 11:48:06 +0200
Message-ID: <20130507094806.GA20003@breakpoint.cc>
References: <20130505093610.GA19796@breakpoint.cc>
 <20130507004606.GA5088@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:50348 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755819Ab3EGJsI (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 7 May 2013 05:48:08 -0400
Content-Disposition: inline
In-Reply-To: <20130507004606.GA5088@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > Because xt_addrtype uses ip6_route_output, the ipv6 routing
> > implementation creates an unwanted cached entry, and the packet
> > won't make it to the real/expected destination.
> > 
> > Silently ignoring --limit-iface-in makes the routing work
> > but it breaks rule matching (--dst-type LOCAL with limit-iface-in
> > is supposed to only match if the dst address is configured on
> > the incoming interface; without --limit-iface-in it will match if
> > the address is reachable via lo).
> > 
> > AFAIU the only solution is to use ipv6_chk_addr() when
> > LOCAL is requested instead of a route lookup.
> > 
> > Since this would create a dependeny on ipv6 its a no-go.
> > So, it boils down to two possible solutions:
> > 
> > a), extend struct nf_afinfo to also register
> >     ipv6_chk_addr(), OR
> > b), revert the commit that moved ipt_addrtype to xt_addrtype,
> >     and keep the ipv6 code in ip6t_addrtype.
> 
> I'd prefer something smaller  so I can pass a fix to -stable. We
> cannot pass patches bigger than 100 lines including context.

This will be tough.  Extending struct nf_afinfo for
ipv6_chk_addr MIGHT come in just under 100 lines.  I'll have go at this.

[ i don't like this solution because we add a something for the sake
  of a single ipv6 special case ].
