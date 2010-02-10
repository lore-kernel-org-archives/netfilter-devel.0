From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 3/4] netfilter: xtables: use xt_table for hook instantiation
Date: Wed, 10 Feb 2010 16:27:37 +0100
Message-ID: <4B72D069.2040106@trash.net>
References: <1265813954-13854-1-git-send-email-jengelh@medozas.de> <1265813954-13854-4-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:53081 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753355Ab0BJP1m (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Feb 2010 10:27:42 -0500
In-Reply-To: <1265813954-13854-4-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> diff --git a/net/ipv4/netfilter/iptable_raw.c b/net/ipv4/netfilter/iptable_raw.c
> index 766c6fd..2367953 100644
> --- a/net/ipv4/netfilter/iptable_raw.c
> +++ b/net/ipv4/netfilter/iptable_raw.c
> @@ -41,6 +41,7 @@ static const struct xt_table packet_raw = {
>  	.valid_hooks =  RAW_VALID_HOOKS,
>  	.me = THIS_MODULE,
>  	.af = NFPROTO_IPV4,
> +	.priority = NF_IP_PRI_FIRST,

You're changing priorities here, NF_IP_PRI_RAW is not NF_IP_PRI_FIRST.

>  };
>  
>  /* The work comes in here from netfilter.c. */
> @@ -62,23 +63,7 @@ iptable_raw_hook(unsigned int hook,
>  	return ipt_do_table(skb, hook, in, out, net->ipv4.iptable_raw);
>  }
>  
> -/* 'raw' is the very first table. */
> -static struct nf_hook_ops ipt_ops[] __read_mostly = {
> -	{
> -		.hook = iptable_raw_hook,
> -		.pf = NFPROTO_IPV4,
> -		.hooknum = NF_INET_PRE_ROUTING,
> -		.priority = NF_IP_PRI_RAW,
> -		.owner = THIS_MODULE,
> -	},
> -	{
> -		.hook = iptable_raw_hook,
> -		.pf = NFPROTO_IPV4,
> -		.hooknum = NF_INET_LOCAL_OUT,
> -		.priority = NF_IP_PRI_RAW,
> -		.owner = THIS_MODULE,
> -	},
> -};
