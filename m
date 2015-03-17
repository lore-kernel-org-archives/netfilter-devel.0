From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: ipset: Proposed improvements to the kernel code
Date: Tue, 17 Mar 2015 15:45:02 +0100 (CET)
Message-ID: <alpine.DEB.2.10.1503171459340.25136@blackhole.kfki.hu>
References: <2984705.dCFJb2qqrb@tuxracer> <1543409.17Fue4MmIJ@tuxracer> <alpine.DEB.2.10.1503171132190.25136@blackhole.kfki.hu> <17192717.ykyp7yZVki@tuxracer>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Sergey Popovich <popovich_sergei@mail.ua>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp0.kfki.hu ([148.6.0.25]:50681 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754090AbbCQOnP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 17 Mar 2015 10:43:15 -0400
In-Reply-To: <17192717.ykyp7yZVki@tuxracer>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, 17 Mar 2015, Sergey Popovich wrote:

> I did not say that you should do anything, I just give an option (like 
> branch) to let you quickly see changes I made if you wish. Maybe you 
> find them totally useless:)

I see - a branch costs nothing, so that's no problem. Then create a 
numbered list of the patches, put them in a tar file and let me know from 
where I can download it.
 
> On the other hand I'm worry about if I start supplying my patch series 
> (say this takes one month) there is no major changes will be entered to 
> the master ipset git tree, so I get rebase again and again, as actually 
> happened before commit 920ddfa09 where I have made some changes (bug 
> fixes at that moment).

Such things may happen when multiple patches flow in and some parts are 
just modified. But in such a case like this, changes can be communicated 
back and forth.

> > > For example quick overview of the current RCU implementation in the 
> > > ip_set_core.c gives no hint on how all further readers are prevented 
> > > from entering set before it is being destroyed (i.e. we can destroy 
> > > core set data structures with ip_set_destroy_set() while they being 
> > > accessed by the ip_set_test().
> > 
> > That's excluded by the set references: set can be destroyed only when it's
> > reference counter is zero and ip_set_test() can be called for referenced
> > sets only.
> 
> I did not agree with this since ip_set.c:ip_set_destroy_set() after 
> checking of reference counters is called, but ip_set(inst, index) = NULL 
> (which itself looks unclear since pointer assignments alone not 
> guaranteed to be atomic, thus rcu_assign_pointer() and friends exists) 
> used without any RCU grace period waiters like synchronize_rcu().

No. Please check xt_set.c and all the checkentry functions: sets are 
referenced there and until such reference is not created, no 
ip_set_test|add|del() function can use the set. The reference is released 
in the match/target destroy functions - and the set can be destroyed only 
after that. When the pointer assigment happens above, there cannot be any 
user of the set, there's no need for any protection.

> Yes I see rcu_barrier() is used in each set module, however it is more 
> for waiting of callbacks to complete (or kfree_rcu).

It's called from the module unload path. Actually, at that time there 
isn't any set belonging to the given set type (because otherwise the 
module could not be removed).
 
> Therefore ip_set_test() could easily enter set structures before 
> ip_set(inst, index) = NULL and destroyed in the ip_set_destroy_set() at 
> the same time.

That simply cannot happen due to the reference counter protection.

> There is other things to consider: ip_set_add()/ip_set_del() and of course
> timeout enabled set gc routine (I known del_timer_sync() is the first
> in ->destroy() method).
> 
> set_bit(j, n->used);
> 	if (old != ERR_PTR(-ENOENT)) {
> 		rcu_assign_pointer(hbucket(t, key), n);
> 
> This looks as data publishing prior to using it where bit is set before 
> pointer to the new data assigned to the bucket.

When new hashbucket is created, the set_bit() call is actually an 
initialization.
 
> Calling ip_set_ext_destroy() concurrently with readers seems also not
> friendly. Currently this is only for commens, but if any other extension,
> used by the readers is added problems will arise.

As I mentioned, that's the only part which needs fixing.
 
> In general any modification to the data should be consistent for 
> concurrent readers all times, and should be only modified/released after 
> RCU grace period (or in case of RCU-bh after one softirq scheduling). 
> Modification data inline seems worse to me.

When data can safely be modified, then that's the better approach.
 
> > > Also I don't think there is a good idea to modify cidr book keeping 
> > > data without any protection from the concurrent readers.
> > 
> > cidr book keeping was changed so that it is safe to modify it without 
> > any protection. The worst case is that a reader loops at the same cidr 
> > value twice.
> 
> Anyway this seems worse to me.

Why? No data corruption can happen and that's the fastest way. The worst 
case scenario is not the common case.
 
> > The main point of the ipset git tree is to keep and maintain support
> > kernel versions back to the last (i.e. 2.6.32) longterm kernel tree.
> 
> However debugging locking issues without lockdep is much harder and
> having one when it is available seems good.

It can probably be added in a wrapper which gives noop for older kernels.
 
> > > Using test_bit() in the fastpath loops to skip empty entries with 
> > > bitmap probably wastes more time than using ffs()/ffz().
> > 
> > I'm sure patches for that can be applied without any problem.
> 
> With minimal, since ffs()/ffz() may be architecture specific, or even 
> generic taking unsigned long. However on 32 bit arches sizeof(unsigned 
> long) == 4, but net:iface uses up to 64 slots, so u64 type should be 
> used with __ffs64().
> 
> As for optimizations I have many other small ones:)

Great, I'm looking forward for improvements!

> > > Providing additionall variant callback ->uref() to handle references
> > > seems confusing in aspects of set dump: we release set items prior to
> > > dumping them. Furthermore due to netlink_dump_start() nature (callbacks)
> > > there is no guarantee that we do not get pointer to the new table after
> > > resize (for hashes) where all dumps become inconsistent anyway. Running
> > > via callbacks implies no locking on the entire ipset structures (checked
> > > with lockdep), only first call of the callback may be locked with NFNL.
> > 
> > The uref() callback is required for the parallel resizing and dumping:
> > dumping keeps the original hash table and the uref referecen counter tells
> > the system which function should destroy it: resizing (because there are
> > no parallel dump using the old hash table) or the dumping (because
> > resizing successfully created a new hash table).
> 
> Yes, I'm already aware of this problem.

The problem is already solved in the current ipset git tree.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
