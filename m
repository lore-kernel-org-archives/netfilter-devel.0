From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH v3 2/2] netfilter: xt_addrtype: ipv6 support
Date: Wed, 16 Mar 2011 16:59:57 +0100
Message-ID: <20110316155957.GB13371@Chamillionaire.breakpoint.cc>
References: <1300214971-20345-1-git-send-email-fw@strlen.de>
 <1300214971-20345-2-git-send-email-fw@strlen.de>
 <4D80C12E.4010107@trash.net>
 <20110316141948.GA13371@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:47183 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750734Ab1CPP76 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 16 Mar 2011 11:59:58 -0400
Content-Disposition: inline
In-Reply-To: <20110316141948.GA13371@Chamillionaire.breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Florian Westphal <fw@strlen.de> wrote:
> Patrick McHardy <kaber@trash.net> wrote:
> > > +		rt = rt6_lookup(net, addr, NULL, ifindex, !!dev);
> > 
> > Florian, I just noticed that this will pull in the IPv6 module just
> > by loading the xt_addrtype module.
> 
> Yes...
> 
> > Can we convert this to use
> > nf_ip6_afinfo->route() instead?
> 
> I agree that it would be much nicer, thanks for the
> suggestion.
> 
> I'll look into this on Saturday.

Regardless if this works or not, we'd also
need to find an alternative to ipv6_addr_type, no?

One possibility would be to revert the xt_addrinfo patch
and add an ip6t_addrtype module instead, I think the involved
code duplication would be rlow in this case.
