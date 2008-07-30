From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 4/7] Helper modules load on-demand support for ctnetlink
Date: Wed, 30 Jul 2008 15:35:12 +0200
Message-ID: <48906E10.9020902@trash.net>
References: <48904A9F.8010509@netfilter.org> <48904C3B.7060004@trash.net> <48905083.1040002@netfilter.org> <4890519C.80407@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:48334 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752314AbYG3NfU (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Jul 2008 09:35:20 -0400
In-Reply-To: <4890519C.80407@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso wrote:
> Sorry, it's wrong. Please, take this.

> @@ -1672,9 +1660,24 @@ ctnetlink_create_expect(struct nlattr *c
>  	help = nfct_help(ct);
>  
>  	if (!help || !help->helper) {
> -		/* such conntrack hasn't got any helper, abort */
> +#ifdef CONFIG_KMOD
> +		char *name;
> +
>  		err = -EINVAL;
> +		if (!cda[CTA_EXPECT_HELP_NAME])
> +			goto out;
> +
> +		err = -ENOTSUPP;
> +		name = nla_data(cda[CTA_EXPECT_HELP_NAME]);
> +		if (request_module("nfct-helper-%s", name) < 0)
> +			goto out;
> +
> +		if (nf_ct_set_helper(ct, GFP_KERNEL) < 0)
> +			goto out;

This strikes me as quite inconsistent. First, we only perform
autoloading for expectation creation, but not for conntracks.
Second, this implicit helper assignment is also a bit unusual,
why don't we simply insist that the conntrack has a helper
assigned through the ctnetlink conntrack interface?
