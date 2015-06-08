From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH nf-next 1/2] netfilter: xtables: use percpu rule counters
Date: Mon, 08 Jun 2015 11:59:14 -0700
Message-ID: <1433789954.29864.65.camel@edumazet-glaptop2.roam.corp.google.com>
References: <1433784432-16451-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ig0-f181.google.com ([209.85.213.181]:33884 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752808AbbFHS7Q (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 8 Jun 2015 14:59:16 -0400
Received: by igbhj9 with SMTP id hj9so66688043igb.1
        for <netfilter-devel@vger.kernel.org>; Mon, 08 Jun 2015 11:59:16 -0700 (PDT)
In-Reply-To: <1433784432-16451-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, 2015-06-08 at 19:27 +0200, Florian Westphal wrote:
> The binary arp/ip/ip6tables ruleset is stored per cpu.
> 
> The only reason left as to why we need percpu duplication are the rule
> counters embedded into ipt_entry et al -- since each cpu has its own copy
> of the rules, all counters can be lockless.
> 
> The downside is that the more cpus are supported, the more memory is
> required.  Rules are not just duplicated per online cpu but for each
> possible cpu, i.e. if maxcpu is 144, then rule is duplicated 144 times,
> not for the e.g. 64 cores present.
> 
> To save some memory and also improve utilization of shared caches it
> would be preferable to only store the rule blob once.
> 
> So we first need to separate counters and the rule blob.
> 
> Instead of using entry->counters, allocate this percpu and store the
> percpu address in entry->counters.pcnt on CONFIG_SMP.
> 
> This change makes no sense as-is; it is merely an intermediate step to
> remove the percpu duplication of the rule set in a followup patch.
> 
> Suggested-by: Eric Dumazet <edumazet@google.com>
> Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>
> Reported-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  include/linux/netfilter/x_tables.h | 51 ++++++++++++++++++++++++++++++++++++++
>  net/ipv4/netfilter/arp_tables.c    | 32 ++++++++++++++++++++----
>  net/ipv4/netfilter/ip_tables.c     | 31 ++++++++++++++++++++---
>  net/ipv6/netfilter/ip6_tables.c    | 31 +++++++++++++++++++----
>  4 files changed, 131 insertions(+), 14 deletions(-)
> 
> diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x_tables.h
> index 09f3820..e438c43 100644
> --- a/include/linux/netfilter/x_tables.h
> +++ b/include/linux/netfilter/x_tables.h
> @@ -353,6 +353,57 @@ static inline unsigned long ifname_compare_aligned(const char *_a,
>  	return ret;
>  }
>  
> +
> +/* On SMP, ip(6)t_entry->counters.pcnt holds address of the
> + * real (percpu) counter.  On !SMP, its just the packet count,
> + * so nothing needs to be done there.
> + *
> + * xt_percpu_counter_alloc returns the address of the percpu
> + * counter, or 0 on !SMP.
> + *
> + * Hence caller must use IS_ERR_VALUE to check for error, this
> + * allows us to contain CONFIG_SMP kludgery.
> + */
> +static inline u64 xt_percpu_counter_alloc(void)
> +{
> +#ifdef CONFIG_SMP
> +	void *res = alloc_percpu(struct xt_counters);
> +
> +	if (res == NULL)
> +		return (u64) -ENOMEM;
> +
> +	return (__force u64) res;
> +#else
> +	return 0;
> +#endif
> +}


The u64 stuff looks strange on a 32bit kernel ;)

> +static inline void xt_percpu_counter_free(u64 pcnt)
> +{
> +#ifdef CONFIG_SMP
> +	free_percpu((__force void *) pcnt);
> +#endif
> +}
> +
> +static inline struct xt_counters *
> +xt_get_this_cpu_counter(struct xt_counters *cnt)
> +{
> +#ifdef CONFIG_SMP
> +	return this_cpu_ptr((void *) cnt->pcnt);
> +#else
> +	return cnt;
> +#endif
> +}
> +
> +static inline struct xt_counters *
> +xt_get_per_cpu_counter(struct xt_counters *cnt, unsigned int cpu)
> +{
> +#ifdef CONFIG_SMP
> +	return per_cpu_ptr((void *) cnt->pcnt, cpu);
> +#else
> +	return cnt;
> +#endif
> +}
> +

So I understand struct xt_counters is exported to user space
(include/uapi/linux/netfilter/x_tables.h) 


But maybe you could use in the kernel 

union xt_kcounters {
	struct xt_counters __percpu *pcpu;
	struct xt_counters counters;
};



This way, you could avoid a lot of casts ?

Please run sparse to make sure you did not miss an annotation.

include/linux/netfilter/x_tables.h:370:21: warning: incorrect type in initializer (different address spaces)
include/linux/netfilter/x_tables.h:370:21:    expected void *res
include/linux/netfilter/x_tables.h:370:21:    got struct xt_counters [noderef] <asn:3>*<noident>
include/linux/netfilter/x_tables.h:391:16: warning: incorrect type in initializer (different address spaces)
include/linux/netfilter/x_tables.h:391:16:    expected void const [noderef] <asn:3>*__vpp_verify
include/linux/netfilter/x_tables.h:391:16:    got void *<noident>
include/linux/netfilter/x_tables.h:383:22: warning: incorrect type in argument 1 (different address spaces)
include/linux/netfilter/x_tables.h:383:22:    expected void [noderef] <asn:3>*__pdata
include/linux/netfilter/x_tables.h:383:22:    got void *<noident>
include/linux/netfilter/x_tables.h:383:22: warning: incorrect type in argument 1 (different address spaces)
include/linux/netfilter/x_tables.h:383:22:    expected void [noderef] <asn:3>*__pdata
include/linux/netfilter/x_tables.h:383:22:    got void *<noident>
include/linux/netfilter/x_tables.h:401:16: warning: incorrect type in initializer (different address spaces)
include/linux/netfilter/x_tables.h:401:16:    expected void const [noderef] <asn:3>*__vpp_verify
include/linux/netfilter/x_tables.h:401:16:    got void *<noident>

Otherwise, patch looks absolutely great, thanks Florian !


