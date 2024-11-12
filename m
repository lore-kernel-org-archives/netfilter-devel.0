Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 192F5207A04
	for <netfilter-devel@vger.kernel.org>; Tue, 12 Nov 2024 03:25:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731381930; cv=none; b=jddxOTXW72hM1Qqbqi5PwUGXOp+rRCmlkmbN3fgeCz3O95FSgBfdpw7piLg6z+cGHSfu5pmlDOzC7lnEoUw2jIABii9zGPhnvuw+VpWUeUFMRbwoL6eZTw+sfjeooVptv7GSPW1BKl41SlKnTxjzzJjRH+NDlwW4Cn8f2M+2XWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731381930; c=relaxed/simple;
	bh=v60/XNeGJ6P6Q9dHy2KAuX8dUztDvX4+YttrMJndQZc=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=SRJPZ0IoWnveBX5RATLhuKcB6cGaXa68C3Ebuq7TDhh4jqnvZ8b/t5gbqdZndCxh28KmD+VQsP2WMxjgvYnIWHX44Pz85hppQOo7B+vPSerExoOto/CtEwjmfzrpKD6n/eEdTfYbG6Okv+6j+otWU/hOUbHO4zPZtuxc+m6tcm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-3a4f2698c76so62771475ab.2
        for <netfilter-devel@vger.kernel.org>; Mon, 11 Nov 2024 19:25:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731381928; x=1731986728;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BMWwpOnmmD03l1SYt6YYnqs/QyDCcSmQTZKHU1UsmQ0=;
        b=jVZWFUSu0FINgZTP95wDpO5btmZwxpxFG3OMa+Iki1IQAnVgbJJCBd/pgY3xLVKoUa
         coE2ACct7vP5XMUWEjwiX4ruOi1zKw8FQEezSFdqHEd079Rf1B/XTXomTTt7EE4984pW
         GavYME5y/GHYOIhrz+VrPENReUCrhvw/LDn8TkQLrW9wxytDLPrXIU4aK4L42Vv7pVHZ
         ZxJUZkGWkfQ74ILO40XPg/MnRbTKNSBJg+KrcISRES4gId1MEg9undC9H3IdZ9T7STOx
         uBowlFB91EtA3UqsWnZSC6RW63Q4KKPRHAV2erCkb4wPNq+q4n4EcXjNATWQb5HWs18+
         Ff7g==
X-Forwarded-Encrypted: i=1; AJvYcCXJUq/yGq4dK92IlrTYb4wlK5C7UwMQ3bEAG4GwqZBA2s2d/CcsJar/qRV5DEyPcpjNO8D8mUY5k7kdo0PF5zQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YyJYKn4bVMqoZbinPvT8rn3pp9tTZaxgN/3xvFpYDs9MgKKbzm5
	4A8EEACyj48/hk3OAty7DOb3PmlKpo4tzeFbGdFWepx1Z+7sa8o9X/Bay6w7M7WpNtDANuG5jxr
	XsPQ85u6BuzgxixuScFujrwpxI6TzlUNU0ow7wTnNQPi20Xx8Zrzmeis=
X-Google-Smtp-Source: AGHT+IHqC3Y4V8pOfSLs+aT8dqzIB5kUI2G+LdJX9AsiK2bl2Ahg/tKFCvqZ8oR2uNovEd2uFAZafqCxU2cpsoUChmgK2tuHl4u+
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:180c:b0:3a6:ad61:7ffc with SMTP id
 e9e14a558f8ab-3a6f1a6441amr177202635ab.17.1731381928186; Mon, 11 Nov 2024
 19:25:28 -0800 (PST)
Date: Mon, 11 Nov 2024 19:25:28 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6732caa8.050a0220.138bd5.00cf.GAE@google.com>
Subject: [syzbot] [netfilter?] KASAN: slab-out-of-bounds Read in bitmap_ip_add (2)
From: syzbot <syzbot+58c872f7790a4d2ac951@syzkaller.appspotmail.com>
To: coreteam@netfilter.org, davem@davemloft.net, edumazet@google.com, 
	horms@kernel.org, kadlec@netfilter.org, kuba@kernel.org, 
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org, 
	netfilter-devel@vger.kernel.org, pabeni@redhat.com, pablo@netfilter.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    906bd684e4b1 Merge tag 'spi-fix-v6.12-rc6' of git://git.ke..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1068035f980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=64aa0d9945bd5c1
