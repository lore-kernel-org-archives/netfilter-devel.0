Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 983922264C7
	for <netfilter-devel@vger.kernel.org>; Thu, 13 Nov 2025 13:50:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763041852; cv=none; b=d2IIiiaTIfODbp/H5Gep5YbUMmcCfKm5dkJ7LHC0gHbwzrLBDcQLMXF1hI8lU1jN3N3tAY82FsIJJv96A99fFwKc28Xw8uqI2IArX6x7IGyvYJoDu9jE5ABlXQah7nO0Qj/9Q6MeFu3bYTfLMBDtPyHnJ7BvNxjBLyoBmrKanGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763041852; c=relaxed/simple;
	bh=YHwpLQZLAsocv8zCxcdO6JPA15+fou47SRFPfHukz4E=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=BAYKzWTSM5oP0marfxDUg9ILlelRyzHcAczKvWDOxPMy/ZJF5YKiGtwg/60q2fq9iT4DIZfpUEiuvCViFkQuPUvwcmDTNrWQpuWhvewavAfx9LGrlz9M1wh+zrAALyxQFXqaUwC4rDGtXpi9mYIPnK+dMDjPnjqu5i8JT6w2aFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-433199c7fb4so8849105ab.3
        for <netfilter-devel@vger.kernel.org>; Thu, 13 Nov 2025 05:50:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763041849; x=1763646649;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gR5QHRJoKlUfEKsqtqN8QGAlulySX9Zv3V+FIyZgt/0=;
        b=qzzUYxeBHD2lOTShGK0+YOd1yECy7tTioWB0NwNyHFtXf1nJjYAs/F1yLg/2cumcr6
         K8hzXsEUx1wpscUOD/dMVYhZoa9zguv+lEeSM9CM3ZVoUXkoWszLgpmM3xSAbvORZp4w
         cyUbcQxywEr5b1fh0Ej3FwNw3BNAnifzH/Vh/mTXlbHvaD2P1h2GAvwVLglSAAtwinQi
         cz0HJqoSbrvmHeWikqRM2D+Cnbh9P3PcjQstb8q50ZdCzL9PUAigEWH695hmNiOYkDuT
         xvnsRLufzQicqGK1uFV3XLTTfphbO5tgoxXwEPuGxt5uIEUd3u7j32XWLBSWTMcpKS/x
         7ifQ==
X-Forwarded-Encrypted: i=1; AJvYcCXpVI9C+Wcq1rGwVbaIMiL10MptsHPMrYawqzSOms4GfOs3p+XOCZaW+M4rF5a0HGCgzcB1XFZNLgTOQoVIeOc=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywin0bRFU5Kbb/bTbLDjTNd4Z1K4gJ7pq6fsgsB/2NI8BI+2961
	DXYW+Bvil/htxdEiX5vyO4nPeD03wwdD2SZzx7QLV0L/1InKX+x3rxydEUv5Rdb0EfSKwEeO4Jo
	AFUaIzNUXOQZmp7rs0hnlSs9Wq/vfzOkg8sXYJJxHDp9ep/I4CxPDXt71ZA4=
X-Google-Smtp-Source: AGHT+IFGfFo1KbKpKvVzlkRza9ovk/p48usi5JoqdbcquAg13bFV2sMz3dIBqs4h/BeJvO+cPBPDvTd991hK3B/F6D8tnMw4OJlT
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:3091:b0:433:7e25:b93d with SMTP id
 e9e14a558f8ab-43473da71bdmr85293035ab.28.1763041849569; Thu, 13 Nov 2025
 05:50:49 -0800 (PST)
Date: Thu, 13 Nov 2025 05:50:49 -0800
In-Reply-To: <20251113092606.91406-1-scott_mitchell@apple.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6915e239.a70a0220.3124cb.0029.GAE@google.com>
Subject: [syzbot ci] Re: netfilter: nfnetlink_queue: optimize verdict lookup
 with hash table
From: syzbot ci <syzbot+ci9bdcb0a5ada952db@syzkaller.appspotmail.com>
To: coreteam@netfilter.org, davem@davemloft.net, edumazet@google.com, 
	fw@strlen.de, horms@kernel.org, kadlec@netfilter.org, kuba@kernel.org, 
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org, 
	netfilter-devel@vger.kernel.org, pabeni@redhat.com, pablo@netfilter.org, 
	phil@nwl.cc, scott.k.mitch1@gmail.com, scott_mitchell@apple.com
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v2] netfilter: nfnetlink_queue: optimize verdict lookup with hash table
https://lore.kernel.org/all/20251113092606.91406-1-scott_mitchell@apple.com
* [PATCH v2] netfilter: nfnetlink_queue: optimize verdict lookup with hash table

