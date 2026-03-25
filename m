Received: from mail-oo1-f78.google.com (mail-oo1-f78.google.com [209.85.161.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 703DB345CA8
	for <netfilter-devel@vger.kernel.org>; Wed, 25 Mar 2026 10:43:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774435407; cv=none; b=oUBcRq47Ddi1l8MeO0rxvr/6IwayMeOkoV0kJe36QoeEwSwbAYi+BH3p8xaMc7NCSbD0jPx32aFSkPcQ2mGyfX7y28w5JEKzSb2OKi542a8TWLxwpd+u39u+6Wgj2fJjEHbL7wCcN78CUeWeJ8oW6wKGmEjY/Gim0DJfFWUTxoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774435407; c=relaxed/simple;
	bh=2rqILl+4N509h5OcHN30omO6Y2zeTmhJoGC+vC6Kvoc=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=Myw0KD/mVThgHy0V7MPNiH4i7iybZj5nSDEB7zCRj603c+elUtD5fTnBc62MlfVK982dkoTus4T0v5dnInLYLBJdIGTw0NZ4LLWrSa02xQ6QV6jX9TxKbM7S+YLukjh9YRAowMHSMqdmjmYzaFLzLpZfXxz6BT4OyU0ZQIbcd4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f78.google.com with SMTP id 006d021491bc7-67de3f8988cso57125869eaf.1
        for <netfilter-devel@vger.kernel.org>; Wed, 25 Mar 2026 03:43:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774435405; x=1775040205;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=sth+Yx3Anp5voHgHzU56hbsx1ZXp3cay5o4gpG4EVEo=;
        b=UF7lxDC8FX9/PhKyz8MIXT8P8FmPQVE2M7DUdjWI3Ew/8pO/tK7eCOM0EOfWaBuCPK
         8dAQFoz+X5RtA46L3Dvg82EGYpqGdkEBLya35d8IRTWIrHonRJTEsBmZWly7YjVA+YaZ
         K+BHhLSHRd1aW6+azh5R48xt8NtfLl1Tp8EGAw34CCACOsr0wIx91dpOyqRO/DL70TVb
         +Iwz4scwJcaHWE/FPXF4v0PS3EeEXS/pkdk5fr7LJ0rv+S0cvgF153s11VOoBtYzmsBK
         iId0H6kUjaH7d4w2J7Uw1wZNyBH2BTnTUCgSaZqnCsOs4u9effQzGk9qzZDP1+Us1MXn
         rovg==
X-Forwarded-Encrypted: i=1; AJvYcCWM0eARgGWJ7bB+z1jNUkDCDAMyxo805E4rlf2/rZM/2cT7+9jWtIZaf8uWRn9JHTekBQpokMISGoS35KEQ1/A=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx4uvq9y1GlyHGgf2tI4owvEn/Eg+RRT3PsTPvZTakSieb9K+JM
	1ZtHn1gVhTpEcJg9Gt6+nVlt1JyEpXvCokfwZOBGhn/JrejOYfbAzGrJ/+7HbKsAQbzRbPAeU1y
	QNqkfL6VWO/4tXt9EWOUl/yY8p0dvDf4TxheJpkPpJ/kOhv1yrNwCTvWzimQ=
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:1625:b0:67d:e70f:a1f with SMTP id
 006d021491bc7-67dff4784fdmr1706591eaf.32.1774435405461; Wed, 25 Mar 2026
 03:43:25 -0700 (PDT)
Date: Wed, 25 Mar 2026 03:43:25 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69c3bc4d.a70a0220.234938.004e.GAE@google.com>
Subject: [syzbot] [netfilter?] KCSAN: data-race in hash_ip4_add / hash_ip4_head
From: syzbot <syzbot+1da17e4b41d795df059e@syzkaller.appspotmail.com>
To: coreteam@netfilter.org, davem@davemloft.net, edumazet@google.com, 
	fw@strlen.de, horms@kernel.org, kuba@kernel.org, linux-kernel@vger.kernel.org, 
	netdev@vger.kernel.org, netfilter-devel@vger.kernel.org, pabeni@redhat.com, 
	pablo@netfilter.org, phil@nwl.cc, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    24f9515de877 Merge tag 'for-linus' of git://git.kernel.org..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=149f16da580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=3a78dd265deac3a9
dashboard link: https://syzkaller.appspot.com/bug?extid=1da17e4b41d795df059e
compiler:       Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/1bb1f4a7b1f6/disk-24f9515d.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/6d7e15112efa/vmlinux-24f9515d.xz
kernel image: https://storage.googleapis.com/syzbot-assets/ffad41df862f/bzImage-24f9515d.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+1da17e4b41d795df059e@syzkaller.appspotmail.com

==================================================================
BUG: KCSAN: data-race in hash_ip4_add / hash_ip4_head

read-write to 0xffff88810e478c19 of 1 bytes by task 6489 on cpu 1:
 hash_ip4_add+0x703/0xf60 net/netfilter/ipset/ip_set_hash_gen.h:965
 hash_ip4_uadt+0x452/0x500 net/netfilter/ipset/ip_set_hash_ip.c:160
 call_ad+0x231/0x640 net/netfilter/ipset/ip_set_core.c:1751
 ip_set_ad+0x5c0/0x690 net/netfilter/ipset/ip_set_core.c:1841
 ip_set_uadd+0x41/0x50 net/netfilter/ipset/ip_set_core.c:1864
 nfnetlink_rcv_msg+0x509/0x5d0 net/netfilter/nfnetlink.c:302
 netlink_rcv_skb+0x123/0x220 net/netlink/af_netlink.c:2550
 nfnetlink_rcv+0x167/0x1720 net/netfilter/nfnetlink.c:669
 netlink_unicast_kernel net/netlink/af_netlink.c:1318 [inline]
 netlink_unicast+0x5c0/0x690 net/netlink/af_netlink.c:1344
 netlink_sendmsg+0x5c8/0x6f0 net/netlink/af_netlink.c:1894
 sock_sendmsg_nosec net/socket.c:727 [inline]
 __sock_sendmsg net/socket.c:742 [inline]
 ____sys_sendmsg+0x563/0x5b0 net/socket.c:2592
 ___sys_sendmsg+0x195/0x1e0 net/socket.c:2646
 __sys_sendmsg net/socket.c:2678 [inline]
 __do_sys_sendmsg net/socket.c:2683 [inline]
 __se_sys_sendmsg net/socket.c:2681 [inline]
 __x64_sys_sendmsg+0xd4/0x160 net/socket.c:2681
 x64_sys_call+0x194c/0x3020 arch/x86/include/generated/asm/syscalls_64.h:47
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x12c/0x370 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

read to 0xffff88810e478c19 of 1 bytes by task 6498 on cpu 0:
 hash_ip4_ext_size net/netfilter/ipset/ip_set_hash_gen.h:823 [inline]
 hash_ip4_head+0x283/0x950 net/netfilter/ipset/ip_set_hash_gen.h:1275
 ip_set_dump_do+0xa34/0xb00 net/netfilter/ipset/ip_set_core.c:1651
 netlink_dump+0x455/0x8a0 net/netlink/af_netlink.c:2325
 netlink_recvmsg+0x420/0x550 net/netlink/af_netlink.c:1976
 sock_recvmsg_nosec net/socket.c:1078 [inline]
 sock_recvmsg+0xf5/0x120 net/socket.c:1100
 ____sys_recvmsg+0xf5/0x280 net/socket.c:2812
 ___sys_recvmsg+0x11f/0x3b0 net/socket.c:2854
 __sys_recvmsg net/socket.c:2887 [inline]
 __do_sys_recvmsg net/socket.c:2893 [inline]
 __se_sys_recvmsg net/socket.c:2890 [inline]
 __x64_sys_recvmsg+0xd1/0x160 net/socket.c:2890
 x64_sys_call+0x2b1a/0x3020 arch/x86/include/generated/asm/syscalls_64.h:48
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x12c/0x370 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

value changed: 0x01 -> 0x02

Reported by Kernel Concurrency Sanitizer on:
CPU: 0 UID: 0 PID: 6498 Comm: syz.4.620 Tainted: G        W           syzkaller #0 PREEMPT(full) 
Tainted: [W]=WARN
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 02/12/2026
==================================================================


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
