From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf-next 1/2] netfilter: xtables: use percpu rule counters
Date: Mon, 8 Jun 2015 21:54:22 +0200
Message-ID: <20150608195422.GE22198@breakpoint.cc>
References: <1433784432-16451-1-git-send-email-fw@strlen.de>
 <1433789954.29864.65.camel@edumazet-glaptop2.roam.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Eric Dumazet <eric.dumazet@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:42633 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753513AbbFHTyX (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 8 Jun 2015 15:54:23 -0400
Content-Disposition: inline
In-Reply-To: <1433789954.29864.65.camel@edumazet-glaptop2.roam.corp.google.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eric Dumazet <eric.dumazet@gmail.com> wrote:
> > The only reason left as to why we need percpu duplication are the rule
> > counters embedded into ipt_entry et al -- since each cpu has its own copy
> > of the rules, all counters can be lockless.
> > 
> > The downside is that the more cpus are supported, the more memory is
> > required.  Rules are not just duplicated per online cpu but for each
> > possible cpu, i.e. if maxcpu is 144, then rule is duplicated 144 times,
> > not for the e.g. 64 cores present.
> > 
> > To save some memory and also improve utilization of shared caches it
> > would be preferable to only store the rule blob once.
> > 
> > So we first need to separate counters and the rule blob.
> > 
> > Instead of using entry->counters, allocate this percpu and store the
> > percpu address in entry->counters.pcnt on CONFIG_SMP.
> > 
> > This change makes no sense as-is; it is merely an intermediate step to
> > remove the percpu duplication of the rule set in a followup patch.
> > 
> > Suggested-by: Eric Dumazet <edumazet@google.com>
> > Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>
> > Reported-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
> > Signed-off-by: Florian Westphal <fw@strlen.de>
> > ---
[..]

> > +++ b/include/linux/netfilter/x_tables.h
> > +/* On SMP, ip(6)t_entry->counters.pcnt holds address of the
> > + * real (percpu) counter.  On !SMP, its just the packet count,
> > + * so nothing needs to be done there.
> > + *
> > + * xt_percpu_counter_alloc returns the address of the percpu
> > + * counter, or 0 on !SMP.
> > + *
> > + * Hence caller must use IS_ERR_VALUE to check for error, this
> > + * allows us to contain CONFIG_SMP kludgery.
> > + */
> > +static inline u64 xt_percpu_counter_alloc(void)
> > +{
> > +#ifdef CONFIG_SMP
> > +	void *res = alloc_percpu(struct xt_counters);
> > +
> > +	if (res == NULL)
> > +		return (u64) -ENOMEM;
> > +
> > +	return (__force u64) res;
> > +#else
> > +	return 0;
> > +#endif
> > +}
> 
> 
> The u64 stuff looks strange on a 32bit kernel ;)

Hmmm, not sure how to avoid that.
The packet and byte counters are always u64, and I don't
think it will help to provide different helpers for 32 vs. 64bit system.

> > +static inline void xt_percpu_counter_free(u64 pcnt)
> > +{
> > +#ifdef CONFIG_SMP
> > +	free_percpu((__force void *) pcnt);
> > +#endif
> > +}
> > +
> > +static inline struct xt_counters *
> > +xt_get_this_cpu_counter(struct xt_counters *cnt)
> > +{
> > +#ifdef CONFIG_SMP
> > +	return this_cpu_ptr((void *) cnt->pcnt);
> > +#else
> > +	return cnt;
> > +#endif
> > +}
> > +
> > +static inline struct xt_counters *
> > +xt_get_per_cpu_counter(struct xt_counters *cnt, unsigned int cpu)
> > +{
> > +#ifdef CONFIG_SMP
> > +	return per_cpu_ptr((void *) cnt->pcnt, cpu);
> > +#else
> > +	return cnt;
> > +#endif
> > +}
> > +
> 
> So I understand struct xt_counters is exported to user space
> (include/uapi/linux/netfilter/x_tables.h) 
>
> But maybe you could use in the kernel 
> 
> union xt_kcounters {
> 	struct xt_counters __percpu *pcpu;
> 	struct xt_counters counters;
> };
> 
> This way, you could avoid a lot of casts ?

I tried that but I did not find out how to use this to improve
readability :-|

static inline bool xt_percpu_counter_alloc(union xt_kcounters *cnt)
{
#ifdef CONFIG_SMP
	cnt->pcpu = alloc_percpu(struct xt_counters);

	return cnt->pcpu != NULL;
#else
	return true;
#endif
}

... looks ok BUT it means call site looks like

if (xt_percpu_counter_alloc((union xt_kcounters *) &e->counters))
	/* err */

which I find worse :-/

I could add anon union in ipt_entry to avoid casts but I remember
there were build failure problems with anon unions & older gcc releases.

Is there any idea you have wrt. not leaking percpu yes|no details
to ip(6)_tables.c while still avoiding the casts outside the static
inline helpers above?

> Please run sparse to make sure you did not miss an annotation.
> 
> include/linux/netfilter/x_tables.h:370:21: warning: incorrect type in initializer (different address spaces)
> include/linux/netfilter/x_tables.h:370:21:    expected void *res
> include/linux/netfilter/x_tables.h:370:21:    got struct xt_counters [noderef] <asn:3>*<noident>

Ugh.  I sprinkled a few more __percpu annotations on x_tables.h and
these are gone now.

Thanks Eric.
