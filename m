From: syzbot <syzbot+9f5271e1f46f2954d29c@syzkaller.appspotmail.com>
Subject: INFO: rcu detected stall in tipc_disc_timeout
Date: Wed, 16 Jan 2019 09:01:03 -0800
Message-ID: <0000000000001908be057f963938@google.com>
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

HEAD commit:    80b3671e9377 ip6_gre: update version related info when cha..
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=151e546b400000
kernel config:  https://syzkaller.appspot.com/x/.config?x=8a4dffabfb4e36f9
dashboard link: https://syzkaller.appspot.com/bug?extid=9f5271e1f46f2954d29c
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+9f5271e1f46f2954d29c@syzkaller.appspotmail.com

Enabling of bearer <udp:syz0> rejected, already enabled
Enabling of bearer <udp:syz0> rejected, already enabled
rcu: INFO: rcu_preempt self-detected stall on CPU
rcu: 	1-....: (1 GPs behind) idle=776/1/0x4000000000000004  
softirq=84430/84432 fqs=5221
rcu: 	 (t=10500 jiffies g=117297 q=5397)
NMI backtrace for cpu 1
CPU: 1 PID: 7906 Comm: syz-fuzzer Not tainted 5.0.0-rc2+ #21
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
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
RIP: 0010:kasan_check_read+0x8/0x20 mm/kasan/common.c:100
Code: 73 58 89 c2 48 c7 c7 70 a5 3c 89 f7 da e8 04 77 a2 ff e9 c4 f5 ff ff  
90 90 90 90 90 90 90 90 90 90 90 55 89 f6 31 d2 48 89 e5 <48> 8b 4d 08 e8  
ff 23 00 00 5d c3 0f 1f 00 66 2e 0f 1f 84 00 00 00
RSP: 0000:ffff8880ae706c30 EFLAGS: 00000246 ORIG_RAX: ffffffffffffff13
RAX: 0000000000000000 RBX: ffff8880ae706de8 RCX: 0000000000000004
RDX: 0000000000000000 RSI: 0000000000000004 RDI: ffffe8ffffd6d738
RBP: ffff8880ae706c30 R08: 1ffffd1ffffadae7 R09: fffff91ffffadae8
R10: fffff91ffffadae7 R11: ffffe8ffffd6d73b R12: ffffed1015ce0dab
R13: ffffe8ffffd6d738 R14: 0000000000000003 R15: 00000000000000fc
  atomic_read include/asm-generic/atomic-instrumented.h:21 [inline]
  virt_spin_lock arch/x86/include/asm/qspinlock.h:83 [inline]
  native_queued_spin_lock_slowpath+0xfe/0x1290 kernel/locking/qspinlock.c:337
  pv_queued_spin_lock_slowpath arch/x86/include/asm/paravirt.h:653 [inline]
  queued_spin_lock_slowpath arch/x86/include/asm/qspinlock.h:50 [inline]
  queued_spin_lock include/asm-generic/qspinlock.h:90 [inline]
  do_raw_spin_lock+0x2af/0x360 kernel/locking/spinlock_debug.c:113
  __raw_spin_lock include/linux/spinlock_api_smp.h:143 [inline]
  _raw_spin_lock+0x37/0x40 kernel/locking/spinlock.c:144
  spin_lock include/linux/spinlock.h:329 [inline]
  nf_ct_add_to_unconfirmed_list net/netfilter/nf_conntrack_core.c:462  
[inline]
  init_conntrack.isra.0+0xa5c/0x1380 net/netfilter/nf_conntrack_core.c:1421
  resolve_normal_ct net/netfilter/nf_conntrack_core.c:1463 [inline]
  nf_conntrack_in+0xb95/0x1250 net/netfilter/nf_conntrack_core.c:1569
  ipv4_conntrack_local+0x169/0x210 net/netfilter/nf_conntrack_proto.c:444
  nf_hook_entry_hookfn include/linux/netfilter.h:119 [inline]
  nf_hook_slow+0xbf/0x1f0 net/netfilter/core.c:511
  nf_hook include/linux/netfilter.h:244 [inline]
  __ip_local_out+0x542/0xa90 net/ipv4/ip_output.c:113
  ip_local_out+0x2d/0x1b0 net/ipv4/ip_output.c:122
  iptunnel_xmit+0x58e/0x980 net/ipv4/ip_tunnel_core.c:91
  udp_tunnel_xmit_skb+0x236/0x310 net/ipv4/udp_tunnel.c:200
  tipc_udp_xmit.isra.0+0xa9c/0xe40 net/tipc/udp_media.c:181
  tipc_udp_send_msg+0x5b2/0x6e0 net/tipc/udp_media.c:235
  tipc_bearer_xmit_skb+0x172/0x360 net/tipc/bearer.c:503
  tipc_disc_timeout+0xb43/0x1070 net/tipc/discover.c:332
  call_timer_fn+0x254/0x900 kernel/time/timer.c:1325
  expire_timers kernel/time/timer.c:1362 [inline]
  __run_timers+0x6fc/0xd50 kernel/time/timer.c:1681
  run_timer_softirq+0x52/0xb0 kernel/time/timer.c:1694
  __do_softirq+0x30b/0xb11 kernel/softirq.c:292
  invoke_softirq kernel/softirq.c:373 [inline]
  irq_exit+0x180/0x1d0 kernel/softirq.c:413
  exiting_irq arch/x86/include/asm/apic.h:536 [inline]
  smp_apic_timer_interrupt+0x1b7/0x760 arch/x86/kernel/apic/apic.c:1062
  apic_timer_interrupt+0xf/0x20 arch/x86/entry/entry_64.S:807
  </IRQ>
RIP: 0033:0x41de97
Code: 4c 89 d1 45 89 c2 48 39 cf 0f 83 51 01 00 00 48 85 ff 0f 84 40 01 00  
00 41 83 fa 03 0f 83 2b 01 00 00 45 8d 42 01 44 0f b6 0b <49> 89 ca 44 89  
c1 41 d3 e9 48 83 ff 08 74 0b 41 0f ba e1 04 0f 83
RSP: 002b:000000c420031e80 EFLAGS: 00000246 ORIG_RAX: ffffffffffffff13
RAX: 000000c420000000 RBX: 000000c41feb6fb9 RCX: 0000000000000040
RDX: 000000c42cbb0000 RSI: 000000c4229208c0 RDI: 0000000000000000
RBP: 000000c420031f18 R08: 0000000000000000 R09: 00000000000000df
R10: 0000000000000000 R11: 000000c4229208c0 R12: 000000c42a412930
R13: 0000000000000200 R14: ffffffffffffffff R15: 0000000000000200


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#bug-status-tracking for how to communicate with  
syzbot.
