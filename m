Received: from mail-il1-f206.google.com (mail-il1-f206.google.com [209.85.166.206])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40655221F04
	for <netfilter-devel@vger.kernel.org>; Fri, 18 Jul 2025 09:34:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.206
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752831300; cv=none; b=f2xkoMrnFQr1xX7xSWGnnwxhPgWJPaXcxDjGrW26hBew+pmnjYuzyh+59EW6I6EywnGvDB1A93bt14xCOPf6EhXxYxGUkg4Fubu2/uMuPevPMqex83pcS5S2BvprFDQApLTp6ZrqvBoB9irPHcix280vOcbsQHm9HoZnbtcEhj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752831300; c=relaxed/simple;
	bh=oJPNvUEXdxCTEiTHsIL00kvucGoxpvtYlL1SfUh7O64=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=qZtYHlb9TwAtkwjDtbMb42t0/2MUcNJzhRcDJ3od0ifaSI5ZcL+HkJlJJo8I62ChsQr0MO0kMB8QTgjJSYOi/GKd9XLyS72I0sZ37b5zYJcxAaJ6Mr+6g0XbYmojlbGct4PcVvw9oi9SyT6TzMiNj35Qw7VWLHGDbsEraFVcmHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.206
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f206.google.com with SMTP id e9e14a558f8ab-3df33827a8cso32171945ab.1
        for <netfilter-devel@vger.kernel.org>; Fri, 18 Jul 2025 02:34:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752831297; x=1753436097;
        h=content-transfer-encoding:cc:to:from:subject:message-id:in-reply-to
         :date:mime-version:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gO9o/XxraTkT/9LIwD/pek5Hnwy9BztHyrfR/OPQXjE=;
        b=ZSsWX14qRzVySxoN6/jbAIpWP+aegUETvNWXRDclTOHwSRQKvKRglxLrazW0J32GCD
         0yqg9dhEQRs6BJCRIeuzVjl3inpGhiko5fzdITOLPAb4umQS0YD1zed685hjvkfe9A5T
         0J5JQunRMfnQ2KESIHE5FrXtO9olBD84tBmWbN/F7FkmcB9qCHhTQFTRsXNGWFbtkOfT
         JTJPrdUfT0aIsmHmoidJv9jkT5PTTFJepLz1s+nvmx/B8nTQFT0gmkgetsOvwFWQiBCz
         c10nWubCayIwJ1zAalxuLkBC7qvQEfXUfL/959uUQXl2f0O/5cQoY9d8uymXDooVMAa6
         /0lg==
X-Forwarded-Encrypted: i=1; AJvYcCXOpGLbKXMgYVQdJYS8lSjjAxJbZdQZICQ3EoggS34spNDcB08kKZzw9912MijYCNMpxQLJUUAZIgTG8Ei516E=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz0aho1LUbq9SGUyOMv7eyPp5WOf/Z8yfNGSszYqtDvNT9DIvEB
	VfZRdyFMJoU2VilYkNqF+sfoEpoZIdnG8useccyKqTk2LM4gHdfUqQZj4XAhE1Wr4mKo/a8N+SS
	MUc85yV0wMQl9z9bTRIn+lC07PbqofXDiOq2AMAd6wKWBGsJmc7JKvGExx4U=
X-Google-Smtp-Source: AGHT+IGtPlpwQ2r8/YVYVukRZN/tbtDovLy9KxRauxmGhRQl7yNQDy9W+EZDJxzPYjZIMaKKHrZrxJ3gloWPM/kvhLB+dDeRvDhs
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:330a:b0:3df:3ee6:6973 with SMTP id
 e9e14a558f8ab-3e282d629demr108063155ab.1.1752831297323; Fri, 18 Jul 2025
 02:34:57 -0700 (PDT)
Date: Fri, 18 Jul 2025 02:34:57 -0700
In-Reply-To: <CANp29Y4Y=az02pTZpCRVbz-d2v3cebwfm6V_MitKWgeZxxZwwQ@mail.gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <687a1541.a00a0220.3af5df.0026.GAE@google.com>
Subject: Re: [syzbot] [netfilter?] KASAN: slab-out-of-bounds Read in nfacct_mt_checkentry
From: syzbot <syzbot+4ff165b9251e4d295690@syzkaller.appspotmail.com>
To: nogikh@google.com
Cc: coreteam@netfilter.org, davem@davemloft.net, edumazet@google.com, 
	fw@strlen.de, horms@kernel.org, kadlec@netfilter.org, kuba@kernel.org, 
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org, 
	netfilter-devel@vger.kernel.org, nogikh@google.com, pabeni@redhat.com, 
	pablo@netfilter.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

