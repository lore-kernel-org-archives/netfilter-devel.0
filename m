Received: from mail-oo1-f80.google.com (mail-oo1-f80.google.com [209.85.161.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11EB23D8130
	for <netfilter-devel@vger.kernel.org>; Fri,  3 Apr 2026 20:46:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775249186; cv=none; b=al/MruTAnHdGChms3wcd/LSaeKLFc0hpxMS3E/S3vEPiFd+WmiIqgwKKrgJ+ilMhXIuJUp2shvNn9CE6nFC9WMBLS8nEA4zanaxWexguWMzTd+kxENpTeSZbHOjFM11w5+rwDMQnL73EiTxi7F5/uK7MXWU+FEeACv5MNHknrdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775249186; c=relaxed/simple;
	bh=ya8mIEi/lOzbAAv9vNueo7lkjuUjA9tBA2hrrpB0r9c=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=nn1bxmPprF9ZQaiGQKlsRwEruVTMmt3vXP1sbzLci8dCBcsVFuW+n2F3KgparZdGI/9nXGIXKANDwGEMQSiQKbu/M17q2Jrt2XqQIkdaSvDYGBcbMe714WQAWyrnU1l/sZY4u8gqIPHZmzGBgWjI43HK9hHXTaNoa1LIJoe6Y/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f80.google.com with SMTP id 006d021491bc7-67e07123bb5so3877560eaf.0
        for <netfilter-devel@vger.kernel.org>; Fri, 03 Apr 2026 13:46:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775249184; x=1775853984;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DwihP8VSD5VEOSh/pvXoSKE8nmgjfZs35QdENxNc5QI=;
        b=JN4WwGPOTY3cIerrpzQ/k2woI2kN3EYd62zkFmhH8XgTa8MxyLrI7eAya3Kqcrst0+
         4T2aA39KXX9z4b9w7E72wOG5yGZfI79+VjjgEhip/WpLVb/rX9Hfwk/yfBffoPeQ3M3X
         4jyhNwpcM3MFSSyWfqS8ZskK/yP//tOotfFxgWV7kxmXxz3oIpZukVhpvIEFs2CcDeYr
         PW9lmtJz7vii2wU/ralRCFkgrplI1S/DMSGUZGS/pcNp84UzjfUgsZSGa/x7bHvFOkf0
         7FyahNL+ecOPG3WHqzn/zNJDVHW6fWcs89TOSJeED+iE7dlEziuB8v0WlWBZ8EaiVH9a
         +KWg==
X-Forwarded-Encrypted: i=1; AJvYcCUdJhEFLrn+Xt4wQVmIEH25lU0RZjeN7xXztyt6GYAtA3qwbOZEIrsm6d0bD6vQOJo32fOLR7D5vsT99zlp/a0=@vger.kernel.org
X-Gm-Message-State: AOJu0YxusbwlP5pfsZCcl1v8/kYlZeyPBkvjCSJe4+1stk+MDU+2il9v
	mppabuhTMit0zwgKjcKnpCKPn9WuM2etfJUPv/fqfGVzt/xEqe0yNAqBeEgTSreVkE4lFvH76TU
	CSelQf5MFBeAXtCuP7wPPOktdHs3E+3KmfXGvqB+J0Hea21S1T4fwZTxxBMQ=
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:818a:b0:67d:e140:344a with SMTP id
 006d021491bc7-68220c3f586mr2682669eaf.40.1775249183975; Fri, 03 Apr 2026
 13:46:23 -0700 (PDT)
Date: Fri, 03 Apr 2026 13:46:23 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69d0271f.050a0220.182279.0019.GAE@google.com>
Subject: [syzbot] [netfilter?] KCSAN: data-race in hash_ipportnet6_add / hash_ipportnet6_head
From: syzbot <syzbot+421c5f3ff8e9493084d9@syzkaller.appspotmail.com>
To: coreteam@netfilter.org, davem@davemloft.net, edumazet@google.com, 
	fw@strlen.de, horms@kernel.org, kuba@kernel.org, linux-kernel@vger.kernel.org, 
	netdev@vger.kernel.org, netfilter-devel@vger.kernel.org, pabeni@redhat.com, 
	pablo@netfilter.org, phil@nwl.cc, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    2d1373e4246d Merge tag 'for-7.0-rc4-tag' of git://git.kern..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=12df3d52580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=3a78dd265deac3a9
dashboard link: https://syzkaller.appspot.com/bug?extid=421c5f3ff8e9493084d9
compiler:       Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/b2aee7aa6da1/disk-2d1373e4.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/6cbfa1602880/vmlinux-2d1373e4.xz
kernel image: https://storage.googleapis.com/syzbot-assets/52fe8db03e03/bzImage-2d1373e4.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+421c5f3ff8e9493084d9@syzkaller.appspotmail.com

==================================================================
BUG: KCSAN: data-race in hash_ipportnet6_add / hash_ipportnet6_head

read-write to 0xffff888181583b19 of 1 bytes by task 29523 on cpu 1:
 hash_ipportnet6_add+0xa12/0x1900 net/netfilter/ipset/ip_set_hash_gen.h:965
 hash_ipportnet6_uadt+0x7c1/0x900 net/netfilter/ipset/ip_set_hash_ipportnet.c:504
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

read to 0xffff888181583b19 of 1 bytes by task 29539 on cpu 0:
 hash_ipportnet6_ext_size net/netfilter/ipset/ip_set_hash_gen.h:823 [inline]
 hash_ipportnet6_head+0x28f/0x790 net/netfilter/ipset/ip_set_hash_gen.h:1275
 ip_set_dump_do+0xa34/0xb00 net/netfilter/ipset/ip_set_core.c:1651
 netlink_dump+0x455/0x8a0 net/netlink/af_netlink.c:2325
 netlink_recvmsg+0x420/0x550 net/netlink/af_netlink.c:1976
 sock_recvmsg_nosec net/socket.c:1078 [inline]
 sock_recvmsg+0xf5/0x120 net/socket.c:1100
 ____sys_recvmsg+0xf5/0x280 net/socket.c:2812
 ___sys_recvmsg+0x11f/0x3b0 net/socket.c:2854
 do_recvmmsg+0x1ef/0x560 net/socket.c:2949
 __sys_recvmmsg net/socket.c:3023 [inline]
 __do_sys_recvmmsg net/socket.c:3046 [inline]
 __se_sys_recvmmsg net/socket.c:3039 [inline]
 __x64_sys_recvmmsg+0xe5/0x170 net/socket.c:3039
 x64_sys_call+0x80f/0x3020 arch/x86/include/generated/asm/syscalls_64.h:300
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x12c/0x370 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

value changed: 0x05 -> 0x06

Reported by Kernel Concurrency Sanitizer on:
CPU: 0 UID: 0 PID: 29539 Comm: syz.4.6655 Tainted: G        W           syzkaller #0 PREEMPT(full) 
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
