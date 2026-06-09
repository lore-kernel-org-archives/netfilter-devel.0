Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com [209.85.167.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 357693905F4
	for <netfilter-devel@vger.kernel.org>; Tue,  9 Jun 2026 20:44:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781037896; cv=none; b=pO8597vcgYIZ1wnoXN/L0UzVDyy6EYpgOS+klGvqTFO6zw1pvOn4PpNg8+U7omVqlpKVGoEZTExlDxp+glAYDvd0Tudz4QOcq6HSJV2iPSdEeivT61Eev39xC6ic15BHHvlJMzdlZsGlQZqy/PZjG8CCMFnlGEqu2wgEPXK+ZKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781037896; c=relaxed/simple;
	bh=/4h3XFkUDw6rYtb6pUhQSE0ax+KXYlYfhQxaRDU3XTE=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=OZfYTQAgBRxhofy9ycb+q8PbZhm963hyr94ndVIs5B4CWvMOnvDUxp+6Zd+elxILiAhpt9PyvcrbITX0rqhsaEDqnBe5sqq+OHAyHHwlRpvWNqsGuHnrYy4MM87Ulv0D4z93vEQ/iIpnY7266O7TZm/TslK9nMMQ2Is7r4oQ1gU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f198.google.com with SMTP id 5614622812f47-486359cca85so5136913b6e.0
        for <netfilter-devel@vger.kernel.org>; Tue, 09 Jun 2026 13:44:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781037893; x=1781642693;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hHdpHFTTL1aPCxUrVSyLAPbsSBXV66SQct108zIFSjI=;
        b=m8OUYgYXkreIT1o7EqUF6B3PePTN81Ovq6YqNipCSFID9NCB1QSFS9xQSuMvGkAzNo
         tNLNvTQuv+w+GBKelRhrKtLEYRGsuf6y27FaznQAfVpgFkBN5GtyIP9uGqIOg3UBFKu+
         2Vx1UWmlkMRFOFzMqPH+2vo4JiZV1qPCeTU0I0+xF1Y0Ts9Xlgf6hQO0I1iGFJ/7Z2ff
         BqP7135itCR6v7I8y/20I0BJGcaKjVwoPDFZByD2dHt/R+lagh5rFCzluNNhRWMDtQAW
         24hFTLLk8inzRttWFumFN0/DxUMUNNWePe6N8ruegsHGfuQIdpqu8XNiq6Sz6UTTIkfr
         LWWQ==
X-Forwarded-Encrypted: i=1; AFNElJ9A8IY58+Klu1OjQYe2ebrsJ7dwy1nu32Ds8vAjXyH6kn1/z80JiOkakMOQ82UokpDCE4Lw2f8K3waRZPKGxzM=@vger.kernel.org
X-Gm-Message-State: AOJu0YzariUpjQYSuqgDh9wvq8DoDbsGfF75sovD4ouJtJsNPPL2sOMJ
	w8NNzP5yCD8emP9RxFdob0KA7fQcOEOYhi/8o+Nzx6HOPGruSkwVP6GUDCLvPks8flmdxl6An7R
	74E7xEwIfdJAjvenLof7j7mxr5RhQBApZG/VRuMIgoOhqrV6bVyp2lUIfr4M=
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:1613:b0:69e:b425:744d with SMTP id
 006d021491bc7-69eb4257929mr2028092eaf.6.1781037893299; Tue, 09 Jun 2026
 13:44:53 -0700 (PDT)
Date: Tue, 09 Jun 2026 13:44:53 -0700
In-Reply-To: <20260609072750.318774-1-kadlec@netfilter.org>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a287b45.39669fcc.33b062.00a2.GAE@google.com>
Subject: [syzbot ci] Re: netfilter: ipset fixes, second batch
From: syzbot ci <syzbot+ci586baf4859d7e73f@syzkaller.appspotmail.com>
To: kadlec@netfilter.org, netfilter-devel@vger.kernel.org, pablo@netfilter.org
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v2] netfilter: ipset fixes, second batch
https://lore.kernel.org/all/20260609072750.318774-1-kadlec@netfilter.org
* [PATCH v2 1/9] netfilter: ipset: Don't use test_bit() in lockless RCU readers in hash types
* [PATCH v2 2/9] netfilter: ipset: Don't use test_bit() in lockless RCU readers in bitmap types
* [PATCH v2 3/9] netfilter: ipset: fix order of kfree_rcu() and rcu_assign_pointer()
* [PATCH v2 4/9] netfilter: ipset: Extend the rcu locked area properly
* [PATCH v2 5/9] netfilter: ipset: exlude gc when resize is in progress
* [PATCH v2 6/9] netfilter: ipset: fix potential double free at resize/del
* [PATCH v2 7/9] netfilter: ipset: make sure gc is properly stopped
* [PATCH v2 8/9] netfilter: ipset: fix potential torn read in reuse/forceadd cases
* [PATCH v2 9/9] netfilter: ipset: rework cidr bookkeeping

