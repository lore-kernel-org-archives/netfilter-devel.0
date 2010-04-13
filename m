From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 4/6] netfilter: xtables2: make ip_tables reentrant
Date: Tue, 13 Apr 2010 11:57:29 +0200
Message-ID: <4BC44009.4080206@trash.net>
References: <1270666217-27670-1-git-send-email-jengelh@medozas.de> <1270666217-27670-5-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org,
	YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:45932 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751231Ab0DMJ5b (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 13 Apr 2010 05:57:31 -0400
In-Reply-To: <1270666217-27670-5-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
> index 8e23d8f..2010b56 100644
> --- a/net/netfilter/x_tables.c
> +++ b/net/netfilter/x_tables.c
> @@ -62,6 +62,11 @@ static const char *const xt_prefix[NFPROTO_NUMPROTO] = {
>  	[NFPROTO_IPV6]   = "ip6",
>  };
>  
> +/* Allow this many total (re)entries. */
> +static unsigned int xt_jumpstack_multiplier = 2;
> +module_param_named(jumpstack_multiplier, xt_jumpstack_multiplier,
> +	uint, S_IRUGO | S_IWUSR);
> +

This seems very wrong. Why should the user care about this?

I still don't like this patch very much, its only used for a very
special case and I'm not convinced that reentrancy of TEE'ed packets
is enough justification for this. Perhaps actually getting rid of
the per-cpu copies of the ruleset could convince me :)
