From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 2/9] netfilter: xtables: slightly more detailed checkentry
 return values
Date: Wed, 17 Mar 2010 14:39:19 +0100
Message-ID: <4BA0DB87.9040709@trash.net>
References: <1268831945-6041-1-git-send-email-jengelh@medozas.de> <1268831945-6041-3-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:57788 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754848Ab0CQNjU (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 17 Mar 2010 09:39:20 -0400
In-Reply-To: <1268831945-6041-3-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> When extended status codes are available, such as ENOMEM on failed
> allocations, or subsequent functions (e.g. nf_ct_get_l3proto), passing
> them up to userspace seems like a good idea compared to just always
> EINVAL.

> diff --git a/net/bridge/netfilter/ebt_802_3.c b/net/bridge/netfilter/ebt_802_3.c
> index 5d11767..7b6f4c4 100644
> --- a/net/bridge/netfilter/ebt_802_3.c
> +++ b/net/bridge/netfilter/ebt_802_3.c
> @@ -36,7 +36,7 @@ ebt_802_3_mt(const struct sk_buff *skb, const struct xt_match_param *par)
>  	return true;
>  }
>  
> -static bool ebt_802_3_mt_check(const struct xt_mtchk_param *par)
> +static int ebt_802_3_mt_check(const struct xt_mtchk_param *par)
>  {
>  	const struct ebt_802_3_info *info = par->matchinfo;

Sigh, so we're basically going back to the old signatures. I guess
this makes sense, however iptables has special interpretations of
errno values. How will this interact?
