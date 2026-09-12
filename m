Received: from mail-oi2-f0.google.com (mail-oi2-f0.google.com [74.125.231.192])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8777426D4C3
	for <netfilter-devel@vger.kernel.org>; Sat, 12 Sep 2026 00:57:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.231.192
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789174650; cv=none; b=cRVuBw5qySgM60B5vJMsoiDWqgwyfBkm8IGVu3gtCH5bKWetFCqddGKRbMGFaQN57ehmpu4TZIvOj6sWHPoGfjOsYiXwx+Sis7qA1fib4HhASL7Yyu6TlxBbJXnsAuGxb2r+/w6y81PRWiwa/s2BhIhds18Wktpd1PEkgN8totA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789174650; c=relaxed/simple;
	bh=sfdKITiTTBp/5SdN9B+NauWhSGiWmQ+MMSMPzMhDZMg=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=Zg7Y8Mphh3UZkWPhrqz5Q4pkzUR9CnOv7P8tzdN1eL+WNUNhh3N3w4B+v1lnIFwIQs4vaavEG4WqB/Y5tizkCdpijtpmKYKxeUfVkjmYSgQo4wXVG6Zw5u4sWGyAn2wSfD5ga6LrrNoOvcYttL294VFnt8aAlPAJLCCeIyvQ4yY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=74.125.231.192
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi2-f0.google.com with SMTP id 5614622812f47-4a4492f5cd1so280010b6e.1
        for <netfilter-devel@vger.kernel.org>; Fri, 11 Sep 2026 17:57:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789174647; x=1789779447;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Y2buhqL3+jbmYjdf40xuvgASTB4Cv1cwvnYxQ4HuR5c=;
        b=m1GMlvs6Lg/3/TmkvA4Z5tNWxea1CrEbcqi7Vib84zos8o43KmCxGkDHVpyaFxJOAX
         0ZqAJ7+nJGIX4QQzfebyP2CcbzJBPOX43hR0EeewuKNyM/SdPHHlg3wlQupUUaumCFIw
         4pHULI/4ZJzyt1otJGxmCGeFPGjijME8TTYc34fNuYJu8s58tzVf1NCr3M3jxn4MEb1P
         S5kkzf7Ep6rgI+bb+n4s7iVwqZs2TlI9FwQmtSuaDi1dOJ3m0zTamrIC92lzRkyCeSmu
         Lac/rMl3/2CykVXz1Jc0nXI+TQ0ZQadyvaXkW8+AvgBvGynGpKKF7ihoU/xI0tbdQq0+
         BE8g==
X-Forwarded-Encrypted: i=1; AKwUvBzuyw68jSOnpJ89kK2rAguIjSL02rLd0HsgNJWbLmKTWTHUV6qojvNw0nJUcGrLGOHSi0i2fb5dN5aeGSLRzjw=@vger.kernel.org
X-Gm-Message-State: AFuF++no6VXzWkihkx4xO6ICXkKsMrieLACszKB6xjEmW1JYznk2n7fY
	PbQx56TWVnozuW9zboe4+hkA3RHhOL8TorWTA/gUDvlYP39QYngpliNxHpJATYjS60wo7BL9VVq
	SxPjQI4sxdPKNwYjrc5EpFWXm4SUTvKbgMs+GwUzDXrm9CkPBiBDtMUfeeUc=
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:16ac:b0:6b3:5229:fcd7 with SMTP id
 006d021491bc7-6c24ceaaed3mr634429eaf.16.1789174647429; Fri, 11 Sep 2026
 17:57:27 -0700 (PDT)
Date: Fri, 11 Sep 2026 17:57:27 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6aa4a377.f81106d8.2ab401.0024.GAE@google.com>
Subject: [syzbot] [netfilter?] WARNING: suspicious RCU usage in expect_iter_name
From: syzbot <syzbot+4bd730aede2791e40bdf@syzkaller.appspotmail.com>
To: coreteam@netfilter.org, davem@davemloft.net, edumazet@google.com, 
	fw@strlen.de, horms@kernel.org, kuba@kernel.org, linux-kernel@vger.kernel.org, 
	netdev@vger.kernel.org, netfilter-devel@vger.kernel.org, pabeni@redhat.com, 
	pablo@netfilter.org, phil@nwl.cc, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    15071f2a1263 Merge branch 'bpf-tcp-fix-bpf_sock_destroy-on..
