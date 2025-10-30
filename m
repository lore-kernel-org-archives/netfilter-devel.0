Received: from mail-il1-f207.google.com (mail-il1-f207.google.com [209.85.166.207])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F5CD2D0611
	for <netfilter-devel@vger.kernel.org>; Thu, 30 Oct 2025 12:37:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761827853; cv=none; b=l7WXiadiML9bfdxMjjcrlFWgbCUpfMo1yZ3Ye80OzC8rixS8Chn74FnIYfvHmMwQD5rQ2lRxbZeayjnnI+opYCraxP8Sz0bN4n2Bf2rEwC7aIvxYyNAyIyEU1hx0jeFbwGv46SkYPtRZHerwmW7ymiWqPUvlploi0TcjjeVnIrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761827853; c=relaxed/simple;
	bh=+BEb5A3FVsu+J3Ry977bg1bez4uF76Mqs/ReUtil/A8=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=kRlBx4qvZOVOvT0b2ywPBTpXBoJcEgHpe6RJo7/cNTwfJ4Sgzh/XAAbBFnX0v1gibxuSFuZWX0IpDQDc6RjcE69W+aBIiCDxlPTDOCEvtJAo9nhTYDC/e38ZytKd/ntOP4cLgLfZTMO+P2molHpswdBQ3WzxuDZS7i8tuxxSptA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f207.google.com with SMTP id e9e14a558f8ab-431d3a4db56so33577785ab.1
        for <netfilter-devel@vger.kernel.org>; Thu, 30 Oct 2025 05:37:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761827851; x=1762432651;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=R8cwPAlKZVSjF+/N6Fi1I5B5KzPONFRHbaCRMS20ttE=;
        b=IjnKGuriHvSeN9RczGDsDI2zSGT4Hsj4VCiy5QWdSLJ4Wi6Yy3bTes+pEXFh3EFB5W
         6CIvH+L4xd9jo6Hg8ybU5vtMEPTVOabCDIq3/26FH1GcWEqJ8CaJGo7bANjEG7vPe6TM
         obdMCJ4dRYzWm8yzoDEGzeevZvjQFZsIrK69kCvaat6ftrVYMyGZh8Xw5CaP5YC4vdw2
         nxOyY/gi8P5JO4JPPYa3c6D1k3k966PDSXc7YYWKwJx1QMlnX9l9tVs27+G2A4vK38nC
         ggXAvWYJ+JH39CVtOv9U6hvYYK74VLKDV5H02lCK/NzxLO3KAEWSyTsjaJWMVJ86Fw3S
         qwjw==
X-Forwarded-Encrypted: i=1; AJvYcCVJVRniNbu05gueT9Ml4bYszK3Vu1D6YEGn369Lfo0MfJ87soF04ZVg7YGHD4G56Bgik8RJtFESbcbHXCwLIC4=@vger.kernel.org
X-Gm-Message-State: AOJu0YzyuujzIG4ovO3ow+RoHSYQ2XPQ/7avyQaqTpH1Sby4wjI0iRzi
	h/IYGYXFHXt0AZSuW8UW3VvixAawGpd9FL3Bq4+vw/C71KSQoV7L289l6GV0a+4xTF7aO+4ss+k
	JYHnDH1XSXIijXpWOey7dGcm6Sq40exm7N+krl+mWmxdkzQRqaFXygTLq3ug=
X-Google-Smtp-Source: AGHT+IHAL/7dLlSaaFS1lZzxZx7lwZe6fajDitXF2Ab8bmEqN6QMZo9ihZqPzBCwhcK3YS2VoWwHGmnITEWkc0+3wYOdFjhvw3P5
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:74a:b0:42f:983e:e54d with SMTP id
 e9e14a558f8ab-432f8f81cc3mr94139635ab.4.1761827851395; Thu, 30 Oct 2025
 05:37:31 -0700 (PDT)
Date: Thu, 30 Oct 2025 05:37:31 -0700
In-Reply-To: <6889adf3.050a0220.5d226.0002.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69035c0b.050a0220.3344a1.0441.GAE@google.com>
Subject: Re: [syzbot] [netfilter?] WARNING in __nf_unregister_net_hook (9)
From: syzbot <syzbot+78ac1e46d2966eb70fda@syzkaller.appspotmail.com>
To: coreteam@netfilter.org, davem@davemloft.net, edumazet@google.com, 
	fw@strlen.de, horms@kernel.org, kadlec@netfilter.org, kuba@kernel.org, 
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org, 
	netfilter-devel@vger.kernel.org, pabeni@redhat.com, pablo@netfilter.org, 
	phil@nwl.cc, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has found a reproducer for the following issue on:

