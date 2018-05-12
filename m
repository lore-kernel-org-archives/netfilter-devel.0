From: Dmitry Vyukov <dvyukov@google.com>
Subject: Re: KASAN: use-after-free Write in xt_rateest_put
Date: Sat, 12 May 2018 10:39:35 +0200
Message-ID: <CACT4Y+bVBGCXe1_td1c4kZi+BbSAGZV=_a_tODe5owUkU-zgcA@mail.gmail.com>
References: <94eb2c0b9a14f575660563eb788d@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: coreteam@netfilter.org, David Miller <davem@davemloft.net>,
        Florian Westphal <fw@strlen.de>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, netfilter-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
To: syzbot <syzbot+551ff4604e832588433e@syzkaller.appspotmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <94eb2c0b9a14f575660563eb788d@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Mon, Jan 29, 2018 at 3:58 PM, syzbot
<syzbot+551ff4604e832588433e@syzkaller.appspotmail.com> wrote:
> Hello,
>
> syzbot hit the following crash on upstream commit
> 24b1cccf922914f3d6eeb84036dde8338bc03abb (Sun Jan 28 20:24:36 2018 +0000)
> Merge branch 'x86-pti-for-linus' of
> git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
>
> C reproducer is attached.
> syzkaller reproducer is attached.
> Raw console output is attached.
> compiler: gcc (GCC) 7.1.1 20170620
> .config is attached.
>
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+551ff4604e832588433e@syzkaller.appspotmail.com
> It will help syzbot understand when the bug is fixed. See footer for
> details.
> If you forward the report, please keep this part and the footer.

This was bisected as fixed by:

#syz fix: netfilter: xt_RATEEST: acquire xt_rateest_mutex for hash insert

https://gist.githubusercontent.com/dvyukov/9d5b710cf4f429969b93aa90ec217c29/raw/68c1fee7f7e133574a0787c9e46d97a6cf521759/gistfile1.txt

