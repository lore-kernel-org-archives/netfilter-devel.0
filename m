Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFC4D32C336
	for <netfilter-devel@vger.kernel.org>; Wed,  3 Sep 2025 17:47:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756921625; cv=none; b=jprXCSq/f8ZkR5p24k3W3e5MYhLv9XQSMdDycgFa8gQfunkt6ThZ2/xCxY8VBUIE78k8B/dH5IBLQLXJ39ooQLQ1XFuSvmqwfWS4/x4sZrUAdmCIPYUSlovV0c2TcJu/t8A9yQ4sfXbmzJNyRHgTlF37Jd1ItP2TKwAlJG+kBL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756921625; c=relaxed/simple;
	bh=TdVE6NuXlt4KLM1ST2Qq7DiBIQrps4g0l1xaUaMNICY=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=Vsp1RukV6YvucsjSBdVyrVNRrlXRXSBlug7KAxXmHcOfVhdPYrRj64B6dEC223F05Ha062m8UZDJrE5xVhuLlYP2R/Ydj4uY++OhIvPImmGaDbknxLaeH8+ZnLiblcQcMg2j8QPICDRsK3iN+GFLtATzxMH6kWRdkGS8s0VO3zA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-3f321907716so15765455ab.0
        for <netfilter-devel@vger.kernel.org>; Wed, 03 Sep 2025 10:47:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756921623; x=1757526423;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LqcMjvd0CpZBWnqhKsVwjjgs+ri8agbdZqsKqlh8gmw=;
        b=TQBYkoBB4rLTS/3UvhE3xIX7h9n4DDRih0+5vJJeKUdGKmqS+isBDsCv8m3sz1+Ccb
         X/uYMqOkbzRReQtcVgaWm+LwAVrR4bwunLfX510c0WGWWUq3MEDfmK8xJRS6J+5srl/4
         dngv3MilyVCm9zQuBMuGo+gZu201u/VJf+jDNwPyMAFhaXznw1ZNxl3b343Am1onSGmO
         0yJb8ibkjpNmjX+FINzkntlwYrug4l7hnpNJq8KtB4JncUOrD5XdreFBI1jAFsEcaYh6
         b+X0qNe6LDJyzGV0Iv2JOVwnD1UfcfUn17iJ9pcOtaZWgwY/1Zt7J7rJUydvBfAlhyEu
         1AEQ==
X-Forwarded-Encrypted: i=1; AJvYcCX1dekSIhJEMYSQgSbtewD/Xl/sRDDsD6duNEEfOewfrZsv5NZKXlrZkGN/9+Fv6LRy87qFAcjFQGdf1mEhB6c=@vger.kernel.org
X-Gm-Message-State: AOJu0YyZSOxxzImtXiK75QWFWbP3aeD2oAodxj57oFpN63QVq+hv64M8
	YOpwekW/GjV+iCB4jqYjMce6z5ogvuiFBDTwJ417Dun2QBtg1b5KkNfFuMP6NsX9666G5pI8+35
	NQ4Yaq85B9m3pb/A46ZrtiY6MUsb2D5pex1dMVbdk6EsnXAADiYQpMxy7/sg=
X-Google-Smtp-Source: AGHT+IGfsN7JS7dAm/WE2FEEXElHpRiHHgQusZpk6EhsbwrrIc7vWFkYDF7NCAJFRI4ROG8pwPr1ATuxr5jT5shl7eiuJdgFZ08r
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:4711:b0:3f6:5b66:b5cd with SMTP id
 e9e14a558f8ab-3f65b66c0b8mr87986645ab.6.1756921622680; Wed, 03 Sep 2025
 10:47:02 -0700 (PDT)
Date: Wed, 03 Sep 2025 10:47:02 -0700
In-Reply-To: <20250902215433.75568-1-nickgarlis@gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68b87f16.050a0220.3db4df.01fc.GAE@google.com>
Subject: [syzbot ci] Re: netfilter: nft_ct: reject ambiguous conntrack
 expressions in inet tables
From: syzbot ci <syzbot+ci86bf0c7d9e28d066@syzkaller.appspotmail.com>
To: fw@strlen.de, netfilter-devel@vger.kernel.org, nickgarlis@gmail.com, 
	pablo@netfilter.org
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v2] netfilter: nft_ct: reject ambiguous conntrack expressions in inet tables
https://lore.kernel.org/all/20250902215433.75568-1-nickgarlis@gmail.com
* [PATCH v2] netfilter: nft_ct: reject ambiguous conntrack expressions in inet tables

and found the following issue:
KASAN: slab-out-of-bounds Write in nft_meta_inner_init

Full report is available here:
https://ci.syzbot.org/series/d9b8905e-8e5d-42de-8b7a-56fc81572df6

***

KASAN: slab-out-of-bounds Write in nft_meta_inner_init

