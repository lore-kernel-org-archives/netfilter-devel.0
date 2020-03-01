Return-Path: <SRS0=wwvA=4S=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.4 required=3.0 tests=FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34390C3F2D1
	for <netfilter-devel@archiver.kernel.org>; Sun,  1 Mar 2020 11:21:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 146B321775
	for <netfilter-devel@archiver.kernel.org>; Sun,  1 Mar 2020 11:21:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726798AbgCALVP (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 1 Mar 2020 06:21:15 -0500
Received: from mail-il1-f199.google.com ([209.85.166.199]:50470 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725874AbgCALVO (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 1 Mar 2020 06:21:14 -0500
Received: by mail-il1-f199.google.com with SMTP id z12so8227982ilh.17
        for <netfilter-devel@vger.kernel.org>; Sun, 01 Mar 2020 03:21:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=F2M/p9iF68HAFAzmluvJryCbsipnLPuxg09c4nmnAuI=;
        b=ZzYSTEFapyleyoynI9qPJitXXt4oVunbo0CTippjyS3X5AnsDSiYjI/FbqOxXkweMg
         +C2Tjw4HnyAwcP/X5+9lP2wYuVcNznsIL6h9KspvWq+zJd11WxhYtyA5sNbWz66gHQKm
         px8JCzpRa+76Ls5/RdSKPVibiGgv4szZbPvjeNgVz+O4g3TuWwgrWBQQfVobhwUGMcVO
         HYGHs4G9G8zgl4KBzwWWuDp13WiQkBhu4uNOI9VILBnz8z9uNHKrmNF16dKaWcO/3dcY
         v3/a/bgntxo2xuE4dGuiqSPAssDWd9+6sm5nuEaZsoSI+mxfIm97A9AcFNpz+fzfY5g8
         LWHQ==
X-Gm-Message-State: APjAAAVHWs7fXaVnVOySHwRNRal8a63vK9IkTb8IpNMLTOvEkSZdzgoT
        y5ZYHLlYwwivRlveTBCWKRatU/Yg3i91hRruGqNjc9jsFyNz
X-Google-Smtp-Source: APXvYqzc36P+9OkIwWrhrSY9yuG0z4wTPj0erPw3RDrFfuNtqd2k44Y6NzB3pm4wA/M1s+BEwnpvEUV5WwNPdheKvnmauTIqqmHQ
MIME-Version: 1.0
X-Received: by 2002:a02:cc75:: with SMTP id j21mr9819265jaq.113.1583061672019;
 Sun, 01 Mar 2020 03:21:12 -0800 (PST)
Date:   Sun, 01 Mar 2020 03:21:12 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000009e504d059fc9447a@google.com>
Subject: general protection fault in gc_worker
From:   syzbot <syzbot+2a2fe383b2ce0e44b6ea@syzkaller.appspotmail.com>
To:     coreteam@netfilter.org, davem@davemloft.net, fw@strlen.de,
        kadlec@netfilter.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    f8788d86 Linux 5.6-rc3
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=104263a1e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=9833e26bab355358
dashboard link: https://syzkaller.appspot.com/bug?extid=2a2fe383b2ce0e44b6ea
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+2a2fe383b2ce0e44b6ea@syzkaller.appspotmail.com

general protection fault, probably for non-canonical address 0xdffffc0000000006: 0000 [#1] PREEMPT SMP KASAN
KASAN: null-ptr-deref in range [0x0000000000000030-0x0000000000000037]
CPU: 0 PID: 22524 Comm: kworker/0:10 Not tainted 5.6.0-rc3-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: events_power_efficient gc_worker
RIP: 0010:nf_ct_tuplehash_to_ctrack include/net/netfilter/nf_conntrack.h:113 [inline]
RIP: 0010:gc_worker+0x3b1/0xdd0 net/netfilter/nf_conntrack_core.c:1390
Code: e8 03 4c 01 f8 85 db 48 89 85 70 ff ff ff 0f 85 53 03 00 00 e8 10 9d 01 fb 49 8d 7e 37 48 89 f8 48 89 fa 48 c1 e8 03 83 e2 07 <42> 0f b6 04 38 38 d0 7f 08 84 c0 0f 85 c4 08 00 00 41 0f b6 46 37
RSP: 0018:ffffc9000604fc40 EFLAGS: 00010202
RAX: 0000000000000006 RBX: 0000000000000000 RCX: ffffffff8673ed86
RDX: 0000000000000007 RSI: ffffffff8673ea40 RDI: 0000000000000037
RBP: ffffc9000604fd20 R08: ffff8880a25f23c0 R09: ffffed1000025fb8
R10: ffffed1000025fb7 R11: ffff88800012fdbb R12: ffff88800012fdb8
R13: 0000000000010000 R14: 0000000000000000 R15: dffffc0000000000
FS:  0000000000000000(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 000000005014d000 CR4: 00000000001426f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 process_one_work+0xa05/0x17a0 kernel/workqueue.c:2264
 worker_thread+0x98/0xe40 kernel/workqueue.c:2410
 kthread+0x361/0x430 kernel/kthread.c:255
 ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352
Modules linked in:
---[ end trace 3051a0fdf6c90610 ]---
RIP: 0010:nf_ct_tuplehash_to_ctrack include/net/netfilter/nf_conntrack.h:113 [inline]
RIP: 0010:gc_worker+0x3b1/0xdd0 net/netfilter/nf_conntrack_core.c:1390
Code: e8 03 4c 01 f8 85 db 48 89 85 70 ff ff ff 0f 85 53 03 00 00 e8 10 9d 01 fb 49 8d 7e 37 48 89 f8 48 89 fa 48 c1 e8 03 83 e2 07 <42> 0f b6 04 38 38 d0 7f 08 84 c0 0f 85 c4 08 00 00 41 0f b6 46 37
RSP: 0018:ffffc9000604fc40 EFLAGS: 00010202
RAX: 0000000000000006 RBX: 0000000000000000 RCX: ffffffff8673ed86
RDX: 0000000000000007 RSI: ffffffff8673ea40 RDI: 0000000000000037
RBP: ffffc9000604fd20 R08: ffff8880a25f23c0 R09: ffffed1000025fb8
R10: ffffed1000025fb7 R11: ffff88800012fdbb R12: ffff88800012fdb8
R13: 0000000000010000 R14: 0000000000000000 R15: dffffc0000000000
FS:  0000000000000000(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000928000 CR3: 0000000217f1b000 CR4: 00000000001426f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
