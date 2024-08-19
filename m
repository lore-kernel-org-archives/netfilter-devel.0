Received: from mail-io1-f70.google.com (mail-io1-f70.google.com [209.85.166.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56E1B1EA65
	for <netfilter-devel@vger.kernel.org>; Mon, 19 Aug 2024 05:03:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724043805; cv=none; b=nSGX4/Tv5+hlt8s1iAlHMjxfEvSDGUMnmAgSiuVeIYGM7Dse5pVj6VmpkVTFLs/ON36FBBgCFcQqODvH0tvyuD5LQQ5VIfokEta67QQqJYA4Ui9CoFfsipXwxwPgSeqzFZyA3gFzQE/dFKhjgVd4SYdzNAvvtPP9y49Jm/VrtvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724043805; c=relaxed/simple;
	bh=2tMLIrqrdArfhHkJKhMI/7SWYgCC0HMpmuwe+ITq0zA=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=deRDMhh/UbUnVhIqdQh8s8FbLDDYzo/Ul6/26hTQ8vtW/AoakkX84Em9aSGdDPDu1/zUz4d3rddHskA6/Td5+528XSer2SRDXABs5JkijEswxDzstLZhmah/UfM3qBL/L7rylMDsF0OBOXZHDeUDqaYRh4kLEHC0UVUo002bQ0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f70.google.com with SMTP id ca18e2360f4ac-822372161efso277061039f.0
        for <netfilter-devel@vger.kernel.org>; Sun, 18 Aug 2024 22:03:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724043802; x=1724648602;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=dSFLBeiiWzZySsiLWtsnFCqQnBT+0rywY/3IuUv38jA=;
        b=p20Qb4JVxN5yWnNWqvMR4O+f4tGROhbevtBS4kaeZ+dckyQZY9Fc6O2uH69eAWIaVf
         uvbHlLcIod1JIVLrnfy5w0qvHE2D6/RdLl0/LRNVYHlA+5O82Q0Gd0jOa8/dNmNn3S5R
         za2+zdbooC6bmq+wP3cocgVBB3SGPrLxZErXbVX/CZKp/fIi9pw6P/sIUfJq5ZdNIZz/
         HZsMPK/UOxsOZXvz91PLU0pJDgbVZOfWywixJ2AvaN32vXrUW99G8oKsdiV5EGo5UQj9
         D9zdXcCStYLPiWaEKN78mSUXHz7gZY25VoTaCyvHCUymClNqtL+VPpAyNKBVF10ZERoe
         PW2g==
X-Forwarded-Encrypted: i=1; AJvYcCUAcRxyCX9Lziv577ZWmge99abaFOKdtGqcw9o43YNxNQoDGaDAjO+tmRZoLr0Z3sq04juZ65YWWBEbKvg2brM=@vger.kernel.org
X-Gm-Message-State: AOJu0YxyATvxov13Hd+YJi88xQ5tYD+8nIQmcJbhOPg8Fv3i8RSkXJH9
	BY0+zaJQL8r8h1vOBBVpiKp1zicZVWPUG+kxe7oKFWan+oeFgLv1s+qlIn4q3oVG3WtCTguZXb3
	acjr8z0cnTMYcLQpQXfcA4YSHWUyjrVMRos4Q79Ztm50nVFDOwzrkq78=
X-Google-Smtp-Source: AGHT+IHg4pSo/XROWbExL7L5GVHLAz7Kuv0/gjSQXXCfQBC7S6pniAsduujPacdn61cgu00ziDpPko2wQzMbEX/GFFo6mmVz512b
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:b2c:b0:398:b1d3:7c9d with SMTP id
 e9e14a558f8ab-39d26d61d8cmr4698225ab.3.1724043802424; Sun, 18 Aug 2024
 22:03:22 -0700 (PDT)
Date: Sun, 18 Aug 2024 22:03:22 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000006bc6d20620023a14@google.com>
Subject: [syzbot] [netfilter?] inconsistent lock state in valid_state (4)
From: syzbot <syzbot+d43eb079c2addf2439c3@syzkaller.appspotmail.com>
To: coreteam@netfilter.org, davem@davemloft.net, dsahern@kernel.org, 
	edumazet@google.com, kadlec@netfilter.org, kuba@kernel.org, 
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org, 
	netfilter-devel@vger.kernel.org, pabeni@redhat.com, pablo@netfilter.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    9d5906799f7d Merge tag 'selinux-pr-20240814' of git://git...
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=12b7d5ed980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=7229118d88b4a71b
dashboard link: https://syzkaller.appspot.com/bug?extid=d43eb079c2addf2439c3
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/8e704636e03c/disk-9d590679.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/51ba26ca8f22/vmlinux-9d590679.xz
kernel image: https://storage.googleapis.com/syzbot-assets/8446039662e6/bzImage-9d590679.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+d43eb079c2addf2439c3@syzkaller.appspotmail.com

gfs2: fsid=syz:syz.0: can't create logd thread: -4
================================
WARNING: inconsistent lock state
6.11.0-rc3-syzkaller-00036-g9d5906799f7d #0 Not tainted
--------------------------------
inconsistent {IN-SOFTIRQ-W} -> {SOFTIRQ-ON-W} usage.
syz.4.59/5557 [HC0[0]:SC0[0]:HE1:SE1] takes:
ffff88802cd32548 ((&usbhid->io_retry)){+.?.}-{0:0}, at: touch_wq_lockdep_map kernel/workqueue.c:3876 [inline]
ffff88802cd32548 ((&usbhid->io_retry)){+.?.}-{0:0}, at: __flush_workqueue+0x1b0/0x1710 kernel/workqueue.c:3918
{IN-SOFTIRQ-W} state was registered at:
  lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5759
  call_timer_fn+0xdd/0x650 kernel/time/timer.c:1789
  expire_timers kernel/time/timer.c:1843 [inline]
  __run_timers kernel/time/timer.c:2417 [inline]
  __run_timer_base+0x66a/0x8e0 kernel/time/timer.c:2428
  run_timer_base kernel/time/timer.c:2437 [inline]
  run_timer_softirq+0xb7/0x170 kernel/time/timer.c:2447
  handle_softirqs+0x2c6/0x970 kernel/softirq.c:554
  __do_softirq kernel/softirq.c:588 [inline]
  invoke_softirq kernel/softirq.c:428 [inline]
  __irq_exit_rcu+0xf4/0x1c0 kernel/softirq.c:637
  irq_exit_rcu+0x9/0x30 kernel/softirq.c:649
  instr_sysvec_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1043 [inline]
  sysvec_apic_timer_interrupt+0xa6/0xc0 arch/x86/kernel/apic/apic.c:1043
  asm_sysvec_apic_timer_interrupt+0x1a/0x20 arch/x86/include/asm/idtentry.h:702
  __raw_spin_unlock_irqrestore include/linux/spinlock_api_smp.h:152 [inline]
  _raw_spin_unlock_irqrestore+0xd8/0x140 kernel/locking/spinlock.c:194
  __debug_check_no_obj_freed lib/debugobjects.c:999 [inline]
  debug_check_no_obj_freed+0x561/0x580 lib/debugobjects.c:1020
  free_pages_prepare mm/page_alloc.c:1101 [inline]
  free_unref_page+0x38a/0xea0 mm/page_alloc.c:2612
  __slab_free+0x31b/0x3d0 mm/slub.c:4384
  qlink_free mm/kasan/quarantine.c:163 [inline]
  qlist_free_all+0x9e/0x140 mm/kasan/quarantine.c:179
  kasan_quarantine_reduce+0x14f/0x170 mm/kasan/quarantine.c:286
  __kasan_slab_alloc+0x23/0x80 mm/kasan/common.c:322
  kasan_slab_alloc include/linux/kasan.h:201 [inline]
  slab_post_alloc_hook mm/slub.c:3988 [inline]
  slab_alloc_node mm/slub.c:4037 [inline]
  __kmalloc_cache_node_noprof+0x166/0x300 mm/slub.c:4197
  kmalloc_node_noprof include/linux/slab.h:704 [inline]
  __get_vm_area_node+0x113/0x270 mm/vmalloc.c:3109
  __vmalloc_node_range_noprof+0x3bc/0x1460 mm/vmalloc.c:3801
  __vmalloc_node_noprof mm/vmalloc.c:3906 [inline]
  vzalloc_noprof+0x79/0x90 mm/vmalloc.c:3979
  alloc_counters+0xd7/0x740 net/ipv4/netfilter/ip_tables.c:799
  copy_entries_to_user net/ipv6/netfilter/ip6_tables.c:837 [inline]
  get_entries net/ipv6/netfilter/ip6_tables.c:1039 [inline]
  do_ip6t_get_ctl+0xecc/0x1820 net/ipv6/netfilter/ip6_tables.c:1677
  nf_getsockopt+0x29b/0x2c0 net/netfilter/nf_sockopt.c:116
  ipv6_getsockopt+0x263/0x380 net/ipv6/ipv6_sockglue.c:1493
  tcp_getsockopt+0x165/0x1c0 net/ipv4/tcp.c:4409
  do_sock_getsockopt+0x375/0x850 net/socket.c:2386
  __sys_getsockopt+0x271/0x330 net/socket.c:2415
  __do_sys_getsockopt net/socket.c:2425 [inline]
  __se_sys_getsockopt net/socket.c:2422 [inline]
  __x64_sys_getsockopt+0xb5/0xd0 net/socket.c:2422
  do_syscall_x64 arch/x86/entry/common.c:52 [inline]
  do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
  entry_SYSCALL_64_after_hwframe+0x77/0x7f
irq event stamp: 93075
hardirqs last  enabled at (93075): [<ffffffff8bc06683>] __raw_spin_unlock_irq include/linux/spinlock_api_smp.h:159 [inline]
hardirqs last  enabled at (93075): [<ffffffff8bc06683>] _raw_spin_unlock_irq+0x23/0x50 kernel/locking/spinlock.c:202
hardirqs last disabled at (93074): [<ffffffff8bc063cd>] __raw_spin_lock_irq include/linux/spinlock_api_smp.h:117 [inline]
hardirqs last disabled at (93074): [<ffffffff8bc063cd>] _raw_spin_lock_irq+0xad/0x120 kernel/locking/spinlock.c:170
softirqs last  enabled at (92472): [<ffffffff81575bd4>] __do_softirq kernel/softirq.c:588 [inline]
softirqs last  enabled at (92472): [<ffffffff81575bd4>] invoke_softirq kernel/softirq.c:428 [inline]
softirqs last  enabled at (92472): [<ffffffff81575bd4>] __irq_exit_rcu+0xf4/0x1c0 kernel/softirq.c:637
softirqs last disabled at (92431): [<ffffffff81575bd4>] __do_softirq kernel/softirq.c:588 [inline]
softirqs last disabled at (92431): [<ffffffff81575bd4>] invoke_softirq kernel/softirq.c:428 [inline]
softirqs last disabled at (92431): [<ffffffff81575bd4>] __irq_exit_rcu+0xf4/0x1c0 kernel/softirq.c:637

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock((&usbhid->io_retry));
  <Interrupt>
    lock((&usbhid->io_retry));

 *** DEADLOCK ***

1 lock held by syz.4.59/5557:
 #0: ffff888055c9a0e0 (&type->s_umount_key#66/1){+.+.}-{3:3}, at: alloc_super+0x221/0x9d0 fs/super.c:344

stack backtrace:
CPU: 0 UID: 0 PID: 5557 Comm: syz.4.59 Not tainted 6.11.0-rc3-syzkaller-00036-g9d5906799f7d #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 06/27/2024
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:93 [inline]
 dump_stack_lvl+0x241/0x360 lib/dump_stack.c:119
 valid_state+0x13a/0x1c0 kernel/locking/lockdep.c:4012
 mark_lock_irq+0xbb/0xc20 kernel/locking/lockdep.c:4215
 mark_lock+0x223/0x350 kernel/locking/lockdep.c:4677
 __lock_acquire+0x11a6/0x2040 kernel/locking/lockdep.c:5096
 lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5759
 touch_wq_lockdep_map kernel/workqueue.c:3876 [inline]
 __flush_workqueue+0x1c9/0x1710 kernel/workqueue.c:3918
 drain_workqueue+0xc9/0x3a0 kernel/workqueue.c:4082
 destroy_workqueue+0xba/0xc40 kernel/workqueue.c:5781
 gfs2_fill_super+0x128a/0x2500 fs/gfs2/ops_fstype.c:1310
 get_tree_bdev+0x3f9/0x570 fs/super.c:1635
 gfs2_get_tree+0x54/0x220 fs/gfs2/ops_fstype.c:1329
 vfs_get_tree+0x92/0x2a0 fs/super.c:1800
 do_new_mount+0x2be/0xb40 fs/namespace.c:3472
 do_mount fs/namespace.c:3812 [inline]
 __do_sys_mount fs/namespace.c:4020 [inline]
 __se_sys_mount+0x2d6/0x3c0 fs/namespace.c:3997
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f6490f7b0ba
Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb a6 e8 7e 1a 00 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f6491d08e68 EFLAGS: 00000202 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007f6491d08ef0 RCX: 00007f6490f7b0ba
RDX: 00000000200003c0 RSI: 0000000020037f80 RDI: 00007f6491d08eb0
RBP: 00000000200003c0 R08: 00007f6491d08ef0 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000202 R12: 0000000020037f80
R13: 00007f6491d08eb0 R14: 0000000000037f59 R15: 0000000020000000
 </TASK>
list_del corruption, ffff88802cd32410->prev is LIST_POISON2 (dead000000000122)
------------[ cut here ]------------
kernel BUG at lib/list_debug.c:61!
Oops: invalid opcode: 0000 [#1] PREEMPT SMP KASAN NOPTI
CPU: 1 UID: 0 PID: 5557 Comm: syz.4.59 Not tainted 6.11.0-rc3-syzkaller-00036-g9d5906799f7d #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 06/27/2024
RIP: 0010:__list_del_entry_valid_or_report+0x106/0x140 lib/list_debug.c:59
Code: e8 3f e5 fa 06 90 0f 0b 48 c7 c7 e0 6c 60 8c 4c 89 fe e8 2d e5 fa 06 90 0f 0b 48 c7 c7 40 6d 60 8c 4c 89 fe e8 1b e5 fa 06 90 <0f> 0b 48 c7 c7 a0 6d 60 8c 4c 89 fe 48 89 d9 e8 06 e5 fa 06 90 0f
RSP: 0018:ffffc90009017928 EFLAGS: 00010246
RAX: 000000000000004e RBX: dead000000000122 RCX: 6fba748022670100
RDX: ffffc90009049000 RSI: 000000000003ffff RDI: 0000000000040000
RBP: ffff88802cd324f8 R08: ffffffff8173f24c R09: 1ffff92001202ec4
R10: dffffc0000000000 R11: fffff52001202ec5 R12: dffffc0000000000
R13: ffff88802cd32400 R14: ffff88802cd32810 R15: ffff88802cd32410
FS:  00007f6491d096c0(0000) GS:ffff8880b9300000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007faf8fc47d60 CR3: 0000000022a12000 CR4: 0000000000350ef0
Call Trace:
 <TASK>
 __list_del_entry_valid include/linux/list.h:124 [inline]
 __list_del_entry include/linux/list.h:215 [inline]
 list_del_rcu include/linux/rculist.h:157 [inline]
 destroy_workqueue+0x7b3/0xc40 kernel/workqueue.c:5823
 gfs2_fill_super+0x128a/0x2500 fs/gfs2/ops_fstype.c:1310
 get_tree_bdev+0x3f9/0x570 fs/super.c:1635
 gfs2_get_tree+0x54/0x220 fs/gfs2/ops_fstype.c:1329
 vfs_get_tree+0x92/0x2a0 fs/super.c:1800
 do_new_mount+0x2be/0xb40 fs/namespace.c:3472
 do_mount fs/namespace.c:3812 [inline]
 __do_sys_mount fs/namespace.c:4020 [inline]
 __se_sys_mount+0x2d6/0x3c0 fs/namespace.c:3997
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f6490f7b0ba
Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb a6 e8 7e 1a 00 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f6491d08e68 EFLAGS: 00000202 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007f6491d08ef0 RCX: 00007f6490f7b0ba
RDX: 00000000200003c0 RSI: 0000000020037f80 RDI: 00007f6491d08eb0
RBP: 00000000200003c0 R08: 00007f6491d08ef0 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000202 R12: 0000000020037f80
R13: 00007f6491d08eb0 R14: 0000000000037f59 R15: 0000000020000000
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:__list_del_entry_valid_or_report+0x106/0x140 lib/list_debug.c:59
Code: e8 3f e5 fa 06 90 0f 0b 48 c7 c7 e0 6c 60 8c 4c 89 fe e8 2d e5 fa 06 90 0f 0b 48 c7 c7 40 6d 60 8c 4c 89 fe e8 1b e5 fa 06 90 <0f> 0b 48 c7 c7 a0 6d 60 8c 4c 89 fe 48 89 d9 e8 06 e5 fa 06 90 0f
RSP: 0018:ffffc90009017928 EFLAGS: 00010246
RAX: 000000000000004e RBX: dead000000000122 RCX: 6fba748022670100
RDX: ffffc90009049000 RSI: 000000000003ffff RDI: 0000000000040000
RBP: ffff88802cd324f8 R08: ffffffff8173f24c R09: 1ffff92001202ec4
R10: dffffc0000000000 R11: fffff52001202ec5 R12: dffffc0000000000
R13: ffff88802cd32400 R14: ffff88802cd32810 R15: ffff88802cd32410
FS:  00007f6491d096c0(0000) GS:ffff8880b9200000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007faaedf66731 CR3: 0000000022a12000 CR4: 0000000000350ef0


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
