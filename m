From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 5/9] netfilter: xtables: limit xt_mac to ethernet devices
Date: Wed, 17 Mar 2010 14:31:29 +0100
Message-ID: <4BA0D9B1.4050809@trash.net>
References: <1268831945-6041-1-git-send-email-jengelh@medozas.de> <1268831945-6041-6-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:57631 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754873Ab0CQNba (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 17 Mar 2010 09:31:30 -0400
In-Reply-To: <1268831945-6041-6-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> I do not see a point of allowing the MAC module to work with devices
> that don't possibly have one, e.g. various tunnel interfaces such as
> tun and sit.

> @@ -29,6 +30,8 @@ static bool mac_mt(const struct sk_buff *skb, const struct xt_match_param *par)
>  	const struct xt_mac_info *info = par->matchinfo;
>  	bool ret;
>  
> +	if (skb->dev == NULL || skb->dev->type != ARPHRD_ETHER)
> +		return false;

What about the ~60 ARPHRD values that are not tunnels and sit?
