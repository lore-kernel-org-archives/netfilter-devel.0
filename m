From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 12/14] netfilter: ipset: styles warned by checkpatch.pl
 fixed
Date: Tue, 2 Dec 2014 19:43:43 +0100
Message-ID: <20141202184343.GE4504@salvia>
References: <1417373825-3734-1-git-send-email-kadlec@blackhole.kfki.hu>
 <1417373825-3734-13-git-send-email-kadlec@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57131 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753776AbaLBSl1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 2 Dec 2014 13:41:27 -0500
Content-Disposition: inline
In-Reply-To: <1417373825-3734-13-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Nov 30, 2014 at 07:57:03PM +0100, Jozsef Kadlecsik wrote:
> Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
> ---
>  include/linux/netfilter/ipset/ip_set.h       |  6 +++---
>  net/netfilter/ipset/ip_set_core.c            | 11 ++++++++---
>  net/netfilter/ipset/ip_set_hash_ipportnet.c  |  2 ++
>  net/netfilter/ipset/ip_set_hash_net.c        |  4 +++-
>  net/netfilter/ipset/ip_set_hash_netiface.c   |  2 ++
>  net/netfilter/ipset/ip_set_hash_netnet.c     |  2 ++
>  net/netfilter/ipset/ip_set_hash_netport.c    |  2 ++
>  net/netfilter/ipset/ip_set_hash_netportnet.c |  2 ++
>  net/netfilter/xt_set.c                       |  7 +++++++
>  net/sched/em_ipset.c                         |  5 ++++-
>  10 files changed, 35 insertions(+), 8 deletions(-)
> 
> diff --git a/include/linux/netfilter/ipset/ip_set.h b/include/linux/netfilter/ipset/ip_set.h
> index d5d5bcd..f7fcb6e 100644
> --- a/include/linux/netfilter/ipset/ip_set.h
> +++ b/include/linux/netfilter/ipset/ip_set.h
> @@ -345,10 +345,10 @@ ip_set_put_skbinfo(struct sk_buff *skb, struct ip_set_skbinfo *skbinfo)
>  			      cpu_to_be64((u64)skbinfo->skbmark << 32 |
>  					  skbinfo->skbmarkmask))) ||
>  	       (skbinfo->skbprio &&
> -	        nla_put_net32(skb, IPSET_ATTR_SKBPRIO,
> +		nla_put_net32(skb, IPSET_ATTR_SKBPRIO,
>  			      cpu_to_be32(skbinfo->skbprio))) ||
>  	       (skbinfo->skbqueue &&
> -	        nla_put_net16(skb, IPSET_ATTR_SKBQUEUE,
> +		nla_put_net16(skb, IPSET_ATTR_SKBQUEUE,
>  			     cpu_to_be16(skbinfo->skbqueue)));
>  
>  }
> @@ -547,7 +547,7 @@ ip_set_put_extensions(struct sk_buff *skb, const struct ip_set *set,
>  
>  		if (nla_put_net32(skb, IPSET_ATTR_TIMEOUT,
>  			htonl(active ? ip_set_timeout_get(timeout)
> -				: *timeout)))
> +			      : *timeout)))

This seems to fit here in the 80-chars line, please recheck.