and found the following issues:
* BUG: sleeping function called from invalid context in hash_ip4_resize
* BUG: sleeping function called from invalid context in hash_ipmark4_resize
* BUG: sleeping function called from invalid context in hash_ipport4_resize
* BUG: sleeping function called from invalid context in hash_ipportnet6_resize
* BUG: sleeping function called from invalid context in hash_net4_resize

Full report is available here:
https://ci.syzbot.org/series/60ee40c9-c67a-4d2e-8c5c-7cbc4f2c35e3

***

BUG: sleeping function called from invalid context in hash_ip4_resize

tree:      nf-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netfilter/nf-next.git
base:      bfa3d89cc15c09f7d1581c834a5ed725189ec19f
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/63302f1b-7561-4e38-b3bc-890b9b65c7c1/config
syz repro: https://ci.syzbot.org/findings/3f7d3e03-c73e-47d2-a969-7c113b094a23/syz_repro

BUG: sleeping function called from invalid context at ./include/linux/sched/mm.h:323
in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 5837, name: syz.0.17
preempt_count: 201, expected: 0
RCU nest depth: 0, expected: 0
2 locks held by syz.0.17/5837:
 #0: ffffffff9a952da0 (nfnl_subsys_ipset){+.+.}-{4:4}, at: nfnl_lock net/netfilter/nfnetlink.c:96 [inline]
 #0: ffffffff9a952da0 (nfnl_subsys_ipset){+.+.}-{4:4}, at: nfnetlink_rcv_msg+0xa71/0x12c0 net/netfilter/nfnetlink.c:293
 #1: ffff8881bbd48028 (&t->gc_lock){+...}-{3:3}, at: spin_lock_bh include/linux/spinlock.h:348 [inline]
 #1: ffff8881bbd48028 (&t->gc_lock){+...}-{3:3}, at: hash_ip4_resize+0x149/0x1a80 net/netfilter/ipset/ip_set_hash_gen.h:667
Preemption disabled at:
[<0000000000000000>] 0x0
CPU: 0 UID: 0 PID: 5837 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 __might_resched+0x378/0x4d0 kernel/sched/core.c:9163
 might_alloc include/linux/sched/mm.h:323 [inline]
 slab_pre_alloc_hook mm/slub.c:4521 [inline]
 slab_alloc_node mm/slub.c:4876 [inline]
 __do_kmalloc_node mm/slub.c:5295 [inline]
 __kvmalloc_node_noprof+0x164/0x8a0 mm/slub.c:6833
 hash_ip4_resize+0x278/0x1a80 net/netfilter/ipset/ip_set_hash_gen.h:682
 call_ad+0x562/0xb60 net/netfilter/ipset/ip_set_core.c:1758
 ip_set_ad+0x824/0x9d0 net/netfilter/ipset/ip_set_core.c:1842
 nfnetlink_rcv_msg+0xc03/0x12c0 net/netfilter/nfnetlink.c:300
 netlink_rcv_skb+0x232/0x4b0 net/netlink/af_netlink.c:2556
 nfnetlink_rcv+0x2c0/0x27b0 net/netfilter/nfnetlink.c:667
 netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
 netlink_unicast+0x75c/0x8e0 net/netlink/af_netlink.c:1345
 netlink_sendmsg+0x813/0xb40 net/netlink/af_netlink.c:1900
 sock_sendmsg_nosec net/socket.c:787 [inline]
 __sock_sendmsg net/socket.c:802 [inline]
 ____sys_sendmsg+0x972/0x9f0 net/socket.c:2698
 ___sys_sendmsg+0x2a5/0x360 net/socket.c:2752
 __sys_sendmsg net/socket.c:2784 [inline]
 __do_sys_sendmsg net/socket.c:2789 [inline]
 __se_sys_sendmsg net/socket.c:2787 [inline]
 __x64_sys_sendmsg+0x1bd/0x2a0 net/socket.c:2787
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fb3ded9ce59
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fb3dfcee028 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007fb3df015fa0 RCX: 00007fb3ded9ce59
RDX: 00000000240008c4 RSI: 0000200000000000 RDI: 0000000000000004
RBP: 00007fb3dee32d6f R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fb3df016038 R14: 00007fb3df015fa0 R15: 00007ffd0454d2c8
 </TASK>
