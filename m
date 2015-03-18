From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: ipset: Proposed improvements to the kernel code
Date: Wed, 18 Mar 2015 20:59:50 +0100 (CET)
Message-ID: <alpine.DEB.2.10.1503172117100.27562@blackhole.kfki.hu>
References: <2984705.dCFJb2qqrb@tuxracer> <17192717.ykyp7yZVki@tuxracer> <alpine.DEB.2.10.1503171459340.25136@blackhole.kfki.hu> <4532245.8hNB4lJHyg@tuxracer>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Sergey Popovich <popovich_sergei@mail.ua>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.28]:51919 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754099AbbCRT56 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 18 Mar 2015 15:57:58 -0400
In-Reply-To: <4532245.8hNB4lJHyg@tuxracer>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, 17 Mar 2015, Sergey Popovich wrote:

> Thanks Jozsef, I have prepare patches for you and put link to the series.
> 
> http://ftp.payport.com.ua/users/sergey/public/netfilter-devel-2015031701.tar
> 
> These patches will be against nf-next for simplicity and I'm already rebase
> them, so for first review just fresh nf-next will be needed.

Thanks, I have downloaded it and started to review the patches.
 
> > No. Please check xt_set.c and all the checkentry functions: sets are
> > referenced there and until such reference is not created, no
> > ip_set_test|add|del() function can use the set. The reference is released
> > in the match/target destroy functions - and the set can be destroyed only
> > after that. When the pointer assigment happens above, there cannot be any
> > user of the set, there's no need for any protection.
> 
> If you mean ip_set*nfnl*() then they just needed to be used in the properly
> written code (such as xt_set.c and em_ipset.c). However they just reference
> set to prevent it from deletion. Set already published in netns ip_set_list
> and available to ip_set_add() and ip_set_del() (sure anyone should not call 
> these functions from the kernel without first referencing the set with 
> ip_set*nfnl*()).
> 
> On the other hand, code using ip_set_{add,del,test}() should also ensure
> there is no callers to such ones after ip_set*nfnl*().
> 
> I reviewed all of such code in xt_set.c and em_ipset.c and you are right.
> Im just try to be more paranoid in the subsystem implementation.

There are countless ways to break the kernel from inside when the API is 
violated in a module.

> > > Yes I see rcu_barrier() is used in each set module, however it is more
> > > for waiting of callbacks to complete (or kfree_rcu).
> > 
> > It's called from the module unload path. Actually, at that time there
> > isn't any set belonging to the given set type (because otherwise the
> > module could not be removed).
> 
> I think it is not necessary at all if no outstanding rcu callbacks are used
> in favor to kfree_rcu() which itselfs rcu callback to kfree() to just free
> data without any actions taken (for which rcu callbacks intended).

When Pablo reviewed the RCU patches he suggested to add the calls to 
rcu_barrier() for the clarity.

> In my series callbacks used to destroy memory cache allocations and
> extensions.
> 
> I like to take full copy of the bucket before modification with extensions
> and not rely on set_bit()/clear_bit() it gives on guarantee on reordering on 
> arches other than x86 (see comment in include/asm-generic/atomic.h).

Reordering can be prevented with smp_mb__before_atomic() and alike.

> So adding new element takes copy of the full bucket (which is up to 12
> positions for all hash:* except netiface, where it 64 positions) and
> extensions.
>
> Yes, it seems expensive, but correct in all aspects including extensions. 
> Previous copies destroyed with rcu callbacks. Callbacks itself wery simple 
> pose minimal overhead.

The memory allocations are expensive operations!

> I split implementation of bitmap:* sets to the two variants: ordinary
> array of bits when set created w/o extensions and array of pointers (hash 
> table w/o collisions) for sets w/ extensions, since having bitmap:* with
> extensions anyway uses array of extensions data and accessing pointer
> is a cheap on most platforms. This also simplifies my RCU implementation.
> 
> For bitmap:* where bitmap (array of bits, no extensions) is used there is no 
> RCU needed since whenever we have bit set or bit clear for concurrent
> readers on modify does not play any significant role.
> 
> For bitmap:* implemented as array of pointers (element is in set if pointer
> points to the data) this is much like for hash:* sets.
> 
> For list:set it is standard linux double linked list RCU variant.

This is quite similar how RCU is introduced in ipset.

> Destroy procedure is split into parts:
>   hide set from the new readers
> 
>   flush all elements from the set, and mark it as inactive under set lock,
>   so other writers (ip_set_test() -EAGAIN for bitmap:ipmac and 
>   ip_set_{add,del}() and gc routine) won't modify it. Current readers
>   may still use set data.
> 
>   wait for RCU grace period to let readers to finish with set structures
> 
>   wait for RCU callbacks to complete (after flushing elements)
> 
>   finally destroy set data without any lock.

There are NO READERS when the destroy function is called.

> All tests I made are done on relatively ancient hardware (Pentium D 2.8Ghz,
> DDR 2 for SMP x86, x86_64 and PIII 1Ghz for UP).
> 
> > > There is other things to consider: ip_set_add()/ip_set_del() and of course
> > > timeout enabled set gc routine (I known del_timer_sync() is the first
> > > in ->destroy() method).
> > > 
> > > set_bit(j, n->used);
> > > 
> > > 	if (old != ERR_PTR(-ENOENT)) {
> > > 	
> > > 		rcu_assign_pointer(hbucket(t, key), n);
> > > 
> > > This looks as data publishing prior to using it where bit is set before
> > > pointer to the new data assigned to the bucket.
> > 
> > When new hashbucket is created, the set_bit() call is actually an
> > initialization.
> 
> Yes, sorry for that, n is an unpublished bucket. Correct.
> 
> But what about memcpy()? Extensions assignment? These operations
> is not atomic.

Those are also initializations in the code part you refer to.

Also please note, the comment extension is alone which needs special 
treatment. At the same time it is not used by the kernel functions at all 
- except when dumping the set. Therefore I want to avoid any *unnecessary* 
overhead (both in processing and memory usage) about it.

> > > However debugging locking issues without lockdep is much harder and
> > > having one when it is available seems good.
> > 
> > It can probably be added in a wrapper which gives noop for older kernels.
> 
> Yes, supporting old kernels is a good choise.
> 
> On the other hand I think that it would be nice to have branch, similar to the 
> nf-next (say ipset-next) for supplying patches to the upstream and make all 
> code in this branch inline with upstream kernel.

That's a maintenance question. So far the backported/wrapped things could 
be kept to a minimum number which made possible to keep a single branch.

> I think this eases work for supplying patches from ipset to nf-next, or
> request for pull may be send to mailing list instead of individual patches
> (this is how nf-next pulled by DM into net-next).

I maintain an nf-next tree in order to make possible the simple pulling of 
the patches, but that is independent from the ipset git tree (because of 
the backward compatibility stuff).

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
