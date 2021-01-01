Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07A43C433E6
	for <netfilter-devel@archiver.kernel.org>; Fri,  1 Jan 2021 00:50:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BEC662222D
	for <netfilter-devel@archiver.kernel.org>; Fri,  1 Jan 2021 00:50:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726707AbhAAAtx (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 31 Dec 2020 19:49:53 -0500
Received: from mail-il1-f197.google.com ([209.85.166.197]:46557 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726314AbhAAAtx (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 31 Dec 2020 19:49:53 -0500
Received: by mail-il1-f197.google.com with SMTP id x14so18873488ilg.13
        for <netfilter-devel@vger.kernel.org>; Thu, 31 Dec 2020 16:49:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=f4jpcmyenKqYfST2LyQr30I+nGdhfXpwOSlfzY/gMRg=;
        b=D8MDje3UiP9/oZxcQosaZu4IpfDdm1ugCr6xDP3CTlcTkvcG/k6hDCRDZfQSVD9d8F
         yqmvowcTUWg3+1UP6JSNDmTrbGpggAqAFUsOmcsTkNL2RljNmrenLTRyjc5v75XrsRy3
         ByWqROMPa7SkD5Ig0X7b166ZodRoiq48Fc154dA+0dgvZYQlgg98TvOZABt0WVQJ5Xzz
         j2uPOUwTfbOV5yw4JmJX77sghyipyZQofZUBe2Kwm8cwJd609AW0Z9x82zckUwfxS7oY
         +86hwtJFJYxGyKDrocU78etQZA+FKGlYJ0om70qJRkFERKJ44MDLRE4pav/t+QuP4egs
         rTBw==
X-Gm-Message-State: AOAM532njyDOIMnVHgjt/D0mtabkP70rdGdEGjgx/aXbABWJI/qG2zdd
        KfZ2vaE/ubLaiAe/Vv2d6zCGZXie+R9KpCcb+d/8iQp/APd+
X-Google-Smtp-Source: ABdhPJz5xy4u3Ybd++5GdqLQDigch4VAvgPEqKu2JTiKDWpaq0dnJo0DnSWd61C0FPgiaKY1aFv6nXGlpQzz7SzLD8LwnGBb8WKf
MIME-Version: 1.0
X-Received: by 2002:a92:58dc:: with SMTP id z89mr58050886ilf.11.1609462151899;
 Thu, 31 Dec 2020 16:49:11 -0800 (PST)
Date:   Thu, 31 Dec 2020 16:49:11 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000d7f02105b7cc1b99@google.com>
Subject: WARNING: suspicious RCU usage in xt_obj_to_user
From:   syzbot <syzbot+00399fa030c641ffc5ae@syzkaller.appspotmail.com>
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

HEAD commit:    f838f8d2 mfd: ab8500-debugfs: Remove extraneous seq_putc
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=17074c47500000
kernel config:  https://syzkaller.appspot.com/x/.config?x=7a43a64bad3fdb39
dashboard link: https://syzkaller.appspot.com/bug?extid=00399fa030c641ffc5ae
compiler:       gcc (GCC) 10.1.0-syz 20200507

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+00399fa030c641ffc5ae@syzkaller.appspotmail.com

=============================
WARNING: suspicious RCU usage
5.10.0-syzkaller #0 Not tainted
-----------------------------
kernel/sched/core.c:7877 Illegal context switch in RCU-bh read-side critical section!

other info that might help us debug this:


rcu_scheduler_active = 2, debug_locks = 0
1 lock held by syz-executor.0/9704:
 #0: ffff888013794458 (&xt[i].mutex){+.+.}-{3:3}, at: xt_find_table_lock+0x41/0x540 net/netfilter/x_tables.c:1206

stack backtrace:
CPU: 0 PID: 9704 Comm: syz-executor.0 Not tainted 5.10.0-syzkaller #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.12.0-59-gc9ba5276e321-prebuilt.qemu.org 04/01/2014
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x107/0x163 lib/dump_stack.c:120
 ___might_sleep+0x229/0x2c0 kernel/sched/core.c:7877
 __might_fault+0x6e/0x180 mm/memory.c:5014
 xt_obj_to_user+0x31/0x110 net/netfilter/x_tables.c:277
 xt_target_to_user+0xa8/0x200 net/netfilter/x_tables.c:323
 copy_entries_to_user net/ipv4/netfilter/arp_tables.c:705 [inline]
 get_entries net/ipv4/netfilter/arp_tables.c:866 [inline]
 do_arpt_get_ctl+0x733/0x8f0 net/ipv4/netfilter/arp_tables.c:1450
 nf_getsockopt+0x72/0xd0 net/netfilter/nf_sockopt.c:116
 ip_getsockopt net/ipv4/ip_sockglue.c:1777 [inline]
 ip_getsockopt+0x164/0x1c0 net/ipv4/ip_sockglue.c:1756
 tcp_getsockopt+0x86/0xd0 net/ipv4/tcp.c:4141
 __sys_getsockopt+0x219/0x4c0 net/socket.c:2156
 __do_sys_getsockopt net/socket.c:2171 [inline]
 __se_sys_getsockopt net/socket.c:2168 [inline]
 __x64_sys_getsockopt+0xba/0x150 net/socket.c:2168
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x45ef5a
Code: b8 34 01 00 00 0f 05 48 3d 01 f0 ff ff 0f 83 cd 9f fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 49 89 ca b8 37 00 00 00 0f 05 <48> 3d 01 f0 ff ff 0f 83 aa 9f fb ff c3 66 0f 1f 84 00 00 00 00 00
RSP: 002b:00007ffcf91ed728 EFLAGS: 00000212 ORIG_RAX: 0000000000000037
RAX: ffffffffffffffda RBX: 00007ffcf91ed790 RCX: 000000000045ef5a
RDX: 0000000000000061 RSI: 0000000000000000 RDI: 0000000000000003
RBP: 0000000000000003 R08: 00007ffcf91ed73c R09: 000000000000000a
R10: 00007ffcf91ed790 R11: 0000000000000212 R12: 00007ffcf91ed73c
R13: 0000000000000000 R14: 0000000000000032 R15: 000000000003354d


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