INFO: trying to register non-static key.
The code is fine but needs lockdep annotation, or maybe
you didn't initialize this object before use?
turning off the locking correctness validator.
CPU: 0 UID: 0 PID: 5837 Comm: syz.0.17 Tainted: G        W           syzkaller #0 PREEMPT(full) 
Tainted: [W]=WARN
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 assign_lock_key+0x133/0x150 kernel/locking/lockdep.c:984
 register_lock_class+0xcc/0x2e0 kernel/locking/lockdep.c:1299
 __lock_acquire+0xad/0x2cf0 kernel/locking/lockdep.c:5112
 lock_acquire+0x106/0x350 kernel/locking/lockdep.c:5868
 __raw_spin_lock_bh include/linux/spinlock_api_smp.h:150 [inline]
 _raw_spin_lock_bh+0x36/0x50 kernel/locking/spinlock.c:182
 spin_lock_bh include/linux/spinlock.h:348 [inline]
 hash_ip4_resize+0x149/0x1a80 net/netfilter/ipset/ip_set_hash_gen.h:667
 call_ad+0x463/0xb60 net/netfilter/ipset/ip_set_core.c:1758
 ip_set_ad+0x824/0x9d0 net/netfilter/ipset/ip_set_core.c:1842
 nfnetlink_rcv_msg+0xc03/0x12c0 net/netfilter/nfnetlink.c:300
 netlink_rcv_skb+0x232/0x4b0 net/netlink/af_netlink.c:2556
 nfnetlink_rcv+0x2c0/0x27b0 net/netfilter/nfnetlink.c:667
 netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
 netlink_unicast+0x75c/0x8e0 net/netlink/af_netlink.c:1345
 netlink_sendmsg+0x813/0xb40 net/netlink/af_netlink.c:1900
 sock_sendmsg_nosec net/socket.c:787 [inline]
 __sock_sendmsg net/socket.c:802 [inline]
 ____sys_sendmsg+0x972/0x9f0 net/socket.c:2698
 ___sys_sendmsg+0x2a5/0x360 net/socket.c:2752
 __sys_sendmsg net/socket.c:2784 [inline]
 __do_sys_sendmsg net/socket.c:2789 [inline]
 __se_sys_sendmsg net/socket.c:2787 [inline]
 __x64_sys_sendmsg+0x1bd/0x2a0 net/socket.c:2787
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fb3ded9ce59
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fb3dfcee028 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007fb3df015fa0 RCX: 00007fb3ded9ce59
RDX: 00000000240008c4 RSI: 0000200000000000 RDI: 0000000000000004
RBP: 00007fb3dee32d6f R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fb3df016038 R14: 00007fb3df015fa0 R15: 00007ffd0454d2c8
 </TASK>
Set syz1 is full, maxelem 65536 reached


***

BUG: sleeping function called from invalid context in hash_ipmark4_resize

tree:      nf-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netfilter/nf-next.git
base:      bfa3d89cc15c09f7d1581c834a5ed725189ec19f
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/63302f1b-7561-4e38-b3bc-890b9b65c7c1/config
syz repro: https://ci.syzbot.org/findings/57335612-22e3-4e78-a4ec-3d06321de960/syz_repro

BUG: sleeping function called from invalid context at ./include/linux/sched/mm.h:323
in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 5839, name: syz.1.18
preempt_count: 201, expected: 0
RCU nest depth: 0, expected: 0
2 locks held by syz.1.18/5839:
 #0: ffffffff9a952da0 (nfnl_subsys_ipset){+.+.}-{4:4}, at: nfnl_lock net/netfilter/nfnetlink.c:96 [inline]
 #0: ffffffff9a952da0 (nfnl_subsys_ipset){+.+.}-{4:4}, at: nfnetlink_rcv_msg+0xa71/0x12c0 net/netfilter/nfnetlink.c:293
 #1: ffff888168150028 (&t->gc_lock){+...}-{3:3}, at: spin_lock_bh include/linux/spinlock.h:348 [inline]
 #1: ffff888168150028 (&t->gc_lock){+...}-{3:3}, at: hash_ipmark4_resize+0x13f/0x1ae0 net/netfilter/ipset/ip_set_hash_gen.h:667
