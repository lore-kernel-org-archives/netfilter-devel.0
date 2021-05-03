Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D7EDC433B4
	for <netfilter-devel@archiver.kernel.org>; Mon,  3 May 2021 17:20:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5403661026
	for <netfilter-devel@archiver.kernel.org>; Mon,  3 May 2021 17:20:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232281AbhECRVP (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 3 May 2021 13:21:15 -0400
Received: from mail-io1-f72.google.com ([209.85.166.72]:52084 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232091AbhECRVO (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 3 May 2021 13:21:14 -0400
Received: by mail-io1-f72.google.com with SMTP id h7-20020a5d9e070000b029041a1f6bccc8so3781839ioh.18
        for <netfilter-devel@vger.kernel.org>; Mon, 03 May 2021 10:20:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=SsW4WGApkthaeG/yN0Sh2zDtXgNB7YUudWMFW51IJwk=;
        b=MzT+rL6j0wqjrC5NkME4VPmzWDn8v9FoonNgDRjpG63SkRKxdbpqcCtLhPcWJU2JZt
         yNN7NnEFArqAqXQLNZPj6JaP4NWeZ8Ib96y5TLkwJHQsNy/KjWU6mmndw8JgNBTt6c5H
         QiKvcRA5bFbBzCeoXEdVhRpBWyhc5PYi4Pb/2nmX4SsaZU+swPPnoWO1TWeMgAItuoCr
         xSTiKQAoCaUIln1dKViXtp6yEdZD+cdA8CTquUldauutIZc7HpXFB5p1szNZFdsoqjoB
         rl80hZ+dt2bq1Hay0esnPtmCQNY2gOteBqAFx7cdYOb5/v2C2WkjFA+/qLFYNQ3s0uQ9
         k/8g==
X-Gm-Message-State: AOAM532sDv+W62DqU215qGg50kC7CpodS7/NE6lJky7ywf1jLYHlzSnz
        68A9+/qMD4lu1xtWieXrYH0Temr7GslO4rhP1On4Vh7zhsKX
X-Google-Smtp-Source: ABdhPJyt0vvFF+YFkGZh1hStsZ1HJyTL9uTFPJzka9gUtjT7vrUzG58a5Y5uPLQo8wLUfqm2+v60eWC5ekB5R+ERdt9TXZYXwj/1
MIME-Version: 1.0
X-Received: by 2002:a6b:ea10:: with SMTP id m16mr15356144ioc.124.1620062421212;
 Mon, 03 May 2021 10:20:21 -0700 (PDT)
Date:   Mon, 03 May 2021 10:20:21 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000021665f05c1702dd1@google.com>
Subject: [syzbot] upstream test error: WARNING in __nf_unregister_net_hook
From:   syzbot <syzbot+7ad5cd1615f2d89c6e7e@syzkaller.appspotmail.com>
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

HEAD commit:    9ccce092 Merge tag 'for-linus-5.13-ofs-1' of git://git.ker..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=15303b33d00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=27df24136354948b
dashboard link: https://syzkaller.appspot.com/bug?extid=7ad5cd1615f2d89c6e7e

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+7ad5cd1615f2d89c6e7e@syzkaller.appspotmail.com

wlan1: Created IBSS using preconfigured BSSID 50:50:50:50:50:50
wlan1: Creating new IBSS network, BSSID 50:50:50:50:50:50
------------[ cut here ]------------
hook not found, pf 3 num 0
WARNING: CPU: 0 PID: 334 at net/netfilter/core.c:480 __nf_unregister_net_hook+0x1eb/0x610 net/netfilter/core.c:480
Modules linked in:
CPU: 0 PID: 334 Comm: kworker/u4:5 Not tainted 5.12.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: netns cleanup_net
RIP: 0010:__nf_unregister_net_hook+0x1eb/0x610 net/netfilter/core.c:480
Code: 0f b6 14 02 48 89 c8 83 e0 07 83 c0 03 38 d0 7c 08 84 d2 0f 85 11 04 00 00 8b 53 1c 89 ee 48 c7 c7 c0 15 6e 8a e8 f6 3c 8a 01 <0f> 0b e9 e5 00 00 00 e8 59 3e 2e fa 44 8b 3c 24 4c 89 f8 48 c1 e0
RSP: 0018:ffffc90001fcfbc0 EFLAGS: 00010286
RAX: 0000000000000000 RBX: ffff88814459f300 RCX: 0000000000000000
RDX: ffff888013648000 RSI: ffffffff815caa75 RDI: fffff520003f9f6a
RBP: 0000000000000003 R08: 0000000000000000 R09: 0000000000000000
R10: ffffffff815c48de R11: 0000000000000000 R12: ffff888033e98f20
R13: 0000000000000000 R14: ffff888012825c00 R15: 0000000000000001
FS:  0000000000000000(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000c000a00000 CR3: 00000000159c4000 CR4: 0000000000350ee0
Call Trace:
 nf_unregister_net_hook net/netfilter/core.c:502 [inline]
 nf_unregister_net_hooks+0x117/0x160 net/netfilter/core.c:576
 arpt_unregister_table_pre_exit+0x67/0x80 net/ipv4/netfilter/arp_tables.c:1565
 ops_pre_exit_list net/core/net_namespace.c:165 [inline]
 cleanup_net+0x451/0xb10 net/core/net_namespace.c:583
 process_one_work+0x98d/0x1600 kernel/workqueue.c:2275
 worker_thread+0x64c/0x1120 kernel/workqueue.c:2421
 kthread+0x3b1/0x4a0 kernel/kthread.c:313
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
