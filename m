From: eric gisse <jowr.pi@gmail.com>
Subject: Re: bug report: use after free bug leading to kernel panic
Date: Fri, 31 Oct 2014 17:30:46 +0000
Message-ID: <CAHZ_AjvkAgcgkwjFzSfzMhkAOHBNPRiA2ywTyv=ORBO8RRZAaw@mail.gmail.com>
References: <CAHZ_AjsbkkXNMG8oZfOhr6WbUmV=4eK0j23ijbP=cNkfVdoAjQ@mail.gmail.com>
	<20141031165042.GN10069@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: netfilter-devel@vger.kernel.org,
	Mathias Krause <minipli@googlemail.com>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-la0-f54.google.com ([209.85.215.54]:61050 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753797AbaJaRas (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 31 Oct 2014 13:30:48 -0400
Received: by mail-la0-f54.google.com with SMTP id s18so1218940lam.41
        for <netfilter-devel@vger.kernel.org>; Fri, 31 Oct 2014 10:30:46 -0700 (PDT)
In-Reply-To: <20141031165042.GN10069@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Oct 31, 2014 at 4:50 PM, Florian Westphal <fw@strlen.de> wrote:
> eric gisse <jowr.pi@gmail.com> wrote:
>> Background:
>>
>> This was discovered on a server running a tor exit node (crazy high
>> packet flow) with a firewall that uses a few connection tracking rules
>> in the INPUT chain:
>>
>> # iptables-save | grep conn
>> -A INPUT -m comment --comment "001-v4 drop invalid traffic" -m
>> conntrack --ctstate INVALID -j DROP
>> -A INPUT -m comment --comment "990-v4 accept existing connections" -m
>> conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
>>
>> The kernel was not stock, but rather was modified with grsecurity. I
>> worked with the grsecurity folks first on this issue (
>> https://forums.grsecurity.net/viewtopic.php?f=1&t=4071 ) to isolate
>> and explain what's going on. They were very helpful.
>
> Thanks for reporting.
>
>> because netconsole is ... inconsistent with when choosing to work. As
>> an aside, what is the ideal way to get kernel oops output anyway?
>
> booting into a crash-kernel has worked for me in the past to salvage
> original trace from memory.

I'm using Gentoo which doesn't have the super nice crash kernel /
abrtd stuff setup.

That's the one thing I really like about RHEL, though I wouldn't be
able to use grsecurity (or anything else custom) in kernel space with
those tools for that matter...

>
>> Note: please Ignore the xt_* modules as they were not in use at the
>> time, and were not present for either the 3.16.5 panics or the 3.17.1
>> + sanitize test case patch.
>
> Just to be clear, the 3.16.5 panic is also with pax memory
> sanitizing...?

Correct.

Since it ran along the same syscall path as the 3.17.1 panics, I am
making the assumption it is the same bug.

I don't have the 3.16.5 kernel built with the debugging flags needed
though, so I can't verify it 100% after the fact but I'm reasonably
confident at this point with the amount of "reproducability" this
issue has had.

>
>> The spot of code that's causing grief:
>>
>> # addr2line -e vmlinux -fip ffffffff814b58ce
>> nf_ct_tuplehash_to_ctrack at
>> /usr/src/linux/include/net/netfilter/nf_conntrack.h:122
>>  (inlined by) nf_ct_key_equal at
>> /usr/src/linux/net/netfilter/nf_conntrack_core.c:393
>>  (inlined by) ____nf_conntrack_find at
>> /usr/src/linux/net/netfilter/nf_conntrack_core.c:422
>>  (inlined by) __nf_conntrack_find_get at
>> /usr/src/linux/net/netfilter/nf_conntrack_core.c:453
>
> Thanks.
> So this happens when we walk the conntrack hash lists to find
> a matching entry.

That is as far as I was able to understand.

My connection tracking table gets *big*. This is what it looks like at
this instant in time on the machine in question:

# sysctl -a | grep conntrack_count
net.ipv4.netfilter.ip_conntrack_count = 46205
net.netfilter.nf_conntrack_count = 46203



>
>> diff --git a/mm/slub.c b/mm/slub.c
>> index 3e8afcc07a76..08a7cbcf2274 100644
>> --- a/mm/slub.c
>> +++ b/mm/slub.c
>> @@ -2643,6 +2643,12 @@ static __always_inline void slab_free(struct kmem_cache *s,
>>
>>       slab_free_hook(s, x);
>>
>> +     if (pax_sanitize_slab && !(s->flags & SLAB_NO_SANITIZE)) {
>> +             memset(x, PAX_MEMORY_SANITIZE_VALUE, s->object_size);
>> +             if (s->ctor)
>> +                     s->ctor(x);
>> +     }
>> +
>
> I am no SLUB expert, but this looks wrong.
> slab_free() is called directly via kmem_cache_free().

I can't help with that one. My competence does not extend to kernel
memory managment / allocation issues :)

>
> conntrack objects are alloc'd/free'd from a SLAB_DESTROY_BY_RCU cache.
>
> It is therefore legal to access a conntrack object from another
> CPU even after kmem_cache_free() was invoked on another cpu, provided all
> readers that do so hold rcu_read_lock, and verify that object has not been
> freed yet by issuing appropriate atomic_inc_not_zero calls.
>
> Therefore, object poisoning will only be safe from rcu callback, after
> accesses are known to be illegal/invalid.

Can you expand on that? The term "object poisoning" to me means an
object (you are talking about the conntract tuple, right?) with
problematic values is put into memory, but the way you phrase it seems
more like the hash table itself is being manipulated improperly.

I'm still trying to work out what the actual ISSUE is. My
understanding is this, thus far:

It seems like an object in the connection track hash table is being
improperly marked as free, which then is sanitized, and is then later
being accessed by the netfilter codepath that loops through the table.

>
> (not saying that conntrack is bug free..., we had races there in the
>  past).
>
> From a short glance at SLUB it seems poisoning objects for SLAB_DESTROY_BY_RCU
> caches is safe in __free_slab(), but not earlier.
>
> If you use different allocator, please tell us which one (check kernel
> config, slub is default).

SLAB allocator, though I do not remember making the choice.

>From the kernel config that's causing issues:

# egrep 'SLAB|SLUB' .config
CONFIG_SLAB=y
# CONFIG_SLUB is not set
CONFIG_SLABINFO=y
# CONFIG_DEBUG_SLAB is not set
CONFIG_PAX_USERCOPY_SLABS=y

For reference, the current kernel, with the PaX sanitization feature
disabled, doesn't exhibit the issue. Not that I am surprised.

I don't, as a rule, mess with kernel memory/process management
internals without a good reason because I don't have enough
information to make a proper choice. Usually the defaults are "good
enough". I can only think of a handful of instances where I have had
reason to do so, and even then the results were inconsistent at best.

>
> If its reproduceable with poisoning done after the RCU grace periods
> have elapsed (i.e., where its not legal anymore to access the memory),
> please let us know and we can have another look at it.
>
> Thanks.

Reproducability is an issue since I don't know what's triggering it in
the first place. Just that it happens after a variable length of time
along the same code path, subject to differences between the two
kernel versions I've seen this issue with.

The machine itself is pushing 20-25 megabytes (~50k packets) per
second at any given time and has smacked the default conntrack hash
table maximums. So the netfilter system is under nontrivial stresses.

I'll happily work with you guys to isolate this as this is an
interesting problem and I'm bored, but I need a bit of help and
prompting to get this done properly.

I am a sysadmin of reasonable (in my own estimate) skill and developer
in puppet / perl, but kernel stuff beyond surface level debugging of
panics is way beyond my aegis.

Even after your explanation I am not yet sure I understand the issue,
and am definitely sure I don't understand how to debug this further.
