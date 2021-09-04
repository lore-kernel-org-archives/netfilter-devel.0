Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.9 required=3.0 tests=BAYES_00,FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16A77C433F5
	for <netfilter-devel@archiver.kernel.org>; Sat,  4 Sep 2021 16:46:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F181960F5D
	for <netfilter-devel@archiver.kernel.org>; Sat,  4 Sep 2021 16:46:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237039AbhIDQrh (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 4 Sep 2021 12:47:37 -0400
Received: from mail-io1-f72.google.com ([209.85.166.72]:46757 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237012AbhIDQrg (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 4 Sep 2021 12:47:36 -0400
Received: by mail-io1-f72.google.com with SMTP id s6-20020a5ec646000000b005b7f88ffdd3so1711226ioo.13
        for <netfilter-devel@vger.kernel.org>; Sat, 04 Sep 2021 09:46:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=huiWn6OJf1Z8+HD+VinaZl059PYkj4x1r8j41/BduPQ=;
        b=jdrvZZXDFcK5T0TuW7lo26MPgfjdHkZtDZeAN6k6F/mEHXdvma3zCxOujnLEnGTIri
         CP+T66f3yn9Mrd9FiuO/eABYave18CrwWlHYHZ54f7Ls65Q1rXEzB8jSl9no6+ayn0mI
         wHkYKEf5wCyYZXW5HaDnyvYiiYskTLlleVW3U8bNXxDsGD2vZGHjhuSxihKt/pr4vs8Q
         k63gCqrSb8xLt1VMxS+Ou48vkly9KQrn+jvhJeUOzHChLojWYkZ31pa50JMyTQ2d5uxU
         tl5Cs41zC/jZZoMl/hUPe5QhkTPBRoYPqXc8SmCXGCX9AhvZ5pyWVvnAYsXfFHzaZBof
         0eYg==
X-Gm-Message-State: AOAM530QFqW8MeBvPwwc5Va/twXzDSyBp47kvWC2ZW9leutcMKL2yBN2
        8yobrK9Q/V2+3VAyrRCx1iCBjzE8SVJZzkddT8cRQTecyspR
X-Google-Smtp-Source: ABdhPJyPhigVO5GV0BU/1v96Ow36EPc+LvIoS+8KBaRJKi9LdPSrCwI7fri9E836e9/mbKvq0ye8EOR0LQVxLDwSDEA2/kvJP6EY
MIME-Version: 1.0
X-Received: by 2002:a92:c5aa:: with SMTP id r10mr3083929ilt.274.1630773994893;
 Sat, 04 Sep 2021 09:46:34 -0700 (PDT)
Date:   Sat, 04 Sep 2021 09:46:34 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000acb87205cb2e283c@google.com>
Subject: [syzbot] WARNING: kmalloc bug in hash_ipportnet_create
From:   syzbot <syzbot+0e73f839b35d0973fb97@syzkaller.appspotmail.com>
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

HEAD commit:    7cca308cfdc0 Merge tag 'powerpc-5.15-1' of git://git.kerne..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1238fbbd300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=8aa56a640db99eb1
dashboard link: https://syzkaller.appspot.com/bug?extid=0e73f839b35d0973fb97
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.1
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10ef4e0b300000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1302e115300000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+0e73f839b35d0973fb97@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 0 PID: 8442 at mm/util.c:597 kvmalloc_node+0x111/0x120 mm/util.c:597
Modules linked in:
CPU: 0 PID: 8442 Comm: syz-executor543 Not tainted 5.14.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:kvmalloc_node+0x111/0x120 mm/util.c:597
Code: 01 00 00 00 4c 89 e7 e8 4d 17 0d 00 49 89 c5 e9 69 ff ff ff e8 30 3e d1 ff 41 89 ed 41 81 cd 00 20 01 00 eb 95 e8 1f 3e d1 ff <0f> 0b e9 4c ff ff ff 0f 1f 84 00 00 00 00 00 55 48 89 fd 53 e8 06
RSP: 0018:ffffc900019f7288 EFLAGS: 00010293
RAX: 0000000000000000 RBX: ffffc900019f73a0 RCX: 0000000000000000
RDX: ffff888018236140 RSI: ffffffff81a41371 RDI: 0000000000000003
RBP: 0000000000400dc0 R08: 000000007fffffff R09: 000000000000001c
R10: ffffffff81a4132e R11: 000000000000001f R12: 0000000080000018
R13: 0000000000000000 R14: 00000000ffffffff R15: ffff8880171e1000
FS:  00000000020ae300(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020000246 CR3: 0000000013999000 CR4: 00000000001506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 hash_ipportnet_create+0x3dd/0x1220 net/netfilter/ipset/ip_set_hash_gen.h:1524
 ip_set_create+0x782/0x15a0 net/netfilter/ipset/ip_set_core.c:1100
 nfnetlink_rcv_msg+0xbc9/0x13f0 net/netfilter/nfnetlink.c:296
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
RIP: 0033:0x43f039
Code: 28 c3 e8 2a 14 00 00 66 2e 0f 1f 84 00 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffe5f928db8 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 0000000000400488 RCX: 000000000043f039
RDX: 0000000000000000 RSI: 00000000200000c0 RDI: 0000000000000003
RBP: 0000000000403020 R08: 0000000000000005 R09: 0000000000400488
R10: 0000000000000004 R11: 0000000000000246 R12: 00000000004030b0
R13: 0000000000000000 R14: 00000000004ac018 R15: 0000000000400488


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
