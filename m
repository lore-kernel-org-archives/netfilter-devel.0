Received: from mail-io1-f71.google.com (mail-io1-f71.google.com [209.85.166.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F05937165
	for <netfilter-devel@vger.kernel.org>; Thu, 22 Aug 2024 05:26:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724304384; cv=none; b=nqYs6sAyYmuYAdP2OASsq+YWKAP4ZKDnfk/RX/vF8/UcL56o38OKd0MKHkaYOHSBN2zRhucR3cico/AgyxZ3O0s2tqLTD0EI1f4e92Brd9XTnA0mCbFNCAKZzIXOEjgH78TbPFyzmNZEEknCXWhDbRjN/FLJ/v6kKFNzDZZmqno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724304384; c=relaxed/simple;
	bh=+edMAsVTf0wvAVFwSBvzVsBiU+RmU/QI9+TE/bAHDt4=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=QrrwJGiaCHMcWBSPGC2ZP8zM2X3am9CZoCplIZ1fvV35vA0QBrVxIb361hu30qQLBFVJi5inecGvSulhqKrM9w+eAygFs3VxJnLv4ZHEIEWwIjGrpSEFcuIAaufr+1NDIBVxPSIAFoF2lYssx/8VRYzfJObN/er2sILOa/pV0GE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-81f8c78cc66so46168839f.2
        for <netfilter-devel@vger.kernel.org>; Wed, 21 Aug 2024 22:26:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724304382; x=1724909182;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=nRBczyP1ndFp3DZdaxz249kSZYF8G49vPTCSgElcrRM=;
        b=E9vaQT15jqPQe/w/B89Y6ub/dE+x4v6B3ZELiIiCUFqo+DLOtZ1UHqm6bBGNsz/a5B
         uNQvwHaQ1kolypY8eO00E0wgfLmzGFIogpBHrkmt8/dDc5AN2eHOVtgPoIqf2XsvWpTD
         SbQHiPhqvjtxwm6u4YZiFTgcHNAIQdcNDyJ4VZ3WeWsIpto9wqio+xSFVVf94ca87sE/
         Cqr/l0w1SlKhnKOrDNo2bKYyo5fd6GGiMAdLU8/5ifL+k5FeaZX4eC1uxM0qB5DIcD/4
         eNFLCKPdbHHpyQ2Ij4fO7kGKYLOFcZnAs7OZoADZCKC6gomWCii1lCw+g2peIvpAYkix
         KDzw==
X-Forwarded-Encrypted: i=1; AJvYcCVm+yZ0+gOqH33ZbQ+DJBsxz3M/ZgHTZITDDq3yeAFzJyHQY0ZBkd19nQRnGG7O0c/veWqIU5XlvRJwQbFozLE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyt6v1ZtyhXfNX+FsAQmz1aW94zrk6cXdGMnrM7xnoP0nqC+LBh
	7Rdd//2ZCr/vuALsBQeVP/DseYRNgGNBWFXtvI+0SwzmkuG8VpAtRAqTJZ/oSNWQS+bQ+bynrgN
	rAO4imuuH4ntGogxdzeZQxKZ1k/XPIxBBgEMsb+3AiPpgLtNcclgd3pA=
X-Google-Smtp-Source: AGHT+IE5PO4igPnJCHytbFuHacpsvJRuU1Rpv+aVih48FcPTHQuKoi6qwfFRG8+GD7bO+vqBUZgLF2K+R5ZMWDdlmlVwMnxDEr0P
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1d9d:b0:39d:22b1:d0f2 with SMTP id
 e9e14a558f8ab-39d6c5c6e63mr2315495ab.5.1724304381700; Wed, 21 Aug 2024
 22:26:21 -0700 (PDT)
Date: Wed, 21 Aug 2024 22:26:21 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000027f84f06203ee675@google.com>
Subject: [syzbot] [netfilter?] inconsistent lock state in gfs2_fill_super
From: syzbot <syzbot+e9708296aa2eef438a51@syzkaller.appspotmail.com>
To: coreteam@netfilter.org, davem@davemloft.net, edumazet@google.com, 
	kadlec@netfilter.org, kuba@kernel.org, linux-kernel@vger.kernel.org, 
	netdev@vger.kernel.org, netfilter-devel@vger.kernel.org, pabeni@redhat.com, 
	pablo@netfilter.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    5c43d43bad35 Merge branches 'for-next/acpi', 'for-next/mis..
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
console output: https://syzkaller.appspot.com/x/log.txt?x=110668dd980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c91f83ae59feaa1f
dashboard link: https://syzkaller.appspot.com/bug?extid=e9708296aa2eef438a51
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
userspace arch: arm64

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/cc2dd4be620e/disk-5c43d43b.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/81d40d99ddbf/vmlinux-5c43d43b.xz
kernel image: https://storage.googleapis.com/syzbot-assets/bc6aed0f2bc5/Image-5c43d43b.gz.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+e9708296aa2eef438a51@syzkaller.appspotmail.com

================================
WARNING: inconsistent lock state
6.11.0-rc3-syzkaller-g5c43d43bad35 #0 Not tainted
--------------------------------
inconsistent {IN-SOFTIRQ-W} -> {SOFTIRQ-ON-W} usage.
syz.2.12/6520 [HC0[0]:SC0[0]:HE1:SE1] takes:
ffff0000d2af2d48 (&inst->lock){+.?.}-{2:2}, at: touch_wq_lockdep_map+0x70/0x118 kernel/workqueue.c:3876
{IN-SOFTIRQ-W} state was registered at:
  lock_acquire+0x240/0x728 kernel/locking/lockdep.c:5759
  __raw_spin_lock_bh include/linux/spinlock_api_smp.h:126 [inline]
  _raw_spin_lock_bh+0x48/0x60 kernel/locking/spinlock.c:178
  spin_lock_bh include/linux/spinlock.h:356 [inline]
  nfqnl_flush net/netfilter/nfnetlink_queue.c:407 [inline]
  instance_destroy_rcu+0xd4/0x314 net/netfilter/nfnetlink_queue.c:173
  rcu_do_batch kernel/rcu/tree.c:2569 [inline]
  rcu_core+0x888/0x1b3c kernel/rcu/tree.c:2843
  rcu_core_si+0x10/0x1c kernel/rcu/tree.c:2860
  handle_softirqs+0x2e4/0xbfc kernel/softirq.c:554
  run_ksoftirqd+0x70/0x158 kernel/softirq.c:928
  smpboot_thread_fn+0x4b0/0x90c kernel/smpboot.c:164
  kthread+0x288/0x310 kernel/kthread.c:389
  ret_from_fork+0x10/0x20 arch/arm64/kernel/entry.S:860
irq event stamp: 90375
hardirqs last  enabled at (90375): [<ffff80008b3e09a8>] __raw_spin_unlock_irqrestore include/linux/spinlock_api_smp.h:151 [inline]
hardirqs last  enabled at (90375): [<ffff80008b3e09a8>] _raw_spin_unlock_irqrestore+0x38/0x98 kernel/locking/spinlock.c:194
hardirqs last disabled at (90374): [<ffff8000803f46c4>] rcu_read_unlock_special+0x7c/0x400 kernel/rcu/tree_plugin.h:647
softirqs last  enabled at (89632): [<ffff8000801f6dfc>] softirq_handle_end kernel/softirq.c:400 [inline]
softirqs last  enabled at (89632): [<ffff8000801f6dfc>] handle_softirqs+0xa3c/0xbfc kernel/softirq.c:582
softirqs last disabled at (89621): [<ffff800080020de8>] __do_softirq+0x14/0x20 kernel/softirq.c:588

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(&inst->lock);
  <Interrupt>
    lock(&inst->lock);

 *** DEADLOCK ***

1 lock held by syz.2.12/6520:
 #0: ffff0000d53e20e0 (&type->s_umount_key#51/1){+.+.}-{3:3}, at: alloc_super+0x1b0/0x83c fs/super.c:344

stack backtrace:
CPU: 1 UID: 0 PID: 6520 Comm: syz.2.12 Not tainted 6.11.0-rc3-syzkaller-g5c43d43bad35 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 06/27/2024
Call trace:
 dump_backtrace+0x1b8/0x1e4 arch/arm64/kernel/stacktrace.c:317
 show_stack+0x2c/0x3c arch/arm64/kernel/stacktrace.c:324
 __dump_stack lib/dump_stack.c:93 [inline]
 dump_stack_lvl+0xe4/0x150 lib/dump_stack.c:119
 dump_stack+0x1c/0x28 lib/dump_stack.c:128
 print_usage_bug+0x698/0x9ac kernel/locking/lockdep.c:4000
 mark_lock_irq+0x980/0xd2c
 mark_lock+0x258/0x360 kernel/locking/lockdep.c:4677
 __lock_acquire+0x131c/0x779c kernel/locking/lockdep.c:5096
 lock_acquire+0x240/0x728 kernel/locking/lockdep.c:5759
 touch_wq_lockdep_map+0x98/0x118 kernel/workqueue.c:3876
 __flush_workqueue+0x118/0x1174 kernel/workqueue.c:3918
 drain_workqueue+0xb8/0x32c kernel/workqueue.c:4082
 destroy_workqueue+0xb8/0xdc0 kernel/workqueue.c:5781
 gfs2_fill_super+0xe78/0x1f98 fs/gfs2/ops_fstype.c:1310
 get_tree_bdev+0x320/0x470 fs/super.c:1635
 gfs2_get_tree+0x54/0x1b4 fs/gfs2/ops_fstype.c:1329
 vfs_get_tree+0x90/0x288 fs/super.c:1800
 do_new_mount+0x278/0x900 fs/namespace.c:3472
 path_mount+0x590/0xe04 fs/namespace.c:3799
 do_mount fs/namespace.c:3812 [inline]
 __do_sys_mount fs/namespace.c:4020 [inline]
 __se_sys_mount fs/namespace.c:3997 [inline]
 __arm64_sys_mount+0x45c/0x5a8 fs/namespace.c:3997
 __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
 invoke_syscall+0x98/0x2b8 arch/arm64/kernel/syscall.c:49
 el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
 do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
 el0_svc+0x54/0x168 arch/arm64/kernel/entry-common.c:712
 el0t_64_sync_handler+0x84/0xfc arch/arm64/kernel/entry-common.c:730
 el0t_64_sync+0x190/0x194 arch/arm64/kernel/entry.S:598
list_del corruption, ffff0000d2af2c10->prev is LIST_POISON2 (dead000000000122)
------------[ cut here ]------------
kernel BUG at lib/list_debug.c:61!
Internal error: Oops - BUG: 00000000f2000800 [#1] PREEMPT SMP
Modules linked in:
CPU: 0 UID: 0 PID: 6520 Comm: syz.2.12 Not tainted 6.11.0-rc3-syzkaller-g5c43d43bad35 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 06/27/2024
pstate: 60400005 (nZCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : __list_del_entry_valid_or_report+0x124/0x158 lib/list_debug.c:59
lr : __list_del_entry_valid_or_report+0x124/0x158 lib/list_debug.c:59
sp : ffff8000a0157680
x29: ffff8000a0157680
 x28: ffff70001402af04
 x27: ffff0000d2af2c00
x26: dfff800000000000 x25: ffff0000ccfc0a58 x24: ffff0000ccfc0008
x23: 1fffe0001aa7c4c7 x22: dfff800000000000 x21: dead000000000122
x20: ffff0000d2af3010 x19: ffff0000d2af2c10 x18: 1fffe00036799fe6
x17: ffff80008f50d000 x16: ffff800083014574 x15: 0000000000000001
x14: 1ffff0001402ae24 x13: 0000000000000000 x12: 0000000000000000
x11: 0000000000000001 x10: 0000000000ff0100 x9 : 03ab41263e22fd00
x8 : 03ab41263e22fd00 x7 : 1fffe00036799fe7 x6 : ffff8000802b5ca8
x5 : 0000000000000000 x4 : 0000000000000001 x3 : ffff800082f9efc4
x2 : 0000000000000001 x1 : 0000000100000000 x0 : 000000000000004e
Call trace:
 __list_del_entry_valid_or_report+0x124/0x158 lib/list_debug.c:59
 __list_del_entry_valid include/linux/list.h:124 [inline]
 __list_del_entry include/linux/list.h:215 [inline]
 list_del_rcu include/linux/rculist.h:157 [inline]
 destroy_workqueue+0x6e4/0xdc0 kernel/workqueue.c:5823
 gfs2_fill_super+0xe78/0x1f98 fs/gfs2/ops_fstype.c:1310
 get_tree_bdev+0x320/0x470 fs/super.c:1635
 gfs2_get_tree+0x54/0x1b4 fs/gfs2/ops_fstype.c:1329
 vfs_get_tree+0x90/0x288 fs/super.c:1800
 do_new_mount+0x278/0x900 fs/namespace.c:3472
 path_mount+0x590/0xe04 fs/namespace.c:3799
 do_mount fs/namespace.c:3812 [inline]
 __do_sys_mount fs/namespace.c:4020 [inline]
 __se_sys_mount fs/namespace.c:3997 [inline]
 __arm64_sys_mount+0x45c/0x5a8 fs/namespace.c:3997
 __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
 invoke_syscall+0x98/0x2b8 arch/arm64/kernel/syscall.c:49
 el0_svc_common+0x130/0x23c arch/arm64/kernel/syscall.c:132
 do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
 el0_svc+0x54/0x168 arch/arm64/kernel/entry-common.c:712
 el0t_64_sync_handler+0x84/0xfc arch/arm64/kernel/entry-common.c:730
 el0t_64_sync+0x190/0x194 arch/arm64/kernel/entry.S:598
Code: d0044ca0 913c8000 aa1303e1 953c558b (d4210000) 
---[ end trace 0000000000000000 ]---


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
