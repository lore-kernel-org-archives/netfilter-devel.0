From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: rpfilter: skip locally generated bcast, too
Date: Tue, 16 Apr 2013 18:55:26 +0200
Message-ID: <20130416165526.GA3556@localhost>
References: <1365799891-7731-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:60210 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935693Ab3DPQzg (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 16 Apr 2013 12:55:36 -0400
Content-Disposition: inline
In-Reply-To: <1365799891-7731-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Florian,

On Fri, Apr 12, 2013 at 10:51:31PM +0200, Florian Westphal wrote:
> Alex Efros reported rpfilter module doesn't match following packets:
> IN=br.qemu SRC=192.168.2.1 DST=192.168.2.255 [ .. ]
> (netfilter bugzilla #814).
> 
> Problem is that network stack arranges for the locally generated broadcasts
> to appear on the interface they were sent out, so the IFF_LOOPBACK check
> doesn't trigger.
> 
> As -m rpfilter is restricted to PREROUTING, we can check for existing
> skb_dst instead, it catches locally-generated broad/multicast case, too.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  net/ipv4/netfilter/ipt_rpfilter.c  |    2 +-
>  net/ipv6/netfilter/ip6t_rpfilter.c |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/net/ipv4/netfilter/ipt_rpfilter.c b/net/ipv4/netfilter/ipt_rpfilter.c
> index c301300..601abf2 100644
> --- a/net/ipv4/netfilter/ipt_rpfilter.c
> +++ b/net/ipv4/netfilter/ipt_rpfilter.c
> @@ -76,7 +76,7 @@ static bool rpfilter_mt(const struct sk_buff *skb, struct xt_action_param *par)
>  	info = par->matchinfo;
>  	invert = info->flags & XT_RPFILTER_INVERT;
>  
> -	if (par->in->flags & IFF_LOOPBACK)
> +	if (skb_dst(skb)) /* locally generated? */

I'd prefer if this is narrowed down to locally generated traffic in
the same way we do in nf_conntrack_broadcast.c.
