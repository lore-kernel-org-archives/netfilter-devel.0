From: syzbot <syzbot+655174276c47216abab5@syzkaller.appspotmail.com>
Subject: INFO: rcu detected stall in gc_worker
Date: Tue, 22 Jan 2019 11:19:03 -0800
Message-ID: <000000000000ada99c058010d943@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
To: coreteam@netfilter.org, davem@davemloft.net, fw@strlen.de,
        kadlec@blackhole.kfki.hu, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        pablo@netfilter.org, syzkaller-bugs@googlegroups.com
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    133bbb18ab1a virtio-net: per-queue RPS config
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=16c98130c00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=8a4dffabfb4e36f9
dashboard link: https://syzkaller.appspot.com/bug?extid=655174276c47216abab5
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+655174276c47216abab5@syzkaller.appspotmail.com

IPVS: ftp: loaded support on port[0] = 21
rcu: INFO: rcu_preempt self-detected stall on CPU
rcu: 	1-....: (10500 ticks this GP) idle=2fa/1/0x4000000000000002  
softirq=16980/16980 fqs=5250
rcu: 	 (t=10502 jiffies g=18501 q=1048)
NMI backtrace for cpu 1
CPU: 1 PID: 2980 Comm: kworker/1:2 Not tainted 5.0.0-rc2+ #12
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Workqueue: events_power_efficient gc_worker
Call Trace:
  <IRQ>
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x1db/0x2d0 lib/dump_stack.c:113
  nmi_cpu_backtrace.cold+0x63/0xa4 lib/nmi_backtrace.c:101
  nmi_trigger_cpumask_backtrace+0x1be/0x236 lib/nmi_backtrace.c:62
  arch_trigger_cpumask_backtrace+0x14/0x20 arch/x86/kernel/apic/hw_nmi.c:38
  trigger_single_cpu_backtrace include/linux/nmi.h:164 [inline]
  rcu_dump_cpu_stacks+0x183/0x1cf kernel/rcu/tree.c:1211
  print_cpu_stall.cold+0x227/0x40c kernel/rcu/tree.c:1348
  check_cpu_stall kernel/rcu/tree.c:1422 [inline]
  rcu_pending kernel/rcu/tree.c:3018 [inline]
  rcu_check_callbacks+0xb32/0x1380 kernel/rcu/tree.c:2521
  update_process_times+0x32/0x80 kernel/time/timer.c:1635
  tick_sched_handle+0xa2/0x190 kernel/time/tick-sched.c:161
  tick_sched_timer+0x47/0x130 kernel/time/tick-sched.c:1271
  __run_hrtimer kernel/time/hrtimer.c:1389 [inline]
  __hrtimer_run_queues+0x3a7/0x1050 kernel/time/hrtimer.c:1451
  hrtimer_interrupt+0x314/0x770 kernel/time/hrtimer.c:1509
  local_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1035 [inline]
  smp_apic_timer_interrupt+0x18d/0x760 arch/x86/kernel/apic/apic.c:1060
  apic_timer_interrupt+0xf/0x20 arch/x86/entry/entry_64.S:807
  </IRQ>
RIP: 0010:cpu_relax arch/x86/include/asm/processor.h:666 [inline]
RIP: 0010:virt_spin_lock arch/x86/include/asm/qspinlock.h:84 [inline]
RIP: 0010:native_queued_spin_lock_slowpath+0x1b9/0x1290  
kernel/locking/qspinlock.c:337
Code: 00 00 00 48 8b 45 d0 65 48 33 04 25 28 00 00 00 0f 85 68 0c 00 00 48  
81 c4 a8 01 00 00 5b 41 5c 41 5d 41 5e 41 5f 5d c3 f3 90 <e9> 33 ff ff ff  
8b 83 c0 fe ff ff 3d 00 01 00 00 0f 84 e4 01 00 00
RSP: 0018:ffff88809e65f328 EFLAGS: 00000202 ORIG_RAX: ffffffffffffff13
RAX: 0000000000000000 RBX: ffff88809e65f4d0 RCX: 0000000000000004
RDX: dffffc0000000000 RSI: 0000000000000004 RDI: ffffe8ffffd719d8
RBP: ffff88809e65f4f8 R08: 1ffffd1ffffae33b R09: fffff91ffffae33c
R10: fffff91ffffae33b R11: ffffe8ffffd719db R12: ffffed1013ccbe88
R13: ffffe8ffffd719d8 R14: 0000000000000003 R15: 00000000000002f4
  pv_queued_spin_lock_slowpath arch/x86/include/asm/paravirt.h:653 [inline]
  queued_spin_lock_slowpath arch/x86/include/asm/qspinlock.h:50 [inline]
  queued_spin_lock include/asm-generic/qspinlock.h:90 [inline]
  do_raw_spin_lock+0x2af/0x360 kernel/locking/spinlock_debug.c:113
  __raw_spin_lock include/linux/spinlock_api_smp.h:143 [inline]
  _raw_spin_lock+0x37/0x40 kernel/locking/spinlock.c:144
  spin_lock include/linux/spinlock.h:329 [inline]
  nf_ct_add_to_dying_list+0xdb/0x210 net/netfilter/nf_conntrack_core.c:447
  nf_ct_delete_from_lists+0x4a2/0x6a0 net/netfilter/nf_conntrack_core.c:585
  nf_ct_delete net/netfilter/nf_conntrack_core.c:612 [inline]
  nf_ct_delete+0x2a2/0x5e0 net/netfilter/nf_conntrack_core.c:590
  nf_ct_kill include/net/netfilter/nf_conntrack.h:221 [inline]
  nf_ct_gc_expired net/netfilter/nf_conntrack_core.c:654 [inline]
  nf_ct_gc_expired+0x394/0x490 net/netfilter/nf_conntrack_core.c:648
  gc_worker+0xcc9/0x1100 net/netfilter/nf_conntrack_core.c:1176
  process_one_work+0xd0c/0x1ce0 kernel/workqueue.c:2153
  worker_thread+0x143/0x14a0 kernel/workqueue.c:2296
  kthread+0x357/0x430 kernel/kthread.c:246
  ret_from_fork+0x3a/0x50 arch/x86/entry/entry_64.S:352
rcu: INFO: rcu_preempt detected expedited stalls on CPUs/tasks: { 1-... }  
10631 jiffies s: 1297 root: 0x2/.
rcu: blocking rcu_node structures:
Task dump for CPU 1:
kworker/1:2     R  running task    22408  2980      2 0x80000008
Workqueue: events_power_efficient gc_worker
Call Trace:
  context_switch kernel/sched/core.c:2834 [inline]
  __schedule+0x89f/0x1e60 kernel/sched/core.c:3472
  atomic_try_cmpxchg include/asm-generic/atomic-instrumented.h:72 [inline]
  queued_spin_lock include/asm-generic/qspinlock.h:87 [inline]
  do_raw_spin_lock+0x156/0x360 kernel/locking/spinlock_debug.c:113


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#bug-status-tracking for how to communicate with  
syzbot.
