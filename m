Return-Path: <SRS0=vjpg=BV=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=BAYES_00,FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDB28C433E0
	for <netfilter-devel@archiver.kernel.org>; Tue, 11 Aug 2020 17:07:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9BC342076B
	for <netfilter-devel@archiver.kernel.org>; Tue, 11 Aug 2020 17:07:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728970AbgHKRHV (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 11 Aug 2020 13:07:21 -0400
Received: from mail-il1-f197.google.com ([209.85.166.197]:33773 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729046AbgHKRHP (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 11 Aug 2020 13:07:15 -0400
Received: by mail-il1-f197.google.com with SMTP id m9so11086475ili.0
        for <netfilter-devel@vger.kernel.org>; Tue, 11 Aug 2020 10:07:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=tTCIDG0AiF6unYAgKKJgpZv2a64bzMEnVSBadd7xH6E=;
        b=Hki2CBYSgocHPyWSnpHhcegtJ2/sWLZMPWSUC3wXjXenpf1WDPYtqJ7mQ0+JomcH5K
         C8cm6PNjDbs0K1duqf4kXdS43W+idVEZ8dNzB5T3tyOtnfyakAMHPg6+cQU9j5sxlwx0
         hoVn8fbzbgr8oSSSkJobe/buQG4XPQsuAMebd/ptCTjXmxi3PpDIM8ormG02tJ+wI31d
         J3euyymZjb6iFusmBfP4oEiqiE+FlwquYmraaQA2iUyAQPeUu/i5vnSThagaqp6DO0AC
         Gu1lSzCh8s1XqASHnIvaKTOYvoc23hYlVyoK58BRneQH+aI9w2FFLQdTD/9F4+dgGMlI
         F6LA==
X-Gm-Message-State: AOAM531NNa7/vHivzP8B9siPq69eYBAxDWHENHlKOPWWYkUqqoeiB1H5
        u2TZymfyfP8q8qiGqWrRB6KkrjdhN9DyrrcquAar/Oj+ilPH
X-Google-Smtp-Source: ABdhPJx7Vx1z7scE2ykU5jH6nuSd2PdvkivGiBLvX8VgbucyGqMmUlqDCX4ftVLuZof7Hs3H7j+mXHhv31UjjwaAFX3QDRKNF/uI
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:dcc:: with SMTP id l12mr22902511ilj.282.1597165634112;
 Tue, 11 Aug 2020 10:07:14 -0700 (PDT)
Date:   Tue, 11 Aug 2020 10:07:14 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000044d3c705ac9d1a39@google.com>
Subject: memory leak in nf_tables_addchain
From:   syzbot <syzbot+c99868fde67014f7e9f5@syzkaller.appspotmail.com>
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

syzbot found the following issue on:

HEAD commit:    449dc8c9 Merge tag 'for-v5.9' of git://git.kernel.org/pub/..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=14f87006900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=4810fa4a53b3aa2c
dashboard link: https://syzkaller.appspot.com/bug?extid=c99868fde67014f7e9f5
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17fbf6e6900000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12781652900000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+c99868fde67014f7e9f5@syzkaller.appspotmail.com

executing program
BUG: memory leak
unreferenced object 0xffff888119189f80 (size 128):
  comm "syz-executor071", pid 6469, jiffies 4294944001 (age 12.440s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    90 9f 18 19 81 88 ff ff 90 9f 18 19 81 88 ff ff  ................
  backtrace:
    [<0000000004286457>] kmalloc include/linux/slab.h:554 [inline]
    [<0000000004286457>] kzalloc include/linux/slab.h:666 [inline]
    [<0000000004286457>] nf_tables_addchain.constprop.0+0x414/0x720 net/netfilter/nf_tables_api.c:2006
    [<0000000064582dc8>] nf_tables_newchain+0x74c/0x9d0 net/netfilter/nf_tables_api.c:2316
    [<000000009af54f85>] nfnetlink_rcv_batch+0x2fb/0x9e0 net/netfilter/nfnetlink.c:434
    [<000000000edcf8ff>] nfnetlink_rcv_skb_batch net/netfilter/nfnetlink.c:544 [inline]
    [<000000000edcf8ff>] nfnetlink_rcv+0x182/0x1b0 net/netfilter/nfnetlink.c:562
    [<00000000d8cb87ba>] netlink_unicast_kernel net/netlink/af_netlink.c:1304 [inline]
    [<00000000d8cb87ba>] netlink_unicast+0x2b6/0x3c0 net/netlink/af_netlink.c:1330
    [<00000000e133d3d8>] netlink_sendmsg+0x2ba/0x570 net/netlink/af_netlink.c:1919
    [<000000003f4dae42>] sock_sendmsg_nosec net/socket.c:651 [inline]
    [<000000003f4dae42>] sock_sendmsg+0x4c/0x60 net/socket.c:671
    [<00000000a38aa29c>] ____sys_sendmsg+0x2c4/0x2f0 net/socket.c:2359
    [<00000000a06b2c98>] ___sys_sendmsg+0x81/0xc0 net/socket.c:2413
    [<00000000b3d1da45>] __sys_sendmsg+0x77/0xe0 net/socket.c:2446
    [<00000000e1124972>] do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
    [<00000000f18a8a31>] entry_SYSCALL_64_after_hwframe+0x44/0xa9



---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
