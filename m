Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7782FC48BDF
	for <netfilter-devel@archiver.kernel.org>; Sun, 20 Jun 2021 23:22:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4C127611AC
	for <netfilter-devel@archiver.kernel.org>; Sun, 20 Jun 2021 23:22:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229899AbhFTXYa (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 20 Jun 2021 19:24:30 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:40943 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229875AbhFTXY3 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 20 Jun 2021 19:24:29 -0400
Received: by mail-io1-f71.google.com with SMTP id l15-20020a5e820f0000b02904bd1794d00eso8995623iom.7
        for <netfilter-devel@vger.kernel.org>; Sun, 20 Jun 2021 16:22:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=BqnKWzwtAQvEzSaBToMPLDFYUsWkoHiliy61h2x+ZUA=;
        b=rs8QOFOFuWGkZM9MyHckngT5l7XzUoTt9ZwzU12/zmPDTN3VVve89ioPB1pOfDZlfe
         jRsx8HRroB5aRmClKn/uRLKOylS4UuyV9WR4D+NGcuob7V1380KdyUrAqOUj/H/CPX1O
         mfFC5gWiQhXLQc2ntqUBtdXEonyiAyOTKEKBo0ZuG6zFhQVEEKEElpogIhykHB8N1ift
         9nKPBRmAJR6fJH5dy3o1CfTLaUF6RXb1397sGvOqAOPe1CViU3/mxwyB9Zl1SXFZ+z2w
         nThTWBu81VCSVF9cmSR0GeaTIzGOtzHtVqIqiN5+yaaHSKjyODQvgE5gHOW8YCox+Sn6
         qGpQ==
X-Gm-Message-State: AOAM532gOEWbMhnusY1MsAFF25eLGK/PcbSdbiNhuFyCryXKUQDz6GTO
        RJEy+kRZ1ZqFU/5WsPhu/VJRzDEAxnc55mZ95qWJXq0itf01
X-Google-Smtp-Source: ABdhPJyWiEMVZPD/h2RokK4V7o73QVWvvWVi7Idtwt3lT6GGw5JlKqF3+/47RIQpKsRVunqRvAKgkoohdAJANQTmcMaP3Y/372q0
MIME-Version: 1.0
X-Received: by 2002:a5d:9051:: with SMTP id v17mr565354ioq.81.1624231336038;
 Sun, 20 Jun 2021 16:22:16 -0700 (PDT)
Date:   Sun, 20 Jun 2021 16:22:16 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000d154d905c53ad34d@google.com>
Subject: [syzbot] general protection fault in smc_tx_sendmsg
From:   syzbot <syzbot+5dda108b672b54141857@syzkaller.appspotmail.com>
To:     coreteam@netfilter.org, davem@davemloft.net, dsahern@kernel.org,
        fw@strlen.de, kadlec@netfilter.org, kgraul@linux.ibm.com,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        syzkaller-bugs@googlegroups.com, yoshfuji@linux-ipv6.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    0c337952 Merge tag 'wireless-drivers-next-2021-06-16' of g..
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=1621de10300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a6380da8984033f1
dashboard link: https://syzkaller.appspot.com/bug?extid=5dda108b672b54141857
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=121d2d20300000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=100bd768300000

The issue was bisected to:

commit f9006acc8dfe59e25aa75729728ac57a8d84fc32
Author: Florian Westphal <fw@strlen.de>
Date:   Wed Apr 21 07:51:08 2021 +0000

    netfilter: arp_tables: pass table pointer via nf_hook_ops

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=12600fffd00000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=11600fffd00000
console output: https://syzkaller.appspot.com/x/log.txt?x=16600fffd00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+5dda108b672b54141857@syzkaller.appspotmail.com
Fixes: f9006acc8dfe ("netfilter: arp_tables: pass table pointer via nf_hook_ops")

general protection fault, probably for non-canonical address 0xdffffc0000000004: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000020-0x0000000000000027]
CPU: 1 PID: 8455 Comm: syz-executor893 Not tainted 5.13.0-rc3-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:smc_tx_sendmsg+0x204/0x1ba0 net/smc/smc_tx.c:157
Code: 48 c1 ea 03 80 3c 02 00 0f 85 8b 17 00 00 49 8b 9d 08 05 00 00 48 b8 00 00 00 00 00 fc ff df 48 8d 7b 20 48 89 fa 48 c1 ea 03 <0f> b6 04 02 84 c0 74 08 3c 03 0f 8e 8f 17 00 00 48 63 5b 20 4c 8b
RSP: 0018:ffffc9000164f800 EFLAGS: 00010202
RAX: dffffc0000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000000004 RSI: ffffffff889cd6ae RDI: 0000000000000020
RBP: ffff88801cf58000 R08: 0000000000000000 R09: 0000000000000000
R10: ffffffff889cd6a1 R11: 0000000000000000 R12: 0000000000000000
R13: ffff88801cf58000 R14: ffffc9000164fd90 R15: ffff88801cf58060
FS:  0000000000ebf300(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ffd43ca1328 CR3: 000000002acf2000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 smc_sendmsg+0x274/0x5b0 net/smc/af_smc.c:2037
 sock_sendmsg_nosec net/socket.c:654 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:674
 ____sys_sendmsg+0x331/0x810 net/socket.c:2350
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2404
 __sys_sendmmsg+0x195/0x470 net/socket.c:2490
 __do_sys_sendmmsg net/socket.c:2519 [inline]
 __se_sys_sendmmsg net/socket.c:2516 [inline]
 __x64_sys_sendmmsg+0x99/0x100 net/socket.c:2516
 do_syscall_64+0x3a/0xb0 arch/x86/entry/common.c:47
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x43ee89
Code: 28 c3 e8 2a 14 00 00 66 2e 0f 1f 84 00 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffc82b20a58 EFLAGS: 00000246 ORIG_RAX: 0000000000000133
RAX: ffffffffffffffda RBX: 0000000000400488 RCX: 000000000043ee89
RDX: 0000000000000001 RSI: 0000000020003d80 RDI: 0000000000000003
RBP: 0000000000402e70 R08: 0000000000000000 R09: 0000000000400488
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000402f00
R13: 0000000000000000 R14: 00000000004ac018 R15: 0000000000400488
Modules linked in:
---[ end trace 459b28282ae53115 ]---
RIP: 0010:smc_tx_sendmsg+0x204/0x1ba0 net/smc/smc_tx.c:157
Code: 48 c1 ea 03 80 3c 02 00 0f 85 8b 17 00 00 49 8b 9d 08 05 00 00 48 b8 00 00 00 00 00 fc ff df 48 8d 7b 20 48 89 fa 48 c1 ea 03 <0f> b6 04 02 84 c0 74 08 3c 03 0f 8e 8f 17 00 00 48 63 5b 20 4c 8b
RSP: 0018:ffffc9000164f800 EFLAGS: 00010202
RAX: dffffc0000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000000004 RSI: ffffffff889cd6ae RDI: 0000000000000020
RBP: ffff88801cf58000 R08: 0000000000000000 R09: 0000000000000000
R10: ffffffff889cd6a1 R11: 0000000000000000 R12: 0000000000000000
R13: ffff88801cf58000 R14: ffffc9000164fd90 R15: ffff88801cf58060
FS:  0000000000ebf300(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055b7501be298 CR3: 000000002acf2000 CR4: 00000000001506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
