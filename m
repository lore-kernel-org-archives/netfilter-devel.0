Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC55012F5B3
	for <netfilter-devel@vger.kernel.org>; Sat, 12 Oct 2024 07:17:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728717455; cv=none; b=RSiBB+Z0WZdcOvfjZHtBN3tp/lSDgFWhE0AYA4Ljea1jkLhADhuIvpST5VDzusEql17q53y+h4ygjjLvPBwIyAP/zdtEJB42CWJCoYyPR/dAEmhPDk0Y4yL/K1/BXM7QHVe/dfwdELgiLdmC/ukZJ6iMHFKlzpTBca4et8TJLmA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728717455; c=relaxed/simple;
	bh=TtXHe36EBMtczZIOhAyOxIMyX0X8nZTLsEu0NrQ4Rp0=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=jmXEuUhv8CMqoepgqWbTQ9+Ei5GelqspIVRs6e53ayQMnasHkTlymRafGSmaLmoFRLpaFJVKtE8d6qEQQhOY4ZddBKG3pPzX/6Jctw3d5xypyDfJeb3rj4JprWZWXezvbCgvok8stUoSPqjU5TJm0OJ5sGrjhjwvgaiQVNNz694=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-3a0ce7e621aso23139965ab.1
        for <netfilter-devel@vger.kernel.org>; Sat, 12 Oct 2024 00:17:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728717453; x=1729322253;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rYnpbRxiIHqjokjg/LOm8GPBmJhp5qj5PMQSXr29vhE=;
        b=p24bH8/LVaE6klTtnG4m2oAaiGB8mFHUO5AzZJOBiPpsWXFwYADCYN+YI5aR11Msi5
         QMY71Cwnq0Ip9qDpabE9uIm030N8abPj81LtMB80Jukg+7FY9vKhmHLX7+62ZN0EbcDX
         cbRnII8FMX6E1JRsKNsdFXMpvl/49pchhZjYPUDJTO/RxyZY/xxHYv3rIrx0RDdH4Gor
         U1qv2fOr6sibW5jfHUDcJlHRTUtCyBY2LeBdRaAE0u0DgS/EK2yGlSaYvdmlTfy4m678
         MEtAV/cktclWhd0BCQit6b80T/i7KgNRKvD8ZFxDTQJCQOX2EagFdFKGEyYOvIqDO0/1
         hrLw==
X-Forwarded-Encrypted: i=1; AJvYcCUvUw8K0TVjTmmdv8OpUV62ELGstzO0PmsDH7u8PqA8G0tnU9wykjf2CEDgLv97JG+2Lq9m3VFJ8xgtZ9z5Dak=@vger.kernel.org
X-Gm-Message-State: AOJu0YwvwoDLIJwzo/ykhInZhXCjzD7CSt3u6uXjMlgUTE1laTlpjrZi
	vhe/GZm9/SgDX8yfaEqKMeox9N+5yYGGmAfS7Hurj6L/KkcUZE8o41fx0tuLwLBxESbmF5pzHYq
	vpqefESCe1ZjjHDbQWKoyK1uYnxf3Gua9Q4sCklRbuoqomDfy5DwKl+w=
X-Google-Smtp-Source: AGHT+IG6YFCVvG72B3C66uba1lq+gd5R8LdyFvxAVL2OOx3eahXrGYslhjQaVGaLJd7+elA+/1HplXMelysNr/5C2w1ILkGMlxvW
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1d10:b0:3a3:b4ec:b3f1 with SMTP id
 e9e14a558f8ab-3a3b5fb0325mr27757775ab.17.1728717452942; Sat, 12 Oct 2024
 00:17:32 -0700 (PDT)
Date: Sat, 12 Oct 2024 00:17:32 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <670a228c.050a0220.3e960.0020.GAE@google.com>
Subject: [syzbot] [bridge?] INFO: rcu detected stall in br_handle_frame (5)
From: syzbot <syzbot+c596faae21a68bf7afd0@syzkaller.appspotmail.com>
To: bridge@lists.linux.dev, coreteam@netfilter.org, davem@davemloft.net, 
	edumazet@google.com, kadlec@netfilter.org, kuba@kernel.org, 
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org, 
	netfilter-devel@vger.kernel.org, pabeni@redhat.com, pablo@netfilter.org, 
	razor@blackwall.org, roopa@nvidia.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    1405981bbba0 lib: packing: catch kunit_kzalloc() failure i..
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=1489bb80580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=f95955e3f7b5790c
dashboard link: https://syzkaller.appspot.com/bug?extid=c596faae21a68bf7afd0
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17808f9f980000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/34f62132d43f/disk-1405981b.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/872fb3b1af67/vmlinux-1405981b.xz
kernel image: https://storage.googleapis.com/syzbot-assets/493188519750/bzImage-1405981b.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+c596faae21a68bf7afd0@syzkaller.appspotmail.com

