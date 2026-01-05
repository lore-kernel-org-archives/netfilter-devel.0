Received: from mail-oo1-f78.google.com (mail-oo1-f78.google.com [209.85.161.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43092333448
	for <netfilter-devel@vger.kernel.org>; Mon,  5 Jan 2026 08:31:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767601887; cv=none; b=B5zhEjVkeYuc3wBsBEuvQ/fHdN1GUD4pSlweQUcVl+9RS3JRJx+ml08s79iqUQYUvwNGmF/QV0IDCkzEDzPgjTgEpb+JoGXXQExrPcPdO/cYfy3ki47tRCR7BG75vj9TyLulHmVm8gHBQquZc3e+OOXBbTSClSX718CwiTJxTSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767601887; c=relaxed/simple;
	bh=HNmhhznQJuu33DLS+2t6q801usE+P2O3v/lqJE76mfo=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=q2BpBq62fANBBTEyvvxawtaSXtsZrVcP+Y4JLHf9P/XKWPlZMGjspHh8D+tGCpiaagkA0rg6mFtqyDMv9zlR2XCEddRRNM4dLVVFicQTPBqLWkufGEV7UT1GWsQjpX5084jRaTHu0Rc1s4GWuji5MdXfsyVZpWgRMsa3FhKoDVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f78.google.com with SMTP id 006d021491bc7-65b2cd67cceso27788911eaf.0
        for <netfilter-devel@vger.kernel.org>; Mon, 05 Jan 2026 00:31:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767601884; x=1768206684;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9+E81ZK8kW7VMQC24dUJUhLhJ8nIdci8AoW4+w+wf2o=;
        b=wLpZOu62p5RWnWncuh4E/zn5eQDteTazTjVrX37xPnHPOTv/4Lj4sJyva9swxk+JRN
         3Zz9kxUJRidmNJY0k0xaOXFtrfziE6rARG5k1YrJ1lYL9/nCS31BStorGVA3Q1lNTABB
         qLngDKjFM3dn/vLY8Les7dQpcSr4uLNcmvTXrv0WrCEOgE8hZ2euAtFZbjpBPm20Y95H
         Q3A32dSjUTHMr7L+rFZtgj9f6FXtdejFiPp6o/DO9YpKNjigWeGZIIAlkjiyQXH3pJbE
         je1jf+d3VeJbvzgKcJccPUmZVru7jLhSlwS9i/rv+P4kJId9IHUi8u2y6/DSaSaJc7+x
         djrw==
X-Forwarded-Encrypted: i=1; AJvYcCVyBdFdXHAC9H06ZA21/iIAK63vJ4AROtJ/udFCyqq0oGOZDeMJbkeGCbMLdDJtnf44u6QY5rmYgdQMT09bkeo=@vger.kernel.org
X-Gm-Message-State: AOJu0YxySFqLtJbnsY/S3gnUooagdlfy+sor+vaSYDTO2OmDrrDX65qB
	l/9W3itWEOuymhe3gaOMxkeUowuI53iaZ4qWnoJAOl0vSqJMOQiIaIancyokaOF9JGRPS2SWInh
	Lxc3KtZKDqMQvq+wR4X6cldbGeQfCupBM3ZkhKFXYCZfky+66523kc/QxWe8=
X-Google-Smtp-Source: AGHT+IEdh0N1IsuCsTnZ+LDmkPk3wrN1GE3rg7IbJKz0xbqKlhXEd2WjJB7m1DqbuJTt3U2VLT2UILkrQkas9cqJGZC+cLxEcyF+
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:162a:b0:656:8548:d866 with SMTP id
 006d021491bc7-65d0e9324e2mr20576414eaf.1.1767601884251; Mon, 05 Jan 2026
 00:31:24 -0800 (PST)
Date: Mon, 05 Jan 2026 00:31:24 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <695b76dc.050a0220.1c9965.0029.GAE@google.com>
Subject: [syzbot] [netfilter?] possible deadlock in nf_tables_dumpreset_rules
From: syzbot <syzbot+ee287f5effa60050d9ac@syzkaller.appspotmail.com>
To: coreteam@netfilter.org, davem@davemloft.net, edumazet@google.com, 
	fw@strlen.de, horms@kernel.org, kadlec@netfilter.org, kuba@kernel.org, 
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org, 
	netfilter-devel@vger.kernel.org, pabeni@redhat.com, pablo@netfilter.org, 
	phil@nwl.cc, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    54e82e93ca93 Merge tag 'core_urgent_for_v6.19_rc4' of git:..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=10b1ee22580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=8bfa57a8c0ab3aa8
dashboard link: https://syzkaller.appspot.com/bug?extid=ee287f5effa60050d9ac
compiler:       gcc (Debian 12.2.0-14+deb12u1) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40
userspace arch: i386

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-54e82e93.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/c7af41d4f0f4/vmlinux-54e82e93.xz
kernel image: https://storage.googleapis.com/syzbot-assets/02aa2250dd4f/bzImage-54e82e93.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+ee287f5effa60050d9ac@syzkaller.appspotmail.com

netlink: 48 bytes leftover after parsing attributes in process `syz.8.6539'.
======================================================
WARNING: possible circular locking dependency detected
syzkaller #0 Tainted: G             L     
------------------------------------------------------
syz.8.6539/2008 is trying to acquire lock:
ffff888052e32cd8 (&nft_net->commit_mutex){+.+.}-{4:4}, at: nf_tables_dumpreset_rules+0x6f/0xa0 net/netfilter/nf_tables_api.c:3913

but task is already holding lock:
ffff888025cb16f0 (nlk_cb_mutex-NETFILTER){+.+.}-{4:4}, at: __netlink_dump_start+0x150/0x990 net/netlink/af_netlink.c:2404

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #2 (nlk_cb_mutex-NETFILTER){+.+.}-{4:4}:
       __mutex_lock_common kernel/locking/mutex.c:614 [inline]
       __mutex_lock+0x1aa/0x1ca0 kernel/locking/mutex.c:776
       __netlink_dump_start+0x150/0x990 net/netlink/af_netlink.c:2404
       netlink_dump_start include/linux/netlink.h:341 [inline]
       ip_set_dump+0x17f/0x210 net/netfilter/ipset/ip_set_core.c:1717
       nfnetlink_rcv_msg+0x9fc/0x1200 net/netfilter/nfnetlink.c:302
       netlink_rcv_skb+0x158/0x420 net/netlink/af_netlink.c:2550
       nfnetlink_rcv+0x1b3/0x430 net/netfilter/nfnetlink.c:669
       netlink_unicast_kernel net/netlink/af_netlink.c:1318 [inline]
       netlink_unicast+0x5aa/0x870 net/netlink/af_netlink.c:1344
       netlink_sendmsg+0x8c8/0xdd0 net/netlink/af_netlink.c:1894
       sock_sendmsg_nosec net/socket.c:727 [inline]
       __sock_sendmsg net/socket.c:742 [inline]
       ____sys_sendmsg+0xa5d/0xc30 net/socket.c:2592
       ___sys_sendmsg+0x134/0x1d0 net/socket.c:2646
       __sys_sendmsg+0x16d/0x220 net/socket.c:2678
       do_syscall_32_irqs_on arch/x86/entry/syscall_32.c:83 [inline]
       __do_fast_syscall_32+0xe8/0x680 arch/x86/entry/syscall_32.c:307
       do_fast_syscall_32+0x32/0x80 arch/x86/entry/syscall_32.c:332
       entry_SYSENTER_compat_after_hwframe+0x84/0x8e

-> #1 (nfnl_subsys_ipset){+.+.}-{4:4}:
       __mutex_lock_common kernel/locking/mutex.c:614 [inline]
       __mutex_lock+0x1aa/0x1ca0 kernel/locking/mutex.c:776
       ip_set_nfnl_get_byindex+0x7c/0x290 net/netfilter/ipset/ip_set_core.c:909
       set_target_v1_checkentry+0x1ac/0x570 net/netfilter/xt_set.c:313
       xt_check_target+0x27c/0xa40 net/netfilter/x_tables.c:1038
       nft_target_init+0x459/0x7d0 net/netfilter/nft_compat.c:267
       nf_tables_newexpr net/netfilter/nf_tables_api.c:3550 [inline]
       nf_tables_newrule+0xedd/0x2910 net/netfilter/nf_tables_api.c:4419
       nfnetlink_rcv_batch+0x190d/0x2350 net/netfilter/nfnetlink.c:526
       nfnetlink_rcv_skb_batch net/netfilter/nfnetlink.c:649 [inline]
       nfnetlink_rcv+0x3c1/0x430 net/netfilter/nfnetlink.c:667
       netlink_unicast_kernel net/netlink/af_netlink.c:1318 [inline]
       netlink_unicast+0x5aa/0x870 net/netlink/af_netlink.c:1344
       netlink_sendmsg+0x8c8/0xdd0 net/netlink/af_netlink.c:1894
       sock_sendmsg_nosec net/socket.c:727 [inline]
       __sock_sendmsg net/socket.c:742 [inline]
       ____sys_sendmsg+0xa5d/0xc30 net/socket.c:2592
       ___sys_sendmsg+0x134/0x1d0 net/socket.c:2646
       __sys_sendmsg+0x16d/0x220 net/socket.c:2678
       do_syscall_32_irqs_on arch/x86/entry/syscall_32.c:83 [inline]
       __do_fast_syscall_32+0xe8/0x680 arch/x86/entry/syscall_32.c:307
       do_fast_syscall_32+0x32/0x80 arch/x86/entry/syscall_32.c:332
       entry_SYSENTER_compat_after_hwframe+0x84/0x8e

-> #0 (&nft_net->commit_mutex){+.+.}-{4:4}:
       check_prev_add kernel/locking/lockdep.c:3165 [inline]
       check_prevs_add kernel/locking/lockdep.c:3284 [inline]
       validate_chain kernel/locking/lockdep.c:3908 [inline]
       __lock_acquire+0x1669/0x2890 kernel/locking/lockdep.c:5237
       lock_acquire kernel/locking/lockdep.c:5868 [inline]
       lock_acquire+0x179/0x330 kernel/locking/lockdep.c:5825
       __mutex_lock_common kernel/locking/mutex.c:614 [inline]
       __mutex_lock+0x1aa/0x1ca0 kernel/locking/mutex.c:776
       nf_tables_dumpreset_rules+0x6f/0xa0 net/netfilter/nf_tables_api.c:3913
       netlink_dump+0x539/0xd30 net/netlink/af_netlink.c:2325
       __netlink_dump_start+0x6d6/0x990 net/netlink/af_netlink.c:2440
       netlink_dump_start include/linux/netlink.h:341 [inline]
       nft_netlink_dump_start_rcu+0x81/0x1f0 net/netfilter/nf_tables_api.c:1309
       nf_tables_getrule_reset+0x56b/0x6b0 net/netfilter/nf_tables_api.c:4053
       nfnetlink_rcv_msg+0x583/0x1200 net/netfilter/nfnetlink.c:290
       netlink_rcv_skb+0x158/0x420 net/netlink/af_netlink.c:2550
       nfnetlink_rcv+0x1b3/0x430 net/netfilter/nfnetlink.c:669
       netlink_unicast_kernel net/netlink/af_netlink.c:1318 [inline]
       netlink_unicast+0x5aa/0x870 net/netlink/af_netlink.c:1344
       netlink_sendmsg+0x8c8/0xdd0 net/netlink/af_netlink.c:1894
       sock_sendmsg_nosec net/socket.c:727 [inline]
       __sock_sendmsg net/socket.c:742 [inline]
       ____sys_sendmsg+0xa5d/0xc30 net/socket.c:2592
       ___sys_sendmsg+0x134/0x1d0 net/socket.c:2646
       __sys_sendmsg+0x16d/0x220 net/socket.c:2678
       do_syscall_32_irqs_on arch/x86/entry/syscall_32.c:83 [inline]
       __do_fast_syscall_32+0xe8/0x680 arch/x86/entry/syscall_32.c:307
       do_fast_syscall_32+0x32/0x80 arch/x86/entry/syscall_32.c:332
       entry_SYSENTER_compat_after_hwframe+0x84/0x8e

other info that might help us debug this:

Chain exists of:
  &nft_net->commit_mutex --> nfnl_subsys_ipset --> nlk_cb_mutex-NETFILTER

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(nlk_cb_mutex-NETFILTER);
                               lock(nfnl_subsys_ipset);
                               lock(nlk_cb_mutex-NETFILTER);
  lock(&nft_net->commit_mutex);

 *** DEADLOCK ***

1 lock held by syz.8.6539/2008:
 #0: ffff888025cb16f0 (nlk_cb_mutex-NETFILTER){+.+.}-{4:4}, at: __netlink_dump_start+0x150/0x990 net/netlink/af_netlink.c:2404

stack backtrace:
CPU: 2 UID: 0 PID: 2008 Comm: syz.8.6539 Tainted: G             L      syzkaller #0 PREEMPT(full) 
Tainted: [L]=SOFTLOCKUP
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x116/0x1f0 lib/dump_stack.c:120
 print_circular_bug+0x275/0x340 kernel/locking/lockdep.c:2043
 check_noncircular+0x146/0x160 kernel/locking/lockdep.c:2175
 check_prev_add kernel/locking/lockdep.c:3165 [inline]
 check_prevs_add kernel/locking/lockdep.c:3284 [inline]
 validate_chain kernel/locking/lockdep.c:3908 [inline]
 __lock_acquire+0x1669/0x2890 kernel/locking/lockdep.c:5237
 lock_acquire kernel/locking/lockdep.c:5868 [inline]
 lock_acquire+0x179/0x330 kernel/locking/lockdep.c:5825
 __mutex_lock_common kernel/locking/mutex.c:614 [inline]
 __mutex_lock+0x1aa/0x1ca0 kernel/locking/mutex.c:776
 nf_tables_dumpreset_rules+0x6f/0xa0 net/netfilter/nf_tables_api.c:3913
 netlink_dump+0x539/0xd30 net/netlink/af_netlink.c:2325
 __netlink_dump_start+0x6d6/0x990 net/netlink/af_netlink.c:2440
 netlink_dump_start include/linux/netlink.h:341 [inline]
 nft_netlink_dump_start_rcu+0x81/0x1f0 net/netfilter/nf_tables_api.c:1309
 nf_tables_getrule_reset+0x56b/0x6b0 net/netfilter/nf_tables_api.c:4053
 nfnetlink_rcv_msg+0x583/0x1200 net/netfilter/nfnetlink.c:290
 netlink_rcv_skb+0x158/0x420 net/netlink/af_netlink.c:2550
 nfnetlink_rcv+0x1b3/0x430 net/netfilter/nfnetlink.c:669
 netlink_unicast_kernel net/netlink/af_netlink.c:1318 [inline]
 netlink_unicast+0x5aa/0x870 net/netlink/af_netlink.c:1344
 netlink_sendmsg+0x8c8/0xdd0 net/netlink/af_netlink.c:1894
 sock_sendmsg_nosec net/socket.c:727 [inline]
 __sock_sendmsg net/socket.c:742 [inline]
 ____sys_sendmsg+0xa5d/0xc30 net/socket.c:2592
 ___sys_sendmsg+0x134/0x1d0 net/socket.c:2646
 __sys_sendmsg+0x16d/0x220 net/socket.c:2678
 do_syscall_32_irqs_on arch/x86/entry/syscall_32.c:83 [inline]
 __do_fast_syscall_32+0xe8/0x680 arch/x86/entry/syscall_32.c:307
 do_fast_syscall_32+0x32/0x80 arch/x86/entry/syscall_32.c:332
 entry_SYSENTER_compat_after_hwframe+0x84/0x8e
RIP: 0023:0xf702d579
Code: b8 01 10 06 03 74 b4 01 10 07 03 74 b0 01 10 08 03 74 d8 01 00 00 00 00 00 00 00 00 00 00 00 00 00 51 52 55 89 e5 0f 34 cd 80 <5d> 5a 59 c3 90 90 90 90 8d b4 26 00 00 00 00 8d b4 26 00 00 00 00
RSP: 002b:00000000f4f9f55c EFLAGS: 00000296 ORIG_RAX: 0000000000000172
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 0000000080000240
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000296 R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
 </TASK>
----------------
Code disassembly (best guess), 2 bytes skipped:
   0:	10 06                	adc    %al,(%rsi)
   2:	03 74 b4 01          	add    0x1(%rsp,%rsi,4),%esi
   6:	10 07                	adc    %al,(%rdi)
   8:	03 74 b0 01          	add    0x1(%rax,%rsi,4),%esi
   c:	10 08                	adc    %cl,(%rax)
   e:	03 74 d8 01          	add    0x1(%rax,%rbx,8),%esi
  1e:	00 51 52             	add    %dl,0x52(%rcx)
  21:	55                   	push   %rbp
  22:	89 e5                	mov    %esp,%ebp
  24:	0f 34                	sysenter
  26:	cd 80                	int    $0x80
* 28:	5d                   	pop    %rbp <-- trapping instruction
  29:	5a                   	pop    %rdx
  2a:	59                   	pop    %rcx
  2b:	c3                   	ret
  2c:	90                   	nop
  2d:	90                   	nop
  2e:	90                   	nop
  2f:	90                   	nop
  30:	8d b4 26 00 00 00 00 	lea    0x0(%rsi,%riz,1),%esi
  37:	8d b4 26 00 00 00 00 	lea    0x0(%rsi,%riz,1),%esi


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
