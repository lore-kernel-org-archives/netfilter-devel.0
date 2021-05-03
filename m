Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD4B7C433ED
	for <netfilter-devel@archiver.kernel.org>; Mon,  3 May 2021 03:00:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B205B6139A
	for <netfilter-devel@archiver.kernel.org>; Mon,  3 May 2021 03:00:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232782AbhECDBR (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 2 May 2021 23:01:17 -0400
Received: from mail-io1-f69.google.com ([209.85.166.69]:34328 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230368AbhECDBQ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 2 May 2021 23:01:16 -0400
Received: by mail-io1-f69.google.com with SMTP id v25-20020a0566020159b02904017f565b33so2316405iot.1
        for <netfilter-devel@vger.kernel.org>; Sun, 02 May 2021 20:00:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=QsmWOiuqBjacmw1ctaNCjChVXJoRgKeDEkz+C0oyblw=;
        b=opRp2tbpVEKMFlRh0kTmWuZUY2LpU378zsXOcOhJeHCNi3yxGSiO6W4A5UNv+Q7eXA
         xNa9bJH0VZaI5rGYMM6CnPKKNTHmnFRPVREHRGVHlqwN+DTRcEYvgt28vVaDNP2+JHgL
         TwFOkr6Q/0Ml8jUp7wHgpNP5WR09GYo3K6NdX0OPahlcIbmD9wDQl1dkvu4rBHbvt1Sp
         U/sJoY77mZ3//hvnxTob+zSctQ1ZoqtlNXWaZwEDAKn8dGj4QSPgruVB5lnN8O1ZZHEq
         i0vTNe5QDVgLEbiJUOClyXsHFBADgEU3CVkhkGxvcdYxa6zA6FolFjfmuDfuKxJpC2kl
         9deg==
X-Gm-Message-State: AOAM533FRzxJZKWY6vtNh06bjQSQbvEnD0JtCjyir2QQzWThNJ6NyHI9
        41N4qm+SaM+ubThIiWzfWAxNNwm5J9bie4DTd+g7Q1LMeNUZ
X-Google-Smtp-Source: ABdhPJxFHPJcx1dQ9Ta7mvY45fXl8ZWoc4sgViuiPUjYxPbvgejLvXSZs8CkXZJccsJ4g2qApaBs4cXs2gKZWKGDicWXsA0QY+QZ
MIME-Version: 1.0
X-Received: by 2002:a92:c7a1:: with SMTP id f1mr13598531ilk.33.1620010824063;
 Sun, 02 May 2021 20:00:24 -0700 (PDT)
Date:   Sun, 02 May 2021 20:00:24 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000b361bf05c16429a5@google.com>
Subject: [syzbot] bpf-next test error: WARNING in __nf_unregister_net_hook
From:   syzbot <syzbot+0d9ff6eeee8f4b6e2aed@syzkaller.appspotmail.com>
To:     ast@kernel.org, coreteam@netfilter.org, daniel@iogearbox.net,
        davem@davemloft.net, fw@strlen.de, kadlec@netfilter.org,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        pablo@netfilter.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    9d31d233 Merge tag 'net-next-5.13' of git://git.kernel.org..
git tree:       bpf-next
console output: https://syzkaller.appspot.com/x/log.txt?x=102b70d9d00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=57b4b78935781045
dashboard link: https://syzkaller.appspot.com/bug?extid=0d9ff6eeee8f4b6e2aed

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+0d9ff6eeee8f4b6e2aed@syzkaller.appspotmail.com

------------[ cut here ]------------
hook not found, pf 3 num 0
WARNING: CPU: 1 PID: 108 at net/netfilter/core.c:480 __nf_unregister_net_hook+0x1eb/0x610 net/netfilter/core.c:480
Modules linked in:
CPU: 1 PID: 108 Comm: kworker/u4:2 Not tainted 5.12.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: netns cleanup_net
RIP: 0010:__nf_unregister_net_hook+0x1eb/0x610 net/netfilter/core.c:480
Code: 0f b6 14 02 48 89 c8 83 e0 07 83 c0 03 38 d0 7c 08 84 d2 0f 85 11 04 00 00 8b 53 1c 89 ee 48 c7 c7 c0 78 6d 8a e8 60 4c 8a 01 <0f> 0b e9 e5 00 00 00 e8 79 48 30 fa 44 8b 3c 24 4c 89 f8 48 c1 e0
RSP: 0018:ffffc9000121fbc0 EFLAGS: 00010286
RAX: 0000000000000000 RBX: ffff888147896c00 RCX: 0000000000000000
RDX: ffff888012371c40 RSI: ffffffff815c8ba5 RDI: fffff52000243f6a
RBP: 0000000000000003 R08: 0000000000000000 R09: 0000000000000000
R10: ffffffff815c2a0e R11: 0000000000000000 R12: ffff88802f600f20
R13: 0000000000000000 R14: ffff888021357800 R15: 0000000000000001
FS:  0000000000000000(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000f43ef0 CR3: 0000000024afe000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
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
