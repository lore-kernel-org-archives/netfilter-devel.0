From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: Resend: One bug in the xt_hashlimit.c
Date: Mon, 17 Dec 2012 00:01:20 +0100
Message-ID: <20121216230120.GA5191@1984>
References: <CA+6hz4oJ3g3z49z44nN02DJtkHDkF5tiNH-nDH3thdD3GYUg7A@mail.gmail.com>
 <alpine.LNX.2.01.1212161822470.27614@nerf07.vanv.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Feng Gao <gfree.wind@gmail.com>, laforge@netfilter.org,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51109 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750981Ab2LPXBY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 16 Dec 2012 18:01:24 -0500
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.01.1212161822470.27614@nerf07.vanv.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Dec 16, 2012 at 06:39:56PM +0100, Jan Engelhardt wrote:
[...]
> What would you think of the following patch?
> 
> diff --git a/net/netfilter/xt_hashlimit.c b/net/netfilter/xt_hashlimit.c
> index 26a668a..0d17032 100644
> --- a/net/netfilter/xt_hashlimit.c
> +++ b/net/netfilter/xt_hashlimit.c
> @@ -591,9 +591,11 @@ hashlimit_mt(const struct sk_buff *skb, struct xt_action_param *par)
>  		goto hotdrop;
>  
>  	rcu_read_lock_bh();
> +	spin_lock_bh();
>  	dh = dsthash_find(hinfo, &dst);
>  	if (dh == NULL) {
>  		dh = dsthash_alloc_init(hinfo, &dst);
> +		spin_unlock_bh();

This is sub-optimal and RCU becomes almost useless with this approach.

The way to fix this is to follow a similar approach to what
nf_conntrack does to avoid this race.

>  		if (dh == NULL) {
>  			rcu_read_unlock_bh();
>  			goto hotdrop;
> @@ -601,6 +603,7 @@ hashlimit_mt(const struct sk_buff *skb, struct xt_action_param *par)
>  		dh->expires = jiffies + msecs_to_jiffies(hinfo->cfg.expire);
>  		rateinfo_init(dh, hinfo);
>  	} else {
> +		spin_unlock_bh();
>  		/* update expiration timeout */
>  		dh->expires = now + msecs_to_jiffies(hinfo->cfg.expire);
>  		rateinfo_recalc(dh, now, hinfo->cfg.mode);
