From: Sergey Popovich <popovich_sergei@mail.ua>
Subject: Re: ipset: Proposed improvements to the kernel code
Date: Tue, 17 Mar 2015 20:59:51 +0200
Message-ID: <4532245.8hNB4lJHyg@tuxracer>
References: <2984705.dCFJb2qqrb@tuxracer> <17192717.ykyp7yZVki@tuxracer> <alpine.DEB.2.10.1503171459340.25136@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp44.i.mail.ru ([94.100.177.104]:43934 "EHLO smtp44.i.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932091AbbCQS74 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 17 Mar 2015 14:59:56 -0400
Received: from [95.135.32.1] (port=19096 helo=tuxracer.localnet)
	by smtp44.i.mail.ru with esmtpa (envelope-from <popovich_sergei@mail.ua>)
	id 1YXwiX-0003Me-HK
	for netfilter-devel@vger.kernel.org; Tue, 17 Mar 2015 21:59:54 +0300
In-Reply-To: <alpine.DEB.2.10.1503171459340.25136@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


> > I did not say that you should do anything, I just give an option (like
> > branch) to let you quickly see changes I made if you wish. Maybe you
> > find them totally useless:)
> 
> I see - a branch costs nothing, so that's no problem. Then create a
> numbered list of the patches, put them in a tar file and let me know from
> where I can download it.

Thanks Jozsef, I have prepare patches for you and put link to the series.

http://ftp.payport.com.ua/users/sergey/public/netfilter-devel-2015031701.tar

These patches will be against nf-next for simplicity and I'm already rebase
them, so for first review just fresh nf-next will be needed.

> > > > For example quick overview of the current RCU implementation in the
> > > > ip_set_core.c gives no hint on how all further readers are prevented
> > > > from entering set before it is being destroyed (i.e. we can destroy
> > > > core set data structures with ip_set_destroy_set() while they being
> > > > accessed by the ip_set_test().
> > > 
> > > That's excluded by the set references: set can be destroyed only when
> > > it's
> > > reference counter is zero and ip_set_test() can be called for referenced
> > > sets only.
> > 
> > I did not agree with this since ip_set.c:ip_set_destroy_set() after
> > checking of reference counters is called, but ip_set(inst, index) = NULL
> > (which itself looks unclear since pointer assignments alone not
> > guaranteed to be atomic, thus rcu_assign_pointer() and friends exists)
> > used without any RCU grace period waiters like synchronize_rcu().
> 
> No. Please check xt_set.c and all the checkentry functions: sets are
> referenced there and until such reference is not created, no
> ip_set_test|add|del() function can use the set. The reference is released
> in the match/target destroy functions - and the set can be destroyed only
> after that. When the pointer assigment happens above, there cannot be any
> user of the set, there's no need for any protection.

If you mean ip_set*nfnl*() then they just needed to be used in the properly
written code (such as xt_set.c and em_ipset.c). However they just reference
set to prevent it from deletion. Set already published in netns ip_set_list
and available to ip_set_add() and ip_set_del() (sure anyone should not call 
these functions from the kernel without first referencing the set with 
ip_set*nfnl*()).

On the other hand, code using ip_set_{add,del,test}() should also ensure
there is no callers to such ones after ip_set*nfnl*().

I reviewed all of such code in xt_set.c and em_ipset.c and you are right.
Im just try to be more paranoid in the subsystem implementation.

> 
> > Yes I see rcu_barrier() is used in each set module, however it is more
> > for waiting of callbacks to complete (or kfree_rcu).
> 
> It's called from the module unload path. Actually, at that time there
> isn't any set belonging to the given set type (because otherwise the
> module could not be removed).

I think it is not necessary at all if no outstanding rcu callbacks are used
in favor to kfree_rcu() which itselfs rcu callback to kfree() to just free
data without any actions taken (for which rcu callbacks intended).

In my series callbacks used to destroy memory cache allocations and
extensions.

I like to take full copy of the bucket before modification with extensions
and not rely on set_bit()/clear_bit() it gives on guarantee on reordering on 
arches other than x86 (see comment in include/asm-generic/atomic.h).

So adding new element takes copy of the full bucket (which is up to 12
positions for all hash:* except netiface, where it 64 positions) and
extensions.

