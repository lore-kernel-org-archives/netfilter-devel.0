Return-Path: <SRS0=yr9h=Q5=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3401EC43381
	for <netfilter-devel@archiver.kernel.org>; Fri, 22 Feb 2019 17:10:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0E75E20700
	for <netfilter-devel@archiver.kernel.org>; Fri, 22 Feb 2019 17:10:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727301AbfBVRKG (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 22 Feb 2019 12:10:06 -0500
Received: from mail-it1-f199.google.com ([209.85.166.199]:55253 "EHLO
        mail-it1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726403AbfBVRKG (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 22 Feb 2019 12:10:06 -0500
Received: by mail-it1-f199.google.com with SMTP id v125so2449004itc.4
        for <netfilter-devel@vger.kernel.org>; Fri, 22 Feb 2019 09:10:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=pHxPEfLIOcr/61xwOv7FPjJT/D7GpsqoBSDZ06xID2s=;
        b=cXw19E3Pr2TQk3SwjHEy+ToIxwKSr84ei7nAcyudx3+F0LTQhNDh4MEA4b+YXfud66
         RJZUFIqflfkT6v+8DMVKk1t9uJwgEDvtaHGcPlBSUUf+ZxAcWcHJcvEo+fcpWc/PMyhs
         xfLYjeBNQEmPLrpU5iM4Os+6OY4Wb+KL9+STmFWY4+zf0n+Ql88DXMv3E2txz8+OyH5m
         GH2krLARS5IzfCyklmHzeh3bkeB+wgR+5zBAzXiPBc9d+rA9nTW2u4su8bMw3HfRVzkJ
         YmKVZIpW44xqr7/YYZAsVPSJ2RtXEhOIfKARgCoj9aSSipa4eyDc4U8nNvUkMH4th38X
         OvcQ==
X-Gm-Message-State: AHQUAubd33LW3VGxQc8TZi8S8kTEQOjQq4mn+uqiISlr0pzupSoq589t
        8rJx37Uazv1oM6yO4hknKxF0/ChonysyHdVu/6ylFxjklsVl
X-Google-Smtp-Source: AHgI3IbuhF26WsE1jY3Of8Zv6LqCIYedQ5yImfOJXTIkZliTXH5Z7bRUQa4mEy9ZiVLCFf7QWw9+QB9oy8k62m74YKHGdjWt031b
MIME-Version: 1.0
X-Received: by 2002:a24:9143:: with SMTP id i64mr2820304ite.32.1550855404882;
 Fri, 22 Feb 2019 09:10:04 -0800 (PST)
Date:   Fri, 22 Feb 2019 09:10:04 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000081994205827ea9a0@google.com>
Subject: WARNING in xt_compat_add_offset
From:   syzbot <syzbot+276ddebab3382bbf72db@syzkaller.appspotmail.com>
To:     coreteam@netfilter.org, davem@davemloft.net, fw@strlen.de,
        kadlec@blackhole.kfki.hu, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        pablo@netfilter.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    8a61716ff2ab Merge tag 'ceph-for-5.0-rc8' of git://github...
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1456fa6cc00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=7132344728e7ec3f
dashboard link: https://syzkaller.appspot.com/bug?extid=276ddebab3382bbf72db
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
userspace arch: i386
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=140c0914c00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+276ddebab3382bbf72db@syzkaller.appspotmail.com

IPv6: ADDRCONF(NETDEV_CHANGE): hsr_slave_0: link becomes ready
IPv6: ADDRCONF(NETDEV_CHANGE): hsr_slave_1: link becomes ready
IPv6: ADDRCONF(NETDEV_CHANGE): hsr0: link becomes ready
8021q: adding VLAN 0 to HW filter on device batadv0
cannot load conntrack support for proto=7
WARNING: CPU: 1 PID: 7458 at net/netfilter/x_tables.c:654  
xt_compat_add_offset+0x22a/0x290 net/netfilter/x_tables.c:654
Kernel panic - not syncing: panic_on_warn set ...
CPU: 1 PID: 7458 Comm: syz-executor.0 Not tainted 5.0.0-rc7+ #83
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x172/0x1f0 lib/dump_stack.c:113
  panic+0x2cb/0x65c kernel/panic.c:214
  __warn.cold+0x20/0x45 kernel/panic.c:571
  report_bug+0x263/0x2b0 lib/bug.c:186
  fixup_bug arch/x86/kernel/traps.c:178 [inline]
  fixup_bug arch/x86/kernel/traps.c:173 [inline]
  do_error_trap+0x11b/0x200 arch/x86/kernel/traps.c:271
  do_invalid_op+0x37/0x50 arch/x86/kernel/traps.c:290
  invalid_op+0x14/0x20 arch/x86/entry/entry_64.S:973
RIP: 0010:xt_compat_add_offset+0x22a/0x290 net/netfilter/x_tables.c:654
Code: 00 01 e8 59 67 bb fb 44 89 e0 48 83 c4 08 5b 41 5c 41 5d 41 5e 41 5f  
5d c3 e8 42 67 bb fb 0f 0b e9 56 fe ff ff e8 36 67 bb fb <0f> 0b 41 bc f4  
ff ff ff eb ce 4c 89 f7 e8 14 6a f2 fb e9 75 ff ff
RSP: 0018:ffff8880a8197808 EFLAGS: 00010293
RAX: ffff88809055e040 RBX: ffff8882166548d0 RCX: ffffffff85b47892
RDX: 0000000000000000 RSI: ffffffff85b47a4a RDI: ffff8882166549f0
RBP: ffff8880a8197838 R08: ffff88809055e040 R09: ffffed1042cca92f
R10: ffffed1042cca92e R11: ffff888216654977 R12: 0000000000000018
R13: 0000000000000030 R14: ffff88809055e040 R15: 0000000000000000
  size_entry_mwt net/bridge/netfilter/ebtables.c:2183 [inline]
  compat_copy_entries+0x51b/0x1360 net/bridge/netfilter/ebtables.c:2208
  compat_do_replace+0x3b3/0x680 net/bridge/netfilter/ebtables.c:2302
  compat_do_ebt_set_ctl+0x229/0x278 net/bridge/netfilter/ebtables.c:2384
  compat_nf_sockopt net/netfilter/nf_sockopt.c:144 [inline]
  compat_nf_setsockopt+0x9b/0x140 net/netfilter/nf_sockopt.c:156
  compat_ip_setsockopt net/ipv4/ip_sockglue.c:1284 [inline]
  compat_ip_setsockopt+0x106/0x140 net/ipv4/ip_sockglue.c:1265
  compat_udp_setsockopt+0x68/0xb0 net/ipv4/udp.c:2629
  compat_ipv6_setsockopt+0xca/0x210 net/ipv6/ipv6_sockglue.c:959
  inet_csk_compat_setsockopt+0x99/0x120 net/ipv4/inet_connection_sock.c:1054
  compat_tcp_setsockopt+0x4d/0x80 net/ipv4/tcp.c:3079
  compat_sock_common_setsockopt+0xb4/0x150 net/core/sock.c:3002
  __compat_sys_setsockopt+0x176/0x610 net/compat.c:404
  __do_compat_sys_setsockopt net/compat.c:417 [inline]
  __se_compat_sys_setsockopt net/compat.c:414 [inline]
  __ia32_compat_sys_setsockopt+0xbd/0x150 net/compat.c:414
  do_syscall_32_irqs_on arch/x86/entry/common.c:326 [inline]
  do_fast_syscall_32+0x281/0xc98 arch/x86/entry/common.c:397
  entry_SYSENTER_compat+0x70/0x7f arch/x86/entry/entry_64_compat.S:139
RIP: 0023:0xf7fd3869
Code: 85 d2 74 02 89 0a 5b 5d c3 8b 04 24 c3 8b 14 24 c3 8b 3c 24 c3 90 90  
90 90 90 90 90 90 90 90 90 90 51 52 55 89 e5 0f 34 cd 80 <5d> 5a 59 c3 90  
90 90 90 eb 0d 90 90 90 90 90 90 90 90 90 90 90 90
RSP: 002b:00000000f7fcf0cc EFLAGS: 00000296 ORIG_RAX: 000000000000016e
RAX: ffffffffffffffda RBX: 0000000000000006 RCX: 0000000000000000
RDX: 0000000000000080 RSI: 00000000200000c0 RDI: 0000000000000270
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
Kernel Offset: disabled
Rebooting in 86400 seconds..


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#bug-status-tracking for how to communicate with  
syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
