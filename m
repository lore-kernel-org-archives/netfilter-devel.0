From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] netfilter: xt_hashlimit: restore per-rule effectiveness
Date: Wed, 06 Oct 2010 15:54:18 +0200
Message-ID: <4CAC7F8A.5080703@trash.net>
References: <1286346523-9476-1-git-send-email-jengelh@medozas.de> <1286346523-9476-2-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:41847 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756548Ab0JFNyU (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 6 Oct 2010 09:54:20 -0400
In-Reply-To: <1286346523-9476-2-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Am 06.10.2010 08:28, schrieb Jan Engelhardt:
> When adding a second hashlimit rule with the same name, its parameters
> had no effect, because it had used a copy of the first one's inner
> state.

I'm not sure we can change this behaviour at this point. There's at
least one change in your patch that changes the default behaviour,
you can currently create a second rule for a table witout specifying
the mode and it will re-use the mode from the first rule. With your
patch this will result in an error due to the unfortunate fact that
the kernel doesn't check for valid modes. Having entries for rules
with different modes also would require to initalize all members
since a different rule might want to match on them. This again
doesn't work with the way masking is currently implemented.

> @@ -452,34 +456,34 @@ hashlimit_init_dst(const struct xt_hashlimit_htable *hinfo,
>  
>  	memset(dst, 0, sizeof(*dst));
>  
> -	switch (hinfo->family) {
> +	switch (family) {

This also looks problematic, the entries don't include the family
themselves, so you're allowing tables to contain entries of multiple
families, which might cause mismatches.

>  	case NFPROTO_IPV4:
> -		if (hinfo->cfg.mode & XT_HASHLIMIT_HASH_DIP)
> +		if (info->cfg.mode & XT_HASHLIMIT_HASH_DIP)
>  			dst->ip.dst = maskl(ip_hdr(skb)->daddr,
> -			              hinfo->cfg.dstmask);
> -		if (hinfo->cfg.mode & XT_HASHLIMIT_HASH_SIP)
> +			              info->cfg.dstmask);
> +		if (info->cfg.mode & XT_HASHLIMIT_HASH_SIP)
>  			dst->ip.src = maskl(ip_hdr(skb)->saddr,
> -			              hinfo->cfg.srcmask);
> +			              info->cfg.srcmask);
>  
> -		if (!(hinfo->cfg.mode &
> +		if (!(info->cfg.mode &
>  		      (XT_HASHLIMIT_HASH_DPT | XT_HASHLIMIT_HASH_SPT)))
>  			return 0;
>  		nexthdr = ip_hdr(skb)->protocol;
>  		break;
