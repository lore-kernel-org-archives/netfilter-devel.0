From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 08/10] netfilter: ipset: Introduce RCU in all set types
 instead of rwlock per set
Date: Wed, 26 Nov 2014 14:14:34 +0100
Message-ID: <20141126131434.GA1671@salvia>
References: <1416862012-31139-1-git-send-email-kadlec@blackhole.kfki.hu>
 <1416862012-31139-9-git-send-email-kadlec@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57910 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750884AbaKZNMj (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 26 Nov 2014 08:12:39 -0500
Content-Disposition: inline
In-Reply-To: <1416862012-31139-9-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Nov 24, 2014 at 09:46:50PM +0100, Jozsef Kadlecsik wrote:
> Performance is tested by Jesper Dangaard Brouer:
> 
> Simple drop in FORWARD
> ~~~~~~~~~~~~~~~~~~~~
> 
> Dropping via simple iptables net-mask match::
> 
>  iptables -t raw -N simple || iptables -t raw -F simple
>  iptables -t raw -I simple  -s 198.18.0.0/15 -j DROP
>  iptables -t raw -D PREROUTING -j simple
>  iptables -t raw -I PREROUTING -j simple
> 
> Drop performance in "raw": 11.3Mpps
> 
> Generator: sending 12.2Mpps (tx:12264083 pps)
> 
> Drop via original ipset in RAW table
> ~~~~~~~~~~~~~~~~~~~~~~~~~
> 
> Create a set with lots of elements::
>  sudo ./ipset destroy test
>  echo "create test hash:ip hashsize 65536" > test.set
>  for x in `seq 0 255`; do
>     for y in `seq 0 255`; do
>         echo "add test 198.18.$x.$y" >> test.set
>     done
>  done
>  sudo ./ipset restore < test.set
> 
> Dropping via ipset::
> 
>  iptables -t raw -F
>  iptables -t raw -N net198 || iptables -t raw -F net198
>  iptables -t raw -I net198 -m set --match-set test src -j DROP
>  iptables -t raw -I PREROUTING -j net198
> 
> Drop performance in "raw" with ipset: 8Mpps
> 
> Perf report numbers ipset drop in "raw"::
> 
>  +   24.65%  ksoftirqd/1  [ip_set]           [k] ip_set_test
>  -   21.42%  ksoftirqd/1  [kernel.kallsyms]  [k] _raw_read_lock_bh
>     - _raw_read_lock_bh
>        + 99.88% ip_set_test
>  -   19.42%  ksoftirqd/1  [kernel.kallsyms]  [k] _raw_read_unlock_bh
>     - _raw_read_unlock_bh
>        + 99.72% ip_set_test
>  +    4.31%  ksoftirqd/1  [ip_set_hash_ip]   [k] hash_ip4_kadt
>  +    2.27%  ksoftirqd/1  [ixgbe]            [k] ixgbe_fetch_rx_buffer
>  +    2.18%  ksoftirqd/1  [ip_tables]        [k] ipt_do_table
>  +    1.81%  ksoftirqd/1  [ip_set_hash_ip]   [k] hash_ip4_test
>  +    1.61%  ksoftirqd/1  [kernel.kallsyms]  [k] __netif_receive_skb_core
>  +    1.44%  ksoftirqd/1  [kernel.kallsyms]  [k] build_skb
>  +    1.42%  ksoftirqd/1  [kernel.kallsyms]  [k] ip_rcv
>  +    1.36%  ksoftirqd/1  [kernel.kallsyms]  [k] __local_bh_enable_ip
>  +    1.16%  ksoftirqd/1  [kernel.kallsyms]  [k] dev_gro_receive
>  +    1.09%  ksoftirqd/1  [kernel.kallsyms]  [k] __rcu_read_unlock
>  +    0.96%  ksoftirqd/1  [ixgbe]            [k] ixgbe_clean_rx_irq
>  +    0.95%  ksoftirqd/1  [kernel.kallsyms]  [k] __netdev_alloc_frag
>  +    0.88%  ksoftirqd/1  [kernel.kallsyms]  [k] kmem_cache_alloc
>  +    0.87%  ksoftirqd/1  [xt_set]           [k] set_match_v3
>  +    0.85%  ksoftirqd/1  [kernel.kallsyms]  [k] inet_gro_receive
>  +    0.83%  ksoftirqd/1  [kernel.kallsyms]  [k] nf_iterate
>  +    0.76%  ksoftirqd/1  [kernel.kallsyms]  [k] put_compound_page
>  +    0.75%  ksoftirqd/1  [kernel.kallsyms]  [k] __rcu_read_lock
> 
> Drop via ipset in RAW table with RCU-locking
> ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> 
> With RCU locking, the RW-lock is gone.
> 
> Drop performance in "raw" with ipset with RCU-locking: 11.3Mpps
> 
> Performance-tested-by: Jesper Dangaard Brouer <brouer@redhat.com>
> Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
> ---
>  include/linux/netfilter/ipset/ip_set.h         |  82 +++-
>  include/linux/netfilter/ipset/ip_set_timeout.h |  39 +-
>  net/netfilter/ipset/ip_set_bitmap_gen.h        |   8 +-
>  net/netfilter/ipset/ip_set_bitmap_ipmac.c      |   2 +-
>  net/netfilter/ipset/ip_set_core.c              |  35 +-
>  net/netfilter/ipset/ip_set_hash_gen.h          | 547 +++++++++++++++----------
>  net/netfilter/ipset/ip_set_list_set.c          | 386 ++++++++---------
>  7 files changed, 614 insertions(+), 485 deletions(-)
> 
> diff --git a/include/linux/netfilter/ipset/ip_set.h b/include/linux/netfilter/ipset/ip_set.h
> index f1606fa..418d360 100644
> --- a/include/linux/netfilter/ipset/ip_set.h
> +++ b/include/linux/netfilter/ipset/ip_set.h
> @@ -113,10 +113,10 @@ struct ip_set_comment {
>  };
>  
>  struct ip_set_skbinfo {
> -	u32 skbmark;
> -	u32 skbmarkmask;
> -	u32 skbprio;
> -	u16 skbqueue;
> +	u32 __rcu skbmark;
> +	u32 __rcu skbmarkmask;
> +	u32 __rcu skbprio;
> +	u16 __rcu skbqueue;
>  };
>  
>  struct ip_set;
> @@ -223,7 +223,7 @@ struct ip_set {
>  	/* The name of the set */
>  	char name[IPSET_MAXNAMELEN];
>  	/* Lock protecting the set data */
> -	rwlock_t lock;
> +	spinlock_t lock;
>  	/* References to the set */
>  	u32 ref;
>  	/* The core set type */
> @@ -322,30 +322,72 @@ ip_set_update_counter(struct ip_set_counter *counter,
>  	}
>  }
>  
> +/* RCU-safe assign value */
> +#define IP_SET_RCU_ASSIGN(ptr, value)	\
> +do {					\
> +	smp_wmb();			\
> +	*(ptr) = value;			\
> +} while (0)
> +
> +static inline void
> +ip_set_rcu_assign_ulong(unsigned long *v, unsigned long value)
> +{
> +	IP_SET_RCU_ASSIGN(v, value);
> +}
> +
> +static inline void
> +ip_set_rcu_assign_u32(u32 *v, u32 value)
> +{
> +	IP_SET_RCU_ASSIGN(v, value);
> +}
> +
> +static inline void
> +ip_set_rcu_assign_u16(u16 *v, u16 value)
> +{
> +	IP_SET_RCU_ASSIGN(v, value);
> +}
> +
> +static inline void
> +ip_set_rcu_assign_u8(u8 *v, u8 value)
> +{
> +	IP_SET_RCU_ASSIGN(v, value);
> +}

No questions regarding numbers, but I would like to see some
explanation on the RCU approach that you're implementing in this
patch. Thanks.
