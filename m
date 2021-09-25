Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A120C433F5
	for <netfilter-devel@archiver.kernel.org>; Sat, 25 Sep 2021 00:07:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E6BDB60FDC
	for <netfilter-devel@archiver.kernel.org>; Sat, 25 Sep 2021 00:07:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344971AbhIYAIz (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 24 Sep 2021 20:08:55 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:42990 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344954AbhIYAIz (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 24 Sep 2021 20:08:55 -0400
Received: by mail-io1-f71.google.com with SMTP id j7-20020a0566022cc700b005d65f61a95fso6154222iow.9
        for <netfilter-devel@vger.kernel.org>; Fri, 24 Sep 2021 17:07:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=sviqDGv7FA/IhhALPB5pV261SeTKYNilDnX9mugDeHQ=;
        b=sm2MHi0vL5NQp0UmXz+iPi0+p0vNdBk0RMdUa4lHG9NNd+522fsWIMVRFEaVwjSGiV
         5jlq+8pffU0cqknciru6QkGtxSOSqvncUBMOcUSzY50OZLWlfr5ED9ATNRU0twmzLfm4
         iS8qUyAEU4dIMaBFq/fhcDMICzVQr3nc5vmTMs5wQPY4uZ8LkrWQ7NeWZeKCvIZgc75Z
         7sYv9ktfdjfxYltJKM85UaawZUNrByxHip1C865+b9ddnMmKJem2OkhluK4jJb7lcwSV
         07lXCTfWh3l02z1lNGI+W8iKcL30AmYCSyZmEcCf9+k2qFSSruinoYnM9UB1t6Arm/yC
         l9TQ==
X-Gm-Message-State: AOAM531GDSfItRrxTfQI8Ktzf0NgIbayXy9VtUgaMJTOM1I/Cr3xQg6N
        +DlDGTnF73C6Fi8ADYgYZnCHorJ5TWn+g6MHcJ4VtGsSSVW7
X-Google-Smtp-Source: ABdhPJwb71yoXr/tmYrKu9MhvPeJGTT96ZRz8L6nqspc9HUI7PN6hGZwjA4zpwP+wllVkbTAlcRJ2SVpu0MAikHjbVSBL112CgPf
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:964:: with SMTP id q4mr10904487ilt.290.1632528441403;
 Fri, 24 Sep 2021 17:07:21 -0700 (PDT)
Date:   Fri, 24 Sep 2021 17:07:21 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000d5efd605ccc6a5df@google.com>
Subject: [syzbot] general protection fault in nf_tables_dump_tables
From:   syzbot <syzbot+0e3358e5ebb1956c271d@syzkaller.appspotmail.com>
To:     coreteam@netfilter.org, davem@davemloft.net, fw@strlen.de,
        kadlec@netfilter.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    2fcd14d0f780 Merge git://git.kernel.org/pub/scm/linux/kern..
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=13cc680b300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=e917f3dfc452c977
dashboard link: https://syzkaller.appspot.com/bug?extid=0e3358e5ebb1956c271d
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17a81d4b300000

The issue was bisected to:

commit 6001a930ce0378b62210d4f83583fc88a903d89d
Author: Pablo Neira Ayuso <pablo@netfilter.org>
Date:   Mon Feb 15 11:28:07 2021 +0000

    netfilter: nftables: introduce table ownership

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1773834b300000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=14f3834b300000
console output: https://syzkaller.appspot.com/x/log.txt?x=10f3834b300000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+0e3358e5ebb1956c271d@syzkaller.appspotmail.com
Fixes: 6001a930ce03 ("netfilter: nftables: introduce table ownership")

general protection fault, probably for non-canonical address 0xfbd59c0000000058: 0000 [#1] PREEMPT SMP KASAN
KASAN: maybe wild-memory-access in range [0xdead0000000002c0-0xdead0000000002c7]
CPU: 1 PID: 10340 Comm: syz-executor.0 Not tainted 5.15.0-rc2-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:nf_tables_dump_tables+0x343/0xa50 net/netfilter/nf_tables_api.c:822
Code: 44 24 30 e8 9f 35 08 fa 31 ff 44 89 ee e8 d5 3c 08 fa 45 85 ed 74 4c e8 8b 35 08 fa 48 8d bb c4 01 00 00 48 89 f8 48 c1 e8 03 <0f> b6 14 28 48 89 f8 83 e0 07 83 c0 01 38 d0 7c 08 84 d2 0f 85 cd
RSP: 0018:ffffc90002d2f220 EFLAGS: 00010a03
RAX: 1bd5a00000000058 RBX: dead000000000100 RCX: 0000000000000000
RDX: ffff88801fb38000 RSI: ffffffff876dd605 RDI: dead0000000002c4
RBP: dffffc0000000000 R08: 0000000000000000 R09: ffff88807ddb8043
R10: ffffffff876dd5fb R11: 0000000000000000 R12: 0000000000000001
R13: 0000000000000002 R14: 0000000000000774 R15: 0000000000000000
FS:  00007f6eebb1b700(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00005563e0826a50 CR3: 00000000701f3000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 netlink_dump+0x4b9/0xb70 net/netlink/af_netlink.c:2278
 __netlink_dump_start+0x642/0x900 net/netlink/af_netlink.c:2383
 netlink_dump_start include/linux/netlink.h:258 [inline]
 nft_netlink_dump_start_rcu+0x83/0x1c0 net/netfilter/nf_tables_api.c:859
 nf_tables_gettable+0x47d/0x570 net/netfilter/nf_tables_api.c:884
 nfnetlink_rcv_msg+0x659/0x13f0 net/netfilter/nfnetlink.c:285
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2504
 nfnetlink_rcv+0x1ac/0x420 net/netfilter/nfnetlink.c:654
 netlink_unicast_kernel net/netlink/af_netlink.c:1314 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1340
 netlink_sendmsg+0x86d/0xdb0 net/netlink/af_netlink.c:1929
 sock_sendmsg_nosec net/socket.c:704 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:724
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2409
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2463
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2492
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7f6eec3a4709
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f6eebb1b188 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007f6eec4a8f60 RCX: 00007f6eec3a4709
RDX: 0000000000000000 RSI: 0000000020000380 RDI: 0000000000000004
RBP: 00007f6eec3fecb4 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007ffdf5e6994f R14: 00007f6eebb1b300 R15: 0000000000022000
Modules linked in:
---[ end trace a1f4a53e20fe8503 ]---
RIP: 0010:nf_tables_dump_tables+0x343/0xa50 net/netfilter/nf_tables_api.c:822
Code: 44 24 30 e8 9f 35 08 fa 31 ff 44 89 ee e8 d5 3c 08 fa 45 85 ed 74 4c e8 8b 35 08 fa 48 8d bb c4 01 00 00 48 89 f8 48 c1 e8 03 <0f> b6 14 28 48 89 f8 83 e0 07 83 c0 01 38 d0 7c 08 84 d2 0f 85 cd
RSP: 0018:ffffc90002d2f220 EFLAGS: 00010a03
RAX: 1bd5a00000000058 RBX: dead000000000100 RCX: 0000000000000000
RDX: ffff88801fb38000 RSI: ffffffff876dd605 RDI: dead0000000002c4
RBP: dffffc0000000000 R08: 0000000000000000 R09: ffff88807ddb8043
R10: ffffffff876dd5fb R11: 0000000000000000 R12: 0000000000000001
R13: 0000000000000002 R14: 0000000000000774 R15: 0000000000000000
FS:  00007f6eebb1b700(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fd5c003e0c8 CR3: 00000000701f3000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
----------------
Code disassembly (best guess):
   0:	44 24 30             	rex.R and $0x30,%al
   3:	e8 9f 35 08 fa       	callq  0xfa0835a7
   8:	31 ff                	xor    %edi,%edi
   a:	44 89 ee             	mov    %r13d,%esi
   d:	e8 d5 3c 08 fa       	callq  0xfa083ce7
  12:	45 85 ed             	test   %r13d,%r13d
  15:	74 4c                	je     0x63
  17:	e8 8b 35 08 fa       	callq  0xfa0835a7
  1c:	48 8d bb c4 01 00 00 	lea    0x1c4(%rbx),%rdi
  23:	48 89 f8             	mov    %rdi,%rax
  26:	48 c1 e8 03          	shr    $0x3,%rax
* 2a:	0f b6 14 28          	movzbl (%rax,%rbp,1),%edx <-- trapping instruction
  2e:	48 89 f8             	mov    %rdi,%rax
  31:	83 e0 07             	and    $0x7,%eax
  34:	83 c0 01             	add    $0x1,%eax
  37:	38 d0                	cmp    %dl,%al
  39:	7c 08                	jl     0x43
  3b:	84 d2                	test   %dl,%dl
  3d:	0f                   	.byte 0xf
  3e:	85 cd                	test   %ecx,%ebp


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
