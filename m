From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: nf_tables: fix racy rule deletion
Date: Thu, 6 Feb 2014 00:02:00 +0100
Message-ID: <20140205230200.GA3849@localhost>
References: <1390655031-4115-1-git-send-email-pablo@netfilter.org>
 <20140125135552.GA31554@macbook.localnet>
 <20140125163533.GA14235@macbook.localnet>
 <20140125171451.GA11373@macbook.localnet>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, arturo.borrero.glez@gmail.com
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48169 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753892AbaBEXCF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 5 Feb 2014 18:02:05 -0500
Content-Disposition: inline
In-Reply-To: <20140125171451.GA11373@macbook.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

> --- a/net/netfilter/nf_tables_api.c
> +++ b/net/netfilter/nf_tables_api.c
> @@ -1989,13 +1992,13 @@ static int nf_tables_set_alloc_name(struct nft_ctx *ctx, struct nft_set *set,
>  
>  			if (!sscanf(i->name, name, &tmp))
>  				continue;
> -			if (tmp < 0 || tmp > BITS_PER_LONG * PAGE_SIZE)
> +			if (tmp < 0 || tmp >= BITS_PER_BYTE * PAGE_SIZE)
>  				continue;
>  
>  			set_bit(tmp, inuse);
>  		}
>  
> -		n = find_first_zero_bit(inuse, BITS_PER_LONG * PAGE_SIZE);
> +		n = find_first_zero_bit(inuse, BITS_PER_BYTE * PAGE_SIZE);
>  		free_page((unsigned long)inuse);
>  	}
> 

Enqueued this chunk as fix for David, thanks Patrick.
