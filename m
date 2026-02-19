Received: from mail-oo1-f72.google.com (mail-oo1-f72.google.com [209.85.161.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 216CA2F1FEA
	for <netfilter-devel@vger.kernel.org>; Thu, 19 Feb 2026 09:53:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771494807; cv=none; b=G4CIeDjxCu8XZ7LwtaLXGKhxzorQGWveJOGCyRuZ1V0JUVSQsMwzdOaZwz/ZOghdPfhW7qZICoX7HG9l+wufAaWm4n0QX6dwqpzlSBgFQTcyCGgLfb7bTVhI3f8guU7CTEyiRTv90W9WOivJ2Hf+OMhEV9seHIyPKzfcBq4FK6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771494807; c=relaxed/simple;
	bh=Dhduq9xuVvgA8DtpWSl04RjzTY7h43inAglIIusU1cI=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=TSGcj3h0/FzJheWE/zkkbXwrIGMCnF53EqJmf+pbGdUb6hPj1A26HaiswPS++0Pidh9+msZWTLGp7hWwllNGrVNLAcrnQ5K9qXs1w/jSmt5hCPVEvVgymFHRxr70lA+eK0jj9SmwenO29mcDC218aUDW6suaN2MXoRXxeCkFhcE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f72.google.com with SMTP id 006d021491bc7-679a409a175so9299648eaf.1
        for <netfilter-devel@vger.kernel.org>; Thu, 19 Feb 2026 01:53:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771494805; x=1772099605;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zGZKkrB6oOUdLIAR0DUc8CPC0P4InXVzgpiay4MkPXc=;
        b=SpO1iy5IfkMi+kv8IVM0eKvInFTgGJEE6OGnrnlMT7OMG0kwrf1KDPWDVhY15vSVxo
         vZu3Y8GCHIccjyNvI3zCI4QoQfCmkkHnQzHpJckKx6FMq7VtL1oOByeeqW3bsYSnjZ1u
         47Py14X+63DE6AKpYTyddP/jeqPJf7HkXrYHdw3DnFwEUiIVN7qB9SkfQTeqrbpgtamv
         hPDOzznrpcXP5z4UY8ucpANmGWocGhdXDjELZvDUNlzTUINeht5DBB0cvD7IFWV3vSw+
         ovMqEooK/RuR7iAOHV7SNaMPcTVSJJaeII7JUhVT1UDJmAIZivyQQ7NXHiGltwZEE/AK
         HjvQ==
X-Forwarded-Encrypted: i=1; AJvYcCVg43qbYy2xvu6QgUvlLmtKDPPk+dQDvFeOeZcR9MPfggpgfBVq5/UOyvQcN3V1l1dYu5nDh69tQRQ6Hk2ZLJ0=@vger.kernel.org
X-Gm-Message-State: AOJu0YwfOFNV37aaEI/1genTS6/3YI2QMkTsKi1a7f4wK94NXUCtYT1b
	95q6eGBU9ts3/Y6/eQr7nX2IIDQu2X+d2oTngsJte5Fu1QncsHJl78ruwseE7LabsjEPS1rDz1M
	tmqqSrfJXfQtwmNVjVpW/n8DBMFKJnNo7D7bQISWYZVsheWo5HGvv62drkaQ=
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:4b01:b0:679:a4bc:9f8f with SMTP id
 006d021491bc7-679a4bca251mr3116067eaf.61.1771494805102; Thu, 19 Feb 2026
 01:53:25 -0800 (PST)
Date: Thu, 19 Feb 2026 01:53:25 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6996dd95.050a0220.21cd75.010c.GAE@google.com>
Subject: [syzbot] [netfilter?] WARNING in nft_map_deactivate
From: syzbot <syzbot+4924a0edc148e8b4b342@syzkaller.appspotmail.com>
To: coreteam@netfilter.org, davem@davemloft.net, edumazet@google.com, 
	fw@strlen.de, horms@kernel.org, kuba@kernel.org, linux-kernel@vger.kernel.org, 
	netdev@vger.kernel.org, netfilter-devel@vger.kernel.org, pabeni@redhat.com, 
	pablo@netfilter.org, phil@nwl.cc, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    4c51f90d45dc selftests/bpf: Add powerpc support for get_pr..
git tree:       bpf-next
console output: https://syzkaller.appspot.com/x/log.txt?x=159e5aaa580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=6d9e410399043c26
dashboard link: https://syzkaller.appspot.com/bug?extid=4924a0edc148e8b4b342
compiler:       Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13437652580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1250a7b2580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/173ab67d0a10/disk-4c51f90d.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/9c8787b7cc0e/vmlinux-4c51f90d.xz
kernel image: https://storage.googleapis.com/syzbot-assets/bf9799a7764a/bzImage-4c51f90d.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+4924a0edc148e8b4b342@syzkaller.appspotmail.com

R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000001
R13: 00007fb5ea615fac R14: 00007fb5ea615fa0 R15: 00007fb5ea615fa0
 </TASK>
------------[ cut here ]------------
iter.err
WARNING: net/netfilter/nf_tables_api.c:845 at nft_map_deactivate+0x34e/0x3c0 net/netfilter/nf_tables_api.c:845, CPU#0: syz.0.17/5992
Modules linked in:
CPU: 0 UID: 0 PID: 5992 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 02/12/2026
RIP: 0010:nft_map_deactivate+0x34e/0x3c0 net/netfilter/nf_tables_api.c:845
Code: 8b 05 86 5a 4e 09 48 3b 84 24 a0 00 00 00 75 62 48 8d 65 d8 5b 41 5c 41 5d 41 5e 41 5f 5d c3 cc cc cc cc cc e8 63 6d fa f7 90 <0f> 0b 90 43 80 7c 35 00 00 0f 85 23 fe ff ff e9 26 fe ff ff 89 d9
RSP: 0018:ffffc900045af780 EFLAGS: 00010293
RAX: ffffffff89ca45bd RBX: 00000000fffffff4 RCX: ffff888028111e40
RDX: 0000000000000000 RSI: 00000000fffffff4 RDI: 0000000000000000
RBP: ffffc900045af870 R08: 0000000000400dc0 R09: 00000000ffffffff
R10: dffffc0000000000 R11: fffffbfff1d141db R12: ffffc900045af7e0
R13: 1ffff920008b5f24 R14: dffffc0000000000 R15: ffffc900045af920
FS:  000055557a6a5500(0000) GS:ffff888125496000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fb5ea271fc0 CR3: 000000003269e000 CR4: 00000000003526f0
Call Trace:
 <TASK>
 __nft_release_table+0xceb/0x11f0 net/netfilter/nf_tables_api.c:12115
 nft_rcv_nl_event+0xc25/0xdb0 net/netfilter/nf_tables_api.c:12187
 notifier_call_chain+0x19d/0x3a0 kernel/notifier.c:85
 blocking_notifier_call_chain+0x6a/0x90 kernel/notifier.c:380
 netlink_release+0x123b/0x1ad0 net/netlink/af_netlink.c:761
 __sock_release net/socket.c:662 [inline]
 sock_close+0xc3/0x240 net/socket.c:1455
 __fput+0x44f/0xa70 fs/file_table.c:469
 fput_close_sync+0x11f/0x240 fs/file_table.c:574
 __do_sys_close fs/open.c:1509 [inline]
 __se_sys_close fs/open.c:1494 [inline]
 __x64_sys_close+0x7e/0x110 fs/open.c:1494
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fb5ea39c629
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fff72e03568 EFLAGS: 00000246 ORIG_RAX: 0000000000000003
RAX: ffffffffffffffda RBX: 00007fb5ea615fa0 RCX: 00007fb5ea39c629
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000003
RBP: 00007fff72e035d0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000001
R13: 00007fb5ea615fac R14: 00007fb5ea615fa0 R15: 00007fb5ea615fa0
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
