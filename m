Received: from mail-io1-f69.google.com (mail-io1-f69.google.com [209.85.166.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 929C516FF2B
	for <netfilter-devel@vger.kernel.org>; Thu,  2 May 2024 18:15:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714673728; cv=none; b=EP4h8KaR/F7g4IGWfxf9TUsqFOimPl/6paAKancBOLfX6e9LxIH3wkgGmEXcAA4JztboDDkEW2Db2xtpdN/i+ACKydmHfmflnP2kwFgHcC35s8dn8ZdG94CxGeIg1iFD+CqaUjzdZ7Sn9HOFnQUO9IEaNHo/TcwSac3k9xdQQ6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714673728; c=relaxed/simple;
	bh=B+AEgSrImoxMG3JNPasALH1NU4yOSbtYW7dTITD570A=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=IfnpXC0T7Hdz80E6iLkF3I6z2AxhoBdgPeYN+7QJDIJ609OZckw+hTH2jxi/1RJREbcho3/IL5EwtList7kKRz2mMxGVxYfsC4Kd5fFluFosklfN8J3lumarwtu5loo1TxKHbOQp5Qw+PL0SMFyc74SrvQ8kK+IqfBNH6zs/Lno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-7dec81b8506so567363539f.2
        for <netfilter-devel@vger.kernel.org>; Thu, 02 May 2024 11:15:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714673725; x=1715278525;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rkV1hvBTUEVgIZeAIO5qPy+bLhfXMGCLMSOvL4R+62w=;
        b=DG1YoVIdrHEbjYiJbr5g8xxiiMHAk8UNlvr8I7EzuvusvQdsaPPG4RFAMSXptCgxAV
         5ZPj6BtZuZiuXLwSLqgTGP3YW1wcT7JcH07tQim2t8GY3xl+623TVP2c3dxyhESx+4cR
         nBHgM5PbsVcTr1pn1oEr60qA6xBLvlGJzhpzNcsCWks9s79+bUzFSc2SDPqkCc+WNey1
         VjaLUbzTfnp8e8YM/MRXALjx2LVP94+qoLWQkx32aQwBe2EccschYa5CeI0WAgJcJH42
         ZWcKffaj7yBpRkntaxLVNDGdc8ePXBqPDXBuUfc47p9Awgv9qkP7qesdroCmb9jpLrXA
         zpTw==
X-Forwarded-Encrypted: i=1; AJvYcCUG4HTq3eHcSZ1TgQgcl5lOwiFF2KwXubX4h34DUdQfkB540lBDehGUAFdfEVrafMBAV4aTk2FWSQDviTQOycVaey8RPHLocGWQnxxRU8wn
X-Gm-Message-State: AOJu0Yz6BC7N8H6sImcQmxyobsSDJsIqDkSiD18wmg/6uG8i/uUTFphB
	wgZhQ7pAeD6cdRF1UUR+r3BskPP1pe81nUXX6k3nzz9gG07+apgeRhAOVonz0uJY6+LkWFGjnqs
	Gd2p3FHvTEWINTtnvrcvV26TLncMQ8mx92P8MJdX0FhDpLarr1Kc9PDM=
X-Google-Smtp-Source: AGHT+IHMCTmGWmSW2YdsLMh0GsH6rDyactqBacyaXMAcHpU000fVC7Czu0WNrx3/o8e2jNHKLGzZ1jU2DGIwaUSNqRgQdSWKN5O9
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6638:9412:b0:487:8899:de17 with SMTP id
 ky18-20020a056638941200b004878899de17mr17269jab.3.1714673725114; Thu, 02 May
 2024 11:15:25 -0700 (PDT)
Date: Thu, 02 May 2024 11:15:25 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000004a9b3506177c96d5@google.com>
Subject: [syzbot] [netfilter?] WARNING: suspicious RCU usage in br_mst_set_state
From: syzbot <syzbot+fa04eb8a56fd923fc5d8@syzkaller.appspotmail.com>
To: kadlec@netfilter.org, linux-kernel@vger.kernel.org, netdev@vger.kernel.org, 
	netfilter-devel@vger.kernel.org, pablo@netfilter.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    e67572cd2204 Linux 6.9-rc6
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=16ec5c40980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d2f00edef461175
dashboard link: https://syzkaller.appspot.com/bug?extid=fa04eb8a56fd923fc5d8
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/7ece3eebb82c/disk-e67572cd.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/81b1e26c57c9/vmlinux-e67572cd.xz
kernel image: https://storage.googleapis.com/syzbot-assets/be9561f066e4/bzImage-e67572cd.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+fa04eb8a56fd923fc5d8@syzkaller.appspotmail.com

=============================
WARNING: suspicious RCU usage
6.9.0-rc6-syzkaller #0 Not tainted
-----------------------------
net/bridge/br_private.h:1599 suspicious rcu_dereference_protected() usage!

other info that might help us debug this:


rcu_scheduler_active = 2, debug_locks = 1
10 locks held by syz-executor.1/8017:
 #0: ffffffff8e3df430 (dup_mmap_sem){.+.+}-{0:0}, at: dup_mmap kernel/fork.c:637 [inline]
 #0: ffffffff8e3df430 (dup_mmap_sem){.+.+}-{0:0}, at: dup_mm kernel/fork.c:1688 [inline]
 #0: ffffffff8e3df430 (dup_mmap_sem){.+.+}-{0:0}, at: copy_mm+0x275/0x2180 kernel/fork.c:1737
 #1: ffff888078cbea20 (&mm->mmap_lock){++++}-{3:3}, at: mmap_write_lock_killable include/linux/mmap_lock.h:124 [inline]
 #1: ffff888078cbea20 (&mm->mmap_lock){++++}-{3:3}, at: dup_mmap kernel/fork.c:638 [inline]
 #1: ffff888078cbea20 (&mm->mmap_lock){++++}-{3:3}, at: dup_mm kernel/fork.c:1688 [inline]
 #1: ffff888078cbea20 (&mm->mmap_lock){++++}-{3:3}, at: copy_mm+0x295/0x2180 kernel/fork.c:1737
 #2: ffff88806a945720 (&mm->mmap_lock/1){+.+.}-{3:3}, at: mmap_write_lock_nested include/linux/mmap_lock.h:115 [inline]
 #2: ffff88806a945720 (&mm->mmap_lock/1){+.+.}-{3:3}, at: dup_mmap kernel/fork.c:647 [inline]
 #2: ffff88806a945720 (&mm->mmap_lock/1){+.+.}-{3:3}, at: dup_mm kernel/fork.c:1688 [inline]
 #2: ffff88806a945720 (&mm->mmap_lock/1){+.+.}-{3:3}, at: copy_mm+0x3d1/0x2180 kernel/fork.c:1737
 #3: ffffffff8e334da0 (rcu_read_lock){....}-{1:2}, at: rcu_lock_acquire include/linux/rcupdate.h:329 [inline]
 #3: ffffffff8e334da0 (rcu_read_lock){....}-{1:2}, at: rcu_read_lock include/linux/rcupdate.h:781 [inline]
 #3: ffffffff8e334da0 (rcu_read_lock){....}-{1:2}, at: __pte_offset_map+0x82/0x380 mm/pgtable-generic.c:285
 #4: ffff88802db9a798 (ptlock_ptr(ptdesc)#2){+.+.}-{2:2}, at: spin_lock include/linux/spinlock.h:351 [inline]
 #4: ffff88802db9a798 (ptlock_ptr(ptdesc)#2){+.+.}-{2:2}, at: __pte_offset_map_lock+0x1ba/0x300 mm/pgtable-generic.c:373
 #5: ffffffff8e334da0 (rcu_read_lock){....}-{1:2}, at: rcu_lock_acquire include/linux/rcupdate.h:329 [inline]
 #5: ffffffff8e334da0 (rcu_read_lock){....}-{1:2}, at: rcu_read_lock include/linux/rcupdate.h:781 [inline]
 #5: ffffffff8e334da0 (rcu_read_lock){....}-{1:2}, at: __pte_offset_map+0x82/0x380 mm/pgtable-generic.c:285
 #6: ffff8880298631f8 (ptlock_ptr(ptdesc)#2/1){+.+.}-{2:2}, at: copy_pte_range mm/memory.c:1103 [inline]
 #6: ffff8880298631f8 (ptlock_ptr(ptdesc)#2/1){+.+.}-{2:2}, at: copy_pmd_range mm/memory.c:1238 [inline]
 #6: ffff8880298631f8 (ptlock_ptr(ptdesc)#2/1){+.+.}-{2:2}, at: copy_pud_range mm/memory.c:1275 [inline]
 #6: ffff8880298631f8 (ptlock_ptr(ptdesc)#2/1){+.+.}-{2:2}, at: copy_p4d_range mm/memory.c:1299 [inline]
 #6: ffff8880298631f8 (ptlock_ptr(ptdesc)#2/1){+.+.}-{2:2}, at: copy_page_range+0x11c7/0x5b00 mm/memory.c:1397
 #7: ffffffff8e334d20 (rcu_read_lock_sched){....}-{1:2}, at: rcu_lock_acquire include/linux/rcupdate.h:329 [inline]
 #7: ffffffff8e334d20 (rcu_read_lock_sched){....}-{1:2}, at: rcu_read_lock_sched include/linux/rcupdate.h:873 [inline]
 #7: ffffffff8e334d20 (rcu_read_lock_sched){....}-{1:2}, at: pfn_valid+0xf6/0x440 include/linux/mmzone.h:2019
 #8: ffffc90000a08c00 ((&p->forward_delay_timer)){+.-.}-{0:0}, at: call_timer_fn+0xc0/0x650 kernel/time/timer.c:1790
 #9: ffff88807b56ccb8 (&br->lock){+.-.}-{2:2}, at: spin_lock include/linux/spinlock.h:351 [inline]
 #9: ffff88807b56ccb8 (&br->lock){+.-.}-{2:2}, at: br_forward_delay_timer_expired+0x50/0x440 net/bridge/br_stp_timer.c:86

stack backtrace:
CPU: 1 PID: 8017 Comm: syz-executor.1 Not tainted 6.9.0-rc6-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 03/27/2024
Call Trace:
 <IRQ>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0x241/0x360 lib/dump_stack.c:114
 lockdep_rcu_suspicious+0x221/0x340 kernel/locking/lockdep.c:6712
 nbp_vlan_group net/bridge/br_private.h:1599 [inline]
 br_mst_set_state+0x1ea/0x650 net/bridge/br_mst.c:105
 br_set_state+0x28a/0x7b0 net/bridge/br_stp.c:47
 br_forward_delay_timer_expired+0x176/0x440 net/bridge/br_stp_timer.c:88
 call_timer_fn+0x18e/0x650 kernel/time/timer.c:1793
 expire_timers kernel/time/timer.c:1844 [inline]
 __run_timers kernel/time/timer.c:2418 [inline]
 __run_timer_base+0x66a/0x8e0 kernel/time/timer.c:2429
 run_timer_base kernel/time/timer.c:2438 [inline]
 run_timer_softirq+0xb7/0x170 kernel/time/timer.c:2448
 __do_softirq+0x2c6/0x980 kernel/softirq.c:554
 invoke_softirq kernel/softirq.c:428 [inline]
 __irq_exit_rcu+0xf2/0x1c0 kernel/softirq.c:633
 irq_exit_rcu+0x9/0x30 kernel/softirq.c:645
 instr_sysvec_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1043 [inline]
 sysvec_apic_timer_interrupt+0xa6/0xc0 arch/x86/kernel/apic/apic.c:1043
 </IRQ>
 <TASK>
 asm_sysvec_apic_timer_interrupt+0x1a/0x20 arch/x86/include/asm/idtentry.h:702
RIP: 0010:lock_acquire+0x264/0x550 kernel/locking/lockdep.c:5758
Code: 2b 00 74 08 4c 89 f7 e8 ba d1 84 00 f6 44 24 61 02 0f 85 85 01 00 00 41 f7 c7 00 02 00 00 74 01 fb 48 c7 44 24 40 0e 36 e0 45 <4b> c7 44 25 00 00 00 00 00 43 c7 44 25 09 00 00 00 00 43 c7 44 25
RSP: 0018:ffffc90013657100 EFLAGS: 00000206
RAX: 0000000000000001 RBX: 1ffff920026cae2c RCX: 0000000000000001
RDX: dffffc0000000000 RSI: ffffffff8bcaca00 RDI: ffffffff8c1eaa60
RBP: ffffc90013657260 R08: ffffffff92efe507 R09: 1ffffffff25dfca0
R10: dffffc0000000000 R11: fffffbfff25dfca1 R12: 1ffff920026cae28
R13: dffffc0000000000 R14: ffffc90013657160 R15: 0000000000000246
 rcu_lock_acquire include/linux/rcupdate.h:329 [inline]
 rcu_read_lock_sched include/linux/rcupdate.h:873 [inline]
 pfn_valid+0x113/0x440 include/linux/mmzone.h:2019
 page_table_check_set+0x25/0x700 mm/page_table_check.c:105
 __page_table_check_ptes_set+0x220/0x280 mm/page_table_check.c:196
 page_table_check_ptes_set include/linux/page_table_check.h:74 [inline]
 set_ptes include/linux/pgtable.h:267 [inline]
 __copy_present_ptes mm/memory.c:953 [inline]
 copy_present_ptes mm/memory.c:1036 [inline]
 copy_pte_range mm/memory.c:1151 [inline]
 copy_pmd_range mm/memory.c:1238 [inline]
 copy_pud_range mm/memory.c:1275 [inline]
 copy_p4d_range mm/memory.c:1299 [inline]
 copy_page_range+0x3d98/0x5b00 mm/memory.c:1397
 dup_mmap kernel/fork.c:751 [inline]
 dup_mm kernel/fork.c:1688 [inline]
 copy_mm+0x1321/0x2180 kernel/fork.c:1737
 copy_process+0x187a/0x3df0 kernel/fork.c:2390
 kernel_clone+0x223/0x870 kernel/fork.c:2797
 __do_sys_clone kernel/fork.c:2940 [inline]
 __se_sys_clone kernel/fork.c:2924 [inline]
 __x64_sys_clone+0x258/0x2a0 kernel/fork.c:2924
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf5/0x240 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7ff5bc07aed3
Code: 1f 84 00 00 00 00 00 64 48 8b 04 25 10 00 00 00 45 31 c0 31 d2 31 f6 bf 11 00 20 01 4c 8d 90 d0 02 00 00 b8 38 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 35 89 c2 85 c0 75 2c 64 48 8b 04 25 10 00 00
RSP: 002b:00007ffd2ed6ec68 EFLAGS: 00000246 ORIG_RAX: 0000000000000038
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007ff5bc07aed3
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000001200011
RBP: 0000000000000001 R08: 0000000000000000 R09: 0000000000000000
R10: 00005555798ad750 R11: 0000000000000246 R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000000001 R15: 0000000000000001
 </TASK>
bridge0: port 1(bridge_slave_0) entered learning state
bridge0: port 2(bridge_slave_1) entered learning state
----------------
Code disassembly (best guess):
   0:	2b 00                	sub    (%rax),%eax
   2:	74 08                	je     0xc
   4:	4c 89 f7             	mov    %r14,%rdi
   7:	e8 ba d1 84 00       	call   0x84d1c6
   c:	f6 44 24 61 02       	testb  $0x2,0x61(%rsp)
  11:	0f 85 85 01 00 00    	jne    0x19c
  17:	41 f7 c7 00 02 00 00 	test   $0x200,%r15d
  1e:	74 01                	je     0x21
  20:	fb                   	sti
  21:	48 c7 44 24 40 0e 36 	movq   $0x45e0360e,0x40(%rsp)
  28:	e0 45
* 2a:	4b c7 44 25 00 00 00 	movq   $0x0,0x0(%r13,%r12,1) <-- trapping instruction
  31:	00 00
  33:	43 c7 44 25 09 00 00 	movl   $0x0,0x9(%r13,%r12,1)
  3a:	00 00
  3c:	43                   	rex.XB
  3d:	c7                   	.byte 0xc7
  3e:	44                   	rex.R
  3f:	25                   	.byte 0x25


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.

If the report is already addressed, let syzbot know by replying with:
#syz fix: exact-commit-title

If you want to overwrite report's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the report is a duplicate of another one, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup
