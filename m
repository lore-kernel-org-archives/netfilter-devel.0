Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [148.6.0.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5748F1DE8AF
	for <netfilter-devel@vger.kernel.org>; Thu, 13 Nov 2025 15:47:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.6.0.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763048846; cv=none; b=FF7Ivel7soKkS01zNcnIQHJFKb4c1EzWmNY0CuFQW2MFWELE+ZKQjg4Y5d7DU0oYUQfWAM53z8WLRc2ShIjHdJzobD5yPeIF22sTQOYuwtYrt2hTbFdrwHM04Xcl30EaZOezE6mT9YSC0VixZh/Go87ilzLzKQL4RiR+EJfGopA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763048846; c=relaxed/simple;
	bh=JfW3xL1MEvUqNXe/G/0U2AIrvhwPHFYZP95hD8CR/nI=;
	h=Date:From:To:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=T5cS/kDjaxCI8OXsRKZ87xUD2r5bY/DuXhj0dlmbMJkuvSyGIkUKSZ/PkvlyCYoqV1JjLJBv4e1CDLIvSbFsmH9b81vA1Ft6hDjSgI55K0ry1g9Z+pTZaQnM6uJLbYvNs9WkywgaWCl17ZXpDFwJqd8XkAe0HolErtnaeXHlk3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=148.6.0.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Received: from localhost (localhost [127.0.0.1])
	by smtp0.kfki.hu (Postfix) with ESMTP id 4d6kyf5Qd1z3sb9v
	for <netfilter-devel@vger.kernel.org>; Thu, 13 Nov 2025 16:41:30 +0100 (CET)
X-Virus-Scanned: Debian amavis at smtp0.kfki.hu
Received: from smtp0.kfki.hu ([127.0.0.1])
 by localhost (smtp0.kfki.hu [127.0.0.1]) (amavis, port 10026) with ESMTP
 id L3LW4MxQAZEu for <netfilter-devel@vger.kernel.org>;
 Thu, 13 Nov 2025 16:41:27 +0100 (CET)
Received: from mentat.rmki.kfki.hu (unknown [148.6.192.8])
	(Authenticated sender: kadlecsik.jozsef@wigner.hu)
	by smtp0.kfki.hu (Postfix) with ESMTPSA id 4d6kyb3sS6z3sb9B
	for <netfilter-devel@vger.kernel.org>; Thu, 13 Nov 2025 16:41:27 +0100 (CET)
Received: by mentat.rmki.kfki.hu (Postfix, from userid 1000)
	id F2544140738; Thu, 13 Nov 2025 16:41:26 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by mentat.rmki.kfki.hu (Postfix) with ESMTP id EF472140527
	for <netfilter-devel@vger.kernel.org>; Thu, 13 Nov 2025 16:41:26 +0100 (CET)
Date: Thu, 13 Nov 2025 16:41:26 +0100 (CET)
From: Jozsef Kadlecsik <kadlec@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: Re: [syzbot] [netfilter?] possible deadlock in
 ip_set_nfnl_get_byindex
In-Reply-To: <6915a8ef.050a0220.3565dc.0025.GAE@google.com>
Message-ID: <8cd1a354-7bef-4f3e-5e3d-4a3742d619d9@netfilter.org>
References: <6915a8ef.050a0220.3565dc.0025.GAE@google.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

Hi,

On Thu, 13 Nov 2025, syzbot wrote:

> syzbot found the following issue on:
> 
> HEAD commit:    e927c520e1ba Merge tag 'loongarch-fixes-6.18-1' of git://g..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=110d97cd980000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=609c87dcb0628493
> dashboard link: https://syzkaller.appspot.com/bug?extid=aefe8555e94ae62b95c1
> compiler:       gcc (Debian 12.2.0-14+deb12u1) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40
> 
> Unfortunately, I don't have any reproducer for this issue yet.
> 
> Downloadable assets:
> disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-e927c520.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/216d03ed7180/vmlinux-e927c520.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/63801f21a529/bzImage-e927c520.xz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+aefe8555e94ae62b95c1@syzkaller.appspotmail.com
> 
> ======================================================
> WARNING: possible circular locking dependency detected
> syzkaller #0 Not tainted
> ------------------------------------------------------
> syz.9.6420/24339 is trying to acquire lock:
> ffffffff9af8cbd8 (nfnl_subsys_ipset){+.+.}-{4:4}, at: ip_set_nfnl_get_byindex+0x7c/0x290 net/netfilter/ipset/ip_set_core.c:909
> 
> but task is already holding lock:
> ffff888026b1e0d8 (&nft_net->commit_mutex){+.+.}-{4:4}, at: nf_tables_valid_genid+0x35/0x140 net/netfilter/nf_tables_api.c:11499
> 
> which lock already depends on the new lock.
> 
> 
> the existing dependency chain (in reverse order) is:
> 
> -> #2 (&nft_net->commit_mutex){+.+.}-{4:4}:
>        __mutex_lock_common kernel/locking/mutex.c:598 [inline]
>        __mutex_lock+0x193/0x1060 kernel/locking/mutex.c:760
>        nf_tables_dumpreset_set+0xcd/0x320 net/netfilter/nf_tables_api.c:6288
>        netlink_dump+0x539/0xd30 net/netlink/af_netlink.c:2327
>        __netlink_dump_start+0x6d6/0x990 net/netlink/af_netlink.c:2442
>        netlink_dump_start include/linux/netlink.h:341 [inline]
>        nft_netlink_dump_start_rcu+0x81/0x1f0 net/netfilter/nf_tables_api.c:1286
>        nf_tables_getsetelem_reset+0x946/0xab0 net/netfilter/nf_tables_api.c:6604
>        nfnetlink_rcv_msg+0x583/0x1200 net/netfilter/nfnetlink.c:290
>        netlink_rcv_skb+0x158/0x420 net/netlink/af_netlink.c:2552
>        nfnetlink_rcv+0x1b3/0x430 net/netfilter/nfnetlink.c:669
>        netlink_unicast_kernel net/netlink/af_netlink.c:1320 [inline]
>        netlink_unicast+0x5aa/0x870 net/netlink/af_netlink.c:1346
>        netlink_sendmsg+0x8c8/0xdd0 net/netlink/af_netlink.c:1896
>        sock_sendmsg_nosec net/socket.c:727 [inline]
>        __sock_sendmsg net/socket.c:742 [inline]
>        ____sys_sendmsg+0xa98/0xc70 net/socket.c:2630
>        ___sys_sendmsg+0x134/0x1d0 net/socket.c:2684
>        __sys_sendmsg+0x16d/0x220 net/socket.c:2716
>        do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>        do_syscall_64+0xcd/0xfa0 arch/x86/entry/syscall_64.c:94
>        entry_SYSCALL_64_after_hwframe+0x77/0x7f
> 
> -> #1 (nlk_cb_mutex-NETFILTER){+.+.}-{4:4}:
>        __mutex_lock_common kernel/locking/mutex.c:598 [inline]
>        __mutex_lock+0x193/0x1060 kernel/locking/mutex.c:760
>        __netlink_dump_start+0x150/0x990 net/netlink/af_netlink.c:2406
>        netlink_dump_start include/linux/netlink.h:341 [inline]
>        ip_set_dump+0x17f/0x210 net/netfilter/ipset/ip_set_core.c:1717
>        nfnetlink_rcv_msg+0x9fc/0x1200 net/netfilter/nfnetlink.c:302
>        netlink_rcv_skb+0x158/0x420 net/netlink/af_netlink.c:2552
>        nfnetlink_rcv+0x1b3/0x430 net/netfilter/nfnetlink.c:669
>        netlink_unicast_kernel net/netlink/af_netlink.c:1320 [inline]
>        netlink_unicast+0x5aa/0x870 net/netlink/af_netlink.c:1346
>        netlink_sendmsg+0x8c8/0xdd0 net/netlink/af_netlink.c:1896
>        sock_sendmsg_nosec net/socket.c:727 [inline]
>        __sock_sendmsg net/socket.c:742 [inline]
>        ____sys_sendmsg+0xa98/0xc70 net/socket.c:2630
>        ___sys_sendmsg+0x134/0x1d0 net/socket.c:2684
>        __sys_sendmsg+0x16d/0x220 net/socket.c:2716
>        do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>        do_syscall_64+0xcd/0xfa0 arch/x86/entry/syscall_64.c:94
>        entry_SYSCALL_64_after_hwframe+0x77/0x7f
> 
> -> #0 (nfnl_subsys_ipset){+.+.}-{4:4}:
>        check_prev_add kernel/locking/lockdep.c:3165 [inline]
>        check_prevs_add kernel/locking/lockdep.c:3284 [inline]
>        validate_chain kernel/locking/lockdep.c:3908 [inline]
>        __lock_acquire+0x126f/0x1c90 kernel/locking/lockdep.c:5237
>        lock_acquire kernel/locking/lockdep.c:5868 [inline]
>        lock_acquire+0x179/0x350 kernel/locking/lockdep.c:5825
>        __mutex_lock_common kernel/locking/mutex.c:598 [inline]
>        __mutex_lock+0x193/0x1060 kernel/locking/mutex.c:760
>        ip_set_nfnl_get_byindex+0x7c/0x290 net/netfilter/ipset/ip_set_core.c:909
>        set_target_v1_checkentry+0x1ac/0x570 net/netfilter/xt_set.c:313
>        xt_check_target+0x27c/0xa40 net/netfilter/x_tables.c:1038
>        nft_target_init+0x459/0x7d0 net/netfilter/nft_compat.c:267
>        nf_tables_newexpr net/netfilter/nf_tables_api.c:3527 [inline]
>        nf_tables_newrule+0xea9/0x28f0 net/netfilter/nf_tables_api.c:4358
>        nfnetlink_rcv_batch+0x190d/0x2350 net/netfilter/nfnetlink.c:526
>        nfnetlink_rcv_skb_batch net/netfilter/nfnetlink.c:649 [inline]
>        nfnetlink_rcv+0x3c1/0x430 net/netfilter/nfnetlink.c:667
>        netlink_unicast_kernel net/netlink/af_netlink.c:1320 [inline]
>        netlink_unicast+0x5aa/0x870 net/netlink/af_netlink.c:1346
>        netlink_sendmsg+0x8c8/0xdd0 net/netlink/af_netlink.c:1896
>        sock_sendmsg_nosec net/socket.c:727 [inline]
>        __sock_sendmsg net/socket.c:742 [inline]
>        ____sys_sendmsg+0xa98/0xc70 net/socket.c:2630
>        ___sys_sendmsg+0x134/0x1d0 net/socket.c:2684
>        __sys_sendmsg+0x16d/0x220 net/socket.c:2716
>        do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>        do_syscall_64+0xcd/0xfa0 arch/x86/entry/syscall_64.c:94
>        entry_SYSCALL_64_after_hwframe+0x77/0x7f
> 
> other info that might help us debug this:
> 
> Chain exists of:
>   nfnl_subsys_ipset --> nlk_cb_mutex-NETFILTER --> &nft_net->commit_mutex
> 
>  Possible unsafe locking scenario:
> 
>        CPU0                    CPU1
>        ----                    ----
>   lock(&nft_net->commit_mutex);
>                                lock(nlk_cb_mutex-NETFILTER);
>                                lock(&nft_net->commit_mutex);
>   lock(nfnl_subsys_ipset);
> 
>  *** DEADLOCK ***

I simply don't see where's the possible circular lock dependency.

nfnl_subsys_ipset lock is - as far as I know - totally independent of 
nft_net->commit_mutex lock.

So where's the issue?

Best regards,
Jozsef
 
> 1 lock held by syz.9.6420/24339:
>  #0: ffff888026b1e0d8 (&nft_net->commit_mutex){+.+.}-{4:4}, at: nf_tables_valid_genid+0x35/0x140 net/netfilter/nf_tables_api.c:11499
> 
> stack backtrace:
> CPU: 3 UID: 0 PID: 24339 Comm: syz.9.6420 Not tainted syzkaller #0 PREEMPT(full) 
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
> Call Trace:
>  <TASK>
>  __dump_stack lib/dump_stack.c:94 [inline]
>  dump_stack_lvl+0x116/0x1f0 lib/dump_stack.c:120
>  print_circular_bug+0x275/0x350 kernel/locking/lockdep.c:2043
>  check_noncircular+0x14c/0x170 kernel/locking/lockdep.c:2175
>  check_prev_add kernel/locking/lockdep.c:3165 [inline]
>  check_prevs_add kernel/locking/lockdep.c:3284 [inline]
>  validate_chain kernel/locking/lockdep.c:3908 [inline]
>  __lock_acquire+0x126f/0x1c90 kernel/locking/lockdep.c:5237
>  lock_acquire kernel/locking/lockdep.c:5868 [inline]
>  lock_acquire+0x179/0x350 kernel/locking/lockdep.c:5825
>  __mutex_lock_common kernel/locking/mutex.c:598 [inline]
>  __mutex_lock+0x193/0x1060 kernel/locking/mutex.c:760
>  ip_set_nfnl_get_byindex+0x7c/0x290 net/netfilter/ipset/ip_set_core.c:909
>  set_target_v1_checkentry+0x1ac/0x570 net/netfilter/xt_set.c:313
>  xt_check_target+0x27c/0xa40 net/netfilter/x_tables.c:1038
>  nft_target_init+0x459/0x7d0 net/netfilter/nft_compat.c:267
>  nf_tables_newexpr net/netfilter/nf_tables_api.c:3527 [inline]
>  nf_tables_newrule+0xea9/0x28f0 net/netfilter/nf_tables_api.c:4358
>  nfnetlink_rcv_batch+0x190d/0x2350 net/netfilter/nfnetlink.c:526
>  nfnetlink_rcv_skb_batch net/netfilter/nfnetlink.c:649 [inline]
>  nfnetlink_rcv+0x3c1/0x430 net/netfilter/nfnetlink.c:667
>  netlink_unicast_kernel net/netlink/af_netlink.c:1320 [inline]
>  netlink_unicast+0x5aa/0x870 net/netlink/af_netlink.c:1346
>  netlink_sendmsg+0x8c8/0xdd0 net/netlink/af_netlink.c:1896
>  sock_sendmsg_nosec net/socket.c:727 [inline]
>  __sock_sendmsg net/socket.c:742 [inline]
>  ____sys_sendmsg+0xa98/0xc70 net/socket.c:2630
>  ___sys_sendmsg+0x134/0x1d0 net/socket.c:2684
>  __sys_sendmsg+0x16d/0x220 net/socket.c:2716
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xcd/0xfa0 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f24a538f6c9
> Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007f24a6265038 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
> RAX: ffffffffffffffda RBX: 00007f24a55e5fa0 RCX: 00007f24a538f6c9
> RDX: 0000000000000800 RSI: 0000200000000100 RDI: 0000000000000004
> RBP: 00007f24a5411f91 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f24a55e6038 R14: 00007f24a55e5fa0 R15: 00007ffc70b4f688
>  </TASK>
> Cannot find add_set index 0 as target
> 
> 
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
> 
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> 
> If the report is already addressed, let syzbot know by replying with:
> #syz fix: exact-commit-title
> 
> If you want to overwrite report's subsystems, reply with:
> #syz set subsystems: new-subsystem
> (See the list of subsystem names on the web dashboard)
> 
> If the report is a duplicate of another one, reply with:
> #syz dup: exact-subject-of-another-report
> 
> If you want to undo deduplication, reply with:
> #syz undup
> 

-- 
E-mail : kadlec@netfilter.org, kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.hu
Address: Wigner Research Centre for Physics
         H-1525 Budapest 114, POB. 49, Hungary
