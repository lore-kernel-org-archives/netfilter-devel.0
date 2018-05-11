From: Dmitry Vyukov <dvyukov@google.com>
Subject: Re: WARNING in compat_copy_entries (2)
Date: Fri, 11 May 2018 16:13:10 +0200
Message-ID: <CACT4Y+bpDiybQ7j_r3Pa-UgOTnOLRGiJxnwwZ5J=sjgo=O0__A@mail.gmail.com>
References: <001a113dea0ef7d2620566c15bac@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: bridge@lists.linux-foundation.org, coreteam@netfilter.org,
        David Miller <davem@davemloft.net>,
        Florian Westphal <fw@strlen.de>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, netfilter-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        stephen hemminger <stephen@networkplumber.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
To: syzbot <syzbot+659574e7bcc7f7eb4df7@syzkaller.appspotmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <001a113dea0ef7d2620566c15bac@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Tue, Mar 6, 2018 at 5:59 PM, syzbot
<syzbot+659574e7bcc7f7eb4df7@syzkaller.appspotmail.com> wrote:
> Hello,
>
> syzbot hit the following crash on upstream commit
> ce380619fab99036f5e745c7a865b21c59f005f6 (Tue Mar 6 04:31:14 2018 +0000)
> Merge tag 'please-pull-ia64_misc' of
> git://git.kernel.org/pub/scm/linux/kernel/git/aegl/linux
>
> So far this crash happened 11 times on upstream.
> syzkaller reproducer is attached.
> Raw console output is attached.
> compiler: gcc (GCC) 7.1.1 20170620
> .config is attached.
> user-space arch: i386

This was bisected to, well:

commit 9dea5dc921b5f4045a18c63eb92e84dc274d17eb
Author: Andy Lutomirski <luto@kernel.org>
Date:   Tue Jul 14 15:24:24 2015 -0700

    x86/entry/syscalls: Wire up 32-bit direct socket calls

https://gist.githubusercontent.com/dvyukov/acbdace00cbb2fd31fb599a009d471e6/raw/bfe6bd8f2423df7b3493c7df2e466b37a8968688/gistfile1.txt

Which is kinda makes sense, but shows another limitation of automatic bisection.


> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+659574e7bcc7f7eb4df7@syzkaller.appspotmail.com
> It will help syzbot understand when the bug is fixed. See footer for
> details.
> If you forward the report, please keep this part and the footer.
>
> audit: type=1400 audit(1520347101.934:8): avc:  denied  { map } for
> pid=4183 comm="syz-execprog" path="/root/syzkaller-shm886349459" dev="sda1"
> ino=16482 scontext=unconfined_u:system_r:insmod_t:s0-s0:c0.c1023
> tcontext=unconfined_u:object_r:file_t:s0 tclass=file permissive=1
> IPVS: ftp: loaded support on port[0] = 21
> WARNING: CPU: 1 PID: 4192 at net/bridge/netfilter/ebtables.c:2063
> ebt_size_mwt net/bridge/netfilter/ebtables.c:2063 [inline]
> WARNING: CPU: 1 PID: 4192 at net/bridge/netfilter/ebtables.c:2063
> size_entry_mwt net/bridge/netfilter/ebtables.c:2140 [inline]
> WARNING: CPU: 1 PID: 4192 at net/bridge/netfilter/ebtables.c:2063
> compat_copy_entries+0xd92/0x1150 net/bridge/netfilter/ebtables.c:2179
> Kernel panic - not syncing: panic_on_warn set ...
>
> CPU: 1 PID: 4192 Comm: syz-executor0 Not tainted 4.16.0-rc4+ #253
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
> Google 01/01/2011
> Call Trace:
>  __dump_stack lib/dump_stack.c:17 [inline]
>  dump_stack+0x194/0x24d lib/dump_stack.c:53
>  panic+0x1e4/0x41c kernel/panic.c:183
>  __warn+0x1dc/0x200 kernel/panic.c:547
>  report_bug+0x211/0x2d0 lib/bug.c:184
>  fixup_bug.part.11+0x37/0x80 arch/x86/kernel/traps.c:178
>  fixup_bug arch/x86/kernel/traps.c:247 [inline]
>  do_error_trap+0x2d7/0x3e0 arch/x86/kernel/traps.c:296
>  do_invalid_op+0x1b/0x20 arch/x86/kernel/traps.c:315
>  invalid_op+0x1b/0x40 arch/x86/entry/entry_64.S:986
> RIP: 0010:ebt_size_mwt net/bridge/netfilter/ebtables.c:2063 [inline]
> RIP: 0010:size_entry_mwt net/bridge/netfilter/ebtables.c:2140 [inline]
> RIP: 0010:compat_copy_entries+0xd92/0x1150
> net/bridge/netfilter/ebtables.c:2179
> RSP: 0018:ffff8801bb5077e8 EFLAGS: 00010293
> RAX: ffff8801bc82a580 RBX: 0000000000000000 RCX: ffffffff851ad5c2
> RDX: 0000000000000000 RSI: ffffc90001853180 RDI: 0000000000000000
> RBP: ffff8801bb507968 R08: 0000000000000004 R09: 0000000000000000
> R10: ffffffff88613380 R11: 0000000000000001 R12: 0000000000000007
> R13: dffffc0000000000 R14: ffff8801bb5079c8 R15: 000000000000000c
>  compat_do_replace+0x398/0x7d0 net/bridge/netfilter/ebtables.c:2268
>  compat_do_ebt_set_ctl+0x22a/0x2d0 net/bridge/netfilter/ebtables.c:2350
>  compat_nf_sockopt net/netfilter/nf_sockopt.c:144 [inline]
>  compat_nf_setsockopt+0x88/0x130 net/netfilter/nf_sockopt.c:156
>  compat_ip_setsockopt+0x8b/0xd0 net/ipv4/ip_sockglue.c:1285
>  inet_csk_compat_setsockopt+0x95/0x120 net/ipv4/inet_connection_sock.c:1041
>  compat_dccp_setsockopt+0x40/0x70 net/dccp/proto.c:589
>  compat_sock_common_setsockopt+0xb2/0x140 net/core/sock.c:2986
>  C_SYSC_setsockopt net/compat.c:403 [inline]
>  compat_SyS_setsockopt+0x17c/0x410 net/compat.c:386
>  do_syscall_32_irqs_on arch/x86/entry/common.c:330 [inline]
>  do_fast_syscall_32+0x3ec/0xf9f arch/x86/entry/common.c:392
>  entry_SYSENTER_compat+0x70/0x7f arch/x86/entry/entry_64_compat.S:139
> RIP: 0023:0xf7f35c99
> RSP: 002b:00000000ff9c02cc EFLAGS: 00000282 ORIG_RAX: 000000000000016e
> RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 0000000000000000
> RDX: 0000000000000080 RSI: 0000000020000240 RDI: 0000000000000240
> RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
> R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
> Dumping ftrace buffer:
>    (ftrace buffer empty)
> Kernel Offset: disabled
> Rebooting in 86400 seconds..
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
> https://groups.google.com/d/msgid/syzkaller-bugs/001a113dea0ef7d2620566c15bac%40google.com.
> For more options, visit https://groups.google.com/d/optout.
