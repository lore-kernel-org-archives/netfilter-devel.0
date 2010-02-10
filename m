From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 1/4] netfilter: xtables: compact table hook functions
 (1/2)
Date: Wed, 10 Feb 2010 16:22:28 +0100
Message-ID: <4B72CF34.6000701@trash.net>
References: <1265813954-13854-1-git-send-email-jengelh@medozas.de> <1265813954-13854-2-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:52935 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753151Ab0BJPWf (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Feb 2010 10:22:35 -0500
In-Reply-To: <1265813954-13854-2-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> diff --git a/net/ipv4/netfilter/arptable_filter.c b/net/ipv4/netfilter/arptable_filter.c
> index 9733760..78bb72e 100644
> --- a/net/ipv4/netfilter/arptable_filter.c
> +++ b/net/ipv4/netfilter/arptable_filter.c
> @@ -53,43 +53,38 @@ static const struct xt_table packet_filter = {
>  };
>  
>  /* The work comes in here from netfilter.c */
> -static unsigned int arpt_in_hook(unsigned int hook,
> +static unsigned int arptable_filter_hook(unsigned int hook,
>  				 struct sk_buff *skb,
>  				 const struct net_device *in,
>  				 const struct net_device *out,
>  				 int (*okfn)(struct sk_buff *))

I'm fine with this patch, but can we please keep the arguments aligned
neatly? As I said previously, I've let this slip too often, but intend
not to in the future.