Yes, it seems expensive, but correct in all aspects including extensions. 
Previous copies destroyed with rcu callbacks. Callbacks itself wery simple 
pose minimal overhead.

I split implementation of bitmap:* sets to the two variants: ordinary
array of bits when set created w/o extensions and array of pointers (hash 
table w/o collisions) for sets w/ extensions, since having bitmap:* with
extensions anyway uses array of extensions data and accessing pointer
is a cheap on most platforms. This also simplifies my RCU implementation.

For bitmap:* where bitmap (array of bits, no extensions) is used there is no 
RCU needed since whenever we have bit set or bit clear for concurrent
readers on modify does not play any significant role.

For bitmap:* implemented as array of pointers (element is in set if pointer
points to the data) this is much like for hash:* sets.

For list:set it is standard linux double linked list RCU variant.

Destroy procedure is split into parts:
  hide set from the new readers

  flush all elements from the set, and mark it as inactive under set lock,
  so other writers (ip_set_test() -EAGAIN for bitmap:ipmac and 
  ip_set_{add,del}() and gc routine) won't modify it. Current readers
  may still use set data.

  wait for RCU grace period to let readers to finish with set structures

  wait for RCU callbacks to complete (after flushing elements)

  finally destroy set data without any lock.

All tests I made are done on relatively ancient hardware (Pentium D 2.8Ghz,
DDR 2 for SMP x86, x86_64 and PIII 1Ghz for UP).

> > There is other things to consider: ip_set_add()/ip_set_del() and of course
> > timeout enabled set gc routine (I known del_timer_sync() is the first
> > in ->destroy() method).
> > 
> > set_bit(j, n->used);
> > 
> > 	if (old != ERR_PTR(-ENOENT)) {
> > 	
> > 		rcu_assign_pointer(hbucket(t, key), n);
> > 
> > This looks as data publishing prior to using it where bit is set before
> > pointer to the new data assigned to the bucket.
> 
> When new hashbucket is created, the set_bit() call is actually an
> initialization.

Yes, sorry for that, n is an unpublished bucket. Correct.

But what about memcpy()? Extensions assignment? These operations
is not atomic.

> 
> > Calling ip_set_ext_destroy() concurrently with readers seems also not
> > friendly. Currently this is only for commens, but if any other extension,
> > used by the readers is added problems will arise.
> 
> As I mentioned, that's the only part which needs fixing.
> 
> > In general any modification to the data should be consistent for
> > concurrent readers all times, and should be only modified/released after
> > RCU grace period (or in case of RCU-bh after one softirq scheduling).
> > Modification data inline seems worse to me.
> 
> When data can safely be modified, then that's the better approach.
> 
> > > > Also I don't think there is a good idea to modify cidr book keeping
> > > > data without any protection from the concurrent readers.
> > > 
> > > cidr book keeping was changed so that it is safe to modify it without
> > > any protection. The worst case is that a reader loops at the same cidr
> > > value twice.
> > 
> > Anyway this seems worse to me.
> 
> Why? No data corruption can happen and that's the fastest way. The worst
> case scenario is not the common case.
> 
> > > The main point of the ipset git tree is to keep and maintain support
> > > kernel versions back to the last (i.e. 2.6.32) longterm kernel tree.
> > 
> > However debugging locking issues without lockdep is much harder and
> > having one when it is available seems good.
> 
> It can probably be added in a wrapper which gives noop for older kernels.

Yes, supporting old kernels is a good choise.

On the other hand I think that it would be nice to have branch, similar to the 
nf-next (say ipset-next) for supplying patches to the upstream and make all 
code in this branch inline with upstream kernel.

I think this eases work for supplying patches from ipset to nf-next, or
request for pull may be send to mailing list instead of individual patches
(this is how nf-next pulled by DM into net-next).

Then new changes from the ipset-next could be backported into ipset git tree
(say it would be named as ipset-stable to the analogy with linux-stable etc.).

> 
> Best regards,
> Jozsef
> -
> E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
> PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
> Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
>           H-1525 Budapest 114, POB. 49, Hungary

-- 
SP5474-RIPE
Sergey Popovich