> ==================================================================
> BUG: KASAN: use-after-free in __hlist_del include/linux/list.h:651 [inline]
> BUG: KASAN: use-after-free in hlist_del include/linux/list.h:656 [inline]
> BUG: KASAN: use-after-free in xt_rateest_put+0x2e3/0x300
> net/netfilter/xt_RATEEST.c:65
> Write of size 8 at addr ffff8801d4d40e58 by task syzkaller770396/3682
>
> CPU: 1 PID: 3682 Comm: syzkaller770396 Not tainted 4.15.0-rc9+ #284
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
> Google 01/01/2011
> Call Trace:
>  __dump_stack lib/dump_stack.c:17 [inline]
>  dump_stack+0x194/0x257 lib/dump_stack.c:53
>  print_address_description+0x73/0x250 mm/kasan/report.c:252
>  kasan_report_error mm/kasan/report.c:351 [inline]
>  kasan_report+0x25b/0x340 mm/kasan/report.c:409
>  __asan_report_store8_noabort+0x17/0x20 mm/kasan/report.c:435
>  __hlist_del include/linux/list.h:651 [inline]
>  hlist_del include/linux/list.h:656 [inline]
>  xt_rateest_put+0x2e3/0x300 net/netfilter/xt_RATEEST.c:65
>  xt_rateest_tg_destroy+0x50/0x70 net/netfilter/xt_RATEEST.c:154
>  cleanup_entry+0x242/0x380 net/ipv6/netfilter/ip6_tables.c:678
>  __do_replace+0x7e6/0xab0 net/ipv6/netfilter/ip6_tables.c:1115
>  do_replace net/ipv6/netfilter/ip6_tables.c:1171 [inline]
>  do_ip6t_set_ctl+0x40f/0x5f0 net/ipv6/netfilter/ip6_tables.c:1693
>  nf_sockopt net/netfilter/nf_sockopt.c:106 [inline]
>  nf_setsockopt+0x67/0xc0 net/netfilter/nf_sockopt.c:115
>  ipv6_setsockopt+0x115/0x150 net/ipv6/ipv6_sockglue.c:928
>  udpv6_setsockopt+0x45/0x80 net/ipv6/udp.c:1452
>  sock_common_setsockopt+0x95/0xd0 net/core/sock.c:2968
>  SYSC_setsockopt net/socket.c:1831 [inline]
>  SyS_setsockopt+0x189/0x360 net/socket.c:1810
>  entry_SYSCALL_64_fastpath+0x29/0xa0
> RIP: 0033:0x4412d9
> RSP: 002b:00007fffb8cbf5f8 EFLAGS: 00000203 ORIG_RAX: 0000000000000036
> RAX: ffffffffffffffda RBX: ffffffffffffffff RCX: 00000000004412d9
> RDX: 0000000000000040 RSI: 0000000000000029 RDI: 0000000000000326
> RBP: f6fcce9cd855ec40 R08: 00000000000003b8 R09: 0000000000000000
> R10: 0000000020019c48 R11: 0000000000000203 R12: fbfe5b6031634428
> R13: 5826b2d59f7fe9a1 R14: fd7217c033abf8b5 R15: 0000000000000000
>
> Allocated by task 3687:
>  save_stack+0x43/0xd0 mm/kasan/kasan.c:447
>  set_track mm/kasan/kasan.c:459 [inline]
>  kasan_kmalloc+0xad/0xe0 mm/kasan/kasan.c:551
>  kmem_cache_alloc_trace+0x136/0x750 mm/slab.c:3610
>  kmalloc include/linux/slab.h:499 [inline]
>  kzalloc include/linux/slab.h:688 [inline]
>  xt_rateest_tg_checkentry+0x25a/0xaa0 net/netfilter/xt_RATEEST.c:120
>  xt_check_target+0x22c/0x7d0 net/netfilter/x_tables.c:845
>  check_target net/ipv6/netfilter/ip6_tables.c:538 [inline]
>  find_check_entry.isra.7+0x935/0xcf0 net/ipv6/netfilter/ip6_tables.c:580
>  translate_table+0xf52/0x1690 net/ipv6/netfilter/ip6_tables.c:749
>  do_replace net/ipv6/netfilter/ip6_tables.c:1167 [inline]
>  do_ip6t_set_ctl+0x370/0x5f0 net/ipv6/netfilter/ip6_tables.c:1693
>  nf_sockopt net/netfilter/nf_sockopt.c:106 [inline]
>  nf_setsockopt+0x67/0xc0 net/netfilter/nf_sockopt.c:115
>  ipv6_setsockopt+0x115/0x150 net/ipv6/ipv6_sockglue.c:928
>  udpv6_setsockopt+0x45/0x80 net/ipv6/udp.c:1452
>  sock_common_setsockopt+0x95/0xd0 net/core/sock.c:2968
>  SYSC_setsockopt net/socket.c:1831 [inline]
>  SyS_setsockopt+0x189/0x360 net/socket.c:1810
>  entry_SYSCALL_64_fastpath+0x29/0xa0
>
> Freed by task 3682:
>  save_stack+0x43/0xd0 mm/kasan/kasan.c:447
>  set_track mm/kasan/kasan.c:459 [inline]
>  kasan_slab_free+0x71/0xc0 mm/kasan/kasan.c:524
>  __cache_free mm/slab.c:3488 [inline]
>  kfree+0xd6/0x260 mm/slab.c:3803
>  __rcu_reclaim kernel/rcu/rcu.h:190 [inline]
>  rcu_do_batch kernel/rcu/tree.c:2758 [inline]
>  invoke_rcu_callbacks kernel/rcu/tree.c:3012 [inline]
>  __rcu_process_callbacks kernel/rcu/tree.c:2979 [inline]
>  rcu_process_callbacks+0xe94/0x17f0 kernel/rcu/tree.c:2996
>  __do_softirq+0x2d7/0xb85 kernel/softirq.c:285
>
> The buggy address belongs to the object at ffff8801d4d40e00
>  which belongs to the cache kmalloc-192 of size 192
> The buggy address is located 88 bytes inside of
>  192-byte region [ffff8801d4d40e00, ffff8801d4d40ec0)
> The buggy address belongs to the page:
> page:ffffea0007535000 count:1 mapcount:0 mapping:ffff8801d4d40000 index:0x0
> flags: 0x2fffc0000000100(slab)
> raw: 02fffc0000000100 ffff8801d4d40000 0000000000000000 0000000100000010
> raw: ffffea00075251e0 ffff8801dac01148 ffff8801dac00040 0000000000000000
> page dumped because: kasan: bad access detected
>
> Memory state around the buggy address:
>  ffff8801d4d40d00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>  ffff8801d4d40d80: fb fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
>>
>> ffff8801d4d40e00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>
>                                                     ^
>  ffff8801d4d40e80: fb fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
>  ffff8801d4d40f00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> ==================================================================
>
>
> ---
> This bug is generated by a dumb bot. It may contain errors.
> See https://goo.gl/tpsmEJ for details.
> Direct all questions to syzkaller@googlegroups.com.
>
> syzbot will keep track of this bug report.
> If you forgot to add the Reported-by tag, once the fix for this bug is
> merged
> into any tree, please reply to this email with:
> #syz fix: exact-commit-title
> If you want to test a patch for this bug, please reply with:
> #syz test: git://repo/address.git branch
> and provide the patch inline or as an attachment.
> To mark this as a duplicate of another syzbot report, please reply with:
> #syz dup: exact-subject-of-another-report
> If it's a one-off invalid bug report, please reply with:
> #syz invalid
> Note: if the crash happens again, it will cause creation of a new bug
> report.
> Note: all commands must start from beginning of the line in the email body.
>
> --
> You received this message because you are subscribed to the Google Groups
> "syzkaller-bugs" group.
> To unsubscribe from this group and stop receiving emails from it, send an
> email to syzkaller-bugs+unsubscribe@googlegroups.com.
> To view this discussion on the web visit
> https://groups.google.com/d/msgid/syzkaller-bugs/94eb2c0b9a14f575660563eb788d%40google.com.
> For more options, visit https://groups.google.com/d/optout.
