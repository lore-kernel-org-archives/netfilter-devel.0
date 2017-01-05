From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next 1/1] netfilter: Use strlcpy to copy dev name
 instead of strncpy
Date: Thu, 5 Jan 2017 13:37:05 +0100
Message-ID: <20170105123705.GA6658@salvia>
References: <1482837413-32048-1-git-send-email-fgao@ikuai8.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, gfree.wind@gmail.com
To: fgao@ikuai8.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:54396 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1031885AbdAEMhM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 5 Jan 2017 07:37:12 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 354AB6EAD3
        for <netfilter-devel@vger.kernel.org>; Thu,  5 Jan 2017 13:37:10 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 24977DA2D3
        for <netfilter-devel@vger.kernel.org>; Thu,  5 Jan 2017 13:37:10 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 38E89A7DC7
        for <netfilter-devel@vger.kernel.org>; Thu,  5 Jan 2017 13:37:06 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1482837413-32048-1-git-send-email-fgao@ikuai8.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Dec 27, 2016 at 07:16:53PM +0800, fgao@ikuai8.com wrote:
> From: Gao Feng <fgao@ikuai8.com>
> 
> The current codes use strncpy to copy the dev name in
> nf_tables_newchain, there is no real issue now. Because the sizes of
> src and dst are IFNAMSIZ. But normally it should use count-1 with
> strncpy, because strncpy doesn't make sure the dst must be
> NULL-terminated when src exceeds the count bytes.
> So use strlcpy to replace the strncpy to make it clearer.
> 
> Signed-off-by: Gao Feng <fgao@ikuai8.com>
> ---
>  net/netfilter/nf_tables_api.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> index a019a87..dc50801 100644
> --- a/net/netfilter/nf_tables_api.c
> +++ b/net/netfilter/nf_tables_api.c
> @@ -1488,7 +1488,7 @@ static int nf_tables_newchain(struct net *net, struct sock *nlsk,
>  		}
>  
>  		if (hook.dev != NULL)
> -			strncpy(basechain->dev_name, hook.dev->name, IFNAMSIZ);
> +			strlcpy(basechain->dev_name, hook.dev->name, IFNAMSIZ);

I think this is not a problem, look:

        [NFTA_HOOK_DEV]         = { .type = NLA_STRING,
                                    .len = IFNAMSIZ - 1 },

The netlink attribute policy enforces that NFTA_HOOK_DEV is always one
bytes smaller than the maximum length. So we guarantee that there's
room to nul-terminated this string.

>  		if (nla[NFTA_CHAIN_COUNTERS]) {
>  			stats = nft_stats_alloc(nla[NFTA_CHAIN_COUNTERS]);
> -- 
> 1.9.1
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