dashboard link: https://syzkaller.appspot.com/bug?extid=58c872f7790a4d2ac951
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1468035f980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=105b6e30580000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7feb34a89c2a/non_bootable_disk-906bd684.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/88c5c4ba7e33/vmlinux-906bd684.xz
kernel image: https://storage.googleapis.com/syzbot-assets/07094e69f47b/bzImage-906bd684.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+58c872f7790a4d2ac951@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: slab-out-of-bounds in instrument_atomic_read include/linux/instrumented.h:68 [inline]
BUG: KASAN: slab-out-of-bounds in _test_bit include/asm-generic/bitops/instrumented-non-atomic.h:141 [inline]
BUG: KASAN: slab-out-of-bounds in bitmap_ip_do_add net/netfilter/ipset/ip_set_bitmap_ip.c:83 [inline]
BUG: KASAN: slab-out-of-bounds in bitmap_ip_add+0xdf/0x8d0 net/netfilter/ipset/ip_set_bitmap_gen.h:136
Read of size 8 at addr ffff888032b3df08 by task syz-executor701/5308

CPU: 0 UID: 0 PID: 5308 Comm: syz-executor701 Not tainted 6.12.0-rc6-syzkaller-00169-g906bd684e4b1 #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x241/0x360 lib/dump_stack.c:120
 print_address_description mm/kasan/report.c:377 [inline]
 print_report+0x169/0x550 mm/kasan/report.c:488
 kasan_report+0x143/0x180 mm/kasan/report.c:601
 kasan_check_range+0x282/0x290 mm/kasan/generic.c:189
 instrument_atomic_read include/linux/instrumented.h:68 [inline]
 _test_bit include/asm-generic/bitops/instrumented-non-atomic.h:141 [inline]
 bitmap_ip_do_add net/netfilter/ipset/ip_set_bitmap_ip.c:83 [inline]
 bitmap_ip_add+0xdf/0x8d0 net/netfilter/ipset/ip_set_bitmap_gen.h:136
 bitmap_ip_uadt+0x78a/0xbb0 net/netfilter/ipset/ip_set_bitmap_ip.c:186
 call_ad+0x279/0xa70 net/netfilter/ipset/ip_set_core.c:1746
 ip_set_ad+0x7e0/0x990 net/netfilter/ipset/ip_set_core.c:1836
 nfnetlink_rcv_msg+0xbec/0x1180 net/netfilter/nfnetlink.c:302
 netlink_rcv_skb+0x1e3/0x430 net/netlink/af_netlink.c:2551
 nfnetlink_rcv+0x297/0x2ab0 net/netfilter/nfnetlink.c:667
 netlink_unicast_kernel net/netlink/af_netlink.c:1331 [inline]
 netlink_unicast+0x7f6/0x990 net/netlink/af_netlink.c:1357
 netlink_sendmsg+0x8e4/0xcb0 net/netlink/af_netlink.c:1901
 sock_sendmsg_nosec net/socket.c:729 [inline]
 __sock_sendmsg+0x221/0x270 net/socket.c:744
 ____sys_sendmsg+0x52a/0x7e0 net/socket.c:2607
 ___sys_sendmsg net/socket.c:2661 [inline]
 __sys_sendmsg+0x292/0x380 net/socket.c:2690
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fa0f44fcdf9
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 c1 17 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffe08129638 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007fa0f44fcdf9
RDX: 0000000004000050 RSI: 0000000020000000 RDI: 0000000000000004
RBP: 0000000000003a28 R08: 0000000000000006 R09: 0000000000000006
R10: 0000000000000006 R11: 0000000000000246 R12: 0000000000000001
R13: 431bde82d7b634db R14: 0000000000000001 R15: 0000000000000001
 </TASK>

Allocated by task 5308:
 kasan_save_stack mm/kasan/common.c:47 [inline]
 kasan_save_track+0x3f/0x80 mm/kasan/common.c:68
 poison_kmalloc_redzone mm/kasan/common.c:377 [inline]
 __kasan_kmalloc+0x98/0xb0 mm/kasan/common.c:394
 kasan_kmalloc include/linux/kasan.h:257 [inline]
 __do_kmalloc_node mm/slub.c:4264 [inline]
 __kmalloc_noprof+0x1fc/0x400 mm/slub.c:4276
 init_map_ip net/netfilter/ipset/ip_set_bitmap_ip.c:223 [inline]
 bitmap_ip_create+0x565/0xc00 net/netfilter/ipset/ip_set_bitmap_ip.c:327
 ip_set_create+0xa5c/0x1900 net/netfilter/ipset/ip_set_core.c:1104
 nfnetlink_rcv_msg+0xbec/0x1180 net/netfilter/nfnetlink.c:302
 netlink_rcv_skb+0x1e3/0x430 net/netlink/af_netlink.c:2551
 nfnetlink_rcv+0x297/0x2ab0 net/netfilter/nfnetlink.c:667
 netlink_unicast_kernel net/netlink/af_netlink.c:1331 [inline]
 netlink_unicast+0x7f6/0x990 net/netlink/af_netlink.c:1357
 netlink_sendmsg+0x8e4/0xcb0 net/netlink/af_netlink.c:1901
 sock_sendmsg_nosec net/socket.c:729 [inline]
 __sock_sendmsg+0x221/0x270 net/socket.c:744
 ____sys_sendmsg+0x52a/0x7e0 net/socket.c:2607
 ___sys_sendmsg net/socket.c:2661 [inline]
 __sys_sendmsg+0x292/0x380 net/socket.c:2690
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

