From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: BUG: unable to handle kernel paging request in
 cgroup_mt_destroy_v1
Date: Sat, 12 May 2018 23:50:49 -0700
Message-ID: <20180513065049.GA27296@sol.localdomain>
References: <f4f5e803bcb8f8c5e305641cecbe@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: coreteam@netfilter.org, davem@davemloft.net, fw@strlen.de,
        kadlec@blackhole.kfki.hu, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        pablo@netfilter.org, syzkaller-bugs@googlegroups.com
To: syzbot <syzbot+eeed2602160e4cc17410@syzkaller.appspotmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <f4f5e803bcb8f8c5e305641cecbe@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Wed, Jan 31, 2018 at 05:58:01PM -0800, syzbot wrote:
> Hello,
> 
> syzbot hit the following crash on upstream commit
> 3da90b159b146672f830bcd2489dd3a1f4e9e089 (Wed Jan 31 03:07:32 2018 +0000)
> Merge tag 'f2fs-for-4.16-rc1' of
> git://git.kernel.org/pub/scm/linux/kernel/git/jaegeuk/f2fs
> 
> So far this crash happened 3 times on net-next, upstream.
> C reproducer is attached.
> syzkaller reproducer is attached.
> Raw console output is attached.
> compiler: gcc (GCC) 7.1.1 20170620
> .config is attached.
> 
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+eeed2602160e4cc17410@syzkaller.appspotmail.com
> It will help syzbot understand when the bug is fixed. See footer for
> details.
> If you forward the report, please keep this part and the footer.
> 
> audit: type=1400 audit(1517426494.787:7): avc:  denied  { map } for
> pid=4176 comm="syzkaller493328" path="/root/syzkaller493328633" dev="sda1"
> ino=16481 scontext=unconfined_u:system_r:insmod_t:s0-s0:c0.c1023
> tcontext=unconfined_u:object_r:user_home_t:s0 tclass=file permissive=1
> BUG: unable to handle kernel paging request at ffffffffffffff6d
> IP: css_put include/linux/cgroup.h:386 [inline]
> IP: cgroup_put include/linux/cgroup.h:415 [inline]
> IP: cgroup_mt_destroy_v1+0xe5/0x310 net/netfilter/xt_cgroup.c:102
> PGD 6a25067 P4D 6a25067 PUD 6a27067 PMD 0
> Oops: 0000 [#1] SMP KASAN
> Dumping ftrace buffer:
>    (ftrace buffer empty)
> Modules linked in:
> CPU: 0 PID: 4176 Comm: syzkaller493328 Not tainted 4.15.0+ #288
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
> Google 01/01/2011
> RIP: 0010:css_put include/linux/cgroup.h:386 [inline]
> RIP: 0010:cgroup_put include/linux/cgroup.h:415 [inline]
> RIP: 0010:cgroup_mt_destroy_v1+0xe5/0x310 net/netfilter/xt_cgroup.c:102
> RSP: 0018:ffff8801b19e7958 EFLAGS: 00010246
> RAX: 0000000000000008 RBX: 1ffff1003633cf2b RCX: ffffffff847188c6
> RDX: 0000000000000000 RSI: ffffffff8709b900 RDI: ffffffffffffff6d
> RBP: ffff8801b19e79e0 R08: 1ffff1003633cef9 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000000 R12: ffffffffffffff01
> R13: ffff8801b19e79b8 R14: dffffc0000000000 R15: ffffffff84718810
> FS:  0000000000c16880(0000) GS:ffff8801db400000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: ffffffffffffff6d CR3: 00000001b1f38004 CR4: 00000000001606f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  cleanup_match+0x14e/0x220 net/ipv6/netfilter/ip6_tables.c:481
>  cleanup_entry+0xcb/0x350 net/ipv4/netfilter/ip_tables.c:646
>  __do_replace+0x7d7/0xa90 net/ipv4/netfilter/ip_tables.c:1091
>  do_replace net/ipv4/netfilter/ip_tables.c:1147 [inline]
>  do_ipt_set_ctl+0x40f/0x5f0 net/ipv4/netfilter/ip_tables.c:1677
>  nf_sockopt net/netfilter/nf_sockopt.c:106 [inline]
>  nf_setsockopt+0x67/0xc0 net/netfilter/nf_sockopt.c:115
>  ip_setsockopt+0xa1/0xb0 net/ipv4/ip_sockglue.c:1256
>  tcp_setsockopt+0x82/0xd0 net/ipv4/tcp.c:2875
>  sock_common_setsockopt+0x95/0xd0 net/core/sock.c:2968
>  SYSC_setsockopt net/socket.c:1831 [inline]
>  SyS_setsockopt+0x189/0x360 net/socket.c:1810
>  entry_SYSCALL_64_fastpath+0x29/0xa0
> RIP: 0033:0x4408a9
> RSP: 002b:00007ffddd061cc8 EFLAGS: 00000207 ORIG_RAX: 0000000000000036
> RAX: ffffffffffffffda RBX: ffffffffffffffff RCX: 00000000004408a9
> RDX: 0000000000000040 RSI: 0000000000000000 RDI: 0000000000000004
> RBP: faaff2414ccfc19e R08: 00000000000012f0 R09: 0000000000000000
> R10: 000000002000b000 R11: 0000000000000207 R12: 886f734548d4d66b
> R13: ffffffffffffff01 R14: 0000000000000000 R15: 0000000000000000
> Code: 6c 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 0f b6 14 02 48
> 89 f8 83 e0 07 83 c0 03 38 d0 7c 08 84 d2 0f 85 a6 01 00 00 <41> f6 44 24 6c
> 01 74 2e e8 be 06 ff fc 48 b8 00 00 00 00 00 fc
> RIP: css_put include/linux/cgroup.h:386 [inline] RSP: ffff8801b19e7958
> RIP: cgroup_put include/linux/cgroup.h:415 [inline] RSP: ffff8801b19e7958
> RIP: cgroup_mt_destroy_v1+0xe5/0x310 net/netfilter/xt_cgroup.c:102 RSP:
> ffff8801b19e7958
> CR2: ffffffffffffff6d
> ---[ end trace bfd8c145aa41ae03 ]---
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

This was fixed by commit ba7cd5d95f25cc6:

#syz fix: netfilter: xt_cgroup: initialize info->priv in cgroup_mt_check_v1()

- Eric