Preemption disabled at:
[<0000000000000000>] 0x0
CPU: 1 UID: 0 PID: 5839 Comm: syz.1.18 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 __might_resched+0x378/0x4d0 kernel/sched/core.c:9163
 might_alloc include/linux/sched/mm.h:323 [inline]
 slab_pre_alloc_hook mm/slub.c:4521 [inline]
 slab_alloc_node mm/slub.c:4876 [inline]
 __do_kmalloc_node mm/slub.c:5295 [inline]
 __kvmalloc_node_noprof+0x164/0x8a0 mm/slub.c:6833
 hash_ipmark4_resize+0x26f/0x1ae0 net/netfilter/ipset/ip_set_hash_gen.h:682
 call_ad+0x562/0xb60 net/netfilter/ipset/ip_set_core.c:1758
 ip_set_ad+0x824/0x9d0 net/netfilter/ipset/ip_set_core.c:1842
 nfnetlink_rcv_msg+0xc03/0x12c0 net/netfilter/nfnetlink.c:300
 netlink_rcv_skb+0x232/0x4b0 net/netlink/af_netlink.c:2556
 nfnetlink_rcv+0x2c0/0x27b0 net/netfilter/nfnetlink.c:667
 netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
 netlink_unicast+0x75c/0x8e0 net/netlink/af_netlink.c:1345
 netlink_sendmsg+0x813/0xb40 net/netlink/af_netlink.c:1900
 sock_sendmsg_nosec net/socket.c:787 [inline]
 __sock_sendmsg net/socket.c:802 [inline]
 ____sys_sendmsg+0x972/0x9f0 net/socket.c:2698
 ___sys_sendmsg+0x2a5/0x360 net/socket.c:2752
 __sys_sendmsg net/socket.c:2784 [inline]
 __do_sys_sendmsg net/socket.c:2789 [inline]
 __se_sys_sendmsg net/socket.c:2787 [inline]
 __x64_sys_sendmsg+0x1bd/0x2a0 net/socket.c:2787
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f37dad9ce59
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f37dbd30028 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007f37db015fa0 RCX: 00007f37dad9ce59
RDX: 00000000040c0080 RSI: 00002000000002c0 RDI: 0000000000000004
RBP: 00007f37dae32d6f R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f37db016038 R14: 00007f37db015fa0 R15: 00007fff6c4f3458
 </TASK>
INFO: trying to register non-static key.
The code is fine but needs lockdep annotation, or maybe
you didn't initialize this object before use?
turning off the locking correctness validator.
CPU: 1 UID: 0 PID: 5839 Comm: syz.1.18 Tainted: G        W           syzkaller #0 PREEMPT(full) 
Tainted: [W]=WARN
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 assign_lock_key+0x133/0x150 kernel/locking/lockdep.c:984
 register_lock_class+0xcc/0x2e0 kernel/locking/lockdep.c:1299
 __lock_acquire+0xad/0x2cf0 kernel/locking/lockdep.c:5112
 lock_acquire+0x106/0x350 kernel/locking/lockdep.c:5868
 __raw_spin_lock_bh include/linux/spinlock_api_smp.h:150 [inline]
 _raw_spin_lock_bh+0x36/0x50 kernel/locking/spinlock.c:182
 spin_lock_bh include/linux/spinlock.h:348 [inline]
 hash_ipmark4_resize+0x13f/0x1ae0 net/netfilter/ipset/ip_set_hash_gen.h:667
 call_ad+0x463/0xb60 net/netfilter/ipset/ip_set_core.c:1758
 ip_set_ad+0x824/0x9d0 net/netfilter/ipset/ip_set_core.c:1842
 nfnetlink_rcv_msg+0xc03/0x12c0 net/netfilter/nfnetlink.c:300
 netlink_rcv_skb+0x232/0x4b0 net/netlink/af_netlink.c:2556
 nfnetlink_rcv+0x2c0/0x27b0 net/netfilter/nfnetlink.c:667
 netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
 netlink_unicast+0x75c/0x8e0 net/netlink/af_netlink.c:1345
 netlink_sendmsg+0x813/0xb40 net/netlink/af_netlink.c:1900
 sock_sendmsg_nosec net/socket.c:787 [inline]
 __sock_sendmsg net/socket.c:802 [inline]
 ____sys_sendmsg+0x972/0x9f0 net/socket.c:2698
 ___sys_sendmsg+0x2a5/0x360 net/socket.c:2752
 __sys_sendmsg net/socket.c:2784 [inline]
 __do_sys_sendmsg net/socket.c:2789 [inline]
 __se_sys_sendmsg net/socket.c:2787 [inline]
 __x64_sys_sendmsg+0x1bd/0x2a0 net/socket.c:2787
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f37dad9ce59
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f37dbd30028 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007f37db015fa0 RCX: 00007f37dad9ce59
RDX: 00000000040c0080 RSI: 00002000000002c0 RDI: 0000000000000004
RBP: 00007f37dae32d6f R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f37db016038 R14: 00007f37db015fa0 R15: 00007fff6c4f3458
 </TASK>
Set syz1 is full, maxelem 65536 reached


***

BUG: sleeping function called from invalid context in hash_ipport4_resize

tree:      nf-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netfilter/nf-next.git
base:      bfa3d89cc15c09f7d1581c834a5ed725189ec19f
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/63302f1b-7561-4e38-b3bc-890b9b65c7c1/config
syz repro: https://ci.syzbot.org/findings/79e04816-4100-48fa-8d49-43c546bef2fa/syz_repro