HEAD commit:    efd3e30e651d Merge branch 'net-stmmac-hwif-c-cleanups'
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=17ea1704580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=5683686a5f7ee53f
dashboard link: https://syzkaller.appspot.com/bug?extid=78ac1e46d2966eb70fda
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12afbc92580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/a6eb09423004/disk-efd3e30e.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/f8a2fb326497/vmlinux-efd3e30e.xz
kernel image: https://storage.googleapis.com/syzbot-assets/a8cdcb8113e1/bzImage-efd3e30e.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+78ac1e46d2966eb70fda@syzkaller.appspotmail.com

------------[ cut here ]------------
hook not found, pf 5 num 0
WARNING: CPU: 1 PID: 9032 at net/netfilter/core.c:514 __nf_unregister_net_hook+0x30a/0x700 net/netfilter/core.c:514
Modules linked in:
CPU: 1 UID: 0 PID: 9032 Comm: syz.0.994 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/02/2025
RIP: 0010:__nf_unregister_net_hook+0x30a/0x700 net/netfilter/core.c:514
Code: d5 18 f8 05 01 90 48 8b 44 24 10 0f b6 04 28 84 c0 0f 85 e3 03 00 00 41 8b 17 48 c7 c7 00 72 72 8c 44 89 ee e8 67 4f 14 f8 90 <0f> 0b 90 90 e9 d8 01 00 00 e8 a8 17 d7 01 89 c3 31 ff 89 c6 e8 fd
RSP: 0018:ffffc9000c396938 EFLAGS: 00010246
RAX: a02a0e56549ab800 RBX: ffff8880583d1480 RCX: ffff888059800000
RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000002
RBP: dffffc0000000000 R08: ffff8880b8924293 R09: 1ffff11017124852
R10: dffffc0000000000 R11: ffffed1017124853 R12: ffff88807acf2480
R13: 0000000000000005 R14: ffff88802701a488 R15: ffff88807796ae3c
FS:  00007fba157656c0(0000) GS:ffff888126240000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000555576f79808 CR3: 000000007f6c4000 CR4: 00000000003526f0
Call Trace:
 <TASK>
 nft_unregister_flowtable_ops net/netfilter/nf_tables_api.c:8979 [inline]
 nft_flowtable_event net/netfilter/nf_tables_api.c:9758 [inline]
 __nf_tables_flowtable_event+0x5bf/0x8c0 net/netfilter/nf_tables_api.c:9803
 nf_tables_flowtable_event+0x103/0x160 net/netfilter/nf_tables_api.c:9834
 notifier_call_chain+0x1b6/0x3e0 kernel/notifier.c:85
 call_netdevice_notifiers_extack net/core/dev.c:2267 [inline]
 call_netdevice_notifiers net/core/dev.c:2281 [inline]
 unregister_netdevice_many_notify+0x1860/0x2390 net/core/dev.c:12333
 unregister_netdevice_many net/core/dev.c:12396 [inline]
 unregister_netdevice_queue+0x33c/0x380 net/core/dev.c:12210
 unregister_netdevice include/linux/netdevice.h:3390 [inline]
 hsr_dev_finalize+0x707/0xaa0 net/hsr/hsr_device.c:800
 hsr_newlink+0x8ad/0x9f0 net/hsr/hsr_netlink.c:128
 rtnl_newlink_create+0x310/0xb00 net/core/rtnetlink.c:3833
 __rtnl_newlink net/core/rtnetlink.c:3950 [inline]
 rtnl_newlink+0x16e4/0x1c80 net/core/rtnetlink.c:4065
 rtnetlink_rcv_msg+0x7cf/0xb70 net/core/rtnetlink.c:6951
 netlink_rcv_skb+0x208/0x470 net/netlink/af_netlink.c:2550
 netlink_unicast_kernel net/netlink/af_netlink.c:1318 [inline]
 netlink_unicast+0x82f/0x9e0 net/netlink/af_netlink.c:1344
 netlink_sendmsg+0x805/0xb30 net/netlink/af_netlink.c:1894
 sock_sendmsg_nosec net/socket.c:727 [inline]
 __sock_sendmsg+0x21c/0x270 net/socket.c:742
 ____sys_sendmsg+0x505/0x830 net/socket.c:2630
 ___sys_sendmsg+0x21f/0x2a0 net/socket.c:2684
 __sys_sendmsg net/socket.c:2716 [inline]
 __do_sys_sendmsg net/socket.c:2721 [inline]
 __se_sys_sendmsg net/socket.c:2719 [inline]
 __x64_sys_sendmsg+0x19b/0x260 net/socket.c:2719
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fba1498efc9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fba15765038 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007fba14be5fa0 RCX: 00007fba1498efc9
RDX: 0000000000000000 RSI: 00002000000000c0 RDI: 0000000000000005
RBP: 00007fba14a11f91 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fba14be6038 R14: 00007fba14be5fa0 R15: 00007ffcbfaff8c8
 </TASK>


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.
