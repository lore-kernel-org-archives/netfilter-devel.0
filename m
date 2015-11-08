From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/1 net-next] net: bridge: netfilter: use vzalloc()
 instead of vmalloc() for counterstmp
Date: Sun, 8 Nov 2015 21:41:15 +0100
Message-ID: <20151108204115.GA2629@salvia>
References: <20151030123303.GA19481@mx.elandsys.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Loganaden Velvindron <logan@elandsys.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55691 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751331AbbKHUd4 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 8 Nov 2015 15:33:56 -0500
Content-Disposition: inline
In-Reply-To: <20151030123303.GA19481@mx.elandsys.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Oct 30, 2015 at 05:33:03AM -0700, Loganaden Velvindron wrote:
> counterstmp is not cleared before it is used in get_counters(). it might be 
> leaked partially when it is sent to userland later on.

get_counters() is memcpy'ing the old counter to the counterstmp area
and updating it.

Where is there leak?

> Signed-off-by: Loganaden Velvindron <logan@elandsys.com>
> ---
>  net/bridge/netfilter/ebtables.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
> index f46ca41..26922e9 100644
> --- a/net/bridge/netfilter/ebtables.c
> +++ b/net/bridge/netfilter/ebtables.c
> @@ -989,7 +989,7 @@ static int do_replace_finish(struct net *net, struct ebt_replace *repl,
>  	   the check on the size is done later, when we have the lock */
>  	if (repl->num_counters) {
>  		unsigned long size = repl->num_counters * sizeof(*counterstmp);
> -		counterstmp = vmalloc(size);
> +		counterstmp = vzalloc(size);
>  		if (!counterstmp)
>  			return -ENOMEM;
>  	}
> @@ -1410,7 +1410,7 @@ static int copy_counters_to_user(struct ebt_table *t,
>  		return -EINVAL;
>  	}
>  
> -	counterstmp = vmalloc(nentries * sizeof(*counterstmp));
> +	counterstmp = vzalloc(nentries * sizeof(*counterstmp));
>  	if (!counterstmp)
>  		return -ENOMEM;
>  
> -- 
> 2.6.1
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
