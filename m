Return-Path: <SRS0=S2pA=AZ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=BAYES_00,FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D949C433E1
	for <netfilter-devel@archiver.kernel.org>; Tue, 14 Jul 2020 03:56:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1E30B21D90
	for <netfilter-devel@archiver.kernel.org>; Tue, 14 Jul 2020 03:56:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726568AbgGND4X (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 13 Jul 2020 23:56:23 -0400
Received: from mail-io1-f70.google.com ([209.85.166.70]:36158 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726505AbgGND4W (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 13 Jul 2020 23:56:22 -0400
Received: by mail-io1-f70.google.com with SMTP id g17so9607477iob.3
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Jul 2020 20:56:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=vwdPlU1PrYjkqbfwhsZQcX2BXd1nYCKuk7q1J0ZeKXk=;
        b=b2rdyjAg9jN1QPVgEFAnl9S+XGoa8GSeRIqq+qQrCxAbyJ7HBqSG36BC6ejAHeHqgQ
         EKkgJiAyXL4Vea0ROUOtEabhaSgIPlL8sGKjmMRRFg7iZinYdjOTben6YCwpTVS9pEK+
         4Uym5ryy+keKSi1/DUEyX6QXEyPT91GLMvAPSwK3Q8MZhhq7FiW6XbCAqFVfCFlUr7Gd
         OSyDtgj1JlVbv579FF7EgdxHPk7JO9AQpjh2mqJQOzwkBiophxFXdPBaZI/IRAZGKOV8
         O61efMxJe5EwAdRVe65qkLp2jdcaKA/WZrfJmnXE7vSNbojV6cj4vU3o2o5kIJ+zAXGM
         565w==
X-Gm-Message-State: AOAM533ch8OOrt8fn0ejPnibo9Cr4v2wGHIxWNzFJNvLU2xSqIzkYxgs
        OMp6mxtdSLr3/3kKjsu8gpPiES6sFbPTD7KmrnYN3YsmOr1u
X-Google-Smtp-Source: ABdhPJxbtwhnxJQM82iiHLLvQ9pUAKuggv9im1h2ick1MGTTT1OjSazcw29Ym0P0nY2EtFYdPVLRfS/mpaD7RoOoM07zCEITNE2e
MIME-Version: 1.0
X-Received: by 2002:a92:cf42:: with SMTP id c2mr3141754ilr.13.1594698980928;
 Mon, 13 Jul 2020 20:56:20 -0700 (PDT)
Date:   Mon, 13 Jul 2020 20:56:20 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000048335c05aa5eca10@google.com>
Subject: WARNING in __nf_unregister_net_hook (2)
From:   syzbot <syzbot+2570f2c036e3da5db176@syzkaller.appspotmail.com>
To:     coreteam@netfilter.org, davem@davemloft.net, fw@strlen.de,
        kadlec@blackhole.kfki.hu, kadlec@netfilter.org, kuba@kernel.org,
        kuznet@ms2.inr.ac.ru, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        pablo@netfilter.org, syzkaller-bugs@googlegroups.com,
        yoshfuji@linux-ipv6.org
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    0aea6d5c Merge tag 'for-linus-5.8b-rc5-tag' of git://git.k..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1646fd67100000
kernel config:  https://syzkaller.appspot.com/x/.config?x=b1a5a263f7a540cb
dashboard link: https://syzkaller.appspot.com/bug?extid=2570f2c036e3da5db176
compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1646988b100000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=132b1263100000

The bug was bisected to:

commit db8ab38880e06dedbfc879e75f5b0ddc495f4eb6
Author: Florian Westphal <fw@strlen.de>
Date:   Thu Feb 28 11:02:52 2019 +0000

    netfilter: nf_tables: merge ipv4 and ipv6 nat chain types

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1013e3db100000
final crash:    https://syzkaller.appspot.com/x/report.txt?x=1213e3db100000
console output: https://syzkaller.appspot.com/x/log.txt?x=1413e3db100000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+2570f2c036e3da5db176@syzkaller.appspotmail.com
Fixes: db8ab38880e0 ("netfilter: nf_tables: merge ipv4 and ipv6 nat chain types")

------------[ cut here ]------------
hook not found, pf 2 num 0
WARNING: CPU: 0 PID: 6775 at net/netfilter/core.c:413 __nf_unregister_net_hook+0x3e6/0x4a0 net/netfilter/core.c:413
Kernel panic - not syncing: panic_on_warn set ...
CPU: 0 PID: 6775 Comm: syz-executor554 Not tainted 5.8.0-rc4-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x1f0/0x31e lib/dump_stack.c:118
 panic+0x264/0x7a0 kernel/panic.c:231
 __warn+0x227/0x250 kernel/panic.c:600
 report_bug+0x1b1/0x2e0 lib/bug.c:198
 handle_bug+0x42/0x80 arch/x86/kernel/traps.c:235
 exc_invalid_op+0x16/0x40 arch/x86/kernel/traps.c:255
 asm_exc_invalid_op+0x12/0x20 arch/x86/include/asm/idtentry.h:542
RIP: 0010:__nf_unregister_net_hook+0x3e6/0x4a0 net/netfilter/core.c:413
Code: 49 30 c3 02 01 48 8b 44 24 20 42 8a 04 28 84 c0 0f 85 ad 00 00 00 41 8b 14 24 48 c7 c7 78 ad 08 89 89 de 31 c0 e8 6a 5a a0 fa <0f> 0b e9 04 ff ff ff 44 89 e1 80 e1 07 80 c1 03 38 c1 0f 8c 44 fc
RSP: 0018:ffffc90001277718 EFLAGS: 00010246
RAX: 08b629c459c08900 RBX: 0000000000000002 RCX: ffff8880941721c0
RDX: 0000000000000000 RSI: 0000000000000008 RDI: 0000000000000282
RBP: ffffffff895b8008 R08: dffffc0000000000 R09: fffffbfff16338a7
R10: fffffbfff16338a7 R11: 0000000000000000 R12: ffff888094f5461c
R13: dffffc0000000000 R14: 0000000000000050 R15: ffffffff895b7040
 nft_unregister_basechain_hooks net/netfilter/nf_tables_api.c:206 [inline]
 nft_table_disable net/netfilter/nf_tables_api.c:835 [inline]
 nf_tables_table_disable net/netfilter/nf_tables_api.c:868 [inline]
 nf_tables_commit+0x32d3/0x4d70 net/netfilter/nf_tables_api.c:7550
 nfnetlink_rcv_batch net/netfilter/nfnetlink.c:486 [inline]
 nfnetlink_rcv_skb_batch net/netfilter/nfnetlink.c:544 [inline]
 nfnetlink_rcv+0x14a5/0x1e50 net/netfilter/nfnetlink.c:562
 netlink_unicast_kernel net/netlink/af_netlink.c:1303 [inline]
 netlink_unicast+0x786/0x940 net/netlink/af_netlink.c:1329
 netlink_sendmsg+0xa57/0xd70 net/netlink/af_netlink.c:1918
 sock_sendmsg_nosec net/socket.c:652 [inline]
 sock_sendmsg net/socket.c:672 [inline]
 ____sys_sendmsg+0x519/0x800 net/socket.c:2352
 ___sys_sendmsg net/socket.c:2406 [inline]
 __sys_sendmsg+0x2b1/0x360 net/socket.c:2439
 do_syscall_64+0x73/0xe0 arch/x86/entry/common.c:384
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x440709
Code: Bad RIP value.
RSP: 002b:00007fff97b1aa78 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00000000004002c8 RCX: 0000000000440709
RDX: 0000000000000000 RSI: 000000002000c2c0 RDI: 0000000000000003
RBP: 00000000006ca018 R08: 0000000000000000 R09: 00000000004002c8
R10: 0000000000000003 R11: 0000000000000246 R12: 0000000000401f10
R13: 0000000000401fa0 R14: 0000000000000000 R15: 0000000000000000
Kernel Offset: disabled
Rebooting in 86400 seconds..


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
