Received: from mail-io1-f71.google.com (mail-io1-f71.google.com [209.85.166.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75E8316F8F7
	for <netfilter-devel@vger.kernel.org>; Mon,  1 Jul 2024 20:19:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719865158; cv=none; b=R1pJ4iBCUg2NGIGnAROAs/y7PI3ClO6lyxVOY0M0sltf08li6tDjMNKrrBLdxDS/rOld29i5gAT6kPn4zH+QoBkAGENwRwcmVORI0PLLEMHZP3POJMUn0VU6gQbRKfMz/3UuJ0m6PcrC/zOWM5DHjScn1QvG1J0GnSkvDLDAvTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719865158; c=relaxed/simple;
	bh=wzC07gG7wgjsbKeUdwWk6b8fnX8QNH2n/Oa0DidKyTk=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=MpxpgKsJGek3Ix3pQpPaknRme/01tqH28HzVI5hthtd/wcDlcw54N62+Pk8Fk2Unltok419kVeEu4Fu4K7KA2XXFLDyp7vAn9P2ZFPFXH9FdRX5Yu8r/fjgUlGXF/g7fIgFaESIXfCakd3KkMeXsrZ4MRvHaJsaJGnTMhbB/xUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-7eb01189491so376275439f.1
        for <netfilter-devel@vger.kernel.org>; Mon, 01 Jul 2024 13:19:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719865155; x=1720469955;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=QnwFgeiau++PzEkeYKS8qQW1sii2OS6quBuGfN6xzcg=;
        b=IRK5+xdqxPLI7NlC6I5d7XbSejwnsTSxtwxDyJ4cZnx/OZ5Mc02G4lmc37ZmSEutw8
         nVwLneRIdjwft0ivw0o8X7OgPNQJfsUJ6nyoJC/LpUmxD8zBW1Br3jZ8/mU4dBx5x6Fq
         3dy7wTRwS7c/ZfEBpdelMSN6Qy7i94exsAr0t+RrOrpaIP5C8jcwuC24xhy4DvigAieP
         TGamLjlKWzJoFPtcJF+G8vuxkbbsZQnBCUYSOgdV35cMvuo+qpAN6G/wc77EVu2CX6JQ
         Z8IKlaWY0IzNM78Gt8DeEfysEphWYkSPxGDlO45NPFtW5ktUmEtnawT2OeD0J1dPp9ZA
         wmug==
X-Forwarded-Encrypted: i=1; AJvYcCUt27MrCn/VQt8SJXJsrNQKDtvdw+i2M2XNkgCifh0pnHQkR+APFNRGwfVLZJT8fAjephvxHONRSAflL97Ez46ErbcRR4RDCvXVImFgOrV/
X-Gm-Message-State: AOJu0YzJDkHlovh61QqEGPRxinT19hqV4oAOKqu/dufl5EaMvrWx7zyH
	9vlpDDVIpQqCNCmBxwdnm3xBeVP0OeGrLzodexm/ibevauMpSnNOJ5gVyM/jz3qFrBL7XbkniAw
	0w4qwEzSZoehQnXcwAZEkC1nioa7MtxEXfRf64l+Uoa2aY5wiYlyv8e4=
X-Google-Smtp-Source: AGHT+IHKetGPxxCYE8rvtpi6U6xtcHDLrnyokoD8VeAEbLVeYnAYzONX4NPrf/j0ESisGrBow+MPdi7Stjy07SxYRdln6hUEUE3v
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6602:3415:b0:7f6:2e92:9adc with SMTP id
 ca18e2360f4ac-7f62eea8c9dmr51134339f.4.1719865155651; Mon, 01 Jul 2024
 13:19:15 -0700 (PDT)
Date: Mon, 01 Jul 2024 13:19:15 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000aa1dbb061c354fe6@google.com>
Subject: [syzbot] [netfilter?] KASAN: slab-use-after-free Read in nf_tables_trans_destroy_work
From: syzbot <syzbot+4fd66a69358fc15ae2ad@syzkaller.appspotmail.com>
To: coreteam@netfilter.org, davem@davemloft.net, edumazet@google.com, 
	kadlec@netfilter.org, kuba@kernel.org, linux-kernel@vger.kernel.org, 
	netdev@vger.kernel.org, netfilter-devel@vger.kernel.org, pabeni@redhat.com, 
	pablo@netfilter.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    1c5fc27bc48a Merge tag 'nf-next-24-06-28' of git://git.ker..
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=103b1da9980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=5264b58fdff6e881
dashboard link: https://syzkaller.appspot.com/bug?extid=4fd66a69358fc15ae2ad
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=148791c6980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12cecb1e980000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/9672225af907/disk-1c5fc27b.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/0f14d163a914/vmlinux-1c5fc27b.xz
kernel image: https://storage.googleapis.com/syzbot-assets/ec6c331e6a6e/bzImage-1c5fc27b.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+4fd66a69358fc15ae2ad@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: slab-use-after-free in nft_ctx_update include/net/netfilter/nf_tables.h:1831 [inline]
BUG: KASAN: slab-use-after-free in nft_commit_release net/netfilter/nf_tables_api.c:9530 [inline]
BUG: KASAN: slab-use-after-free in nf_tables_trans_destroy_work+0x152b/0x1750 net/netfilter/nf_tables_api.c:9597
Read of size 2 at addr ffff88802b0051c4 by task kworker/1:1/45

CPU: 1 PID: 45 Comm: kworker/1:1 Not tainted 6.10.0-rc5-syzkaller-01137-g1c5fc27bc48a #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 06/07/2024
Workqueue: events nf_tables_trans_destroy_work
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0x241/0x360 lib/dump_stack.c:114
 print_address_description mm/kasan/report.c:377 [inline]
 print_report+0x169/0x550 mm/kasan/report.c:488
 kasan_report+0x143/0x180 mm/kasan/report.c:601
 nft_ctx_update include/net/netfilter/nf_tables.h:1831 [inline]
 nft_commit_release net/netfilter/nf_tables_api.c:9530 [inline]
 nf_tables_trans_destroy_work+0x152b/0x1750 net/netfilter/nf_tables_api.c:9597
 process_one_work kernel/workqueue.c:3248 [inline]
 process_scheduled_works+0xa2c/0x1830 kernel/workqueue.c:3329
 worker_thread+0x86d/0xd50 kernel/workqueue.c:3409
 kthread+0x2f0/0x390 kernel/kthread.c:389
 ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
 </TASK>

Allocated by task 6682:
 kasan_save_stack mm/kasan/common.c:47 [inline]
 kasan_save_track+0x3f/0x80 mm/kasan/common.c:68
 poison_kmalloc_redzone mm/kasan/common.c:370 [inline]
 __kasan_kmalloc+0x98/0xb0 mm/kasan/common.c:387
 kasan_kmalloc include/linux/kasan.h:211 [inline]
 kmalloc_trace_noprof+0x19c/0x2c0 mm/slub.c:4154
 kmalloc_noprof include/linux/slab.h:660 [inline]
 kzalloc_noprof include/linux/slab.h:778 [inline]
 nf_tables_newtable+0x52e/0x1dc0 net/netfilter/nf_tables_api.c:1465
 nfnetlink_rcv_batch net/netfilter/nfnetlink.c:522 [inline]
 nfnetlink_rcv_skb_batch net/netfilter/nfnetlink.c:644 [inline]
 nfnetlink_rcv+0x1427/0x2a90 net/netfilter/nfnetlink.c:662
 netlink_unicast_kernel net/netlink/af_netlink.c:1331 [inline]
 netlink_unicast+0x7f0/0x990 net/netlink/af_netlink.c:1357
 netlink_sendmsg+0x8e4/0xcb0 net/netlink/af_netlink.c:1901
 sock_sendmsg_nosec net/socket.c:730 [inline]
 __sock_sendmsg+0x221/0x270 net/socket.c:745
 ____sys_sendmsg+0x525/0x7d0 net/socket.c:2585
 ___sys_sendmsg net/socket.c:2639 [inline]
 __sys_sendmsg+0x2b0/0x3a0 net/socket.c:2668
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Freed by task 6682:
 kasan_save_stack mm/kasan/common.c:47 [inline]
 kasan_save_track+0x3f/0x80 mm/kasan/common.c:68
 kasan_save_free_info+0x40/0x50 mm/kasan/generic.c:579
 poison_slab_object+0xe0/0x150 mm/kasan/common.c:240
 __kasan_slab_free+0x37/0x60 mm/kasan/common.c:256
 kasan_slab_free include/linux/kasan.h:184 [inline]
 slab_free_hook mm/slub.c:2196 [inline]
 slab_free mm/slub.c:4438 [inline]
 kfree+0x149/0x360 mm/slub.c:4559
 nf_tables_table_destroy net/netfilter/nf_tables_api.c:1672 [inline]
 __nft_release_table+0xe80/0xf40 net/netfilter/nf_tables_api.c:11517
 nft_rcv_nl_event+0x55f/0x6d0 net/netfilter/nf_tables_api.c:11576
 notifier_call_chain+0x19f/0x3e0 kernel/notifier.c:93
 blocking_notifier_call_chain+0x69/0x90 kernel/notifier.c:388
 netlink_release+0x11a6/0x1b10 net/netlink/af_netlink.c:787
 __sock_release net/socket.c:659 [inline]
 sock_close+0xbc/0x240 net/socket.c:1421
 __fput+0x406/0x8b0 fs/file_table.c:422
 task_work_run+0x24f/0x310 kernel/task_work.c:180
 exit_task_work include/linux/task_work.h:38 [inline]
 do_exit+0xa27/0x27e0 kernel/exit.c:874
 do_group_exit+0x207/0x2c0 kernel/exit.c:1023
 __do_sys_exit_group kernel/exit.c:1034 [inline]
 __se_sys_exit_group kernel/exit.c:1032 [inline]
 __x64_sys_exit_group+0x3f/0x40 kernel/exit.c:1032
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Last potentially related work creation:
 kasan_save_stack+0x3f/0x60 mm/kasan/common.c:47
 __kasan_record_aux_stack+0xac/0xc0 mm/kasan/generic.c:541
 insert_work+0x3e/0x330 kernel/workqueue.c:2208
 __queue_work+0xc16/0xee0 kernel/workqueue.c:2360
 queue_work_on+0x1c2/0x380 kernel/workqueue.c:2411
 queue_work include/linux/workqueue.h:621 [inline]
 schedule_work include/linux/workqueue.h:682 [inline]
 __rhashtable_remove_fast_one include/linux/rhashtable.h:1069 [inline]
 __rhashtable_remove_fast include/linux/rhashtable.h:1093 [inline]
 rhltable_remove+0x1097/0x1160 include/linux/rhashtable.h:1144
 nft_chain_del net/netfilter/nf_tables_api.c:9781 [inline]
 __nft_release_table+0xc57/0xf40 net/netfilter/nf_tables_api.c:11513
 nft_rcv_nl_event+0x55f/0x6d0 net/netfilter/nf_tables_api.c:11576
 notifier_call_chain+0x19f/0x3e0 kernel/notifier.c:93
 blocking_notifier_call_chain+0x69/0x90 kernel/notifier.c:388
 netlink_release+0x11a6/0x1b10 net/netlink/af_netlink.c:787
 __sock_release net/socket.c:659 [inline]
 sock_close+0xbc/0x240 net/socket.c:1421
 __fput+0x406/0x8b0 fs/file_table.c:422
 task_work_run+0x24f/0x310 kernel/task_work.c:180
 exit_task_work include/linux/task_work.h:38 [inline]
 do_exit+0xa27/0x27e0 kernel/exit.c:874
 do_group_exit+0x207/0x2c0 kernel/exit.c:1023
 __do_sys_exit_group kernel/exit.c:1034 [inline]
 __se_sys_exit_group kernel/exit.c:1032 [inline]
 __x64_sys_exit_group+0x3f/0x40 kernel/exit.c:1032
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

The buggy address belongs to the object at ffff88802b005000
 which belongs to the cache kmalloc-cg-512 of size 512
The buggy address is located 452 bytes inside of
 freed 512-byte region [ffff88802b005000, ffff88802b005200)

The buggy address belongs to the physical page:
page: refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x2b004
head: order:2 mapcount:0 entire_mapcount:0 nr_pages_mapped:0 pincount:0
flags: 0xfff00000000040(head|node=0|zone=1|lastcpupid=0x7ff)
page_type: 0xffffefff(slab)
raw: 00fff00000000040 ffff88801504f140 ffffea0000b63700 0000000000000002
raw: 0000000000000000 0000000080100010 00000001ffffefff 0000000000000000
head: 00fff00000000040 ffff88801504f140 ffffea0000b63700 0000000000000002
head: 0000000000000000 0000000080100010 00000001ffffefff 0000000000000000
head: 00fff00000000002 ffffea0000ac0101 ffffffffffffffff 0000000000000000
head: 0000000000000004 0000000000000000 00000000ffffffff 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 2, migratetype Unmovable, gfp_mask 0xd20c0(__GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 4764, tgid 4764 (dhcpcd), ts 34584428687, free_ts 34557820760
 set_page_owner include/linux/page_owner.h:32 [inline]
 post_alloc_hook+0x1f3/0x230 mm/page_alloc.c:1473
 prep_new_page mm/page_alloc.c:1481 [inline]
 get_page_from_freelist+0x2e4c/0x2f10 mm/page_alloc.c:3425
 __alloc_pages_noprof+0x256/0x6c0 mm/page_alloc.c:4683
 __alloc_pages_node_noprof include/linux/gfp.h:269 [inline]
 alloc_pages_node_noprof include/linux/gfp.h:296 [inline]
 alloc_slab_page+0x5f/0x120 mm/slub.c:2265
 allocate_slab+0x5a/0x2f0 mm/slub.c:2428
 new_slab mm/slub.c:2481 [inline]
 ___slab_alloc+0xcd1/0x14b0 mm/slub.c:3667
 __slab_alloc+0x58/0xa0 mm/slub.c:3757
 __slab_alloc_node mm/slub.c:3810 [inline]
 slab_alloc_node mm/slub.c:3990 [inline]
 __do_kmalloc_node mm/slub.c:4122 [inline]
 kmalloc_node_track_caller_noprof+0x281/0x440 mm/slub.c:4143
 kmalloc_reserve+0x111/0x2a0 net/core/skbuff.c:605
 __alloc_skb+0x1f3/0x440 net/core/skbuff.c:674
 alloc_skb include/linux/skbuff.h:1320 [inline]
 alloc_skb_with_frags+0xc3/0x770 net/core/skbuff.c:6524
 sock_alloc_send_pskb+0x91a/0xa60 net/core/sock.c:2815
 unix_dgram_sendmsg+0x6d3/0x1f80 net/unix/af_unix.c:2030
 sock_sendmsg_nosec net/socket.c:730 [inline]
 __sock_sendmsg+0x221/0x270 net/socket.c:745
 __sys_sendto+0x3a4/0x4f0 net/socket.c:2192
 __do_sys_sendto net/socket.c:2204 [inline]
 __se_sys_sendto net/socket.c:2200 [inline]
 __x64_sys_sendto+0xde/0x100 net/socket.c:2200
page last free pid 4764 tgid 4764 stack trace:
 reset_page_owner include/linux/page_owner.h:25 [inline]
 free_pages_prepare mm/page_alloc.c:1093 [inline]
 free_unref_page+0xd22/0xea0 mm/page_alloc.c:2588
 stack_depot_save_flags+0x6f6/0x830 lib/stackdepot.c:666
 kasan_save_stack mm/kasan/common.c:48 [inline]
 kasan_save_track+0x51/0x80 mm/kasan/common.c:68
 unpoison_slab_object mm/kasan/common.c:312 [inline]
 __kasan_slab_alloc+0x66/0x80 mm/kasan/common.c:338
 kasan_slab_alloc include/linux/kasan.h:201 [inline]
 slab_post_alloc_hook mm/slub.c:3940 [inline]
 slab_alloc_node mm/slub.c:4002 [inline]
 kmem_cache_alloc_node_noprof+0x16b/0x320 mm/slub.c:4045
 kmalloc_reserve+0xa8/0x2a0 net/core/skbuff.c:583
 __alloc_skb+0x1f3/0x440 net/core/skbuff.c:674
 alloc_skb include/linux/skbuff.h:1320 [inline]
 __ip6_append_data+0x2ba6/0x4070 net/ipv6/ip6_output.c:1648
 ip6_append_data+0x264/0x3a0 net/ipv6/ip6_output.c:1835
 rawv6_sendmsg+0x18f1/0x23c0 net/ipv6/raw.c:919
 sock_sendmsg_nosec net/socket.c:730 [inline]
 __sock_sendmsg+0x1a6/0x270 net/socket.c:745
 ____sys_sendmsg+0x525/0x7d0 net/socket.c:2585
 ___sys_sendmsg net/socket.c:2639 [inline]
 __sys_sendmsg+0x2b0/0x3a0 net/socket.c:2668
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Memory state around the buggy address:
 ffff88802b005080: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff88802b005100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>ffff88802b005180: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                           ^
 ffff88802b005200: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff88802b005280: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
==================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.

If the report is already addressed, let syzbot know by replying with:
#syz fix: exact-commit-title

If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.

If you want to overwrite report's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the report is a duplicate of another one, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup
