From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: disallow builtin socket/tproxy with modular
 ipv6 defrag
Date: Fri, 4 Apr 2014 00:22:38 +0200
Message-ID: <20140403222238.GA9081@localhost>
References: <1395529169-26819-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:46386 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753894AbaDCWWo (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 3 Apr 2014 18:22:44 -0400
Content-Disposition: inline
In-Reply-To: <1395529169-26819-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Mar 22, 2014 at 11:59:29PM +0100, Florian Westphal wrote:
> xt_socket.c:(.init.text+0x13d2): undefined reference to `nf_defrag_ipv6_enable'
> xt_TPROXY.c:(.init.text+0x19b5): undefined reference to `nf_defrag_ipv6_enable'
> 
> If DEFRAG_IPV6=m we cannot have SOCKET/TPROXY=y.
> 
> Reported-by: kbuild test robot <fengguang.wu@intel.com>
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
> Technically this patch is bogus, but I couldn't figure out
> how to express the dependencies in kconfig.
> 
> both already have
> 
> select NF_DEFRAG_IPV6 if IP6_NF_IPTABLES
> 
> But its not enough; its possible to have
> CONFIG_NF_DEFRAG_IPV6=m
> CONFIG_IP6_NF_IPTABLES=m
> CONFIG_NETFILTER_XT_TARGET_TPROXY=y
> CONFIG_NETFILTER_XT_MATCH_SOCKET=y
> 
> Which doesn't work as socket/tproxy references symbols
> from ipv6 defrag.
> 
> cannot add
> depends on (NF_DEFRAG_IPV6 || NF_DEFRAG_IPV6=n)
> since thats a recursive dependency.
> 
> Adding a dependency to have m/y depend on IP6_NF_IPTABLES
> status appears to do the right thing but its not correct
> because it also disallows DEFRAG=y, TPROXY=m (which is fine).
>
> AFAICS this dependency issue has always existed since ipv6
> support was added to tproxy.

Not your fault, this Kconfig games that we already have to resolve the
IPv6 dependencies are a mess. We should consider splitting this two in
ipt_/ip6t_ modules, but that's just large change just to resolve this.
