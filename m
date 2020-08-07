Return-Path: <SRS0=v7HC=BR=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=BAYES_00,FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E416BC433DF
	for <netfilter-devel@archiver.kernel.org>; Fri,  7 Aug 2020 02:26:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DA59820855
	for <netfilter-devel@archiver.kernel.org>; Fri,  7 Aug 2020 02:26:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726566AbgHGC0l (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 6 Aug 2020 22:26:41 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:49272 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726180AbgHGC01 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 6 Aug 2020 22:26:27 -0400
Received: by mail-io1-f71.google.com with SMTP id 189so510432iov.16
        for <netfilter-devel@vger.kernel.org>; Thu, 06 Aug 2020 19:26:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=yHSo/kuS5ZP8bar2nScAn5lqkwqHBJnis2OUjlmiGf8=;
        b=XVa5PfvwYUwCwYuUYbrvbpifalqAe1ke52B+gVjn/cXQnrya8MDgiyHCkkTczDFdgt
         KxrZ4D/3y2vLqQobN7y9CyJYCKZon7mzgDl7Xf48Rh7Dc/3YhWybZir0VMYqLn5J1kxv
         jnZw82otysp86Mpd9c1OO5sxmDDU6z1RqZpkKcqd0JnT1Vmdg8abtq1cGeyiedPdaXQ0
         C26trdqsjghblSb1VGIjVCGaGqFU0QtW3leW+Ck80E3wqq0YERKtQJ7S7i1vCeMmtMtM
         /nxjd4F3VXLSS6NFip5+jtUxloLXSVf63lYWywAzKFbdOHNM9KviCSJvbB/RhuZrnbcq
         CztQ==
X-Gm-Message-State: AOAM533CZs76fvtGASlxAVApqCNLOgt+d/hjC4LIc852O2OW7mej0+qY
        2TCpkeiuJXd1tgWCBRggs3f5tahGGaHJ/AQn2GS8u8Hr2bVZ
X-Google-Smtp-Source: ABdhPJzWqZlpXxseUdPBQtg4h5n7fncG9tig9ZWsF3MR1GAU9dFy4z0l4sIfNL+g6FoISGc69bCA7oL5MMsm3vF5TUDs1Qt2wrPD
MIME-Version: 1.0
X-Received: by 2002:a92:981d:: with SMTP id l29mr2298152ili.178.1596767186248;
 Thu, 06 Aug 2020 19:26:26 -0700 (PDT)
Date:   Thu, 06 Aug 2020 19:26:26 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000ece9db05ac4054e8@google.com>
Subject: WARNING in compat_do_ebt_get_ctl
From:   syzbot <syzbot+5accb5c62faa1d346480@syzkaller.appspotmail.com>
To:     bridge@lists.linux-foundation.org, coreteam@netfilter.org,
        davem@davemloft.net, fw@strlen.de, kadlec@netfilter.org,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        nikolay@cumulusnetworks.com, pablo@netfilter.org,
        roopa@cumulusnetworks.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    47ec5303 Merge git://git.kernel.org/pub/scm/linux/kernel/g..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=17e92e76900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=7c06047f622c5724
dashboard link: https://syzkaller.appspot.com/bug?extid=5accb5c62faa1d346480
compiler:       gcc (GCC) 10.1.0-syz 20200507
userspace arch: i386

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+5accb5c62faa1d346480@syzkaller.appspotmail.com

WARNING: CPU: 0 PID: 783 at include/linux/thread_info.h:134 copy_overflow include/linux/thread_info.h:134 [inline]
WARNING: CPU: 0 PID: 783 at include/linux/thread_info.h:134 check_copy_size include/linux/thread_info.h:143 [inline]
WARNING: CPU: 0 PID: 783 at include/linux/thread_info.h:134 copy_to_user include/linux/uaccess.h:151 [inline]
WARNING: CPU: 0 PID: 783 at include/linux/thread_info.h:134 compat_do_ebt_get_ctl+0x47e/0x500 net/bridge/netfilter/ebtables.c:2270
Kernel panic - not syncing: panic_on_warn set ...
CPU: 0 PID: 783 Comm: syz-executor.2 Not tainted 5.8.0-syzkaller #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.12.0-59-gc9ba5276e321-prebuilt.qemu.org 04/01/2014
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x18f/0x20d lib/dump_stack.c:118
 panic+0x2e3/0x75c kernel/panic.c:231
 __warn.cold+0x20/0x45 kernel/panic.c:600
 report_bug+0x1bd/0x210 lib/bug.c:198
 handle_bug+0x38/0x90 arch/x86/kernel/traps.c:235
 exc_invalid_op+0x14/0x40 arch/x86/kernel/traps.c:255
 asm_exc_invalid_op+0x12/0x20 arch/x86/include/asm/idtentry.h:536
RIP: 0010:copy_overflow include/linux/thread_info.h:134 [inline]
RIP: 0010:check_copy_size include/linux/thread_info.h:143 [inline]
RIP: 0010:copy_to_user include/linux/uaccess.h:151 [inline]
RIP: 0010:compat_do_ebt_get_ctl+0x47e/0x500 net/bridge/netfilter/ebtables.c:2270
Code: ba fd ff ff 4c 89 f7 e8 a0 11 a4 fa e9 ad fd ff ff e8 06 0f 64 fa 4c 89 e2 be 50 00 00 00 48 c7 c7 00 4e 0e 89 e8 64 20 35 fa <0f> 0b e9 dc fd ff ff 41 bc f2 ff ff ff e9 4f fe ff ff e8 7b 11 a4
RSP: 0018:ffffc900047b7ae8 EFLAGS: 00010282
RAX: 0000000000000000 RBX: 1ffff920008f6f5e RCX: 0000000000000000
RDX: 0000000000040000 RSI: ffffffff815d8eb7 RDI: fffff520008f6f4f
RBP: ffffffff8a8f3460 R08: 0000000000000001 R09: ffff88802ce31927
R10: 0000000000000000 R11: 0000000033383754 R12: 000000000000ffab
R13: 0000000020000100 R14: ffffc900047b7d80 R15: ffffc900047b7b20
 do_ebt_get_ctl+0x2b4/0x790 net/bridge/netfilter/ebtables.c:2317
 nf_getsockopt+0x72/0xd0 net/netfilter/nf_sockopt.c:116
 ip_getsockopt net/ipv4/ip_sockglue.c:1778 [inline]
 ip_getsockopt+0x164/0x1c0 net/ipv4/ip_sockglue.c:1757
 raw_getsockopt+0x1a1/0x1d0 net/ipv4/raw.c:876
 __sys_getsockopt+0x219/0x4c0 net/socket.c:2179
 __do_sys_getsockopt net/socket.c:2194 [inline]
 __se_sys_getsockopt net/socket.c:2191 [inline]
 __ia32_sys_getsockopt+0xb9/0x150 net/socket.c:2191
 do_syscall_32_irqs_on arch/x86/entry/common.c:84 [inline]
 __do_fast_syscall_32+0x57/0x80 arch/x86/entry/common.c:126
 do_fast_syscall_32+0x2f/0x70 arch/x86/entry/common.c:149
 entry_SYSENTER_compat_after_hwframe+0x4d/0x5c
RIP: 0023:0xf7f24569
Code: c4 01 10 03 03 74 c0 01 10 05 03 74 b8 01 10 06 03 74 b4 01 10 07 03 74 b0 01 10 08 03 74 d8 01 00 51 52 55 89 e5 0f 34 cd 80 <5d> 5a 59 c3 90 90 90 90 eb 0d 90 90 90 90 90 90 90 90 90 90 90 90
RSP: 002b:00000000f551e0bc EFLAGS: 00000296 ORIG_RAX: 000000000000016d
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 0000000000000000
RDX: 0000000000000082 RSI: 0000000020000100 RDI: 0000000020000180
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
Kernel Offset: disabled
Rebooting in 86400 seconds..


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
