Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F5E5ECAAD4
	for <netfilter-devel@archiver.kernel.org>; Mon, 29 Aug 2022 23:33:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229601AbiH2Xdn (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 29 Aug 2022 19:33:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229732AbiH2Xde (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 29 Aug 2022 19:33:34 -0400
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08929857E0
        for <netfilter-devel@vger.kernel.org>; Mon, 29 Aug 2022 16:33:33 -0700 (PDT)
Received: by mail-il1-f200.google.com with SMTP id a4-20020a056e0208a400b002e4621942dfso7022621ilt.0
        for <netfilter-devel@vger.kernel.org>; Mon, 29 Aug 2022 16:33:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc;
        bh=pQsvM0lNlMEBpkZs+6Ir9JLbqpOTi5k2pYARw9hKdac=;
        b=XOnAN2juWTgswf9nNx+LX5+4jEQvlGhwNOEPfMLypFJpbuQJfm5LXoy4tYUThJceU4
         ZAUrYvdv3oyEbDeVzCaaRimD1JzbToVDkXGKnsldapCI9czK3NVikgzqFsUnVGSjCcl8
         6OE4TtVulieNwtYvHOZwveY9aFnhEK1vyfh+LhVJ/f9nQYvAysRXXg5WC4PFhl5jPxci
         E406KhVXZXycMGDMUUSwaZ+QEp+tegKd8vzC+IUXCySYEktZSSTPd8zNivGcL/3scuL+
         O+SnHDD+HDH7WczPIH2qz4nBT7QgQff2Bi5/nb56XbQJhkUlMfegHfQc91HspNOrCgz8
         6J1A==
X-Gm-Message-State: ACgBeo3XLZGXwcki4lzHTQrbXdElydOg9w3Sha0YeZWVe9Lnr+UNWi5W
        IeC8djdJlVzaDVdvnArT+fHmtzwcAkkZQYpbNX7FsCvXe6ni
X-Google-Smtp-Source: AA6agR5C6Qga/30TVGHv4ICPLSc92WhV+sBpWb2mo+IP20l01OrArs+sJYQqXxJXN4xomqaZsq9enJTHDKmB7j3DDMS+mDXr00nb
MIME-Version: 1.0
X-Received: by 2002:a05:6638:3804:b0:349:881b:a4bc with SMTP id
 i4-20020a056638380400b00349881ba4bcmr10689708jav.313.1661816012409; Mon, 29
 Aug 2022 16:33:32 -0700 (PDT)
Date:   Mon, 29 Aug 2022 16:33:32 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000001a12f105e769b1eb@google.com>
Subject: [syzbot] memory leak in nft_chain_parse_hook
From:   syzbot <syzbot+5fcdbfab6d6744c57418@syzkaller.appspotmail.com>
To:     coreteam@netfilter.org, davem@davemloft.net, edumazet@google.com,
        fw@strlen.de, kadlec@netfilter.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, pabeni@redhat.com,
        pablo@netfilter.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    4c612826bec1 Merge tag 'net-6.0-rc3' of git://git.kernel.o..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=13db4765080000
kernel config:  https://syzkaller.appspot.com/x/.config?x=b1831d905b683446
dashboard link: https://syzkaller.appspot.com/bug?extid=5fcdbfab6d6744c57418
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1263c283080000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=111b6545080000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+5fcdbfab6d6744c57418@syzkaller.appspotmail.com

executing program
executing program
BUG: memory leak
unreferenced object 0xffff88810180b100 (size 96):
  comm "syz-executor133", pid 3619, jiffies 4294945714 (age 12.690s)
  hex dump (first 32 bytes):
    28 64 23 02 81 88 ff ff 28 64 23 02 81 88 ff ff  (d#.....(d#.....
    90 a8 aa 83 ff ff ff ff 00 00 b5 0f 81 88 ff ff  ................
  backtrace:
    [<ffffffff83a8c59b>] kmalloc include/linux/slab.h:600 [inline]
    [<ffffffff83a8c59b>] nft_netdev_hook_alloc+0x3b/0xc0 net/netfilter/nf_tables_api.c:1901
    [<ffffffff83a9239a>] nft_chain_parse_netdev net/netfilter/nf_tables_api.c:1998 [inline]
    [<ffffffff83a9239a>] nft_chain_parse_hook+0x33a/0x530 net/netfilter/nf_tables_api.c:2073
    [<ffffffff83a9b14b>] nf_tables_addchain.constprop.0+0x10b/0x950 net/netfilter/nf_tables_api.c:2218
    [<ffffffff83a9c41b>] nf_tables_newchain+0xa8b/0xc60 net/netfilter/nf_tables_api.c:2593
    [<ffffffff83a3d6a6>] nfnetlink_rcv_batch+0xa46/0xd20 net/netfilter/nfnetlink.c:517
    [<ffffffff83a3db79>] nfnetlink_rcv_skb_batch net/netfilter/nfnetlink.c:638 [inline]
    [<ffffffff83a3db79>] nfnetlink_rcv+0x1f9/0x220 net/netfilter/nfnetlink.c:656
    [<ffffffff83a13b17>] netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
    [<ffffffff83a13b17>] netlink_unicast+0x397/0x4c0 net/netlink/af_netlink.c:1345
    [<ffffffff83a13fd6>] netlink_sendmsg+0x396/0x710 net/netlink/af_netlink.c:1921
    [<ffffffff83865ab6>] sock_sendmsg_nosec net/socket.c:714 [inline]
    [<ffffffff83865ab6>] sock_sendmsg+0x56/0x80 net/socket.c:734
    [<ffffffff8386601c>] ____sys_sendmsg+0x36c/0x390 net/socket.c:2482
    [<ffffffff8386a918>] ___sys_sendmsg+0xa8/0x110 net/socket.c:2536
    [<ffffffff8386aaa8>] __sys_sendmsg+0x88/0x100 net/socket.c:2565
    [<ffffffff845e5955>] do_syscall_x64 arch/x86/entry/common.c:50 [inline]
    [<ffffffff845e5955>] do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
    [<ffffffff84800087>] entry_SYSCALL_64_after_hwframe+0x63/0xcd



---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
