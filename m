From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCHv3 2/2 nf] netfilter: bridge: fix IPv6 packets not being
 bridged with CONFIG_IPV6=n
Date: Wed, 12 Aug 2015 19:57:11 +0200
Message-ID: <20150812175711.GA31542@salvia>
References: <1438229221-25959-1-git-send-email-bernhard.thaler@wvnet.at>
 <20150806103911.GA18793@salvia>
 <55C7D928.9020805@wvnet.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kadlec@blackhole.kfki.hu, netfilter-devel@vger.kernel.org
To: Bernhard Thaler <bernhard.thaler@wvnet.at>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59509 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750829AbbHLRvB (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 12 Aug 2015 13:51:01 -0400
Content-Disposition: inline
In-Reply-To: <55C7D928.9020805@wvnet.at>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Aug 10, 2015 at 12:50:16AM +0200, Bernhard Thaler wrote:
> Hi Pablo,
> 
> seeing all this I think there is a much simpler solution to the initial
> problem that should be fixed (IPv6 packets not traversing the bridge
> with CONFIG_IPV6=n).
> 
> diff --git a/include/net/netfilter/br_netfilter.h
> b/include/net/netfilter/br_netfilter.h
> index bab824b..d4c6b5f 100644
> --- a/include/net/netfilter/br_netfilter.h
> +++ b/include/net/netfilter/br_netfilter.h
> @@ -59,7 +59,7 @@ static inline unsigned int
>  br_nf_pre_routing_ipv6(const struct nf_hook_ops *ops, struct sk_buff *skb,
>                        const struct nf_hook_state *state)
>  {
> -       return NF_DROP;
> +       return NF_ACCEPT;
>  }
>  #endif
> 
> 
> Only downside it has that /proc/sys/net/bridge/bridge-nf-call-ip6tables
> and /sys/class/net/brXXX/bridge/nf_call_ip6tables is still exposed with
> CONFIG_IPV6=n and changeable, but with no effect.
> Despite brnf_call_ip6tables being set to 1 packets will not be available
> to ip6tables, which will not be present anyway in this case.

Given that this has been the default behaviour before the _ipv6.c file
was introduced and that it is a corner case (it only affects people
that compile custom kernels), this sounds OK.

Anyway it would be good to have the patches that move IPv6 code to the
new _ipv6.c file now that we have it there.
