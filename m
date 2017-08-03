From: Phil Sutter <phil@nwl.cc>
Subject: nftables: Testcase crashes the kernel
Date: Thu, 3 Aug 2017 21:45:50 +0200
Message-ID: <20170803194550.GA9380@orbyte.nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:58527 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751773AbdHCTpv (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 3 Aug 2017 15:45:51 -0400
Received: from mail.nwl.cc (orbyte.nwl.cc [127.0.0.1])
        by mail.nwl.cc (Postfix) with ESMTP id 911DB681C4
        for <netfilter-devel@vger.kernel.org>; Thu,  3 Aug 2017 21:45:50 +0200 (CEST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

While running tests/shell testsuite, I notice a kernel crash during
execution of ./testcases/maps/0003map_add_many_elements_0.

I am running nf-next kernel with head at
4d3a57f23dec59f0a2362e63540b2d01b37afe0a.

Here's the crashdump:

[  570.593118] BUG: unable to handle kernel paging request at 0000000000006a24
[  570.594093] IP: skb_release_data+0x72/0x170
[  570.594789] PGD 2ca31067 
[  570.594791] P4D 2ca31067 
[  570.595250] PUD 30a32067 
[  570.595748] PMD 0 
[  570.596221] 
[  570.596893] Oops: 0002 [#1] PREEMPT SMP KASAN
[  570.597713] Modules linked in: nf_tables_ipv4 nf_tables nfnetlink nf_conntrack_ipv4 nf_defrag_ipv4 nf_conntrack 8021q [last unloaded: nfnetlink]
[  570.599439] CPU: 0 PID: 3540 Comm: nft Not tainted 4.13.0-rc1-00381-g4d3a57f23dec5 #50
[  570.600313] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.10.2-1.fc27 04/01/2014
[  570.601095] task: ffff880034f95700 task.stack: ffff8800357f8000
[  570.601505] RIP: 0010:skb_release_data+0x72/0x170
[  570.601837] RSP: 0018:ffff8800357ff738 EFLAGS: 00010203
[  570.602207] RAX: 00000000ffffffff RBX: ffff880035300dc0 RCX: ffffffff81c1979a
[  570.602696] RDX: 0000000000000001 RSI: dffffc0000000000 RDI: ffff880035300e4e
[  570.603196] RBP: ffff8800357ff760 R08: 0000000000bf789d R09: 0000000000000003
[  570.603685] R10: 00000000bc2c803a R11: 00000000a131ea44 R12: ffffc900001579ca
[  570.604283] R13: 0000000000006a00 R14: ffffffffa0020e9f R15: ffff880035300dc0
[  570.604973] FS:  00007f7142c2f700(0000) GS:ffff880036200000(0000) knlGS:0000000000000000
[  570.605670] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  570.606190] CR2: 0000000000006a24 CR3: 000000003289b000 CR4: 00000000001406f0
[  570.606882] Call Trace:
[  570.607134]  ? nfnetlink_rcv+0x6af/0xb00 [nfnetlink]
[  570.607618]  __kfree_skb+0x1a/0x30
[  570.607960]  kfree_skb+0x44/0xf0
[  570.608257]  nfnetlink_rcv+0x6af/0xb00 [nfnetlink]
[  570.608669]  ? nfnl_err_reset+0xc0/0xc0 [nfnetlink]
[  570.609099]  ? __netlink_lookup+0x1f9/0x260
[  570.609503]  ? netlink_recvmsg+0x670/0x670
[  570.609827]  ? __rcu_read_unlock+0x6d/0x90
[  570.610242]  netlink_unicast+0x2be/0x3c0
[  570.610672]  ? netlink_sendskb+0x40/0x40
[  570.611104]  ? _copy_from_iter_full+0xe2/0x3a0
[  570.611618]  ? memset+0x31/0x40
[  570.612020]  netlink_sendmsg+0x561/0x600
[  570.612468]  ? nlmsg_notify+0xd0/0xd0
[  570.612858]  sock_sendmsg+0x4d/0x60
[  570.613258]  ___sys_sendmsg+0x4da/0x4f0
[  570.613720]  ? copy_msghdr_from_user+0x210/0x210
[  570.614282]  ? kasan_slab_free+0xaf/0x190
[  570.614767]  ? kmem_cache_free+0x88/0x220
[  570.615241]  ? remove_vma+0x87/0xa0
[  570.615654]  ? do_munmap+0x4ca/0x620
[  570.616075]  ? SyS_brk+0x2a3/0x330
[  570.616420]  ? entry_SYSCALL_64_fastpath+0x13/0x94
[  570.616891]  ? flush_tlb_mm_range+0xd2/0x160
[  570.617311]  ? lru_add_drain_cpu+0xb0/0x170
[  570.617712]  ? kasan_free_pages+0x59/0x60
[  570.618093]  ? cap_capable+0x9d/0xe0
[  570.618433]  ? __rcu_read_unlock+0x6d/0x90
[  570.618827]  ? _raw_spin_unlock_bh+0x23/0x30
[  570.619229]  ? release_sock+0xc3/0xd0
[  570.619575]  ? sock_setsockopt+0x29a/0xd00
[  570.619968]  ? sock_enable_timestamp+0x60/0x60
[  570.620394]  ? remove_vma+0x87/0xa0
[  570.620729]  ? call_rcu+0x17/0x20
[  570.621044]  ? put_object+0x32/0x40
[  570.621372]  ? __fget_light+0xa7/0xc0
[  570.621722]  __sys_sendmsg+0xbf/0x130
[  570.622068]  ? __sys_sendmsg+0xbf/0x130
[  570.622428]  ? SyS_shutdown+0x120/0x120
[  570.622800]  ? SyS_setsockopt+0x17b/0x190
[  570.623190]  ? SyS_recv+0x20/0x20
[  570.623514]  SyS_sendmsg+0x12/0x20
[  570.623850]  entry_SYSCALL_64_fastpath+0x13/0x94
[  570.624298] RIP: 0033:0x7f71420a56b7
[  570.624646] RSP: 002b:00007fff895c4bb8 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
[  570.625377] RAX: ffffffffffffffda RBX: 00007f7142bfd0ac RCX: 00007f71420a56b7
[  570.626061] RDX: 0000000000000000 RSI: 00007fff895c4c10 RDI: 0000000000000003
[  570.626767] RBP: 0000000000008001 R08: 0000000000000004 R09: 000000000000000a
[  570.627546] R10: 00000000000005e8 R11: 0000000000000246 R12: 00007f7142bfd0ac
[  570.628382] R13: 00007f7142bfd0d0 R14: 000000000148f1d0 R15: 0000000000000367
[  570.629196] Code: 52 73 ff 41 0f b6 87 8e 00 00 00 a8 01 74 31 83 e0 02 3c 01 89 c2 19 c0 0d ff ff fe ff 80 fa 01 19 d2 66 31 d2 81 c2 01 00 01 00 <f0> 41 0f c1 45 24 39 c2 74 0b 5b 41 5c 41 5d 41 5e 41 5f 5d c3 
[  570.631171] RIP: skb_release_data+0x72/0x170 RSP: ffff8800357ff738
[  570.631596] CR2: 0000000000006a24
[  570.635791] ---[ end trace caf8646dc8c272dd ]---
[  570.636185] Kernel panic - not syncing: Fatal exception
[  570.636741] Kernel Offset: disabled
[  570.637052] ---[ end Kernel panic - not syncing: Fatal exception

