From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: WARNING: ODEBUG bug in do_arpt_get_ctl
Date: Wed, 4 Jul 2018 14:24:08 -0700
Message-ID: <20180704212408.GG725@sol.localdomain>
References: <94eb2c0efc1e7e42b20565bf3254@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: coreteam@netfilter.org, davem@davemloft.net, fw@strlen.de,
        kadlec@blackhole.kfki.hu, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        pablo@netfilter.org, syzkaller-bugs@googlegroups.com
To: syzbot <syzbot+9d1c0d941336dbc741a1@syzkaller.appspotmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <94eb2c0efc1e7e42b20565bf3254@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Wed, Feb 21, 2018 at 12:59:03PM -0800, syzbot wrote:
> Hello,
> 
> syzbot hit the following crash on upstream commit
> 91ab883eb21325ad80f3473633f794c78ac87f51 (Mon Feb 19 01:29:42 2018 +0000)
> Linux 4.16-rc2
> 
> syzkaller reproducer is attached.
> Raw console output is attached.
> compiler: gcc (GCC) 7.1.1 20170620
> .config is attached.
> 
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+9d1c0d941336dbc741a1@syzkaller.appspotmail.com
> It will help syzbot understand when the bug is fixed. See footer for
> details.
> If you forward the report, please keep this part and the footer.
> 
> IPVS: ftp: loaded support on port[0] = 21
> IPVS: ftp: loaded support on port[0] = 21
> IPVS: ftp: loaded support on port[0] = 21
> ------------[ cut here ]------------
> ODEBUG: free active (active state 0) object type: work_struct hint:
> htable_gc+0x0/0xc0 net/netfilter/xt_hashlimit.c:376
> WARNING: CPU: 1 PID: 4165 at lib/debugobjects.c:291
> debug_print_object+0x166/0x220 lib/debugobjects.c:288
> Kernel panic - not syncing: panic_on_warn set ...
> 
> CPU: 1 PID: 4165 Comm: syz-executor3 Not tainted 4.16.0-rc2+ #320
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
> Google 01/01/2011
> Call Trace:
>  __dump_stack lib/dump_stack.c:17 [inline]
>  dump_stack+0x194/0x257 lib/dump_stack.c:53
>  panic+0x1e4/0x41c kernel/panic.c:183
>  __warn+0x1dc/0x200 kernel/panic.c:547
>  report_bug+0x211/0x2d0 lib/bug.c:184
>  fixup_bug.part.11+0x37/0x80 arch/x86/kernel/traps.c:178
>  fixup_bug arch/x86/kernel/traps.c:247 [inline]
>  do_error_trap+0x2d7/0x3e0 arch/x86/kernel/traps.c:296
>  do_invalid_op+0x1b/0x20 arch/x86/kernel/traps.c:315
>  invalid_op+0x58/0x80 arch/x86/entry/entry_64.S:957
> RIP: 0010:debug_print_object+0x166/0x220 lib/debugobjects.c:288
> RSP: 0018:ffff8801b3d8f790 EFLAGS: 00010082
> RAX: dffffc0000000008 RBX: 0000000000000003 RCX: ffffffff815abdbe
> RDX: 0000000000000000 RSI: 1ffff100367b1ea2 RDI: 1ffff100367b1e77
> RBP: ffff8801b3d8f7d0 R08: 0000000000000000 R09: 1ffff100367b1e49
> R10: ffffed00367b1f21 R11: ffffffff86b394b8 R12: 0000000000000001
> R13: ffffffff86b14d80 R14: ffffffff86007de0 R15: ffffffff8147ac00
>  __debug_check_no_obj_freed lib/debugobjects.c:745 [inline]
>  debug_check_no_obj_freed+0x662/0xf1f lib/debugobjects.c:774
>  __vunmap+0x112/0x380 mm/vmalloc.c:1530
>  vfree+0x50/0xe0 mm/vmalloc.c:1606
>  copy_entries_to_user net/ipv4/netfilter/arp_tables.c:714 [inline]
>  get_entries net/ipv4/netfilter/arp_tables.c:867 [inline]
>  do_arpt_get_ctl+0x7c4/0xa00 net/ipv4/netfilter/arp_tables.c:1485
>  nf_sockopt net/netfilter/nf_sockopt.c:104 [inline]
>  nf_getsockopt+0x6a/0xc0 net/netfilter/nf_sockopt.c:122
>  ip_getsockopt+0x15c/0x220 net/ipv4/ip_sockglue.c:1571
>  tcp_getsockopt+0x82/0xd0 net/ipv4/tcp.c:3359
>  sock_common_getsockopt+0x95/0xd0 net/core/sock.c:2934
>  SYSC_getsockopt net/socket.c:1880 [inline]
>  SyS_getsockopt+0x178/0x340 net/socket.c:1862
>  do_syscall_64+0x280/0x940 arch/x86/entry/common.c:287
>  entry_SYSCALL_64_after_hwframe+0x42/0xb7
> RIP: 0033:0x45687a
> RSP: 002b:0000000000a3eb48 EFLAGS: 00000212 ORIG_RAX: 0000000000000037
> RAX: ffffffffffffffda RBX: 0000000000000027 RCX: 000000000045687a
> RDX: 0000000000000061 RSI: 0000000000000000 RDI: 0000000000000000
> RBP: 0000000000a3f200 R08: 0000000000a3eb7c R09: 0000000000000001
> R10: 0000000000a3f200 R11: 0000000000000212 R12: 0000000000a3eb80
> R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000001380
> 

Like the similar bug report "WARNING: ODEBUG bug in do_ipt_get_ctl" [1], this
report doesn't make sense as there is no work_struct in the array being freed.
And this last occurred 4 months ago.  So I am invalidating this one too as it
probably was a weird bug elsewhere in the kernel that has since been fixed:

#syz invalid

[1] https://groups.google.com/forum/#!msg/syzkaller-bugs/A_gWpsvtxKc/5YSSVpImDQAJ

- Eric
