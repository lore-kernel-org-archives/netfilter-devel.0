From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 11/14] netfilter: ipset: Introduce RCU locking in the
 hash types
Date: Tue, 2 Dec 2014 19:40:12 +0100
Message-ID: <20141202184012.GD4504@salvia>
References: <1417373825-3734-1-git-send-email-kadlec@blackhole.kfki.hu>
 <1417373825-3734-12-git-send-email-kadlec@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56687 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753906AbaLBSh4 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 2 Dec 2014 13:37:56 -0500
Content-Disposition: inline
In-Reply-To: <1417373825-3734-12-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Nov 30, 2014 at 07:57:02PM +0100, Jozsef Kadlecsik wrote:
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
>  net/netfilter/ipset/ip_set_hash_gen.h | 580 ++++++++++++++++++++--------------
>  1 file changed, 344 insertions(+), 236 deletions(-)
> 
> diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/ip_set_hash_gen.h
> index 974ff38..8f51ba4 100644
> --- a/net/netfilter/ipset/ip_set_hash_gen.h
> +++ b/net/netfilter/ipset/ip_set_hash_gen.h
> @@ -10,19 +10,19 @@
>  
>  #include <linux/rcupdate.h>
>  #include <linux/jhash.h>
> +#include <linux/types.h>
>  #include <linux/netfilter/ipset/ip_set_timeout.h>
> -#ifndef rcu_dereference_bh
> -#define rcu_dereference_bh(p)	rcu_dereference(p)
> -#endif
> +
> +#define __ipset_dereference_protected(p, c)	rcu_dereference_protected(p, c)
> +#define ipset_dereference_protected(p, set) \
> +	__ipset_dereference_protected(p, spin_is_locked(&(set)->lock))
>  
>  #define rcu_dereference_bh_nfnl(p)	rcu_dereference_bh_check(p, 1)
>  
[...]
>  /* Flush a hash type of set: destroy all elements */
> @@ -376,16 +359,16 @@ mtype_flush(struct ip_set *set)
>  	struct hbucket *n;
>  	u32 i;
>  
> -	t = rcu_dereference_bh_nfnl(h->table);
> +	t = ipset_dereference_protected(h->table, set);
>  	for (i = 0; i < jhash_size(t->htable_bits); i++) {
> -		n = hbucket(t, i);
> -		if (n->size) {
> -			if (set->extensions & IPSET_EXT_DESTROY)
> -				mtype_ext_cleanup(set, n);
> -			n->size = n->pos = 0;
> -			/* FIXME: use slab cache */
> -			kfree(n->value);
> -		}
> +		n = __ipset_dereference_protected(hbucket(t, i), 1);

What is your intention with these macros?