tree:      nf-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netfilter/nf-next.git
base:      864ecc4a6dade82d3f70eab43dad0e277aa6fc78
arch:      amd64
compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
config:    https://ci.syzbot.org/builds/b1146649-3f67-48cb-975c-62829433c8c5/config
C repro:   https://ci.syzbot.org/findings/d1f93a73-6b38-4a3b-9232-e80dea47a810/c_repro
syz repro: https://ci.syzbot.org/findings/d1f93a73-6b38-4a3b-9232-e80dea47a810/syz_repro

==================================================================
BUG: KASAN: slab-out-of-bounds in nft_meta_inner_init+0x1a7/0x1d0 net/netfilter/nft_meta.c:844
Write of size 1 at addr ffff88810d9f5a40 by task syz.0.17/5997

CPU: 1 UID: 0 PID: 5997 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0x189/0x250 lib/dump_stack.c:120
 print_address_description mm/kasan/report.c:378 [inline]
 print_report+0xca/0x240 mm/kasan/report.c:482
 kasan_report+0x118/0x150 mm/kasan/report.c:595
 nft_meta_inner_init+0x1a7/0x1d0 net/netfilter/nft_meta.c:844
 nft_inner_init+0x534/0x630 net/netfilter/nft_inner.c:388
 nf_tables_newexpr net/netfilter/nf_tables_api.c:3513 [inline]
 nf_tables_newrule+0x17b0/0x28a0 net/netfilter/nf_tables_api.c:4346
 nfnetlink_rcv_batch net/netfilter/nfnetlink.c:524 [inline]
 nfnetlink_rcv_skb_batch net/netfilter/nfnetlink.c:647 [inline]
 nfnetlink_rcv+0x1132/0x2520 net/netfilter/nfnetlink.c:665
 netlink_unicast_kernel net/netlink/af_netlink.c:1320 [inline]
 netlink_unicast+0x82f/0x9e0 net/netlink/af_netlink.c:1346
 netlink_sendmsg+0x805/0xb30 net/netlink/af_netlink.c:1896
 sock_sendmsg_nosec net/socket.c:714 [inline]
 __sock_sendmsg+0x21c/0x270 net/socket.c:729
 ____sys_sendmsg+0x505/0x830 net/socket.c:2614
 ___sys_sendmsg+0x21f/0x2a0 net/socket.c:2668
 __sys_sendmsg net/socket.c:2700 [inline]
 __do_sys_sendmsg net/socket.c:2705 [inline]
 __se_sys_sendmsg net/socket.c:2703 [inline]
 __x64_sys_sendmsg+0x19b/0x260 net/socket.c:2703
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f2d6c18ebe9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fff1c4d5e58 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007f2d6c3c5fa0 RCX: 00007f2d6c18ebe9
RDX: 0000000000000000 RSI: 0000200000000000 RDI: 0000000000000003
RBP: 00007f2d6c211e19 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f2d6c3c5fa0 R14: 00007f2d6c3c5fa0 R15: 0000000000000003
 </TASK>

Allocated by task 5997:
 kasan_save_stack mm/kasan/common.c:47 [inline]
 kasan_save_track+0x3e/0x80 mm/kasan/common.c:68
 poison_kmalloc_redzone mm/kasan/common.c:388 [inline]
 __kasan_kmalloc+0x93/0xb0 mm/kasan/common.c:405
 kasan_kmalloc include/linux/kasan.h:260 [inline]
 __do_kmalloc_node mm/slub.c:4365 [inline]
 __kmalloc_noprof+0x27a/0x4f0 mm/slub.c:4377
 kmalloc_noprof include/linux/slab.h:909 [inline]
 kzalloc_noprof include/linux/slab.h:1039 [inline]
 nf_tables_newrule+0x1503/0x28a0 net/netfilter/nf_tables_api.c:4328
 nfnetlink_rcv_batch net/netfilter/nfnetlink.c:524 [inline]
 nfnetlink_rcv_skb_batch net/netfilter/nfnetlink.c:647 [inline]
 nfnetlink_rcv+0x1132/0x2520 net/netfilter/nfnetlink.c:665
 netlink_unicast_kernel net/netlink/af_netlink.c:1320 [inline]
 netlink_unicast+0x82f/0x9e0 net/netlink/af_netlink.c:1346
 netlink_sendmsg+0x805/0xb30 net/netlink/af_netlink.c:1896
 sock_sendmsg_nosec net/socket.c:714 [inline]
 __sock_sendmsg+0x21c/0x270 net/socket.c:729
 ____sys_sendmsg+0x505/0x830 net/socket.c:2614
 ___sys_sendmsg+0x21f/0x2a0 net/socket.c:2668
 __sys_sendmsg net/socket.c:2700 [inline]
 __do_sys_sendmsg net/socket.c:2705 [inline]
 __se_sys_sendmsg net/socket.c:2703 [inline]
 __x64_sys_sendmsg+0x19b/0x260 net/socket.c:2703
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

The buggy address belongs to the object at ffff88810d9f5a00
 which belongs to the cache kmalloc-cg-64 of size 64
