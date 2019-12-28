Return-Path: <SRS0=8lzl=2S=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.4 required=3.0 tests=FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19878C2D0CE
	for <netfilter-devel@archiver.kernel.org>; Sat, 28 Dec 2019 06:15:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ED3D920838
	for <netfilter-devel@archiver.kernel.org>; Sat, 28 Dec 2019 06:15:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726045AbfL1GPK (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 28 Dec 2019 01:15:10 -0500
Received: from mail-il1-f198.google.com ([209.85.166.198]:52382 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725857AbfL1GPK (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 28 Dec 2019 01:15:10 -0500
Received: by mail-il1-f198.google.com with SMTP id n9so23696571ilm.19
        for <netfilter-devel@vger.kernel.org>; Fri, 27 Dec 2019 22:15:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=2HOXPV+14RU9R447cOV0dBvVZbunalY8Ec32XNcdQ0Y=;
        b=VydwssPbxHph9+l2agGl/1NuA+/Mweje1kqV6PUpJp3NDvaw5FREft5LLWp+Aec3NT
         GRAQHR/jHCegs9VrtC0UNVNlJ1rXtq/2bepSaayiSJbe4Fo93jzw+4AqI+79bOMvxXvt
         QOZqz6pPsXepcV+q1BvD6C0hzavkGgVkdA5p5OQknJ4REPyOMvJWnO2gcmmBQV6svPOa
         i0btVF6qmo6l/+qXEodqimFZtW0IdhR3RtgH5zEWYfcRFYCHRJ8D2prgJokOyiCxA+H3
         sUr0G6QPWGrkUcUCJq/k0JJ7sodISLnHj0cuv/y5a1t9+zko4RywucOdQj7UWYQmiL5K
         6AIw==
X-Gm-Message-State: APjAAAXNy/DfFpgmvn18yoI4Cl0tQ4vfM4B6MRIeuSF7FaOQTj2DR118
        Li1MbZBDwcKtMPwNv7gBEWiPePbHMPXsy/v2xOcqyVekGwWG
X-Google-Smtp-Source: APXvYqxckNFrsGfJfYnb+Vcaqz+NOfZ27b0QhIttqwc3dJbOO0t/9X2f0QIiNwKOeX7r1sF44MKOobbKleutPxYIBgGUAetvq61l
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1014:: with SMTP id n20mr47443147ilj.172.1577513709408;
 Fri, 27 Dec 2019 22:15:09 -0800 (PST)
Date:   Fri, 27 Dec 2019 22:15:09 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000004718ff059abd88ef@google.com>
Subject: general protection fault in nf_ct_netns_do_get
From:   syzbot <syzbot+19616eedf6fd8e241e50@syzkaller.appspotmail.com>
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
console output: https://syzkaller.appspot.com/x/log.txt?x=14188971e00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=ed9d672709340e35
dashboard link: https://syzkaller.appspot.com/bug?extid=19616eedf6fd8e241e50
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14a47ab9e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=170f2485e00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+19616eedf6fd8e241e50@syzkaller.appspotmail.com

kasan: CONFIG_KASAN_INLINE enabled
kasan: GPF could be caused by NULL-ptr deref or user memory access
general protection fault: 0000 [#1] PREEMPT SMP KASAN
CPU: 0 PID: 9171 Comm: syz-executor797 Not tainted 5.5.0-rc3-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
RIP: 0010:__read_once_size include/linux/compiler.h:199 [inline]
RIP: 0010:net_generic include/net/netns/generic.h:45 [inline]
RIP: 0010:nf_ct_netns_do_get+0xd2/0x7e0  
net/netfilter/nf_conntrack_proto.c:449
Code: 22 22 fb 45 84 f6 0f 84 5c 03 00 00 e8 07 21 22 fb 49 8d bc 24 68 13  
00 00 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <80> 3c 02 00 0f  
85 9f 06 00 00 4d 8b b4 24 68 13 00 00 e8 47 59 0e
RSP: 0018:ffffc90001f177a8 EFLAGS: 00010202
RAX: dffffc0000000000 RBX: 0000000000000003 RCX: ffffffff86531056
RDX: 000000000000026d RSI: ffffffff86530ce9 RDI: 0000000000001368
RBP: ffffc90001f177e8 R08: ffff88808fd96200 R09: ffffed1015d0703d
R10: ffffed1015d0703c R11: ffff8880ae8381e3 R12: 0000000000000000
R13: 000000000000002a R14: 0000000000000001 R15: 0000000000000003
FS:  00000000009fd880(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000200008a0 CR3: 0000000093cc3000 CR4: 00000000001406f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
  nf_ct_netns_get+0x41/0x150 net/netfilter/nf_conntrack_proto.c:601
  connmark_tg_check+0x61/0xe0 net/netfilter/xt_connmark.c:106
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
RIP: 0033:0x441369
Code: 18 89 d0 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 fb 13 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ffed53f1838 EFLAGS: 00000246 ORIG_RAX: 0000000000000036
RAX: ffffffffffffffda RBX: 00000000004002c8 RCX: 0000000000441369
RDX: 0000000000000060 RSI: 0a02000000000000 RDI: 0000000000000003
RBP: 00000000006cb018 R08: 0000000000000418 R09: 00000000004002c8
R10: 0000000020000880 R11: 0000000000000246 R12: 0000000000402bf0
R13: 0000000000402c80 R14: 0000000000000000 R15: 0000000000000000
Modules linked in:
---[ end trace 86b70d3f20194272 ]---
RIP: 0010:__read_once_size include/linux/compiler.h:199 [inline]
RIP: 0010:net_generic include/net/netns/generic.h:45 [inline]
RIP: 0010:nf_ct_netns_do_get+0xd2/0x7e0  
net/netfilter/nf_conntrack_proto.c:449
Code: 22 22 fb 45 84 f6 0f 84 5c 03 00 00 e8 07 21 22 fb 49 8d bc 24 68 13  
00 00 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <80> 3c 02 00 0f  
85 9f 06 00 00 4d 8b b4 24 68 13 00 00 e8 47 59 0e
RSP: 0018:ffffc90001f177a8 EFLAGS: 00010202
RAX: dffffc0000000000 RBX: 0000000000000003 RCX: ffffffff86531056
RDX: 000000000000026d RSI: ffffffff86530ce9 RDI: 0000000000001368
RBP: ffffc90001f177e8 R08: ffff88808fd96200 R09: ffffed1015d0703d
R10: ffffed1015d0703c R11: ffff8880ae8381e3 R12: 0000000000000000
R13: 000000000000002a R14: 0000000000000001 R15: 0000000000000003
FS:  00000000009fd880(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000200008a0 CR3: 0000000093cc3000 CR4: 00000000001406f0
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
