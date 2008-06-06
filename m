From: Patrick McHardy <kaber@trash.net>
Subject: Re: [ULOGD PATCH 2/5] New MARK filtering module.
Date: Fri, 06 Jun 2008 15:29:49 +0200
Message-ID: <48493BCD.4020605@trash.net>
References: <> <1212758035-19538-1-git-send-email-eric@inl.fr> <1212758035-19538-2-git-send-email-eric@inl.fr> <1212758035-19538-3-git-send-email-eric@inl.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@inl.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:44979 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754352AbYFFN3w (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 6 Jun 2008 09:29:52 -0400
In-Reply-To: <1212758035-19538-3-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eric Leblond wrote:
> +static struct config_keyset libulog_kset = {
> +	.num_ces = 2,
> +	.ces = {
> +		{
> +			.key 	 = "mark",
> +			.type 	 = CONFIG_TYPE_INT,
> +			.options = CONFIG_OPT_NONE,
> +			.u.value = 0,
> +		},
> +		{
> +			.key 	 = "mask",
> +			.type 	 = CONFIG_TYPE_INT,
> +			.options = CONFIG_OPT_NONE,
> +			.u.value = 0xffffffff,
> +		},
> +
> +	}
> +};
> +	
> +#define mark_ce(x)	(x->ces[0])
> +#define mask_ce(x)	(x->ces[1])


This magic value stuff is an error-prone mess in my opinion.
Could we for future modules agree to always do something like
this:

enum foo_keys {
	FOO_MARK,
	FOO_MASK,
	...
};

struct config_keyset foo_kset = {
...
	.ces = {
		[FOO_MARK] = {
			...
		},
	},
};

Or maybe resolve them at runtime using the key string in
performance uncritical paths?

