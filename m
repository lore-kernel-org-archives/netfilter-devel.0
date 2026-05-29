Received: from mail-oa1-f79.google.com (mail-oa1-f79.google.com [209.85.160.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5F453ACA5B
	for <netfilter-devel@vger.kernel.org>; Fri, 29 May 2026 19:50:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.79
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780084228; cv=none; b=MVP/OHbpssrBLMMZREemNA9DGvrRaDfdFm0/5X5zzZ/EkZsbIHSaZbT7lXQ1+Os5DgpCq1tYRZvqYq201sJgUEwfV55mxSghzkdxeSmAP9I9puF/SZgp23UYFDrNHkByfcvcZBaa1wktJ5KGotG2fhCJUjVnXSev/oAKessv4dk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780084228; c=relaxed/simple;
	bh=4cKI3OzVEC+QhsrwxEGBneTkY3RoyNTLsnJJTtOyd2k=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=J6hC1dDmOisQcU+2ytX31Li9DPaIKxZrpmeeaq6ThMHXI7ixLXVFGSNClNOS7W/bATpg8HJCPnszkirMdv1Mq7MvQDw7e29wGPfIV8XDz1TyNidN+lXGZAKgIiX518yeQk4EeQ75RmimhNjb4QUQrUxJzHLodQB+mLWqE/wcnUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.160.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oa1-f79.google.com with SMTP id 586e51a60fabf-43b599211f0so8729565fac.2
        for <netfilter-devel@vger.kernel.org>; Fri, 29 May 2026 12:50:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780084226; x=1780689026;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=IzI839ybWTlU0/60C79VveyA77L3xaWgGjlAE9/HT58=;
        b=SwbKeKx9ppm5m6QYhn5P0q7gV48MCFdp3X+1D7n0j2To4SFwU7nUkrfLdM5jQKFB+f
         Gnxy9wLm3j8dDvTbWpvcExYuTLNcgwBM1srwwJpYUKyMecFjxvJhTvklfeAvyl8iFu6v
         mbpLw9wgAxDmJ0N/sQnPuKbxmxCnjV0lWdK2Si0dN+l0D1cRsumN2ZCv0MZ1rUGOJGRk
         nN5SvOHmE/E+IDgPInqy5E1EbEFYhLRWSh3d4Vjuc635cZfPHH/w5uL7bAqhte+4Rt6T
         daWrQ91Wz+Z3r3Y2VQLjGCaz+WId7i5SBMLdvoQVkoWAl39VHI0Q3lK6YGTnpGtpTyxP
         Nc0g==
X-Forwarded-Encrypted: i=1; AFNElJ8qJF4N8jLOUEq6d5/Xckqlz8Rp/dIxF2IUDFKzKqYwSTJ4JQ60EnBHeyxwV90+W+/WAqT639jPMU2W65CM2BM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw7AmQTNcl/hrJZERPgt77aXlJ8Tranfrq0jTDWSCRGBMpABKPQ
	h587UnWccHDnPBn2Tho0/ogbC1D1IYdchTjAUAluttAleRwjG4iTBpVaEcuWwBFWeP8/t9P4+7l
	oHkoOBsb7yADNueL8cWN975SemaXj3O8JtaeIkBvJQfdEB31Z+v0CAwPwlsc=
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a4a:edc6:0:b0:69d:9e9d:b000 with SMTP id
 006d021491bc7-69e102bff96mr380821eaf.23.1780084225750; Fri, 29 May 2026
 12:50:25 -0700 (PDT)
Date: Fri, 29 May 2026 12:50:25 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a19ee01.c16d89a8.217f2c.0006.GAE@google.com>
Subject: [syzbot] [netfilter?] INFO: rcu detected stall in handle_softirqs (3)
From: syzbot <syzbot+e044a9b6370ed8ca9737@syzkaller.appspotmail.com>
To: anna-maria@linutronix.de, frederic@kernel.org, fw@strlen.de, 
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org, 
	netfilter-devel@vger.kernel.org, pablo@netfilter.org, 
	syzkaller-bugs@googlegroups.com, tglx@kernel.org
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    3baa7ba4ab98 eth: dpaa2: constify dpaa2_ethtool_stats and ..
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=15b8012e580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=35076fd17e60f52f
dashboard link: https://syzkaller.appspot.com/bug?extid=e044a9b6370ed8ca9737
compiler:       Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1308b92e580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10918086580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/05663c9a51b5/disk-3baa7ba4.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/53c6c5e94629/vmlinux-3baa7ba4.xz
kernel image: https://storage.googleapis.com/syzbot-assets/021068ae9d1c/bzImage-3baa7ba4.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+e044a9b6370ed8ca9737@syzkaller.appspotmail.com

rcu: INFO: rcu_preempt detected stalls on CPUs/tasks:
rcu: 	1-...!: (1 GPs behind) idle=1944/1/0x4000000000000000 softirq=18067/18074 fqs=140
rcu: 	(detected by 0, t=10506 jiffies, g=17221, q=496 ncpus=2)
Sending NMI from CPU 0 to CPUs 1:
NMI backtrace for cpu 1
CPU: 1 UID: 0 PID: 23 Comm: ksoftirqd/1 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 04/18/2026
RIP: 0010:hlock_class kernel/locking/lockdep.c:234 [inline]
RIP: 0010:__lock_acquire+0xa54/0x2cf0 kernel/locking/lockdep.c:5234
Code: c7 c6 96 5e 0d 8e 67 48 0f b9 3a 90 31 c0 48 83 78 40 00 0f 84 5f 1d 00 00 41 8b 45 20 25 ff 1f 00 00 48 0f a3 05 9c b0 a0 12 <73> 10 48 69 c0 c8 00 00 00 48 8d 80 70 73 e3 93 eb 32 83 3d 63 40
RSP: 0018:ffffc90000a08b40 EFLAGS: 00000047
RAX: 0000000000000000 RBX: 00000000aa3bd169 RCX: 0000000033b37d7c
RDX: 0000000000d3daf7 RSI: 000000004fa421e6 RDI: ffff88801de98000
RBP: 97064f2600000000 R08: ffffffff84bcde63 R09: ffffffff9a701a18
R10: dffffc0000000000 R11: fffff520001411ac R12: ffff88801de98c08
R13: ffff88801de98c08 R14: ffff88801de98000 R15: 0000000000000003
FS:  0000000000000000(0000) GS:ffff888125376000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fff903adf52 CR3: 00000000768b2000 CR4: 00000000003526f0
Call Trace:
 <IRQ>
 lock_acquire+0x106/0x350 kernel/locking/lockdep.c:5868
 __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:132 [inline]
 _raw_spin_lock_irqsave+0x40/0x60 kernel/locking/spinlock.c:166
 debug_object_activate+0x83/0x580 lib/debugobjects.c:835
 debug_hrtimer_activate kernel/time/hrtimer.c:485 [inline]
 debug_activate kernel/time/hrtimer.c:528 [inline]
 enqueue_hrtimer+0xa9/0x2c0 kernel/time/hrtimer.c:1109
 __run_hrtimer kernel/time/hrtimer.c:1946 [inline]
 __hrtimer_run_queues+0x4d2/0xa20 kernel/time/hrtimer.c:1994
 hrtimer_interrupt+0x44b/0x950 kernel/time/hrtimer.c:2113
 local_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1050 [inline]
 __sysvec_apic_timer_interrupt+0x102/0x430 arch/x86/kernel/apic/apic.c:1067
 instr_sysvec_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1061 [inline]
 sysvec_apic_timer_interrupt+0xa1/0xc0 arch/x86/kernel/apic/apic.c:1061
 </IRQ>
 <TASK>
 asm_sysvec_apic_timer_interrupt+0x1a/0x20 arch/x86/include/asm/idtentry.h:697
RIP: 0010:lock_acquire+0x221/0x350 kernel/locking/lockdep.c:5872
Code: ff ff ff e8 f1 3d 09 0a f7 44 24 08 00 02 00 00 0f 84 3a ff ff ff 65 48 8b 05 db e8 98 11 48 3b 44 24 58 75 33 fb 48 83 c4 60 <5b> 41 5c 41 5d 41 5e 41 5f 5d e9 40 31 0c 0a cc 48 8d 3d c8 dc 92
RSP: 0018:ffffc900001d75f8 EFLAGS: 00000282
RAX: 22a67b2282df5a00 RBX: 0000000000000000 RCX: 0000000080000100
RDX: 00000000cfbe58cb RSI: ffffffff8e22b58a RDI: ffffffff8c28b760
RBP: ffffffff8176f256 R08: ffffffff8176f256 R09: ffffffff8e95cca0
R10: ffffc900001d7758 R11: ffffffff81b0f020 R12: 0000000000000002
R13: ffffffff8e95cca0 R14: 0000000000000000 R15: 0000000000000246
 rcu_lock_acquire include/linux/rcupdate.h:300 [inline]
 rcu_read_lock include/linux/rcupdate.h:838 [inline]
 class_rcu_constructor include/linux/rcupdate.h:1181 [inline]
 unwind_next_frame+0xc3/0x2550 arch/x86/kernel/unwind_orc.c:495
 arch_stack_walk+0x11b/0x150 arch/x86/kernel/stacktrace.c:25
 stack_trace_save+0xa9/0x100 kernel/stacktrace.c:122
 kasan_save_stack mm/kasan/common.c:57 [inline]
 kasan_save_track+0x3e/0x80 mm/kasan/common.c:78
 kasan_save_free_info+0x46/0x50 mm/kasan/generic.c:584
 poison_slab_object mm/kasan/common.c:253 [inline]
 __kasan_slab_free+0x5c/0x80 mm/kasan/common.c:285
 kasan_slab_free include/linux/kasan.h:235 [inline]
 slab_free_hook mm/slub.c:2689 [inline]
 __rcu_free_sheaf_prepare+0x12d/0x2a0 mm/slub.c:2940
 rcu_free_sheaf+0x31/0x200 mm/slub.c:5849
 rcu_do_batch kernel/rcu/tree.c:2617 [inline]
 rcu_core+0x7cd/0x1070 kernel/rcu/tree.c:2869
 handle_softirqs+0x22a/0x840 kernel/softirq.c:622
 run_ksoftirqd+0x36/0x60 kernel/softirq.c:1076
 smpboot_thread_fn+0x541/0xa50 kernel/smpboot.c:160
 kthread+0x389/0x470 kernel/kthread.c:436
 ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>
rcu: rcu_preempt kthread starved for 9805 jiffies! g17221 f0x0 RCU_GP_WAIT_FQS(5) ->state=0x0 ->cpu=0
rcu: 	Unless rcu_preempt kthread gets sufficient CPU time, OOM is now expected behavior.
rcu: RCU grace-period kthread stack dump:
task:rcu_preempt     state:R  running task     stack:27544 pid:16    tgid:16    ppid:2      task_flags:0x208040 flags:0x00080000
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5388 [inline]
 __schedule+0x1821/0x5740 kernel/sched/core.c:7189
 __schedule_loop kernel/sched/core.c:7268 [inline]
 schedule+0x164/0x360 kernel/sched/core.c:7283
 schedule_timeout+0x158/0x2c0 kernel/time/sleep_timeout.c:99
 rcu_gp_fqs_loop+0x312/0x11d0 kernel/rcu/tree.c:2095
 rcu_gp_kthread+0x9e/0x2b0 kernel/rcu/tree.c:2297
 kthread+0x389/0x470 kernel/kthread.c:436
 ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>
rcu: Stack dump where RCU GP kthread last ran:
CPU: 0 UID: 0 PID: 5766 Comm: syz-executor Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 04/18/2026
RIP: 0010:csd_lock_wait kernel/smp.c:342 [inline]
RIP: 0010:smp_call_function_many_cond+0xfcf/0x13d0 kernel/smp.c:892
Code: 79 45 8b 2e 44 89 ee 83 e6 01 31 ff e8 7a 06 0c 00 41 83 e5 01 49 bd 00 00 00 00 00 fc ff df 75 07 e8 25 02 0c 00 eb 37 f3 90 <43> 0f b6 04 2c 84 c0 75 10 41 f7 06 01 00 00 00 74 1e e8 0a 02 0c
RSP: 0018:ffffc9000466f440 EFLAGS: 00000293
RAX: ffffffff81b9c2b6 RBX: ffff8880b863c148 RCX: ffff88802e6c3d80
RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000000
RBP: ffffc9000466f580 R08: ffffffff903135f7 R09: 1ffffffff20626be
R10: dffffc0000000000 R11: fffffbfff20626bf R12: 1ffff110170e8169
R13: dffffc0000000000 R14: ffff8880b8740b48 R15: 0000000000000001
FS:  0000000000000000(0000) GS:ffff888125276000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000555591cba4e8 CR3: 000000000e74a000 CR4: 00000000003526f0
Call Trace:
 <TASK>
 on_each_cpu_cond_mask+0x3f/0x80 kernel/smp.c:1057
 __flush_tlb_multi arch/x86/include/asm/paravirt.h:46 [inline]
 flush_tlb_multi arch/x86/mm/tlb.c:1361 [inline]
 flush_tlb_mm_range+0x5c3/0x10b0 arch/x86/mm/tlb.c:1451
 tlb_flush arch/x86/include/asm/tlb.h:23 [inline]
 tlb_flush_mmu_tlbonly include/asm-generic/tlb.h:509 [inline]
 tlb_flush_mmu+0x1af/0xa30 mm/mmu_gather.c:423
 tlb_finish_mmu+0xf9/0x230 mm/mmu_gather.c:549
 free_ldt_pgtables+0x19d/0x350 arch/x86/kernel/ldt.c:411
 arch_exit_mmap arch/x86/include/asm/mmu_context.h:229 [inline]
 exit_mmap+0x1af/0x9e0 mm/mmap.c:1285
 __mmput+0x118/0x430 kernel/fork.c:1178
 exit_mm+0x1f6/0x2d0 kernel/exit.c:582
 do_exit+0x6a2/0x22c0 kernel/exit.c:964
 do_group_exit+0x21b/0x2d0 kernel/exit.c:1119
 get_signal+0x1284/0x1330 kernel/signal.c:3037
 arch_do_signal_or_restart+0xbc/0x840 arch/x86/kernel/signal.c:337
 __exit_to_user_mode_loop kernel/entry/common.c:64 [inline]
 exit_to_user_mode_loop+0x8c/0x4d0 kernel/entry/common.c:98
 __exit_to_user_mode_prepare include/linux/irq-entry-common.h:207 [inline]
 syscall_exit_to_user_mode_prepare include/linux/irq-entry-common.h:230 [inline]
 syscall_exit_to_user_mode include/linux/entry-common.h:318 [inline]
 do_syscall_64+0x33e/0xf80 arch/x86/entry/syscall_64.c:100
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fee6db57fd7
Code: Unable to access opcode bytes at 0x7fee6db57fad.
RSP: 002b:00007ffdf5f33f60 EFLAGS: 00000202 ORIG_RAX: 000000000000003d
RAX: fffffffffffffe00 RBX: 0000555591cba500 RCX: 00007fee6db57fd7
RDX: 0000000040000000 RSI: 00007ffdf5f33fbc RDI: ffffffffffffffff
RBP: 00007ffdf5f33fbc R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000202 R12: 00007ffdf5f34038
R13: 0000000000000002 R14: 00007ffdf5f34218 R15: 0000000000000000
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
