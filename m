From: Amin Azez <azez@ufomechanic.net>
Subject: Re: [PATCH] conntrack-event-api
Date: Tue, 19 Jul 2005 14:43:55 +0100
Message-ID: <42DD039B.4090207@ufomechanic.net>
References: <20050719201646.GH3768@rama>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <20050719201646.GH3768@rama>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Harald Welte wrote:
> Hi!
> 
> Here's a revamped conntrack-event-api patch.  Instead of using
> skb->nfcache, we now use a per-cpu data structure.  This saves 32bit in
> sk_buff.
> 
> I did not yet merge Pablo's latest change[s], namely moving generation
> of DESTROY events into conntrack_destroy().
> 
> (this patch is inceremental to my two recent patches regarding nfcache
> and nfctinfo from the day before yesterday).

I'm just trying to understand the basis of this change.
Is it that:
1) a CPU is only processing one SKB at a time
2) then it entirely finishes that SKB before it processes another
3) and that the event data does not need to persist for the life of the
conntrack, only the life of that skb

therefore a per cpu variable is very suitable.

Do we see this breaking anytime, perhaps through some extended kernel
pre-emption trick or something, or is the conntrack stuff here always
going to run as a bh?

Azez


> 
> 
> 
> ------------------------------------------------------------------------
> 
> diff --git a/include/linux/netfilter_ipv4/ip_conntrack.h b/include/linux/netfilter_ipv4/ip_conntrack.h
> --- a/include/linux/netfilter_ipv4/ip_conntrack.h
> +++ b/include/linux/netfilter_ipv4/ip_conntrack.h
> @@ -65,6 +65,63 @@ enum ip_conntrack_status {
>  
>  	/* Both together */
>  	IPS_NAT_DONE_MASK = (IPS_DST_NAT_DONE | IPS_SRC_NAT_DONE),
> +
> +	/* Connection is dying (removed from lists), can not be unset. */
> +	IPS_DYING_BIT = 9,
> +	IPS_DYING = (1 << IPS_DYING_BIT),
> +};
> +
> +/* Connection tracking event bits */
> +enum ip_conntrack_events
> +{
> +	/* New conntrack */
> +	IPCT_NEW_BIT = 0,
> +	IPCT_NEW = (1 << IPCT_NEW_BIT),
> +
> +	/* Expected connection */
> +	IPCT_RELATED_BIT = 1,
> +	IPCT_RELATED = (1 << IPCT_RELATED_BIT),
> +
> +	/* Destroyed conntrack */
> +	IPCT_DESTROY_BIT = 2,
> +	IPCT_DESTROY = (1 << IPCT_DESTROY_BIT),
> +
> +	/* Timer has been refreshed */
> +	IPCT_REFRESH_BIT = 3,
> +	IPCT_REFRESH = (1 << IPCT_REFRESH_BIT),
> +
> +	/* Status has changed */
> +	IPCT_STATUS_BIT = 4,
> +	IPCT_STATUS = (1 << IPCT_STATUS_BIT),
> +
> +	/* Update of protocol info */
> +	IPCT_PROTOINFO_BIT = 5,
> +	IPCT_PROTOINFO = (1 << IPCT_PROTOINFO_BIT),
> +
> +	/* Volatile protocol info */
> +	IPCT_PROTOINFO_VOLATILE_BIT = 6,
> +	IPCT_PROTOINFO_VOLATILE = (1 << IPCT_PROTOINFO_VOLATILE_BIT),
> +
> +	/* New helper for conntrack */
> +	IPCT_HELPER_BIT = 7,
> +	IPCT_HELPER = (1 << IPCT_HELPER_BIT),
> +
> +	/* Update of helper info */
> +	IPCT_HELPINFO_BIT = 8,
> +	IPCT_HELPINFO = (1 << IPCT_HELPINFO_BIT),
> +
> +	/* Volatile helper info */
> +	IPCT_HELPINFO_VOLATILE_BIT = 9,
> +	IPCT_HELPINFO_VOLATILE = (1 << IPCT_HELPINFO_VOLATILE_BIT),
> +
> +	/* NAT info */
> +	IPCT_NATINFO_BIT = 10,
> +	IPCT_NATINFO = (1 << IPCT_NATINFO_BIT),
> +};
> +
> +enum ip_conntrack_expect_events {
> +	IPEXP_NEW_BIT = 0,
> +	IPEXP_NEW = (1 << IPEXP_NEW_BIT),
>  };
>  
>  #ifdef __KERNEL__
> @@ -277,6 +334,11 @@ static inline int is_confirmed(struct ip
>  	return test_bit(IPS_CONFIRMED_BIT, &ct->status);
>  }
>  
> +static inline int is_dying(struct ip_conntrack *ct)
> +{
> +	return test_bit(IPS_DYING_BIT, &ct->status);
> +}
> +
>  extern unsigned int ip_conntrack_htable_size;
>   
>  struct ip_conntrack_stat
> @@ -300,6 +362,88 @@ struct ip_conntrack_stat
>  
>  #define CONNTRACK_STAT_INC(count) (__get_cpu_var(ip_conntrack_stat).count++)
>  
> +#ifdef CONFIG_IP_NF_CONNTRACK_EVENTS
> +#include <linux/notifier.h>
> +
> +struct ip_conntrack_ecache {
> +	struct ip_conntrack *ct;
> +	unsigned int events;
> +};
> +DECLARE_PER_CPU(struct ip_conntrack_ecache, ip_conntrack_ecache);
> +
> +#define CONNTRACK_ECACHE(x)	(__get_cpu_var(ip_conntrack_ecache).x)
> + 
> +extern struct notifier_block *ip_conntrack_chain;
> +extern struct notifier_block *ip_conntrack_expect_chain;
> +
> +static inline int ip_conntrack_register_notifier(struct notifier_block *nb)
> +{
> +	return notifier_chain_register(&ip_conntrack_chain, nb);
> +}
> +
> +static inline int ip_conntrack_unregister_notifier(struct notifier_block *nb)
> +{
> +	return notifier_chain_unregister(&ip_conntrack_chain, nb);
> +}
> +
> +static inline int 
> +ip_conntrack_expect_register_notifier(struct notifier_block *nb)
> +{
> +	return notifier_chain_register(&ip_conntrack_expect_chain, nb);
> +}
> +
> +static inline int
> +ip_conntrack_expect_unregister_notifier(struct notifier_block *nb)
> +{
> +	return notifier_chain_unregister(&ip_conntrack_expect_chain, nb);
> +}
> +
> +static inline void 
> +ip_conntrack_event_cache(enum ip_conntrack_events event,
> +			 const struct sk_buff *skb)
> +{
> +	struct ip_conntrack_ecache *ecache = 
> +					&__get_cpu_var(ip_conntrack_ecache);
> +
> +	if (unlikely((struct ip_conntrack *) skb->nfct != ecache->ct)) {
> +		if (net_ratelimit()) {
> +			printk(KERN_ERR "ctevent: skb->ct != ecache->ct !!!\n");
> +			dump_stack();
> +		}
> +	}
> +	ecache->events |= event;
> +}
> +
> +extern void 
> +ip_conntrack_deliver_cached_events_for(const struct ip_conntrack *ct);
> +extern void ip_conntrack_event_cache_init(const struct sk_buff *skb);
> +
> +static inline void ip_conntrack_event(enum ip_conntrack_events event,
> +				      struct ip_conntrack *ct)
> +{
> +	if (is_confirmed(ct) && !is_dying(ct))
> +		notifier_call_chain(&ip_conntrack_chain, event, ct);
> +}
> +
> +static inline void 
> +ip_conntrack_expect_event(enum ip_conntrack_expect_events event,
> +			  struct ip_conntrack_expect *exp)
> +{
> +	notifier_call_chain(&ip_conntrack_expect_chain, event, exp);
> +}
> +#else /* CONFIG_IP_NF_CONNTRACK_EVENTS */
> +static inline void ip_conntrack_event_cache(enum ip_conntrack_events event, 
> +					    const struct sk_buff *skb) {}
> +static inline void ip_conntrack_event(enum ip_conntrack_events event, 
> +				      struct ip_conntrack *ct) {}
> +static inline void ip_conntrack_deliver_cached_events_for(
> +						struct ip_conntrack *ct) {}
> +static inline void ip_conntrack_event_cache_init(const struct sk_buff *skb) {}
> +static inline void 
> +ip_conntrack_expect_event(enum ip_conntrack_expect_events event, 
> +			  struct ip_conntrack_expect *exp) {}
> +#endif /* CONFIG_IP_NF_CONNTRACK_EVENTS */
> +
>  #ifdef CONFIG_IP_NF_NAT_NEEDED
>  static inline int ip_nat_initialized(struct ip_conntrack *conntrack,
>  				     enum ip_nat_manip_type manip)
> diff --git a/include/linux/netfilter_ipv4/ip_conntrack_core.h b/include/linux/netfilter_ipv4/ip_conntrack_core.h
> --- a/include/linux/netfilter_ipv4/ip_conntrack_core.h
> +++ b/include/linux/netfilter_ipv4/ip_conntrack_core.h
> @@ -38,12 +38,21 @@ extern int __ip_conntrack_confirm(struct
>  /* Confirm a connection: returns NF_DROP if packet must be dropped. */
>  static inline int ip_conntrack_confirm(struct sk_buff **pskb)
>  {
> -	if ((*pskb)->nfct
> -	    && !is_confirmed((struct ip_conntrack *)(*pskb)->nfct))
> -		return __ip_conntrack_confirm(pskb);
> -	return NF_ACCEPT;
> +	struct ip_conntrack *ct = (struct ip_conntrack *)(*pskb)->nfct;
> +	int ret = NF_ACCEPT;
> +
> +	if (ct && !is_confirmed(ct))
> +		ret = __ip_conntrack_confirm(pskb);
> +	ip_conntrack_deliver_cached_events_for(ct);
> +
> +	return ret;
>  }
>  
> +#ifdef CONFIG_IP_NF_CONNTRACK_EVENTS
> +struct ip_conntrack_ecache;
> +extern void __ip_ct_deliver_cached_events(struct ip_conntrack_ecache *ec);
> +#endif
> +
>  extern struct list_head *ip_conntrack_hash;
>  extern struct list_head ip_conntrack_expect_list;
>  extern rwlock_t ip_conntrack_lock;
> diff --git a/net/ipv4/netfilter/Kconfig b/net/ipv4/netfilter/Kconfig
> --- a/net/ipv4/netfilter/Kconfig
> +++ b/net/ipv4/netfilter/Kconfig
> @@ -692,5 +692,15 @@ config IP_NF_ARP_MANGLE
>  	  Allows altering the ARP packet payload: source and destination
>  	  hardware and network addresses.
>  
> +config IP_NF_CONNTRACK_EVENTS
> +	bool "Connection tracking events"
> +	depends on IP_NF_CONNTRACK
> +	help
> +	  If this option is enabled, the connection tracking code will
> +	  provide a notifier chain that can be used by other kernel code
> +	  to get notified about changes in the connection tracking state.
> +	  
> +	  IF unsure, say `N'.
> +
>  endmenu
>  
> diff --git a/net/ipv4/netfilter/ip_conntrack_core.c b/net/ipv4/netfilter/ip_conntrack_core.c
> --- a/net/ipv4/netfilter/ip_conntrack_core.c
> +++ b/net/ipv4/netfilter/ip_conntrack_core.c
> @@ -37,6 +37,7 @@
>  #include <linux/err.h>
>  #include <linux/percpu.h>
>  #include <linux/moduleparam.h>
> +#include <linux/notifier.h>
>  
>  /* ip_conntrack_lock protects the main hash table, protocol/helper/expected
>     registrations, conntrack timers*/
> @@ -76,6 +77,81 @@ unsigned int ip_ct_log_invalid;
>  static LIST_HEAD(unconfirmed);
>  static int ip_conntrack_vmalloc;
>  
> +#ifdef CONFIG_IP_NF_CONNTRACK_EVENTS
> +struct notifier_block *ip_conntrack_chain;
> +struct notifier_block *ip_conntrack_expect_chain;
> +
> +DEFINE_PER_CPU(struct ip_conntrack_ecache, ip_conntrack_ecache);
> +
> +static inline void __deliver_cached_events(struct ip_conntrack_ecache *ecache)
> +{
> +	if (is_confirmed(ecache->ct) && !is_dying(ecache->ct) && ecache->events)
> +		notifier_call_chain(&ip_conntrack_chain, ecache->events,
> +				    ecache->ct);
> +	ecache->events = 0;
> +}
> +
> +void __ip_ct_deliver_cached_events(struct ip_conntrack_ecache *ecache)
> +{
> +	__deliver_cached_events(ecache);
> +}
> +
> +/* Deliver all cached events for a particular conntrack. This is called
> + * by code prior to async packet handling or freeing the skb */
> +void 
> +ip_conntrack_deliver_cached_events_for(const struct ip_conntrack *ct)
> +{
> +	struct ip_conntrack_ecache *ecache = 
> +					&__get_cpu_var(ip_conntrack_ecache);
> +
> +	if (!ct)
> +		return;
> +
> +	if (ecache->ct == ct) {
> +		DEBUGP("ecache: delivering event for %p\n", ct);
> +		__deliver_cached_events(ecache);
> +	} else {
> +		if (net_ratelimit())
> +			printk(KERN_WARNING "ecache: want to deliver for %p, "
> +				"but cache has %p\n", ct, ecache->ct);
> +	}
> +
> +	/* signalize that events have already been delivered */
> +	ecache->ct = NULL;
> +}
> +
> +/* Deliver cached events for old pending events, if current conntrack != old */
> +void ip_conntrack_event_cache_init(const struct sk_buff *skb)
> +{
> +	struct ip_conntrack *ct = (struct ip_conntrack *) skb->nfct;
> +	struct ip_conntrack_ecache *ecache = 
> +					&__get_cpu_var(ip_conntrack_ecache);
> +
> +	/* take care of delivering potentially old events */
> +	if (ecache->ct != ct) {
> +		enum ip_conntrack_info ctinfo;
> +		/* we have to check, since at startup the cache is NULL */
> +		if (likely(ecache->ct)) {
> +			DEBUGP("ecache: entered for different conntrack: "
> +			       "ecache->ct=%p, skb->nfct=%p. delivering "
> +			       "events\n", ecache->ct, ct);
> +			__deliver_cached_events(ecache);
> +			ip_conntrack_put(ecache->ct);
> +		} else {
> +			DEBUGP("ecache: entered for conntrack %p, "
> +				"cache was clean before\n", ct);
> +		}
> +
> +		/* initialize for this conntrack/packet */
> +		ecache->ct = ip_conntrack_get(skb, &ctinfo);
> +		/* ecache->events cleared by __deliver_cached_devents() */
> +	} else {
> +		DEBUGP("ecache: re-entered for conntrack %p.\n", ct);
> +	}
> +}
> +
> +#endif /* CONFIG_IP_NF_CONNTRACK_EVENTS */
> +
>  DEFINE_PER_CPU(struct ip_conntrack_stat, ip_conntrack_stat);
>  
>  void 
> @@ -230,6 +306,8 @@ destroy_conntrack(struct nf_conntrack *n
>  	IP_NF_ASSERT(atomic_read(&nfct->use) == 0);
>  	IP_NF_ASSERT(!timer_pending(&ct->timeout));
>  
> +	set_bit(IPS_DYING_BIT, &ct->status);
> +
>  	/* To make sure we don't get any weird locking issues here:
>  	 * destroy_conntrack() MUST NOT be called with a write lock
>  	 * to ip_conntrack_lock!!! -HW */
> @@ -268,6 +346,7 @@ static void death_by_timeout(unsigned lo
>  {
>  	struct ip_conntrack *ct = (void *)ul_conntrack;
>  
> +	ip_conntrack_event(IPCT_DESTROY, ct);
>  	write_lock_bh(&ip_conntrack_lock);
>  	/* Inside lock so preempt is disabled on module removal path.
>  	 * Otherwise we can get spurious warnings. */
> @@ -381,6 +460,16 @@ __ip_conntrack_confirm(struct sk_buff **
>  		set_bit(IPS_CONFIRMED_BIT, &ct->status);
>  		CONNTRACK_STAT_INC(insert);
>  		write_unlock_bh(&ip_conntrack_lock);
> +		if (ct->helper)
> +			ip_conntrack_event_cache(IPCT_HELPER, *pskb);
> +#ifdef CONFIG_IP_NF_NAT_NEEDED
> +		if (test_bit(IPS_SRC_NAT_DONE_BIT, &ct->status) ||
> +		    test_bit(IPS_DST_NAT_DONE_BIT, &ct->status))
> +			ip_conntrack_event_cache(IPCT_NATINFO, *pskb);
> +#endif
> +		ip_conntrack_event_cache(master_ct(ct) ?
> +					 IPCT_RELATED : IPCT_NEW, *pskb);
> +
>  		return NF_ACCEPT;
>  	}
>  
> @@ -668,6 +757,8 @@ unsigned int ip_conntrack_in(unsigned in
>  
>  	IP_NF_ASSERT((*pskb)->nfct);
>  
> +	ip_conntrack_event_cache_init(*pskb);
> +
>  	ret = proto->packet(ct, *pskb, ctinfo);
>  	if (ret < 0) {
>  		/* Invalid: inverse of the return code tells
> @@ -678,8 +769,8 @@ unsigned int ip_conntrack_in(unsigned in
>  		return -ret;
>  	}
>  
> -	if (set_reply)
> -		set_bit(IPS_SEEN_REPLY_BIT, &ct->status);
> +	if (set_reply && !test_and_set_bit(IPS_SEEN_REPLY_BIT, &ct->status))
> +		ip_conntrack_event_cache(IPCT_STATUS, *pskb);
>  
>  	return ret;
>  }
> @@ -823,6 +914,7 @@ int ip_conntrack_expect_related(struct i
>  		evict_oldest_expect(expect->master);
>  
>  	ip_conntrack_expect_insert(expect);
> +	ip_conntrack_expect_event(IPEXP_NEW, expect);
>  	ret = 0;
>  out:
>  	write_unlock_bh(&ip_conntrack_lock);
> @@ -860,8 +952,10 @@ int ip_conntrack_helper_register(struct 
>  static inline int unhelp(struct ip_conntrack_tuple_hash *i,
>  			 const struct ip_conntrack_helper *me)
>  {
> -	if (tuplehash_to_ctrack(i)->helper == me)
> +	if (tuplehash_to_ctrack(i)->helper == me) {
> + 		ip_conntrack_event(IPCT_HELPER, tuplehash_to_ctrack(i));
>  		tuplehash_to_ctrack(i)->helper = NULL;
> +	}
>  	return 0;
>  }
>  
> @@ -923,6 +1017,7 @@ void ip_ct_refresh_acct(struct ip_conntr
>  		if (del_timer(&ct->timeout)) {
>  			ct->timeout.expires = jiffies + extra_jiffies;
>  			add_timer(&ct->timeout);
> +			ip_conntrack_event_cache(IPCT_REFRESH, skb);
>  		}
>  		ct_add_counters(ct, ctinfo, skb);
>  		write_unlock_bh(&ip_conntrack_lock);
> diff --git a/net/ipv4/netfilter/ip_conntrack_ftp.c b/net/ipv4/netfilter/ip_conntrack_ftp.c
> --- a/net/ipv4/netfilter/ip_conntrack_ftp.c
> +++ b/net/ipv4/netfilter/ip_conntrack_ftp.c
> @@ -262,7 +262,8 @@ static int find_nl_seq(u32 seq, const st
>  }
>  
>  /* We don't update if it's older than what we have. */
> -static void update_nl_seq(u32 nl_seq, struct ip_ct_ftp_master *info, int dir)
> +static void update_nl_seq(u32 nl_seq, struct ip_ct_ftp_master *info, int dir,
> +			  struct sk_buff *skb)
>  {
>  	unsigned int i, oldest = NUM_SEQ_TO_REMEMBER;
>  
> @@ -276,10 +277,13 @@ static void update_nl_seq(u32 nl_seq, st
>  			oldest = i;
>  	}
>  
> -	if (info->seq_aft_nl_num[dir] < NUM_SEQ_TO_REMEMBER)
> +	if (info->seq_aft_nl_num[dir] < NUM_SEQ_TO_REMEMBER) {
>  		info->seq_aft_nl[dir][info->seq_aft_nl_num[dir]++] = nl_seq;
> -	else if (oldest != NUM_SEQ_TO_REMEMBER)
> +		ip_conntrack_event_cache(IPCT_HELPINFO_VOLATILE, skb);
> +	} else if (oldest != NUM_SEQ_TO_REMEMBER) {
>  		info->seq_aft_nl[dir][oldest] = nl_seq;
> +		ip_conntrack_event_cache(IPCT_HELPINFO_VOLATILE, skb);
> +	}
>  }
>  
>  static int help(struct sk_buff **pskb,
> @@ -439,7 +443,7 @@ out_update_nl:
>  	/* Now if this ends in \n, update ftp info.  Seq may have been
>  	 * adjusted by NAT code. */
>  	if (ends_in_nl)
> -		update_nl_seq(seq, ct_ftp_info,dir);
> +		update_nl_seq(seq, ct_ftp_info,dir, *pskb);
>   out:
>  	spin_unlock_bh(&ip_ftp_lock);
>  	return ret;
> diff --git a/net/ipv4/netfilter/ip_conntrack_proto_icmp.c b/net/ipv4/netfilter/ip_conntrack_proto_icmp.c
> --- a/net/ipv4/netfilter/ip_conntrack_proto_icmp.c
> +++ b/net/ipv4/netfilter/ip_conntrack_proto_icmp.c
> @@ -102,6 +102,7 @@ static int icmp_packet(struct ip_conntra
>  			ct->timeout.function((unsigned long)ct);
>  	} else {
>  		atomic_inc(&ct->proto.icmp.count);
> +		ip_conntrack_event_cache(IPCT_PROTOINFO_VOLATILE, skb);
>  		ip_ct_refresh_acct(ct, ctinfo, skb, ip_ct_icmp_timeout);
>  	}
>  
> diff --git a/net/ipv4/netfilter/ip_conntrack_proto_sctp.c b/net/ipv4/netfilter/ip_conntrack_proto_sctp.c
> --- a/net/ipv4/netfilter/ip_conntrack_proto_sctp.c
> +++ b/net/ipv4/netfilter/ip_conntrack_proto_sctp.c
> @@ -404,6 +404,8 @@ static int sctp_packet(struct ip_conntra
>  		}
>  
>  		conntrack->proto.sctp.state = newconntrack;
> +		if (oldsctpstate != newconntrack)
> +			ip_conntrack_event_cache(IPCT_PROTOINFO, skb);
>  		write_unlock_bh(&sctp_lock);
>  	}
>  
> diff --git a/net/ipv4/netfilter/ip_conntrack_proto_tcp.c b/net/ipv4/netfilter/ip_conntrack_proto_tcp.c
> --- a/net/ipv4/netfilter/ip_conntrack_proto_tcp.c
> +++ b/net/ipv4/netfilter/ip_conntrack_proto_tcp.c
> @@ -973,6 +973,10 @@ static int tcp_packet(struct ip_conntrac
>  		  ? ip_ct_tcp_timeout_max_retrans : *tcp_timeouts[new_state];
>  	write_unlock_bh(&tcp_lock);
>  
> +	ip_conntrack_event_cache(IPCT_PROTOINFO_VOLATILE, skb);
> +	if (new_state != old_state)
> +		ip_conntrack_event_cache(IPCT_PROTOINFO, skb);
> +
>  	if (!test_bit(IPS_SEEN_REPLY_BIT, &conntrack->status)) {
>  		/* If only reply is a RST, we can consider ourselves not to
>  		   have an established connection: this is a fairly common
> diff --git a/net/ipv4/netfilter/ip_conntrack_proto_udp.c b/net/ipv4/netfilter/ip_conntrack_proto_udp.c
> --- a/net/ipv4/netfilter/ip_conntrack_proto_udp.c
> +++ b/net/ipv4/netfilter/ip_conntrack_proto_udp.c
> @@ -73,7 +73,8 @@ static int udp_packet(struct ip_conntrac
>  		ip_ct_refresh_acct(conntrack, ctinfo, skb, 
>  				   ip_ct_udp_timeout_stream);
>  		/* Also, more likely to be important, and not a probe */
> -		set_bit(IPS_ASSURED_BIT, &conntrack->status);
> +		if (!test_and_set_bit(IPS_ASSURED_BIT, &conntrack->status))
> +			ip_conntrack_event_cache(IPCT_STATUS, skb);
>  	} else
>  		ip_ct_refresh_acct(conntrack, ctinfo, skb, ip_ct_udp_timeout);
>  
> diff --git a/net/ipv4/netfilter/ip_conntrack_standalone.c b/net/ipv4/netfilter/ip_conntrack_standalone.c
> --- a/net/ipv4/netfilter/ip_conntrack_standalone.c
> +++ b/net/ipv4/netfilter/ip_conntrack_standalone.c
> @@ -402,6 +402,7 @@ static unsigned int ip_confirm(unsigned 
>  			       const struct net_device *out,
>  			       int (*okfn)(struct sk_buff *))
>  {
> +	ip_conntrack_event_cache_init(*pskb);
>  	/* We've seen it coming out the other side: confirm it */
>  	return ip_conntrack_confirm(pskb);
>  }
> @@ -419,6 +420,7 @@ static unsigned int ip_conntrack_help(un
>  	ct = ip_conntrack_get(*pskb, &ctinfo);
>  	if (ct && ct->helper) {
>  		unsigned int ret;
> +		ip_conntrack_event_cache_init(*pskb);
>  		ret = ct->helper->help(pskb, ct, ctinfo);
>  		if (ret != NF_ACCEPT)
>  			return ret;
> @@ -886,9 +888,27 @@ static int init_or_cleanup(int init)
>  	}
>  #endif
>  
> +#ifdef CONFIG_IP_NF_CONNTRACK_EVENTS
> +	{
> +		/* we need to deliver all cached events in order to drop
> +		 * the reference counts */
> +		int cpu;
> +		for_each_cpu(cpu) {
> +			struct ip_conntrack_ecache *ecache = 
> +					&per_cpu(ip_conntrack_ecache, cpu);
> +			if (ecache->ct) {
> +				__ip_ct_deliver_cached_events(ecache);
> +				ip_conntrack_put(ecache->ct);
> +				ecache->ct = NULL;
> +			}
> +		}
> +	}
> +#endif
> +
>  	return ret;
>  
>   cleanup:
> +	synchronize_net();
>  #ifdef CONFIG_SYSCTL
>   	unregister_sysctl_table(ip_ct_sysctl_header);
>   cleanup_localinops:
> @@ -971,6 +991,13 @@ void need_ip_conntrack(void)
>  {
>  }
>  
> +#ifdef CONFIG_IP_NF_CONNTRACK_EVENTS
> +EXPORT_SYMBOL_GPL(ip_conntrack_chain);
> +EXPORT_SYMBOL_GPL(ip_conntrack_expect_chain);
> +EXPORT_SYMBOL_GPL(ip_conntrack_register_notifier);
> +EXPORT_SYMBOL_GPL(ip_conntrack_unregister_notifier);
> +EXPORT_PER_CPU_SYMBOL_GPL(ip_conntrack_ecache);
> +#endif
>  EXPORT_SYMBOL(ip_conntrack_protocol_register);
>  EXPORT_SYMBOL(ip_conntrack_protocol_unregister);
>  EXPORT_SYMBOL(ip_ct_get_tuple);