BUG: sleeping function called from invalid context at ./include/linux/sched/mm.h:323
in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 5819, name: syz.2.19
preempt_count: 201, expected: 0
RCU nest depth: 0, expected: 0
2 locks held by syz.2.19/5819:
 #0: ffffffff9a952da0 (nfnl_subsys_ipset){+.+.}-{4:4}, at: nfnl_lock net/netfilter/nfnetlink.c:96 [inline]
 #0: ffffffff9a952da0 (nfnl_subsys_ipset){+.+.}-{4:4}, at: nfnetlink_rcv_msg+0xa71/0x12c0 net/netfilter/nfnetlink.c:293
 #1: ffff888116501828 (&t->gc_lock){+...}-{3:3}, at: spin_lock_bh include/linux/spinlock.h:348 [inline]
 #1: ffff888116501828 (&t->gc_lock){+...}-{3:3}, at: hash_ipport4_resize+0x13f/0x1ae0 net/netfilter/ipset/ip_set_hash_gen.h:667
Preemption disabled at:
[<0000000000000000>] 0x0
CPU: 0 UID: 0 PID: 5819 Comm: syz.2.19 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 __might_resched+0x378/0x4d0 kernel/sched/core.c:9163
 might_alloc include/linux/sched/mm.h:323 [inline]
 slab_pre_alloc_hook mm/slub.c:4521 [inline]
 slab_alloc_node mm/slub.c:4876 [inline]
 __do_kmalloc_node mm/slub.c:5295 [inline]
 __kvmalloc_node_noprof+0x164/0x8a0 mm/slub.c:6833
 hash_ipport4_resize+0x219/0x1ae0 net/netfilter/ipset/ip_set_hash_gen.h:677
 call_ad+0x562/0xb60 net/netfilter/ipset/ip_set_core.c:1758
 ip_set_ad+0x824/0x9d0 net/netfilter/ipset/ip_set_core.c:1842
 nfnetlink_rcv_msg+0xc03/0x12c0 net/netfilter/nfnetlink.c:300
 netlink_rcv_skb+0x232/0x4b0 net/netlink/af_netlink.c:2556
 nfnetlink_rcv+0x2c0/0x27b0 net/netfilter/nfnetlink.c:667
 netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
 netlink_unicast+0x75c/0x8e0 net/netlink/af_netlink.c:1345
 netlink_sendmsg+0x813/0xb40 net/netlink/af_netlink.c:1900
 sock_sendmsg_nosec net/socket.c:787 [inline]
 __sock_sendmsg net/socket.c:802 [inline]
 ____sys_sendmsg+0x972/0x9f0 net/socket.c:2698
 ___sys_sendmsg+0x2a5/0x360 net/socket.c:2752
 __sys_sendmsg net/socket.c:2784 [inline]
 __do_sys_sendmsg net/socket.c:2789 [inline]
 __se_sys_sendmsg net/socket.c:2787 [inline]
 __x64_sys_sendmsg+0x1bd/0x2a0 net/socket.c:2787
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fe5c739ce59
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fe5c8339028 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007fe5c7615fa0 RCX: 00007fe5c739ce59
RDX: 0000000000000090 RSI: 00002000000002c0 RDI: 0000000000000004
RBP: 00007fe5c7432d6f R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fe5c7616038 R14: 00007fe5c7615fa0 R15: 00007ffd329f2868
 </TASK>
INFO: trying to register non-static key.
The code is fine but needs lockdep annotation, or maybe
you didn't initialize this object before use?
turning off the locking correctness validator.
CPU: 1 UID: 0 PID: 5819 Comm: syz.2.19 Tainted: G        W           syzkaller #0 PREEMPT(full) 
Tainted: [W]=WARN
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 assign_lock_key+0x133/0x150 kernel/locking/lockdep.c:984
 register_lock_class+0xcc/0x2e0 kernel/locking/lockdep.c:1299
 __lock_acquire+0xad/0x2cf0 kernel/locking/lockdep.c:5112
 lock_acquire+0x106/0x350 kernel/locking/lockdep.c:5868
 __raw_spin_lock_bh include/linux/spinlock_api_smp.h:150 [inline]
 _raw_spin_lock_bh+0x36/0x50 kernel/locking/spinlock.c:182
 spin_lock_bh include/linux/spinlock.h:348 [inline]
 hash_ipport4_resize+0x13f/0x1ae0 net/netfilter/ipset/ip_set_hash_gen.h:667
 call_ad+0x463/0xb60 net/netfilter/ipset/ip_set_core.c:1758
 ip_set_ad+0x824/0x9d0 net/netfilter/ipset/ip_set_core.c:1842
 nfnetlink_rcv_msg+0xc03/0x12c0 net/netfilter/nfnetlink.c:300
 netlink_rcv_skb+0x232/0x4b0 net/netlink/af_netlink.c:2556
 nfnetlink_rcv+0x2c0/0x27b0 net/netfilter/nfnetlink.c:667
 netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
 netlink_unicast+0x75c/0x8e0 net/netlink/af_netlink.c:1345
 netlink_sendmsg+0x813/0xb40 net/netlink/af_netlink.c:1900
 sock_sendmsg_nosec net/socket.c:787 [inline]
 __sock_sendmsg net/socket.c:802 [inline]
 ____sys_sendmsg+0x972/0x9f0 net/socket.c:2698
 ___sys_sendmsg+0x2a5/0x360 net/socket.c:2752
 __sys_sendmsg net/socket.c:2784 [inline]
 __do_sys_sendmsg net/socket.c:2789 [inline]
 __se_sys_sendmsg net/socket.c:2787 [inline]
 __x64_sys_sendmsg+0x1bd/0x2a0 net/socket.c:2787
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fe5c739ce59
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fe5c8339028 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007fe5c7615fa0 RCX: 00007fe5c739ce59
RDX: 0000000000000090 RSI: 00002000000002c0 RDI: 0000000000000004
RBP: 00007fe5c7432d6f R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fe5c7616038 R14: 00007fe5c7615fa0 R15: 00007ffd329f2868
 </TASK>


