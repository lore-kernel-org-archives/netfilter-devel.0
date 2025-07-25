Received: from mail-io1-f80.google.com (mail-io1-f80.google.com [209.85.166.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 944DF137923
	for <netfilter-devel@vger.kernel.org>; Fri, 25 Jul 2025 12:46:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753447593; cv=none; b=gzB0XC42CeZ8+5FEsUGhLNf6gZGUAlV1nHM6KPBAHbcg+OlgpCLZlmXHVcvUnmfRz2ZZ+beYrpXZ4yYx/gvXDzH5iv7wvOU2gOB/TzxOoCWSGei1Z8H8fhuKFFuIY5JXEoXtRwK85jzACNhGY+i4BOMzrJLiZQiluSndSB518P4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753447593; c=relaxed/simple;
	bh=qm7IYgwWsCevniBDmNoxwlw3iwTZXJXBKMafkaJPtwA=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=Sbh27yrYP0RCdMl15YkWe9QBoPHlXvIBETSLsvoEd1IXpSat2f6OkALG7gc+humeOrkrHWgMu0hzNcDaKZroeWkTYY4aFjqd5dCGphKfKqwr51IvZK2acR3wmryIpojCULHhvwWCjA0kXPJLot3YArHH6HRuIBSYpHHlPQ+oF8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f80.google.com with SMTP id ca18e2360f4ac-87c1d70dabdso222528339f.1
        for <netfilter-devel@vger.kernel.org>; Fri, 25 Jul 2025 05:46:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753447591; x=1754052391;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=RcOwnNkGMbRm/SAGPNDv3FvzOSvBQBAw0vpb+6DYIB4=;
        b=K6CQLHZJGcq7D5895IvGug037seBoZcp+Ou4lZMFc+YPIsWyuEUe731XQDwQx4zdgi
         T7liS5OXg+2Cr2bWKkHR+lQ0ASAat0gZXxAWl7T6IN2HQDmNllhVVvI9vmPtZMqlhAYZ
         d6NPxuHkFYWIaSxvHUTKB0uLMBF+wB/hqqGNO39TfVeE+4QjX6r/mJemEDrh4N3qrqOn
         LixM78/Ya9eh29SOmea3N9FzjAkSQsnt9nG1UyM8PTxz09qCmRJExAde0Gm/C4KE+01O
         z9lS8NU0a3U+5075fL9CgivseoJSe+TckkELu+cKylo9qCL3tQztK0RTJDNHHbgCAopO
         lPKA==
X-Forwarded-Encrypted: i=1; AJvYcCXyrBNvZgXGLAz1UMRWRhEy5G6zDJnAW/Q+PlhGojLTikjmgPIVy0CuvliKNSX9SnaxLqoN4juppMtQYLKPxro=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw/lkGM8HVPLMH3S3FnWTnnMMYdvFteK+3yW4/QPe+fr6ZGmZ7b
	atIUzGWntGNzPKO5eldERaFp6tmHT/Lf8njYgYuPP44E2pWu7IfkVS4wGPCt7McKMG9A+Pnm/aj
	rdqJ1Z17QeyHUNsecF5Dy3+2VVJ/9NPsKDG5IMfXp5FUwmmqnc40sbwlhmzw=
X-Google-Smtp-Source: AGHT+IGhLJ7WPISWlkBBKk0VG56ANSua07lRzc2p1rbmGsljUveQsfjYLhKQDFiB+gfn/k2x9EC/enz4YR91PiOq4KT2/m3G+lxl
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:158b:b0:3df:3110:cc01 with SMTP id
 e9e14a558f8ab-3e3c531f7aemr25617085ab.19.1753447590693; Fri, 25 Jul 2025
 05:46:30 -0700 (PDT)
Date: Fri, 25 Jul 2025 05:46:30 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68837ca6.a00a0220.2f88df.0053.GAE@google.com>
Subject: [syzbot] [netfilter?] WARNING in nft_socket_init (2)
From: syzbot <syzbot+a225fea35d7baf8dbdc3@syzkaller.appspotmail.com>
To: coreteam@netfilter.org, davem@davemloft.net, edumazet@google.com, 
	horms@kernel.org, kadlec@netfilter.org, kuba@kernel.org, 
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org, 
	netfilter-devel@vger.kernel.org, pabeni@redhat.com, pablo@netfilter.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    94619ea2d933 Merge tag 'ipsec-next-2025-07-23' of git://gi..
git tree:       net-next
console+strace: https://syzkaller.appspot.com/x/log.txt?x=14bf10a2580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=ceda48240b85ec34
dashboard link: https://syzkaller.appspot.com/bug?extid=a225fea35d7baf8dbdc3
compiler:       Debian clang version 20.1.7 (++20250616065708+6146a88f6049-1~exp1~20250616065826.132), Debian LLD 20.1.7
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12bf10a2580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13d27fd4580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/afd64d9816ee/disk-94619ea2.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/e1755ce1f83b/vmlinux-94619ea2.xz
kernel image: https://storage.googleapis.com/syzbot-assets/2061dff2fbf4/bzImage-94619ea2.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+a225fea35d7baf8dbdc3@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 0 PID: 5853 at net/netfilter/nft_socket.c:220 nft_socket_init+0x2f4/0x3d0 net/netfilter/nft_socket.c:220
Modules linked in:
CPU: 0 UID: 0 PID: 5853 Comm: syz-executor145 Not tainted 6.16.0-rc6-syzkaller-01673-g94619ea2d933 #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/12/2025
RIP: 0010:nft_socket_init+0x2f4/0x3d0 net/netfilter/nft_socket.c:220
Code: 84 c0 0f 85 da 00 00 00 41 88 2c 24 bd 08 00 00 00 e9 ad fe ff ff 89 f3 e8 29 86 07 f8 89 d8 e9 57 ff ff ff e8 1d 86 07 f8 90 <0f> 0b 90 e9 44 ff ff ff 89 e9 80 e1 07 38 c1 0f 8c 87 fd ff ff 48
RSP: 0018:ffffc9000401f178 EFLAGS: 00010293
RAX: ffffffff89b8a433 RBX: ffff888077f68020 RCX: ffff888030a8da00
RDX: 0000000000000000 RSI: 0000000000000100 RDI: 00000000000000ff
RBP: 00000000000000ff R08: 0000000000000000 R09: ffffffff89b8b21c
R10: dffffc0000000000 R11: ffffed10299a8e5b R12: 0000000000000100
R13: ffff8880352ec898 R14: dffffc0000000000 R15: 1ffff1100efed004
FS:  000055555942b380(0000) GS:ffff888125c15000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000200000000000 CR3: 0000000034702000 CR4: 00000000003526f0
Call Trace:
 <TASK>
 nf_tables_newexpr net/netfilter/nf_tables_api.c:3496 [inline]
 nf_tables_newrule+0x178f/0x2890 net/netfilter/nf_tables_api.c:4327
 nfnetlink_rcv_batch net/netfilter/nfnetlink.c:524 [inline]
 nfnetlink_rcv_skb_batch net/netfilter/nfnetlink.c:647 [inline]
 nfnetlink_rcv+0x112f/0x2520 net/netfilter/nfnetlink.c:665
 netlink_unicast_kernel net/netlink/af_netlink.c:1320 [inline]
 netlink_unicast+0x82c/0x9e0 net/netlink/af_netlink.c:1346
 netlink_sendmsg+0x805/0xb30 net/netlink/af_netlink.c:1896
 sock_sendmsg_nosec net/socket.c:714 [inline]
 __sock_sendmsg+0x219/0x270 net/socket.c:729
 ____sys_sendmsg+0x505/0x830 net/socket.c:2614
 ___sys_sendmsg+0x21f/0x2a0 net/socket.c:2668
 __sys_sendmsg net/socket.c:2700 [inline]
 __do_sys_sendmsg net/socket.c:2705 [inline]
 __se_sys_sendmsg net/socket.c:2703 [inline]
 __x64_sys_sendmsg+0x19b/0x260 net/socket.c:2703
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7efdcf55c0e9
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 61 18 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fff48ea8a28 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 00007efdcf55c0e9
RDX: 0000000000000000 RSI: 0000200000000000 RDI: 0000000000000003
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007efdcf5a5036
R13: 00007fff48ea8a60 R14: 00007fff48ea8aa0 R15: 0000000000000000
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.

If the report is already addressed, let syzbot know by replying with:
#syz fix: exact-commit-title

If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.

If you want to overwrite report's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the report is a duplicate of another one, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup
