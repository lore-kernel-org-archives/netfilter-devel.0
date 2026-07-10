Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com [209.85.167.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A79ED26ACC
	for <netfilter-devel@vger.kernel.org>; Fri, 10 Jul 2026 07:46:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783669608; cv=none; b=b/M/WBfNzdGgnGnReXZiMY4BM+xEzfVRZCt6vsSd/2WvhoOYuEQdyIbev4HHxuLzWVU7+gfAPAEa90YMeXDCKyzlGL7QwxkYPO7KkH4lX0E0vpneufjbHb6CyhH/kGu5PcK6GF0MJhmuA4iGgsXWjnd3QagYwWDR1lxMYKMGZ/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783669608; c=relaxed/simple;
	bh=BKBWWDRretnrU37CTI91R/3bBxlHmJWWI2HROJKe/cU=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=fBbgHA2/dqqqa4NgBQW130DCDWk+7LiqcfbP2RpEeWDfAj4L7Sr176gCyXX9etgTUjFJYhJsgYdr5FU7syJolDAbhULlTalJOWnRaFyY+Qtje0Z1OlQjwpwb6XXNhkzCnDb/G2IYyegbhzpFm1qR1c3+S27CFsmusSzSU6ojKfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f200.google.com with SMTP id 5614622812f47-49ce04870f8so1055207b6e.0
        for <netfilter-devel@vger.kernel.org>; Fri, 10 Jul 2026 00:46:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783669606; x=1784274406;
        h=content-type:cc:to:from:subject:message-id:in-reply-to:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=/RIrXkPXqk6Tm9n+eZtVOBYreXVHsQ7d94TjonpZcjE=;
        b=KCRRgTz4j7dkQ9bFjuddnBqQe8j1wBKQXsmK45X8R23rf/7TxjbWzOFaZyyoNj6Mb6
         aMbfoHAhl9A55n3XSWwnevvT62sLZl3Uo+Q1/1DMi8W6b61fmDJOjh8skkNoy3KTa9ox
         f05UBh7pnm5yzP5YW3RsH+oMYMI1bgpov9wIvczGhdjDlCGZ6N9/geVxSWlqdvVYBiKv
         x+RC9VKejsBdOOsMayWj0Vl3pplXLchBx+3BYZGe9gFwgfohVXpYTw2il6Uf0jBno3g1
         gK3OgKPC60ImJKO3qZnP91hbiuq+J2dGhEg4eI6IwyISjNIXW7MdZQlCpLRGspYehgwa
         PH6A==
X-Forwarded-Encrypted: i=1; AFNElJ+Kq5sGB7epCCt2GfgUsjWnEnkGDKtpeC0OP4vae+LnpYUF96JJOrAeiDjjgdwnHBQhTfLbMi3Ks5j0ivxcMRA=@vger.kernel.org
X-Gm-Message-State: AOJu0YyM8xgaXvqBAebXRMfkQmdzxlzeiOFa9vOQd0jpYUKwOE5siCNh
	GVjS3g5+AaA1/Upw2oewAGiRKjH9XfJ04cp5mf99C324QHM4keYQO6aMT3GeZs8Pc8b7VoMacjz
	JAnTz5UC5CUkeS9uYg/J7aMHMYWPgdoBoBQRQhYYKHYs5XYh7j+P3U6Uuyg0=
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:4706:b0:490:315d:e0d5 with SMTP id
 5614622812f47-4a2020091cbmr8558875b6e.16.1783669605777; Fri, 10 Jul 2026
 00:46:45 -0700 (PDT)
Date: Fri, 10 Jul 2026 00:46:45 -0700
In-Reply-To: <20260708205404.911832-1-anzaki@gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a50a365.c76b52dc.2a15e.000a.GAE@google.com>
Subject: [syzbot ci] Re: netfilter: flowtable: tear down HW offloaded flows on
 FIB route changes
From: syzbot ci <syzbot+ci43317981636ba259@syzkaller.appspotmail.com>
To: anzaki@gmail.com, davem@davemloft.net, edumazet@google.com, fw@strlen.de, 
	horms@kernel.org, kuba@kernel.org, netdev@vger.kernel.org, 
	netfilter-devel@vger.kernel.org, pabeni@redhat.com, pablo@netfilter.org
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v1] netfilter: flowtable: tear down HW offloaded flows on FIB route changes
https://lore.kernel.org/all/20260708205404.911832-1-anzaki@gmail.com
* [PATCH nf] netfilter: flowtable: tear down HW offloaded flows on FIB route changes

and found the following issue:
general protection fault in net_generic

Full report is available here:
https://ci.syzbot.org/series/75cd5a68-8e8e-41ef-9da6-dea3554407a7

***

general protection fault in net_generic

tree:      nf
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netfilter/nf.git
base:      60444706aa17616efc03190d099ac347e28b3d0a
arch:      amd64
compiler:  Debian clang version 22.1.6 (++20260514074242+fc4aad7b5db3-1~exp1~20260514074407.73), Debian LLD 22.1.6
config:    https://ci.syzbot.org/builds/b941607c-6459-4d25-8127-6c11f2a37ef0/config
syz repro: https://ci.syzbot.org/findings/93de0afd-01d4-4d54-9d3f-13094335f314/syz_repro

Oops: general protection fault, probably for non-canonical address 0xdffffc00000002c8: 0000 [#1] SMP KASAN PTI
KASAN: probably user-memory-access in range [0x0000000000001640-0x0000000000001647]
CPU: 1 UID: 0 PID: 5813 Comm: syz.2.19 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:net_generic+0xd4/0x240 include/net/netns/generic.h:46
Code: 8c be 4a 03 00 00 48 c7 c2 c0 83 e0 8c e8 14 1b 09 f8 49 bf 00 00 00 00 00 fc ff df 49 81 c6 40 16 00 00 4c 89 f0 48 c1 e8 03 <42> 80 3c 38 00 74 08 4c 89 f7 e8 0d a4 9a f8 4d 8b 26 e8 45 e8 1b
RSP: 0018:ffffc90003bde998 EFLAGS: 00010202
RAX: 00000000000002c8 RBX: ffffffff8999417e RCX: ffff8881699c5940
RDX: 0000000000000000 RSI: ffffffff8c2ab760 RDI: ffffffff8c2ab720
RBP: 0000000000000005 R08: ffffffff8999417e R09: 0000000000000000
R10: 0000000000000000 R11: ffffffff8e959c20 R12: ffff8881b1679870
R13: dffffc0000000000 R14: 0000000000001640 R15: dffffc0000000000
FS:  00007ff6de31c6c0(0000) GS:ffff8882a921d000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ff6dd272780 CR3: 000000016bc8e000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 fib_seq_sum+0x29/0x280 net/core/fib_notifier.c:43
 register_fib_notifier+0x49/0x360 net/core/fib_notifier.c:106
 nf_flow_table_init+0x34a/0x460 net/netfilter/nf_flow_table_core.c:888
 tcf_ct_flow_table_get+0x13b6/0x1f40 net/sched/act_ct.c:352
 tcf_ct_init+0x6bd/0xb10 net/sched/act_ct.c:1423
 tcf_action_init_1+0x4ba/0x740 net/sched/act_api.c:1433
 tcf_action_init+0x30e/0xb10 net/sched/act_api.c:1508
 tcf_action_add net/sched/act_api.c:2106 [inline]
 tc_ctl_action+0x43b/0xc70 net/sched/act_api.c:2163
 rtnetlink_rcv_msg+0x7b9/0xc00 net/core/rtnetlink.c:7085
 netlink_rcv_skb+0x226/0x4a0 net/netlink/af_netlink.c:2556
 netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
 netlink_unicast+0x7bb/0x940 net/netlink/af_netlink.c:1345
 netlink_sendmsg+0x813/0xb40 net/netlink/af_netlink.c:1900
 sock_sendmsg_nosec+0x13a/0x180 net/socket.c:775
 __sock_sendmsg net/socket.c:790 [inline]
 ____sys_sendmsg+0x54e/0x850 net/socket.c:2684
 ___sys_sendmsg+0x2a5/0x360 net/socket.c:2738
 __sys_sendmsg net/socket.c:2770 [inline]
 __do_sys_sendmsg net/socket.c:2775 [inline]
 __se_sys_sendmsg net/socket.c:2773 [inline]
 __x64_sys_sendmsg+0x1b1/0x290 net/socket.c:2773
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7ff6dd39ce59
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ff6de31c028 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007ff6dd615fa0 RCX: 00007ff6dd39ce59
RDX: 0000000000000040 RSI: 0000200000000080 RDI: 0000000000000003
RBP: 00007ff6dd432e6f R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007ff6dd616038 R14: 00007ff6dd615fa0 R15: 00007ffd83f8d058
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:net_generic+0xd4/0x240 include/net/netns/generic.h:46
Code: 8c be 4a 03 00 00 48 c7 c2 c0 83 e0 8c e8 14 1b 09 f8 49 bf 00 00 00 00 00 fc ff df 49 81 c6 40 16 00 00 4c 89 f0 48 c1 e8 03 <42> 80 3c 38 00 74 08 4c 89 f7 e8 0d a4 9a f8 4d 8b 26 e8 45 e8 1b
RSP: 0018:ffffc90003bde998 EFLAGS: 00010202
RAX: 00000000000002c8 RBX: ffffffff8999417e RCX: ffff8881699c5940
RDX: 0000000000000000 RSI: ffffffff8c2ab760 RDI: ffffffff8c2ab720
RBP: 0000000000000005 R08: ffffffff8999417e R09: 0000000000000000
R10: 0000000000000000 R11: ffffffff8e959c20 R12: ffff8881b1679870
R13: dffffc0000000000 R14: 0000000000001640 R15: dffffc0000000000
FS:  00007ff6de31c6c0(0000) GS:ffff8882a921d000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ff6dd3ea540 CR3: 000000016bc8e000 CR4: 00000000000006f0
----------------
Code disassembly (best guess):
   0:	8c be 4a 03 00 00    	mov    %?,0x34a(%rsi)
   6:	48 c7 c2 c0 83 e0 8c 	mov    $0xffffffff8ce083c0,%rdx
   d:	e8 14 1b 09 f8       	call   0xf8091b26
  12:	49 bf 00 00 00 00 00 	movabs $0xdffffc0000000000,%r15
  19:	fc ff df
  1c:	49 81 c6 40 16 00 00 	add    $0x1640,%r14
  23:	4c 89 f0             	mov    %r14,%rax
  26:	48 c1 e8 03          	shr    $0x3,%rax
* 2a:	42 80 3c 38 00       	cmpb   $0x0,(%rax,%r15,1) <-- trapping instruction
  2f:	74 08                	je     0x39
  31:	4c 89 f7             	mov    %r14,%rdi
  34:	e8 0d a4 9a f8       	call   0xf89aa446
  39:	4d 8b 26             	mov    (%r14),%r12
  3c:	e8                   	.byte 0xe8
  3d:	45                   	rex.RB
  3e:	e8                   	.byte 0xe8
  3f:	1b                   	.byte 0x1b


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
