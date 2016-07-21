From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/1] netfilter: Use IS_ERR_OR_NULL instead of IS_ERR and
 NULl check to simplify the codes in ip_vs_genl_dump_dests and
 resolve_normal_ct
Date: Thu, 21 Jul 2016 18:54:55 +0200
Message-ID: <20160721165455.GA11300@salvia>
References: <1469110159-19200-1-git-send-email-fgao@ikuai8.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kaber@trash.net, netfilter-devel@vger.kernel.org,
	netdev@vger.kernel.org, gfree.wind@gmail.com
To: fgao@ikuai8.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:34229 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753852AbcGUQzE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 21 Jul 2016 12:55:04 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 1989321057E
	for <netfilter-devel@vger.kernel.org>; Thu, 21 Jul 2016 18:55:02 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 097EFFAB56
	for <netfilter-devel@vger.kernel.org>; Thu, 21 Jul 2016 18:55:02 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id E53B1FAB5A
	for <netfilter-devel@vger.kernel.org>; Thu, 21 Jul 2016 18:54:59 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1469110159-19200-1-git-send-email-fgao@ikuai8.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch title is too long, no more than 80 chars.

On Thu, Jul 21, 2016 at 10:09:19PM +0800, fgao@ikuai8.com wrote:
> From: Gao Feng <fgao@ikuai8.com>

Please, include a description here.

> Signed-off-by: Gao Feng <fgao@ikuai8.com>

More comments below.
> ---
>  v1: Initial Version
> 
>  net/netfilter/ipvs/ip_vs_ctl.c    | 2 +-
>  net/netfilter/nf_conntrack_core.c | 6 ++----
>  2 files changed, 3 insertions(+), 5 deletions(-)
> 
> diff --git a/net/netfilter/ipvs/ip_vs_ctl.c b/net/netfilter/ipvs/ip_vs_ctl.c
> index c3c809b..6dc86cc 100644
> --- a/net/netfilter/ipvs/ip_vs_ctl.c
> +++ b/net/netfilter/ipvs/ip_vs_ctl.c
> @@ -3267,7 +3267,7 @@ static int ip_vs_genl_dump_dests(struct sk_buff *skb,
>  
>  
>  	svc = ip_vs_genl_find_service(ipvs, attrs[IPVS_CMD_ATTR_SERVICE]);
> -	if (IS_ERR(svc) || svc == NULL)
> +	if (IS_ERR_OR_NULL(svc))
>  		goto out_err;
>  
>  	/* Dump the destinations */

You have to send this chunk through ipvs-devel mailing list to request
and Acked-by on this.

> diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
> index 153e33f..634d592 100644
> --- a/net/netfilter/nf_conntrack_core.c
> +++ b/net/netfilter/nf_conntrack_core.c
> @@ -1108,10 +1108,8 @@ resolve_normal_ct(struct net *net, struct nf_conn *tmpl,
>  	if (!h) {
>  		h = init_conntrack(net, tmpl, &tuple, l3proto, l4proto,
>  				   skb, dataoff, hash);
> -		if (!h)
> -			return NULL;
> -		if (IS_ERR(h))
> -			return (void *)h;
> +		if (IS_ERR_OR_NULL(h))
> +			return ERR_CAST(h);
>  	}
>  	ct = nf_ct_tuplehash_to_ctrack(h);
>  
> -- 
> 1.9.1
> 
> 
