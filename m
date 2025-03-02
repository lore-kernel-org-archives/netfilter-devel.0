Received: from mail-io1-f78.google.com (mail-io1-f78.google.com [209.85.166.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 169051DB546
	for <netfilter-devel@vger.kernel.org>; Sun,  2 Mar 2025 11:57:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740916649; cv=none; b=LRzaWc1wFz4pf1TujWl1mtrUC1Vn/uMa1pj7p+8r/cWBDGhmb1dbv9buukj5iAIWbA8q91C0t47RHbqXc0gktD/ACaZN3Aui5g2U4pPduUVNF82KMoB5sGzapAWkfuzCR/HqPjrjtUR+Rv+1tYGSspQhJ3k3d+Wnz+eOj3E5g40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740916649; c=relaxed/simple;
	bh=/beikVxTu1NGcAZWXy1YUVqubTtwr3l5ZFU1MMVz0HU=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=h2SS9Bc/ArJJhaMeDquEGOQ9zo9SSOLgvHDJ5AFPfkMmwYHq+NcI6rV7+DsZRovZ5ojIBeRrX18fHz0AEDRiyEQJ0QmfHjq2NVTRtcesQlvID3xDS2YjiaHA5UXaLBnEm1SjfOg91hwVtggussYQ7NIDHu0nPurWoghwU35lePM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f78.google.com with SMTP id ca18e2360f4ac-85ad875acccso32577639f.3
        for <netfilter-devel@vger.kernel.org>; Sun, 02 Mar 2025 03:57:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740916647; x=1741521447;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=RF2w+Q4mJTL2WE4yO3ADOwLLA0YdZZYeo6J9OV011m4=;
        b=prvxP7jt84dNY5D4KITskMtuZBuoyIcqwL4KTRaD5WfYXytTXiKU0z+ss8bNT2ItXt
         AYZlUf3eZu5JsqlFnQaxO4sOlLad+dCgPkDvXigIl9f8cfQ1sqnrgP3W/zT/PtPJMnTm
         2nomPY1o5f1IN2/1gvaHR0xgGTCWhehwErvOCvC1rw2N4P5koFe1u8oAsXh5o31HpQbh
         5xlpmQmLfboHXFsk1nxzzPJanH4vx1yHgRusLQCREGaJrZdmkaaHE0acn+Y7pIltGtH2
         t9BlIuVSmHRo5YZ3+RnLKV7h6td/UeCKMDMazNlofzZ0pVwM6BShmL4YnEEsBJnK4sd6
         aluw==
X-Forwarded-Encrypted: i=1; AJvYcCUNfOQECxp58D1BDFRzBgBHgx/fRjhnVNoGVC+453ixWZULUL25wSnp1egTwFvK53a6zjcgUwmfspt3/1FYkQw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw2zEY8JGlu2lMVLSf1wpR10PFS8GHtA6RQyj/TciTCsLQe1seP
	3XjF5oIP5e5aHHQEqxC2/XkerF122/LYh2Wijqigx9D/GhK3o412AjAY/i+NGfyTTZPQNVuhmNA
	OAzY8P3aIqU1jM5lGiYZ0RyZ/Enidw93I2dKnPsgeCGMb85o/rpq+Zls=
X-Google-Smtp-Source: AGHT+IHtYNK+aHOtVvS2PMxS++2fmFsaYh7hMzNNVRvfXIcsU7VxICWixVW7OMwrlWq9D8PAmY4EyIrxOVH1MVjAV9TWV9ORPzgP
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:12ce:b0:3d3:d483:9079 with SMTP id
 e9e14a558f8ab-3d3e6f9b143mr108651345ab.18.1740916647203; Sun, 02 Mar 2025
 03:57:27 -0800 (PST)
Date: Sun, 02 Mar 2025 03:57:27 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67c447a7.050a0220.55417.04d3.GAE@google.com>
Subject: [syzbot] [netfilter?] KASAN: slab-use-after-free Read in
 nf_tables_trans_destroy_work (2)
From: syzbot <syzbot+5d8c5789c8cb076b2c25@syzkaller.appspotmail.com>
To: coreteam@netfilter.org, davem@davemloft.net, edumazet@google.com, 
	horms@kernel.org, kadlec@netfilter.org, kuba@kernel.org, 
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org, 
	netfilter-devel@vger.kernel.org, pabeni@redhat.com, pablo@netfilter.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    03d38806a902 Merge tag 'thermal-6.14-rc5' of git://git.ker..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=115128b7980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=8f2f8fb6ad08b539
dashboard link: https://syzkaller.appspot.com/bug?extid=5d8c5789c8cb076b2c25
compiler:       gcc (Debian 12.2.0-14) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=155128b7980000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7feb34a89c2a/non_bootable_disk-03d38806.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/1d06fe5cd112/vmlinux-03d38806.xz
kernel image: https://storage.googleapis.com/syzbot-assets/1615b4c586c7/bzImage-03d38806.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+5d8c5789c8cb076b2c25@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: slab-use-after-free in nft_ctx_update include/net/netfilter/nf_tables.h:1861 [inline]
BUG: KASAN: slab-use-after-free in nft_commit_release net/netfilter/nf_tables_api.c:9958 [inline]
BUG: KASAN: slab-use-after-free in nf_tables_trans_destroy_work+0x9af/0xae0 net/netfilter/nf_tables_api.c:10023
Read of size 2 at addr ffff88804ee0e9c4 by task kworker/0:3/6521

CPU: 0 UID: 0 PID: 6521 Comm: kworker/0:3 Not tainted 6.14.0-rc4-syzkaller-00248-g03d38806a902 #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
Workqueue: events nf_tables_trans_destroy_work
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x116/0x1f0 lib/dump_stack.c:120
 print_address_description mm/kasan/report.c:408 [inline]
 print_report+0xc3/0x670 mm/kasan/report.c:521
 kasan_report+0xd9/0x110 mm/kasan/report.c:634
 nft_ctx_update include/net/netfilter/nf_tables.h:1861 [inline]
 nft_commit_release net/netfilter/nf_tables_api.c:9958 [inline]
 nf_tables_trans_destroy_work+0x9af/0xae0 net/netfilter/nf_tables_api.c:10023
 process_one_work+0x9c5/0x1ba0 kernel/workqueue.c:3238
 process_scheduled_works kernel/workqueue.c:3319 [inline]
 worker_thread+0x6c8/0xf00 kernel/workqueue.c:3400
 kthread+0x3af/0x750 kernel/kthread.c:464
 ret_from_fork+0x45/0x80 arch/x86/kernel/process.c:148
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
 </TASK>

Allocated by task 14088:
 kasan_save_stack+0x33/0x60 mm/kasan/common.c:47
 kasan_save_track+0x14/0x30 mm/kasan/common.c:68
 poison_kmalloc_redzone mm/kasan/common.c:377 [inline]
 __kasan_kmalloc+0xaa/0xb0 mm/kasan/common.c:394
 kmalloc_noprof include/linux/slab.h:901 [inline]
 kzalloc_noprof include/linux/slab.h:1037 [inline]
 nf_tables_newtable+0xd79/0x1b40 net/netfilter/nf_tables_api.c:1574
 nfnetlink_rcv_batch+0x1a2a/0x24e0 net/netfilter/nfnetlink.c:524
 nfnetlink_rcv_skb_batch net/netfilter/nfnetlink.c:647 [inline]
 nfnetlink_rcv+0x3c3/0x430 net/netfilter/nfnetlink.c:665
 netlink_unicast_kernel net/netlink/af_netlink.c:1312 [inline]
 netlink_unicast+0x53c/0x7f0 net/netlink/af_netlink.c:1338
 netlink_sendmsg+0x8b8/0xd70 net/netlink/af_netlink.c:1882
 sock_sendmsg_nosec net/socket.c:718 [inline]
 __sock_sendmsg net/socket.c:733 [inline]
 ____sys_sendmsg+0xaaf/0xc90 net/socket.c:2573
 ___sys_sendmsg+0x135/0x1e0 net/socket.c:2627
 __sys_sendmsg+0x16e/0x220 net/socket.c:2659
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xcd/0x250 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Freed by task 14086:
 kasan_save_stack+0x33/0x60 mm/kasan/common.c:47
 kasan_save_track+0x14/0x30 mm/kasan/common.c:68
 kasan_save_free_info+0x3b/0x60 mm/kasan/generic.c:576
 poison_slab_object mm/kasan/common.c:247 [inline]
 __kasan_slab_free+0x51/0x70 mm/kasan/common.c:264
 kasan_slab_free include/linux/kasan.h:233 [inline]
 slab_free_hook mm/slub.c:2353 [inline]
 slab_free mm/slub.c:4609 [inline]
 kfree+0x2c4/0x4d0 mm/slub.c:4757
 nf_tables_table_destroy+0xb3/0xf0 net/netfilter/nf_tables_api.c:1781
 __nft_release_table+0xf8b/0x13d0 net/netfilter/nf_tables_api.c:11818
 nft_rcv_nl_event+0x4c9/0x6b0 net/netfilter/nf_tables_api.c:11876
 notifier_call_chain+0xb7/0x410 kernel/notifier.c:85
 blocking_notifier_call_chain kernel/notifier.c:380 [inline]
 blocking_notifier_call_chain+0x69/0xa0 kernel/notifier.c:368
 netlink_release+0x1838/0x1fe0 net/netlink/af_netlink.c:764
 __sock_release+0xb0/0x270 net/socket.c:647
 sock_close+0x1c/0x30 net/socket.c:1398
 __fput+0x3ff/0xb70 fs/file_table.c:464
 task_work_run+0x14e/0x250 kernel/task_work.c:227
 resume_user_mode_work include/linux/resume_user_mode.h:50 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:114 [inline]
 exit_to_user_mode_prepare include/linux/entry-common.h:329 [inline]
 __syscall_exit_to_user_mode_work kernel/entry/common.c:207 [inline]
 syscall_exit_to_user_mode+0x27b/0x2a0 kernel/entry/common.c:218
 do_syscall_64+0xda/0x250 arch/x86/entry/common.c:89
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Last potentially related work creation:
 kasan_save_stack+0x33/0x60 mm/kasan/common.c:47
 kasan_record_aux_stack+0xb8/0xd0 mm/kasan/generic.c:548
 insert_work+0x36/0x230 kernel/workqueue.c:2183
 __queue_work+0x97e/0x10f0 kernel/workqueue.c:2341
 queue_work_on+0x11a/0x140 kernel/workqueue.c:2392
 queue_work include/linux/workqueue.h:662 [inline]
 schedule_work include/linux/workqueue.h:723 [inline]
 __rhashtable_remove_fast_one include/linux/rhashtable.h:1069 [inline]
 __rhashtable_remove_fast.constprop.0.isra.0+0xed7/0x12b0 include/linux/rhashtable.h:1093
 rhltable_remove include/linux/rhashtable.h:1144 [inline]
 nft_chain_del+0x57/0x1a0 net/netfilter/nf_tables_api.c:10207
 __nft_release_table+0xf0e/0x13d0 net/netfilter/nf_tables_api.c:11814
 nft_rcv_nl_event+0x4c9/0x6b0 net/netfilter/nf_tables_api.c:11876
 notifier_call_chain+0xb7/0x410 kernel/notifier.c:85
 blocking_notifier_call_chain kernel/notifier.c:380 [inline]
 blocking_notifier_call_chain+0x69/0xa0 kernel/notifier.c:368
 netlink_release+0x1838/0x1fe0 net/netlink/af_netlink.c:764
 __sock_release+0xb0/0x270 net/socket.c:647
 sock_close+0x1c/0x30 net/socket.c:1398
 __fput+0x3ff/0xb70 fs/file_table.c:464
 task_work_run+0x14e/0x250 kernel/task_work.c:227
 resume_user_mode_work include/linux/resume_user_mode.h:50 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:114 [inline]
 exit_to_user_mode_prepare include/linux/entry-common.h:329 [inline]
 __syscall_exit_to_user_mode_work kernel/entry/common.c:207 [inline]
 syscall_exit_to_user_mode+0x27b/0x2a0 kernel/entry/common.c:218
 do_syscall_64+0xda/0x250 arch/x86/entry/common.c:89
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

The buggy address belongs to the object at ffff88804ee0e800
 which belongs to the cache kmalloc-cg-512 of size 512
The buggy address is located 452 bytes inside of
 freed 512-byte region [ffff88804ee0e800, ffff88804ee0ea00)

The buggy address belongs to the physical page:
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x4ee0c
head: order:2 mapcount:0 entire_mapcount:0 nr_pages_mapped:0 pincount:0
memcg:ffff8880280fae01
flags: 0xfff00000000040(head|node=0|zone=1|lastcpupid=0x7ff)
page_type: f5(slab)
raw: 00fff00000000040 ffff88801b04de00 dead000000000122 0000000000000000
raw: 0000000000000000 0000000080100010 00000000f5000000 ffff8880280fae01
head: 00fff00000000040 ffff88801b04de00 dead000000000122 0000000000000000
head: 0000000000000000 0000000080100010 00000000f5000000 ffff8880280fae01
head: 00fff00000000002 ffffea00013b8301 ffffffffffffffff 0000000000000000
head: 0000000000000004 0000000000000000 00000000ffffffff 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 2, migratetype Unmovable, gfp_mask 0xd20c0(__GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 5653, tgid 5653 (dhcpcd), ts 208176970817, free_ts 208162705163
 set_page_owner include/linux/page_owner.h:32 [inline]
 post_alloc_hook+0x181/0x1b0 mm/page_alloc.c:1551
 prep_new_page mm/page_alloc.c:1559 [inline]
 get_page_from_freelist+0xfce/0x2f80 mm/page_alloc.c:3477
 __alloc_frozen_pages_noprof+0x221/0x2470 mm/page_alloc.c:4739
 alloc_pages_mpol+0x1fc/0x540 mm/mempolicy.c:2270
 alloc_slab_page mm/slub.c:2423 [inline]
 allocate_slab mm/slub.c:2587 [inline]
 new_slab+0x23d/0x330 mm/slub.c:2640
 ___slab_alloc+0xc5d/0x1720 mm/slub.c:3826
 __slab_alloc.constprop.0+0x56/0xb0 mm/slub.c:3916
 __slab_alloc_node mm/slub.c:3991 [inline]
 slab_alloc_node mm/slub.c:4152 [inline]
 __do_kmalloc_node mm/slub.c:4293 [inline]
 __kmalloc_node_track_caller_noprof+0x2f1/0x510 mm/slub.c:4313
 kmalloc_reserve+0xef/0x2c0 net/core/skbuff.c:537
 __alloc_skb+0x164/0x380 net/core/skbuff.c:606
 alloc_skb include/linux/skbuff.h:1331 [inline]
 alloc_skb_with_frags+0xe4/0x850 net/core/skbuff.c:6522
 sock_alloc_send_pskb+0x7f1/0x980 net/core/sock.c:2914
 unix_dgram_sendmsg+0x45e/0x1880 net/unix/af_unix.c:2017
 sock_sendmsg_nosec net/socket.c:718 [inline]
 __sock_sendmsg net/socket.c:733 [inline]
 sock_write_iter+0x4fe/0x5b0 net/socket.c:1137
 new_sync_write fs/read_write.c:586 [inline]
 vfs_write+0x5ae/0x1150 fs/read_write.c:679
 ksys_write+0x207/0x250 fs/read_write.c:731
page last free pid 14050 tgid 14050 stack trace:
 reset_page_owner include/linux/page_owner.h:25 [inline]
 free_pages_prepare mm/page_alloc.c:1127 [inline]
 free_frozen_pages+0x6db/0xfb0 mm/page_alloc.c:2660
 __put_partials+0x14c/0x170 mm/slub.c:3153
 qlink_free mm/kasan/quarantine.c:163 [inline]
 qlist_free_all+0x4e/0x120 mm/kasan/quarantine.c:179
 kasan_quarantine_reduce+0x195/0x1e0 mm/kasan/quarantine.c:286
 __kasan_slab_alloc+0x69/0x90 mm/kasan/common.c:329
 kasan_slab_alloc include/linux/kasan.h:250 [inline]
 slab_post_alloc_hook mm/slub.c:4115 [inline]
 slab_alloc_node mm/slub.c:4164 [inline]
 kmem_cache_alloc_noprof+0x226/0x3d0 mm/slub.c:4171
 ptlock_alloc+0x1f/0x70 mm/memory.c:7055
 ptlock_init include/linux/mm.h:2972 [inline]
 pagetable_pte_ctor include/linux/mm.h:3020 [inline]
 __pte_alloc_one_noprof include/asm-generic/pgalloc.h:73 [inline]
 pte_alloc_one+0x74/0x390 arch/x86/mm/pgtable.c:44
 do_fault_around mm/memory.c:5355 [inline]
 do_read_fault mm/memory.c:5394 [inline]
 do_fault mm/memory.c:5537 [inline]
 do_pte_missing+0x1aff/0x3e10 mm/memory.c:4058
 handle_pte_fault mm/memory.c:5900 [inline]
 __handle_mm_fault+0x1166/0x2c60 mm/memory.c:6043
 handle_mm_fault+0x3fa/0xaa0 mm/memory.c:6212
 do_user_addr_fault+0x60d/0x13f0 arch/x86/mm/fault.c:1337
 handle_page_fault arch/x86/mm/fault.c:1480 [inline]
 exc_page_fault+0x5c/0xc0 arch/x86/mm/fault.c:1538
 asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:623

Memory state around the buggy address:
 ffff88804ee0e880: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff88804ee0e900: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>ffff88804ee0e980: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                           ^
 ffff88804ee0ea00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff88804ee0ea80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
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
