Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B3F1C2BB48
	for <netfilter-devel@archiver.kernel.org>; Tue, 15 Dec 2020 10:26:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2B47122209
	for <netfilter-devel@archiver.kernel.org>; Tue, 15 Dec 2020 10:26:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727292AbgLOKZH (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 15 Dec 2020 05:25:07 -0500
Received: from mail-io1-f72.google.com ([209.85.166.72]:46515 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727377AbgLOKYw (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 15 Dec 2020 05:24:52 -0500
Received: by mail-io1-f72.google.com with SMTP id a2so13289085iod.13
        for <netfilter-devel@vger.kernel.org>; Tue, 15 Dec 2020 02:24:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=0qYa0dsPMP7tmde6ntcVuGWaHNVgAG/+qCsZ5UYMglA=;
        b=tQg6n1wvVfLkjjx43lHvw5qIWx86C55QWN3ZM91v+gs34YuypBBu60rxq155UH6qZ4
         6maNPITY/BZROAztql953I/EDM9E+lGTDYWcMcMqvRAvE4TEn/4nSWptgcCVyyWE9Udv
         VBlxw5gRUMhy2HETzYEmoyhLRDCw+1KPaIGKGhKR3jHKUwACScJePwyc4k9utEw++GdJ
         u2fxPx9iuK0whmJOtW1ysuUr4Hg73Z+7QUfQVQUPgyT4ki+WY7Cjjb0z77Ed8VSIILkz
         Rzjlu/xH2NDpFqJiYtol7ARhYfPRuiCu3320zPfDCv8Huhup5EZmrhhlfTGB8ROrMOIl
         wJTQ==
X-Gm-Message-State: AOAM531hYge8TftLEDvcCFZHtNa33SUC3prWkAUGFdgQ4iCGGylfwmht
        eH5VXCNEZHH79+QwVv5fPEu5YDUXSAX2aBZnpCyqWc0IwPJe
X-Google-Smtp-Source: ABdhPJxxohlQ3B+YU2w+xW9BNn1uL9NYPvq1Vh698TyAU4Sv8vBCGpnnXaCjJAI7K/WQcAX8b0ZLOdRbBe52sFwV2S+MqzzRSKT1
MIME-Version: 1.0
X-Received: by 2002:a02:1007:: with SMTP id 7mr39330981jay.73.1608027851046;
 Tue, 15 Dec 2020 02:24:11 -0800 (PST)
Date:   Tue, 15 Dec 2020 02:24:11 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000d9c89b05b67e2803@google.com>
Subject: WARNING: suspicious RCU usage in nf_ct_iterate_cleanup
From:   syzbot <syzbot+dced7c2d89dde957f7dd@syzkaller.appspotmail.com>
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

HEAD commit:    33dc9614 Merge tag 'ktest-v5.10-rc6' of git://git.kernel.o..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1200a46b500000
kernel config:  https://syzkaller.appspot.com/x/.config?x=5ed9af1b47477866
dashboard link: https://syzkaller.appspot.com/bug?extid=dced7c2d89dde957f7dd
compiler:       gcc (GCC) 10.1.0-syz 20200507

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+dced7c2d89dde957f7dd@syzkaller.appspotmail.com

=============================
WARNING: suspicious RCU usage
5.10.0-rc7-syzkaller #0 Not tainted
-----------------------------
kernel/sched/core.c:7270 Illegal context switch in RCU-bh read-side critical section!

other info that might help us debug this:


rcu_scheduler_active = 2, debug_locks = 0
2 locks held by kworker/1:8/18355:
 #0: ffff888010063d38 ((wq_completion)events){+.+.}-{0:0}, at: arch_atomic64_set arch/x86/include/asm/atomic64_64.h:34 [inline]
 #0: ffff888010063d38 ((wq_completion)events){+.+.}-{0:0}, at: atomic64_set include/asm-generic/atomic-instrumented.h:856 [inline]
 #0: ffff888010063d38 ((wq_completion)events){+.+.}-{0:0}, at: atomic_long_set include/asm-generic/atomic-long.h:41 [inline]
 #0: ffff888010063d38 ((wq_completion)events){+.+.}-{0:0}, at: set_work_data kernel/workqueue.c:616 [inline]
 #0: ffff888010063d38 ((wq_completion)events){+.+.}-{0:0}, at: set_work_pool_and_clear_pending kernel/workqueue.c:643 [inline]
 #0: ffff888010063d38 ((wq_completion)events){+.+.}-{0:0}, at: process_one_work+0x821/0x15a0 kernel/workqueue.c:2243
 #1: ffffc90002a6fda8 ((work_completion)(&w->work)#2){+.+.}-{0:0}, at: process_one_work+0x854/0x15a0 kernel/workqueue.c:2247

stack backtrace:
CPU: 1 PID: 18355 Comm: kworker/1:8 Not tainted 5.10.0-rc7-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: events iterate_cleanup_work
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x107/0x163 lib/dump_stack.c:118
 ___might_sleep+0x220/0x2b0 kernel/sched/core.c:7270
 get_next_corpse net/netfilter/nf_conntrack_core.c:2222 [inline]
 nf_ct_iterate_cleanup+0x132/0x400 net/netfilter/nf_conntrack_core.c:2244
 nf_ct_iterate_cleanup_net net/netfilter/nf_conntrack_core.c:2329 [inline]
 nf_ct_iterate_cleanup_net+0x113/0x170 net/netfilter/nf_conntrack_core.c:2314
 iterate_cleanup_work+0x45/0x130 net/netfilter/nf_nat_masquerade.c:216
 process_one_work+0x933/0x15a0 kernel/workqueue.c:2272
 worker_thread+0x64c/0x1120 kernel/workqueue.c:2418
 kthread+0x3b1/0x4a0 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:296


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
