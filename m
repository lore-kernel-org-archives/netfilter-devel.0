Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF9F5C5519F
	for <netfilter-devel@archiver.kernel.org>; Sun, 29 Nov 2020 10:59:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8ADA220771
	for <netfilter-devel@archiver.kernel.org>; Sun, 29 Nov 2020 10:59:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725984AbgK2K7H (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 29 Nov 2020 05:59:07 -0500
Received: from mail-io1-f69.google.com ([209.85.166.69]:49278 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725867AbgK2K7E (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 29 Nov 2020 05:59:04 -0500
Received: by mail-io1-f69.google.com with SMTP id v15so5481573ioq.16
        for <netfilter-devel@vger.kernel.org>; Sun, 29 Nov 2020 02:58:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=+hSyrMmE7Jd1LFQtWNmFHjej4ynpvSMXHSpcTqGIDIU=;
        b=hjIGqwaeEsnTY+/7B1wt+Kjl+QNW8tH4/BtBMyk5txto/iqMttW6wzX1AIBtjODEXy
         m3UFQzXzJv00FE37CxXWIP3blrDMZvsu3xO+2l7vC1Sfi+TpwQb34ulzJqftcyPtRpYJ
         V2aqEcuZzvj48SP4SFyMYcWFoQV7IEs8ZDkjmv+C3iMpKjSSp1r3RYJm/xRM3CVhaV5A
         BQ5hb4GceUE4OE+zA0bf8O6nvOQ2o6LzScK+prouQ+qRQqvFcTOon1/U2GR77+cLP4fC
         sLEpHd+PepLzEgN1NbOig3rUWkzXn8wCKLAxfb1LNVVMlEPrntkqK6VgaPdmjHAHQXN7
         P8wA==
X-Gm-Message-State: AOAM531dbwWfSyoRg2B/vPXckXVs1W41K69U9Iv46UBWdgg9EfAgQXH3
        XsmTtMus2RLwDF52QD0Xk9q/GMekFKKQzUKeI80jGqaYk3t6
X-Google-Smtp-Source: ABdhPJym2twyN3aJwoCGatFXC/ngKVVfc9dejgWUWmP75kZNzy85oqPEgVWX8GTcjTWzwrpaQYcCt0zR0lr3Izg3RP/p8ellEjPj
MIME-Version: 1.0
X-Received: by 2002:a6b:ef11:: with SMTP id k17mr12098422ioh.210.1606647503166;
 Sun, 29 Nov 2020 02:58:23 -0800 (PST)
Date:   Sun, 29 Nov 2020 02:58:23 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000b4a2c005b53cc5f2@google.com>
Subject: WARNING: suspicious RCU usage in get_counters
From:   syzbot <syzbot+5cfc290df4bbf069bc65@syzkaller.appspotmail.com>
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

HEAD commit:    127c501a Merge tag '5.10-rc5-smb3-fixes' of git://git.samb..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=17f4912d500000
kernel config:  https://syzkaller.appspot.com/x/.config?x=6d1e98d0b97781e4
dashboard link: https://syzkaller.appspot.com/bug?extid=5cfc290df4bbf069bc65
compiler:       gcc (GCC) 10.1.0-syz 20200507

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+5cfc290df4bbf069bc65@syzkaller.appspotmail.com

=============================
WARNING: suspicious RCU usage
5.10.0-rc5-syzkaller #0 Not tainted
-----------------------------
kernel/sched/core.c:7270 Illegal context switch in RCU-sched read-side critical section!

other info that might help us debug this:


rcu_scheduler_active = 2, debug_locks = 0
1 lock held by syz-executor.3/10331:
 #0: ffff8880459f8308 (&xt[i].mutex){+.+.}-{3:3}, at: xt_find_table_lock+0x41/0x540 net/netfilter/x_tables.c:1206

stack backtrace:
CPU: 3 PID: 10331 Comm: syz-executor.3 Not tainted 5.10.0-rc5-syzkaller #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.12.0-59-gc9ba5276e321-prebuilt.qemu.org 04/01/2014
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x107/0x163 lib/dump_stack.c:118
 ___might_sleep+0x25d/0x2b0 kernel/sched/core.c:7270
 get_counters+0x2f5/0x520 net/ipv4/netfilter/ip_tables.c:765
 do_ipt_get_ctl+0x634/0x9d0 net/ipv4/netfilter/ip_tables.c:805
 nf_getsockopt+0x72/0xd0 net/netfilter/nf_sockopt.c:116
 ip_getsockopt net/ipv4/ip_sockglue.c:1777 [inline]
 ip_getsockopt+0x164/0x1c0 net/ipv4/ip_sockglue.c:1756
 tcp_getsockopt+0x86/0xd0 net/ipv4/tcp.c:3882
 __sys_getsockopt+0x219/0x4c0 net/socket.c:2173
 __do_sys_getsockopt net/socket.c:2188 [inline]
 __se_sys_getsockopt net/socket.c:2185 [inline]
 __x64_sys_getsockopt+0xba/0x150 net/socket.c:2185
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x45ec3a
Code: b8 34 01 00 00 0f 05 48 3d 01 f0 ff ff 0f 83 cd 9f fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 49 89 ca b8 37 00 00 00 0f 05 <48> 3d 01 f0 ff ff 0f 83 aa 9f fb ff c3 66 0f 1f 84 00 00 00 00 00
RSP: 002b:00007ffccbec9f78 EFLAGS: 00000212 ORIG_RAX: 0000000000000037
RAX: ffffffffffffffda RBX: 00007ffccbec9fb0 RCX: 000000000045ec3a
RDX: 0000000000000041 RSI: 0000000000000000 RDI: 0000000000000003
RBP: 0000000000734000 R08: 00007ffccbec9fac R09: 0000000000004000
R10: 00007ffccbeca010 R11: 0000000000000212 R12: 00007ffccbeca010
R13: 0000000000000003 R14: 0000000000732bc0 R15: 0000000000000000


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
