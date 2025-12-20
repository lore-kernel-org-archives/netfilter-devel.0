Received: from mail-oa1-f77.google.com (mail-oa1-f77.google.com [209.85.160.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF152239E6F
	for <netfilter-devel@vger.kernel.org>; Sat, 20 Dec 2025 00:58:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.77
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766192311; cv=none; b=tFd5VFgmg85d4Lg18Hxw1f1nOeYBX646puAz0zdnQ581Rb0WY1JI4Vll/36upKSXn40UDK+3dx20/MEqhEQUFsHu40qsSoQFWqEMSBylJOBk8WJDkYMElYmbmEBntiKQmKsfeA1BrtFfKCWCgbpe0s13O4ZWdk0wBySFSNMDC68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766192311; c=relaxed/simple;
	bh=76RkY53A53TE5vjruyOQ+9fxoxR/g3EA2S0do+GOSEM=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=VK2qRtQaeV95HVOx3fFOXXmF9bUQn71q2EqEFXD33qFJepvyQychsSaBgvflKoipL7AvQJAvq7/Ws/e08Wbvpf1G0REmrznDJ+r+qJGlzNlWkfH1agUYLywo5efZaDnaMg1LP9C69db/z61c4+BpeoW7aNHCbQpbepej06jWkRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.160.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oa1-f77.google.com with SMTP id 586e51a60fabf-3e895c6cd28so1541211fac.1
        for <netfilter-devel@vger.kernel.org>; Fri, 19 Dec 2025 16:58:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766192309; x=1766797109;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=WwApJ4ymW9qNlyX/ux7Ad8vgCZzQe62XlTOBLNe3WJU=;
        b=t/H+gSeq8s/z43im7/a5kNgtDbUpP2yx2mDBgM1vmw1UYSAoUZxJM6iSeNKukJSHH9
         l6WnrFpU1CXblBwCjnKSnvWOWLALm9BuXQ2yxYJ7iXSauzgfPVOe3PB2PMv/LuHGBYWD
         oJSKQ7Sq7xR/KVZ2Yhbe2FpNCEVtEqnbvnt6esk3uBDusD/HWGZ46UOz086yiygIPtm9
         PRSbvFYyuOsxueMlrSnqLCeEd9kTq5HbWcsjpd1+8Bd/5Z7wSJha4X0zlx105JbxsjbX
         MBbWrL6orA8IiR3ymqRF4SMEZf24RnzEmWHjdVHE+3MemXI6P1F6Lsgnp5GbYzRseFTP
         NkbA==
X-Forwarded-Encrypted: i=1; AJvYcCV4eeaEgWC6IvjE7LUDz8KON8vpj3iQg73dUNf1DunONOzsuwbzz3JxSsi+fZascsr6QdiKFWPYel1z1c0dPBw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy+crs41B+ogGMhEmwy3WmHQNpOlQk/Pzp0cOhJ/innee+dYj/v
	XWWW0s/J8z3HrXY8J+j8uIDVcL3kHjNA2xtpsO8MymIEz/q4ez3CmO04hQRh7IizU+0uZPj/cKC
	61qaEYYXD+YljGMe6I7PAH5S43chpWFcSFl1fTW7TcvDRSOsph9n6UWtUvpE=
X-Google-Smtp-Source: AGHT+IH8z1xizs4/DgR2IxHVW2LrMd5szXgAdwV5XL5euymH4jWKMKV+aCIvYtTvLOOuayuVfcBFOkKm2lJ4xW/Uj4mdduejdkIc
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a4a:e602:0:b0:65d:bee:4c7 with SMTP id 006d021491bc7-65d0eb1f940mr1539827eaf.42.1766192308685;
 Fri, 19 Dec 2025 16:58:28 -0800 (PST)
Date: Fri, 19 Dec 2025 16:58:28 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6945f4b4.a70a0220.207337.0121.GAE@google.com>
Subject: [syzbot] [netfilter?] possible deadlock in nf_tables_dumpreset_obj
From: syzbot <syzbot+ff16b505ec9152e5f448@syzkaller.appspotmail.com>
To: coreteam@netfilter.org, davem@davemloft.net, edumazet@google.com, 
	fw@strlen.de, horms@kernel.org, kadlec@netfilter.org, kuba@kernel.org, 
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org, 
	netfilter-devel@vger.kernel.org, pabeni@redhat.com, pablo@netfilter.org, 
	phil@nwl.cc, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    8f0b4cce4481 Linux 6.19-rc1
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=104f2d92580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a11e0f726bfb6765
dashboard link: https://syzkaller.appspot.com/bug?extid=ff16b505ec9152e5f448
compiler:       gcc (Debian 12.2.0-14+deb12u1) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-8f0b4cce.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/64c9a36f3f29/vmlinux-8f0b4cce.xz
kernel image: https://storage.googleapis.com/syzbot-assets/27a5e8a8a4b8/bzImage-8f0b4cce.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+ff16b505ec9152e5f448@syzkaller.appspotmail.com

======================================================
WARNING: possible circular locking dependency detected
syzkaller #0 Not tainted
------------------------------------------------------
syz.3.970/9330 is trying to acquire lock:
ffff888012d4ccd8 (&nft_net->commit_mutex){+.+.}-{4:4}, at: nf_tables_dumpreset_obj+0x6f/0xa0 net/netfilter/nf_tables_api.c:8491

but task is already holding lock:
ffff88802bce36f0 (nlk_cb_mutex-NETFILTER){+.+.}-{4:4}, at: __netlink_dump_start+0x150/0x990 net/netlink/af_netlink.c:2404

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #2 (nlk_cb_mutex-NETFILTER){+.+.}-{4:4}:
       __mutex_lock_common kernel/locking/mutex.c:614 [inline]
       __mutex_lock+0x1aa/0x1ca0 kernel/locking/mutex.c:776
       __netlink_dump_start+0x150/0x990 net/netlink/af_netlink.c:2404
       netlink_dump_start include/linux/netlink.h:341 [inline]
       ip_set_dump+0x17f/0x210 net/netfilter/ipset/ip_set_core.c:1717
       nfnetlink_rcv_msg+0x9fc/0x1200 net/netfilter/nfnetlink.c:302
       netlink_rcv_skb+0x158/0x420 net/netlink/af_netlink.c:2550
       nfnetlink_rcv+0x1b3/0x430 net/netfilter/nfnetlink.c:669
       netlink_unicast_kernel net/netlink/af_netlink.c:1318 [inline]
       netlink_unicast+0x5aa/0x870 net/netlink/af_netlink.c:1344
       netlink_sendmsg+0x8c8/0xdd0 net/netlink/af_netlink.c:1894
       sock_sendmsg_nosec net/socket.c:727 [inline]
       __sock_sendmsg net/socket.c:742 [inline]
       ____sys_sendmsg+0xa5d/0xc30 net/socket.c:2592
       ___sys_sendmsg+0x134/0x1d0 net/socket.c:2646
       __sys_sendmsg+0x16d/0x220 net/socket.c:2678
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0xcd/0xf80 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #1 (nfnl_subsys_ipset){+.+.}-{4:4}:
       __mutex_lock_common kernel/locking/mutex.c:614 [inline]
       __mutex_lock+0x1aa/0x1ca0 kernel/locking/mutex.c:776
       ip_set_nfnl_get_byindex+0x7c/0x290 net/netfilter/ipset/ip_set_core.c:909
       set_target_v1_checkentry+0x1ac/0x570 net/netfilter/xt_set.c:313
       xt_check_target+0x27c/0xa40 net/netfilter/x_tables.c:1038
       nft_target_init+0x459/0x7d0 net/netfilter/nft_compat.c:267
       nf_tables_newexpr net/netfilter/nf_tables_api.c:3527 [inline]
       nf_tables_newrule+0xedd/0x2910 net/netfilter/nf_tables_api.c:4358
       nfnetlink_rcv_batch+0x190d/0x2350 net/netfilter/nfnetlink.c:526
       nfnetlink_rcv_skb_batch net/netfilter/nfnetlink.c:649 [inline]
       nfnetlink_rcv+0x3c1/0x430 net/netfilter/nfnetlink.c:667
       netlink_unicast_kernel net/netlink/af_netlink.c:1318 [inline]
       netlink_unicast+0x5aa/0x870 net/netlink/af_netlink.c:1344
       netlink_sendmsg+0x8c8/0xdd0 net/netlink/af_netlink.c:1894
       sock_sendmsg_nosec net/socket.c:727 [inline]
       __sock_sendmsg net/socket.c:742 [inline]
       ____sys_sendmsg+0xa5d/0xc30 net/socket.c:2592
       ___sys_sendmsg+0x134/0x1d0 net/socket.c:2646
       __sys_sendmsg+0x16d/0x220 net/socket.c:2678
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0xcd/0xf80 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #0 (&nft_net->commit_mutex){+.+.}-{4:4}:
       check_prev_add kernel/locking/lockdep.c:3165 [inline]
       check_prevs_add kernel/locking/lockdep.c:3284 [inline]
       validate_chain kernel/locking/lockdep.c:3908 [inline]
       __lock_acquire+0x1669/0x2890 kernel/locking/lockdep.c:5237
       lock_acquire kernel/locking/lockdep.c:5868 [inline]
       lock_acquire+0x179/0x330 kernel/locking/lockdep.c:5825
       __mutex_lock_common kernel/locking/mutex.c:614 [inline]
       __mutex_lock+0x1aa/0x1ca0 kernel/locking/mutex.c:776
       nf_tables_dumpreset_obj+0x6f/0xa0 net/netfilter/nf_tables_api.c:8491
       netlink_dump+0x539/0xd30 net/netlink/af_netlink.c:2325
       __netlink_dump_start+0x6d6/0x990 net/netlink/af_netlink.c:2440
       netlink_dump_start include/linux/netlink.h:341 [inline]
       nft_netlink_dump_start_rcu+0x81/0x1f0 net/netfilter/nf_tables_api.c:1286
       nf_tables_getobj_reset+0x56b/0x6b0 net/netfilter/nf_tables_api.c:8626
       nfnetlink_rcv_msg+0x583/0x1200 net/netfilter/nfnetlink.c:290
       netlink_rcv_skb+0x158/0x420 net/netlink/af_netlink.c:2550
       nfnetlink_rcv+0x1b3/0x430 net/netfilter/nfnetlink.c:669
       netlink_unicast_kernel net/netlink/af_netlink.c:1318 [inline]
       netlink_unicast+0x5aa/0x870 net/netlink/af_netlink.c:1344
       netlink_sendmsg+0x8c8/0xdd0 net/netlink/af_netlink.c:1894
       sock_sendmsg_nosec net/socket.c:727 [inline]
       __sock_sendmsg net/socket.c:742 [inline]
       ____sys_sendmsg+0xa5d/0xc30 net/socket.c:2592
       ___sys_sendmsg+0x134/0x1d0 net/socket.c:2646
       __sys_sendmsg+0x16d/0x220 net/socket.c:2678
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0xcd/0xf80 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

other info that might help us debug this:

Chain exists of:
  &nft_net->commit_mutex --> nfnl_subsys_ipset --> nlk_cb_mutex-NETFILTER

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(nlk_cb_mutex-NETFILTER);
                               lock(nfnl_subsys_ipset);
                               lock(nlk_cb_mutex-NETFILTER);
  lock(&nft_net->commit_mutex);

 *** DEADLOCK ***

1 lock held by syz.3.970/9330:
 #0: ffff88802bce36f0 (nlk_cb_mutex-NETFILTER){+.+.}-{4:4}, at: __netlink_dump_start+0x150/0x990 net/netlink/af_netlink.c:2404

stack backtrace:
CPU: 0 UID: 0 PID: 9330 Comm: syz.3.970 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x116/0x1f0 lib/dump_stack.c:120
 print_circular_bug+0x275/0x340 kernel/locking/lockdep.c:2043
 check_noncircular+0x146/0x160 kernel/locking/lockdep.c:2175
 check_prev_add kernel/locking/lockdep.c:3165 [inline]
 check_prevs_add kernel/locking/lockdep.c:3284 [inline]
 validate_chain kernel/locking/lockdep.c:3908 [inline]
 __lock_acquire+0x1669/0x2890 kernel/locking/lockdep.c:5237
 lock_acquire kernel/locking/lockdep.c:5868 [inline]
 lock_acquire+0x179/0x330 kernel/locking/lockdep.c:5825
 __mutex_lock_common kernel/locking/mutex.c:614 [inline]
 __mutex_lock+0x1aa/0x1ca0 kernel/locking/mutex.c:776
 nf_tables_dumpreset_obj+0x6f/0xa0 net/netfilter/nf_tables_api.c:8491
 netlink_dump+0x539/0xd30 net/netlink/af_netlink.c:2325
 __netlink_dump_start+0x6d6/0x990 net/netlink/af_netlink.c:2440
 netlink_dump_start include/linux/netlink.h:341 [inline]
 nft_netlink_dump_start_rcu+0x81/0x1f0 net/netfilter/nf_tables_api.c:1286
 nf_tables_getobj_reset+0x56b/0x6b0 net/netfilter/nf_tables_api.c:8626
 nfnetlink_rcv_msg+0x583/0x1200 net/netfilter/nfnetlink.c:290
 netlink_rcv_skb+0x158/0x420 net/netlink/af_netlink.c:2550
 nfnetlink_rcv+0x1b3/0x430 net/netfilter/nfnetlink.c:669
 netlink_unicast_kernel net/netlink/af_netlink.c:1318 [inline]
 netlink_unicast+0x5aa/0x870 net/netlink/af_netlink.c:1344
 netlink_sendmsg+0x8c8/0xdd0 net/netlink/af_netlink.c:1894
 sock_sendmsg_nosec net/socket.c:727 [inline]
 __sock_sendmsg net/socket.c:742 [inline]
 ____sys_sendmsg+0xa5d/0xc30 net/socket.c:2592
 ___sys_sendmsg+0x134/0x1d0 net/socket.c:2646
 __sys_sendmsg+0x16d/0x220 net/socket.c:2678
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xcd/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fb7e7b8f7c9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fb7e8a9c038 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007fb7e7de5fa0 RCX: 00007fb7e7b8f7c9
RDX: 0000000004004004 RSI: 0000200000000140 RDI: 0000000000000003
RBP: 00007fb7e7c13f91 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fb7e7de6038 R14: 00007fb7e7de5fa0 R15: 00007fffe518fab8
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