bridge0: received packet on veth0_to_bridge with own address as source address (addr:6e:a5:51:5e:bc:50, vlan:0)
rcu: INFO: rcu_preempt detected stalls on CPUs/tasks:
rcu: 	(detected by 1, t=10502 jiffies, g=8089, q=1074 ncpus=2)
rcu: All QSes seen, last rcu_preempt kthread activity 8424 (4294972116-4294963692), jiffies_till_next_fqs=1, root ->qsmask 0x0
rcu: rcu_preempt kthread starved for 8425 jiffies! g8089 f0x2 RCU_GP_WAIT_FQS(5) ->state=0x0 ->cpu=0
rcu: 	Unless rcu_preempt kthread gets sufficient CPU time, OOM is now expected behavior.
rcu: RCU grace-period kthread stack dump:
task:rcu_preempt     state:R  running task     stack:25952 pid:17    tgid:17    ppid:2      flags:0x00004000
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5315 [inline]
 __schedule+0x1895/0x4b30 kernel/sched/core.c:6675
 __schedule_loop kernel/sched/core.c:6752 [inline]
 schedule+0x14b/0x320 kernel/sched/core.c:6767
 schedule_timeout+0x1be/0x310 kernel/time/timer.c:2615
 rcu_gp_fqs_loop+0x2df/0x1330 kernel/rcu/tree.c:2045
 rcu_gp_kthread+0xa7/0x3b0 kernel/rcu/tree.c:2247
 kthread+0x2f0/0x390 kernel/kthread.c:389
 ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
 </TASK>
rcu: Stack dump where RCU GP kthread last ran:
Sending NMI from CPU 1 to CPUs 0:
NMI backtrace for cpu 0
CPU: 0 UID: 0 PID: 5350 Comm: kworker/0:3 Not tainted 6.12.0-rc1-syzkaller-00242-g1405981bbba0 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/13/2024
Workqueue: events nsim_dev_trap_report_work
RIP: 0010:task_tick_fair+0x282/0x7c0 kernel/sched/fair.c:13046
Code: 89 e7 e8 01 d3 96 00 4d 39 34 24 75 60 48 81 c3 78 01 00 00 48 89 d8 48 c1 e8 03 42 80 3c 28 00 74 08 48 89 df e8 de d2 96 00 <48> 8b 3b 83 7c 24 08 00 74 07 e8 9f 6f fb ff eb 0c 48 81 c7 40 0d
RSP: 0018:ffffc900000067c8 EFLAGS: 00000046
RAX: 1ffff110170c7d97 RBX: ffff8880b863ecb8 RCX: 000000000008c5a2
RDX: 000000000008c5a2 RSI: dffffc0000000000 RDI: ffff8880b863eb54
RBP: ffff888071fc5b28 R08: ffffffff901ce76f R09: 1ffffffff2039ced
R10: dffffc0000000000 R11: ffffffff8167b790 R12: ffff888071fc5a80
R13: dffffc0000000000 R14: 0000000000000000 R15: dffffc0000000000
FS:  0000000000000000(0000) GS:ffff8880b8600000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f8e57107ab8 CR3: 0000000077f18000 CR4: 00000000003526f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <NMI>
 </NMI>
 <IRQ>
 sched_tick+0x219/0x610 kernel/sched/core.c:5593
 update_process_times+0x202/0x230 kernel/time/timer.c:2524
 tick_sched_handle kernel/time/tick-sched.c:276 [inline]
 tick_nohz_handler+0x37c/0x500 kernel/time/tick-sched.c:297
 __run_hrtimer kernel/time/hrtimer.c:1691 [inline]
 __hrtimer_run_queues+0x551/0xd50 kernel/time/hrtimer.c:1755
 hrtimer_interrupt+0x396/0x990 kernel/time/hrtimer.c:1817
 local_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1026 [inline]
 __sysvec_apic_timer_interrupt+0x110/0x3f0 arch/x86/kernel/apic/apic.c:1043
 instr_sysvec_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1037 [inline]
 sysvec_apic_timer_interrupt+0x52/0xc0 arch/x86/kernel/apic/apic.c:1037
 asm_sysvec_apic_timer_interrupt+0x1a/0x20 arch/x86/include/asm/idtentry.h:702
