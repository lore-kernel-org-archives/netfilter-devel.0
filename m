From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 3/9] netfilter: xtables: make use of xt_request_find_target
Date: Tue, 23 Mar 2010 15:24:13 +0100
Message-ID: <4BA8CF0D.1090707@trash.net>
References: <1269285486-22653-1-git-send-email-jengelh@medozas.de> <1269285486-22653-4-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:58890 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751707Ab0CWOYP (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 23 Mar 2010 10:24:15 -0400
In-Reply-To: <1269285486-22653-4-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
> index f07d77f..0665e1b 100644
> --- a/net/ipv4/netfilter/arp_tables.c
> +++ b/net/ipv4/netfilter/arp_tables.c
> @@ -523,13 +523,11 @@ find_check_entry(struct arpt_entry *e, const char *name, unsigned int size)
>  		return ret;
>  
>  	t = arpt_get_target(e);
> -	target = try_then_request_module(xt_find_target(NFPROTO_ARP,
> -							t->u.user.name,
> -							t->u.user.revision),
> -					 "arpt_%s", t->u.user.name);
> -	if (IS_ERR(target) || !target) {
> +	target = xt_request_find_target(NFPROTO_ARP, t->u.user.name,
> +	         t->u.user.revision);
>   
Indentation according to maintainers taste, please :)

> +	if (IS_ERR(target)) {
>  		duprintf("find_check_entry: `%s' not found\n", t->u.user.name);
> -		ret = target ? PTR_ERR(target) : -ENOENT;
> +		ret = PTR_ERR(target);
>  		goto out;
>  	}



