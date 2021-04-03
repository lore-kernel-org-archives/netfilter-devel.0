Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C281DC43461
	for <netfilter-devel@archiver.kernel.org>; Sat,  3 Apr 2021 02:22:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6684D611CC
	for <netfilter-devel@archiver.kernel.org>; Sat,  3 Apr 2021 02:22:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236077AbhDCCWV (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 2 Apr 2021 22:22:21 -0400
Received: from mail-il1-f200.google.com ([209.85.166.200]:56398 "EHLO
        mail-il1-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236035AbhDCCWU (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 2 Apr 2021 22:22:20 -0400
Received: by mail-il1-f200.google.com with SMTP id v7so6813616ilh.23
        for <netfilter-devel@vger.kernel.org>; Fri, 02 Apr 2021 19:22:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=yojHr0LL9tcz8C/ih+uZXwDOxxsE8tJwilH+vxkwGEU=;
        b=MtjC8VtYupMcTQ2vpnsLnwUJHdrpU55o3cK9jwI7nVtbylkFyQvuZv+9GgWVtG48Ap
         xqJfJ3n0DGgEndUWS59BRbX/iGrQh9uVMxyocqXAs7/Kq9fKLBIPJNupnto5AOvxnuOO
         qFVFijJqtZd3XQnq/iVd27NoU/I1dQ952z22rZP0FdrfuxbZCWyqRZ688QFSlAtvkyvo
         aKER6ZyXcXfcMfnD1hc3uF5o7kZI2w6G/g9/+dsyAFtCsw3NaNe57G2RGLANCELFd/IO
         RWoW5LfH92ubgXLHvuUYcoFr1uXlnrwNuClUUit4gbEEJEAwAe16RJbB7z/pZfAkWMAk
         dOpA==
X-Gm-Message-State: AOAM532NJmvahF7UYV/3gP91Cl83PVm3LLn2na2gb2ErG0KqFT/ZeaIQ
        L7o8+ijeaKk73hgF7v5n0k0rQK+MUqw0RhUQz2dFnzQI+ebP
X-Google-Smtp-Source: ABdhPJyBAx5lpsWCs2cfBehnz27AczKqw16RcM1me3OBSZwRId03i5qPHagW0vP7xRMo5UKXyafMcKO0ycDaUet4TolL/MQdcZaA
MIME-Version: 1.0
X-Received: by 2002:a5d:9917:: with SMTP id x23mr12821675iol.22.1617416537245;
 Fri, 02 Apr 2021 19:22:17 -0700 (PDT)
Date:   Fri, 02 Apr 2021 19:22:17 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000028104905bf0822ce@google.com>
Subject: [syzbot] WARNING: suspicious RCU usage in find_inlist_lock
From:   syzbot <syzbot+b221933e5f9ad5b0e2fd@syzkaller.appspotmail.com>
To:     bridge@lists.linux-foundation.org, coreteam@netfilter.org,
        davem@davemloft.net, fw@strlen.de, kadlec@netfilter.org,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        nikolay@nvidia.com, pablo@netfilter.org, roopa@nvidia.com,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    1e43c377 Merge tag 'xtensa-20210329' of git://github.com/j..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=114cdd4ad00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=78ef1d159159890
dashboard link: https://syzkaller.appspot.com/bug?extid=b221933e5f9ad5b0e2fd

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+b221933e5f9ad5b0e2fd@syzkaller.appspotmail.com

=============================
WARNING: suspicious RCU usage
5.12.0-rc5-syzkaller #0 Not tainted
-----------------------------
kernel/sched/core.c:8294 Illegal context switch in RCU-sched read-side critical section!

other info that might help us debug this:


rcu_scheduler_active = 2, debug_locks = 0
no locks held by syz-executor.1/8425.

stack backtrace:
CPU: 1 PID: 8425 Comm: syz-executor.1 Not tainted 5.12.0-rc5-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x141/0x1d7 lib/dump_stack.c:120
 ___might_sleep+0x266/0x2c0 kernel/sched/core.c:8294
 __mutex_lock_common kernel/locking/mutex.c:928 [inline]
 __mutex_lock+0xa9/0x1120 kernel/locking/mutex.c:1096
 find_inlist_lock_noload net/bridge/netfilter/ebtables.c:316 [inline]
 find_inlist_lock.constprop.0+0x26/0x220 net/bridge/netfilter/ebtables.c:330
 find_table_lock net/bridge/netfilter/ebtables.c:339 [inline]
 do_ebt_get_ctl+0x208/0x790 net/bridge/netfilter/ebtables.c:2329
 nf_getsockopt+0x72/0xd0 net/netfilter/nf_sockopt.c:116
 ip_getsockopt net/ipv4/ip_sockglue.c:1777 [inline]
 ip_getsockopt+0x164/0x1c0 net/ipv4/ip_sockglue.c:1756
 tcp_getsockopt+0x86/0xd0 net/ipv4/tcp.c:4239
 __sys_getsockopt+0x21f/0x5f0 net/socket.c:2161
 __do_sys_getsockopt net/socket.c:2176 [inline]
 __se_sys_getsockopt net/socket.c:2173 [inline]
 __x64_sys_getsockopt+0xba/0x150 net/socket.c:2173
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x467a6a
Code: 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 49 89 ca b8 37 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffe660d82f8 EFLAGS: 00000202 ORIG_RAX: 0000000000000037
RAX: ffffffffffffffda RBX: 00000000005401a0 RCX: 0000000000467a6a
RDX: 0000000000000081 RSI: 0000000000000000 RDI: 0000000000000003
RBP: 0000000000000000 R08: 00007ffe660d831c R09: 00007ffe660d83a0
R10: 00007ffe660d8320 R11: 0000000000000202 R12: 0000000000000003
R13: 00007ffe660d8320 R14: 0000000000540128 R15: 00007ffe660d831c


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
