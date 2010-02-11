From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH v0] netns NOTRACK
Date: Thu, 11 Feb 2010 18:59:01 +0100
Message-ID: <4B744565.2010808@trash.net>
References: <20100211173117.GD4099@x200>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Alexey Dobriyan <adobriyan@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:47147 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756587Ab0BKR7L (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 11 Feb 2010 12:59:11 -0500
In-Reply-To: <20100211173117.GD4099@x200>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Alexey Dobriyan wrote:
> This is netns NOTRACK fix we discussed earlier.
> 
> The idea was to remove nf_conntrack_untracked and
> declare that ->nfct=NULL and ->nfctinfo=IP_CT_UNTRACKED are untracked
> connections.
> 
> It wasn't tested more than "it boots, no conntracks are created"
> but so far so good.

No major objections. Comments inline:

> @@ -290,7 +287,7 @@ static inline int nf_ct_is_dying(struct nf_conn *ct)
>  
>  static inline int nf_ct_is_untracked(const struct sk_buff *skb)
>  {
> -	return (skb->nfct == &nf_conntrack_untracked.ct_general);
> +	return !skb->nfct && skb->nfctinfo == IP_CT_UNTRACKED;

Checking just nfctinfo should be enough, its invalid to assign
a new conntrack without assigning nfctinfo.

What's missing however is clearing of nfctinfo in nf_reset().

> diff --git a/net/bridge/br_netfilter.c b/net/bridge/br_netfilter.c
> index 268e2e7..66af0b9 100644
> --- a/net/bridge/br_netfilter.c
> +++ b/net/bridge/br_netfilter.c
> @@ -792,9 +792,11 @@ static unsigned int br_nf_local_out(unsigned int hook, struct sk_buff *skb,
>  }
>  
>  #if defined(CONFIG_NF_CONNTRACK_IPV4) || defined(CONFIG_NF_CONNTRACK_IPV4_MODULE)
> +#include <net/netfilter/nf_conntrack.h>
> +
>  static int br_nf_dev_queue_xmit(struct sk_buff *skb)
>  {
> -	if (skb->nfct != NULL &&
> +	if ((skb->nfct != NULL || nf_ct_is_untracked(skb)) &&

Seems unnecessary since nfct should be NULL when the conntrack
is untracked.

> diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
> index 90de6c5..c1ebe94 100644
> --- a/net/netfilter/nf_conntrack_core.c
> +++ b/net/netfilter/nf_conntrack_core.c
> @@ -1012,6 +1009,11 @@ static void nf_conntrack_attach(struct sk_buff *nskb, struct sk_buff *skb)
>  
>  	/* This ICMP is in reverse direction to the packet which caused it */
>  	ct = nf_ct_get(skb, &ctinfo);
> +	if (!ct && ctinfo == IP_CT_UNTRACKED) {

!ct also should be unnecessary.

> +		nskb->nfct = NULL;
> +		nskb->nfctinfo = IP_CT_UNTRACKED;
> +		return;
> +	}
>  	if (CTINFO2DIR(ctinfo) == IP_CT_DIR_ORIGINAL)
>  		ctinfo = IP_CT_RELATED + IP_CT_IS_REPLY;
>  	else

> diff --git a/net/netfilter/xt_CT.c b/net/netfilter/xt_CT.c
> index 8183a05..fd5209c 100644
> --- a/net/netfilter/xt_CT.c
> +++ b/net/netfilter/xt_CT.c
> @@ -27,9 +27,14 @@ static unsigned int xt_ct_target(struct sk_buff *skb,
>  	if (skb->nfct != NULL)
>  		return XT_CONTINUE;
>  
> -	atomic_inc(&ct->ct_general.use);
> -	skb->nfct = &ct->ct_general;
> -	skb->nfctinfo = IP_CT_NEW;
> +	if (ct) {
> +		atomic_inc(&ct->ct_general.use);
> +		skb->nfct = &ct->ct_general;
> +		skb->nfctinfo = IP_CT_NEW;
> +	} else {
> +		skb->nfct = NULL;
> +		skb->nfctinfo = IP_CT_UNTRACKED;

Perhaps use a small inline function for this reoccuring pattern.
nf_ct_set_untracked()?

> 

