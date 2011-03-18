From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH v3 2/2] netfilter: xt_addrtype: ipv6 support
Date: Sat, 19 Mar 2011 00:26:53 +0100
Message-ID: <20110318232653.GC13371@Chamillionaire.breakpoint.cc>
References: <1300214971-20345-1-git-send-email-fw@strlen.de>
 <1300214971-20345-2-git-send-email-fw@strlen.de>
 <4D80C12E.4010107@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:45500 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757567Ab1CRX0y (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 18 Mar 2011 19:26:54 -0400
Content-Disposition: inline
In-Reply-To: <4D80C12E.4010107@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Patrick McHardy <kaber@trash.net> wrote:
> On 15.03.2011 19:49, Florian Westphal wrote:
[..]
> > +		rt = rt6_lookup(net, addr, NULL, ifindex, !!dev);
> 
> Florian, I just noticed that this will pull in the IPv6 module just
> by loading the xt_addrtype module. Can we convert this to use
> nf_ip6_afinfo->route() instead?

I tried this, but i found two issues:
- no netns support (nf_ip6_route passed init_net)
- its not possible to ask for RT6_LOOKUP_F_IFACE flag in the
  underlying fib6_rule_lookup() call.

But AFAICT the latter is needed to support the '--limit-iface-in/out'
option.

Any idea?

Otherwise I think I'll have a go at extending afinfo->route() to pass
in struct net* and a 'strict' argument (i.e. what rt6_lookup() has).

Unfortunately that would have to wait for 2.6.40...

Thanks,
Florian
