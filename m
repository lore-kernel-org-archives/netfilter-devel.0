Received: from mail-ot1-f72.google.com (mail-ot1-f72.google.com [209.85.210.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87D61263C8C
	for <netfilter-devel@vger.kernel.org>; Wed,  8 Apr 2026 12:35:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775651707; cv=none; b=AOGkzHZhq96ZDDFSJeCWypbJG/Q7sGMp/SPMTN4l+axqZDpbOMbkxrv8osFfH/CfUSjjflPoI1OAIEWRp4QnteqUgmbtcuxORGv1a5pBnohwexCeBB7hykOi2DZfb17jXx5IiABVGJqCj5torXBBwkKc0NjjyTQVe6jAZFzc3zo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775651707; c=relaxed/simple;
	bh=doSUHs5wFxaJTxHdOMQOMWdO/MiEGGRBMVEpjwhZsxQ=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=aPKFBAsGdgWxTuEg1DABOJm2zROb9VrziARJHz2JNt+q6YfiLrr4cOv1RJ0B1D/kS2omi2kwffw2qydYcM1qHg/5cKqsMSDUtX9QROl1S5LCRGviMAbWcjdRm+7qaMNVBEDEJ1wqdMNSZnQcUfbA4NCclRvPds7V/9lD3arvNOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.210.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f72.google.com with SMTP id 46e09a7af769-7dbc48dd44eso1653013a34.1
        for <netfilter-devel@vger.kernel.org>; Wed, 08 Apr 2026 05:35:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775651701; x=1776256501;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nYJT/yqpaxYXUm863ql7d5vQNk6qddXJNOsakoes2/c=;
        b=jx5YQNerV/aSxcS720aMKEo4bUxMveinTU6tUhWSiJ4Qt0bWt2518mIUq3eZKpaqut
         TZzb5sR0iAui/iSDAiFHtu42ygpXnd6V34N8WPvbhhdCjUBlJ8PAY11KO7VEt9fXo76G
         hFOGs7dGZnToFdIPhZU6FUoIe8evb3zGAn65LkRF1t3wnUgbWOZ0+g2Bp/dYu3l9G2+k
         Fx6+MWQvepiC4FdDUOAB1RIv2eWk0jSaQCBmxrol3yBALz+rmJ0wjHAx7cVBkBV8b1WV
         AlJTzroTL3hc2vMfKeJVorN9B3zhv8wb1hKa+rHBHXqQ/kLpVEPbcnhaRxrDQZHg8oxr
         RmbA==
X-Forwarded-Encrypted: i=1; AJvYcCUr4vquZJ13YY4dOgEVM2vfM9gDj3Oarloz2+NsxDAxC/pHSWUIv7bvMZiOz0l7/Ntd2WycyQcb4aPgIYvkR3E=@vger.kernel.org
X-Gm-Message-State: AOJu0YxkE7Snn9XroK3LCY3EVF063GYm6OEPdsHg84ombENFfSYrwm7j
	whdtlYjOk4bLg55TN3ql3KVJcYdxYkXoqyvEEwl0Isn3hQnyhTvH4vEgzKMaol/Riza/13dn9xm
	daDh3WGPcKnH3MmymHBHFQXnKkySyhTWRErGK6WRApNp8niHX0Mp/qTEF3zg=
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:7045:b0:687:6c5f:1331 with SMTP id
 006d021491bc7-6876c5f1433mr3402166eaf.34.1775651700985; Wed, 08 Apr 2026
 05:35:00 -0700 (PDT)
Date: Wed, 08 Apr 2026 05:35:00 -0700
In-Reply-To: <20260408070257.2437291-1-kadlec@netfilter.org>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69d64b74.050a0220.adfb3.0003.GAE@google.com>
Subject: [syzbot ci] Re: netfilter: ipset: concurrent add and dump fixes
From: syzbot ci <syzbot+cidea2d6bafc0138d9@syzkaller.appspotmail.com>
To: fw@strlen.de, kadlec@netfilter.org, netfilter-devel@vger.kernel.org, 
	pablo@netfilter.org
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v1] netfilter: ipset: concurrent add and dump fixes
https://lore.kernel.org/all/20260408070257.2437291-1-kadlec@netfilter.org
* [PATCH 1/2] netfilter: ipset: Fix data race between add and list header in all hash types
* [PATCH 2/2] netfilter: ipset: Fix data race between add and dump in all hash types

and found the following issues:
* KASAN: slab-out-of-bounds Write in hash_ip4_add
* KASAN: slab-out-of-bounds Write in hash_ipport4_add
* KASAN: slab-out-of-bounds Write in hash_ipport6_add
* KASAN: slab-out-of-bounds Write in hash_ipportnet6_add
* KASAN: slab-out-of-bounds Write in hash_netnet4_add

Full report is available here:
https://ci.syzbot.org/series/05533f07-931b-4bbe-886e-737c3dded97b

***

KASAN: slab-out-of-bounds Write in hash_ip4_add

tree:      nf-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netfilter/nf-next.git
base:      47117877d5707b32773bb3d5fd8f1f9aaf8f1f3b
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/8ee93551-dc97-4078-8c85-f884da5dc0bf/config
syz repro: https://ci.syzbot.org/findings/09c3128d-24de-48b4-9d49-798ba00bda6e/syz_repro

==================================================================
BUG: KASAN: slab-out-of-bounds in hash_ip4_add+0x1063/0x1f20 net/netfilter/ipset/ip_set_hash_gen.h:974
Write of size 4 at addr ffff8881a844a680 by task syz.2.19/5958

CPU: 1 UID: 0 PID: 5958 Comm: syz.2.19 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 print_address_description mm/kasan/report.c:378 [inline]
 print_report+0xba/0x230 mm/kasan/report.c:482
 kasan_report+0x117/0x150 mm/kasan/report.c:595
 check_region_inline mm/kasan/generic.c:-1 [inline]
 kasan_check_range+0x264/0x2c0 mm/kasan/generic.c:200
 __asan_memcpy+0x40/0x70 mm/kasan/shadow.c:106
 hash_ip4_add+0x1063/0x1f20 net/netfilter/ipset/ip_set_hash_gen.h:974
 hash_ip4_uadt+0x664/0x860 net/netfilter/ipset/ip_set_hash_ip.c:160
 call_ad+0x18d/0xb60 net/netfilter/ipset/ip_set_core.c:1751
 ip_set_ad+0x824/0x9d0 net/netfilter/ipset/ip_set_core.c:1841
 nfnetlink_rcv_msg+0xc00/0x12c0 net/netfilter/nfnetlink.c:300
 netlink_rcv_skb+0x232/0x4b0 net/netlink/af_netlink.c:2550
 nfnetlink_rcv+0x2c0/0x27b0 net/netfilter/nfnetlink.c:667
 netlink_unicast_kernel net/netlink/af_netlink.c:1318 [inline]
 netlink_unicast+0x80f/0x9b0 net/netlink/af_netlink.c:1344
 netlink_sendmsg+0x813/0xb40 net/netlink/af_netlink.c:1894
 sock_sendmsg_nosec net/socket.c:721 [inline]
 __sock_sendmsg net/socket.c:736 [inline]
 ____sys_sendmsg+0x972/0x9f0 net/socket.c:2585
 ___sys_sendmsg+0x2a5/0x360 net/socket.c:2639
 __sys_sendmsg net/socket.c:2671 [inline]
 __do_sys_sendmsg net/socket.c:2676 [inline]
 __se_sys_sendmsg net/socket.c:2674 [inline]
 __x64_sys_sendmsg+0x1bd/0x2a0 net/socket.c:2674
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fc54039c819
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fc53f9fe028 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007fc540615fa0 RCX: 00007fc54039c819
RDX: 0000000004000084 RSI: 0000200000000000 RDI: 0000000000000004
RBP: 00007fc540432c91 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fc540616038 R14: 00007fc540615fa0 R15: 00007ffe3b0d6a38
 </TASK>

Allocated by task 5958:
 kasan_save_stack mm/kasan/common.c:57 [inline]
 kasan_save_track+0x3e/0x80 mm/kasan/common.c:78
 poison_kmalloc_redzone mm/kasan/common.c:398 [inline]
 __kasan_kmalloc+0x93/0xb0 mm/kasan/common.c:415
 kasan_kmalloc include/linux/kasan.h:263 [inline]
 __do_kmalloc_node mm/slub.c:5260 [inline]
 __kmalloc_noprof+0x35c/0x760 mm/slub.c:5272
 kmalloc_noprof include/linux/slab.h:954 [inline]
 kzalloc_noprof include/linux/slab.h:1188 [inline]
 hash_ip4_add+0xc85/0x1f20 net/netfilter/ipset/ip_set_hash_gen.h:881
 hash_ip4_uadt+0x664/0x860 net/netfilter/ipset/ip_set_hash_ip.c:160
 call_ad+0x18d/0xb60 net/netfilter/ipset/ip_set_core.c:1751
 ip_set_ad+0x824/0x9d0 net/netfilter/ipset/ip_set_core.c:1841
 nfnetlink_rcv_msg+0xc00/0x12c0 net/netfilter/nfnetlink.c:300
 netlink_rcv_skb+0x232/0x4b0 net/netlink/af_netlink.c:2550
 nfnetlink_rcv+0x2c0/0x27b0 net/netfilter/nfnetlink.c:667
 netlink_unicast_kernel net/netlink/af_netlink.c:1318 [inline]
 netlink_unicast+0x80f/0x9b0 net/netlink/af_netlink.c:1344
 netlink_sendmsg+0x813/0xb40 net/netlink/af_netlink.c:1894
 sock_sendmsg_nosec net/socket.c:721 [inline]
 __sock_sendmsg net/socket.c:736 [inline]
 ____sys_sendmsg+0x972/0x9f0 net/socket.c:2585
 ___sys_sendmsg+0x2a5/0x360 net/socket.c:2639
 __sys_sendmsg net/socket.c:2671 [inline]
 __do_sys_sendmsg net/socket.c:2676 [inline]
 __se_sys_sendmsg net/socket.c:2674 [inline]
 __x64_sys_sendmsg+0x1bd/0x2a0 net/socket.c:2674
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

The buggy address belongs to the object at ffff8881a844a600
 which belongs to the cache kmalloc-128 of size 128
The buggy address is located 0 bytes to the right of
 allocated 128-byte region [ffff8881a844a600, ffff8881a844a680)

The buggy address belongs to the physical page:
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x1a844a
flags: 0x57ff00000000000(node=1|zone=2|lastcpupid=0x7ff)
page_type: f5(slab)
raw: 057ff00000000000 ffff888100041a00 dead000000000100 dead000000000122
raw: 0000000000000000 0000000800100010 00000000f5000000 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 0, migratetype Unmovable, gfp_mask 0xd2820(GFP_ATOMIC|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 5958, tgid 5957 (syz.2.19), ts 61144574473, free_ts 60982422209
 set_page_owner include/linux/page_owner.h:32 [inline]
 post_alloc_hook+0x231/0x280 mm/page_alloc.c:1889
 prep_new_page mm/page_alloc.c:1897 [inline]
 get_page_from_freelist+0x24dc/0x2580 mm/page_alloc.c:3962
 __alloc_frozen_pages_noprof+0x18d/0x380 mm/page_alloc.c:5250
 alloc_slab_page mm/slub.c:3292 [inline]
 allocate_slab+0x77/0x660 mm/slub.c:3481
 new_slab mm/slub.c:3539 [inline]
 refill_objects+0x331/0x3c0 mm/slub.c:7175
 refill_sheaf mm/slub.c:2812 [inline]
 __pcs_replace_empty_main+0x2e6/0x730 mm/slub.c:4615
 alloc_from_pcs mm/slub.c:4717 [inline]
 slab_alloc_node mm/slub.c:4851 [inline]
 __do_kmalloc_node mm/slub.c:5259 [inline]
 __kmalloc_noprof+0x474/0x760 mm/slub.c:5272
 kmalloc_noprof include/linux/slab.h:954 [inline]
 kzalloc_noprof include/linux/slab.h:1188 [inline]
 hash_ip4_add+0xc85/0x1f20 net/netfilter/ipset/ip_set_hash_gen.h:881
 hash_ip4_uadt+0x664/0x860 net/netfilter/ipset/ip_set_hash_ip.c:160
 call_ad+0x18d/0xb60 net/netfilter/ipset/ip_set_core.c:1751
 ip_set_ad+0x824/0x9d0 net/netfilter/ipset/ip_set_core.c:1841
 nfnetlink_rcv_msg+0xc00/0x12c0 net/netfilter/nfnetlink.c:300
 netlink_rcv_skb+0x232/0x4b0 net/netlink/af_netlink.c:2550
 nfnetlink_rcv+0x2c0/0x27b0 net/netfilter/nfnetlink.c:667
 netlink_unicast_kernel net/netlink/af_netlink.c:1318 [inline]
 netlink_unicast+0x80f/0x9b0 net/netlink/af_netlink.c:1344
 netlink_sendmsg+0x813/0xb40 net/netlink/af_netlink.c:1894
page last free pid 23 tgid 23 stack trace:
 reset_page_owner include/linux/page_owner.h:25 [inline]
 __free_pages_prepare mm/page_alloc.c:1433 [inline]
 __free_frozen_pages+0xc2b/0xdb0 mm/page_alloc.c:2978
 __tlb_remove_table_free mm/mmu_gather.c:228 [inline]
 tlb_remove_table_rcu+0x85/0x100 mm/mmu_gather.c:291
 rcu_do_batch kernel/rcu/tree.c:2617 [inline]
 rcu_core+0x7cd/0x1070 kernel/rcu/tree.c:2869
 handle_softirqs+0x22a/0x870 kernel/softirq.c:622
 run_ksoftirqd+0x36/0x60 kernel/softirq.c:1063
 smpboot_thread_fn+0x541/0xa50 kernel/smpboot.c:160
 kthread+0x388/0x470 kernel/kthread.c:436
 ret_from_fork+0x51e/0xb90 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

Memory state around the buggy address:
 ffff8881a844a580: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff8881a844a600: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>ffff8881a844a680: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
                   ^
 ffff8881a844a700: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 ffff8881a844a780: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
==================================================================


***

KASAN: slab-out-of-bounds Write in hash_ipport4_add

tree:      nf-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netfilter/nf-next.git
base:      47117877d5707b32773bb3d5fd8f1f9aaf8f1f3b
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/8ee93551-dc97-4078-8c85-f884da5dc0bf/config
syz repro: https://ci.syzbot.org/findings/d9446937-fb89-49b6-8e0d-0765ed1dc490/syz_repro

==================================================================
BUG: KASAN: slab-out-of-bounds in hash_ipport4_add+0x1218/0x22a0 net/netfilter/ipset/ip_set_hash_gen.h:974
Write of size 8 at addr ffff88810c5a8bb0 by task syz.1.18/5959

CPU: 0 UID: 0 PID: 5959 Comm: syz.1.18 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 print_address_description mm/kasan/report.c:378 [inline]
 print_report+0xba/0x230 mm/kasan/report.c:482
 kasan_report+0x117/0x150 mm/kasan/report.c:595
 check_region_inline mm/kasan/generic.c:-1 [inline]
 kasan_check_range+0x264/0x2c0 mm/kasan/generic.c:200
 __asan_memcpy+0x40/0x70 mm/kasan/shadow.c:106
 hash_ipport4_add+0x1218/0x22a0 net/netfilter/ipset/ip_set_hash_gen.h:974
 hash_ipport4_uadt+0xaaf/0xde0 net/netfilter/ipset/ip_set_hash_ipport.c:199
 call_ad+0x18d/0xb60 net/netfilter/ipset/ip_set_core.c:1751
 ip_set_ad+0x824/0x9d0 net/netfilter/ipset/ip_set_core.c:1841
 nfnetlink_rcv_msg+0xc00/0x12c0 net/netfilter/nfnetlink.c:300
 netlink_rcv_skb+0x232/0x4b0 net/netlink/af_netlink.c:2550
 nfnetlink_rcv+0x2c0/0x27b0 net/netfilter/nfnetlink.c:667
 netlink_unicast_kernel net/netlink/af_netlink.c:1318 [inline]
 netlink_unicast+0x80f/0x9b0 net/netlink/af_netlink.c:1344
 netlink_sendmsg+0x813/0xb40 net/netlink/af_netlink.c:1894
 sock_sendmsg_nosec net/socket.c:721 [inline]
 __sock_sendmsg net/socket.c:736 [inline]
 ____sys_sendmsg+0x972/0x9f0 net/socket.c:2585
 ___sys_sendmsg+0x2a5/0x360 net/socket.c:2639
 __sys_sendmsg net/socket.c:2671 [inline]
 __do_sys_sendmsg net/socket.c:2676 [inline]
 __se_sys_sendmsg net/socket.c:2674 [inline]
 __x64_sys_sendmsg+0x1bd/0x2a0 net/socket.c:2674
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f73b079c819
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f73b1662028 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007f73b0a15fa0 RCX: 00007f73b079c819
RDX: 0000000000000090 RSI: 00002000000002c0 RDI: 0000000000000004
RBP: 00007f73b0832c91 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f73b0a16038 R14: 00007f73b0a15fa0 R15: 00007fffcac649b8
 </TASK>

Allocated by task 5959:
 kasan_save_stack mm/kasan/common.c:57 [inline]
 kasan_save_track+0x3e/0x80 mm/kasan/common.c:78
 poison_kmalloc_redzone mm/kasan/common.c:398 [inline]
 __kasan_kmalloc+0x93/0xb0 mm/kasan/common.c:415
 kasan_kmalloc include/linux/kasan.h:263 [inline]
 __do_kmalloc_node mm/slub.c:5260 [inline]
 __kmalloc_noprof+0x35c/0x760 mm/slub.c:5272
 kmalloc_noprof include/linux/slab.h:954 [inline]
 kzalloc_noprof include/linux/slab.h:1188 [inline]
 hash_ipport4_add+0xec2/0x22a0 net/netfilter/ipset/ip_set_hash_gen.h:881
 hash_ipport4_uadt+0xaaf/0xde0 net/netfilter/ipset/ip_set_hash_ipport.c:199
 call_ad+0x18d/0xb60 net/netfilter/ipset/ip_set_core.c:1751
 ip_set_ad+0x824/0x9d0 net/netfilter/ipset/ip_set_core.c:1841
 nfnetlink_rcv_msg+0xc00/0x12c0 net/netfilter/nfnetlink.c:300
 netlink_rcv_skb+0x232/0x4b0 net/netlink/af_netlink.c:2550
 nfnetlink_rcv+0x2c0/0x27b0 net/netfilter/nfnetlink.c:667
 netlink_unicast_kernel net/netlink/af_netlink.c:1318 [inline]
 netlink_unicast+0x80f/0x9b0 net/netlink/af_netlink.c:1344
 netlink_sendmsg+0x813/0xb40 net/netlink/af_netlink.c:1894
 sock_sendmsg_nosec net/socket.c:721 [inline]
 __sock_sendmsg net/socket.c:736 [inline]
 ____sys_sendmsg+0x972/0x9f0 net/socket.c:2585
 ___sys_sendmsg+0x2a5/0x360 net/socket.c:2639
 __sys_sendmsg net/socket.c:2671 [inline]
 __do_sys_sendmsg net/socket.c:2676 [inline]
 __se_sys_sendmsg net/socket.c:2674 [inline]
 __x64_sys_sendmsg+0x1bd/0x2a0 net/socket.c:2674
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

The buggy address belongs to the object at ffff88810c5a8b80
 which belongs to the cache kmalloc-64 of size 64
The buggy address is located 0 bytes to the right of
 allocated 48-byte region [ffff88810c5a8b80, ffff88810c5a8bb0)

The buggy address belongs to the physical page:
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x10c5a8
flags: 0x17ff00000000000(node=0|zone=2|lastcpupid=0x7ff)
page_type: f5(slab)
raw: 017ff00000000000 ffff8881000418c0 dead000000000100 dead000000000122
raw: 0000000000000000 0000000800200020 00000000f5000000 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 0, migratetype Unmovable, gfp_mask 0xd2cc0(GFP_KERNEL|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 28, tgid 28 (kworker/u9:1), ts 11978057194, free_ts 0
 set_page_owner include/linux/page_owner.h:32 [inline]
 post_alloc_hook+0x231/0x280 mm/page_alloc.c:1889
 prep_new_page mm/page_alloc.c:1897 [inline]
 get_page_from_freelist+0x24dc/0x2580 mm/page_alloc.c:3962
 __alloc_frozen_pages_noprof+0x18d/0x380 mm/page_alloc.c:5250
 alloc_slab_page mm/slub.c:3292 [inline]
 allocate_slab+0x77/0x660 mm/slub.c:3481
 new_slab mm/slub.c:3539 [inline]
 refill_objects+0x331/0x3c0 mm/slub.c:7175
 refill_sheaf mm/slub.c:2812 [inline]
 __pcs_replace_empty_main+0x2e6/0x730 mm/slub.c:4615
 alloc_from_pcs mm/slub.c:4717 [inline]
 slab_alloc_node mm/slub.c:4851 [inline]
 __do_kmalloc_node mm/slub.c:5259 [inline]
 __kmalloc_node_noprof+0x577/0x7c0 mm/slub.c:5266
 kmalloc_node_noprof include/linux/slab.h:1081 [inline]
 __vmalloc_area_node mm/vmalloc.c:3855 [inline]
 __vmalloc_node_range_noprof+0x5d5/0x1730 mm/vmalloc.c:4064
 __vmalloc_node_noprof+0xc2/0x100 mm/vmalloc.c:4124
 alloc_thread_stack_node kernel/fork.c:355 [inline]
 dup_task_struct+0x275/0x9a0 kernel/fork.c:924
 copy_process+0x508/0x3cd0 kernel/fork.c:2050
 kernel_clone+0x248/0x8e0 kernel/fork.c:2653
 user_mode_thread+0x110/0x180 kernel/fork.c:2729
 call_usermodehelper_exec_work+0x5c/0x230 kernel/umh.c:171
 process_one_work kernel/workqueue.c:3276 [inline]
 process_scheduled_works+0xb6e/0x18c0 kernel/workqueue.c:3359
 worker_thread+0xa53/0xfc0 kernel/workqueue.c:3440
page_owner free stack trace missing

Memory state around the buggy address:
 ffff88810c5a8a80: fa fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
 ffff88810c5a8b00: fa fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
>ffff88810c5a8b80: 00 00 00 00 00 00 fc fc fc fc fc fc fc fc fc fc
                                     ^
 ffff88810c5a8c00: 00 00 00 00 00 00 fc fc fc fc fc fc fc fc fc fc
 ffff88810c5a8c80: fa fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
==================================================================


***

KASAN: slab-out-of-bounds Write in hash_ipport6_add

tree:      nf-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netfilter/nf-next.git
base:      47117877d5707b32773bb3d5fd8f1f9aaf8f1f3b
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/8ee93551-dc97-4078-8c85-f884da5dc0bf/config
syz repro: https://ci.syzbot.org/findings/5fc445de-91e9-4261-89a2-d6004861bc11/syz_repro

==================================================================
BUG: KASAN: slab-out-of-bounds in hash_ipport6_add+0x12fd/0x2260 net/netfilter/ipset/ip_set_hash_gen.h:974
Write of size 20 at addr ffff888110798c48 by task syz.2.19/6005

CPU: 0 UID: 0 PID: 6005 Comm: syz.2.19 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 print_address_description mm/kasan/report.c:378 [inline]
 print_report+0xba/0x230 mm/kasan/report.c:482
 kasan_report+0x117/0x150 mm/kasan/report.c:595
 check_region_inline mm/kasan/generic.c:-1 [inline]
 kasan_check_range+0x264/0x2c0 mm/kasan/generic.c:200
 __asan_memcpy+0x40/0x70 mm/kasan/shadow.c:106
 hash_ipport6_add+0x12fd/0x2260 net/netfilter/ipset/ip_set_hash_gen.h:974
 hash_ipport6_uadt+0x85d/0xb20 net/netfilter/ipset/ip_set_hash_ipport.c:351
 call_ad+0x18d/0xb60 net/netfilter/ipset/ip_set_core.c:1751
 ip_set_ad+0x824/0x9d0 net/netfilter/ipset/ip_set_core.c:1841
 nfnetlink_rcv_msg+0xc00/0x12c0 net/netfilter/nfnetlink.c:300
 netlink_rcv_skb+0x232/0x4b0 net/netlink/af_netlink.c:2550
 nfnetlink_rcv+0x2c0/0x27b0 net/netfilter/nfnetlink.c:667
 netlink_unicast_kernel net/netlink/af_netlink.c:1318 [inline]
 netlink_unicast+0x80f/0x9b0 net/netlink/af_netlink.c:1344
 netlink_sendmsg+0x813/0xb40 net/netlink/af_netlink.c:1894
 sock_sendmsg_nosec net/socket.c:721 [inline]
 __sock_sendmsg net/socket.c:736 [inline]
 ____sys_sendmsg+0x972/0x9f0 net/socket.c:2585
 ___sys_sendmsg+0x2a5/0x360 net/socket.c:2639
 __sys_sendmsg net/socket.c:2671 [inline]
 __do_sys_sendmsg net/socket.c:2676 [inline]
 __se_sys_sendmsg net/socket.c:2674 [inline]
 __x64_sys_sendmsg+0x1bd/0x2a0 net/socket.c:2674
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f1edcf9c819
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f1eddde0028 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007f1edd215fa0 RCX: 00007f1edcf9c819
RDX: 0000000000000090 RSI: 00002000000002c0 RDI: 0000000000000004
RBP: 00007f1edd032c91 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f1edd216038 R14: 00007f1edd215fa0 R15: 00007ffd74c43f58
 </TASK>

Allocated by task 6005:
 kasan_save_stack mm/kasan/common.c:57 [inline]
 kasan_save_track+0x3e/0x80 mm/kasan/common.c:78
 poison_kmalloc_redzone mm/kasan/common.c:398 [inline]
 __kasan_kmalloc+0x93/0xb0 mm/kasan/common.c:415
 kasan_kmalloc include/linux/kasan.h:263 [inline]
 __do_kmalloc_node mm/slub.c:5260 [inline]
 __kmalloc_noprof+0x35c/0x760 mm/slub.c:5272
 kmalloc_noprof include/linux/slab.h:954 [inline]
 kzalloc_noprof include/linux/slab.h:1188 [inline]
 hash_ipport6_add+0xfb6/0x2260 net/netfilter/ipset/ip_set_hash_gen.h:881
 hash_ipport6_uadt+0x85d/0xb20 net/netfilter/ipset/ip_set_hash_ipport.c:351
 call_ad+0x18d/0xb60 net/netfilter/ipset/ip_set_core.c:1751
 ip_set_ad+0x824/0x9d0 net/netfilter/ipset/ip_set_core.c:1841
 nfnetlink_rcv_msg+0xc00/0x12c0 net/netfilter/nfnetlink.c:300
 netlink_rcv_skb+0x232/0x4b0 net/netlink/af_netlink.c:2550
 nfnetlink_rcv+0x2c0/0x27b0 net/netfilter/nfnetlink.c:667
 netlink_unicast_kernel net/netlink/af_netlink.c:1318 [inline]
 netlink_unicast+0x80f/0x9b0 net/netlink/af_netlink.c:1344
 netlink_sendmsg+0x813/0xb40 net/netlink/af_netlink.c:1894
 sock_sendmsg_nosec net/socket.c:721 [inline]
 __sock_sendmsg net/socket.c:736 [inline]
 ____sys_sendmsg+0x972/0x9f0 net/socket.c:2585
 ___sys_sendmsg+0x2a5/0x360 net/socket.c:2639
 __sys_sendmsg net/socket.c:2671 [inline]
 __do_sys_sendmsg net/socket.c:2676 [inline]
 __se_sys_sendmsg net/socket.c:2674 [inline]
 __x64_sys_sendmsg+0x1bd/0x2a0 net/socket.c:2674
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

The buggy address belongs to the object at ffff888110798c00
 which belongs to the cache kmalloc-96 of size 96
The buggy address is located 0 bytes to the right of
 allocated 72-byte region [ffff888110798c00, ffff888110798c48)

The buggy address belongs to the physical page:
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x110798
flags: 0x17ff00000000000(node=0|zone=2|lastcpupid=0x7ff)
page_type: f5(slab)
raw: 017ff00000000000 ffff888100041280 dead000000000100 dead000000000122
raw: 0000000000000000 0000000800200020 00000000f5000000 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 0, migratetype Unmovable, gfp_mask 0xd2cc0(GFP_KERNEL|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 1094, tgid 1094 (kworker/u9:3), ts 19156789334, free_ts 19155777767
 set_page_owner include/linux/page_owner.h:32 [inline]
 post_alloc_hook+0x231/0x280 mm/page_alloc.c:1889
 prep_new_page mm/page_alloc.c:1897 [inline]
 get_page_from_freelist+0x24dc/0x2580 mm/page_alloc.c:3962
 __alloc_frozen_pages_noprof+0x18d/0x380 mm/page_alloc.c:5250
 alloc_slab_page mm/slub.c:3292 [inline]
 allocate_slab+0x77/0x660 mm/slub.c:3481
 new_slab mm/slub.c:3539 [inline]
 refill_objects+0x331/0x3c0 mm/slub.c:7175
 refill_sheaf mm/slub.c:2812 [inline]
 __pcs_replace_empty_main+0x2e6/0x730 mm/slub.c:4615
 alloc_from_pcs mm/slub.c:4717 [inline]
 slab_alloc_node mm/slub.c:4851 [inline]
 __kmalloc_cache_node_noprof+0x465/0x6b0 mm/slub.c:5388
 kmalloc_node_noprof include/linux/slab.h:1077 [inline]
 __get_vm_area_node+0x13f/0x300 mm/vmalloc.c:3221
 __vmalloc_node_range_noprof+0x372/0x1730 mm/vmalloc.c:4024
 __vmalloc_node_noprof+0xc2/0x100 mm/vmalloc.c:4124
 alloc_thread_stack_node kernel/fork.c:355 [inline]
 dup_task_struct+0x275/0x9a0 kernel/fork.c:924
 copy_process+0x508/0x3cd0 kernel/fork.c:2050
 kernel_clone+0x248/0x8e0 kernel/fork.c:2653
 user_mode_thread+0x110/0x180 kernel/fork.c:2729
 call_usermodehelper_exec_work+0x5c/0x230 kernel/umh.c:171
 process_one_work kernel/workqueue.c:3276 [inline]
 process_scheduled_works+0xb6e/0x18c0 kernel/workqueue.c:3359
page last free pid 1094 tgid 1094 stack trace:
 reset_page_owner include/linux/page_owner.h:25 [inline]
 __free_pages_prepare mm/page_alloc.c:1433 [inline]
 __free_frozen_pages+0xc2b/0xdb0 mm/page_alloc.c:2978
 __kasan_populate_vmalloc_do mm/kasan/shadow.c:393 [inline]
 __kasan_populate_vmalloc+0x1b2/0x1d0 mm/kasan/shadow.c:424
 kasan_populate_vmalloc include/linux/kasan.h:580 [inline]
 alloc_vmap_area+0xd73/0x14b0 mm/vmalloc.c:2129
 __get_vm_area_node+0x1f8/0x300 mm/vmalloc.c:3232
 __vmalloc_node_range_noprof+0x372/0x1730 mm/vmalloc.c:4024
 __vmalloc_node_noprof+0xc2/0x100 mm/vmalloc.c:4124
 alloc_thread_stack_node kernel/fork.c:355 [inline]
 dup_task_struct+0x275/0x9a0 kernel/fork.c:924
 copy_process+0x508/0x3cd0 kernel/fork.c:2050
 kernel_clone+0x248/0x8e0 kernel/fork.c:2653
 user_mode_thread+0x110/0x180 kernel/fork.c:2729
 call_usermodehelper_exec_work+0x5c/0x230 kernel/umh.c:171
 process_one_work kernel/workqueue.c:3276 [inline]
 process_scheduled_works+0xb6e/0x18c0 kernel/workqueue.c:3359
 worker_thread+0xa53/0xfc0 kernel/workqueue.c:3440
 kthread+0x388/0x470 kernel/kthread.c:436
 ret_from_fork+0x51e/0xb90 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

Memory state around the buggy address:
 ffff888110798b00: 00 00 00 00 00 00 00 00 00 fc fc fc fc fc fc fc
 ffff888110798b80: 00 00 00 00 00 00 00 00 00 00 00 00 fc fc fc fc
>ffff888110798c00: 00 00 00 00 00 00 00 00 00 fc fc fc fc fc fc fc
                                              ^
 ffff888110798c80: 00 00 00 00 00 00 00 00 00 00 00 00 fc fc fc fc
 ffff888110798d00: 00 00 00 00 00 00 00 00 00 00 00 00 fc fc fc fc
==================================================================


***

KASAN: slab-out-of-bounds Write in hash_ipportnet6_add

tree:      nf-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netfilter/nf-next.git
base:      47117877d5707b32773bb3d5fd8f1f9aaf8f1f3b
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/8ee93551-dc97-4078-8c85-f884da5dc0bf/config
syz repro: https://ci.syzbot.org/findings/9a835a65-c731-420b-98c9-76cbdfe4d5e7/syz_repro

==================================================================
BUG: KASAN: slab-out-of-bounds in hash_ipportnet6_add+0x1eab/0x2ef0 net/netfilter/ipset/ip_set_hash_gen.h:974
Write of size 36 at addr ffff88812055d068 by task syz.0.17/5970

CPU: 0 UID: 0 PID: 5970 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 print_address_description mm/kasan/report.c:378 [inline]
 print_report+0xba/0x230 mm/kasan/report.c:482
 kasan_report+0x117/0x150 mm/kasan/report.c:595
 check_region_inline mm/kasan/generic.c:-1 [inline]
 kasan_check_range+0x264/0x2c0 mm/kasan/generic.c:200
 __asan_memcpy+0x40/0x70 mm/kasan/shadow.c:106
 hash_ipportnet6_add+0x1eab/0x2ef0 net/netfilter/ipset/ip_set_hash_gen.h:974
 hash_ipportnet6_uadt+0xa88/0xe00 net/netfilter/ipset/ip_set_hash_ipportnet.c:504
 call_ad+0x18d/0xb60 net/netfilter/ipset/ip_set_core.c:1751
 ip_set_ad+0x824/0x9d0 net/netfilter/ipset/ip_set_core.c:1841
 nfnetlink_rcv_msg+0xc00/0x12c0 net/netfilter/nfnetlink.c:300
 netlink_rcv_skb+0x232/0x4b0 net/netlink/af_netlink.c:2550
 nfnetlink_rcv+0x2c0/0x27b0 net/netfilter/nfnetlink.c:667
 netlink_unicast_kernel net/netlink/af_netlink.c:1318 [inline]
 netlink_unicast+0x80f/0x9b0 net/netlink/af_netlink.c:1344
 netlink_sendmsg+0x813/0xb40 net/netlink/af_netlink.c:1894
 sock_sendmsg_nosec net/socket.c:721 [inline]
 __sock_sendmsg net/socket.c:736 [inline]
 ____sys_sendmsg+0x972/0x9f0 net/socket.c:2585
 ___sys_sendmsg+0x2a5/0x360 net/socket.c:2639
 __sys_sendmsg net/socket.c:2671 [inline]
 __do_sys_sendmsg net/socket.c:2676 [inline]
 __se_sys_sendmsg net/socket.c:2674 [inline]
 __x64_sys_sendmsg+0x1bd/0x2a0 net/socket.c:2674
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fbe1ad9c819
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fbe1bccc028 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007fbe1b015fa0 RCX: 00007fbe1ad9c819
RDX: 0000000000000000 RSI: 00002000000002c0 RDI: 0000000000000004
RBP: 00007fbe1ae32c91 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fbe1b016038 R14: 00007fbe1b015fa0 R15: 00007ffe829d96c8
 </TASK>

Allocated by task 5970:
 kasan_save_stack mm/kasan/common.c:57 [inline]
 kasan_save_track+0x3e/0x80 mm/kasan/common.c:78
 poison_kmalloc_redzone mm/kasan/common.c:398 [inline]
 __kasan_kmalloc+0x93/0xb0 mm/kasan/common.c:415
 kasan_kmalloc include/linux/kasan.h:263 [inline]
 __do_kmalloc_node mm/slub.c:5260 [inline]
 __kmalloc_noprof+0x35c/0x760 mm/slub.c:5272
 kmalloc_noprof include/linux/slab.h:954 [inline]
 kzalloc_noprof include/linux/slab.h:1188 [inline]
 hash_ipportnet6_add+0x11fe/0x2ef0 net/netfilter/ipset/ip_set_hash_gen.h:881
 hash_ipportnet6_uadt+0xa88/0xe00 net/netfilter/ipset/ip_set_hash_ipportnet.c:504
 call_ad+0x18d/0xb60 net/netfilter/ipset/ip_set_core.c:1751
 ip_set_ad+0x824/0x9d0 net/netfilter/ipset/ip_set_core.c:1841
 nfnetlink_rcv_msg+0xc00/0x12c0 net/netfilter/nfnetlink.c:300
 netlink_rcv_skb+0x232/0x4b0 net/netlink/af_netlink.c:2550
 nfnetlink_rcv+0x2c0/0x27b0 net/netfilter/nfnetlink.c:667
 netlink_unicast_kernel net/netlink/af_netlink.c:1318 [inline]
 netlink_unicast+0x80f/0x9b0 net/netlink/af_netlink.c:1344
 netlink_sendmsg+0x813/0xb40 net/netlink/af_netlink.c:1894
 sock_sendmsg_nosec net/socket.c:721 [inline]
 __sock_sendmsg net/socket.c:736 [inline]
 ____sys_sendmsg+0x972/0x9f0 net/socket.c:2585
 ___sys_sendmsg+0x2a5/0x360 net/socket.c:2639
 __sys_sendmsg net/socket.c:2671 [inline]
 __do_sys_sendmsg net/socket.c:2676 [inline]
 __se_sys_sendmsg net/socket.c:2674 [inline]
 __x64_sys_sendmsg+0x1bd/0x2a0 net/socket.c:2674
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

The buggy address belongs to the object at ffff88812055d000
 which belongs to the cache kmalloc-128 of size 128
The buggy address is located 0 bytes to the right of
 allocated 104-byte region [ffff88812055d000, ffff88812055d068)

The buggy address belongs to the physical page:
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x12055d
flags: 0x17ff00000000000(node=0|zone=2|lastcpupid=0x7ff)
page_type: f5(slab)
raw: 017ff00000000000 ffff888100041a00 dead000000000122 0000000000000000
raw: 0000000000000000 0000000800100010 00000000f5000000 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 0, migratetype Unmovable, gfp_mask 0xd2820(GFP_ATOMIC|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 5970, tgid 5969 (syz.0.17), ts 62254504797, free_ts 59906136451
 set_page_owner include/linux/page_owner.h:32 [inline]
 post_alloc_hook+0x231/0x280 mm/page_alloc.c:1889
 prep_new_page mm/page_alloc.c:1897 [inline]
 get_page_from_freelist+0x24dc/0x2580 mm/page_alloc.c:3962
 __alloc_frozen_pages_noprof+0x18d/0x380 mm/page_alloc.c:5250
 alloc_slab_page mm/slub.c:3292 [inline]
 allocate_slab+0x77/0x660 mm/slub.c:3481
 new_slab mm/slub.c:3539 [inline]
 refill_objects+0x331/0x3c0 mm/slub.c:7175
 refill_sheaf mm/slub.c:2812 [inline]
 __pcs_replace_empty_main+0x2e6/0x730 mm/slub.c:4615
 alloc_from_pcs mm/slub.c:4717 [inline]
 slab_alloc_node mm/slub.c:4851 [inline]
 __do_kmalloc_node mm/slub.c:5259 [inline]
 __kmalloc_noprof+0x474/0x760 mm/slub.c:5272
 kmalloc_noprof include/linux/slab.h:954 [inline]
 kzalloc_noprof include/linux/slab.h:1188 [inline]
 hash_ipportnet6_add+0x11fe/0x2ef0 net/netfilter/ipset/ip_set_hash_gen.h:881
 hash_ipportnet6_uadt+0xa88/0xe00 net/netfilter/ipset/ip_set_hash_ipportnet.c:504
 call_ad+0x18d/0xb60 net/netfilter/ipset/ip_set_core.c:1751
 ip_set_ad+0x824/0x9d0 net/netfilter/ipset/ip_set_core.c:1841
 nfnetlink_rcv_msg+0xc00/0x12c0 net/netfilter/nfnetlink.c:300
 netlink_rcv_skb+0x232/0x4b0 net/netlink/af_netlink.c:2550
 nfnetlink_rcv+0x2c0/0x27b0 net/netfilter/nfnetlink.c:667
 netlink_unicast_kernel net/netlink/af_netlink.c:1318 [inline]
 netlink_unicast+0x80f/0x9b0 net/netlink/af_netlink.c:1344
 netlink_sendmsg+0x813/0xb40 net/netlink/af_netlink.c:1894
page last free pid 5885 tgid 5885 stack trace:
 reset_page_owner include/linux/page_owner.h:25 [inline]
 __free_pages_prepare mm/page_alloc.c:1433 [inline]
 __free_frozen_pages+0xc2b/0xdb0 mm/page_alloc.c:2978
 vfree+0x25a/0x400 mm/vmalloc.c:3479
 kcov_put kernel/kcov.c:442 [inline]
 kcov_close+0x28/0x50 kernel/kcov.c:543
 __fput+0x44f/0xa70 fs/file_table.c:469
 task_work_run+0x1d9/0x270 kernel/task_work.c:233
 exit_task_work include/linux/task_work.h:40 [inline]
 do_exit+0x70f/0x23c0 kernel/exit.c:976
 do_group_exit+0x21b/0x2d0 kernel/exit.c:1118
 get_signal+0x1284/0x1330 kernel/signal.c:3034
 arch_do_signal_or_restart+0xbc/0x830 arch/x86/kernel/signal.c:337
 __exit_to_user_mode_loop kernel/entry/common.c:64 [inline]
 exit_to_user_mode_loop+0x86/0x480 kernel/entry/common.c:98
 __exit_to_user_mode_prepare include/linux/irq-entry-common.h:226 [inline]
 syscall_exit_to_user_mode_prepare include/linux/irq-entry-common.h:256 [inline]
 syscall_exit_to_user_mode include/linux/entry-common.h:325 [inline]
 do_syscall_64+0x32d/0xf80 arch/x86/entry/syscall_64.c:100
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Memory state around the buggy address:
 ffff88812055cf00: 00 00 00 00 00 00 00 00 00 00 00 00 00 fc fc fc
 ffff88812055cf80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>ffff88812055d000: 00 00 00 00 00 00 00 00 00 00 00 00 00 fc fc fc
                                                          ^
 ffff88812055d080: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff88812055d100: 00 00 00 00 00 00 00 00 00 00 00 00 00 fc fc fc
==================================================================


***

KASAN: slab-out-of-bounds Write in hash_netnet4_add

tree:      nf-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netfilter/nf-next.git
base:      47117877d5707b32773bb3d5fd8f1f9aaf8f1f3b
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/8ee93551-dc97-4078-8c85-f884da5dc0bf/config
syz repro: https://ci.syzbot.org/findings/72f192ce-33b7-4dd0-b1e5-1666100981b0/syz_repro

==================================================================
BUG: KASAN: slab-out-of-bounds in hash_netnet4_add+0x1852/0x27d0 net/netfilter/ipset/ip_set_hash_gen.h:974
Write of size 16 at addr ffff8881125a9f40 by task syz.1.18/5970

CPU: 0 UID: 0 PID: 5970 Comm: syz.1.18 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 print_address_description mm/kasan/report.c:378 [inline]
 print_report+0xba/0x230 mm/kasan/report.c:482
 kasan_report+0x117/0x150 mm/kasan/report.c:595
 check_region_inline mm/kasan/generic.c:-1 [inline]
 kasan_check_range+0x264/0x2c0 mm/kasan/generic.c:200
 __asan_memcpy+0x40/0x70 mm/kasan/shadow.c:106
 hash_netnet4_add+0x1852/0x27d0 net/netfilter/ipset/ip_set_hash_gen.h:974
 hash_netnet4_uadt+0xc06/0xf20 net/netfilter/ipset/ip_set_hash_netnet.c:269
 call_ad+0x18d/0xb60 net/netfilter/ipset/ip_set_core.c:1751
 ip_set_ad+0x824/0x9d0 net/netfilter/ipset/ip_set_core.c:1841
 nfnetlink_rcv_msg+0xc00/0x12c0 net/netfilter/nfnetlink.c:300
 netlink_rcv_skb+0x232/0x4b0 net/netlink/af_netlink.c:2550
 nfnetlink_rcv+0x2c0/0x27b0 net/netfilter/nfnetlink.c:667
 netlink_unicast_kernel net/netlink/af_netlink.c:1318 [inline]
 netlink_unicast+0x80f/0x9b0 net/netlink/af_netlink.c:1344
 netlink_sendmsg+0x813/0xb40 net/netlink/af_netlink.c:1894
 sock_sendmsg_nosec net/socket.c:721 [inline]
 __sock_sendmsg net/socket.c:736 [inline]
 ____sys_sendmsg+0x972/0x9f0 net/socket.c:2585
 ___sys_sendmsg+0x2a5/0x360 net/socket.c:2639
 __sys_sendmsg net/socket.c:2671 [inline]
 __do_sys_sendmsg net/socket.c:2676 [inline]
 __se_sys_sendmsg net/socket.c:2674 [inline]
 __x64_sys_sendmsg+0x1bd/0x2a0 net/socket.c:2674
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f23ac39c819
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f23ad2b1028 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007f23ac615fa0 RCX: 00007f23ac39c819
RDX: 0000000000000004 RSI: 00002000000000c0 RDI: 0000000000000003
RBP: 00007f23ac432c91 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f23ac616038 R14: 00007f23ac615fa0 R15: 00007fff91226648
 </TASK>

Allocated by task 5970:
 kasan_save_stack mm/kasan/common.c:57 [inline]
 kasan_save_track+0x3e/0x80 mm/kasan/common.c:78
 poison_kmalloc_redzone mm/kasan/common.c:398 [inline]
 __kasan_kmalloc+0x93/0xb0 mm/kasan/common.c:415
 kasan_kmalloc include/linux/kasan.h:263 [inline]
 __do_kmalloc_node mm/slub.c:5260 [inline]
 __kmalloc_noprof+0x35c/0x760 mm/slub.c:5272
 kmalloc_noprof include/linux/slab.h:954 [inline]
 kzalloc_noprof include/linux/slab.h:1188 [inline]
 hash_netnet4_add+0xe44/0x27d0 net/netfilter/ipset/ip_set_hash_gen.h:881
 hash_netnet4_uadt+0xc06/0xf20 net/netfilter/ipset/ip_set_hash_netnet.c:269
 call_ad+0x18d/0xb60 net/netfilter/ipset/ip_set_core.c:1751
 ip_set_ad+0x824/0x9d0 net/netfilter/ipset/ip_set_core.c:1841
 nfnetlink_rcv_msg+0xc00/0x12c0 net/netfilter/nfnetlink.c:300
 netlink_rcv_skb+0x232/0x4b0 net/netlink/af_netlink.c:2550
 nfnetlink_rcv+0x2c0/0x27b0 net/netfilter/nfnetlink.c:667
 netlink_unicast_kernel net/netlink/af_netlink.c:1318 [inline]
 netlink_unicast+0x80f/0x9b0 net/netlink/af_netlink.c:1344
 netlink_sendmsg+0x813/0xb40 net/netlink/af_netlink.c:1894
 sock_sendmsg_nosec net/socket.c:721 [inline]
 __sock_sendmsg net/socket.c:736 [inline]
 ____sys_sendmsg+0x972/0x9f0 net/socket.c:2585
 ___sys_sendmsg+0x2a5/0x360 net/socket.c:2639
 __sys_sendmsg net/socket.c:2671 [inline]
 __do_sys_sendmsg net/socket.c:2676 [inline]
 __se_sys_sendmsg net/socket.c:2674 [inline]
 __x64_sys_sendmsg+0x1bd/0x2a0 net/socket.c:2674
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

The buggy address belongs to the object at ffff8881125a9f00
 which belongs to the cache kmalloc-64 of size 64
The buggy address is located 0 bytes to the right of
 allocated 64-byte region [ffff8881125a9f00, ffff8881125a9f40)

The buggy address belongs to the physical page:
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x1125a9
flags: 0x17ff00000000000(node=0|zone=2|lastcpupid=0x7ff)
page_type: f5(slab)
raw: 017ff00000000000 ffff8881000418c0 dead000000000100 dead000000000122
raw: 0000000000000000 0000000800200020 00000000f5000000 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 0, migratetype Unmovable, gfp_mask 0xd2cc0(GFP_KERNEL|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 55, tgid 55 (kworker/u9:2), ts 19909977372, free_ts 0
 set_page_owner include/linux/page_owner.h:32 [inline]
 post_alloc_hook+0x231/0x280 mm/page_alloc.c:1889
 prep_new_page mm/page_alloc.c:1897 [inline]
 get_page_from_freelist+0x24dc/0x2580 mm/page_alloc.c:3962
 __alloc_frozen_pages_noprof+0x18d/0x380 mm/page_alloc.c:5250
 alloc_slab_page mm/slub.c:3292 [inline]
 allocate_slab+0x77/0x660 mm/slub.c:3481
 new_slab mm/slub.c:3539 [inline]
 refill_objects+0x331/0x3c0 mm/slub.c:7175
 refill_sheaf mm/slub.c:2812 [inline]
 __pcs_replace_empty_main+0x2e6/0x730 mm/slub.c:4615
 alloc_from_pcs mm/slub.c:4717 [inline]
 slab_alloc_node mm/slub.c:4851 [inline]
 __do_kmalloc_node mm/slub.c:5259 [inline]
 __kmalloc_node_noprof+0x577/0x7c0 mm/slub.c:5266
 kmalloc_node_noprof include/linux/slab.h:1081 [inline]
 __vmalloc_area_node mm/vmalloc.c:3855 [inline]
 __vmalloc_node_range_noprof+0x5d5/0x1730 mm/vmalloc.c:4064
 __vmalloc_node_noprof+0xc2/0x100 mm/vmalloc.c:4124
 alloc_thread_stack_node kernel/fork.c:355 [inline]
 dup_task_struct+0x275/0x9a0 kernel/fork.c:924
 copy_process+0x508/0x3cd0 kernel/fork.c:2050
 kernel_clone+0x248/0x8e0 kernel/fork.c:2653
 user_mode_thread+0x110/0x180 kernel/fork.c:2729
 call_usermodehelper_exec_work+0x5c/0x230 kernel/umh.c:171
 process_one_work kernel/workqueue.c:3276 [inline]
 process_scheduled_works+0xb6e/0x18c0 kernel/workqueue.c:3359
 worker_thread+0xa53/0xfc0 kernel/workqueue.c:3440
page_owner free stack trace missing

Memory state around the buggy address:
 ffff8881125a9e00: 00 00 00 00 00 00 00 00 fc fc fc fc fc fc fc fc
 ffff8881125a9e80: 00 00 00 00 00 00 fc fc fc fc fc fc fc fc fc fc
>ffff8881125a9f00: 00 00 00 00 00 00 00 00 fc fc fc fc fc fc fc fc
                                           ^
 ffff8881125a9f80: 00 00 00 00 00 00 00 00 fc fc fc fc fc fc fc fc
 ffff8881125aa000: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

To test a patch for this bug, please reply with `#syz test`
(should be on a separate line).

The patch should be attached to the email.
Note: arguments like custom git repos and branches are not supported.
