From: Mathias Krause <minipli@googlemail.com>
Subject: Re: bug report: use after free bug leading to kernel panic
Date: Sat, 1 Nov 2014 11:56:28 +0100
Message-ID: <CA+rthh-3KAJwYZEnoZ9r0eGYO0ycPKveu5ypSARCjmVi0k3w6A@mail.gmail.com>
References: <CAHZ_AjsbkkXNMG8oZfOhr6WbUmV=4eK0j23ijbP=cNkfVdoAjQ@mail.gmail.com>
	<20141031165042.GN10069@breakpoint.cc>
	<CAHZ_AjvkAgcgkwjFzSfzMhkAOHBNPRiA2ywTyv=ORBO8RRZAaw@mail.gmail.com>
	<20141031220055.GO10069@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: eric gisse <jowr.pi@gmail.com>, netfilter-devel@vger.kernel.org,
	PaX Team <pageexec@freemail.hu>,
	Brad Spengler <spender@grsecurity.net>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lb0-f172.google.com ([209.85.217.172]:49969 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751906AbaKAK43 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 1 Nov 2014 06:56:29 -0400
Received: by mail-lb0-f172.google.com with SMTP id w7so74192lbi.17
        for <netfilter-devel@vger.kernel.org>; Sat, 01 Nov 2014 03:56:28 -0700 (PDT)
In-Reply-To: <20141031220055.GO10069@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 31 October 2014 23:00, Florian Westphal <fw@strlen.de> wrote:
> eric gisse <jowr.pi@gmail.com> wrote:
>> On Fri, Oct 31, 2014 at 4:50 PM, Florian Westphal <fw@strlen.de> wrote:
>> >> +     if (pax_sanitize_slab && !(s->flags & SLAB_NO_SANITIZE)) {
>> >> +             memset(x, PAX_MEMORY_SANITIZE_VALUE, s->object_size);
>> >> +             if (s->ctor)
>> >> +                     s->ctor(x);
>> >> +     }
>> >> +
>> >
>> > I am no SLUB expert, but this looks wrong.
>> > slab_free() is called directly via kmem_cache_free().
>>
>> I can't help with that one. My competence does not extend to kernel
>> memory managment / allocation issues :)
>
> Seems Mathias Krause will work on improving Pax poisoning to treat
> SLAB_DESTROY_BY_RCU specially.

Well, the fix is as easy as destructive. PaX sanitize has to exclude
SLAB_DESTROY_BY_RCU marked caches from the per-object sanitization. It
only can do page based sanitization for such slabs.

>> > conntrack objects are alloc'd/free'd from a SLAB_DESTROY_BY_RCU cache.
>> >
>> > It is therefore legal to access a conntrack object from another
>> > CPU even after kmem_cache_free() was invoked on another cpu, provided all
>> > readers that do so hold rcu_read_lock, and verify that object has not been
>> > freed yet by issuing appropriate atomic_inc_not_zero calls.
>> >
>> > Therefore, object poisoning will only be safe from rcu callback, after
>> > accesses are known to be illegal/invalid.
>>
>> Can you expand on that? The term "object poisoning" to me means an
>> object (you are talking about the conntract tuple, right?) with
>
> Yes.
>
>> problematic values is put into memory, but the way you phrase it seems
>> more like the hash table itself is being manipulated improperly.
>
> No, afaics the conntrack object accesses are correct.
>
>> I'm still trying to work out what the actual ISSUE is. My
>> understanding is this, thus far:
>>
>> It seems like an object in the connection track hash table is being
>> improperly marked as free, which then is sanitized, and is then later
>> being accessed by the netfilter codepath that loops through the table.
>
> No.  Conntrack objects are free'd when the last reference counter goes
> away.  However, because lookup of the conntrack hash table is lockless,
> another CPU might be accessing the conntrack object that is being free'd
> right now.
>
> Usually this means that the access is invalid.  However, in the
> conntrack case, the conntrack objects are allocated from a special
> cache that delays freeing of underlying pages until we know that no
> other cpu is currently accessing it.
>
> So there are 2 possible cases:
> 1 - the conntrack object that is being looked at is alive (refcnt > 1).
> 2 - the conntrack object that is being looked is being free'd RIGHT NOW
> on another cpu.  RCU protects us from page fault, since the underlying
> memory page cannot be free'd.
>
> So, we're safe to look at the memory contents of the tuple and decide
> wheter its the object (conntrack tuple) we're trying to find or not.
>
> If it is, we try to obtain a reference, this will only succeed if the
> reference count is not 0 already, so we can detect the "its free'd"
> case.
>
> If we obtained a reference, we still need to re-validate the tuple
> address since its possible that the object was free'd on cpu x and
> almost-instantly reallocated for use by a different tuple.
>
> If you are interested in this you can have a look at the bug fixes made
> in that area, there are some more explanations there.
>
> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/net/netfilter/nf_conntrack_core.c?id=e53376bef2cd97d3e3f61fdc677fb8da7d03d0da
> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/net/netfilter/nf_conntrack_core.c?id=c6825c0976fa7893692e0e43b09740b419b23c09
>

PaX per-object sanitization just nullifies this assumption as its
poisoning would set the reference count to 0xfefefefe which is clearly
not zero. So, it looks like, the only place to safely sanitize the
object is on the page level -- when it gets released after the RCU
period has passed. And that's what the latest version of PaX sanitize
is doing now.

>> > If you use different allocator, please tell us which one (check kernel
>> > config, slub is default).
>>
>> SLAB allocator, though I do not remember making the choice.
>>
>> From the kernel config that's causing issues:
>>
>> # egrep 'SLAB|SLUB' .config
>> CONFIG_SLAB=y
>> # CONFIG_SLUB is not set
>> CONFIG_SLABINFO=y
>> # CONFIG_DEBUG_SLAB is not set
>> CONFIG_PAX_USERCOPY_SLABS=y
>
> Ok, from a quick glance PaX slab kfree is also zapping
> objects before grace period elapsed.

Yep. But that is now fixed in the latest version -- for all of them:
SLAB/SLOB/SLUB.

>> > If its reproduceable with poisoning done after the RCU grace periods
>> > have elapsed (i.e., where its not legal anymore to access the memory),
>> > please let us know and we can have another look at it.
>> >
>> > Thanks.
>>
>> Reproducability is an issue since I don't know what's triggering it in
>> the first place. Just that it happens after a variable length of time
>> along the same code path, subject to differences between the two
>> kernel versions I've seen this issue with.
>>
>> The machine itself is pushing 20-25 megabytes (~50k packets) per
>> second at any given time and has smacked the default conntrack hash
>> table maximums. So the netfilter system is under nontrivial stresses.
>
> It should be able to handle a lot more.
>
> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/net/netfilter/nf_conntrack_core.c?id=93bb0ceb75be2fdfa9fc0dd1fb522d9ada515d9c
>
>> I'll happily work with you guys to isolate this as this is an
>> interesting problem and I'm bored, but I need a bit of help and
>> prompting to get this done properly.
>
> Sure, my understanding is that someone from pax team is working on
> the object poisoning to handle SLAB_DESTROY_BY_RCU properly.
>
> Please don't hesitate to report back with newer pax versions if you
> still see invalid accesses.

Thanks Florian, for investigating on this!

Regards,
Mathias