***

BUG: sleeping function called from invalid context in hash_ipportnet6_resize

tree:      nf-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netfilter/nf-next.git
base:      bfa3d89cc15c09f7d1581c834a5ed725189ec19f
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/63302f1b-7561-4e38-b3bc-890b9b65c7c1/config
syz repro: https://ci.syzbot.org/findings/8502cd2b-1718-4dd7-8c57-c8f6d494a2b7/syz_repro

BUG: sleeping function called from invalid context at ./include/linux/sched/mm.h:323
in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 5835, name: syz.1.18
preempt_count: 201, expected: 0
RCU nest depth: 0, expected: 0
2 locks held by syz.1.18/5835:
 #0: ffffffff9a952da0 (nfnl_subsys_ipset){+.+.}-{4:4}, at: nfnl_lock net/netfilter/nfnetlink.c:96 [inline]
 #0: ffffffff9a952da0 (nfnl_subsys_ipset){+.+.}-{4:4}, at: nfnetlink_rcv_msg+0xa71/0x12c0 net/netfilter/nfnetlink.c:293
 #1: ffff8881114d0028 (&t->gc_lock){+...}-{3:3}, at: spin_lock_bh include/linux/spinlock.h:348 [inline]
 #1: ffff8881114d0028 (&t->gc_lock){+...}-{3:3}, at: hash_ipportnet6_resize+0x170/0x1eb0 net/netfilter/ipset/ip_set_hash_gen.h:667
Preemption disabled at:
[<0000000000000000>] 0x0
CPU: 0 UID: 0 PID: 5835 Comm: syz.1.18 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 __might_resched+0x378/0x4d0 kernel/sched/core.c:9163
 might_alloc include/linux/sched/mm.h:323 [inline]
 slab_pre_alloc_hook mm/slub.c:4521 [inline]
 slab_alloc_node mm/slub.c:4876 [inline]
 __do_kmalloc_node mm/slub.c:5295 [inline]
 __kvmalloc_node_noprof+0x164/0x8a0 mm/slub.c:6833
 hash_ipportnet6_resize+0x31d/0x1eb0 net/netfilter/ipset/ip_set_hash_gen.h:682
 call_ad+0x562/0xb60 net/netfilter/ipset/ip_set_core.c:1758
 ip_set_ad+0x824/0x9d0 net/netfilter/ipset/ip_set_core.c:1842
 nfnetlink_rcv_msg+0xc03/0x12c0 net/netfilter/nfnetlink.c:300
 netlink_rcv_skb+0x232/0x4b0 net/netlink/af_netlink.c:2556
 nfnetlink_rcv+0x2c0/0x27b0 net/netfilter/nfnetlink.c:667
 netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
 netlink_unicast+0x75c/0x8e0 net/netlink/af_netlink.c:1345
 netlink_sendmsg+0x813/0xb40 net/netlink/af_netlink.c:1900
 sock_sendmsg_nosec net/socket.c:787 [inline]
 __sock_sendmsg net/socket.c:802 [inline]
 ____sys_sendmsg+0x972/0x9f0 net/socket.c:2698
 ___sys_sendmsg+0x2a5/0x360 net/socket.c:2752
 __sys_sendmsg net/socket.c:2784 [inline]
 __do_sys_sendmsg net/socket.c:2789 [inline]
 __se_sys_sendmsg net/socket.c:2787 [inline]
 __x64_sys_sendmsg+0x1bd/0x2a0 net/socket.c:2787
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f27c6b9ce59
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f27c7a44028 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007f27c6e15fa0 RCX: 00007f27c6b9ce59
RDX: 0000000000000000 RSI: 00002000000002c0 RDI: 0000000000000004
RBP: 00007f27c6c32d6f R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f27c6e16038 R14: 00007f27c6e15fa0 R15: 00007ffcb0b8a718
 </TASK>
