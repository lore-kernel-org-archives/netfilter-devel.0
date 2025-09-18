Received: from mail-il1-f207.google.com (mail-il1-f207.google.com [209.85.166.207])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7888D30CB43
	for <netfilter-devel@vger.kernel.org>; Thu, 18 Sep 2025 15:34:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758209674; cv=none; b=Oqz3BPe/4+rDNOEtiylXvhQBTShMfBTJ4N86wOURBn4tOcLPp+0GR2eYoWLxU97incDivnidZeTiRAT/nSPq/AI2jn/GHhT35E6kQ8gLb77wYF3qMlUB82PJNW1Gtoav3RVE3FEqOaJRQmsO5Hn5tMuMXthiM2s5mNuxnPsX5yQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758209674; c=relaxed/simple;
	bh=ExErPFUcQ4a8T+RxsqEky4yXipaiLcZSok6s4LPISVE=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=LtUe9bmiMqtDeaX8UL2VlMRqOHfNRc+GGDpP489ubyGlFah1I6iaLH51KZwWmhSaPuz6l3y/h2J3u1gcyL1rU0G4Mkb8ymxtZxcr+UMUot5z5sYQXZbfPwK2E9tPTmvVXmVjlCRg7MriOyU4g0MKPZ+lNM7eeur0fgychi8GPp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f207.google.com with SMTP id e9e14a558f8ab-4247f4fda63so5012605ab.2
        for <netfilter-devel@vger.kernel.org>; Thu, 18 Sep 2025 08:34:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758209672; x=1758814472;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0sduD65NO8lJm33fZ2TP23ShQk8DTdU3PV6L6EWySPQ=;
        b=eyZRFyh2KeZ9exCU5c1ybFRWke9qRVvIVofDVwxVykKNl/sWlovZwVYI9V022/iW0f
         vWy6peL/1CYhRSuSD7+Sp8aO+rsT2kS/KWI277YWclw3fbZZpYXWv3pfo4aBHpv9Iyy2
         1yem4FSZrj6/TW1LKtbKk/BjoN/InjIbM9wNCWs4F/ZholEW+zm9eND9yI8d7cZNBCgb
         EcoEQyN3kyq7PopwcUJ+srV3RmiS73Y4LLpgnwEZH0lNLoqIqOULXyZuQ8Oc8SWYQqiT
         9PE6PYDLOtNpe0VBn9Y0xcjwCAT93EoPB0cIBubZ3o6I0Qt25mNEthizXVcDnnXxrsnR
         tOdA==
X-Forwarded-Encrypted: i=1; AJvYcCXSP9Gbz/zqU17aznHBx4I7Xe5X+hCVJPYP7cMebDkKaE2JsrGTqFzDjMwtiMQ2u37jyuuhlqTxiyLIztUVG/A=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzz3PvleqsxGJ8ZNVChR9NfRP3UPfahzCOqrwGKzYnt7peGM0wA
	Eab7zReNgEuCNoeQxcI72W+7jPhD3t4tJE8LMxM0bbsEv6d0Zuv3CCfJn0yTPlfz6keUBCkIH3C
	YjxyTkgL4ZJJs+B9om3QqfBvfvHojoSWSKWikWa64vN+VtD55/kpS+WQsfXU=
X-Google-Smtp-Source: AGHT+IGzmonCIrGacu/t403kscfOxmaNaHB2fXBBLB7Otoq57cCCrMcGqXwCUewG4xqYr0tv5+DoZVvHaXYaOYrGW1GTz9zgoEW5
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:380b:b0:424:8061:dec0 with SMTP id
 e9e14a558f8ab-42481922c60mr64725ab.7.1758209671557; Thu, 18 Sep 2025 08:34:31
 -0700 (PDT)
Date: Thu, 18 Sep 2025 08:34:31 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68cc2687.050a0220.139b6.0004.GAE@google.com>
Subject: [syzbot] [netfilter?] general protection fault in nft_fib6_eval (2)
From: syzbot <syzbot+109521837481c8e96ea5@syzkaller.appspotmail.com>
To: coreteam@netfilter.org, davem@davemloft.net, edumazet@google.com, 
	fw@strlen.de, horms@kernel.org, kadlec@netfilter.org, kuba@kernel.org, 
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org, 
	netfilter-devel@vger.kernel.org, pabeni@redhat.com, pablo@netfilter.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    01792bc3e5bd net: ti: icssg-prueth: Fix HSR and switch off..
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=108ec3bc580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c321f33e4545e2a1
dashboard link: https://syzkaller.appspot.com/bug?extid=109521837481c8e96ea5
compiler:       Debian clang version 20.1.7 (++20250616065708+6146a88f6049-1~exp1~20250616065826.132), Debian LLD 20.1.7

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/deae9487bd6c/disk-01792bc3.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/1bb0140fd491/vmlinux-01792bc3.xz
kernel image: https://storage.googleapis.com/syzbot-assets/bd9ec803c379/bzImage-01792bc3.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+109521837481c8e96ea5@syzkaller.appspotmail.com

