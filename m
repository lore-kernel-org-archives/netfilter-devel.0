From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 4/4] netfilter: xtables: generate initial table on-demand
Date: Wed, 10 Feb 2010 16:32:40 +0100
Message-ID: <4B72D198.7040204@trash.net>
References: <1265813954-13854-1-git-send-email-jengelh@medozas.de> <1265813954-13854-5-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:53175 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752464Ab0BJPcu (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Feb 2010 10:32:50 -0500
In-Reply-To: <1265813954-13854-5-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> +void *arpt_alloc_initial_table(const struct xt_table *info)
> +{
> +	return xt_repldata_mk(arpt, ARPT);

I vaguely recall asking for a nicer (more pronouncable) name.
xt_alloc_initial_table() perhaps? xt_init_table()?

>  static int __net_init nf_nat_rule_net_init(struct net *net)
>  {
> -	net->ipv4.nat_table = ipt_register_table(net, &nat_table,
> -						 &nat_initial_table.repl);
> +	struct ipt_replace *repl = ipt_alloc_initial_table(&nat_table);
> +

Minor request: I'd prefer to have the allocation next to the NULL check
instead of in the variable definition.

> +	if (repl == NULL)
> +		return -ENOMEM;
> +	net->ipv4.nat_table = ipt_register_table(net, &nat_table, repl);
> +	kfree(repl);
>  	if (IS_ERR(net->ipv4.nat_table))
>  		return PTR_ERR(net->ipv4.nat_table);
>  	return 0;