INFO: trying to register non-static key.
The code is fine but needs lockdep annotation, or maybe
you didn't initialize this object before use?
turning off the locking correctness validator.
CPU: 0 UID: 0 PID: 5835 Comm: syz.1.18 Tainted: G        W           syzkaller #0 PREEMPT(full) 
Tainted: [W]=WARN
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 assign_lock_key+0x133/0x150 kernel/locking/lockdep.c:984
 register_lock_class+0xcc/0x2e0 kernel/locking/lockdep.c:1299
 __lock_acquire+0xad/0x2cf0 kernel/locking/lockdep.c:5112
 lock_acquire+0x106/0x350 kernel/locking/lockdep.c:5868
 __raw_spin_lock_bh include/linux/spinlock_api_smp.h:150 [inline]
 _raw_spin_lock_bh+0x36/0x50 kernel/locking/spinlock.c:182
 spin_lock_bh include/linux/spinlock.h:348 [inline]
 hash_ipportnet6_resize+0x170/0x1eb0 net/netfilter/ipset/ip_set_hash_gen.h:667
 call_ad+0x463/0xb60 net/netfilter/ipset/ip_set_core.c:1758
 ip_set_ad+0x824/0x9d0 net/netfilter/ipset/ip_set_core.c:1842
 nfnetlink_rcv_msg+0xc03/0x12c0 net/netfilter/nfnetlink.c:300
 netlink_rcv_skb+0x232/0x4b0 net/netlink/af_netlink.c:2556
 nfnetlink_rcv+0x2c0/0x27b0 net/netfilter/nfnetlink.c:667
 netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
 netlink_unicast+0x75c/0x8e0 net/netlink/af_netlink.c:1345
 netlink_sendmsg+0x813/0xb40 net/netlink/af_netlink.c:1900
 sock_sendmsg_nosec net/socket.c:787 [inline]
 __sock_sendmsg net/socket.c:802 [inline]
 ____sys_sendmsg+0x972/0x9f0 net/socket.c:2698
 ___sys_sendmsg+0x2a5/0x360 net/socket.c:2752
 __sys_sendmsg net/socket.c:2784 [inline]
 __do_sys_sendmsg net/socket.c:2789 [inline]
 __se_sys_sendmsg net/socket.c:2787 [inline]
 __x64_sys_sendmsg+0x1bd/0x2a0 net/socket.c:2787
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f27c6b9ce59
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f27c7a44028 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007f27c6e15fa0 RCX: 00007f27c6b9ce59
RDX: 0000000000000000 RSI: 00002000000002c0 RDI: 0000000000000004
RBP: 00007f27c6c32d6f R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f27c6e16038 R14: 00007f27c6e15fa0 R15: 00007ffcb0b8a718
 </TASK>


***

BUG: sleeping function called from invalid context in hash_net4_resize

tree:      nf-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netfilter/nf-next.git
base:      bfa3d89cc15c09f7d1581c834a5ed725189ec19f
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/63302f1b-7561-4e38-b3bc-890b9b65c7c1/config
syz repro: https://ci.syzbot.org/findings/230cf2b1-2c8b-4558-b095-874702f9bc7d/syz_repro

BUG: sleeping function called from invalid context at ./include/linux/sched/mm.h:323
in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 5814, name: syz.1.18
preempt_count: 201, expected: 0
RCU nest depth: 0, expected: 0
2 locks held by syz.1.18/5814:
 #0: ffffffff9a952da0 (nfnl_subsys_ipset){+.+.}-{4:4}, at: nfnl_lock net/netfilter/nfnetlink.c:96 [inline]
 #0: ffffffff9a952da0 (nfnl_subsys_ipset){+.+.}-{4:4}, at: nfnetlink_rcv_msg+0xa71/0x12c0 net/netfilter/nfnetlink.c:293
 #1: ffff88816a8df028 (&t->gc_lock){+...}-{3:3}, at: spin_lock_bh include/linux/spinlock.h:348 [inline]
 #1: ffff88816a8df028 (&t->gc_lock){+...}-{3:3}, at: hash_net4_resize+0x168/0x1bb0 net/netfilter/ipset/ip_set_hash_gen.h:667
