From: Cong Wang <xiyou.wangcong@gmail.com>
Subject: Re: WARNING: proc registration bug in clusterip_tg_check
Date: Tue, 6 Feb 2018 22:42:08 -0800
Message-ID: <CAM_iQpVdGUjGr1KdVb6AJ7m4OnKLXHpwiorr_T=TKwCskrZKsA@mail.gmail.com>
References: <089e082d13a0cf25ed05648bf8b3@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: coreteam@netfilter.org, David Miller <davem@davemloft.net>,
        Florian Westphal <fw@strlen.de>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        netfilter-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        syzkaller-bugs@googlegroups.com,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
To: syzbot <syzbot+03218bcdba6aa76441a3@syzkaller.appspotmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <089e082d13a0cf25ed05648bf8b3@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Tue, Feb 6, 2018 at 6:27 AM, syzbot
<syzbot+03218bcdba6aa76441a3@syzkaller.appspotmail.com> wrote:
> Hello,
>
> syzbot hit the following crash on net-next commit
> 617aebe6a97efa539cc4b8a52adccd89596e6be0 (Sun Feb 4 00:25:42 2018 +0000)
> Merge tag 'usercopy-v4.16-rc1' of
> git://git.kernel.org/pub/scm/linux/kernel/git/kees/linux
>
> So far this crash happened 5 times on net-next, upstream.
> C reproducer is attached.
> syzkaller reproducer is attached.
> Raw console output is attached.
> compiler: gcc (GCC) 7.1.1 20170620
> .config is attached.
>
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+03218bcdba6aa76441a3@syzkaller.appspotmail.com
> It will help syzbot understand when the bug is fixed. See footer for
> details.
> If you forward the report, please keep this part and the footer.
>
> x_tables: ip_tables: osf match: only valid for protocol 6
> x_tables: ip_tables: osf match: only valid for protocol 6
> x_tables: ip_tables: osf match: only valid for protocol 6
> ------------[ cut here ]------------
> proc_dir_entry 'ipt_CLUSTERIP/172.20.0.170' already registered
> WARNING: CPU: 1 PID: 4152 at fs/proc/generic.c:330 proc_register+0x2a4/0x370
> fs/proc/generic.c:329
> Kernel panic - not syncing: panic_on_warn set ...
>
> CPU: 1 PID: 4152 Comm: syzkaller851476 Not tainted 4.15.0+ #221
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
>  invalid_op+0x22/0x40 arch/x86/entry/entry_64.S:1097
> RIP: 0010:proc_register+0x2a4/0x370 fs/proc/generic.c:329
> RSP: 0018:ffff8801cbd6ee20 EFLAGS: 00010286
> RAX: dffffc0000000008 RBX: ffff8801d2181038 RCX: ffffffff815a57ae
> RDX: 0000000000000000 RSI: 1ffff100397add74 RDI: 1ffff100397add49
> RBP: ffff8801cbd6ee70 R08: 1ffff100397add0b R09: 0000000000000000
> R10: ffff8801cbd6ecd8 R11: 0000000000000000 R12: ffff8801b2bb1cc0
> R13: dffffc0000000000 R14: ffff8801b0d8dbc8 R15: ffff8801b2bb1d81
>  proc_create_data+0xf8/0x180 fs/proc/generic.c:494
>  clusterip_config_init net/ipv4/netfilter/ipt_CLUSTERIP.c:250 [inline]

I think there is probably a race condition between clusterip_config_entry_put()
and clusterip_config_init(), after we release the spinlock, a new proc
with the same IP could be created therefore triggers this warning....

I am not sure if it is enough to just move the proc_remove() under
spinlock...


diff --git a/net/ipv4/netfilter/ipt_CLUSTERIP.c
b/net/ipv4/netfilter/ipt_CLUSTERIP.c
index 3a84a60f6b39..1ff72b87a066 100644
--- a/net/ipv4/netfilter/ipt_CLUSTERIP.c
+++ b/net/ipv4/netfilter/ipt_CLUSTERIP.c
@@ -107,12 +107,6 @@ clusterip_config_entry_put(struct net *net,
struct clusterip_config *c)

        local_bh_disable();
        if (refcount_dec_and_lock(&c->entries, &cn->lock)) {
-               list_del_rcu(&c->list);
-               spin_unlock(&cn->lock);
-               local_bh_enable();
-
-               unregister_netdevice_notifier(&c->notifier);
-
                /* In case anyone still accesses the file, the open/close
                 * functions are also incrementing the refcount on their own,
                 * so it's safe to remove the entry even if it's in use. */
@@ -120,6 +114,12 @@ clusterip_config_entry_put(struct net *net,
struct clusterip_config *c)
                if (cn->procdir)
                        proc_remove(c->pde);
 #endif
+               list_del_rcu(&c->list);
+               spin_unlock(&cn->lock);
+               local_bh_enable();
+
+               unregister_netdevice_notifier(&c->notifier);
+
                return;
        }
        local_bh_enable();


>  clusterip_tg_check+0xf9c/0x16d0 net/ipv4/netfilter/ipt_CLUSTERIP.c:488
>  xt_check_target+0x22c/0x7d0 net/netfilter/x_tables.c:850
>  check_target net/ipv4/netfilter/ip_tables.c:513 [inline]
>  find_check_entry.isra.8+0x8c8/0xcb0 net/ipv4/netfilter/ip_tables.c:554
>  translate_table+0xed1/0x1610 net/ipv4/netfilter/ip_tables.c:725
>  do_replace net/ipv4/netfilter/ip_tables.c:1141 [inline]
>  do_ipt_set_ctl+0x370/0x5f0 net/ipv4/netfilter/ip_tables.c:1675
>  nf_sockopt net/netfilter/nf_sockopt.c:106 [inline]
>  nf_setsockopt+0x67/0xc0 net/netfilter/nf_sockopt.c:115
>  ip_setsockopt+0x97/0xa0 net/ipv4/ip_sockglue.c:1259
>  sctp_setsockopt+0x2b6/0x61d0 net/sctp/socket.c:4104
>  sock_common_setsockopt+0x95/0xd0 net/core/sock.c:2975
>  SYSC_setsockopt net/socket.c:1849 [inline]
>  SyS_setsockopt+0x189/0x360 net/socket.c:1828
>  entry_SYSCALL_64_fastpath+0x29/0xa0
> RIP: 0033:0x446839
> RSP: 002b:00007f0309d0fdb8 EFLAGS: 00000246 ORIG_RAX: 0000000000000036
> RAX: ffffffffffffffda RBX: 00000000006dbc24 RCX: 0000000000446839
> RDX: 0000000000000040 RSI: 0000000000000000 RDI: 0000000000000003
> RBP: 00000000006dbc20 R08: 0000000000000348 R09: 0000000000000000
> R10: 0000000020013c90 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007ffc7d53f79f R14: 00007f0309d109c0 R15: 0000000000000003
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
