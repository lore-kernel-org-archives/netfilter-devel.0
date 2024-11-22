Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E9B5745F2
	for <netfilter-devel@vger.kernel.org>; Fri, 22 Nov 2024 14:42:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732286551; cv=none; b=TnBpGUSgU5hL6dWh6odLbqPpEf6SLCkJhh/6H9J29lSIvsfUsy7GNU+UWKPqS3MHYO3O0M9R4V7CQK9wfaO5ouYs8hUOqNKxir1Dzorv1XrH91FUkEjmhsYj65ROcmrTFJ9T3haMJqcc6dgRrdQxEbu30T2ovqoV2rGNIKZTbZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732286551; c=relaxed/simple;
	bh=BIEsS5LsD4by/EhQhvRWIE3r/czFlXo23B/i/vdCbG0=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=FDDuE4xUBRSgQnWRCqHAWA1gZb50k481m8pjRPA7cHa+txPEtdr63/LpBzwmwF1LgypZenbUZpDGVavGhP2slsmly0cgZYafSreIreNdVgusiB6b0AX5eBcJrMk3jkhA1ZjGOKYZgE76oIHdpzlHaQmHyg5h5U0+laWCqesz/6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-3a79039ae30so22397445ab.2
        for <netfilter-devel@vger.kernel.org>; Fri, 22 Nov 2024 06:42:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732286548; x=1732891348;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=HREFpr2frQJtKc/0gF+LMIRtVsh+wEdJTnHfyu0RbuM=;
        b=bWsYEhUInyfPapZez16qSkNYOlqe8V5xO1ReuDeMihlVLTUUWLj9oMxtDzIW4z82H1
         micFrahzolU6Ql1huk+Xt/NSaiURbmkHaGF83AYGKxXz3xMp3ruwQPUrRGxfRZwglf+b
         pyaq/R0kt4KZr49TIRUKOgQ+xRbCIKKqdKu8koZEFlnKmuZ1QDc2FeIL5M/MuAHhrhgg
         kX3zQ1juVrqvf2X2sKGH9muehg6IUK96OCjEbruqjPLv0mCuiXcUZVuB/n3z5evkZKzr
         KdP/VtncZUzxXFzmeIAUaqdJXgi3Ll1a7vEBRrvj0nYWYeKFe4H86Tzf/uEdXJp1k6JW
         q6Vg==
X-Forwarded-Encrypted: i=1; AJvYcCVvGmw171qAGRPRhTttJp8esQQSTx54TXv4AW3CbxsQJTOOm+1qZBKkp3yzApSU6ThbI3R1yY9EfMQf33+ruC4=@vger.kernel.org
X-Gm-Message-State: AOJu0YyRXuhceOiNKKfsK2vTIgKLGkadoQ6sR/ncVhbMbZSs/IygPwb2
	wjAcZ45a836zragNNvBjGtgkHUWAPxXTTKSVDG/EBNJ9bsGiV4EYre985e8+ms5yCKIDB0Apen4
	ErjATOSqMz+Sz/VmUeKT9XcN2cEjv24IWSPHGWhd8ZZ2zF/E87db15O4=
X-Google-Smtp-Source: AGHT+IGbXUYw3Kwjx0hw4KKuy2WKwNuZ+/BKDPjA2T2Hn3hL4ksW0iLcQ8/sjUrHRK/GuSqEy7KOeguwLdSbBxZe+35sIIIee0Es
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:16c5:b0:3a7:87f2:b010 with SMTP id
 e9e14a558f8ab-3a79acf9b88mr40033755ab.5.1732286548639; Fri, 22 Nov 2024
 06:42:28 -0800 (PST)
Date: Fri, 22 Nov 2024 06:42:28 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67409854.050a0220.363a1b.013f.GAE@google.com>
Subject: [syzbot] [netfilter?] KMSAN: uninit-value in ip6table_mangle_hook (3)
From: syzbot <syzbot+6023ea32e206eef7920a@syzkaller.appspotmail.com>
To: coreteam@netfilter.org, davem@davemloft.net, dsahern@kernel.org, 
	edumazet@google.com, horms@kernel.org, kadlec@netfilter.org, kuba@kernel.org, 
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org, 
	netfilter-devel@vger.kernel.org, pabeni@redhat.com, pablo@netfilter.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    2e1b3cc9d7f7 Merge tag 'arm-fixes-6.12-2' of git://git.ker..
