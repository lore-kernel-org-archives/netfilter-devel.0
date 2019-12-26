Return-Path: <SRS0=nsnV=2Q=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.4 required=3.0 tests=FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F966C2D0DC
	for <netfilter-devel@archiver.kernel.org>; Thu, 26 Dec 2019 21:15:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5DC7E20838
	for <netfilter-devel@archiver.kernel.org>; Thu, 26 Dec 2019 21:15:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726442AbfLZVPM (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 26 Dec 2019 16:15:12 -0500
Received: from mail-il1-f199.google.com ([209.85.166.199]:35603 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726105AbfLZVPM (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 26 Dec 2019 16:15:12 -0500
Received: by mail-il1-f199.google.com with SMTP id h18so7342580ilc.2
        for <netfilter-devel@vger.kernel.org>; Thu, 26 Dec 2019 13:15:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=ik7b2s7WamGplClGQL+MsIJ1UBXlFPSq+eZNryAWeT8=;
        b=W769JdcvDyC5IBFDHLtcEdmHm0lYkojW8NH9lQxaX8teFsgNifCoVSovv5NsVoyk2E
         sQAqHQXYkTrVAp4tLOQfatriJxDojAMJZEIRFI8x2DE03/mZD3RI2ZJ7l9OkhUn2Bb6+
         hp6EtHM83rpNQG/z77MXOY8ggUBGwnf4BDzrLrU9jOJeGQsCrWuZihujXTfeRxkaVI9S
         7vWQcvT5yY7QMy7cszWid1JGo0mvH8VUDVdSizeFLcWaQY6CcYHo4UQESLMX6ftkpzwt
         ETlBZr+zhCzVa0o8OiaPNwD+zco0ZNV3ERxrsDDIEGmTDRqcuMLuaD+EBy6AZiiQ1L1+
         MJ7g==
X-Gm-Message-State: APjAAAXqkXsnE4jEN3/raBCVWtCgSpzL3VjE4tm9QE7A0IywLUnjDLm2
        GtAus/Snk4K79FmsxyuuTzK5ioVpLVRiMNzBW54RH/ERD7L/
X-Google-Smtp-Source: APXvYqzOUFxyaFo/BSJwAwjfs5XthFXahdFTkxNZEQ52cHWHlC/OE2bQJTqfvDR4XfcOo9H+0+Vleg+DKMe5Auvniu5xQQcQpq3m
MIME-Version: 1.0
X-Received: by 2002:a92:d80f:: with SMTP id y15mr41770448ilm.225.1577394911048;
 Thu, 26 Dec 2019 13:15:11 -0800 (PST)
Date:   Thu, 26 Dec 2019 13:15:11 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000057fd27059aa1dfca@google.com>
Subject: general protection fault in xt_rateest_tg_checkentry
From:   syzbot <syzbot+d7358a458d8a81aee898@syzkaller.appspotmail.com>
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

HEAD commit:    46cf053e Linux 5.5-rc3
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=11775799e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=ed9d672709340e35
dashboard link: https://syzkaller.appspot.com/bug?extid=d7358a458d8a81aee898
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13713ec1e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1272ba49e00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+d7358a458d8a81aee898@syzkaller.appspotmail.com

kasan: CONFIG_KASAN_INLINE enabled
kasan: GPF could be caused by NULL-ptr deref or user memory access
general protection fault: 0000 [#1] PREEMPT SMP KASAN
CPU: 1 PID: 9188 Comm: syz-executor670 Not tainted 5.5.0-rc3-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
RIP: 0010:__read_once_size include/linux/compiler.h:199 [inline]
RIP: 0010:net_generic include/net/netns/generic.h:45 [inline]
RIP: 0010:xt_rateest_tg_checkentry+0x11d/0xb40  
net/netfilter/xt_RATEEST.c:109
Code: d9 f2 0d fb 45 84 f6 0f 84 08 07 00 00 e8 8b f1 0d fb 49 8d bd 68 13  
00 00 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <80> 3c 02 00 0f  
85 f4 08 00 00 4d 8b ad 68 13 00 00 e8 cd 29 fa fa
RSP: 0018:ffffc90001df7788 EFLAGS: 00010202
RAX: dffffc0000000000 RBX: ffffc90001df7ae8 RCX: ffffffff8667437e
RDX: 000000000000026d RSI: ffffffff86673c65 RDI: 0000000000001368
RBP: ffffc90001df7848 R08: ffff888093e48540 R09: ffffed1015d2703d
R10: ffffed1015d2703c R11: ffff8880ae9381e3 R12: 000000000000002d
R13: 0000000000000000 R14: 0000000000000001 R15: ffffc90001df7820
FS:  0000000001250880(0000) GS:ffff8880ae900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020000820 CR3: 000000008f27a000 CR4: 00000000001406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
  xt_check_target+0x283/0x690 net/netfilter/x_tables.c:1019
  check_target net/ipv4/netfilter/arp_tables.c:399 [inline]
  find_check_entry net/ipv4/netfilter/arp_tables.c:422 [inline]
  translate_table+0x1005/0x1d70 net/ipv4/netfilter/arp_tables.c:572
  do_replace net/ipv4/netfilter/arp_tables.c:977 [inline]
  do_arpt_set_ctl+0x310/0x640 net/ipv4/netfilter/arp_tables.c:1456
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
RIP: 0033:0x4414d9
Code: 18 89 d0 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 fb 13 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007fff75392588 EFLAGS: 00000246 ORIG_RAX: 0000000000000036
RAX: ffffffffffffffda RBX: 00000000004002c8 RCX: 00000000004414d9
RDX: 0000000000000060 RSI: 0a02000000000000 RDI: 0000000000000003
RBP: 00000000006cb018 R08: 0000000000000530 R09: 00000000004002c8
R10: 0000000020000800 R11: 0000000000000246 R12: 0000000000402d60
R13: 0000000000402df0 R14: 0000000000000000 R15: 0000000000000000
Modules linked in:
---[ end trace 6eeb34579322f089 ]---
RIP: 0010:__read_once_size include/linux/compiler.h:199 [inline]
RIP: 0010:net_generic include/net/netns/generic.h:45 [inline]
RIP: 0010:xt_rateest_tg_checkentry+0x11d/0xb40  
net/netfilter/xt_RATEEST.c:109
Code: d9 f2 0d fb 45 84 f6 0f 84 08 07 00 00 e8 8b f1 0d fb 49 8d bd 68 13  
00 00 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <80> 3c 02 00 0f  
85 f4 08 00 00 4d 8b ad 68 13 00 00 e8 cd 29 fa fa
RSP: 0018:ffffc90001df7788 EFLAGS: 00010202
RAX: dffffc0000000000 RBX: ffffc90001df7ae8 RCX: ffffffff8667437e
RDX: 000000000000026d RSI: ffffffff86673c65 RDI: 0000000000001368
RBP: ffffc90001df7848 R08: ffff888093e48540 R09: ffffed1015d2703d
R10: ffffed1015d2703c R11: ffff8880ae9381e3 R12: 000000000000002d
R13: 0000000000000000 R14: 0000000000000001 R15: ffffc90001df7820
FS:  0000000001250880(0000) GS:ffff8880ae900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020000820 CR3: 000000008f27a000 CR4: 00000000001406e0
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
