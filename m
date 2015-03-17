From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: ipset: Proposed improvements to the kernel code
Date: Tue, 17 Mar 2015 13:31:50 +0100 (CET)
Message-ID: <alpine.DEB.2.10.1503171132190.25136@blackhole.kfki.hu>
References: <2984705.dCFJb2qqrb@tuxracer> <alpine.DEB.2.10.1503162026490.23975@blackhole.kfki.hu> <1543409.17Fue4MmIJ@tuxracer>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Sergey Popovich <popovich_sergei@mail.ua>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.26]:33398 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752096AbbCQM36 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 17 Mar 2015 08:29:58 -0400
In-Reply-To: <1543409.17Fue4MmIJ@tuxracer>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Sergey,

On Tue, 17 Mar 2015, Sergey Popovich wrote:

> > Please rebase your patches against the ipset git tree: the development 
> > happens there and patches are submitted from the ipset git tree to 
> > nf-next. Also, do not forget to create numbered patches in the future. 
> > Thanks!
> 
> I known that main development of the ipset is done in ipset git tree. 
> However current it's state is far from my branch. I guess there is 
> excessive number of conflicts on rebase.

I cannot do much about it.

> Currently I'm able to do less or more clear rebase to the ipset git tree
> until commit 920ddfa09efbd72a0fe43251cd19bc2c27aa3662
> (Introduce RCU in all set types instead of rwlock per set).

That's before ipset 6.24 was released.
 
> As I wrote earlier I have series of 170 patches, rebase may take more
> time than development of the my series. But even that's not main concern.
> I can't warranty that everything after applying small series will be 
> consistent at all, only after applying final series.

170 patches are a lot. You should not have let to accumulate so many in 
your tree.

> Maybe you are in interest of creating some branch on top of the
> current ipset git tree to look at my work in the whole? Im not wery
> happy with idea of rebasing my whole series to the ipset git tree
> due to massive conflicts.
> 
> Sure there will be much less of work if you decide to merge branches.
> 
> Thanks for your interest for my series.

I'm really interested in your patches, but... do you expect me to roll 
back all of the patches in the ipset git tree, to go back before commit 
920ddfa09efbd72a0fe43251cd19bc2c27aa3662? Or to handle and resolve all 
conflicts when merging the ipset and your branch - instead of you?
 
> Sorry, forget to note in the original mail one category:
> 
>   * Using memory cache to store set elements (i.e. kmem_cache).
> 
> Also I did not do deep analysis of the current ipset git tree RCU 
> implementation since patch introducing it looks monolitics, but I think
> it has some number of problems.

As far as I know the only unresolved issue is the proper RCU handling of 
the comment extension.

> For example quick overview of the current RCU implementation in the 
> ip_set_core.c gives no hint on how all further readers are prevented from 
> entering set before it is being destroyed (i.e. we can destroy core set data 
> structures with ip_set_destroy_set() while they being accessed by the 
> ip_set_test().

That's excluded by the set references: set can be destroyed only when it's 
reference counter is zero and ip_set_test() can be called for referenced 
sets only.
 
> Also I don't think there is a good idea to modify cidr book keeping data
> without any protection from the concurrent readers.

cidr book keeping was changed so that it is safe to modify it without any 
protection. The worst case is that a reader loops at the same cidr value 
twice.
 
> Using rcu_dereference_protected() with spin_is_locked() as condition
> may be is not best choise, kernel has lockdep support for now, which
> is more proven technique for locking issue debugging.

The main point of the ipset git tree is to keep and maintain support 
kernel versions back to the last (i.e. 2.6.32) longterm kernel tree.
That means that a new feature from the mainline kernel is used when it can 
easily be backported or can be worked around by (fall back to) an old 
method.

> Using test_bit() in the fastpath loops to skip empty entries with bitmap
> probably wastes more time than using ffs()/ffz().

I'm sure patches for that can be applied without any problem.

> Providing additionall variant callback ->uref() to handle references 
> seems confusing in aspects of set dump: we release set items prior to 
> dumping them. Furthermore due to netlink_dump_start() nature (callbacks) 
> there is no guarantee that we do not get pointer to the new table after 
> resize (for hashes) where all dumps become inconsistent anyway. Running 
> via callbacks implies no locking on the entire ipset structures (checked 
> with lockdep), only first call of the callback may be locked with NFNL.

The uref() callback is required for the parallel resizing and dumping: 
dumping keeps the original hash table and the uref referecen counter tells 
the system which function should destroy it: resizing (because there are 
no parallel dump using the old hash table) or the dumping (because 
resizing successfully created a new hash table).

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
