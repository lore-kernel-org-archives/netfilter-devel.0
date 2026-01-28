Received: from mail-oa1-f78.google.com (mail-oa1-f78.google.com [209.85.160.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F26E92EBBB7
	for <netfilter-devel@vger.kernel.org>; Wed, 28 Jan 2026 12:08:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769602119; cv=none; b=i2PUuA3KpmU3XY603vSQiaZFEPrXpRWbn2p7LbKoXrTMZv0Z1l0tDyl6JAILCS+yMVsFrUXQblsKj1OvLh0DfyFe8S3LpSi9oAhrjk/ZoUAk5umcUeGWQGq2l5ozeABy3oDXUXGKK/fqY5SaVXyYt1uneUa91J/vKxr/UEC0W7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769602119; c=relaxed/simple;
	bh=7VwZat7Tq3BttXUYitDuHuxn9jhmOfLCmPbZkaT0XW4=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=AwxvKCP7qGv6sb0ORqOF1eXaT4dg4R1MbF43c7ATcxg1nsN26TGOpwZHao8ERmPZ70JqF1ypgsxvFkTl/OK2T6FWGqE74URLpz5hMj6VK5B79zU6At3asRfk/2myorTlnOcHNijdytUrd2428RjOjhhCwDNtPwMgq873NbLXTGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.160.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oa1-f78.google.com with SMTP id 586e51a60fabf-4040e71a7f6so11406977fac.3
        for <netfilter-devel@vger.kernel.org>; Wed, 28 Jan 2026 04:08:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769602117; x=1770206917;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DZvZ1q3zktXtDVsrM1xeVm3lnWPTKWIKsoCzATLtuV8=;
        b=inP7/PuHlgC24aqcgJfQU6rHPWGGRRLBjyjwkhR9kN1/y+ZJ1TKU+NYUfIwVKjIHXq
         5iUngD0AekSrxvGOek9jhzP4v/fpfVQMl+c2CyXS3suR1EVOfNOVnltwHh/SDckVesxz
         FwDwUiEO+2/ExtaYFDN6Yqoa6r9H06JhhMtzD81Zqg5or3yAtbUFHDXfYQuFF/kziBpb
         Ws8mVLMJhCXHj7H6nlE6wjlJkQAjy1vdjmXPsARdFH8dXOQ5bGGBfIqwYWBTQC8DHF+o
         fpaSaPsKOHq6RCEwWuwR6QjtFAmAHCSvhDE/ZlrBSVNiiGvtEKeeRmIpQxj/TcceizMg
         QcUw==
X-Forwarded-Encrypted: i=1; AJvYcCVfjF1QbYOcpVVVJV6JZtpoUYcZdRfqkbwgVpeQ63Bzrxz7a8LriLn4j0z2YQmYxYuO7EG2oE4X0CdLC+/SZkQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YyR6q6a5h7CGA4Q3YjzKVwuBrgm8UlB/cYqtmJwCD+E9N1tfnd1
	wCR4LCc9mw5/oo7A6uLwqh1Zk0kQHHBo32W0QxkIWnQ6SsIeO6Y1AosL31dD2hoeUoISELGJ8MB
	kVOqOEDUGGvhDmx4+3MQY64FK2HrBAu1RSrbeDUSXmP1c/BtCIN5kmBHhIxk=
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:2188:b0:663:22b:1486 with SMTP id
 006d021491bc7-663022b2092mr164103eaf.41.1769602116974; Wed, 28 Jan 2026
 04:08:36 -0800 (PST)
Date: Wed, 28 Jan 2026 04:08:36 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6979fc44.050a0220.c9109.003b.GAE@google.com>
Subject: [syzbot] [netfilter?] KASAN: slab-use-after-free Read in nft_array_get_cmp
From: syzbot <syzbot+d417922a3e7935517ef6@syzkaller.appspotmail.com>
To: coreteam@netfilter.org, davem@davemloft.net, edumazet@google.com, 
	fw@strlen.de, horms@kernel.org, kuba@kernel.org, linux-kernel@vger.kernel.org, 
	netdev@vger.kernel.org, netfilter-devel@vger.kernel.org, pabeni@redhat.com, 
	pablo@netfilter.org, phil@nwl.cc, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    62777c8015f3 Merge branch 'net-stmmac-rk-simplify-per-soc-..
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=103e49b2580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=aeae47237b696a30
dashboard link: https://syzkaller.appspot.com/bug?extid=d417922a3e7935517ef6
compiler:       Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15e50160580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=155ce322580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/1eb82c60e767/disk-62777c80.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/e421b2bad029/vmlinux-62777c80.xz
kernel image: https://storage.googleapis.com/syzbot-assets/3bc19b11eaeb/bzImage-62777c80.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+d417922a3e7935517ef6@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: slab-use-after-free in nft_set_ext include/net/netfilter/nf_tables.h:795 [inline]
BUG: KASAN: slab-use-after-free in nft_set_ext_key include/net/netfilter/nf_tables.h:800 [inline]
BUG: KASAN: slab-use-after-free in nft_array_get_cmp+0x1f6/0x2a0 net/netfilter/nft_set_rbtree.c:133
Read of size 1 at addr ffff888058618b19 by task syz.3.79/6217

CPU: 1 UID: 0 PID: 6217 Comm: syz.3.79 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/13/2026
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 print_address_description mm/kasan/report.c:378 [inline]
 print_report+0xba/0x230 mm/kasan/report.c:482
 kasan_report+0x117/0x150 mm/kasan/report.c:595
 nft_set_ext include/net/netfilter/nf_tables.h:795 [inline]
 nft_set_ext_key include/net/netfilter/nf_tables.h:800 [inline]
 nft_array_get_cmp+0x1f6/0x2a0 net/netfilter/nft_set_rbtree.c:133
 __inline_bsearch include/linux/bsearch.h:15 [inline]
 bsearch+0x50/0xc0 lib/bsearch.c:33
 nft_rbtree_get+0x16b/0x400 net/netfilter/nft_set_rbtree.c:169
 nft_setelem_get net/netfilter/nf_tables_api.c:6495 [inline]
 nft_get_set_elem+0x420/0xaa0 net/netfilter/nf_tables_api.c:6543
 nf_tables_getsetelem+0x448/0x5e0 net/netfilter/nf_tables_api.c:6632
 nfnetlink_rcv_msg+0x8ae/0x12c0 net/netfilter/nfnetlink.c:290
 netlink_rcv_skb+0x232/0x4b0 net/netlink/af_netlink.c:2550
 nfnetlink_rcv+0x2c0/0x27b0 net/netfilter/nfnetlink.c:669
 netlink_unicast_kernel net/netlink/af_netlink.c:1318 [inline]
 netlink_unicast+0x80f/0x9b0 net/netlink/af_netlink.c:1344
 netlink_sendmsg+0x813/0xb40 net/netlink/af_netlink.c:1894
 sock_sendmsg_nosec net/socket.c:727 [inline]
 __sock_sendmsg net/socket.c:742 [inline]
 ____sys_sendmsg+0xa68/0xad0 net/socket.c:2592
 ___sys_sendmsg+0x2a5/0x360 net/socket.c:2646
 __sys_sendmsg net/socket.c:2678 [inline]
 __do_sys_sendmsg net/socket.c:2683 [inline]
 __se_sys_sendmsg net/socket.c:2681 [inline]
 __x64_sys_sendmsg+0x1bd/0x2a0 net/socket.c:2681
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xe2/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f58cd79aeb9
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f58ce594028 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007f58cda15fa0 RCX: 00007f58cd79aeb9
RDX: 0000000000008000 RSI: 0000200000000100 RDI: 0000000000000004
RBP: 00007f58cd808c1f R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f58cda16038 R14: 00007f58cda15fa0 R15: 00007ffd3f69bcd8
 </TASK>

Allocated by task 6217:
 kasan_save_stack mm/kasan/common.c:57 [inline]
 kasan_save_track+0x3e/0x80 mm/kasan/common.c:78
 poison_kmalloc_redzone mm/kasan/common.c:398 [inline]
 __kasan_kmalloc+0x93/0xb0 mm/kasan/common.c:415
 kasan_kmalloc include/linux/kasan.h:263 [inline]
 __do_kmalloc_node mm/slub.c:5657 [inline]
 __kmalloc_noprof+0x40c/0x7e0 mm/slub.c:5669
 kmalloc_noprof include/linux/slab.h:961 [inline]
 kzalloc_noprof include/linux/slab.h:1094 [inline]
 nft_set_elem_init+0xa8/0x7e0 net/netfilter/nf_tables_api.c:6811
 nft_add_set_elem net/netfilter/nf_tables_api.c:7547 [inline]
 nf_tables_newsetelem+0x22a4/0x4360 net/netfilter/nf_tables_api.c:7717
 nfnetlink_rcv_batch net/netfilter/nfnetlink.c:526 [inline]
 nfnetlink_rcv_skb_batch net/netfilter/nfnetlink.c:649 [inline]
 nfnetlink_rcv+0x1240/0x27b0 net/netfilter/nfnetlink.c:667
 netlink_unicast_kernel net/netlink/af_netlink.c:1318 [inline]
 netlink_unicast+0x80f/0x9b0 net/netlink/af_netlink.c:1344
 netlink_sendmsg+0x813/0xb40 net/netlink/af_netlink.c:1894
 sock_sendmsg_nosec net/socket.c:727 [inline]
 __sock_sendmsg net/socket.c:742 [inline]
 ____sys_sendmsg+0xa68/0xad0 net/socket.c:2592
 ___sys_sendmsg+0x2a5/0x360 net/socket.c:2646
 __sys_sendmsg net/socket.c:2678 [inline]
 __do_sys_sendmsg net/socket.c:2683 [inline]
 __se_sys_sendmsg net/socket.c:2681 [inline]
 __x64_sys_sendmsg+0x1bd/0x2a0 net/socket.c:2681
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xe2/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Freed by task 5959:
 kasan_save_stack mm/kasan/common.c:57 [inline]
 kasan_save_track+0x3e/0x80 mm/kasan/common.c:78
 kasan_save_free_info+0x46/0x50 mm/kasan/generic.c:584
 poison_slab_object mm/kasan/common.c:253 [inline]
 __kasan_slab_free+0x5c/0x80 mm/kasan/common.c:285
 kasan_slab_free include/linux/kasan.h:235 [inline]
 slab_free_hook mm/slub.c:2540 [inline]
 slab_free mm/slub.c:6674 [inline]
 kfree+0x1be/0x650 mm/slub.c:6882
 nf_tables_set_elem_destroy net/netfilter/nf_tables_api.c:6930 [inline]
 nft_trans_gc_trans_free+0x519/0x6c0 net/netfilter/nf_tables_api.c:10542
 rcu_do_batch kernel/rcu/tree.c:2605 [inline]
 rcu_core+0xc9e/0x1750 kernel/rcu/tree.c:2857
 handle_softirqs+0x22a/0x7c0 kernel/softirq.c:622
 __do_softirq kernel/softirq.c:656 [inline]
 invoke_softirq kernel/softirq.c:496 [inline]
 __irq_exit_rcu+0x5f/0x150 kernel/softirq.c:723
 irq_exit_rcu+0x9/0x30 kernel/softirq.c:739
 instr_sysvec_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1056 [inline]
 sysvec_apic_timer_interrupt+0xa6/0xc0 arch/x86/kernel/apic/apic.c:1056
 asm_sysvec_apic_timer_interrupt+0x1a/0x20 arch/x86/include/asm/idtentry.h:697

The buggy address belongs to the object at ffff888058618b00
 which belongs to the cache kmalloc-cg-64 of size 64
The buggy address is located 25 bytes inside of
 freed 64-byte region [ffff888058618b00, ffff888058618b40)

The buggy address belongs to the physical page:
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0xffff888058618300 pfn:0x58618
memcg:ffff888078dd1a01
flags: 0xfff00000000000(node=0|zone=1|lastcpupid=0x7ff)
page_type: f5(slab)
raw: 00fff00000000000 ffff88813fe2ec80 ffffea0001b2c9c0 dead000000000006
raw: ffff888058618300 000000000020001e 00000000f5000000 ffff888078dd1a01
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 0, migratetype Unmovable, gfp_mask 0x52cc0(GFP_KERNEL|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP), pid 5876, tgid 5876 (syz-executor), ts 78950935067, free_ts 78950359848
 set_page_owner include/linux/page_owner.h:32 [inline]
 post_alloc_hook+0x228/0x280 mm/page_alloc.c:1884
 prep_new_page mm/page_alloc.c:1892 [inline]
 get_page_from_freelist+0x24dc/0x2580 mm/page_alloc.c:3945
 __alloc_frozen_pages_noprof+0x18d/0x380 mm/page_alloc.c:5240
 alloc_pages_mpol+0x232/0x4a0 mm/mempolicy.c:2486
 alloc_slab_page mm/slub.c:3075 [inline]
 allocate_slab+0x86/0x3a0 mm/slub.c:3248
 new_slab mm/slub.c:3302 [inline]
 ___slab_alloc+0xd82/0x1760 mm/slub.c:4656
 __slab_alloc+0x65/0x100 mm/slub.c:4779
 __slab_alloc_node mm/slub.c:4855 [inline]
 slab_alloc_node mm/slub.c:5251 [inline]
 __do_kmalloc_node mm/slub.c:5656 [inline]
 __kvmalloc_node_noprof+0x673/0x8d0 mm/slub.c:7140
 allocate_hook_entries_size net/netfilter/core.c:58 [inline]
 nf_hook_entries_grow+0x288/0x720 net/netfilter/core.c:137
 __nf_register_net_hook+0x2c9/0x930 net/netfilter/core.c:432
 nf_register_net_hook+0xb2/0x190 net/netfilter/core.c:575
 nf_register_net_hooks+0x44/0x1b0 net/netfilter/core.c:591
 ipt_register_table+0x55b/0x7f0 net/ipv4/netfilter/ip_tables.c:1781
 iptable_filter_table_init+0x75/0xb0 net/ipv4/netfilter/iptable_filter.c:49
 xt_find_table_lock+0x30c/0x3e0 net/netfilter/x_tables.c:1260
 xt_request_find_table_lock+0x26/0x100 net/netfilter/x_tables.c:1285
page last free pid 5876 tgid 5876 stack trace:
 reset_page_owner include/linux/page_owner.h:25 [inline]
 free_pages_prepare mm/page_alloc.c:1433 [inline]
 __free_frozen_pages+0xbf8/0xd70 mm/page_alloc.c:2973
 vfree+0x25a/0x400 mm/vmalloc.c:3466
 copy_entries_to_user net/ipv4/netfilter/arp_tables.c:713 [inline]
 get_entries net/ipv4/netfilter/arp_tables.c:867 [inline]
 do_arpt_get_ctl+0xdef/0x1100 net/ipv4/netfilter/arp_tables.c:1461
 nf_getsockopt+0x26e/0x290 net/netfilter/nf_sockopt.c:116
 ip_getsockopt+0x19e/0x230 net/ipv4/ip_sockglue.c:1777
 do_sock_getsockopt+0x2d3/0x3f0 net/socket.c:2383
 __sys_getsockopt net/socket.c:2412 [inline]
 __do_sys_getsockopt net/socket.c:2419 [inline]
 __se_sys_getsockopt net/socket.c:2416 [inline]
 __x64_sys_getsockopt+0x1a4/0x240 net/socket.c:2416
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xe2/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Memory state around the buggy address:
 ffff888058618a00: fa fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
 ffff888058618a80: fa fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
>ffff888058618b00: fa fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
                            ^
 ffff888058618b80: fa fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
 ffff888058618c00: fa fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
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
