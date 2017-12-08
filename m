From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next 3/3] nftables: reject nat hook registration if
 prio is before conntrack
Date: Fri, 8 Dec 2017 22:22:57 +0100
Message-ID: <20171208212257.GA4348@salvia>
References: <20171208160155.968-1-fw@strlen.de>
 <20171208160155.968-4-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:34522 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752562AbdLHVXC (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 8 Dec 2017 16:23:02 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id D4AF11C4385
        for <netfilter-devel@vger.kernel.org>; Fri,  8 Dec 2017 22:23:00 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C53E3DA7F7
        for <netfilter-devel@vger.kernel.org>; Fri,  8 Dec 2017 22:23:00 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20171208160155.968-4-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Dec 08, 2017 at 05:01:55PM +0100, Florian Westphal wrote:
> No problem for iptables as priorities are fixed values defined in the
> nat modules, but in nftables the priority its coming from userspace.
> 
> Reject in case we see that such a hook would not work.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  net/netfilter/nf_tables_api.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> index f000d4399c7a..4ed66f1b40b5 100644
> --- a/net/netfilter/nf_tables_api.c
> +++ b/net/netfilter/nf_tables_api.c
> @@ -1303,6 +1303,11 @@ static int nft_chain_parse_hook(struct net *net,
>  	}
>  	if (!(type->hook_mask & (1 << hook->num)))
>  		return -EOPNOTSUPP;
> +
> +	if (type->type == NFT_CHAIN_T_NAT &&
> +	    hook->priority <= NF_IP_PRI_CONNTRACK)
> +		return -EINVAL;

EINVAL is usually for missing netlink attributes, so I'd go for
EOPNOTSUPP instead. No need to resend I can mangle this here if you
prefer.

> +
>  	if (!try_module_get(type->owner))
>  		return -ENOENT;
>  
> -- 
> 2.13.6
> 
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
