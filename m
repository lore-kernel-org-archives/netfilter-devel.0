From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf] netfilter: conntrack: resched in nf_ct_iterate_cleanup
Date: Fri, 11 Dec 2015 18:21:23 +0100
Message-ID: <20151211172123.GA12854@breakpoint.cc>
References: <1449682209-20330-1-git-send-email-fw@strlen.de>
 <20151211144313.GD8811@breakpoint.cc>
 <20151211171659.GA1135@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:51463 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751639AbbLKRVZ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 11 Dec 2015 12:21:25 -0500
Content-Disposition: inline
In-Reply-To: <20151211171659.GA1135@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> BTW, the atomic chain notifier in IPv6 seems to be there to handle
> this update from the packet path:
> 
>  ndisc_rcv()
>  ndisc_router_discovery()
>  addrconf_prefix_rcv()
>  manage_tempaddrs()
>  ipv6_add_addr()
>  inet6addr_notifier_call_chain()
> 
> Probably we can get Hannes have a look into this, I think we can
> convert this chain to blocking one through workqueue since
> addrconf_prefix_rcv() returns void. The remaining call sites of
> inet6addr_notifier_call_chain() that I could tracked come from paths
> where I can see ASSERT_RTNL(), so user context is guaranteed.
>
> I'm telling this become I remember that we discussed in netconf'14
> Chicago that it would be good to get rid of this kind og asymmetries
> between IPv4 and IPv6.

Ok, I agree, that would be a lot nicer.

I'll have a look.
