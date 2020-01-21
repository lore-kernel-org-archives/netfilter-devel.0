Return-Path: <SRS0=AyPt=3K=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3224C33CAA
	for <netfilter-devel@archiver.kernel.org>; Tue, 21 Jan 2020 19:57:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A2842217F4
	for <netfilter-devel@archiver.kernel.org>; Tue, 21 Jan 2020 19:57:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728855AbgAUT5K (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 21 Jan 2020 14:57:10 -0500
Received: from mail-io1-f72.google.com ([209.85.166.72]:46252 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727360AbgAUT5K (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 21 Jan 2020 14:57:10 -0500
Received: by mail-io1-f72.google.com with SMTP id p206so2466419iod.13
        for <netfilter-devel@vger.kernel.org>; Tue, 21 Jan 2020 11:57:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=Na+0RlDjz+USmrX/lnYIn3IXaqN3eGHx5d+CcmxDSfw=;
        b=i+N0U5AHt1vyeQlKewwsl6XEUbM9irWW2R9wVisEsXiS3rYE8u7wHTbcBzEhB3jqnt
         Mu2/lk9TOUhcsXEiVwHXZEFKGzGw4yOKYTDslMWaFzOotiKX11Sc6yTBXouGCW9xG/VG
         WIO4Uo6fevvTRWUpv/tDZLScyN1RjWzKir9IuwPMCGXIL49HHlyeHSF61BLptag+KJnU
         QofVC+coMyr5iDJF5HRdMpC2FoujzyLThRCG27oVNyZz/50D5VMx5KUDjcBEIG++BxLO
         pnLjZGFzh2ch6zXckoWdDfAqc2puP0rBhUjnHDQSZ4sCg1nIyWDFBiVPdwpiumurx9Va
         6Wkg==
X-Gm-Message-State: APjAAAWE9QXvcrzSzvGEHYrGB6aZbM7TMZwxYuLNodadKc9UVd3y4Afn
        u8Xo6B8J57zFuIBIrxIRZhJjrmQxYvyzmyDtNxhvsuoOfvpQ
X-Google-Smtp-Source: APXvYqzHKTdCXBMX0jBeRbPRbRY+ALjXzg9J04Y3NuOJkVKKtwwqCljRZoKvKqYX8YYEt2H5NhdCDSddo87YSau6iPRhLSxkrtrX
MIME-Version: 1.0
X-Received: by 2002:a5e:8813:: with SMTP id l19mr4458172ioj.261.1579636629982;
 Tue, 21 Jan 2020 11:57:09 -0800 (PST)
Date:   Tue, 21 Jan 2020 11:57:09 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000346dcd059cabd0b5@google.com>
Subject: WARNING: suspicious RCU usage in find_set_and_id
From:   syzbot <syzbot+fc69d7cb21258ab4ae4d@syzkaller.appspotmail.com>
To:     coreteam@netfilter.org, davem@davemloft.net,
        florent.fourcot@wifirst.fr, fw@strlen.de, jeremy@azazel.net,
        johannes.berg@intel.com, kadlec@netfilter.org,
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

HEAD commit:    ab7541c3 Merge tag 'fuse-fixes-5.5-rc7' of git://git.kerne..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=154ca959e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=cfbb8fa33f49f9f3
dashboard link: https://syzkaller.appspot.com/bug?extid=fc69d7cb21258ab4ae4d
compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12dcb0d6e00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+fc69d7cb21258ab4ae4d@syzkaller.appspotmail.com

=============================
WARNING: suspicious RCU usage
5.5.0-rc6-syzkaller #0 Not tainted
-----------------------------
net/netfilter/ipset/ip_set_core.c:1001 suspicious rcu_dereference_protected() usage!

other info that might help us debug this:


rcu_scheduler_active = 2, debug_locks = 1
1 lock held by syz-executor.0/8783:
 #0: ffff8880a681c5d8 (nlk_cb_mutex-NETFILTER){+.+.}, at: netlink_dump+0x75/0x1170 net/netlink/af_netlink.c:2199

stack backtrace:
CPU: 1 PID: 8783 Comm: syz-executor.0 Not tainted 5.5.0-rc6-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x1fb/0x318 lib/dump_stack.c:118
 lockdep_rcu_suspicious+0x156/0x1c0 kernel/locking/lockdep.c:5435
 find_set_and_id+0x140/0x2f0 net/netfilter/ipset/ip_set_core.c:1001
 dump_init net/netfilter/ipset/ip_set_core.c:1506 [inline]
 ip_set_dump_start+0x7c5/0x1800 net/netfilter/ipset/ip_set_core.c:1541
 netlink_dump+0x4ed/0x1170 net/netlink/af_netlink.c:2244
 netlink_recvmsg+0x659/0xfb0 net/netlink/af_netlink.c:2000
 sock_recvmsg_nosec net/socket.c:873 [inline]
 sock_recvmsg net/socket.c:891 [inline]
 __sys_recvfrom+0x328/0x4b0 net/socket.c:2042
 __do_sys_recvfrom net/socket.c:2060 [inline]
 __se_sys_recvfrom net/socket.c:2056 [inline]
 __x64_sys_recvfrom+0xe5/0x100 net/socket.c:2056
 do_syscall_64+0xf7/0x1c0 arch/x86/entry/common.c:294
 entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x45aff9
Code: ad b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 7b b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007fc45d1a6c78 EFLAGS: 00000246 ORIG_RAX: 000000000000002d
RAX: ffffffffffffffda RBX: 00007fc45d1a76d4 RCX: 000000000045aff9
RDX: 36ff0824c68970de RSI: 0000000000000000 RDI: 0000000000000003
RBP: 000000000075bf20 R08: 0000000000000000 R09: 0000000000000226
R10: 0000000000000000 R11: 0000000000000246 R12: 00000000ffffffff
R13: 000000000000085c R14: 00000000004c9852 R15: 000000000075bf2c


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