git tree:       upstream
console+strace: https://syzkaller.appspot.com/x/log.txt?x=105e0d87980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=6fdf74cce377223b
dashboard link: https://syzkaller.appspot.com/bug?extid=6023ea32e206eef7920a
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=165d5d5f980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=145e0d87980000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/08456e37db58/disk-2e1b3cc9.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/cc957f7ba80b/vmlinux-2e1b3cc9.xz
kernel image: https://storage.googleapis.com/syzbot-assets/7579fe72ed89/bzImage-2e1b3cc9.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+6023ea32e206eef7920a@syzkaller.appspotmail.com

=====================================================
BUG: KMSAN: uninit-value in ip6t_mangle_out net/ipv6/netfilter/ip6table_mangle.c:56 [inline]
BUG: KMSAN: uninit-value in ip6table_mangle_hook+0x97d/0x9c0 net/ipv6/netfilter/ip6table_mangle.c:72
 ip6t_mangle_out net/ipv6/netfilter/ip6table_mangle.c:56 [inline]
 ip6table_mangle_hook+0x97d/0x9c0 net/ipv6/netfilter/ip6table_mangle.c:72
 nf_hook_entry_hookfn include/linux/netfilter.h:154 [inline]
 nf_hook_slow+0xf4/0x400 net/netfilter/core.c:626
 nf_hook include/linux/netfilter.h:269 [inline]
 __ip6_local_out+0x5ac/0x640 net/ipv6/output_core.c:143
 ip6_local_out+0x4c/0x210 net/ipv6/output_core.c:153
 ip6tunnel_xmit+0x129/0x460 include/net/ip6_tunnel.h:161
 ip6_tnl_xmit+0x341a/0x3860 net/ipv6/ip6_tunnel.c:1281
 __gre6_xmit+0x14b9/0x1550 net/ipv6/ip6_gre.c:815
 ip6gre_xmit_ipv4 net/ipv6/ip6_gre.c:839 [inline]
 ip6gre_tunnel_xmit+0x18f7/0x2030 net/ipv6/ip6_gre.c:922
 __netdev_start_xmit include/linux/netdevice.h:4928 [inline]
 netdev_start_xmit include/linux/netdevice.h:4937 [inline]
 xmit_one net/core/dev.c:3588 [inline]
 dev_hard_start_xmit+0x247/0xa20 net/core/dev.c:3604
 sch_direct_xmit+0x399/0xd40 net/sched/sch_generic.c:343
 __dev_xmit_skb net/core/dev.c:3825 [inline]
 __dev_queue_xmit+0x2fcf/0x56d0 net/core/dev.c:4398
 dev_queue_xmit include/linux/netdevice.h:3094 [inline]
 packet_xmit+0x9c/0x6c0 net/packet/af_packet.c:276
 packet_snd net/packet/af_packet.c:3145 [inline]
 packet_sendmsg+0x908b/0xa370 net/packet/af_packet.c:3177
 sock_sendmsg_nosec net/socket.c:729 [inline]
 __sock_sendmsg+0x30f/0x380 net/socket.c:744
 __sys_sendto+0x645/0x7f0 net/socket.c:2214
 __do_sys_sendto net/socket.c:2226 [inline]
 __se_sys_sendto net/socket.c:2222 [inline]
 __x64_sys_sendto+0x125/0x1d0 net/socket.c:2222
 x64_sys_call+0x3373/0x3ba0 arch/x86/include/generated/asm/syscalls_64.h:45
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xcd/0x1e0 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Uninit was stored to memory at:
 ip6_tnl_xmit+0x34f7/0x3860 net/ipv6/ip6_tunnel.c:1277
 __gre6_xmit+0x14b9/0x1550 net/ipv6/ip6_gre.c:815
 ip6gre_xmit_ipv4 net/ipv6/ip6_gre.c:839 [inline]
 ip6gre_tunnel_xmit+0x18f7/0x2030 net/ipv6/ip6_gre.c:922
 __netdev_start_xmit include/linux/netdevice.h:4928 [inline]
 netdev_start_xmit include/linux/netdevice.h:4937 [inline]
 xmit_one net/core/dev.c:3588 [inline]
 dev_hard_start_xmit+0x247/0xa20 net/core/dev.c:3604
 sch_direct_xmit+0x399/0xd40 net/sched/sch_generic.c:343
 __dev_xmit_skb net/core/dev.c:3825 [inline]
 __dev_queue_xmit+0x2fcf/0x56d0 net/core/dev.c:4398
 dev_queue_xmit include/linux/netdevice.h:3094 [inline]
 packet_xmit+0x9c/0x6c0 net/packet/af_packet.c:276
 packet_snd net/packet/af_packet.c:3145 [inline]
 packet_sendmsg+0x908b/0xa370 net/packet/af_packet.c:3177
 sock_sendmsg_nosec net/socket.c:729 [inline]
 __sock_sendmsg+0x30f/0x380 net/socket.c:744
 __sys_sendto+0x645/0x7f0 net/socket.c:2214
 __do_sys_sendto net/socket.c:2226 [inline]
 __se_sys_sendto net/socket.c:2222 [inline]
 __x64_sys_sendto+0x125/0x1d0 net/socket.c:2222
 x64_sys_call+0x3373/0x3ba0 arch/x86/include/generated/asm/syscalls_64.h:45
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xcd/0x1e0 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Uninit was created at:
 slab_post_alloc_hook mm/slub.c:4091 [inline]
 slab_alloc_node mm/slub.c:4134 [inline]
 __do_kmalloc_node mm/slub.c:4263 [inline]
 __kmalloc_node_track_caller_noprof+0x6c7/0xf90 mm/slub.c:4283
 kmalloc_reserve+0x23e/0x4a0 net/core/skbuff.c:609
 pskb_expand_head+0x226/0x1a60 net/core/skbuff.c:2275
 skb_realloc_headroom+0x140/0x2b0 net/core/skbuff.c:2355
 ip6_tnl_xmit+0x2106/0x3860 net/ipv6/ip6_tunnel.c:1227
 __gre6_xmit+0x14b9/0x1550 net/ipv6/ip6_gre.c:815
 ip6gre_xmit_ipv4 net/ipv6/ip6_gre.c:839 [inline]
 ip6gre_tunnel_xmit+0x18f7/0x2030 net/ipv6/ip6_gre.c:922
 __netdev_start_xmit include/linux/netdevice.h:4928 [inline]
 netdev_start_xmit include/linux/netdevice.h:4937 [inline]
 xmit_one net/core/dev.c:3588 [inline]
 dev_hard_start_xmit+0x247/0xa20 net/core/dev.c:3604
 sch_direct_xmit+0x399/0xd40 net/sched/sch_generic.c:343
 __dev_xmit_skb net/core/dev.c:3825 [inline]
 __dev_queue_xmit+0x2fcf/0x56d0 net/core/dev.c:4398
 dev_queue_xmit include/linux/netdevice.h:3094 [inline]
 packet_xmit+0x9c/0x6c0 net/packet/af_packet.c:276
 packet_snd net/packet/af_packet.c:3145 [inline]
 packet_sendmsg+0x908b/0xa370 net/packet/af_packet.c:3177
 sock_sendmsg_nosec net/socket.c:729 [inline]
 __sock_sendmsg+0x30f/0x380 net/socket.c:744
 __sys_sendto+0x645/0x7f0 net/socket.c:2214
 __do_sys_sendto net/socket.c:2226 [inline]
 __se_sys_sendto net/socket.c:2222 [inline]
 __x64_sys_sendto+0x125/0x1d0 net/socket.c:2222
 x64_sys_call+0x3373/0x3ba0 arch/x86/include/generated/asm/syscalls_64.h:45
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xcd/0x1e0 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

CPU: 1 UID: 0 PID: 5819 Comm: syz-executor359 Not tainted 6.12.0-rc6-syzkaller-00077-g2e1b3cc9d7f7 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/13/2024
=====================================================


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
