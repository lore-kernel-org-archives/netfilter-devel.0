From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 2/4] netfilter: xtables: compact table hook functions
 (2/2)
Date: Wed, 10 Feb 2010 16:24:30 +0100
Message-ID: <4B72CFAE.70601@trash.net>
References: <1265813954-13854-1-git-send-email-jengelh@medozas.de> <1265813954-13854-3-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:52988 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753151Ab0BJPYf (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Feb 2010 10:24:35 -0500
In-Reply-To: <1265813954-13854-3-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> diff --git a/net/ipv4/netfilter/iptable_filter.c b/net/ipv4/netfilter/iptable_filter.c
> index b320208..7f64ea5 100644
> --- a/net/ipv4/netfilter/iptable_filter.c
> +++ b/net/ipv4/netfilter/iptable_filter.c
> @@ -67,19 +67,15 @@ iptable_filter_hook(unsigned int hook,
>  	 const struct net_device *out,
>  	 int (*okfn)(struct sk_buff *))
>  {
> -	if (hook == NF_INET_LOCAL_OUT) {
> -		if (skb->len < sizeof(struct iphdr) ||
> -		    ip_hdrlen(skb) < sizeof(struct iphdr))
> -			/* root is playing with raw sockets. */
> -			return NF_ACCEPT;
> -
> -		return ipt_do_table(skb, hook, in, out,
> -				    dev_net(out)->ipv4.iptable_filter);
> -	}
> +	const struct net *net;
> +
> +	if (hook == NF_INET_LOCAL_OUT && (skb->len < sizeof(struct iphdr) ||
> +	    ip_hdrlen(skb) < sizeof(struct iphdr)))

This also looks strange. The length tests belong together, so this would
make it much more readable:

	if (hook == NF_INET_LOCAL_OUT &&
	    (skb->len < sizeof(struct iphdr) ||
	     ip_hdrlen(skb) < sizeof(struct iphdr)))
		...

Please also fix up similar cases in case there are any.
