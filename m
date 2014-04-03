From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH] netfilter: disallow builtin socket/tproxy with modular
 ipv6 defrag
Date: Fri, 4 Apr 2014 00:25:58 +0200
Message-ID: <20140403222558.GD6769@breakpoint.cc>
References: <1395529169-26819-1-git-send-email-fw@strlen.de>
 <20140403222238.GA9081@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:37212 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753884AbaDCW0A (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 3 Apr 2014 18:26:00 -0400
Content-Disposition: inline
In-Reply-To: <20140403222238.GA9081@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > both already have
> > 
> > select NF_DEFRAG_IPV6 if IP6_NF_IPTABLES
> > 
> > But its not enough; its possible to have
> > CONFIG_NF_DEFRAG_IPV6=m
> > CONFIG_IP6_NF_IPTABLES=m
> > CONFIG_NETFILTER_XT_TARGET_TPROXY=y
> > CONFIG_NETFILTER_XT_MATCH_SOCKET=y
> > 
> > Which doesn't work as socket/tproxy references symbols
> > from ipv6 defrag.
> > 
> > cannot add
> > depends on (NF_DEFRAG_IPV6 || NF_DEFRAG_IPV6=n)
> > since thats a recursive dependency.
> > 
> > Adding a dependency to have m/y depend on IP6_NF_IPTABLES
> > status appears to do the right thing but its not correct
> > because it also disallows DEFRAG=y, TPROXY=m (which is fine).
> >
> > AFAICS this dependency issue has always existed since ipv6
> > support was added to tproxy.
> 
> Not your fault, this Kconfig games that we already have to resolve the
> IPv6 dependencies are a mess. We should consider splitting this two in
> ipt_/ip6t_ modules, but that's just large change just to resolve this.

I'll look into a better way to fix it for -next.
