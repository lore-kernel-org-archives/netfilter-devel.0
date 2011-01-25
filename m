From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 00/13] ipset kernel patches v2
Date: Tue, 25 Jan 2011 16:38:28 +0100
Message-ID: <4D3EEE74.2010203@trash.net>
References: <1295618527-9583-1-git-send-email-kadlec@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:56311 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753093Ab1AYPih (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 25 Jan 2011 10:38:37 -0500
In-Reply-To: <1295618527-9583-1-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 21.01.2011 15:01, Jozsef Kadlecsik wrote:
> Eric suggested to use vzalloc instead of
> __vmalloc, however the former hasn't got a gfp_t argument, so I kept __vmalloc.

> +/* Utility functions */
> +void *
> +ip_set_alloc(size_t size, gfp_t gfp_mask)
> +{
> +	void *members = NULL;
> +
> +	if (size < KMALLOC_MAX_SIZE)
> +		members = kzalloc(size, gfp_mask | __GFP_NOWARN);
> +
> +	if (members) {
> +		pr_debug("%p: allocated with kmalloc\n", members);
> +		return members;
> +	}
> +
> +	members = __vmalloc(size, gfp_mask | __GFP_ZERO | __GFP_HIGHMEM,
> +			    PAGE_KERNEL);
> +	if (!members)
> +		return NULL;
> +	pr_debug("%p: allocated with vmalloc\n", members);
> +
> +	return members;
> +}

The gfp_t argument seems unnecessary since all users use GFP_KERNEL
and this is also the only reasonable choice since vmalloc() can't
be used in atomic context. So the only combination of flags that
is actually used is __GFP_ZERO | __GFP_HIGHMEM | __GFP_KERNEL,
which is exactly what vzalloc() uses.
