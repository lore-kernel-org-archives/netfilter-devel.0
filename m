Received: from mail-io1-f78.google.com (mail-io1-f78.google.com [209.85.166.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34F0F19CD13
	for <netfilter-devel@vger.kernel.org>; Wed, 30 Jul 2025 05:30:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753853429; cv=none; b=klHnUqEhM/Kk2kUQ4xKtYaU76p2KvUbuDrKTPiYic9mlRlnM4djXDeRwqfSAcfTF1swysVT4jbYHgN9YAqsAgbUKP21FY3E7IfCVHHksrYgpsOYztbzr6ZjJr49BVQQbQXtN8c9oJwOxRM++O51aRfgCNipZrdAfjNiemJLNwoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753853429; c=relaxed/simple;
	bh=SWXjA3T0iZABKRIwmCf5Uzft+ycSIlMkdD+XTW84w/o=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=V/MTA9kLcHR485zJQBXkZ4R0KeESqzT9RTetY4e4GrPZM8N7GFuladbxYLbGgdwS7uuPxC7Q8n5fvdaS0/PU7l4jUzg0pSVxfghYo4xtd4jLdbarZdkPSc/MQQ6A33rjjeJS+ElQAVYpX8iSw4TMIW/+0bykO4Icl/u3PUQVwBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f78.google.com with SMTP id ca18e2360f4ac-87c33c0b62eso572652139f.2
        for <netfilter-devel@vger.kernel.org>; Tue, 29 Jul 2025 22:30:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753853427; x=1754458227;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=eu7fGBCIzOPa9YHCMscfdaivYVWI9C4AstnrKLseCYE=;
        b=tD2syInD8eAP/SHnkxxW7Qxbpyw/q2wlH9Qqa6EO1MAXrg23Grd5i8kaxWp6LRyQE1
         sBxSEBKWVguMoX2vAaGJ3LJzz/cQd0D1yGmLhSdUrjaXQTLAGZ8fvhHz0pWjQXsTijqf
         z1la6qUz7RBsypFscvbRe4SU62cC6DlvsfaWmtILMdA1bBHS4zQu72rgDQBxUQfI9+2y
         Q76fgyKPxIs1hlszAS3UZVzoZ3EHo/i0SJP3XLdBkTb3dCBSdnWjdzOoK3DbQdDahVGB
         n42f5FNtXGleE6twe2qOT3J/IrmtONKv3QkUdVlbX1eZhhMSzpcVlTvlfVZPFPA16aAy
         GDLA==
X-Forwarded-Encrypted: i=1; AJvYcCWJe+lMdERPxdMSoCvBXagTQMIQjLqmXPrzvxzr6m3es5FsDJ4kNBZmvUAqGIq8/swPm+tHwI3CVcAX5cdAaW4=@vger.kernel.org
X-Gm-Message-State: AOJu0YxcH6sTSRfcNrW0QGkvPMmb80KrW+jhxlZvBXW+bbkc3GUCwFo3
	iVyL6JmnO7TC0rxFJlWx7S2tK1TA1cw8aV9VLS60BOSINepgFBIyhg6xIACCAFeXfaXYMNUXxBb
	8PNofLAdugEpy7Dk5vv06ehQTOH/4kQmUrts4gFAZHCjIYky+M1l/GUGaQYo=
X-Google-Smtp-Source: AGHT+IGbEBXcBVdHTDiadmIrdZtqg/YJT1t5jbW5zXbtps0IXePdqO8BBqN40v43mfu3JJrTWicRPG+91/LmheYL2272IcmGFJuQ
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6602:1592:b0:85d:b054:6eb9 with SMTP id
 ca18e2360f4ac-88138b04598mr386025539f.14.1753853427267; Tue, 29 Jul 2025
 22:30:27 -0700 (PDT)
Date: Tue, 29 Jul 2025 22:30:27 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6889adf3.050a0220.5d226.0002.GAE@google.com>
Subject: [syzbot] [netfilter?] WARNING in __nf_unregister_net_hook (9)
From: syzbot <syzbot+78ac1e46d2966eb70fda@syzkaller.appspotmail.com>
To: coreteam@netfilter.org, davem@davemloft.net, edumazet@google.com, 
	horms@kernel.org, kadlec@netfilter.org, kuba@kernel.org, 
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org, 
	netfilter-devel@vger.kernel.org, pabeni@redhat.com, pablo@netfilter.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    9312ee76490d octeontx2-af: use unsigned int as iterator fo..
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=114b88a2580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=4b71a7f00d74e4f3
dashboard link: https://syzkaller.appspot.com/bug?extid=78ac1e46d2966eb70fda
compiler:       Debian clang version 20.1.7 (++20250616065708+6146a88f6049-1~exp1~20250616065826.132), Debian LLD 20.1.7

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/b381ecf9ad30/disk-9312ee76.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/ebd0e7846e92/vmlinux-9312ee76.xz
kernel image: https://storage.googleapis.com/syzbot-assets/b9c68d721e9c/bzImage-9312ee76.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+78ac1e46d2966eb70fda@syzkaller.appspotmail.com

x_tables: ip6_tables: mh match: only valid for protocol 135
------------[ cut here ]------------
hook not found, pf 10 num 1
WARNING: CPU: 0 PID: 7813 at net/netfilter/core.c:514 __nf_unregister_net_hook+0x30a/0x700 net/netfilter/core.c:514
Modules linked in:
CPU: 0 UID: 0 PID: 7813 Comm: syz.1.502 Not tainted 6.16.0-rc7-syzkaller-01904-g9312ee76490d #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/12/2025
RIP: 0010:__nf_unregister_net_hook+0x30a/0x700 net/netfilter/core.c:514
Code: 58 59 ef 05 01 90 48 8b 44 24 10 0f b6 04 28 84 c0 0f 85 e3 03 00 00 41 8b 17 48 c7 c7 60 8f 98 8c 44 89 ee e8 07 46 e7 f7 90 <0f> 0b 90 90 e9 d8 01 00 00 e8 98 bf d3 01 89 c3 31 ff 89 c6 e8 1d
RSP: 0018:ffffc9000e8a7768 EFLAGS: 00010246
RAX: d399e8c7c2db4300 RBX: ffff8880688c2400 RCX: ffff88802c435a00
RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000002
RBP: dffffc0000000000 R08: 0000000000000003 R09: 0000000000000004
R10: dffffc0000000000 R11: fffffbfff1bfaa6c R12: ffff888029a72440
R13: 000000000000000a R14: ffff888029a736c0 R15: ffffffff8c9a21fc
FS:  00007f5152aa66c0(0000) GS:ffff888125c12000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000110c34c54a CR3: 0000000027c74000 CR4: 00000000003526f0
Call Trace:
 <TASK>
 nf_unregister_net_hook net/netfilter/core.c:-1 [inline]
 nf_unregister_net_hooks+0xcb/0x140 net/netfilter/core.c:610
 synproxy_tg6_destroy+0x58/0xb0 net/ipv6/netfilter/ip6t_SYNPROXY.c:94
 cleanup_entry+0x265/0x320 net/ipv6/netfilter/ip6_tables.c:669
 translate_table+0x1e5f/0x2040 net/ipv6/netfilter/ip6_tables.c:744
 do_replace net/ipv6/netfilter/ip6_tables.c:1154 [inline]
 do_ip6t_set_ctl+0x970/0xce0 net/ipv6/netfilter/ip6_tables.c:1644
 nf_setsockopt+0x26f/0x290 net/netfilter/nf_sockopt.c:101
 do_sock_setsockopt+0x179/0x1b0 net/socket.c:2344
 __sys_setsockopt net/socket.c:2369 [inline]
 __do_sys_setsockopt net/socket.c:2375 [inline]
 __se_sys_setsockopt net/socket.c:2372 [inline]
 __x64_sys_setsockopt+0x13f/0x1b0 net/socket.c:2372
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f5151b8e9a9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f5152aa6038 EFLAGS: 00000246 ORIG_RAX: 0000000000000036
RAX: ffffffffffffffda RBX: 00007f5151db6080 RCX: 00007f5151b8e9a9
RDX: 0000000000000040 RSI: 0000000000000029 RDI: 000000000000000d
RBP: 00007f5151c10d69 R08: 0000000000000470 R09: 0000000000000000
R10: 0000200000000480 R11: 0000000000000246 R12: 0000000000000000
R13: 0000000000000000 R14: 00007f5151db6080 R15: 00007ffc85b4e498
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