RIP: 0010:trace_kmem_cache_alloc+0x18/0xc0 include/trace/events/kmem.h:12
Code: 00 00 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 66 90 65 8b 05 f3 54 11 7e 83 f8 08 73 23 89 c0 48 0f a3 05 80 64 2a 0e <73> 12 e8 21 41 88 ff 84 c0 75 09 f6 05 0a 22 14 0e 01 74 0b c3 cc
RSP: 0018:ffffc90000006c80 EFLAGS: 00000293
RAX: 0000000000000000 RBX: ffff8881a6f96d00 RCX: 0000000000000820
RDX: ffff888141ae13c0 RSI: ffff8881a6f96d00 RDI: ffffffff898d7336
RBP: 0000000000000000 R08: 00000000ffffffff R09: 0000000000000000
R10: ffff8881a6f96d00 R11: ffffffff81808f50 R12: 00000000000000b8
R13: ffff888141ae13c0 R14: 0000000000000820 R15: ffffffff898d7336
 kmem_cache_alloc_noprof+0x185/0x2a0 mm/slub.c:4145
 skb_ext_maybe_cow net/core/skbuff.c:6942 [inline]
 skb_ext_add+0x1d6/0x910 net/core/skbuff.c:7016
 nf_bridge_unshare net/bridge/br_netfilter_hooks.c:168 [inline]
 br_nf_forward_ip+0xd8/0x7b0 net/bridge/br_netfilter_hooks.c:710
 nf_hook_entry_hookfn include/linux/netfilter.h:154 [inline]
 nf_hook_slow+0xc3/0x220 net/netfilter/core.c:626
 nf_hook include/linux/netfilter.h:269 [inline]
 NF_HOOK+0x2a7/0x460 include/linux/netfilter.h:312
 __br_forward+0x489/0x660 net/bridge/br_forward.c:115
 deliver_clone net/bridge/br_forward.c:131 [inline]
 maybe_deliver+0xb3/0x150 net/bridge/br_forward.c:190
 br_flood+0x2e4/0x660 net/bridge/br_forward.c:236
 br_handle_frame_finish+0x18ba/0x1fe0 net/bridge/br_input.c:215
 br_nf_hook_thresh+0x472/0x590
 br_nf_pre_routing_finish_ipv6+0xaa0/0xdd0
 NF_HOOK include/linux/netfilter.h:314 [inline]
 br_nf_pre_routing_ipv6+0x379/0x770 net/bridge/br_netfilter_ipv6.c:184
 nf_hook_entry_hookfn include/linux/netfilter.h:154 [inline]
 nf_hook_bridge_pre net/bridge/br_input.c:277 [inline]
 br_handle_frame+0x9fd/0x1530 net/bridge/br_input.c:424
 __netif_receive_skb_core+0x13e8/0x4570 net/core/dev.c:5560
 __netif_receive_skb_one_core net/core/dev.c:5664 [inline]
 __netif_receive_skb+0x12f/0x650 net/core/dev.c:5779
 process_backlog+0x662/0x15b0 net/core/dev.c:6111
 __napi_poll+0xcb/0x490 net/core/dev.c:6775
 napi_poll net/core/dev.c:6844 [inline]
 net_rx_action+0x89b/0x1240 net/core/dev.c:6966
 handle_softirqs+0x2c5/0x980 kernel/softirq.c:554
 do_softirq+0x11b/0x1e0 kernel/softirq.c:455
 </IRQ>
 <TASK>
 __local_bh_enable_ip+0x1bb/0x200 kernel/softirq.c:382
 spin_unlock_bh include/linux/spinlock.h:396 [inline]
 nsim_dev_trap_report drivers/net/netdevsim/dev.c:820 [inline]
 nsim_dev_trap_report_work+0x75d/0xaa0 drivers/net/netdevsim/dev.c:850
 process_one_work kernel/workqueue.c:3229 [inline]
 process_scheduled_works+0xa63/0x1850 kernel/workqueue.c:3310
 worker_thread+0x870/0xd30 kernel/workqueue.c:3391
 kthread+0x2f0/0x390 kernel/kthread.c:389
 ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
 </TASK>
net_ratelimit: 22358 callbacks suppressed
bridge0: received packet on bridge_slave_0 with own address as source address (addr:aa:aa:aa:aa:aa:0c, vlan:0)
bridge0: received packet on bridge_slave_0 with own address as source address (addr:aa:aa:aa:aa:aa:1b, vlan:0)
bridge0: received packet on veth0_to_bridge with own address as source address (addr:aa:aa:aa:aa:aa:0c, vlan:0)
bridge0: received packet on veth0_to_bridge with own address as source address (addr:6e:a5:51:5e:bc:50, vlan:0)
bridge0: received packet on bridge_slave_0 with own address as source address (addr:aa:aa:aa:aa:aa:1b, vlan:0)
bridge0: received packet on bridge_slave_0 with own address as source address (addr:aa:aa:aa:aa:aa:0c, vlan:0)
bridge0: received packet on bridge_slave_0 with own address as source address (addr:aa:aa:aa:aa:aa:1b, vlan:0)
bridge0: received packet on bridge_slave_0 with own address as source address (addr:aa:aa:aa:aa:aa:0c, vlan:0)
bridge0: received packet on veth0_to_bridge with own address as source address (addr:ca:e3:c2:99:e2:22, vlan:0)
bridge0: received packet on bridge_slave_0 with own address as source address (addr:aa:aa:aa:aa:aa:0c, vlan:0)


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.

If the report is already addressed, let syzbot know by replying with:
#syz fix: exact-commit-title

If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.

If you want to overwrite report's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the report is a duplicate of another one, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup
