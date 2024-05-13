Received: from mail-io1-f79.google.com (mail-io1-f79.google.com [209.85.166.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1E814206B
	for <netfilter-devel@vger.kernel.org>; Mon, 13 May 2024 08:57:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.79
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715590655; cv=none; b=jypE9SvccjK412/cjS+33b9O/J5Va7g/9fueLxY9tsmZ7ljIVMNNWrM3O6efkznsgsmWddocxw7My138ag2y4nqLCTxw0Gde2+w+QLmIvy+WzeyGG/Khgx/GTxJj4thXjZrrpJg2gkStxWZx79yk5FR0mogPzw4bKNCjD0Ur5bA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715590655; c=relaxed/simple;
	bh=iDWYG7RtnNq3AoNOfRrjd0trTuhrPftP85t/iv2tG/A=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=baJXkQKUOIWTQd4xHyNO6pZLtEYVvqqz3nYgHBZHWetzDCpFfOinOQ8kl33C3B8bZZi2sbnPIBuIqxy/O5Wu4vd42Aoqy7ShE5ozxCn/aVsdHKvJA2K5JYc/womf5M7Xg4uWzCxzMm9BhcRZuvr4FrGbDs7KO3jWKlAkwvoUqzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f79.google.com with SMTP id ca18e2360f4ac-7e1ea8608afso34921939f.2
        for <netfilter-devel@vger.kernel.org>; Mon, 13 May 2024 01:57:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715590653; x=1716195453;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=MlsfaHQ06ghUuAit1ZjCEamDh0mY5oTBMtmvFXamK/s=;
        b=sots7X45vFEUSxBiqrDqk3kJdWKVn+92lV7m71uNGJO0p/Z5KixGzhvBWJ4a0YmcBS
         k6ahiuiJodzbg2yqQb8F0EQVswUOdpJNA1Z6uNnf/uIEfR3+G3nv2QXEiD7Wm5J8QgJR
         WaMjG0pSF5HRbYCv+uW4DVNhGbBaRw8tUC7FJO74wCyd+rCptWKKBAwr3LathvH6+LLr
         zwVLhNAKrKZ5PULXuE/klaI8MEya8Zpn+7TwlOSTrwmaMN4PSTk+Y3zo53GUjEI1Wyp+
         3e8FtJ6m9v64S181kPRJ9l2gMDx52jhBufy7aOisjMpUuLoxXDf90G66Rh8PvNHcG+2Q
         ihqA==
X-Forwarded-Encrypted: i=1; AJvYcCU/3jvmzwql1VwJ1/zrRiS32+OrwrGjlG19+Md4F9VxNCCb5PQYYLw+GCKE1r59ju9GHAoTkBdirASsiQae+0iuKo8ktrZmPsX4Z1QCBgxP
X-Gm-Message-State: AOJu0YwVw6DJ0KHCLp0U2niJZebr4KZc1VKlqY6qnogYjn5I5ElKhLYG
	yC33ibnzWejzsQlHlo7Pu4bDjd3628WDh4i4zJgE2lxeFOzMN+GPFcMqAbvCYVf4xFRdmukUyZq
	GArLmFC7yjKmxscVnCjwtqEfJcxzWd/jx1PZ3OUPa2fu6VVffKgiI+K4=
X-Google-Smtp-Source: AGHT+IFMnzSU7DgRgXCbJVmw4Qx/eTeW0adkciJALKBtwAs9DQLAQ78RgRFPjEWpJd/1VpHqK+d6HPO+Iz0rQg+THfz8l/PPgnSf
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6602:1352:b0:7de:de58:3b1f with SMTP id
 ca18e2360f4ac-7e1b5229103mr46266339f.4.1715590653126; Mon, 13 May 2024
 01:57:33 -0700 (PDT)
Date: Mon, 13 May 2024 01:57:33 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000075b694061852136a@google.com>
Subject: [syzbot] [netfilter?] general protection fault in nf_tproxy_laddr4
From: syzbot <syzbot+b94a6818504ea90d7661@syzkaller.appspotmail.com>
To: coreteam@netfilter.org, davem@davemloft.net, dsahern@kernel.org, 
	edumazet@google.com, kadlec@netfilter.org, kuba@kernel.org, 
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org, 
	netfilter-devel@vger.kernel.org, pabeni@redhat.com, pablo@netfilter.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    6e7ffa180a53 net: dsa: mv88e6xxx: read cmode on mv88e6320/..
git tree:       net
console+strace: https://syzkaller.appspot.com/x/log.txt?x=13ad5e04980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=3714fc09f933e505
dashboard link: https://syzkaller.appspot.com/bug?extid=b94a6818504ea90d7661
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16786a6c980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12526504980000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/344d515e5a83/disk-6e7ffa18.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/c177dc9a5410/vmlinux-6e7ffa18.xz
kernel image: https://storage.googleapis.com/syzbot-assets/cd11b4574661/bzImage-6e7ffa18.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+b94a6818504ea90d7661@syzkaller.appspotmail.com

netlink: 'syz-executor314': attribute type 4 has an invalid length.
general protection fault, probably for non-canonical address 0xdffffc0000000003: 0000 [#1] PREEMPT SMP KASAN PTI
KASAN: null-ptr-deref in range [0x0000000000000018-0x000000000000001f]
CPU: 1 PID: 5086 Comm: syz-executor314 Not tainted 6.9.0-rc6-syzkaller-00157-g6e7ffa180a53 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 04/02/2024
RIP: 0010:nf_tproxy_laddr4+0xb7/0x340 net/ipv4/netfilter/nf_tproxy_ipv4.c:62
Code: 89 c5 31 ff 89 c6 e8 08 80 8d f7 85 ed 0f 84 ab 01 00 00 e8 bb 7b 8d f7 eb 05 e8 b4 7b 8d f7 48 83 c3 18 48 89 d8 48 c1 e8 03 <42> 80 3c 38 00 74 08 48 89 df e8 3a 26 f2 f7 48 8b 1b e8 72 df 77
RSP: 0018:ffffc9000344eb38 EFLAGS: 00010206
RAX: 0000000000000003 RBX: 0000000000000018 RCX: ffff88802a7ada00
RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000000
RBP: 0000000000000001 R08: ffffffff8a0894f8 R09: 0000000000000001
R10: 0000000000000002 R11: ffff88802a7ada00 R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000000000 R15: dffffc0000000000
FS:  000055556cd0a380(0000) GS:ffff8880b9500000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 00000000221a6000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 nft_tproxy_eval_v4 net/netfilter/nft_tproxy.c:56 [inline]
 nft_tproxy_eval+0xa9a/0x1a00 net/netfilter/nft_tproxy.c:168
 expr_call_ops_eval net/netfilter/nf_tables_core.c:240 [inline]
 nft_do_chain+0x4ad/0x1da0 net/netfilter/nf_tables_core.c:288
 nft_do_chain_inet+0x418/0x6b0 net/netfilter/nft_chain_filter.c:161
 nf_hook_entry_hookfn include/linux/netfilter.h:154 [inline]
 nf_hook_slow+0xc3/0x220 net/netfilter/core.c:626
 nf_hook_slow_list+0x1f8/0x460 net/netfilter/core.c:665
 NF_HOOK_LIST include/linux/netfilter.h:350 [inline]
 ip_sublist_rcv+0x9a4/0xab0 net/ipv4/ip_input.c:637
 ip_list_rcv+0x42b/0x480 net/ipv4/ip_input.c:674
 __netif_receive_skb_list_ptype net/core/dev.c:5587 [inline]
 __netif_receive_skb_list_core+0x95a/0x980 net/core/dev.c:5635
 __netif_receive_skb_list net/core/dev.c:5687 [inline]
 netif_receive_skb_list_internal+0xa51/0xe30 net/core/dev.c:5779
 netif_receive_skb_list+0x55/0x4b0 net/core/dev.c:5831
 xdp_recv_frames net/bpf/test_run.c:278 [inline]
 xdp_test_run_batch net/bpf/test_run.c:356 [inline]
 bpf_test_run_xdp_live+0x1973/0x1e90 net/bpf/test_run.c:384
 bpf_prog_test_run_xdp+0x813/0x11b0 net/bpf/test_run.c:1267
 bpf_prog_test_run+0x33a/0x3b0 kernel/bpf/syscall.c:4269
 __sys_bpf+0x48d/0x810 kernel/bpf/syscall.c:5678
 __do_sys_bpf kernel/bpf/syscall.c:5767 [inline]
 __se_sys_bpf kernel/bpf/syscall.c:5765 [inline]
 __x64_sys_bpf+0x7c/0x90 kernel/bpf/syscall.c:5765
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf5/0x240 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fcafe84c2b9
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 d1 19 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fffba9dffc8 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 00007fcafe84c2b9
RDX: 0000000000000048 RSI: 0000000020000600 RDI: 000000000000000a
RBP: 0000000000000000 R08: 00007fffba9dfff0 R09: 00007fffba9dfff0
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:nf_tproxy_laddr4+0xb7/0x340 net/ipv4/netfilter/nf_tproxy_ipv4.c:62
Code: 89 c5 31 ff 89 c6 e8 08 80 8d f7 85 ed 0f 84 ab 01 00 00 e8 bb 7b 8d f7 eb 05 e8 b4 7b 8d f7 48 83 c3 18 48 89 d8 48 c1 e8 03 <42> 80 3c 38 00 74 08 48 89 df e8 3a 26 f2 f7 48 8b 1b e8 72 df 77
RSP: 0018:ffffc9000344eb38 EFLAGS: 00010206
RAX: 0000000000000003 RBX: 0000000000000018 RCX: ffff88802a7ada00
RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000000
RBP: 0000000000000001 R08: ffffffff8a0894f8 R09: 0000000000000001
R10: 0000000000000002 R11: ffff88802a7ada00 R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000000000 R15: dffffc0000000000
FS:  000055556cd0a380(0000) GS:ffff8880b9500000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 00000000221a6000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
----------------
Code disassembly (best guess):
   0:	89 c5                	mov    %eax,%ebp
   2:	31 ff                	xor    %edi,%edi
   4:	89 c6                	mov    %eax,%esi
   6:	e8 08 80 8d f7       	call   0xf78d8013
   b:	85 ed                	test   %ebp,%ebp
   d:	0f 84 ab 01 00 00    	je     0x1be
  13:	e8 bb 7b 8d f7       	call   0xf78d7bd3
  18:	eb 05                	jmp    0x1f
  1a:	e8 b4 7b 8d f7       	call   0xf78d7bd3
  1f:	48 83 c3 18          	add    $0x18,%rbx
  23:	48 89 d8             	mov    %rbx,%rax
  26:	48 c1 e8 03          	shr    $0x3,%rax
* 2a:	42 80 3c 38 00       	cmpb   $0x0,(%rax,%r15,1) <-- trapping instruction
  2f:	74 08                	je     0x39
  31:	48 89 df             	mov    %rbx,%rdi
  34:	e8 3a 26 f2 f7       	call   0xf7f22673
  39:	48 8b 1b             	mov    (%rbx),%rbx
  3c:	e8                   	.byte 0xe8
  3d:	72 df                	jb     0x1e
  3f:	77                   	.byte 0x77


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
