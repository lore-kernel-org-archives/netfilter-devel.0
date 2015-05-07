From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 03/34] netfilter: ipset: Introduce RCU locking in
 bitmap:* types
Date: Fri, 8 May 2015 01:01:58 +0200
Message-ID: <20150507230158.GA3407@salvia>
References: <1430587703-3387-1-git-send-email-kadlec@blackhole.kfki.hu>
 <1430587703-3387-4-git-send-email-kadlec@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42151 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751892AbbEGW5a (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 7 May 2015 18:57:30 -0400
Content-Disposition: inline
In-Reply-To: <1430587703-3387-4-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, May 02, 2015 at 07:27:52PM +0200, Jozsef Kadlecsik wrote:
> There's nothing much required because the bitmap types use atomic
> bit operations. However the logic of adding elements slightly changed:
> first the MAC address updated (which is not atomic), then the element
> activated (added).
> 
> Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
> ---
>  net/netfilter/ipset/ip_set_bitmap_gen.h   | 14 ++++++++++----
>  net/netfilter/ipset/ip_set_bitmap_ip.c    |  3 ++-
>  net/netfilter/ipset/ip_set_bitmap_ipmac.c | 13 +++++++++++--
>  net/netfilter/ipset/ip_set_bitmap_port.c  |  3 ++-
>  4 files changed, 25 insertions(+), 8 deletions(-)
> 
[...]
> diff --git a/net/netfilter/ipset/ip_set_bitmap_ip.c b/net/netfilter/ipset/ip_set_bitmap_ip.c
> index 55b083e..487513b 100644
> --- a/net/netfilter/ipset/ip_set_bitmap_ip.c
> +++ b/net/netfilter/ipset/ip_set_bitmap_ip.c
> @@ -80,7 +80,7 @@ static inline int
>  bitmap_ip_do_add(const struct bitmap_ip_adt_elem *e, struct bitmap_ip *map,
>  		 u32 flags, size_t dsize)
>  {
> -	return !!test_and_set_bit(e->id, map->members);
> +	return !!test_bit(e->id, map->members);
>  }
>  
>  static inline int
> @@ -377,6 +377,7 @@ bitmap_ip_init(void)
>  static void __exit
>  bitmap_ip_fini(void)
>  {
> +	rcu_barrier();

You need the rcu_barrier() if you kfree_rcu() or call_rcu().
Basically, this makes sure that rcu gives a chance to deferred
callbacks to run. I don't see any of this in this patch, so this may
have slipped through or it may not necessary.

> diff --git a/net/netfilter/ipset/ip_set_bitmap_ipmac.c b/net/netfilter/ipset/ip_set_bitmap_ipmac.c
> index 8610474..8f3f1cd 100644
> --- a/net/netfilter/ipset/ip_set_bitmap_ipmac.c
> +++ b/net/netfilter/ipset/ip_set_bitmap_ipmac.c
> @@ -146,15 +146,23 @@ bitmap_ipmac_do_add(const struct bitmap_ipmac_adt_elem *e,
>  	struct bitmap_ipmac_elem *elem;
>  
>  	elem = get_elem(map->extensions, e->id, dsize);
> -	if (test_and_set_bit(e->id, map->members)) {
> +	if (test_bit(e->id, map->members)) {
>  		if (elem->filled == MAC_FILLED) {
> -			if (e->ether && (flags & IPSET_FLAG_EXIST))
> +			if (e->ether &&
> +			    (flags & IPSET_FLAG_EXIST) &&
> +			    !ether_addr_equal(e->ether, elem->ether)) {
> +				/* memcpy isn't atomic */
> +				clear_bit(e->id, map->members);
> +				smp_mb__after_atomic();
>  				memcpy(elem->ether, e->ether, ETH_ALEN);
> +			}
>  			return IPSET_ADD_FAILED;
>  		} else if (!e->ether)
>  			/* Already added without ethernet address */
>  			return IPSET_ADD_FAILED;
>  		/* Fill the MAC address and trigger the timer activation */
> +		clear_bit(e->id, map->members);
> +		smp_mb__after_atomic();
>  		memcpy(elem->ether, e->ether, ETH_ALEN);
>  		elem->filled = MAC_FILLED;
>  		return IPSET_ADD_START_STORED_TIMEOUT;
> @@ -414,6 +422,7 @@ bitmap_ipmac_init(void)
>  static void __exit
>  bitmap_ipmac_fini(void)
>  {
> +	rcu_barrier();

Same thing here.

>  	ip_set_type_unregister(&bitmap_ipmac_type);
>  }
>  
> diff --git a/net/netfilter/ipset/ip_set_bitmap_port.c b/net/netfilter/ipset/ip_set_bitmap_port.c
> index 005dd36..e69619a 100644
> --- a/net/netfilter/ipset/ip_set_bitmap_port.c
> +++ b/net/netfilter/ipset/ip_set_bitmap_port.c
> @@ -73,7 +73,7 @@ static inline int
>  bitmap_port_do_add(const struct bitmap_port_adt_elem *e,
>  		   struct bitmap_port *map, u32 flags, size_t dsize)
>  {
> -	return !!test_and_set_bit(e->id, map->members);
> +	return !!test_bit(e->id, map->members);
>  }
>  
>  static inline int
> @@ -311,6 +311,7 @@ bitmap_port_init(void)
>  static void __exit
>  bitmap_port_fini(void)
>  {
> +	rcu_barrier();

And here.
