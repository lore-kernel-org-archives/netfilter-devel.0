Return-Path: <SRS0=uN83=25=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4AF59C00523
	for <netfilter-devel@archiver.kernel.org>; Wed,  8 Jan 2020 09:14:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 21FA120705
	for <netfilter-devel@archiver.kernel.org>; Wed,  8 Jan 2020 09:14:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727726AbgAHJOt (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 8 Jan 2020 04:14:49 -0500
Received: from mail-io1-f69.google.com ([209.85.166.69]:46334 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727309AbgAHJOM (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 8 Jan 2020 04:14:12 -0500
Received: by mail-io1-f69.google.com with SMTP id p206so1646115iod.13
        for <netfilter-devel@vger.kernel.org>; Wed, 08 Jan 2020 01:14:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=/uO82xDBk2WBy3cOZ2CTJOymO5KhzS54ieTzLDz1jec=;
        b=Q1SfoN92cpMiYT/IxRjpT5Rq2EByD68bhM3ja5/rzIetp4aMqVU0mdSxYw2VnTcbiz
         OJBpI8qljuky3etaGXoOJqXhbZh5iBKNMU/secwnSwH+ML3bG4S1NNdA1jfO4+IEr9QZ
         vj8IjBjEdS1C32sILpTFWkthKweRsgaCJMCXLeu88rMkjRywvVhkjS+06icMmRWTOWTE
         1C9lO/G3RUnlX7bHByqvarA8SXLWBgB4zaW+EJTIux9tnILQ3DlJXUOD+fVUL7PZGxW+
         P42+A+czvaVcV5wePd8JLmT7T09ovS+IRELw66gdhwbKnXsYqTqySTc/ld4Du/dGizu5
         lmFQ==
X-Gm-Message-State: APjAAAVwkE3pjrBud9f8qmGA8/thPprS0ufkhbg9pWxCmOCboojtOTx/
        6aFYirTFch0DkDNkgUdUDoaHEVa06bxmb82YmZFJ3mFh7y9g
X-Google-Smtp-Source: APXvYqw2L9C8CpHA5YgsUfif3sTfs7HNFB/m8SkJCGP1SypA2Dts/yg3BoLJ7zuOOKKWnZfnElEzwF9D9GyoqRS49xmYO44EFqa8
MIME-Version: 1.0
X-Received: by 2002:a92:d902:: with SMTP id s2mr3175478iln.223.1578474851824;
 Wed, 08 Jan 2020 01:14:11 -0800 (PST)
Date:   Wed, 08 Jan 2020 01:14:11 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000d47ca7059b9d5016@google.com>
Subject: general protection fault in hash_ip4_uadt
From:   syzbot <syzbot+0be5fe9e46479a332a4a@syzkaller.appspotmail.com>
To:     allison@lohutok.net, coreteam@netfilter.org, davem@davemloft.net,
        fw@strlen.de, gregkh@linuxfoundation.org, info@metux.net,
        jeremy@azazel.net, kadlec@blackhole.kfki.hu, kadlec@netfilter.org,
        kstewart@linuxfoundation.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        pablo@netfilter.org, syzkaller-bugs@googlegroups.com,
        tglx@linutronix.de
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    c101fffc Merge tag 'mlx5-fixes-2020-01-06' of git://git.ke..
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=11b2e656e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=f2f3ef188b7e16cf
dashboard link: https://syzkaller.appspot.com/bug?extid=0be5fe9e46479a332a4a
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=114d8eb9e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1157d076e00000

The bug was bisected to:

commit 23c42a403a9cfdbad6004a556c927be7dd61a8ee
Author: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Date:   Sat Oct 27 13:07:40 2018 +0000

     netfilter: ipset: Introduction of new commands and protocol version 7

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=10b5963ee00000
final crash:    https://syzkaller.appspot.com/x/report.txt?x=12b5963ee00000
console output: https://syzkaller.appspot.com/x/log.txt?x=14b5963ee00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+0be5fe9e46479a332a4a@syzkaller.appspotmail.com
Fixes: 23c42a403a9c ("netfilter: ipset: Introduction of new commands and  
protocol version 7")

kasan: CONFIG_KASAN_INLINE enabled
kasan: GPF could be caused by NULL-ptr deref or user memory access
general protection fault: 0000 [#1] PREEMPT SMP KASAN
CPU: 0 PID: 9507 Comm: syz-executor675 Not tainted 5.5.0-rc4-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
RIP: 0010:hash_ip4_uadt+0x1f5/0x7a0 net/netfilter/ipset/ip_set_hash_ip.c:108
Code: 48 89 f8 83 e0 07 83 c0 03 38 d0 7c 08 84 d2 0f 85 10 05 00 00 48 89  
da 45 8b 7f 04 48 b8 00 00 00 00 00 fc ff df 48 c1 ea 03 <0f> b6 14 02 48  
89 d8 83 e0 07 83 c0 03 38 d0 7c 08 84 d2 0f 85 ec
RSP: 0018:ffffc90001ec7190 EFLAGS: 00010246
RAX: dffffc0000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffffffff86793b82 RDI: ffff888091ab98f4
RBP: ffffc90001ec72b8 R08: 0000000000000000 R09: 0000000000000000
R10: ffffed1015d0703c R11: ffff8880ae8381e3 R12: ffff8880a4b87b00
R13: ffffc90001ec7320 R14: 0000000000000002 R15: 000000009b000000
FS:  0000000000e7e880(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020000446 CR3: 000000008e30e000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
  ip_set_utest+0x55b/0x890 net/netfilter/ipset/ip_set_core.c:1867
  nfnetlink_rcv_msg+0xcf2/0xfb0 net/netfilter/nfnetlink.c:229
  netlink_rcv_skb+0x177/0x450 net/netlink/af_netlink.c:2477
  nfnetlink_rcv+0x1ba/0x460 net/netfilter/nfnetlink.c:563
  netlink_unicast_kernel net/netlink/af_netlink.c:1302 [inline]
  netlink_unicast+0x58c/0x7d0 net/netlink/af_netlink.c:1328
  netlink_sendmsg+0x91c/0xea0 net/netlink/af_netlink.c:1917
  sock_sendmsg_nosec net/socket.c:639 [inline]
  sock_sendmsg+0xd7/0x130 net/socket.c:659
  ____sys_sendmsg+0x753/0x880 net/socket.c:2330
  ___sys_sendmsg+0x100/0x170 net/socket.c:2384
  __sys_sendmsg+0x105/0x1d0 net/socket.c:2417
  __do_sys_sendmsg net/socket.c:2426 [inline]
  __se_sys_sendmsg net/socket.c:2424 [inline]
  __x64_sys_sendmsg+0x78/0xb0 net/socket.c:2424
  do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x440af9
Code: 18 89 d0 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 fb 13 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ffe6e1212b8 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00000000004002c8 RCX: 0000000000440af9
RDX: 0000000000000000 RSI: 0000000020000500 RDI: 0000000000000005
RBP: 00000000006cb018 R08: 0000000000000014 R09: 00000000004002c8
R10: 0000000000000018 R11: 0000000000000246 R12: 0000000000402380
R13: 0000000000402410 R14: 0000000000000000 R15: 0000000000000000
Modules linked in:
---[ end trace 3e5ca24b710cd584 ]---
RIP: 0010:hash_ip4_uadt+0x1f5/0x7a0 net/netfilter/ipset/ip_set_hash_ip.c:108
Code: 48 89 f8 83 e0 07 83 c0 03 38 d0 7c 08 84 d2 0f 85 10 05 00 00 48 89  
da 45 8b 7f 04 48 b8 00 00 00 00 00 fc ff df 48 c1 ea 03 <0f> b6 14 02 48  
89 d8 83 e0 07 83 c0 03 38 d0 7c 08 84 d2 0f 85 ec
RSP: 0018:ffffc90001ec7190 EFLAGS: 00010246
RAX: dffffc0000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffffffff86793b82 RDI: ffff888091ab98f4
RBP: ffffc90001ec72b8 R08: 0000000000000000 R09: 0000000000000000
R10: ffffed1015d0703c R11: ffff8880ae8381e3 R12: ffff8880a4b87b00
R13: ffffc90001ec7320 R14: 0000000000000002 R15: 000000009b000000
FS:  0000000000e7e880(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020000446 CR3: 000000008e30e000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches
