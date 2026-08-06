Received: from mail-ot1-f69.google.com (mail-ot1-f69.google.com [209.85.210.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CEBD3839BD
	for <netfilter-devel@vger.kernel.org>; Thu,  6 Aug 2026 15:22:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786029744; cv=none; b=TIDSfmhMKpoGO6ExwjoYHRbjRkixYmzEdiEzXlqb/vkIVS3tH7IL1vOCGmgyDXSQyaaCddexf7VdWLZZEDBaSke2Z0Ba1JULCK0ZGK3LmwsJwj5zyrx53JXXAVviqqUPx/ryWLk5xmEuF1wDiqNuFKLu+tyCLgk73nf+gI4UNvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786029744; c=relaxed/simple;
	bh=eWbnv5ABWuayK/YHWWcDzqPqAaJOWj0z6kJO7+FoDMo=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=nf4nGrRqGdXStzTkmUQnTbYCOpB8/fBBnI48leluURwSUtwjEYwl5ZIEjajZpiYXBtjUt847Q1aL4ulvGO4+u40Mrwdm+1673ZpkYah2KSHEJo/Fe9bFlrUG98kHH33mdLOslyQ4BSkUF3Wd5rA3XjnkqHVbieEyK4YSRgGxzkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.210.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f69.google.com with SMTP id 46e09a7af769-7ead32f5c6aso1489538a34.1
        for <netfilter-devel@vger.kernel.org>; Thu, 06 Aug 2026 08:22:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786029741; x=1786634541;
        h=content-type:cc:to:from:subject:message-id:in-reply-to:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=jDhjWkpsCWwFZao1yLKH2NBcnmwUC3YEdPeE5OS9rlo=;
        b=B7RLBaHqsGTrBPKIB+4H4buh4Wsm7waenR0ydxCo1oUAVdgbg6GuN2y2DJbGsG2gMP
         oQrNjo7LvcnnTwH41kxv4PSbqP5Ecbju4dT7l7yCXiytuf2B81dkDYWRcjU+JP+oFNeJ
         Dh9KMlijuDWkIff105uGMcYmT/7e9oY7FMNQ5yKa9LBMaYjgdoVW/scuqDb4UKdPmXYQ
         PToRfPjo+nA+CscpKeIyyxpSTfnpf5Y53B69xsUWyP2d9rAuh+5TU1b9vQQY/O5qQJ98
         lIrb4x7lTgXYZFcg5jWLiyoeLc8UYpMKq6BZt1/gjuOgY5il5vj2Nx5lQigoYsFsW78z
         oLxA==
X-Forwarded-Encrypted: i=1; AHgh+RoAEKdi4FUChXRpY8d2KXb/w88yukzOYgGOmcu0FdNj2rf67aIi5a5Sq7gjivxnSI26lSTZM8qbmUvdQcKww7A=@vger.kernel.org
X-Gm-Message-State: AOJu0YweUkTc3PCctFipy/9+dbjsR7osL3aIeF6/oS535AWcygHQp4ex
	Qf1yeBGTEhYs9bFVq9O57qF3PCezb4zMWmsqbiYitWLTuFtLJlVyXVMa6a/oobpSv2HX4MZeit9
	tftIeSa0pM41BZ2MtnZILE6dX/fmOXQozOSi5MHj4KFBDfmyDeBQ0G/h9pjY=
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:4414:b0:6b0:1ba4:dcd0 with SMTP id
 006d021491bc7-6b01ba50a1dmr1727457eaf.27.1786029741471; Thu, 06 Aug 2026
 08:22:21 -0700 (PDT)
Date: Thu, 06 Aug 2026 08:22:21 -0700
In-Reply-To: <20260806101947.2802-1-fw@strlen.de>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a74a6ad.ec7c9571.3ac9bb.0053.GAE@google.com>
Subject: [syzbot ci] Re: netfilter: switch ipset to rhashtable
From: syzbot ci <syzbot+ci11ed5d32bbe502f8@syzkaller.appspotmail.com>
To: fw@strlen.de, kadlec@netfilter.org, netfilter-devel@vger.kernel.org
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v1] netfilter: switch ipset to rhashtable
https://lore.kernel.org/all/20260806101947.2802-1-fw@strlen.de
* [PATCH nf 1/7] netfilter: ipset: remove need to allocate memory on delete operations
* [PATCH nf 2/7] netfilter: ipset: let destroy callbacks adjust ext mem size
* [PATCH nf 3/7] netfilter: ipset: add rhashtable boilerplate stubs
* [PATCH nf 4/7] netfilter: ipset: add rhltable boilerplate stubs
* [PATCH nf 5/7] netfilter: ipset: replace internal hash table with rhashtable
* [PATCH nf 6/7] netfilter: ipset: re-add forceadd support for rhashtable
* [PATCH nf 7/7] netfilter: ipset: also report mem size for cidr storage to userspace

and found the following issues:
* UBSAN: shift-out-of-bounds in hash_netiface6_head
* UBSAN: shift-out-of-bounds in hash_netportnet6_head

Full report is available here:
https://ci.syzbot.org/series/e7969a90-d2b3-4da4-8795-4c3794dae0f0

***

UBSAN: shift-out-of-bounds in hash_netiface6_head

tree:      nf
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netfilter/nf.git
base:      44871eadd07a7f004aa00cb87399461eea08c630
arch:      amd64
compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/81d26051-7806-406c-9355-fbf52dca8f68/config
syz repro: https://ci.syzbot.org/findings/cb9f585e-5753-41c6-b732-20d1d77f5564/syz_repro

------------[ cut here ]------------
UBSAN: shift-out-of-bounds in net/netfilter/ipset/ip_set_hash_gen.h:1120:46
shift exponent 32 is too large for 32-bit type 'u32' (aka 'unsigned int')
CPU: 1 UID: 0 PID: 5865 Comm: syz.2.19 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 ubsan_epilogue+0xa/0x30 lib/ubsan.c:233
 __ubsan_handle_shift_out_of_bounds+0x36d/0x400 lib/ubsan.c:494
 hash_netiface6_head+0x89e/0x970 net/netfilter/ipset/ip_set_hash_gen.h:1120
 ip_set_dump_do+0x1476/0x1920 net/netfilter/ipset/ip_set_core.c:1664
 netlink_dump+0x711/0xee0 net/netlink/af_netlink.c:2331
 __netlink_dump_start+0x589/0x7b0 net/netlink/af_netlink.c:2446
 netlink_dump_start include/linux/netlink.h:341 [inline]
 ip_set_dump+0x15b/0x1f0 net/netfilter/ipset/ip_set_core.c:1730
 nfnetlink_rcv_msg+0xcc2/0x12b0 net/netfilter/nfnetlink.c:300
 netlink_rcv_skb+0x226/0x4a0 net/netlink/af_netlink.c:2556
 nfnetlink_rcv+0x2b9/0x28c0 net/netfilter/nfnetlink.c:667
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
RIP: 0033:0x7f7b3159e019
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f7b323e2028 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007f7b31825fa0 RCX: 00007f7b3159e019
RDX: 0000000000008080 RSI: 0000200000000180 RDI: 0000000000000004
RBP: 00007f7b3163500c R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f7b31826038 R14: 00007f7b31825fa0 R15: 00007ffdc35054d8
 </TASK>
---[ end trace ]---


***

UBSAN: shift-out-of-bounds in hash_netportnet6_head

tree:      nf
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netfilter/nf.git
base:      44871eadd07a7f004aa00cb87399461eea08c630
arch:      amd64
compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/81d26051-7806-406c-9355-fbf52dca8f68/config
syz repro: https://ci.syzbot.org/findings/0f098de1-ac6a-4b30-8a0d-ea1586a67851/syz_repro

------------[ cut here ]------------
UBSAN: shift-out-of-bounds in net/netfilter/ipset/ip_set_hash_gen.h:1120:46
shift exponent 32 is too large for 32-bit type 'u32' (aka 'unsigned int')
CPU: 1 UID: 0 PID: 5838 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 ubsan_epilogue+0xa/0x30 lib/ubsan.c:233
 __ubsan_handle_shift_out_of_bounds+0x36d/0x400 lib/ubsan.c:494
 hash_netportnet6_head+0x97a/0xa40 net/netfilter/ipset/ip_set_hash_gen.h:1120
 ip_set_dump_do+0x1476/0x1920 net/netfilter/ipset/ip_set_core.c:1664
 netlink_dump+0x711/0xee0 net/netlink/af_netlink.c:2331
 __netlink_dump_start+0x589/0x7b0 net/netlink/af_netlink.c:2446
 netlink_dump_start include/linux/netlink.h:341 [inline]
 ip_set_dump+0x15b/0x1f0 net/netfilter/ipset/ip_set_core.c:1730
 nfnetlink_rcv_msg+0xcc2/0x12b0 net/netfilter/nfnetlink.c:300
 netlink_rcv_skb+0x226/0x4a0 net/netlink/af_netlink.c:2556
 nfnetlink_rcv+0x2b9/0x28c0 net/netfilter/nfnetlink.c:667
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
RIP: 0033:0x7f44dc59e019
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f44dd41d028 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007f44dc825fa0 RCX: 00007f44dc59e019
RDX: 0000000000000000 RSI: 0000200000000200 RDI: 0000000000000004
RBP: 00007f44dc63500c R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f44dc826038 R14: 00007f44dc825fa0 R15: 00007ffdbc9c05c8
 </TASK>
---[ end trace ]---


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
