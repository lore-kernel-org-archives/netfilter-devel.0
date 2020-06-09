Return-Path: <SRS0=M6WU=7W=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 809B3C433E0
	for <netfilter-devel@archiver.kernel.org>; Tue,  9 Jun 2020 21:58:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5D8C820737
	for <netfilter-devel@archiver.kernel.org>; Tue,  9 Jun 2020 21:58:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728310AbgFIV6Y (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 9 Jun 2020 17:58:24 -0400
Received: from mail-io1-f70.google.com ([209.85.166.70]:52770 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728163AbgFIV6O (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 9 Jun 2020 17:58:14 -0400
Received: by mail-io1-f70.google.com with SMTP id p8so177223ios.19
        for <netfilter-devel@vger.kernel.org>; Tue, 09 Jun 2020 14:58:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=1mhEZ1q7Z91Rb4K4pPl+Kl2FQ4G6nw8z/eiDSC/Zszk=;
        b=ewaPUA3SI8q/59BNEslkRYcMcLEQ5y/6OYBkyHZk73ptFHwwCRYaMC6rh9GCJTbWY3
         0o0yl3+y8y/4wuaj6Q09jIERaZ0gMsmmLxoaHQqTM4aMltXxT8CWG69R65AZY353Yygp
         ZeE2kiHwm5T8jxnQRelUm67Lf2Rn4MgB1b0Rqc92m1TfllBv15jg63RgrUuHtpIIl4vU
         9jGi4Fr8rxFpT+QiYDC7xCwOEct0RWLgGX9zbHjvnzH1ceOH3bscARDXMLvO66Diuy0E
         oI1UhryQVAUFku97YI449EQBvM0lVQMf8JNaCBcnv5rQHSgQtmKE5UmKE9qIuTl5N1RC
         yUBQ==
X-Gm-Message-State: AOAM5321fAC+5jJFU3WY7VYl8UhLePFoNhysls2kFj2Pj2bnZhJPUnW2
        EoSGD6QmSXjqHKwi67MbXfBlXQ2CmBJ7A9SsmKN3dmQaOWK1
X-Google-Smtp-Source: ABdhPJyVTV6l9HIonmvEbRWycVRVy99+9JoQavvsD0FwXdaQ5WzXVA2DaS4Y+g5qg1twFWhInnmvbiSkvNCuY/nPFYIb2hmmR2Ft
MIME-Version: 1.0
X-Received: by 2002:a02:2c6:: with SMTP id 189mr245195jau.115.1591739892143;
 Tue, 09 Jun 2020 14:58:12 -0700 (PDT)
Date:   Tue, 09 Jun 2020 14:58:12 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000d8a0ea05a7add2fd@google.com>
Subject: memory leak in ctnetlink_del_conntrack
From:   syzbot <syzbot+38b8b548a851a01793c5@syzkaller.appspotmail.com>
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
console output: https://syzkaller.appspot.com/x/log.txt?x=10fcd90e100000
kernel config:  https://syzkaller.appspot.com/x/.config?x=9a1aa05456dfd557
dashboard link: https://syzkaller.appspot.com/bug?extid=38b8b548a851a01793c5
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=129c54c1100000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11c0355a100000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+38b8b548a851a01793c5@syzkaller.appspotmail.com

executing program
executing program
executing program
BUG: memory leak
unreferenced object 0xffff88811c505300 (size 128):
  comm "syz-executor470", pid 6431, jiffies 4294945909 (age 13.210s)
  hex dump (first 32 bytes):
    00 00 00 00 02 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<00000000da2809df>] kmalloc include/linux/slab.h:555 [inline]
    [<00000000da2809df>] kzalloc include/linux/slab.h:669 [inline]
    [<00000000da2809df>] ctnetlink_alloc_filter+0x3a/0x2a0 net/netfilter/nf_conntrack_netlink.c:924
    [<00000000745f0fc9>] ctnetlink_flush_conntrack net/netfilter/nf_conntrack_netlink.c:1516 [inline]
    [<00000000745f0fc9>] ctnetlink_del_conntrack+0x20a/0x326 net/netfilter/nf_conntrack_netlink.c:1554
    [<00000000385a38da>] nfnetlink_rcv_msg+0x32f/0x370 net/netfilter/nfnetlink.c:229
    [<00000000bb3b1fc1>] netlink_rcv_skb+0x5a/0x180 net/netlink/af_netlink.c:2469
    [<00000000b2799dbb>] nfnetlink_rcv+0x83/0x1b0 net/netfilter/nfnetlink.c:563
    [<000000006021f56a>] netlink_unicast_kernel net/netlink/af_netlink.c:1303 [inline]
    [<000000006021f56a>] netlink_unicast+0x20a/0x2f0 net/netlink/af_netlink.c:1329
    [<000000003a4cd173>] netlink_sendmsg+0x2b5/0x560 net/netlink/af_netlink.c:1918
    [<00000000ff287393>] sock_sendmsg_nosec net/socket.c:652 [inline]
    [<00000000ff287393>] sock_sendmsg+0x4c/0x60 net/socket.c:672
    [<000000008c32b330>] ____sys_sendmsg+0x2c4/0x2f0 net/socket.c:2352
    [<00000000a8f57b1b>] ___sys_sendmsg+0x8a/0xd0 net/socket.c:2406
    [<000000002c938bcf>] __sys_sendmsg+0x77/0xe0 net/socket.c:2439
    [<00000000878f0bd0>] do_syscall_64+0x6e/0x220 arch/x86/entry/common.c:295
    [<00000000dcd0e014>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff88811ac32a00 (size 128):
  comm "syz-executor470", pid 6432, jiffies 4294946459 (age 7.710s)
  hex dump (first 32 bytes):
    00 00 00 00 02 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<00000000da2809df>] kmalloc include/linux/slab.h:555 [inline]
    [<00000000da2809df>] kzalloc include/linux/slab.h:669 [inline]
    [<00000000da2809df>] ctnetlink_alloc_filter+0x3a/0x2a0 net/netfilter/nf_conntrack_netlink.c:924
    [<00000000745f0fc9>] ctnetlink_flush_conntrack net/netfilter/nf_conntrack_netlink.c:1516 [inline]
    [<00000000745f0fc9>] ctnetlink_del_conntrack+0x20a/0x326 net/netfilter/nf_conntrack_netlink.c:1554
    [<00000000385a38da>] nfnetlink_rcv_msg+0x32f/0x370 net/netfilter/nfnetlink.c:229
    [<00000000bb3b1fc1>] netlink_rcv_skb+0x5a/0x180 net/netlink/af_netlink.c:2469
    [<00000000b2799dbb>] nfnetlink_rcv+0x83/0x1b0 net/netfilter/nfnetlink.c:563
    [<000000006021f56a>] netlink_unicast_kernel net/netlink/af_netlink.c:1303 [inline]
    [<000000006021f56a>] netlink_unicast+0x20a/0x2f0 net/netlink/af_netlink.c:1329
    [<000000003a4cd173>] netlink_sendmsg+0x2b5/0x560 net/netlink/af_netlink.c:1918
    [<00000000ff287393>] sock_sendmsg_nosec net/socket.c:652 [inline]
    [<00000000ff287393>] sock_sendmsg+0x4c/0x60 net/socket.c:672
    [<000000008c32b330>] ____sys_sendmsg+0x2c4/0x2f0 net/socket.c:2352
    [<00000000a8f57b1b>] ___sys_sendmsg+0x8a/0xd0 net/socket.c:2406
    [<000000002c938bcf>] __sys_sendmsg+0x77/0xe0 net/socket.c:2439
    [<00000000878f0bd0>] do_syscall_64+0x6e/0x220 arch/x86/entry/common.c:295
    [<00000000dcd0e014>] entry_SYSCALL_64_after_hwframe+0x44/0xa9



---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
