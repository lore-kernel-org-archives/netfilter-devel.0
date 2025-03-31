Received: from mail-io1-f79.google.com (mail-io1-f79.google.com [209.85.166.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BD451DDC07
	for <netfilter-devel@vger.kernel.org>; Mon, 31 Mar 2025 16:26:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.79
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743438388; cv=none; b=ky/SVuwPQdmPXstniIXv2pJ1CpKVih78LpCufZX/vrIycZ0ou8b0mXPnBGtEVpUnhBoa7/D1r1pAz2GzLCklAn2CAcYziwKQUH9878UBc7tHd57IxOJin6zS3t7knb4omsRl0ghAshhYdCP2ezNzOm96ZDZUK3AlK/gghfxFB8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743438388; c=relaxed/simple;
	bh=krhqzMzyRJGboTMvJZ1x5N8zbcD9XjssP/1YS+Dvs2s=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=FPScALjRaJ0ZEwWWR/Nvq5b242gd//FkmRpV6Q0sn2WzIEPteanu7zeKZcTVcnPZYy72IlMUk2cuuNlqrj3Ns1CjAVRP4o7TVgspG2w4rQcpgPXJH8gDwyeFgwADVth2z75pR85RMEC7fltTVHS0/JaR6bK+BJ9ym/xrn/B8QV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f79.google.com with SMTP id ca18e2360f4ac-85e318dc464so870558839f.1
        for <netfilter-devel@vger.kernel.org>; Mon, 31 Mar 2025 09:26:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743438385; x=1744043185;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mz3TLPmwKhZz/v+PP8Eziw4Ts8qR9pufWd7yo3Whefw=;
        b=DnVnBzb4bOtB1gpSgG4x+CQj22I+MsEnnD34bP0wyJ+Caz8fdwOPGPIRIQhGHqd9PN
         JvUpxLKQtjp/bgyi3aU6NWmZXdO0JMFdYPDPRinFYCG17Ken/hEMrNzwqhiFnOd/aI3h
         kBl6dbyvLHWlBT0vS6Au71NHHbIAxzIG48tsQJullhDgpE+CKxB0i6yTbqnWLlfWvJAw
         jmYO4J5R1t7DJ5mIAttF5sCwp8vZVVy70JqJJw5roxI17mELGJ/jz3HU5Pj4Cc4QIAPA
         LuTypk/jE3pmoQyEG5/RFdzEnRf7NEiCCFUgqoxpf8z0bKKXMO8kkWFn6yjlcTW0o7YB
         n03Q==
X-Forwarded-Encrypted: i=1; AJvYcCUp5niLDZawXsYNSpzLrlYg/DJItjCzLSXt2VTiJfRxQx5KgeoBTR5r9MjmGIaYQdO79IWu8VrlFNCSqfDfF+A=@vger.kernel.org
X-Gm-Message-State: AOJu0YzsJpPVAUuRhXUHWUsnoWomoajVq/WJf8Oj7pVuW6mvvD4b1y4w
	VOckQBQI1UpR+IJFBwMm4lPVnl4EV9adUYSJs5MGsntHnAsx28viEtKOYXS7ienX5crR0sNdiKF
	US1qQmKukUFNR4m6NsamLkp9digX5e8gFpEM36/VL8nFD7pusR/qs4Ak=
X-Google-Smtp-Source: AGHT+IHniT1dbH2jFnDBbQerDknCGESfBUr4fqHSYAhnGi1cMHRj8xBqExGKd1dSl1cwawY/Ex4nw9ninO6VolkxynBWNXRlqwzQ
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:194e:b0:3d5:8103:1a77 with SMTP id
 e9e14a558f8ab-3d5e08eda71mr109875815ab.1.1743438385664; Mon, 31 Mar 2025
 09:26:25 -0700 (PDT)
Date: Mon, 31 Mar 2025 09:26:25 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67eac231.050a0220.3c3d88.0047.GAE@google.com>
Subject: [syzbot] [netfilter?] WARNING in __nf_unregister_net_hook (8)
From: syzbot <syzbot+53ed3a6440173ddbf499@syzkaller.appspotmail.com>
To: coreteam@netfilter.org, davem@davemloft.net, edumazet@google.com, 
	horms@kernel.org, kadlec@netfilter.org, kuba@kernel.org, 
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org, 
	netfilter-devel@vger.kernel.org, pabeni@redhat.com, pablo@netfilter.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    4e82c87058f4 Merge tag 'rust-6.15' of git://git.kernel.org..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=133ea3e4580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=f8721be6a767792
dashboard link: https://syzkaller.appspot.com/bug?extid=53ed3a6440173ddbf499
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/020d6f490695/disk-4e82c870.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/36e4561ed263/vmlinux-4e82c870.xz
kernel image: https://storage.googleapis.com/syzbot-assets/37b68c422eec/bzImage-4e82c870.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+53ed3a6440173ddbf499@syzkaller.appspotmail.com

RDX: 0000000000000000 RSI: 0000200000000080 RDI: 0000000000000003
RBP: 00007fa126d94090 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000001
R13: 0000000000000000 R14: 00007fa1261a5fa0 R15: 00007fa1262cfa28
 </TASK>
------------[ cut here ]------------
WARNING: CPU: 0 PID: 10727 at net/netfilter/core.c:501 __nf_unregister_net_hook+0x683/0x810 net/netfilter/core.c:501
Modules linked in:
CPU: 0 UID: 0 PID: 10727 Comm: syz.4.1505 Not tainted 6.14.0-syzkaller-10892-g4e82c87058f4 #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 02/12/2025
RIP: 0010:__nf_unregister_net_hook+0x683/0x810 net/netfilter/core.c:501
Code: 41 5d 41 5e 41 5f 5d e9 cb f8 74 f7 e8 06 9d 8f f7 48 83 c4 38 5b 41 5c 41 5d 41 5e 41 5f 5d c3 cc cc cc cc e8 ee 9c 8f f7 90 <0f> 0b 90 48 c7 c7 60 16 16 90 48 83 c4 38 5b 41 5c 41 5d 41 5e 41
RSP: 0018:ffffc900038cee10 EFLAGS: 00010293
RAX: ffffffff8a33e022 RBX: 0000000000000000 RCX: ffff88802b90bc00
RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000000
RBP: dffffc0000000000 R08: ffffffff8a33da61 R09: 1ffffffff20be9ce
R10: dffffc0000000000 R11: fffffbfff20be9cf R12: ffff888035670000
R13: ffff8880333ce480 R14: dffffc0000000000 R15: ffff8880573fa710
FS:  00007fa126d946c0(0000) GS:ffff888124fb1000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000200000f20030 CR3: 00000000511d4000 CR4: 00000000003526f0
Call Trace:
 <TASK>
 nf_tables_updchain+0x108e/0x1e00 net/netfilter/nf_tables_api.c:2917
 nf_tables_newchain+0x10f6/0x3390 net/netfilter/nf_tables_api.c:3039
 nfnetlink_rcv_batch net/netfilter/nfnetlink.c:524 [inline]
 nfnetlink_rcv_skb_batch net/netfilter/nfnetlink.c:647 [inline]
 nfnetlink_rcv+0x12eb/0x28f0 net/netfilter/nfnetlink.c:665
 netlink_unicast_kernel net/netlink/af_netlink.c:1313 [inline]
 netlink_unicast+0x7f8/0x9a0 net/netlink/af_netlink.c:1339
 netlink_sendmsg+0x8c3/0xcd0 net/netlink/af_netlink.c:1883
 sock_sendmsg_nosec net/socket.c:712 [inline]
 __sock_sendmsg+0x221/0x270 net/socket.c:727
 ____sys_sendmsg+0x523/0x860 net/socket.c:2566
 ___sys_sendmsg net/socket.c:2620 [inline]
 __sys_sendmsg+0x271/0x360 net/socket.c:2652
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fa125f8d169
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fa126d94038 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007fa1261a5fa0 RCX: 00007fa125f8d169
RDX: 0000000000000000 RSI: 0000200000000080 RDI: 0000000000000003
RBP: 00007fa126d94090 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000001
R13: 0000000000000000 R14: 00007fa1261a5fa0 R15: 00007fa1262cfa28
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.

If the report is already addressed, let syzbot know by replying with:
#syz fix: exact-commit-title

If you want to overwrite report's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the report is a duplicate of another one, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup
