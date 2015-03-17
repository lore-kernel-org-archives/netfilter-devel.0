From: Sergey Popovich <popovich_sergei@mail.ua>
Subject: Re: ipset: Proposed improvements to the kernel code
Date: Tue, 17 Mar 2015 06:46:28 +0200
Message-ID: <1543409.17Fue4MmIJ@tuxracer>
References: <2984705.dCFJb2qqrb@tuxracer> <alpine.DEB.2.10.1503162026490.23975@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from fallback6.mail.ru ([94.100.181.147]:51355 "EHLO
	fallback6.mail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750716AbbCQEtc (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 17 Mar 2015 00:49:32 -0400
Received: from smtp20.mail.ru (smtp20.mail.ru [94.100.179.251])
	by fallback6.mail.ru (mPOP.Fallback_MX) with ESMTP id 8A05F1C7BDE
	for <netfilter-devel@vger.kernel.org>; Tue, 17 Mar 2015 07:46:30 +0300 (MSK)
Received: from [95.135.32.1] (port=13269 helo=tuxracer.localnet)
	by smtp20.mail.ru with esmtpa (envelope-from <popovich_sergei@mail.ua>)
	id 1YXjOe-0007cc-Tr
	for netfilter-devel@vger.kernel.org; Tue, 17 Mar 2015 07:46:29 +0300
In-Reply-To: <alpine.DEB.2.10.1503162026490.23975@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


> 
> Please rebase your patches against the ipset git tree: the development
> happens there and patches are submitted from the ipset git tree to
> nf-next. Also, do not forget to create numbered patches in the future.
> Thanks!

Hello Jozsef.

I known that main development of the ipset is done in ipset git tree.
However current it's state is far from my branch. I guess there is excessive
number of conflicts on rebase.

Currently I'm able to do less or more clear rebase to the ipset git tree
until commit 920ddfa09efbd72a0fe43251cd19bc2c27aa3662
(Introduce RCU in all set types instead of rwlock per set).

As I wrote earlier I have series of 170 patches, rebase may take more
time than development of the my series. But even that's not main concern.
I can't warranty that everything after applying small series will be 
consistent at all, only after applying final series.

Maybe you are in interest of creating some branch on top of the
current ipset git tree to look at my work in the whole? Im not wery
happy with idea of rebasing my whole series to the ipset git tree
due to massive conflicts.

Sure there will be much less of work if you decide to merge branches.

Thanks for your interest for my series.

Sorry, forget to note in the original mail one category:

  * Using memory cache to store set elements (i.e. kmem_cache).

----

Also I did not do deep analysis of the current ipset git tree RCU 
implementation since patch introducing it looks monolitics, but I think
it has some number of problems.

For example quick overview of the current RCU implementation in the 
ip_set_core.c gives no hint on how all further readers are prevented from 
entering set before it is being destroyed (i.e. we can destroy core set data 
structures with ip_set_destroy_set() while they being accessed by the 
ip_set_test().

Also I don't think there is a good idea to modify cidr book keeping data
without any protection from the concurrent readers.

Using rcu_dereference_protected() with spin_is_locked() as condition
may be is not best choise, kernel has lockdep support for now, which
is more proven technique for locking issue debugging.

Using test_bit() in the fastpath loops to skip empty entries with bitmap
probably wastes more time than using ffs()/ffz().

Providing additionall variant callback ->uref() to handle references
seems confusing in aspects of set dump: we release set items
prior to dumping them. Furthermore due to netlink_dump_start()
nature (callbacks) there is no guarantee that we do not get
pointer to the new table after resize (for hashes) where all dumps
become inconsistent anyway. Running via callbacks implies no locking on the 
entire ipset structures (checked with lockdep), only first call of the callback 
may be locked with NFNL.

> 
> I'm able to apply one single patch from your current series.
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

