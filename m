From: Paolo Abeni <pabeni@redhat.com>
Subject: Re: WARNING: proc registration bug in clusterip_tg_check
Date: Wed, 07 Feb 2018 09:43:06 +0100
Message-ID: <1517992986.2526.13.camel@redhat.com>
References: <089e082d13a0cf25ed05648bf8b3@google.com>
         <CAM_iQpVdGUjGr1KdVb6AJ7m4OnKLXHpwiorr_T=TKwCskrZKsA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
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
To: Cong Wang <xiyou.wangcong@gmail.com>,
        syzbot <syzbot+03218bcdba6aa76441a3@syzkaller.appspotmail.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <CAM_iQpVdGUjGr1KdVb6AJ7m4OnKLXHpwiorr_T=TKwCskrZKsA@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Tue, 2018-02-06 at 22:42 -0800, Cong Wang wrote:
> On Tue, Feb 6, 2018 at 6:27 AM, syzbot
> <syzbot+03218bcdba6aa76441a3@syzkaller.appspotmail.com> wrote:
> > Hello,
> > 
> > syzbot hit the following crash on net-next commit
> > 617aebe6a97efa539cc4b8a52adccd89596e6be0 (Sun Feb 4 00:25:42 2018 +0000)
> > Merge tag 'usercopy-v4.16-rc1' of
> > git://git.kernel.org/pub/scm/linux/kernel/git/kees/linux
> > 
> > So far this crash happened 5 times on net-next, upstream.
> > C reproducer is attached.
> > syzkaller reproducer is attached.
> > Raw console output is attached.
> > compiler: gcc (GCC) 7.1.1 20170620
> > .config is attached.
> > 
> > IMPORTANT: if you fix the bug, please add the following tag to the commit:
> > Reported-by: syzbot+03218bcdba6aa76441a3@syzkaller.appspotmail.com
> > It will help syzbot understand when the bug is fixed. See footer for
> > details.
> > If you forward the report, please keep this part and the footer.
> > 
> > x_tables: ip_tables: osf match: only valid for protocol 6
> > x_tables: ip_tables: osf match: only valid for protocol 6
> > x_tables: ip_tables: osf match: only valid for protocol 6
> > ------------[ cut here ]------------
> > proc_dir_entry 'ipt_CLUSTERIP/172.20.0.170' already registered
> > WARNING: CPU: 1 PID: 4152 at fs/proc/generic.c:330 proc_register+0x2a4/0x370
> > fs/proc/generic.c:329
> > Kernel panic - not syncing: panic_on_warn set ...
> > 
> > CPU: 1 PID: 4152 Comm: syzkaller851476 Not tainted 4.15.0+ #221
> > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
> > Google 01/01/2011
> > Call Trace:
> >  __dump_stack lib/dump_stack.c:17 [inline]
> >  dump_stack+0x194/0x257 lib/dump_stack.c:53
> >  panic+0x1e4/0x41c kernel/panic.c:183
> >  __warn+0x1dc/0x200 kernel/panic.c:547
> >  report_bug+0x211/0x2d0 lib/bug.c:184
> >  fixup_bug.part.11+0x37/0x80 arch/x86/kernel/traps.c:178
> >  fixup_bug arch/x86/kernel/traps.c:247 [inline]
> >  do_error_trap+0x2d7/0x3e0 arch/x86/kernel/traps.c:296
> >  do_invalid_op+0x1b/0x20 arch/x86/kernel/traps.c:315
> >  invalid_op+0x22/0x40 arch/x86/entry/entry_64.S:1097
> > RIP: 0010:proc_register+0x2a4/0x370 fs/proc/generic.c:329
> > RSP: 0018:ffff8801cbd6ee20 EFLAGS: 00010286
> > RAX: dffffc0000000008 RBX: ffff8801d2181038 RCX: ffffffff815a57ae
> > RDX: 0000000000000000 RSI: 1ffff100397add74 RDI: 1ffff100397add49
> > RBP: ffff8801cbd6ee70 R08: 1ffff100397add0b R09: 0000000000000000
> > R10: ffff8801cbd6ecd8 R11: 0000000000000000 R12: ffff8801b2bb1cc0
> > R13: dffffc0000000000 R14: ffff8801b0d8dbc8 R15: ffff8801b2bb1d81
> >  proc_create_data+0xf8/0x180 fs/proc/generic.c:494
> >  clusterip_config_init net/ipv4/netfilter/ipt_CLUSTERIP.c:250 [inline]
> 
> I think there is probably a race condition between clusterip_config_entry_put()
> and clusterip_config_init(), after we release the spinlock, a new proc
> with the same IP could be created therefore triggers this warning....
> 
> I am not sure if it is enough to just move the proc_remove() under
> spinlock...

I *think* we should change the order on proc fs entry creation, 
because clusterip_config_init() can race with itself,
clusterip_config_init() returns NULL if the clusterip_config_init has
no pte, and currently such entry is inserted into the list with NULL
pte and the list lock itself is released before creating the PTE.

I'll try to test something the following:
---
diff --git a/net/ipv4/netfilter/ipt_CLUSTERIP.c b/net/ipv4/netfilter/ipt_CLUSTERIP.c
index 3a84a60f6b39..d8807c44cc61 100644
--- a/net/ipv4/netfilter/ipt_CLUSTERIP.c
+++ b/net/ipv4/netfilter/ipt_CLUSTERIP.c
@@ -230,17 +230,6 @@ clusterip_config_init(struct net *net, const struct ipt_clusterip_tgt_info *i,
        refcount_set(&c->refcount, 1);
        refcount_set(&c->entries, 1);
 
-       spin_lock_bh(&cn->lock);
-       if (__clusterip_config_find(net, ip)) {
-               spin_unlock_bh(&cn->lock);
-               kfree(c);
-
-               return ERR_PTR(-EBUSY);
-       }
-
-       list_add_rcu(&c->list, &cn->configs);
-       spin_unlock_bh(&cn->lock);
-
 #ifdef CONFIG_PROC_FS
        {
                char buffer[16];
@@ -257,6 +246,18 @@ clusterip_config_init(struct net *net, const struct ipt_clusterip_tgt_info *i,
        }
 #endif
 
+       spin_lock_bh(&cn->lock);
+       if (__clusterip_config_find(net, ip)) {
+               spin_unlock_bh(&cn->lock);
+               kfree(c);
+
+               proc_remove(c->pde);
+               return ERR_PTR(-EBUSY);
+       }
+
+       list_add_rcu(&c->list, &cn->configs);
+       spin_unlock_bh(&cn->lock);
+
        c->notifier.notifier_call = clusterip_netdev_event;
        err = register_netdevice_notifier(&c->notifier);
        if (!err)
---

Cheers,

Paolo