Preemption disabled at:
[<0000000000000000>] 0x0
CPU: 1 UID: 0 PID: 5814 Comm: syz.1.18 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 __might_resched+0x378/0x4d0 kernel/sched/core.c:9163
 might_alloc include/linux/sched/mm.h:323 [inline]
 slab_pre_alloc_hook mm/slub.c:4521 [inline]
 slab_alloc_node mm/slub.c:4876 [inline]
 __do_kmalloc_node mm/slub.c:5295 [inline]
 __kvmalloc_node_noprof+0x164/0x8a0 mm/slub.c:6833
 hash_net4_resize+0x26e/0x1bb0 net/netfilter/ipset/ip_set_hash_gen.h:677
 call_ad+0x562/0xb60 net/netfilter/ipset/ip_set_core.c:1758
 ip_set_ad+0x824/0x9d0 net/netfilter/ipset/ip_set_core.c:1842
 nfnetlink_rcv_msg+0xc03/0x12c0 net/netfilter/nfnetlink.c:300
 netlink_rcv_skb+0x232/0x4b0 net/netlink/af_netlink.c:2556
 nfnetlink_rcv+0x2c0/0x27b0 net/netfilter/nfnetlink.c:667
 netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
 netlink_unicast+0x75c/0x8e0 net/netlink/af_netlink.c:1345
 netlink_sendmsg+0x813/0xb40 net/netlink/af_netlink.c:1900
 sock_sendmsg_nosec net/socket.c:787 [inline]
 __sock_sendmsg net/socket.c:802 [inline]
 ____sys_sendmsg+0x972/0x9f0 net/socket.c:2698
 ___sys_sendmsg+0x2a5/0x360 net/socket.c:2752
 __sys_sendmsg net/socket.c:2784 [inline]
 __do_sys_sendmsg net/socket.c:2789 [inline]
 __se_sys_sendmsg net/socket.c:2787 [inline]
 __x64_sys_sendmsg+0x1bd/0x2a0 net/socket.c:2787
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fe472d9ce59
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fe473bc7028 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007fe473015fa0 RCX: 00007fe472d9ce59
RDX: 0000000004000050 RSI: 0000200000000000 RDI: 0000000000000003
RBP: 00007fe472e32d6f R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fe473016038 R14: 00007fe473015fa0 R15: 00007ffcba742758
 </TASK>
INFO: trying to register non-static key.
The code is fine but needs lockdep annotation, or maybe
you didn't initialize this object before use?
turning off the locking correctness validator.
CPU: 1 UID: 0 PID: 5814 Comm: syz.1.18 Tainted: G        W           syzkaller #0 PREEMPT(full) 
Tainted: [W]=WARN
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 assign_lock_key+0x133/0x150 kernel/locking/lockdep.c:984
 register_lock_class+0xcc/0x2e0 kernel/locking/lockdep.c:1299
 __lock_acquire+0xad/0x2cf0 kernel/locking/lockdep.c:5112
 lock_acquire+0x106/0x350 kernel/locking/lockdep.c:5868
 __raw_spin_lock_bh include/linux/spinlock_api_smp.h:150 [inline]
 _raw_spin_lock_bh+0x36/0x50 kernel/locking/spinlock.c:182
 spin_lock_bh include/linux/spinlock.h:348 [inline]
 hash_net4_resize+0x168/0x1bb0 net/netfilter/ipset/ip_set_hash_gen.h:667
 call_ad+0x463/0xb60 net/netfilter/ipset/ip_set_core.c:1758
 ip_set_ad+0x824/0x9d0 net/netfilter/ipset/ip_set_core.c:1842
 nfnetlink_rcv_msg+0xc03/0x12c0 net/netfilter/nfnetlink.c:300
 netlink_rcv_skb+0x232/0x4b0 net/netlink/af_netlink.c:2556
 nfnetlink_rcv+0x2c0/0x27b0 net/netfilter/nfnetlink.c:667
 netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
 netlink_unicast+0x75c/0x8e0 net/netlink/af_netlink.c:1345
 netlink_sendmsg+0x813/0xb40 net/netlink/af_netlink.c:1900
 sock_sendmsg_nosec net/socket.c:787 [inline]
 __sock_sendmsg net/socket.c:802 [inline]
 ____sys_sendmsg+0x972/0x9f0 net/socket.c:2698
 ___sys_sendmsg+0x2a5/0x360 net/socket.c:2752
 __sys_sendmsg net/socket.c:2784 [inline]
 __do_sys_sendmsg net/socket.c:2789 [inline]
 __se_sys_sendmsg net/socket.c:2787 [inline]
 __x64_sys_sendmsg+0x1bd/0x2a0 net/socket.c:2787
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fe472d9ce59
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fe473bc7028 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007fe473015fa0 RCX: 00007fe472d9ce59
RDX: 0000000004000050 RSI: 0000200000000000 RDI: 0000000000000003
RBP: 00007fe472e32d6f R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fe473016038 R14: 00007fe473015fa0 R15: 00007ffcba742758
 </TASK>
Set syz1 is full, maxelem 65536 reached


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

To test a patch for this bug, please reply with `#syz test`
(should be on a separate line).

The patch should be attached to the email.
Note: arguments like custom git repos and branches are not supported.