The buggy address belongs to the object at ffff888032b3df00
 which belongs to the cache kmalloc-8 of size 8
The buggy address is located 0 bytes to the right of
 allocated 8-byte region [ffff888032b3df00, ffff888032b3df08)

The buggy address belongs to the physical page:
page: refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x32b3d
anon flags: 0x4fff00000000000(node=1|zone=1|lastcpupid=0x7ff)
page_type: f5(slab)
raw: 04fff00000000000 ffff88801ac41500 0000000000000000 dead000000000001
raw: 0000000000000000 0000000080800080 00000001f5000000 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 0, migratetype Unmovable, gfp_mask 0x52cc0(GFP_KERNEL|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP), pid 1, tgid 1 (swapper/0), ts 3971426165, free_ts 0
 set_page_owner include/linux/page_owner.h:32 [inline]
 post_alloc_hook+0x1f3/0x230 mm/page_alloc.c:1537
 prep_new_page mm/page_alloc.c:1545 [inline]
 get_page_from_freelist+0x303f/0x3190 mm/page_alloc.c:3457
 __alloc_pages_noprof+0x292/0x710 mm/page_alloc.c:4733
 alloc_pages_mpol_noprof+0x3e8/0x680 mm/mempolicy.c:2265
 alloc_slab_page+0x6a/0x140 mm/slub.c:2412
 allocate_slab+0x5a/0x2f0 mm/slub.c:2578
 new_slab mm/slub.c:2631 [inline]
 ___slab_alloc+0xcd1/0x14b0 mm/slub.c:3818
 __slab_alloc+0x58/0xa0 mm/slub.c:3908
 __slab_alloc_node mm/slub.c:3961 [inline]
 slab_alloc_node mm/slub.c:4122 [inline]
 __do_kmalloc_node mm/slub.c:4263 [inline]
 __kmalloc_noprof+0x25a/0x400 mm/slub.c:4276
 kmalloc_noprof include/linux/slab.h:882 [inline]
 kzalloc_noprof include/linux/slab.h:1014 [inline]
 acpi_ns_internalize_name+0x419/0x610 drivers/acpi/acpica/nsutils.c:331
 acpi_ns_get_node_unlocked drivers/acpi/acpica/nsutils.c:666 [inline]
 acpi_ns_get_node+0x1b7/0x3c0 drivers/acpi/acpica/nsutils.c:726
 acpi_ns_evaluate+0x35f/0xa40 drivers/acpi/acpica/nseval.c:62
 acpi_evaluate_object+0x59b/0xaf0 drivers/acpi/acpica/nsxfeval.c:354
 acpi_evaluate_dsm drivers/acpi/utils.c:798 [inline]
 acpi_check_dsm+0x296/0x850 drivers/acpi/utils.c:831
 device_has_acpi_name drivers/pci/pci-label.c:44 [inline]
 acpi_attr_is_visible+0x8b/0xf0 drivers/pci/pci-label.c:221
 create_files fs/sysfs/group.c:65 [inline]
 internal_create_group+0x714/0x11d0 fs/sysfs/group.c:180
page_owner free stack trace missing

Memory state around the buggy address:
 ffff888032b3de00: 00 fc fc fc fa fc fc fc fa fc fc fc fa fc fc fc
 ffff888032b3de80: 07 fc fc fc 07 fc fc fc fa fc fc fc 00 fc fc fc
>ffff888032b3df00: 00 fc fc fc fa fc fc fc 00 fc fc fc 00 fc fc fc
                      ^
 ffff888032b3df80: 00 fc fc fc 06 fc fc fc 06 fc fc fc 04 fc fc fc
 ffff888032b3e000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
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
