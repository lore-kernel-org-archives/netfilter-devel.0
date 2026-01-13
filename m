Received: from mail-oo1-f80.google.com (mail-oo1-f80.google.com [209.85.161.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B549E30EF88
	for <netfilter-devel@vger.kernel.org>; Tue, 13 Jan 2026 18:06:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768327588; cv=none; b=KzmJQrAaVwIfuZaifVs30SSgHp4P8GBP0alQDmESshoGEz+1/pilsQcCsv5g6O+5AP6/v754oXi+CCo82tSzMkOxjcmQIVNoFIlyAiPYTeG2fxkzpCRioJQQTl+xsPVBAlIhWkOwZCtBUN0AfG3t5xvEuCyf+dVGe1hDObTLGGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768327588; c=relaxed/simple;
	bh=pLTO+XZIUa0VX3iogiRJDvqFsnY3vFJd98Zib6H02Bs=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=euZxru8Mo6qy2ByvCf3R6qDj2aAuask04V4VzDPms6mIleHwuwDYZNh9yOpTxLvsrqh3T7D258Vct2CpXxjrFeSj7G0LDKiVtB/35+zfhzyuj0ONLybecNOnqLR5t45XsrD468Iuh2HhDL4q3A2KozehfTIx4y2ElOChnPTShzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f80.google.com with SMTP id 006d021491bc7-656cc4098f3so16602575eaf.2
        for <netfilter-devel@vger.kernel.org>; Tue, 13 Jan 2026 10:06:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768327585; x=1768932385;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2AeiBtUGtTF1FdzbrsNXuUrvDkJx671OyYLEcVvL3hk=;
        b=OBUk9OfZDmJVHXwNMvDhIC/SQpUdUhHxLa45xDBq7VksUqhmcW43wlJD8D+z5qrSWQ
         F1wNA2VXZzozOnBfxQZv9er+f4PDP+Z7mEsbMWSLDu98AjZPZWd84W4wGQYMjYXxwkYz
         cbYv8pCoX8/bKSbd639HO15+ZdQiuUr5g4j/CbKcBMYVy9drlrz573A4Yj7b17Q3+JQv
         boKqk+75Bb2K6/5Uw1JSJ3f6pglB5Wm4nRcwPibO9WefOfEJ/RLqwqlTbhR3JEBm/Np+
         cZJOc2t9V2gvbHdlzBFsoIkVabR2P2ZuXxkIx8udhuL2iLAMGEXQQz4ol5ARYFNHJD7E
         /59Q==
X-Forwarded-Encrypted: i=1; AJvYcCVQOV/244iIFR/frkjVOBEseVNjO06TWj0gEc5370xrDdWmjYucHbXDA7MoTmOsm/77cKd0fRdpdarkK3+nLco=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzu3rO/ryD7/0stOuaLL4lAR+/DVPxB/46dPx4OICKRuo1MvShp
	OxAKxQFoMq5ytNZjpzCoXg8MpWv0NTLNCmHvppx6fW5IUolbfgywK4WFgyZRIWg+b5iMf7+sw6Q
	Bx8KNpkXrHEJdSCPOK60uyTlLJSsyyIFtFGme82zozGN0b06i19deWWgPsK8=
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:518c:b0:65f:68f5:1a17 with SMTP id
 006d021491bc7-66100621a53mr29525eaf.4.1768327585686; Tue, 13 Jan 2026
 10:06:25 -0800 (PST)
Date: Tue, 13 Jan 2026 10:06:25 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <696689a1.a70a0220.2cc00b.0001.GAE@google.com>
Subject: [syzbot] [bridge?] INFO: rcu detected stall in br_handle_frame (6)
From: syzbot <syzbot+f8850bc3986562f79619@syzkaller.appspotmail.com>
To: bridge@lists.linux.dev, coreteam@netfilter.org, davem@davemloft.net, 
	edumazet@google.com, fw@strlen.de, horms@kernel.org, idosch@nvidia.com, 
	kadlec@netfilter.org, kuba@kernel.org, linux-kernel@vger.kernel.org, 
	netdev@vger.kernel.org, netfilter-devel@vger.kernel.org, pabeni@redhat.com, 
	pablo@netfilter.org, phil@nwl.cc, razor@blackwall.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    f83a4f2a4d8c Merge tag 'erofs-for-6.17-rc6-fixes' of git:/..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=17d98762580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=4d8792ecb6308d0f
dashboard link: https://syzkaller.appspot.com/bug?extid=f8850bc3986562f79619
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=102d3b62580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=174fb934580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/446b6da00381/disk-f83a4f2a.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/acc2d4e8a1cc/vmlinux-f83a4f2a.xz
kernel image: https://storage.googleapis.com/syzbot-assets/cec01f1ca35a/bzImage-f83a4f2a.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+f8850bc3986562f79619@syzkaller.appspotmail.com

rcu: INFO: rcu_preempt detected stalls on CPUs/tasks:
rcu: 	0-...!: (2 ticks this GP) idle=e7fc/1/0x4000000000000000 softirq=18961/18961 fqs=0
rcu: 	(detected by 1, t=10502 jiffies, g=12417, q=367 ncpus=2)
Sending NMI from CPU 1 to CPUs 0:
NMI backtrace for cpu 0
CPU: 0 UID: 0 PID: 807 Comm: kworker/u8:5 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 08/18/2025
Workqueue: ipv6_addrconf addrconf_dad_work
RIP: 0010:taprio_set_budgets+0x12b/0x3b0 net/sched/sch_taprio.c:671
Code: e8 48 c1 e8 03 48 89 44 24 10 31 db 45 31 e4 4c 89 6c 24 18 bf 10 00 00 00 4c 89 e6 e8 8e 70 24 f8 49 83 fc 0f 48 89 6c 24 30 <0f> 87 8a 01 00 00 4d 8d 2c 2f 4c 89 e8 48 c1 e8 03 48 b9 00 00 00
RSP: 0018:ffffc90000006060 EFLAGS: 00000093
RAX: ffffffff899b5352 RBX: 0000000000000000 RCX: ffff88802481bc00
RDX: 0000000000010100 RSI: 0000000000000000 RDI: 0000000000000010
RBP: 0000000000000000 R08: 0000000000000003 R09: 0000000000000004
R10: dffffc0000000000 R11: fffff52000000c08 R12: 0000000000000000
R13: ffff8880313e32e0 R14: ffff8880743df930 R15: ffff8880743dfc00
FS:  0000000000000000(0000) GS:ffff888125c15000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055556d266808 CR3: 000000007e704000 CR4: 00000000003526f0
Call Trace:
 <IRQ>
 advance_sched+0x963/0xc90 net/sched/sch_taprio.c:982
 __run_hrtimer kernel/time/hrtimer.c:1761 [inline]
 __hrtimer_run_queues+0x52c/0xc60 kernel/time/hrtimer.c:1825
 hrtimer_interrupt+0x45b/0xaa0 kernel/time/hrtimer.c:1887
 local_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1039 [inline]
 __sysvec_apic_timer_interrupt+0x108/0x410 arch/x86/kernel/apic/apic.c:1056
 instr_sysvec_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1050 [inline]
 sysvec_apic_timer_interrupt+0x52/0xc0 arch/x86/kernel/apic/apic.c:1050
 asm_sysvec_apic_timer_interrupt+0x1a/0x20 arch/x86/include/asm/idtentry.h:702
RIP: 0010:stack_trace_consume_entry+0x5/0x280 kernel/stacktrace.c:83
Code: f0 5b 41 5e 5d c3 cc cc cc cc cc e8 05 fc cd 09 0f 1f 44 00 00 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 f3 0f 1e fa 55 <41> 57 41 56 41 55 41 54 53 48 83 ec 18 48 ba 00 00 00 00 00 fc ff
RSP: 0018:ffffc90000006518 EFLAGS: 00000286
RAX: ffffffff8184f87d RBX: ffffc900000065e0 RCX: 7a67f0fb8b1bf500
RDX: 0000000000000001 RSI: ffffffff8184f87d RDI: ffffc900000065e0
RBP: ffffc900000065b0 R08: ffffc90003387170 R09: 0000000000000000
R10: ffffc90000006578 R11: ffffffff81ac4b00 R12: ffff88802481bc00
R13: 0000000000000000 R14: ffffffff81ac4b00 R15: ffffc90000006528
 arch_stack_walk+0x10d/0x150 arch/x86/kernel/stacktrace.c:27
 stack_trace_save+0x9c/0xe0 kernel/stacktrace.c:122
 kasan_save_stack mm/kasan/common.c:47 [inline]
 kasan_save_track+0x3e/0x80 mm/kasan/common.c:68
 kasan_save_free_info+0x46/0x50 mm/kasan/generic.c:576
 poison_slab_object mm/kasan/common.c:243 [inline]
 __kasan_slab_free+0x5b/0x80 mm/kasan/common.c:275
 kasan_slab_free include/linux/kasan.h:233 [inline]
 slab_free_hook mm/slub.c:2422 [inline]
 slab_free mm/slub.c:4695 [inline]
 kmem_cache_free+0x18f/0x400 mm/slub.c:4797
 skb_ext_del include/linux/skbuff.h:4929 [inline]
 nf_bridge_info_free net/bridge/br_netfilter_hooks.c:156 [inline]
 br_nf_dev_queue_xmit+0x4ee/0x24a0 net/bridge/br_netfilter_hooks.c:851
 NF_HOOK+0x618/0x6b0 include/linux/netfilter.h:318
 br_nf_post_routing+0xb66/0xfe0 net/bridge/br_netfilter_hooks.c:966
 nf_hook_entry_hookfn include/linux/netfilter.h:158 [inline]
 nf_hook_slow+0xc5/0x220 net/netfilter/core.c:623
 nf_hook include/linux/netfilter.h:273 [inline]
 NF_HOOK+0x215/0x3c0 include/linux/netfilter.h:316
 br_forward_finish+0xd3/0x130 net/bridge/br_forward.c:66
 br_nf_hook_thresh net/bridge/br_netfilter_hooks.c:-1 [inline]
 br_nf_forward_finish+0xa40/0xe60 net/bridge/br_netfilter_hooks.c:662
 NF_HOOK+0x618/0x6b0 include/linux/netfilter.h:318
 br_nf_forward_ip+0x647/0x7e0 net/bridge/br_netfilter_hooks.c:716
 nf_hook_entry_hookfn include/linux/netfilter.h:158 [inline]
 nf_hook_slow+0xc5/0x220 net/netfilter/core.c:623
 nf_hook include/linux/netfilter.h:273 [inline]
 NF_HOOK+0x215/0x3c0 include/linux/netfilter.h:316
 __br_forward+0x41e/0x600 net/bridge/br_forward.c:115
 br_handle_frame_finish+0x14b4/0x19b0 net/bridge/br_input.c:221
 br_nf_hook_thresh+0x3c3/0x4a0 net/bridge/br_netfilter_hooks.c:-1
 br_nf_pre_routing_finish_ipv6+0x948/0xd00 net/bridge/br_netfilter_ipv6.c:-1
 NF_HOOK include/linux/netfilter.h:318 [inline]
 br_nf_pre_routing_ipv6+0x37e/0x6b0 net/bridge/br_netfilter_ipv6.c:184
 nf_hook_entry_hookfn include/linux/netfilter.h:158 [inline]
 nf_hook_bridge_pre net/bridge/br_input.c:283 [inline]
 br_handle_frame+0x982/0x14c0 net/bridge/br_input.c:434
 __netif_receive_skb_core+0x10b6/0x4020 net/core/dev.c:5878
 __netif_receive_skb_one_core net/core/dev.c:5989 [inline]
 __netif_receive_skb+0x72/0x380 net/core/dev.c:6104
 process_backlog+0x60e/0x14f0 net/core/dev.c:6456
 __napi_poll+0xc7/0x360 net/core/dev.c:7506
 napi_poll net/core/dev.c:7569 [inline]
 net_rx_action+0x707/0xe30 net/core/dev.c:7696
 handle_softirqs+0x283/0x870 kernel/softirq.c:579
 do_softirq+0xec/0x180 kernel/softirq.c:480
 </IRQ>
 <TASK>
 __local_bh_enable_ip+0x17d/0x1c0 kernel/softirq.c:407
 local_bh_enable include/linux/bottom_half.h:33 [inline]
 rcu_read_unlock_bh include/linux/rcupdate.h:910 [inline]
 __dev_queue_xmit+0x1d79/0x3b50 net/core/dev.c:4752
 neigh_output include/net/neighbour.h:547 [inline]
 ip6_finish_output2+0x11fb/0x16a0 net/ipv6/ip6_output.c:141
 NF_HOOK include/linux/netfilter.h:318 [inline]
 ndisc_send_skb+0xb54/0x1440 net/ipv6/ndisc.c:512
 ndisc_send_ns+0xcb/0x150 net/ipv6/ndisc.c:670
 addrconf_dad_work+0xaae/0x14b0 net/ipv6/addrconf.c:4282
 process_one_work kernel/workqueue.c:3236 [inline]
 process_scheduled_works+0xae1/0x17b0 kernel/workqueue.c:3319
 worker_thread+0x8a0/0xda0 kernel/workqueue.c:3400
 kthread+0x70e/0x8a0 kernel/kthread.c:463
 ret_from_fork+0x436/0x7d0 arch/x86/kernel/process.c:148
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>
rcu: rcu_preempt kthread timer wakeup didn't happen for 10501 jiffies! g12417 f0x0 RCU_GP_WAIT_FQS(5) ->state=0x402
rcu: 	Possible timer handling issue on cpu=0 timer-softirq=3323
rcu: rcu_preempt kthread starved for 10502 jiffies! g12417 f0x0 RCU_GP_WAIT_FQS(5) ->state=0x402 ->cpu=0
rcu: 	Unless rcu_preempt kthread gets sufficient CPU time, OOM is now expected behavior.
rcu: RCU grace-period kthread stack dump:
task:rcu_preempt     state:I stack:26632 pid:16    tgid:16    ppid:2      task_flags:0x208040 flags:0x00004000
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5357 [inline]
 __schedule+0x1798/0x4cc0 kernel/sched/core.c:6961
 __schedule_loop kernel/sched/core.c:7043 [inline]
 schedule+0x165/0x360 kernel/sched/core.c:7058
 schedule_timeout+0x12b/0x270 kernel/time/sleep_timeout.c:99
 rcu_gp_fqs_loop+0x301/0x1540 kernel/rcu/tree.c:2083
 rcu_gp_kthread+0x99/0x390 kernel/rcu/tree.c:2285
 kthread+0x70e/0x8a0 kernel/kthread.c:463
 ret_from_fork+0x436/0x7d0 arch/x86/kernel/process.c:148
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>


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