git tree:       bpf
console+strace: https://syzkaller.appspot.com/x/log.txt?x=127ca1f9580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=5e4e3a0e188a497e
dashboard link: https://syzkaller.appspot.com/bug?extid=4bd730aede2791e40bdf
compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17caf749580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=115c9f9e580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/e4f2d0fa738f/disk-15071f2a.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/508ad5098ef2/vmlinux-15071f2a.xz
kernel image: https://storage.googleapis.com/syzbot-assets/c3f06d5bc6b9/bzImage-15071f2a.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+4bd730aede2791e40bdf@syzkaller.appspotmail.com

=============================
WARNING: suspicious RCU usage
syzkaller #0 Not tainted
-----------------------------
net/netfilter/nf_conntrack_netlink.c:3393 suspicious rcu_dereference_check() usage!

other info that might help us debug this:


rcu_scheduler_active = 2, debug_locks = 1
locks held by syz-executor381/5628: 2, last CPU#1:
 #0: ffffffff9aee42a0 (nfnl_subsys_ctnetlink_exp){+.+.}-{4:4}, at: nfnl_lock net/netfilter/nfnetlink.c:96 [inline]
 #0: ffffffff9aee42a0 (nfnl_subsys_ctnetlink_exp){+.+.}-{4:4}, at: nfnetlink_rcv_msg+0xa69/0x12b0 net/netfilter/nfnetlink.c:293
 #1: ffffffff8ea74d58 (nf_conntrack_expect_lock){+...}-{3:3}, at: spin_lock_bh include/linux/spinlock.h:353 [inline]
 #1: ffffffff8ea74d58 (nf_conntrack_expect_lock){+...}-{3:3}, at: nf_ct_expect_iterate_net+0x38/0x180 net/netfilter/nf_conntrack_expect.c:623

stack backtrace:
CPU: 1 UID: 0 PID: 5628 Comm: syz-executor381 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/24/2026
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 lockdep_rcu_suspicious+0x140/0x1d0 kernel/locking/lockdep.c:6972
 expect_iter_name+0xfb/0x100 net/netfilter/nf_conntrack_netlink.c:3393
 nf_ct_expect_iterate_net+0xf2/0x180 net/netfilter/nf_conntrack_expect.c:633
 ctnetlink_del_expect+0x45d/0x640 net/netfilter/nf_conntrack_netlink.c:3455
 nfnetlink_rcv_msg+0xcc2/0x12b0 net/netfilter/nfnetlink.c:300
 netlink_rcv_skb+0x226/0x4a0 net/netlink/af_netlink.c:2556
 nfnetlink_rcv+0x2b9/0x28c0 net/netfilter/nfnetlink.c:667
 netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
 netlink_unicast+0x7bd/0x940 net/netlink/af_netlink.c:1345
 netlink_sendmsg+0x813/0xb40 net/netlink/af_netlink.c:1900
 sock_sendmsg_nosec+0x13a/0x180 net/socket.c:800
 __sock_sendmsg net/socket.c:815 [inline]
 ____sys_sendmsg+0x54e/0x850 net/socket.c:2713
 ___sys_sendmsg+0x2a5/0x360 net/socket.c:2767
 __sys_sendmsg net/socket.c:2799 [inline]
 __do_sys_sendmsg net/socket.c:2804 [inline]
 __se_sys_sendmsg net/socket.c:2802 [inline]
 __x64_sys_sendmsg+0x1b1/0x290 net/socket.c:2802
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fb7651a5649
Code: c0 79 93 eb d5 48 8d 7c 1d 00 eb 99 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 d8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffc2a17f2a8 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007fb7651a5649
RDX: 0000000020000080 RSI: 0000200000000300 RDI: 0000000000000004
RBP: 0000000000000000 R08: 0000000000000006 R09: 0000000000000006
R10: 0000000000000006 R11: 0000000000000246 R12: 0000000000000000
R13: 431bde82d7b634db R14: 00007fb765238c40 R15: 0000000000000002
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
