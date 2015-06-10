From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH v2 nf-next 1/2] netfilter: xtables: use percpu rule
 counters
Date: Wed, 10 Jun 2015 14:29:48 -0700
Message-ID: <1433971788.27504.21.camel@edumazet-glaptop2.roam.corp.google.com>
References: <1433935260-18156-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ie0-f193.google.com ([209.85.223.193]:36603 "EHLO
	mail-ie0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003AbbFJV3v (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Jun 2015 17:29:51 -0400
Received: by ierx19 with SMTP id x19so7206979ier.3
        for <netfilter-devel@vger.kernel.org>; Wed, 10 Jun 2015 14:29:50 -0700 (PDT)
In-Reply-To: <1433935260-18156-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, 2015-06-10 at 13:20 +0200, Florian Westphal wrote:
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
>  Changes since v1:
>   proper __percpu annotations to avoid sparse errors (Eric)
> 
>  include/linux/netfilter/x_tables.h | 51 ++++++++++++++++++++++++++++++++++++++
>  net/ipv4/netfilter/arp_tables.c    | 32 ++++++++++++++++++++----
>  net/ipv4/netfilter/ip_tables.c     | 31 ++++++++++++++++++++---
>  net/ipv6/netfilter/ip6_tables.c    | 31 +++++++++++++++++++----
>  4 files changed, 131 insertions(+), 14 deletions(-)
> 
> diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x_tables.h
> index 09f3820..c240d22 100644
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
> +	void __percpu *res = alloc_percpu(struct xt_counters);
> +
> +	if (res == NULL)
> +		return (u64) -ENOMEM;
> +
> +	return (__force u64) res;
> +#else
> +	return 0;
> +#endif


This is awesome.

Note that we might still have SMP builds used on non SMP hosts.

So maybe use something with less ifdefs like the following.

static inline u64 xt_percpu_counter_alloc(void)
{
	if (nr_cpu_ids > 1) {
		void __percpu *res = alloc_percpu(struct xt_counters);

		if (!res)
			return (u64) -ENOMEM;
		return (__force u64) res;
	}
	return 0;
}


On CONFIG_SMP=n builds, compiler will automatically remove all this, as
nr_cpu_ids is constant 1.



