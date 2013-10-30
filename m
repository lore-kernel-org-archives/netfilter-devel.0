From: Florian Westphal <fw@strlen.de>
Subject: Re: [patch net-next RFC] netfilter: ip6_tables: use reasm skb for
 matching
Date: Wed, 30 Oct 2013 15:44:00 +0100
Message-ID: <20131030144400.GE16615@breakpoint.cc>
References: <1383130201-6198-1-git-send-email-jiri@resnulli.us>
 <20131030134100.GD16615@breakpoint.cc>
 <20131030141354.GB1456@minipsycho.orion>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org,
	davem@davemloft.net, pablo@netfilter.org,
	netfilter-devel@vger.kernel.org, yoshfuji@linux-ipv6.org,
	kadlec@blackhole.kfki.hu, kaber@trash.net, mleitner@redhat.com
To: Jiri Pirko <jiri@resnulli.us>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:33441 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752039Ab3J3OoG (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Oct 2013 10:44:06 -0400
Content-Disposition: inline
In-Reply-To: <20131030141354.GB1456@minipsycho.orion>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jiri Pirko <jiri@resnulli.us> wrote:
> >This is a bit backwards, I think.
> >- We gather frags
> >- Then we invoke ip6t_do_table for each individual fragment
> >
> >So basically your patch is equivalent to
> >for_each_frag( )
> >  ip6t_do_table(reassembled_skb)
> >
> >Which makes no sense to me - why traverse the ruleset n times with the same
> >packet?
> 
> Because each fragment need to be pushed through separately.

Why?  AFAIU we only need to ensure that (in forwarding case) we
send out the original fragments instead of the reassembled packet.

> What different approach would you suggest?

I am sure that current behaviour is intentional, so I'd first like to
understand WHY this was implemented this way.

Also, this would change very long standing behaviour so one might argue that
this is a no-go anyway.

What is the exact problem that this is supposed to solve?
