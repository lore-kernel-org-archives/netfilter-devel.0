Return-Path: <SRS0=M6WU=7W=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2721DC433DF
	for <netfilter-devel@archiver.kernel.org>; Tue,  9 Jun 2020 21:58:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0970B20737
	for <netfilter-devel@archiver.kernel.org>; Tue,  9 Jun 2020 21:58:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728348AbgFIV6Z (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 9 Jun 2020 17:58:25 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:48578 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728146AbgFIV6N (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 9 Jun 2020 17:58:13 -0400
Received: by mail-io1-f71.google.com with SMTP id z12so183925iow.15
        for <netfilter-devel@vger.kernel.org>; Tue, 09 Jun 2020 14:58:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=pw0UgTHVe4ORi9w9G47RxZH+2R3g4C+RyCbV9ziJVuQ=;
        b=NGha2cwbwXA74J6uJN0/HAtOLzqJ/jEy0Lq0GbwHla4QCkuN9UZJ/bvsLxL4R0mN8g
         rQm0nus1IZv7MGtyxapIJuXXocrhSjq1bCQAWLi31B8FaJuyNzz+WE6AZm/vbj8Cp95v
         YGUTR3UBHfHdMFTMyQohdxwVeykbHqKEsKMKQxoNV8SKaQb/6HCnErE/0M2UDx68mt18
         /J2cK22mjeEaZbqhTEsGy99A+DrMx+5APXflthKpXLQhay3hdGM1C/xLIdMEeUQwVhHl
         WNx97keao/uTi4aY01uFeJabavj1bg3E0mt13lVZQd0HeW02CHGqau7sfDVrYmquQBBJ
         +rYg==
X-Gm-Message-State: AOAM532lKYIk9EZK3RrONDv166xTGnZBMlUdGGfJtpNUH+yx9WYv41yD
        u0KFZFuKlrXz4NSDxVkhwCHoW7E1iWUab4vwP6q+1MS5mepR
X-Google-Smtp-Source: ABdhPJzLGtUrYFSaKZsCsFiJTeD8F6gQ2x4xdGfJQRk1G0TMrdZjwyUwp8nP0wCHl1E4+iAeiQQ3NndOOrF/LrO47sXaQuRjGCp1
MIME-Version: 1.0
X-Received: by 2002:a05:6602:1616:: with SMTP id x22mr229920iow.70.1591739892592;
 Tue, 09 Jun 2020 14:58:12 -0700 (PDT)
Date:   Tue, 09 Jun 2020 14:58:12 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000df74f605a7add28b@google.com>
Subject: memory leak in ctnetlink_start
From:   syzbot <syzbot+b005af2cfb0411e617de@syzkaller.appspotmail.com>
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

HEAD commit:    7ae77150 Merge tag 'powerpc-5.8-1' of git://git.kernel.org..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=128a9df2100000
kernel config:  https://syzkaller.appspot.com/x/.config?x=9a1aa05456dfd557
dashboard link: https://syzkaller.appspot.com/bug?extid=b005af2cfb0411e617de
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17304a96100000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=168a9df2100000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+b005af2cfb0411e617de@syzkaller.appspotmail.com

executing program
executing program
executing program
BUG: memory leak
unreferenced object 0xffff88811c797900 (size 128):
  comm "syz-executor256", pid 6458, jiffies 4294947022 (age 13.050s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<000000004276332a>] kmalloc include/linux/slab.h:555 [inline]
    [<000000004276332a>] kzalloc include/linux/slab.h:669 [inline]
    [<000000004276332a>] ctnetlink_alloc_filter+0x3a/0x2a0 net/netfilter/nf_conntrack_netlink.c:924
    [<000000000047e6fb>] ctnetlink_start+0x3a/0x80 net/netfilter/nf_conntrack_netlink.c:998
    [<00000000a431a924>] __netlink_dump_start+0x1a3/0x2e0 net/netlink/af_netlink.c:2343
    [<0000000016b073fa>] netlink_dump_start include/linux/netlink.h:246 [inline]
    [<0000000016b073fa>] ctnetlink_get_conntrack+0x26d/0x2f0 net/netfilter/nf_conntrack_netlink.c:1611
    [<00000000d311138b>] nfnetlink_rcv_msg+0x32f/0x370 net/netfilter/nfnetlink.c:229
    [<0000000008feca87>] netlink_rcv_skb+0x5a/0x180 net/netlink/af_netlink.c:2469
    [<0000000088caad78>] nfnetlink_rcv+0x83/0x1b0 net/netfilter/nfnetlink.c:563
    [<0000000052160488>] netlink_unicast_kernel net/netlink/af_netlink.c:1303 [inline]
    [<0000000052160488>] netlink_unicast+0x20a/0x2f0 net/netlink/af_netlink.c:1329
    [<00000000ee36d991>] netlink_sendmsg+0x2b5/0x560 net/netlink/af_netlink.c:1918
    [<00000000dee2cafe>] sock_sendmsg_nosec net/socket.c:652 [inline]
    [<00000000dee2cafe>] sock_sendmsg+0x4c/0x60 net/socket.c:672
    [<00000000b0b655cb>] ____sys_sendmsg+0x2c4/0x2f0 net/socket.c:2352
    [<000000005bba2f8d>] ___sys_sendmsg+0x8a/0xd0 net/socket.c:2406
    [<0000000060ac6563>] __sys_sendmsg+0x77/0xe0 net/socket.c:2439
    [<000000002f7b34b0>] do_syscall_64+0x6e/0x220 arch/x86/entry/common.c:295
    [<00000000941009bb>] entry_SYSCALL_64_after_hwframe+0x44/0xa9



---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
