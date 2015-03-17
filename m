From: Sergey Popovich <popovich_sergei@mail.ua>
Subject: Re: ipset: Proposed improvements to the kernel code
Date: Tue, 17 Mar 2015 15:23:11 +0200
Message-ID: <17192717.ykyp7yZVki@tuxracer>
References: <2984705.dCFJb2qqrb@tuxracer> <1543409.17Fue4MmIJ@tuxracer> <alpine.DEB.2.10.1503171132190.25136@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp22.mail.ru ([94.100.181.177]:40776 "EHLO smtp22.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752520AbbCQNXX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 17 Mar 2015 09:23:23 -0400
Received: from [195.234.68.4] (port=39301 helo=tuxracer.localnet)
	by smtp22.mail.ru with esmtpa (envelope-from <popovich_sergei@mail.ua>)
	id 1YXrSl-0005BV-76
	for netfilter-devel@vger.kernel.org; Tue, 17 Mar 2015 16:23:20 +0300
In-Reply-To: <alpine.DEB.2.10.1503171132190.25136@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Jozsef

> 
> I'm really interested in your patches, but... do you expect me to roll
> back all of the patches in the ipset git tree, to go back before commit
> 920ddfa09efbd72a0fe43251cd19bc2c27aa3662? Or to handle and resolve all
> conflicts when merging the ipset and your branch - instead of you?

I did not say that you should do anything, I just give an option (like branch) 
to let you quickly see changes I made if you wish. Maybe you find them totally 
useless:)

On the other hand I'm worry about if I start supplying my patch series (say 
this takes one month) there is no major changes will be entered to the master
ipset git tree, so I get rebase again and again, as actually happened before
commit 920ddfa09 where I have made some changes (bug fixes at that moment).

I will think on how to perform such rebase much painless and if you give no
other option I will try to perform repase for the master of ipset git tree.

I still think that having custom branch (say ipset-pending, ipset-current,
ipset-experimental etc.) would be a nice option. But this is only my point of
view:)

Thanks for your time.

> 
> > Sorry, forget to note in the original mail one category:
> >   * Using memory cache to store set elements (i.e. kmem_cache).
> > 
> > Also I did not do deep analysis of the current ipset git tree RCU
> > implementation since patch introducing it looks monolitics, but I think
> > it has some number of problems.
> 
> As far as I know the only unresolved issue is the proper RCU handling of
> the comment extension.
> 

> > For example quick overview of the current RCU implementation in the
> > ip_set_core.c gives no hint on how all further readers are prevented from
> > entering set before it is being destroyed (i.e. we can destroy core set
> > data structures with ip_set_destroy_set() while they being accessed by
> > the ip_set_test().
> 
> That's excluded by the set references: set can be destroyed only when it's
> reference counter is zero and ip_set_test() can be called for referenced
> sets only.

I did not agree with this since ip_set.c:ip_set_destroy_set() after checking
of reference counters is called, but ip_set(inst, index) = NULL (which itself
looks unclear since pointer assignments alone not guaranteed to be atomic,
thus rcu_assign_pointer() and friends exists) used without any RCU grace 
period waiters like synchronize_rcu(). Yes I see rcu_barrier() is used in each
set module, however it is more for waiting of callbacks to complete (or 
kfree_rcu).

Therefore ip_set_test() could easily enter set structures before ip_set(inst, 
index) = NULL and destroyed in the ip_set_destroy_set() at the same time.

There is other things to consider: ip_set_add()/ip_set_del() and of course
timeout enabled set gc routine (I known del_timer_sync() is the first
in ->destroy() method).

set_bit(j, n->used);
	if (old != ERR_PTR(-ENOENT)) {
		rcu_assign_pointer(hbucket(t, key), n);

This looks as data publishing prior to using it where bit is set before 
pointer to the new data assigned to the bucket.

Calling ip_set_ext_destroy() concurrently with readers seems also not
friendly. Currently this is only for commens, but if any other extension,
used by the readers is added problems will arise.

In general any modification to the data should be consistent for concurrent
readers all times, and should be only modified/released after RCU grace
period (or in case of RCU-bh after one softirq scheduling). Modification
data inline seems worse to me.

I didn't go deeper with current ipset git tree code, but sure there other
problems here.

> 
> > Also I don't think there is a good idea to modify cidr book keeping data
> > without any protection from the concurrent readers.
> 
> cidr book keeping was changed so that it is safe to modify it without any
> protection. The worst case is that a reader loops at the same cidr value
> twice.

Anyway this seems worse to me.

> 
> > Using rcu_dereference_protected() with spin_is_locked() as condition
> > may be is not best choise, kernel has lockdep support for now, which
> > is more proven technique for locking issue debugging.
> 
> The main point of the ipset git tree is to keep and maintain support
> kernel versions back to the last (i.e. 2.6.32) longterm kernel tree.
> That means that a new feature from the mainline kernel is used when it can
> easily be backported or can be worked around by (fall back to) an old
> method.

Yes I fully agree with you in this point and see no problem on backporting
up to the 2.6.32. I could even do some testings for major distros using such
kernels. No problem here.

I'm using 3.2.x series + nf-next version of ipset (which is sync to 6.23) for 
this development and it is works perfectly with wery few things backported.

However debugging locking issues without lockdep is much harder and
having one when it is available seems good.

> 
> > Using test_bit() in the fastpath loops to skip empty entries with bitmap
> > probably wastes more time than using ffs()/ffz().
> 
> I'm sure patches for that can be applied without any problem.

With minimal, since ffs()/ffz() may be architecture specific, or even generic 
taking unsigned long. However on 32 bit arches sizeof(unsigned long) == 4,
but net:iface uses up to 64 slots, so u64 type should be used with __ffs64().

As for optimizations I have many other small ones:)

> 
> > Providing additionall variant callback ->uref() to handle references
> > seems confusing in aspects of set dump: we release set items prior to
> > dumping them. Furthermore due to netlink_dump_start() nature (callbacks)
> > there is no guarantee that we do not get pointer to the new table after
> > resize (for hashes) where all dumps become inconsistent anyway. Running
> > via callbacks implies no locking on the entire ipset structures (checked
> > with lockdep), only first call of the callback may be locked with NFNL.
> 
> The uref() callback is required for the parallel resizing and dumping:
> dumping keeps the original hash table and the uref referecen counter tells
> the system which function should destroy it: resizing (because there are
> no parallel dump using the old hash table) or the dumping (because
> resizing successfully created a new hash table).

Yes, I'm already aware of this problem.

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