and found the following issue:
BUG: sleeping function called from invalid context in instance_create

Full report is available here:
https://ci.syzbot.org/series/001a6a6c-7e1b-46e8-995d-5b6d650af320

***

BUG: sleeping function called from invalid context in instance_create

tree:      nf-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netfilter/nf-next.git
base:      0d0eb186421d0886ac466008235f6d9eedaf918e
arch:      amd64
compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
config:    https://ci.syzbot.org/builds/69a4254b-f4aa-45a7-a4bd-2d23940887f3/config
C repro:   https://ci.syzbot.org/findings/8074062c-0aee-4734-a3d1-587b80676bf1/c_repro
syz repro: https://ci.syzbot.org/findings/8074062c-0aee-4734-a3d1-587b80676bf1/syz_repro

netlink: 'syz.0.17': attribute type 6 has an invalid length.
BUG: sleeping function called from invalid context at ./include/linux/sched/mm.h:321
in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 5968, name: syz.0.17
preempt_count: 1, expected: 0
RCU nest depth: 1, expected: 0
3 locks held by syz.0.17/5968:
 #0: ffffffff99cc1c30 (nfnl_subsys_queue){+.+.}-{4:4}, at: nfnl_lock net/netfilter/nfnetlink.c:98 [inline]
 #0: ffffffff99cc1c30 (nfnl_subsys_queue){+.+.}-{4:4}, at: nfnetlink_rcv_msg+0x9dc/0x1130 net/netfilter/nfnetlink.c:295
 #1: ffffffff8df3d2e0 (rcu_read_lock){....}-{1:3}, at: rcu_lock_acquire include/linux/rcupdate.h:331 [inline]
 #1: ffffffff8df3d2e0 (rcu_read_lock){....}-{1:3}, at: rcu_read_lock include/linux/rcupdate.h:867 [inline]
 #1: ffffffff8df3d2e0 (rcu_read_lock){....}-{1:3}, at: nfqnl_recv_config+0x222/0xf90 net/netfilter/nfnetlink_queue.c:1653
 #2: ffff888112297d18 (&q->instances_lock){+.+.}-{3:3}, at: spin_lock include/linux/spinlock.h:351 [inline]
 #2: ffff888112297d18 (&q->instances_lock){+.+.}-{3:3}, at: instance_create+0x121/0x740 net/netfilter/nfnetlink_queue.c:206
Preemption disabled at:
[<0000000000000000>] 0x0
CPU: 1 UID: 0 PID: 5968 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0x189/0x250 lib/dump_stack.c:120
 __might_resched+0x495/0x610 kernel/sched/core.c:8927
 might_alloc include/linux/sched/mm.h:321 [inline]
 slab_pre_alloc_hook mm/slub.c:4913 [inline]
 slab_alloc_node mm/slub.c:5248 [inline]
 __do_kmalloc_node mm/slub.c:5633 [inline]
 __kvmalloc_node_noprof+0x149/0x910 mm/slub.c:7089
 kvmalloc_array_node_noprof include/linux/slab.h:1122 [inline]
 instance_create+0x203/0x740 net/netfilter/nfnetlink_queue.c:218
 nfqnl_recv_config+0x660/0xf90 net/netfilter/nfnetlink_queue.c:1667
 nfnetlink_rcv_msg+0xb4d/0x1130 net/netfilter/nfnetlink.c:302
 netlink_rcv_skb+0x208/0x470 net/netlink/af_netlink.c:2550
 nfnetlink_rcv+0x282/0x2590 net/netfilter/nfnetlink.c:669
 netlink_unicast_kernel net/netlink/af_netlink.c:1318 [inline]
 netlink_unicast+0x82f/0x9e0 net/netlink/af_netlink.c:1344
 netlink_sendmsg+0x805/0xb30 net/netlink/af_netlink.c:1894
 sock_sendmsg_nosec net/socket.c:727 [inline]
 __sock_sendmsg+0x21c/0x270 net/socket.c:742
 ____sys_sendmsg+0x505/0x830 net/socket.c:2630
 ___sys_sendmsg+0x21f/0x2a0 net/socket.c:2684
 __sys_sendmsg net/socket.c:2716 [inline]
 __do_sys_sendmsg net/socket.c:2721 [inline]
 __se_sys_sendmsg net/socket.c:2719 [inline]
 __x64_sys_sendmsg+0x19b/0x260 net/socket.c:2719
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f7a65f8f6c9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffde4361588 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007f7a661e5fa0 RCX: 00007f7a65f8f6c9
RDX: 0000000000008010 RSI: 00002000000000c0 RDI: 0000000000000003
RBP: 00007f7a66011f91 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f7a661e5fa0 R14: 00007f7a661e5fa0 R15: 0000000000000003
 </TASK>


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.
