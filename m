From: Florian Westphal <fw@strlen.de>
Subject: Re: bug report: use after free bug leading to kernel panic
Date: Fri, 31 Oct 2014 17:50:42 +0100
Message-ID: <20141031165042.GN10069@breakpoint.cc>
References: <CAHZ_AjsbkkXNMG8oZfOhr6WbUmV=4eK0j23ijbP=cNkfVdoAjQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, minipli@googlemail.com
To: eric gisse <jowr.pi@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:41372 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751127AbaJaQuo (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 31 Oct 2014 12:50:44 -0400
Content-Disposition: inline
In-Reply-To: <CAHZ_AjsbkkXNMG8oZfOhr6WbUmV=4eK0j23ijbP=cNkfVdoAjQ@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

eric gisse <jowr.pi@gmail.com> wrote:
> Background:
> 
> This was discovered on a server running a tor exit node (crazy high
> packet flow) with a firewall that uses a few connection tracking rules
> in the INPUT chain:
> 
> # iptables-save | grep conn
> -A INPUT -m comment --comment "001-v4 drop invalid traffic" -m
> conntrack --ctstate INVALID -j DROP
> -A INPUT -m comment --comment "990-v4 accept existing connections" -m
> conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
> 
> The kernel was not stock, but rather was modified with grsecurity. I
> worked with the grsecurity folks first on this issue (
> https://forums.grsecurity.net/viewtopic.php?f=1&t=4071 ) to isolate
> and explain what's going on. They were very helpful.

Thanks for reporting.

> because netconsole is ... inconsistent with when choosing to work. As
> an aside, what is the ideal way to get kernel oops output anyway?

booting into a crash-kernel has worked for me in the past to salvage
original trace from memory.

> Note: please Ignore the xt_* modules as they were not in use at the
> time, and were not present for either the 3.16.5 panics or the 3.17.1
> + sanitize test case patch.

Just to be clear, the 3.16.5 panic is also with pax memory
sanitizing...?

> The spot of code that's causing grief:
> 
> # addr2line -e vmlinux -fip ffffffff814b58ce
> nf_ct_tuplehash_to_ctrack at
> /usr/src/linux/include/net/netfilter/nf_conntrack.h:122
>  (inlined by) nf_ct_key_equal at
> /usr/src/linux/net/netfilter/nf_conntrack_core.c:393
>  (inlined by) ____nf_conntrack_find at
> /usr/src/linux/net/netfilter/nf_conntrack_core.c:422
>  (inlined by) __nf_conntrack_find_get at
> /usr/src/linux/net/netfilter/nf_conntrack_core.c:453

Thanks.
So this happens when we walk the conntrack hash lists to find
a matching entry.

> diff --git a/mm/slub.c b/mm/slub.c
> index 3e8afcc07a76..08a7cbcf2274 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -2643,6 +2643,12 @@ static __always_inline void slab_free(struct kmem_cache *s,
>  
>  	slab_free_hook(s, x);
>  
> +	if (pax_sanitize_slab && !(s->flags & SLAB_NO_SANITIZE)) {
> +		memset(x, PAX_MEMORY_SANITIZE_VALUE, s->object_size);
> +		if (s->ctor)
> +			s->ctor(x);
> +	}
> +

I am no SLUB expert, but this looks wrong.
slab_free() is called directly via kmem_cache_free().

conntrack objects are alloc'd/free'd from a SLAB_DESTROY_BY_RCU cache.

It is therefore legal to access a conntrack object from another
CPU even after kmem_cache_free() was invoked on another cpu, provided all
readers that do so hold rcu_read_lock, and verify that object has not been
freed yet by issuing appropriate atomic_inc_not_zero calls.

Therefore, object poisoning will only be safe from rcu callback, after
accesses are known to be illegal/invalid.

(not saying that conntrack is bug free..., we had races there in the
 past).

>From a short glance at SLUB it seems poisoning objects for SLAB_DESTROY_BY_RCU
caches is safe in __free_slab(), but not earlier.

If you use different allocator, please tell us which one (check kernel
config, slub is default).

If its reproduceable with poisoning done after the RCU grace periods
have elapsed (i.e., where its not legal anymore to access the memory),
please let us know and we can have another look at it.

Thanks.
