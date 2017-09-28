From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH] netfilter: ipset: Fix race between dump and swap
Date: Thu, 28 Sep 2017 12:31:02 +0200 (CEST)
Message-ID: <alpine.DEB.2.11.1709281230100.24013@blackhole.kfki.hu>
References: <20170927090627.26355-1-ross.lagerwall@citrix.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>
To: Ross Lagerwall <ross.lagerwall@citrix.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp0.kfki.hu ([148.6.0.25]:48164 "EHLO smtp0.kfki.hu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751880AbdI1KbH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 28 Sep 2017 06:31:07 -0400
In-Reply-To: <20170927090627.26355-1-ross.lagerwall@citrix.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, 27 Sep 2017, Ross Lagerwall wrote:

> Fix a race between ip_set_dump_start() and ip_set_swap().
> The race is as follows:
> * Without holding the ref lock, ip_set_swap() checks ref_netlink of the
>   set and it is 0.
> * ip_set_dump_start() takes a reference on the set.
> * ip_set_swap() does the swap (even though it now has a non-zero
>   reference count).
> * ip_set_dump_start() gets the set from ip_set_list again which is now a
>   different set since it has been swapped.
> * ip_set_dump_start() calls __ip_set_put_netlink() and hits a BUG_ON due
>   to the reference count being 0.
> 
> Fix this race by extending the critical region in which the ref lock is
> held to include checking the ref counts.
> 
> The race can be reproduced with the following script:
>   while :; do
>     ipset destroy hash_ip1
>     ipset destroy hash_ip2
>     ipset create hash_ip1 hash:ip family inet hashsize 1024 \
>         maxelem 500000
>     ipset create hash_ip2 hash:ip family inet hashsize 300000 \
>         maxelem 500000
>     ipset create hash_ip3 hash:ip family inet hashsize 1024 \
>         maxelem 500000
>     ipset save &
>     ipset swap hash_ip3 hash_ip2
>     ipset destroy hash_ip3
>     wait
>   done
> 
> Signed-off-by: Ross Lagerwall <ross.lagerwall@citrix.com>

Acked-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>

Good catch, Pablo please apply in the nf tree. Thanks!

Best regards,
Jozsef

> ---
>  net/netfilter/ipset/ip_set_core.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set_core.c
> index ba6a551..cae3e4a 100644
> --- a/net/netfilter/ipset/ip_set_core.c
> +++ b/net/netfilter/ipset/ip_set_core.c
> @@ -1185,14 +1185,17 @@ static int ip_set_swap(struct net *net, struct sock *ctnl, struct sk_buff *skb,
>  	      from->family == to->family))
>  		return -IPSET_ERR_TYPE_MISMATCH;
>  
> -	if (from->ref_netlink || to->ref_netlink)
> +	write_lock_bh(&ip_set_ref_lock);
> +
> +	if (from->ref_netlink || to->ref_netlink) {
> +		write_unlock_bh(&ip_set_ref_lock);
>  		return -EBUSY;
> +	}
>  
>  	strncpy(from_name, from->name, IPSET_MAXNAMELEN);
>  	strncpy(from->name, to->name, IPSET_MAXNAMELEN);
>  	strncpy(to->name, from_name, IPSET_MAXNAMELEN);
>  
> -	write_lock_bh(&ip_set_ref_lock);
>  	swap(from->ref, to->ref);
>  	ip_set(inst, from_id) = to;
>  	ip_set(inst, to_id) = from;
> -- 
> 2.9.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
