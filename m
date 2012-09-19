From: Jesper Dangaard Brouer <hawk@diku.dk>
Subject: Re: [RFC] Inter-match communication cache
Date: Wed, 19 Sep 2012 17:38:43 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.1209191720490.12601@ask.diku.dk>
References: <alpine.DEB.2.00.1209182232460.5113@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mgw2.diku.dk ([130.225.96.92]:40603 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755698Ab2ISPhM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 19 Sep 2012 11:37:12 -0400
In-Reply-To: <alpine.DEB.2.00.1209182232460.5113@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Tue, 18 Sep 2012, Jozsef Kadlecsik wrote:

> I propose a small cache for inter-match communication purpose:
>
> diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x_tables.h
> index 8d674a7..f07eab2 100644
> --- a/include/linux/netfilter/x_tables.h
> +++ b/include/linux/netfilter/x_tables.h
> @@ -216,6 +216,9 @@ struct xt_action_param {
> 		const void *matchinfo, *targinfo;
> 	};
> 	const struct net_device *in, *out;
> +#ifdef CONFIG_NETFILTER_XTABLES_CACHE
> +	u_int32_t cache;
> +#endif

Perhaps we should add it, that the end of the struct, to avoid too big ABI 
breakage.  And I generally don't like, adding compile time optional 
elements in the middle of a struct, as it make its harder to cache profile 
and padding/aligning the struct.

> 	int fragoff;
> 	unsigned int thoff;
> 	unsigned int hooknum;
> @@ -223,6 +226,15 @@ struct xt_action_param {
> 	bool hotdrop;
> };

>
> +enum xt_cache_owner {
> +	XT_CACHE_OWNER_NONE	= 0,
> +	XT_CACHE_OWNER_IPSET	= 1,
> +};
> +
> +#define XT_CACHE_GET_OWNER(cache)	 (((cache) & 0xFF000000) >> 24)
> +#define XT_CACHE_SET_OWNER(cache, owner) ((cache) |= (owner) << 24)
> +#define XT_CACHE_GET_VALUE(cache)	 ((cache) & 0x00FFFFFF)
> +

So, you are reserving 24 bit for data/"values". And we have 8 bits for 
setting an owner of this data.  Thats the basic idea right?


Cheers,
   Jesper Brouer

--
-------------------------------------------------------------------
MSc. Master of Computer Science
Dept. of Computer Science, University of Copenhagen
Author of http://www.adsl-optimizer.dk
-------------------------------------------------------------------