The buggy address is located 0 bytes to the right of
 allocated 64-byte region [ffff88810d9f5a00, ffff88810d9f5a40)

The buggy address belongs to the physical page:
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0xffff88810d9f5880 pfn:0x10d9f5
memcg:ffff88810dfc9601
flags: 0x57ff00000000000(node=1|zone=2|lastcpupid=0x7ff)
page_type: f5(slab)
raw: 057ff00000000000 ffff88801a449c80 ffffea0000f4b500 0000000000000002
raw: ffff88810d9f5880 000000008020001e 00000000f5000000 ffff88810dfc9601
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 0, migratetype Unmovable, gfp_mask 0x52cc0(GFP_KERNEL|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP), pid 5917, tgid 5917 (syz-executor), ts 70404800919, free_ts 68893144552
 set_page_owner include/linux/page_owner.h:32 [inline]
 post_alloc_hook+0x240/0x2a0 mm/page_alloc.c:1851
 prep_new_page mm/page_alloc.c:1859 [inline]
 get_page_from_freelist+0x21e4/0x22c0 mm/page_alloc.c:3858
 __alloc_frozen_pages_noprof+0x181/0x370 mm/page_alloc.c:5148
 alloc_pages_mpol+0x232/0x4a0 mm/mempolicy.c:2416
 alloc_slab_page mm/slub.c:2487 [inline]
 allocate_slab+0x8a/0x370 mm/slub.c:2655
 new_slab mm/slub.c:2709 [inline]
 ___slab_alloc+0xbeb/0x1410 mm/slub.c:3891
 __slab_alloc mm/slub.c:3981 [inline]
 __slab_alloc_node mm/slub.c:4056 [inline]
 slab_alloc_node mm/slub.c:4217 [inline]
 __do_kmalloc_node mm/slub.c:4364 [inline]
 __kvmalloc_node_noprof+0x429/0x5f0 mm/slub.c:5052
 alloc_netdev_mqs+0xc7c/0x11b0 net/core/dev.c:11944
 ip6_tnl_init_net+0x104/0x3b0 net/ipv6/ip6_tunnel.c:2292
 ops_init+0x35c/0x5c0 net/core/net_namespace.c:136
 setup_net+0x10c/0x320 net/core/net_namespace.c:438
 copy_net_ns+0x31b/0x4d0 net/core/net_namespace.c:570
 create_new_namespaces+0x3f3/0x720 kernel/nsproxy.c:110
 unshare_nsproxy_namespaces+0x11c/0x170 kernel/nsproxy.c:218
 ksys_unshare+0x4c8/0x8c0 kernel/fork.c:3127
 __do_sys_unshare kernel/fork.c:3198 [inline]
 __se_sys_unshare kernel/fork.c:3196 [inline]
 __x64_sys_unshare+0x38/0x50 kernel/fork.c:3196
page last free pid 976 tgid 976 stack trace:
 reset_page_owner include/linux/page_owner.h:25 [inline]
 free_pages_prepare mm/page_alloc.c:1395 [inline]
 __free_frozen_pages+0xbc4/0xd30 mm/page_alloc.c:2895
 kasan_depopulate_vmalloc_pte+0x74/0xa0 mm/kasan/shadow.c:472
 apply_to_pte_range mm/memory.c:3015 [inline]
 apply_to_pmd_range mm/memory.c:3059 [inline]
 apply_to_pud_range mm/memory.c:3095 [inline]
 apply_to_p4d_range mm/memory.c:3131 [inline]
 __apply_to_page_range+0xb92/0x1380 mm/memory.c:3167
 kasan_release_vmalloc+0xa2/0xd0 mm/kasan/shadow.c:593
 kasan_release_vmalloc_node mm/vmalloc.c:2249 [inline]
 purge_vmap_node+0x214/0x8f0 mm/vmalloc.c:2266
 __purge_vmap_area_lazy+0x7a4/0xb40 mm/vmalloc.c:2356
 drain_vmap_area_work+0x27/0x40 mm/vmalloc.c:2390
 process_one_work kernel/workqueue.c:3236 [inline]
 process_scheduled_works+0xae1/0x17b0 kernel/workqueue.c:3319
 worker_thread+0x8a0/0xda0 kernel/workqueue.c:3400
 kthread+0x711/0x8a0 kernel/kthread.c:463
 ret_from_fork+0x3fc/0x770 arch/x86/kernel/process.c:148
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

Memory state around the buggy address:
 ffff88810d9f5900: 00 00 00 00 00 fc fc fc fc fc fc fc fc fc fc fc
 ffff88810d9f5980: 00 00 00 00 00 00 fc fc fc fc fc fc fc fc fc fc
>ffff88810d9f5a00: 00 00 00 00 00 00 00 00 fc fc fc fc fc fc fc fc
                                           ^
 ffff88810d9f5a80: fa fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
 ffff88810d9f5b00: fa fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
==================================================================


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.