> #syz upstream

Can't upstream, this is final destination.

>
> On Fri, Jul 18, 2025 at 3:06=E2=80=AFAM syzbot
> <syzbot+4ff165b9251e4d295690@syzkaller.appspotmail.com> wrote:
>>
>> Hello,
>>
>> syzbot found the following issue on:
>>
>> HEAD commit:    5d5d62298b8b Merge tag 'x86_urgent_for_v6.16_rc6' of git=
:/..
>> git tree:       upstream
>> console+strace: https://syzkaller.appspot.com/x/log.txt?x=3D1655418c5800=
00
>> kernel config:  https://syzkaller.appspot.com/x/.config?x=3Db309c907eaab=
29da
>> dashboard link: https://syzkaller.appspot.com/bug?extid=3D4ff165b9251e4d=
295690
>> compiler:       Debian clang version 20.1.7 (++20250616065708+6146a88f60=
49-1~exp1~20250616065826.132), Debian LLD 20.1.7
>> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=3D156787d458=
0000
>> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=3D136787d45800=
00
>>
>> Downloadable assets:
>> disk image: https://storage.googleapis.com/syzbot-assets/621a2e2bbe6e/di=
sk-5d5d6229.raw.xz
>> vmlinux: https://storage.googleapis.com/syzbot-assets/1822022cd8cb/vmlin=
ux-5d5d6229.xz
>> kernel image: https://storage.googleapis.com/syzbot-assets/10cee653a6cd/=
bzImage-5d5d6229.xz
>>
>> The issue was bisected to:
>>
>> commit 6001a930ce0378b62210d4f83583fc88a903d89d
>> Author: Pablo Neira Ayuso <pablo@netfilter.org>
>> Date:   Mon Feb 15 11:28:07 2021 +0000
>>
>>     netfilter: nftables: introduce table ownership
>>
>> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=3D133e518c5=
80000
>> final oops:     https://syzkaller.appspot.com/x/report.txt?x=3D10be518c5=
80000
>> console output: https://syzkaller.appspot.com/x/log.txt?x=3D173e518c5800=
00
>>
>> IMPORTANT: if you fix the issue, please add the following tag to the com=
mit:
>> Reported-by: syzbot+4ff165b9251e4d295690@syzkaller.appspotmail.com
>> Fixes: 6001a930ce03 ("netfilter: nftables: introduce table ownership")
>>
>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>> BUG: KASAN: slab-out-of-bounds in string_nocheck lib/vsprintf.c:639 [inl=
ine]
>> BUG: KASAN: slab-out-of-bounds in string+0x231/0x2b0 lib/vsprintf.c:721
>> Read of size 1 at addr ffff88801eac95c8 by task syz-executor183/5851
>>
>> CPU: 0 UID: 0 PID: 5851 Comm: syz-executor183 Not tainted 6.16.0-rc5-syz=
kaller-00276-g5d5d62298b8b #0 PREEMPT(full)
>> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS =
Google 05/07/2025
>> Call Trace:
>>  <TASK>
>>  dump_stack_lvl+0x189/0x250 lib/dump_stack.c:120
>>  print_address_description mm/kasan/report.c:378 [inline]
>>  print_report+0xca/0x230 mm/kasan/report.c:480
>>  kasan_report+0x118/0x150 mm/kasan/report.c:593
>>  string_nocheck lib/vsprintf.c:639 [inline]
>>  string+0x231/0x2b0 lib/vsprintf.c:721
>>  vsnprintf+0x739/0xf00 lib/vsprintf.c:2874
>>  vprintk_store+0x3c7/0xd00 kernel/printk/printk.c:2279
>>  vprintk_emit+0x21e/0x7a0 kernel/printk/printk.c:2426
>>  _printk+0xcf/0x120 kernel/printk/printk.c:2475
>>  nfacct_mt_checkentry+0xd2/0xe0 net/netfilter/xt_nfacct.c:41
>>  xt_check_match+0x3d1/0xab0 net/netfilter/x_tables.c:523
>>  __nft_match_init+0x63a/0x840 net/netfilter/nft_compat.c:520
>>  nf_tables_newexpr net/netfilter/nf_tables_api.c:3493 [inline]
>>  nf_tables_newrule+0x178c/0x2890 net/netfilter/nf_tables_api.c:4324
>>  nfnetlink_rcv_batch net/netfilter/nfnetlink.c:525 [inline]
>>  nfnetlink_rcv_skb_batch net/netfilter/nfnetlink.c:648 [inline]
>>  nfnetlink_rcv+0x1132/0x2520 net/netfilter/nfnetlink.c:666
>>  netlink_unicast_kernel net/netlink/af_netlink.c:1320 [inline]
>>  netlink_unicast+0x759/0x8e0 net/netlink/af_netlink.c:1346
>>  netlink_sendmsg+0x805/0xb30 net/netlink/af_netlink.c:1896
>>  sock_sendmsg_nosec net/socket.c:712 [inline]
>>  __sock_sendmsg+0x219/0x270 net/socket.c:727
>>  ____sys_sendmsg+0x505/0x830 net/socket.c:2566
>>  ___sys_sendmsg+0x21f/0x2a0 net/socket.c:2620
>>  __sys_sendmsg net/socket.c:2652 [inline]
>>  __do_sys_sendmsg net/socket.c:2657 [inline]
>>  __se_sys_sendmsg net/socket.c:2655 [inline]
>>  __x64_sys_sendmsg+0x19b/0x260 net/socket.c:2655
>>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>>  do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
>>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>> RIP: 0033:0x7fa7bbf1c6a9
>> Code: 48 83 c4 28 c3 e8 37 17 00 00 0f 1f 80 00 00 00 00 48 89 f8 48 89 =
f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 f=
f ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
>> RSP: 002b:00007fff7139c908 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
>> RAX: ffffffffffffffda RBX: 00007fff7139cad8 RCX: 00007fa7bbf1c6a9
>> RDX: 0000000000000000 RSI: 0000200000000000 RDI: 0000000000000003
>> RBP: 00007fa7bbf8f610 R08: 0000000000000002 R09: 00007fff7139cad8
>> R10: 0000000000000009 R11: 0000000000000246 R12: 0000000000000001
>> R13: 00007fff7139cac8 R14: 0000000000000001 R15: 0000000000000001
>>  </TASK>
>>
>> Allocated by task 5851:
>>  kasan_save_stack mm/kasan/common.c:47 [inline]
>>  kasan_save_track+0x3e/0x80 mm/kasan/common.c:68
>>  poison_kmalloc_redzone mm/kasan/common.c:377 [inline]
>>  __kasan_kmalloc+0x93/0xb0 mm/kasan/common.c:394
>>  kasan_kmalloc include/linux/kasan.h:260 [inline]
>>  __do_kmalloc_node mm/slub.c:4328 [inline]
>>  __kmalloc_noprof+0x27a/0x4f0 mm/slub.c:4340
>>  kmalloc_noprof include/linux/slab.h:909 [inline]
>>  kzalloc_noprof include/linux/slab.h:1039 [inline]
>>  nf_tables_newrule+0x1506/0x2890 net/netfilter/nf_tables_api.c:4306
>>  nfnetlink_rcv_batch net/netfilter/nfnetlink.c:525 [inline]
>>  nfnetlink_rcv_skb_batch net/netfilter/nfnetlink.c:648 [inline]
>>  nfnetlink_rcv+0x1132/0x2520 net/netfilter/nfnetlink.c:666
>>  netlink_unicast_kernel net/netlink/af_netlink.c:1320 [inline]
>>  netlink_unicast+0x759/0x8e0 net/netlink/af_netlink.c:1346
>>  netlink_sendmsg+0x805/0xb30 net/netlink/af_netlink.c:1896
>>  sock_sendmsg_nosec net/socket.c:712 [inline]
>>  __sock_sendmsg+0x219/0x270 net/socket.c:727
>>  ____sys_sendmsg+0x505/0x830 net/socket.c:2566
>>  ___sys_sendmsg+0x21f/0x2a0 net/socket.c:2620
>>  __sys_sendmsg net/socket.c:2652 [inline]
>>  __do_sys_sendmsg net/socket.c:2657 [inline]
>>  __se_sys_sendmsg net/socket.c:2655 [inline]
>>  __x64_sys_sendmsg+0x19b/0x260 net/socket.c:2655
>>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>>  do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
>>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>>
>> The buggy address belongs to the object at ffff88801eac9580
>>  which belongs to the cache kmalloc-cg-96 of size 96
>> The buggy address is located 0 bytes to the right of
>>  allocated 72-byte region [ffff88801eac9580, ffff88801eac95c8)
>>
>> The buggy address belongs to the physical page:
>> page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x1ea=
c9
>> flags: 0xfff00000000000(node=3D0|zone=3D1|lastcpupid=3D0x7ff)
>> page_type: f5(slab)
>> raw: 00fff00000000000 ffff88801a449640 dead000000000122 0000000000000000
>> raw: 0000000000000000 0000000080200020 00000000f5000000 0000000000000000
>> page dumped because: kasan: bad access detected
>> page_owner tracks the page as allocated
>> page last allocated via order 0, migratetype Unmovable, gfp_mask 0x52cc0=
(GFP_KERNEL|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP), pid 1, tgid 1 (swapper/=
0), ts 2776913905, free_ts 0
>>  set_page_owner include/linux/page_owner.h:32 [inline]
>>  post_alloc_hook+0x240/0x2a0 mm/page_alloc.c:1704
>>  prep_new_page mm/page_alloc.c:1712 [inline]
>>  get_page_from_freelist+0x21e4/0x22c0 mm/page_alloc.c:3669
>>  __alloc_frozen_pages_noprof+0x181/0x370 mm/page_alloc.c:4959
>>  alloc_pages_mpol+0x232/0x4a0 mm/mempolicy.c:2419
>>  alloc_slab_page mm/slub.c:2451 [inline]
>>  allocate_slab+0x8a/0x3b0 mm/slub.c:2619
>>  new_slab mm/slub.c:2673 [inline]
>>  ___slab_alloc+0xbfc/0x1480 mm/slub.c:3859
>>  __slab_alloc mm/slub.c:3949 [inline]
>>  __slab_alloc_node mm/slub.c:4024 [inline]
>>  slab_alloc_node mm/slub.c:4185 [inline]
>>  __do_kmalloc_node mm/slub.c:4327 [inline]
>>  __kmalloc_noprof+0x305/0x4f0 mm/slub.c:4340
>>  kmalloc_noprof include/linux/slab.h:909 [inline]
>>  kzalloc_noprof include/linux/slab.h:1039 [inline]
>>  __register_sysctl_table+0x72/0x1340 fs/proc/proc_sysctl.c:1380
>>  user_namespace_sysctl_init+0x25/0x150 kernel/ucount.c:355
>>  do_one_initcall+0x233/0x820 init/main.c:1274
>>  do_initcall_level+0x137/0x1f0 init/main.c:1336
>>  do_initcalls+0x69/0xd0 init/main.c:1352
>>  kernel_init_freeable+0x3d9/0x570 init/main.c:1584
>>  kernel_init+0x1d/0x1d0 init/main.c:1474
>>  ret_from_fork+0x3fc/0x770 arch/x86/kernel/process.c:148
>>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
>> page_owner free stack trace missing
>>
>> Memory state around the buggy address:
>>  ffff88801eac9480: 00 00 00 00 00 00 00 00 00 00 00 00 fc fc fc fc
>>  ffff88801eac9500: 00 00 00 00 00 00 00 00 00 00 00 00 fc fc fc fc
>> >ffff88801eac9580: 00 00 00 00 00 00 00 00 00 fc fc fc fc fc fc fc
>>                                               ^
>>  ffff88801eac9600: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>>  ffff88801eac9680: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>>
>>
>> ---
>> This report is generated by a bot. It may contain errors.
>> See https://goo.gl/tpsmEJ for more information about syzbot.
>> syzbot engineers can be reached at syzkaller@googlegroups.com.
>>
>> syzbot will keep track of this issue. See:
>> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
>> For information about bisection process see: https://goo.gl/tpsmEJ#bisec=
tion
>>
>> If the report is already addressed, let syzbot know by replying with:
>> #syz fix: exact-commit-title
>>
>> If you want syzbot to run the reproducer, reply with:
>> #syz test: git://repo/address.git branch-or-commit-hash
>> If you attach or paste a git patch, syzbot will apply it before testing.
>>
>> If you want to overwrite report's subsystems, reply with:
>> #syz set subsystems: new-subsystem
>> (See the list of subsystem names on the web dashboard)
>>
>> If the report is a duplicate of another one, reply with:
>> #syz dup: exact-subject-of-another-report
>>
>> If you want to undo deduplication, reply with:
>> #syz undup
>>
>> --
>> You received this message because you are subscribed to the Google Group=
s "syzkaller-bugs" group.
>> To unsubscribe from this group and stop receiving emails from it, send a=
n email to syzkaller-bugs+unsubscribe@googlegroups.com.
>> To view this discussion visit https://groups.google.com/d/msgid/syzkalle=
r-bugs/68799e14.a00a0220.3af5df.0025.GAE%40google.com.
