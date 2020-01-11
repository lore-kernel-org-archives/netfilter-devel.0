Return-Path: <SRS0=YRd2=3A=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24A6EC282DD
	for <netfilter-devel@archiver.kernel.org>; Sat, 11 Jan 2020 18:04:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 003E920866
	for <netfilter-devel@archiver.kernel.org>; Sat, 11 Jan 2020 18:04:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730699AbgAKSEL (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 11 Jan 2020 13:04:11 -0500
Received: from mail-il1-f198.google.com ([209.85.166.198]:54415 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730647AbgAKSEL (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 11 Jan 2020 13:04:11 -0500
Received: by mail-il1-f198.google.com with SMTP id t4so4245398ili.21
        for <netfilter-devel@vger.kernel.org>; Sat, 11 Jan 2020 10:04:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=IKJ0VvvA4NZ59sgPsM3f+KZQbWTNSpZt7HA/swbAD54=;
        b=M6bTZrB60h6ZXd+BEYXz8/zy9vMUKSWCyEt10qWTuBTiW6+YKJPq7FHJOUbSHnGFof
         g5Yy+fxtOgqAcgqk6mWN2lAna+NhUNqvoehD5oW6j9OtD+s8kF3ASeTkgQuCxyz3OhRL
         yKl5/gLRJBLPq6uJMigUd2KN3FwsQNtLx5HieXmXSJEBxOd1jLicwPvVzB2ghOsrEpYi
         Lfr4ZXmguTQZX1i9fCzQkEQu1MijnzehHDUqzKgbcIEVzCQWOMcTN+HJZMS3TasrZMr2
         XtEaH+x9AxycBgaFCrA/7LcI+GOK3DbC31vlv6qtOQD0MuMDn18xF6PpN8Ia0Sc82bPX
         lxOQ==
X-Gm-Message-State: APjAAAUO2Ip942HVLN9C0eDkMcmH04IBi3XxF3M5XdrucOUn6Si7rShc
        HotlOklUOUwb01YYpqLxLy2YCfn7rf9akQuqfoUlL9dBR4lm
X-Google-Smtp-Source: APXvYqztfG7zgmLeBqeUW17cz6ghTeAyTxdKZTEWIbgdcZMgSWp7sNkTpHMtkBmU3JviC1ytmNIphRKqx2SrQn/VC10oZKjOOZ92
MIME-Version: 1.0
X-Received: by 2002:a92:9603:: with SMTP id g3mr8289386ilh.231.1578765850186;
 Sat, 11 Jan 2020 10:04:10 -0800 (PST)
Date:   Sat, 11 Jan 2020 10:04:10 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000af1c5b059be111e5@google.com>
Subject: general protection fault in xt_rateest_put
From:   syzbot <syzbot+91bdd8eece0f6629ec8b@syzkaller.appspotmail.com>
To:     coreteam@netfilter.org, davem@davemloft.net, fw@strlen.de,
        kadlec@netfilter.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        pablo@netfilter.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    e69ec487 Merge branch 'for-linus' of git://git.kernel.org/..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1239f876e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=18698c0c240ba616
dashboard link: https://syzkaller.appspot.com/bug?extid=91bdd8eece0f6629ec8b
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13dbd58ee00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15eff9e1e00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+91bdd8eece0f6629ec8b@syzkaller.appspotmail.com

kasan: CONFIG_KASAN_INLINE enabled
kasan: GPF could be caused by NULL-ptr deref or user memory access
general protection fault: 0000 [#1] PREEMPT SMP KASAN
CPU: 0 PID: 10213 Comm: syz-executor519 Not tainted 5.5.0-rc5-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
RIP: 0010:__read_once_size include/linux/compiler.h:199 [inline]
RIP: 0010:net_generic include/net/netns/generic.h:45 [inline]
RIP: 0010:xt_rateest_put+0xa1/0x440 net/netfilter/xt_RATEEST.c:77
Code: 85 87 01 fb 45 84 f6 0f 84 68 02 00 00 e8 37 86 01 fb 49 8d bd 68 13  
00 00 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <80> 3c 02 00 0f  
85 6c 03 00 00 4d 8b b5 68 13 00 00 e8 29 bf ed fa
RSP: 0018:ffffc90001cd7940 EFLAGS: 00010202
RAX: dffffc0000000000 RBX: ffff8880a779f700 RCX: ffffffff8673a332
RDX: 000000000000026d RSI: ffffffff8673a0b9 RDI: 0000000000001368
RBP: ffffc90001cd7970 R08: ffff8880a96b2240 R09: ffffed1015d0703d
R10: ffffed1015d0703c R11: ffff8880ae8381e3 R12: 000000000000002d
R13: 0000000000000000 R14: 0000000000000001 R15: ffffffff8673a470
FS:  00000000016ce880(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055cd48aff140 CR3: 0000000096982000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
  xt_rateest_tg_destroy+0x72/0xa0 net/netfilter/xt_RATEEST.c:175
  cleanup_entry net/ipv4/netfilter/arp_tables.c:509 [inline]
  translate_table+0x11f4/0x1d80 net/ipv4/netfilter/arp_tables.c:587
  do_replace net/ipv4/netfilter/arp_tables.c:981 [inline]
  do_arpt_set_ctl+0x317/0x650 net/ipv4/netfilter/arp_tables.c:1461
  nf_sockopt net/netfilter/nf_sockopt.c:106 [inline]
  nf_setsockopt+0x77/0xd0 net/netfilter/nf_sockopt.c:115
  ip_setsockopt net/ipv4/ip_sockglue.c:1260 [inline]
  ip_setsockopt+0xdf/0x100 net/ipv4/ip_sockglue.c:1240
  udp_setsockopt+0x68/0xb0 net/ipv4/udp.c:2639
  sock_common_setsockopt+0x94/0xd0 net/core/sock.c:3149
  __sys_setsockopt+0x261/0x4c0 net/socket.c:2117
  __do_sys_setsockopt net/socket.c:2133 [inline]
  __se_sys_setsockopt net/socket.c:2130 [inline]
  __x64_sys_setsockopt+0xbe/0x150 net/socket.c:2130
  do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x441699
Code: 18 89 d0 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 fb 13 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ffc35157368 EFLAGS: 00000246 ORIG_RAX: 0000000000000036
RAX: ffffffffffffffda RBX: 00000000004002c8 RCX: 0000000000441699
RDX: 0000000000000060 RSI: 0a02000000000000 RDI: 0000000000000003
RBP: 00000000006cb018 R08: 0000000000000430 R09: 00000000004002c8
R10: 00000000200008c0 R11: 0000000000000246 R12: 0000000000402f20
R13: 0000000000402fb0 R14: 0000000000000000 R15: 0000000000000000
Modules linked in:
---[ end trace f2341320b9d5ba2d ]---
RIP: 0010:__read_once_size include/linux/compiler.h:199 [inline]
RIP: 0010:net_generic include/net/netns/generic.h:45 [inline]
RIP: 0010:xt_rateest_put+0xa1/0x440 net/netfilter/xt_RATEEST.c:77
Code: 85 87 01 fb 45 84 f6 0f 84 68 02 00 00 e8 37 86 01 fb 49 8d bd 68 13  
00 00 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <80> 3c 02 00 0f  
85 6c 03 00 00 4d 8b b5 68 13 00 00 e8 29 bf ed fa
RSP: 0018:ffffc90001cd7940 EFLAGS: 00010202
RAX: dffffc0000000000 RBX: ffff8880a779f700 RCX: ffffffff8673a332
RDX: 000000000000026d RSI: ffffffff8673a0b9 RDI: 0000000000001368
RBP: ffffc90001cd7970 R08: ffff8880a96b2240 R09: ffffed1015d0703d
R10: ffffed1015d0703c R11: ffff8880ae8381e3 R12: 000000000000002d
R13: 0000000000000000 R14: 0000000000000001 R15: ffffffff8673a470
FS:  00000000016ce880(0000) GS:ffff8880ae900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055cd48af04c0 CR3: 0000000096982000 CR4: 00000000001406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
