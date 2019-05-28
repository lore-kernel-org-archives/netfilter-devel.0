Return-Path: <SRS0=QEZg=T4=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E32AC46460
	for <netfilter-devel@archiver.kernel.org>; Tue, 28 May 2019 18:28:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 38FB8216FD
	for <netfilter-devel@archiver.kernel.org>; Tue, 28 May 2019 18:28:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728007AbfE1S2G (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 28 May 2019 14:28:06 -0400
Received: from mail-io1-f72.google.com ([209.85.166.72]:38072 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727688AbfE1S2G (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 28 May 2019 14:28:06 -0400
Received: by mail-io1-f72.google.com with SMTP id w3so16635091iot.5
        for <netfilter-devel@vger.kernel.org>; Tue, 28 May 2019 11:28:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=+ldiqKGHr6yHXLQq0GIJnMrPMY0jgu2oLYPlOl6lC24=;
        b=B64GlAa8eR0mJ+zBs134uIyfYcH55E2wmc9FT2P8uyMGVzGZ/mPdr53NOyhNJE85E8
         fw17D+Dyfhlu4unUZmQEFjrCWhLu+iLjulVkbt8GJAboy8WQz23Qnd/8OOXt6VeZ1WSG
         1Z7Yl7gxw74hE+XCMcHaSKb0Mcvv/FgNnCE6KYwFSFwNjRpjKtA2AaJ34WOciwU8OZ1B
         3jLjkGmZMwFXg9SbBfvwuwIQfZKKqGz10r/wj8NjIIwbgZs9+5gQEyh3QvxlDjbYkqdp
         w3J/5xvLnPkyqxgogWVrCYPIXvvHGD6ezCU9oI1MRYSSWzUi7TvWp6HSY/S1HONVz1oC
         m39A==
X-Gm-Message-State: APjAAAX5lyI2Ar9UCiMX5/gW9EhfBnaWYAkiQrTN5h8J72RMEz30ys4u
        8W6Rzs3IQEVHSMilzCwPBSeecQUZjq4/ulPm9T2NOCoQoUgo
X-Google-Smtp-Source: APXvYqwL7c7xW+P7gzgwUx9EHwhUGqmS5Is5gSp6mZQSmOrKqwghTbjBHJ8lwQtnhvrjalR2gBQcgEg0E6pjoT8GpexeXWMq32qx
MIME-Version: 1.0
X-Received: by 2002:a24:5c5:: with SMTP id 188mr4041686itl.10.1559068085677;
 Tue, 28 May 2019 11:28:05 -0700 (PDT)
Date:   Tue, 28 May 2019 11:28:05 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000006d7e520589f6d3a9@google.com>
Subject: memory leak in start_sync_thread
From:   syzbot <syzbot+7e2e50c8adfccd2e5041@syzkaller.appspotmail.com>
To:     coreteam@netfilter.org, davem@davemloft.net, fw@strlen.de,
        horms@verge.net.au, ja@ssi.bg, kadlec@blackhole.kfki.hu,
        linux-kernel@vger.kernel.org, lvs-devel@vger.kernel.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        pablo@netfilter.org, syzkaller-bugs@googlegroups.com,
        wensong@linux-vs.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    cd6c84d8 Linux 5.2-rc2
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=132bd44aa00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=64479170dcaf0e11
dashboard link: https://syzkaller.appspot.com/bug?extid=7e2e50c8adfccd2e5041
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=114b1354a00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14b7ad26a00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+7e2e50c8adfccd2e5041@syzkaller.appspotmail.com

d started: state = MASTER, mcast_ifn = syz_tun, syncid = 0, id = 0
BUG: memory leak
unreferenced object 0xffff8881206bf700 (size 32):
   comm "syz-executor761", pid 7268, jiffies 4294943441 (age 20.470s)
   hex dump (first 32 bytes):
     00 40 7c 09 81 88 ff ff 80 45 b8 21 81 88 ff ff  .@|......E.!....
     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
   backtrace:
     [<0000000057619e23>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:55 [inline]
     [<0000000057619e23>] slab_post_alloc_hook mm/slab.h:439 [inline]
     [<0000000057619e23>] slab_alloc mm/slab.c:3326 [inline]
     [<0000000057619e23>] kmem_cache_alloc_trace+0x13d/0x280 mm/slab.c:3553
     [<0000000086ce5479>] kmalloc include/linux/slab.h:547 [inline]
     [<0000000086ce5479>] start_sync_thread+0x5d2/0xe10  
net/netfilter/ipvs/ip_vs_sync.c:1862
     [<000000001a9229cc>] do_ip_vs_set_ctl+0x4c5/0x780  
net/netfilter/ipvs/ip_vs_ctl.c:2402
     [<00000000ece457c8>] nf_sockopt net/netfilter/nf_sockopt.c:106 [inline]
     [<00000000ece457c8>] nf_setsockopt+0x4c/0x80  
net/netfilter/nf_sockopt.c:115
     [<00000000942f62d4>] ip_setsockopt net/ipv4/ip_sockglue.c:1258 [inline]
     [<00000000942f62d4>] ip_setsockopt+0x9b/0xb0 net/ipv4/ip_sockglue.c:1238
     [<00000000a56a8ffd>] udp_setsockopt+0x4e/0x90 net/ipv4/udp.c:2616
     [<00000000fa895401>] sock_common_setsockopt+0x38/0x50  
net/core/sock.c:3130
     [<0000000095eef4cf>] __sys_setsockopt+0x98/0x120 net/socket.c:2078
     [<000000009747cf88>] __do_sys_setsockopt net/socket.c:2089 [inline]
     [<000000009747cf88>] __se_sys_setsockopt net/socket.c:2086 [inline]
     [<000000009747cf88>] __x64_sys_setsockopt+0x26/0x30 net/socket.c:2086
     [<00000000ded8ba80>] do_syscall_64+0x76/0x1a0  
arch/x86/entry/common.c:301
     [<00000000893b4ac8>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff8881206bf700 (size 32):
   comm "syz-executor761", pid 7268, jiffies 4294943441 (age 21.530s)
   hex dump (first 32 bytes):
     00 40 7c 09 81 88 ff ff 80 45 b8 21 81 88 ff ff  .@|......E.!....
     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
   backtrace:
     [<0000000057619e23>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:55 [inline]
     [<0000000057619e23>] slab_post_alloc_hook mm/slab.h:439 [inline]
     [<0000000057619e23>] slab_alloc mm/slab.c:3326 [inline]
     [<0000000057619e23>] kmem_cache_alloc_trace+0x13d/0x280 mm/slab.c:3553
     [<0000000086ce5479>] kmalloc include/linux/slab.h:547 [inline]
     [<0000000086ce5479>] start_sync_thread+0x5d2/0xe10  
net/netfilter/ipvs/ip_vs_sync.c:1862
     [<000000001a9229cc>] do_ip_vs_set_ctl+0x4c5/0x780  
net/netfilter/ipvs/ip_vs_ctl.c:2402
     [<00000000ece457c8>] nf_sockopt net/netfilter/nf_sockopt.c:106 [inline]
     [<00000000ece457c8>] nf_setsockopt+0x4c/0x80  
net/netfilter/nf_sockopt.c:115
     [<00000000942f62d4>] ip_setsockopt net/ipv4/ip_sockglue.c:1258 [inline]
     [<00000000942f62d4>] ip_setsockopt+0x9b/0xb0 net/ipv4/ip_sockglue.c:1238
     [<00000000a56a8ffd>] udp_setsockopt+0x4e/0x90 net/ipv4/udp.c:2616
     [<00000000fa895401>] sock_common_setsockopt+0x38/0x50  
net/core/sock.c:3130
     [<0000000095eef4cf>] __sys_setsockopt+0x98/0x120 net/socket.c:2078
     [<000000009747cf88>] __do_sys_setsockopt net/socket.c:2089 [inline]
     [<000000009747cf88>] __se_sys_setsockopt net/socket.c:2086 [inline]
     [<000000009747cf88>] __x64_sys_setsockopt+0x26/0x30 net/socket.c:2086
     [<00000000ded8ba80>] do_syscall_64+0x76/0x1a0  
arch/x86/entry/common.c:301
     [<00000000893b4ac8>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff8881206bf700 (size 32):
   comm "syz-executor761", pid 7268, jiffies 4294943441 (age 22.630s)
   hex dump (first 32 bytes):
     00 40 7c 09 81 88 ff ff 80 45 b8 21 81 88 ff ff  .@|......E.!....
     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
   backtrace:
     [<0000000057619e23>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:55 [inline]
     [<0000000057619e23>] slab_post_alloc_hook mm/slab.h:439 [inline]
     [<0000000057619e23>] slab_alloc mm/slab.c:3326 [inline]
     [<0000000057619e23>] kmem_cache_alloc_trace+0x13d/0x280 mm/slab.c:3553
     [<0000000086ce5479>] kmalloc include/linux/slab.h:547 [inline]
     [<0000000086ce5479>] start_sync_thread+0x5d2/0xe10  
net/netfilter/ipvs/ip_vs_sync.c:1862
     [<000000001a9229cc>] do_ip_vs_set_ctl+0x4c5/0x780  
net/netfilter/ipvs/ip_vs_ctl.c:2402
     [<00000000ece457c8>] nf_sockopt net/netfilter/nf_sockopt.c:106 [inline]
     [<00000000ece457c8>] nf_setsockopt+0x4c/0x80  
net/netfilter/nf_sockopt.c:115
     [<00000000942f62d4>] ip_setsockopt net/ipv4/ip_sockglue.c:1258 [inline]
     [<00000000942f62d4>] ip_setsockopt+0x9b/0xb0 net/ipv4/ip_sockglue.c:1238
     [<00000000a56a8ffd>] udp_setsockopt+0x4e/0x90 net/ipv4/udp.c:2616
     [<00000000fa895401>] sock_common_setsockopt+0x38/0x50  
net/core/sock.c:3130
     [<0000000095eef4cf>] __sys_setsockopt+0x98/0x120 net/socket.c:2078
     [<000000009747cf88>] __do_sys_setsockopt net/socket.c:2089 [inline]
     [<000000009747cf88>] __se_sys_setsockopt net/socket.c:2086 [inline]
     [<000000009747cf88>] __x64_sys_setsockopt+0x26/0x30 net/socket.c:2086
     [<00000000ded8ba80>] do_syscall_64+0x76/0x1a0  
arch/x86/entry/common.c:301
     [<00000000893b4ac8>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff8881206bf700 (size 32):
   comm "syz-executor761", pid 7268, jiffies 4294943441 (age 23.720s)
   hex dump (first 32 bytes):
     00 40 7c 09 81 88 ff ff 80 45 b8 21 81 88 ff ff  .@|......E.!....
     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
   backtrace:
     [<0000000057619e23>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:55 [inline]
     [<0000000057619e23>] slab_post_alloc_hook mm/slab.h:439 [inline]
     [<0000000057619e23>] slab_alloc mm/slab.c:3326 [inline]
     [<0000000057619e23>] kmem_cache_alloc_trace+0x13d/0x280 mm/slab.c:3553
     [<0000000086ce5479>] kmalloc include/linux/slab.h:547 [inline]
     [<0000000086ce5479>] start_sync_thread+0x5d2/0xe10  
net/netfilter/ipvs/ip_vs_sync.c:1862
     [<000000001a9229cc>] do_ip_vs_set_ctl+0x4c5/0x780  
net/netfilter/ipvs/ip_vs_ctl.c:2402
     [<00000000ece457c8>] nf_sockopt net/netfilter/nf_sockopt.c:106 [inline]
     [<00000000ece457c8>] nf_setsockopt+0x4c/0x80  
net/netfilter/nf_sockopt.c:115
     [<00000000942f62d4>] ip_setsockopt net/ipv4/ip_sockglue.c:1258 [inline]
     [<00000000942f62d4>] ip_setsockopt+0x9b/0xb0 net/ipv4/ip_sockglue.c:1238
     [<00000000a56a8ffd>] udp_setsockopt+0x4e/0x90 net/ipv4/udp.c:2616
     [<00000000fa895401>] sock_common_setsockopt+0x38/0x50  
net/core/sock.c:3130
     [<0000000095eef4cf>] __sys_setsockopt+0x98/0x120 net/socket.c:2078
     [<000000009747cf88>] __do_sys_setsockopt net/socket.c:2089 [inline]
     [<000000009747cf88>] __se_sys_setsockopt net/socket.c:2086 [inline]
     [<000000009747cf88>] __x64_sys_setsockopt+0x26/0x30 net/socket.c:2086
     [<00000000ded8ba80>] do_syscall_64+0x76/0x1a0  
arch/x86/entry/common.c:301
     [<00000000893b4ac8>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff8881206bf700 (size 32):
   comm "syz-executor761", pid 7268, jiffies 4294943441 (age 25.770s)
   hex dump (first 32 bytes):
     00 40 7c 09 81 88 ff ff 80 45 b8 21 81 88 ff ff  .@|......E.!....
     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
   backtrace:
     [<0000000057619e23>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:55 [inline]
     [<0000000057619e23>] slab_post_alloc_hook mm/slab.h:439 [inline]
     [<0000000057619e23>] slab_alloc mm/slab.c:3326 [inline]
     [<0000000057619e23>] kmem_cache_alloc_trace+0x13d/0x280 mm/slab.c:3553
     [<0000000086ce5479>] kmalloc include/linux/slab.h:547 [inline]
     [<0000000086ce5479>] start_sync_thread+0x5d2/0xe10  
net/netfilter/ipvs/ip_vs_sync.c:1862
     [<000000001a9229cc>] do_ip_vs_set_ctl+0x4c5/0x780  
net/netfilter/ipvs/ip_vs_ctl.c:2402
     [<00000000ece457c8>] nf_sockopt net/netfilter/nf_sockopt.c:106 [inline]
     [<00000000ece457c8>] nf_setsockopt+0x4c/0x80  
net/netfilter/nf_sockopt.c:115
     [<00000000942f62d4>] ip_setsockopt net/ipv4/ip_sockglue.c:1258 [inline]
     [<00000000942f62d4>] ip_setsockopt+0x9b/0xb0 net/ipv4/ip_sockglue.c:1238
     [<00000000a56a8ffd>] udp_setsockopt+0x4e/0x90 net/ipv4/udp.c:2616
     [<00000000fa895401>] sock_common_setsockopt+0x38/0x50  
net/core/sock.c:3130
     [<0000000095eef4cf>] __sys_setsockopt+0x98/0x120 net/socket.c:2078
     [<000000009747cf88>] __do_sys_setsockopt net/socket.c:2089 [inline]
     [<000000009747cf88>] __se_sys_setsockopt net/socket.c:2086 [inline]
     [<000000009747cf88>] __x64_sys_setsockopt+0x26/0x30 net/socket.c:2086
     [<00000000ded8ba80>] do_syscall_64+0x76/0x1a0  
arch/x86/entry/common.c:301
     [<00000000893b4ac8>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff8881206bf700 (size 32):
   comm "syz-executor761", pid 7268, jiffies 4294943441 (age 26.850s)
   hex dump (first 32 bytes):
     00 40 7c 09 81 88 ff ff 80 45 b8 21 81 88 ff ff  .@|......E.!....
     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
   backtrace:
     [<0000000057619e23>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:55 [inline]
     [<0000000057619e23>] slab_post_alloc_hook mm/slab.h:439 [inline]
     [<0000000057619e23>] slab_alloc mm/slab.c:3326 [inline]
     [<0000000057619e23>] kmem_cache_alloc_trace+0x13d/0x280 mm/slab.c:3553
     [<0000000086ce5479>] kmalloc include/linux/slab.h:547 [inline]
     [<0000000086ce5479>] start_sync_thread+0x5d2/0xe10  
net/netfilter/ipvs/ip_vs_sync.c:1862
     [<000000001a9229cc>] do_ip_vs_set_ctl+0x4c5/0x780  
net/netfilter/ipvs/ip_vs_ctl.c:2402
     [<00000000ece457c8>] nf_sockopt net/netfilter/nf_sockopt.c:106 [inline]
     [<00000000ece457c8>] nf_setsockopt+0x4c/0x80  
net/netfilter/nf_sockopt.c:115
     [<00000000942f62d4>] ip_setsockopt net/ipv4/ip_sockglue.c:1258 [inline]
     [<00000000942f62d4>] ip_setsockopt+0x9b/0xb0 net/ipv4/ip_sockglue.c:1238
     [<00000000a56a8ffd>] udp_setsockopt+0x4e/0x90 net/ipv4/udp.c:2616
     [<00000000fa895401>] sock_common_setsockopt+0x38/0x50  
net/core/sock.c:3130
     [<0000000095eef4cf>] __sys_setsockopt+0x98/0x120 net/socket.c:2078
     [<000000009747cf88>] __do_sys_setsockopt net/socket.c:2089 [inline]
     [<000000009747cf88>] __se_sys_setsockopt net/socket.c:2086 [inline]
     [<000000009747cf88>] __x64_sys_setsockopt+0x26/0x30 net/socket.c:2086
     [<00000000ded8ba80>] do_syscall_64+0x76/0x1a0  
arch/x86/entry/common.c:301
     [<00000000893b4ac8>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

BUG: memory leak
unreferenced object 0xffff8881206bf700 (size 32):
   comm "syz-executor761", pid 7268, jiffies 4294943441 (age 27.940s)
   hex dump (first 32 bytes):
     00 40 7c 09 81 88 ff ff 80 45 b8 21 81 88 ff ff  .@|......E.!....
     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
   backtrace:
     [<0000000057619e23>] kmemleak_alloc_recursive  
include/linux/kmemleak.h:55 [inline]
     [<0000000057619e23>] slab_post_alloc_hook mm/slab.h:439 [inline]
     [<0000000057619e23>] slab_alloc mm/slab.c:3326 [inline]
     [<0000000057619e23>] kmem_cache_alloc_trace+0x13d/0x280 mm/slab.c:3553
     [<0000000086ce5479>] kmalloc include/linux/slab.h:547 [inline]
     [<0000000086ce5479>] start_sync_thread+0x5d2/0xe10  
net/netfilter/ipvs/ip_vs_sync.c:1862
     [<000000001a9229cc>] do_ip_vs_set_ctl+0x4c5/0x780  
net/netfilter/ipvs/ip_vs_ctl.c:2402
     [<00000000ece457c8>] nf_sockopt net/netfilter/nf_sockopt.c:106 [inline]
     [<00000000ece457c8>] nf_setsockopt+0x4c/0x80  
net/netfilter/nf_sockopt.c:115
     [<00000000942f62d4>] ip_setsockopt net/ipv4/ip_sockglue.c:1258 [inline]
     [<00000000942f62d4>] ip_setsockopt+0x9b/0xb0 net/ipv4/ip_sockglue.c:1238
     [<00000000a56a8ffd>] udp_setsockopt+0x4e/0x90 net/ipv4/udp.c:2616
     [<00000000fa895401>] sock_common_setsockopt+0x38/0x50  
net/core/sock.c:3130
     [<0000000095eef4cf>] __sys_setsockopt+0x98/0x120 net/socket.c:2078
     [<000000009747cf88>] __do_sys_setsockopt net/socket.c:2089 [inline]
     [<000000009747cf88>] __se_sys_setsockopt net/socket.c:2086 [inline]
     [<000000009747cf88>] __x64_sys_setsockopt+0x26/0x30 net/socket.c:2086
     [<00000000ded8ba80>] do_syscall_64+0x76/0x1a0  
arch/x86/entry/common.c:301
     [<00000000893b4ac8>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

executing program


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
