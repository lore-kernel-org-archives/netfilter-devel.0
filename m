From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next 1/3] netfilter: nft_ct: allow to set ctnetlink
 event types of a connection
Date: Sat, 15 Apr 2017 11:09:45 +0200
Message-ID: <20170415090945.GA4023@salvia>
References: <20170415084505.26176-1-fw@strlen.de>
 <20170415084505.26176-2-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:32880 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751565AbdDOJJu (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 15 Apr 2017 05:09:50 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id AFCB8E04A8
        for <netfilter-devel@vger.kernel.org>; Sat, 15 Apr 2017 11:09:45 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9E64DDA729
        for <netfilter-devel@vger.kernel.org>; Sat, 15 Apr 2017 11:09:45 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8C3C3DA862
        for <netfilter-devel@vger.kernel.org>; Sat, 15 Apr 2017 11:09:43 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20170415084505.26176-2-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Apr 15, 2017 at 10:45:03AM +0200, Florian Westphal wrote:
> by default the kernel emits all ctnetlink events for a connection.
> This allows to select the types of events to generate for a connection.
> 
> This allows to e.g. only send DESTROY events but no NEW/UPDATE ones.
> 
> This was already possible via iptables' CT target.
> The nft version has the advantage that it can also be used with
> already-established conntracks.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  include/uapi/linux/netfilter/nf_tables.h |  2 ++
>  net/netfilter/nft_ct.c                   | 19 ++++++++++++++++++-
>  2 files changed, 20 insertions(+), 1 deletion(-)
> 
> diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
> index 8f3842690d17..683f6f88fcac 100644
> --- a/include/uapi/linux/netfilter/nf_tables.h
> +++ b/include/uapi/linux/netfilter/nf_tables.h
> @@ -901,6 +901,7 @@ enum nft_rt_attributes {
>   * @NFT_CT_BYTES: conntrack bytes
>   * @NFT_CT_AVGPKT: conntrack average bytes per packet
>   * @NFT_CT_ZONE: conntrack zone
> + * @NFT_CT_EVENTMASK: ctnetlink events to be generated for this conntrack
>   */
>  enum nft_ct_keys {
>  	NFT_CT_STATE,
> @@ -921,6 +922,7 @@ enum nft_ct_keys {
>  	NFT_CT_BYTES,
>  	NFT_CT_AVGPKT,
>  	NFT_CT_ZONE,
> +	NFT_CT_EVENTMASK,
>  };
>  
>  /**
> diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
> index 6e23dbbedd7f..4f642977f8a5 100644
> --- a/net/netfilter/nft_ct.c
> +++ b/net/netfilter/nft_ct.c
> @@ -264,7 +264,7 @@ static void nft_ct_set_eval(const struct nft_expr *expr,
>  	struct nf_conn *ct;
>  
>  	ct = nf_ct_get(skb, &ctinfo);
> -	if (ct == NULL)
> +	if (ct == NULL || nf_ct_is_template(ct))

I wonder if this should go in a oneliner, given this is fixing the
fact that we may end up using the template. So someone has a chance to
pass it to -stable. I'll be fine either way, no problem.

Another comment below.

>  		return;
>  
>  	switch (priv->key) {
> @@ -284,6 +284,16 @@ static void nft_ct_set_eval(const struct nft_expr *expr,
>  				      NF_CT_LABELS_MAX_SIZE / sizeof(u32));
>  		break;
>  #endif
> +#ifdef CONFIG_NF_CONNTRACK_EVENTS
> +	case NFT_CT_EVENTMASK: {
> +		struct nf_conntrack_ecache *e = nf_ct_ecache_find(ct);
> +		u16 ctmask = (u16)regs->data[priv->sreg];

Liping added helpers to fetch data from registers, I think it
applies to this case too.

Thanks!