Oops: general protection fault, probably for non-canonical address 0xdffffc0000000000: 0000 [#1] SMP KASAN PTI
KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
CPU: 0 UID: 0 PID: 8151 Comm: syz.2.634 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/12/2025
RIP: 0010:nft_fib6_eval+0x7cd/0xc20 net/ipv6/netfilter/nft_fib_ipv6.c:-1
Code: 4c 89 f3 48 81 c3 d8 00 00 00 48 89 d8 48 c1 e8 03 42 80 3c 20 00 74 08 48 89 df e8 8d df dd f7 48 8b 1b 48 89 d8 48 c1 e8 03 <42> 80 3c 20 00 74 08 48 89 df e8 74 df dd f7 48 8b 3b 48 8b 5c 24
RSP: 0018:ffffc9001c59f000 EFLAGS: 00010246
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000002
RDX: ffff88802fcabc00 RSI: 0000000000000000 RDI: 0000000000000000
RBP: ffffc9001c59f1d0 R08: ffffffff8fa37e37 R09: 1ffffffff1f46fc6
R10: dffffc0000000000 R11: fffffbfff1f46fc7 R12: dffffc0000000000
R13: ffffc9001c59f0f0 R14: ffff88807f6db500 R15: ffff88807f6db560
FS:  00007faeb51596c0(0000) GS:ffff888125c1b000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f7baea82f98 CR3: 000000007e12a000 CR4: 00000000003526f0
Call Trace:
 <TASK>
 expr_call_ops_eval net/netfilter/nf_tables_core.c:237 [inline]
 nft_do_chain+0x409/0x1920 net/netfilter/nf_tables_core.c:285
 nft_do_chain_inet+0x25d/0x340 net/netfilter/nft_chain_filter.c:161
 nf_hook_entry_hookfn include/linux/netfilter.h:158 [inline]
 nf_hook_slow+0xc2/0x220 net/netfilter/core.c:623
 nf_hook include/linux/netfilter.h:273 [inline]
 NF_HOOK+0x206/0x3a0 include/linux/netfilter.h:316
 __netif_receive_skb_one_core net/core/dev.c:5991 [inline]
 __netif_receive_skb+0xd3/0x380 net/core/dev.c:6104
 netif_receive_skb_internal net/core/dev.c:6190 [inline]
 netif_receive_skb+0x1cb/0x790 net/core/dev.c:6249
 tun_rx_batched+0x1b9/0x730 drivers/net/tun.c:1485
 tun_get_user+0x2aa2/0x3e20 drivers/net/tun.c:1950
 tun_chr_write_iter+0x113/0x200 drivers/net/tun.c:1996
 new_sync_write fs/read_write.c:593 [inline]
 vfs_write+0x5c9/0xb30 fs/read_write.c:686
 ksys_write+0x145/0x250 fs/read_write.c:738
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7faeb438d69f
Code: 89 54 24 18 48 89 74 24 10 89 7c 24 08 e8 f9 92 02 00 48 8b 54 24 18 48 8b 74 24 10 41 89 c0 8b 7c 24 08 b8 01 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 31 44 89 c7 48 89 44 24 08 e8 4c 93 02 00 48
RSP: 002b:00007faeb5159000 EFLAGS: 00000293 ORIG_RAX: 0000000000000001
RAX: ffffffffffffffda RBX: 00007faeb45b5fa0 RCX: 00007faeb438d69f
RDX: 0000000000000046 RSI: 0000200000000b00 RDI: 00000000000000c8
RBP: 00007faeb4411e19 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000046 R11: 0000000000000293 R12: 0000000000000000
R13: 00007faeb45b6038 R14: 00007faeb45b5fa0 R15: 00007ffcdc4d36a8
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:nft_fib6_eval+0x7cd/0xc20 net/ipv6/netfilter/nft_fib_ipv6.c:-1
Code: 4c 89 f3 48 81 c3 d8 00 00 00 48 89 d8 48 c1 e8 03 42 80 3c 20 00 74 08 48 89 df e8 8d df dd f7 48 8b 1b 48 89 d8 48 c1 e8 03 <42> 80 3c 20 00 74 08 48 89 df e8 74 df dd f7 48 8b 3b 48 8b 5c 24
RSP: 0018:ffffc9001c59f000 EFLAGS: 00010246
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000002
RDX: ffff88802fcabc00 RSI: 0000000000000000 RDI: 0000000000000000
RBP: ffffc9001c59f1d0 R08: ffffffff8fa37e37 R09: 1ffffffff1f46fc6
R10: dffffc0000000000 R11: fffffbfff1f46fc7 R12: dffffc0000000000
R13: ffffc9001c59f0f0 R14: ffff88807f6db500 R15: ffff88807f6db560
FS:  00007faeb51596c0(0000) GS:ffff888125c1b000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f7baea82f98 CR3: 000000007e12a000 CR4: 00000000003526f0
----------------
Code disassembly (best guess):
   0:	4c 89 f3             	mov    %r14,%rbx
   3:	48 81 c3 d8 00 00 00 	add    $0xd8,%rbx
   a:	48 89 d8             	mov    %rbx,%rax
   d:	48 c1 e8 03          	shr    $0x3,%rax
  11:	42 80 3c 20 00       	cmpb   $0x0,(%rax,%r12,1)
  16:	74 08                	je     0x20
  18:	48 89 df             	mov    %rbx,%rdi
  1b:	e8 8d df dd f7       	call   0xf7dddfad
  20:	48 8b 1b             	mov    (%rbx),%rbx
  23:	48 89 d8             	mov    %rbx,%rax
  26:	48 c1 e8 03          	shr    $0x3,%rax
* 2a:	42 80 3c 20 00       	cmpb   $0x0,(%rax,%r12,1) <-- trapping instruction
  2f:	74 08                	je     0x39
  31:	48 89 df             	mov    %rbx,%rdi
  34:	e8 74 df dd f7       	call   0xf7dddfad
  39:	48 8b 3b             	mov    (%rbx),%rdi
  3c:	48                   	rex.W
  3d:	8b                   	.byte 0x8b
  3e:	5c                   	pop    %rsp
  3f:	24                   	.byte 0x24


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
