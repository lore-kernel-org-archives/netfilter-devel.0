Received: from mail-oo1-f77.google.com (mail-oo1-f77.google.com [209.85.161.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 323373ED5CE
	for <netfilter-devel@vger.kernel.org>; Thu, 19 Mar 2026 17:27:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.77
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773941245; cv=none; b=J3G7sQBt6P7FkJwSbtDq0tSlwg+arORMMeemK7zh2h932JtOzZY60maZmnpD9Vp1mEiG8UXYgwgSIHuGZ4yFn8zVep9F4EY6QEGltVZhVBtfBRE6OXa9blcRsUBW1ds6KWRZ7n1SCiQsqu/o8su9MBaqjQRG/fqdwcZ7HWNYhwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773941245; c=relaxed/simple;
	bh=9wlebsp9Rx6hCwC5pys32X1sYXY103vYKbl9abZWUJI=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=nllt61hX5BFhMnRfrQ1p0mdtfgXYWP/kZVQ0QfeISkNQGgCP8Fb5PAoBbiGhRutnnI7WymviepyssYvh3HfMQ9K9W36tWRV9FzrorAjQnbQbu49TGnjBRim01tnO2PgySkPrvqCoghBQPIQeaVC/7BqvIv2k/K39FGM9afNsxlk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f77.google.com with SMTP id 006d021491bc7-67baeba7a53so28247149eaf.0
        for <netfilter-devel@vger.kernel.org>; Thu, 19 Mar 2026 10:27:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773941240; x=1774546040;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xnfckOcAi0uA4Z6a6lmoTefw+BoX6EypFKu89xrJ1iI=;
        b=jNpXBimNafmuU+6ff79ti4ij0x43k7TATE2qtso03kzMH8dzjfj2h87xJq3grXzn/x
         H3w5uJMPiwSZabLskhYbYQFMfj5q9J7pD2z01AEF163Dw0NRsgmluSaKy2IDRPJyRPvD
         RoQ2WfiiK9Snbqwiun7Sy125mpea4G5XdwrDI4QjG4AAJvm9X9OAgBtf2ZrtcdX76ppT
         4kBP9XzCeDp6F+rqwGH39SIGB28udlMqsCuqJHnYNpn8dopnPI14BsEO8SSyuufX/wHG
         BIeEkhWpcUOIxbiCYMwmKpLkInhWhXilYkF9aVn47UKKp+qfBj6QR+S1ALZd0NlLfZwG
         wnUw==
X-Forwarded-Encrypted: i=1; AJvYcCW+khw5GyCfzJnAUHIcCYWsiEmSTM4yu+eGFeLP2mN0VxWFMmveCCWS9UyzECm3zHUk3s05KxBkj8dqnxM2CGs=@vger.kernel.org
X-Gm-Message-State: AOJu0YxviVzu2W5Z+Vtbn0uEs9gwTztGwVOK7bXYzsks/EXhizE7nMf5
	tt85077sgnatCz/f8XHPXm5aJmcys/XuNOHdXTOymu/4Mv6gvr18QyIZdJs93IpboSYpoOlW+Cv
	NsLkyZ3o3eAl1n2rnqkhlbLrYYLY15p1JKnBgYY0Xzej19579fvR8ZFyZYxc=
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a4a:decc:0:b0:67c:1fa3:ae6e with SMTP id
 006d021491bc7-67c1fa3b0a3mr891507eaf.8.1773941239827; Thu, 19 Mar 2026
 10:27:19 -0700 (PDT)
Date: Thu, 19 Mar 2026 10:27:19 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69bc31f7.050a0220.18f14c.004f.GAE@google.com>
Subject: [syzbot] [netfilter?] KCSAN: data-race in hash_ipport6_add / hash_ipport6_head
From: syzbot <syzbot+786c889f046e8b003ca6@syzkaller.appspotmail.com>
To: coreteam@netfilter.org, davem@davemloft.net, edumazet@google.com, 
	fw@strlen.de, horms@kernel.org, kuba@kernel.org, linux-kernel@vger.kernel.org, 
	netdev@vger.kernel.org, netfilter-devel@vger.kernel.org, pabeni@redhat.com, 
	pablo@netfilter.org, phil@nwl.cc, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    c107785c7e8d Merge tag 'modules-7.0-rc3.fixes' of git://gi..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=143b7006580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=6b32b22d8934c136
dashboard link: https://syzkaller.appspot.com/bug?extid=786c889f046e8b003ca6
compiler:       Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/ddd71de958b3/disk-c107785c.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/79e800fb32ab/vmlinux-c107785c.xz
kernel image: https://storage.googleapis.com/syzbot-assets/1b65c942dadc/bzImage-c107785c.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+786c889f046e8b003ca6@syzkaller.appspotmail.com

==================================================================
BUG: KCSAN: data-race in hash_ipport6_add / hash_ipport6_head

read-write to 0xffff88813e1d7a99 of 1 bytes by task 27445 on cpu 1:
 hash_ipport6_add+0x876/0x1110 net/netfilter/ipset/ip_set_hash_gen.h:965
 hash_ipport6_uadt+0x59f/0x680 net/netfilter/ipset/ip_set_hash_ipport.c:351
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
 ____sys_sendmsg+0x5af/0x600 net/socket.c:2592
 ___sys_sendmsg+0x195/0x1e0 net/socket.c:2646
 __sys_sendmsg net/socket.c:2678 [inline]
 __do_sys_sendmsg net/socket.c:2683 [inline]
 __se_sys_sendmsg net/socket.c:2681 [inline]
 __x64_sys_sendmsg+0xd4/0x160 net/socket.c:2681
 x64_sys_call+0x194c/0x3020 arch/x86/include/generated/asm/syscalls_64.h:47
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x12c/0x370 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

read to 0xffff88813e1d7a99 of 1 bytes by task 27450 on cpu 0:
 hash_ipport6_ext_size net/netfilter/ipset/ip_set_hash_gen.h:823 [inline]
 hash_ipport6_head+0x180/0x960 net/netfilter/ipset/ip_set_hash_gen.h:1275
 ip_set_dump_do+0xa34/0xb00 net/netfilter/ipset/ip_set_core.c:1651
 netlink_dump+0x455/0x8a0 net/netlink/af_netlink.c:2325
 netlink_recvmsg+0x420/0x550 net/netlink/af_netlink.c:1976
 sock_recvmsg_nosec net/socket.c:1078 [inline]
 sock_recvmsg+0x139/0x160 net/socket.c:1100
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
CPU: 0 UID: 0 PID: 27450 Comm: syz.3.7305 Tainted: G        W           syzkaller #0 PREEMPT(full) 
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
