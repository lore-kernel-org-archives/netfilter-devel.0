Received: from mail-oa1-f78.google.com (mail-oa1-f78.google.com [209.85.160.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C3961E832A
	for <netfilter-devel@vger.kernel.org>; Fri,  2 Jan 2026 02:25:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767320724; cv=none; b=HH+uwxGI2HFLJeVTNxgRJxkLG+aZkjjJmkZZRDMYEGkjMheSvs4xji4A29CT9vrYN07X6ky+Wzw0m2MWLW8lmd4+1Mue5aXKY2xl6+CFNPyvR94+ZCJ48WtwP9g0BE0aw32s9TOM5qYlY9NrmZDwHlhZSDA6Cd8R8hkCat5g/V8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767320724; c=relaxed/simple;
	bh=XhiVjpGD9kG5ZvW871psqt8khBSGzuKtZYMHCsnokks=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=oziSv/Sq472C5IQFiVJ5V1eW8uuyE1HmnnnU5sW7HKh26VBEWB/D41vHp1GF1Eheau4/jB+HTTIxGQtJLST1qo7xzFzucFEm8w5lxUn8nr0LmOBPqjXunpZfaWr7kYNsAffap0bVZwsvrMej4pcGl1ENTAUe1jSrW7JARua1au8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.160.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oa1-f78.google.com with SMTP id 586e51a60fabf-3fea6c3e817so8171873fac.1
        for <netfilter-devel@vger.kernel.org>; Thu, 01 Jan 2026 18:25:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767320721; x=1767925521;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=iNXAqAgcGflW6xRJhSCyAKDKPQaiCihSYEu8ztmzuXk=;
        b=Byd5mj6kIbD3CtU/A1t4Z5VVAWHITvpN9Ur8xDo3kB7cy6gaXQ+bM8cGC2UlhSMTrS
         PGMJfxJ6GPNerkU9wRekTFy5oM+bXQsPN7f2L+WzQtRln1Xq30j2rwyU9Gw5jkiNandu
         x73KL2kuoUQuR9Ym+8/U21haCL4+JbJ2+yZjTDnb2tyHOys9BfZMXnfesXDl2OJfbgu4
         9wBuJWtAiDz3v303CG+g7dDU1ZrySLdmXieEUMFzbLDPsYGzDljm/xbHCns4W9hsrxbz
         cm9utV+d6O97EhphpvPVuxYVUMV1ujvmEZpIks+SCGd6bN6eEog46qiESRLDX+u64H+t
         evgw==
X-Forwarded-Encrypted: i=1; AJvYcCUuB6g6JLVxkDLS80z45xn6jxSW+ujXkeA5lzCiet7sV8CDS21bDZfvhqIrDvGFvBcqLIomCIGAQMi5+8/KfoE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzh11StXLOgAm5ogzp6Ir8okPqDSCtXvj/3TqYR5WPqJd8stAc3
	6WwIKrf6Fr0Nsz0Wqry59b9hNFKGGyOFIjsxCYFZzSa9Ld4DzQcQ6LIOqbmrmZ6+THBDSBwCsO7
	A66v9uD28Br52EKqfKo6+/GucJ8D6wK3BLvEJlajrGSCPM4fwXN0yNbY8gnI=
X-Google-Smtp-Source: AGHT+IEgXwi3DuUDXjaNhG2fYM/nOMFwE8lzSb9m6Ai1XD3w2WBhM68kSw99+vRKtOaWaeuw4R23aabV4FLCKJZmxGk58kw7VSQx
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:6481:b0:65c:f363:fe06 with SMTP id
 006d021491bc7-65cfe7d1734mr13535185eaf.42.1767320721022; Thu, 01 Jan 2026
 18:25:21 -0800 (PST)
Date: Thu, 01 Jan 2026 18:25:21 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69572c91.050a0220.a1b6.034b.GAE@google.com>
Subject: [syzbot] [netfilter?] INFO: task hung in nfnetlink_rcv_msg (5)
From: syzbot <syzbot+c4b20b80ee6a7a2f5012@syzkaller.appspotmail.com>
To: coreteam@netfilter.org, davem@davemloft.net, edumazet@google.com, 
	fw@strlen.de, horms@kernel.org, kadlec@netfilter.org, kuba@kernel.org, 
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org, 
	netfilter-devel@vger.kernel.org, pabeni@redhat.com, pablo@netfilter.org, 
	phil@nwl.cc, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    c9b47175e913 Merge tag 'i2c-for-6.19-rc1' of git://git.ker..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=12bd3992580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=b60f8d9470fe9d28
dashboard link: https://syzkaller.appspot.com/bug?extid=c4b20b80ee6a7a2f5012
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/925ba1d27063/disk-c9b47175.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/fd9b311222a4/vmlinux-c9b47175.xz
kernel image: https://storage.googleapis.com/syzbot-assets/8fa7a5cb2cbc/bzImage-c9b47175.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+c4b20b80ee6a7a2f5012@syzkaller.appspotmail.com

INFO: task syz.6.3244:18586 blocked for more than 143 seconds.
      Tainted: G             L      syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz.6.3244      state:D stack:26472 pid:18586 tgid:18584 ppid:17031  task_flags:0x400140 flags:0x00080002
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5256 [inline]
 __schedule+0x14bc/0x5000 kernel/sched/core.c:6863
 __schedule_loop kernel/sched/core.c:6945 [inline]
 schedule+0x165/0x360 kernel/sched/core.c:6960
 schedule_preempt_disabled+0x13/0x30 kernel/sched/core.c:7017
 __mutex_lock_common kernel/locking/mutex.c:692 [inline]
 __mutex_lock+0x7e6/0x1350 kernel/locking/mutex.c:776
 nfnl_lock net/netfilter/nfnetlink.c:98 [inline]
 nfnetlink_rcv_msg+0x9dc/0x1130 net/netfilter/nfnetlink.c:295
 netlink_rcv_skb+0x208/0x470 net/netlink/af_netlink.c:2550
 nfnetlink_rcv+0x282/0x2590 net/netfilter/nfnetlink.c:669
 netlink_unicast_kernel net/netlink/af_netlink.c:1318 [inline]
 netlink_unicast+0x82f/0x9e0 net/netlink/af_netlink.c:1344
 netlink_sendmsg+0x805/0xb30 net/netlink/af_netlink.c:1894
 sock_sendmsg_nosec net/socket.c:727 [inline]
 __sock_sendmsg+0x21c/0x270 net/socket.c:742
 ____sys_sendmsg+0x505/0x820 net/socket.c:2592
 ___sys_sendmsg+0x21f/0x2a0 net/socket.c:2646
 __sys_sendmsg net/socket.c:2678 [inline]
 __do_sys_sendmsg net/socket.c:2683 [inline]
 __se_sys_sendmsg net/socket.c:2681 [inline]
 __x64_sys_sendmsg+0x19b/0x260 net/socket.c:2681
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f9fb618f749
RSP: 002b:00007f9fb6f56038 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007f9fb63e5fa0 RCX: 00007f9fb618f749
RDX: 0000000000000000 RSI: 0000200000000040 RDI: 0000000000000005
RBP: 00007f9fb6213f91 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f9fb63e6038 R14: 00007f9fb63e5fa0 R15: 00007f9fb650fa28
 </TASK>
INFO: task syz.8.3259:18660 blocked for more than 144 seconds.
      Tainted: G             L      syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz.8.3259      state:D stack:24904 pid:18660 tgid:18659 ppid:14215  task_flags:0x400140 flags:0x00080002
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5256 [inline]
 __schedule+0x14bc/0x5000 kernel/sched/core.c:6863
 __schedule_loop kernel/sched/core.c:6945 [inline]
 schedule+0x165/0x360 kernel/sched/core.c:6960
 schedule_preempt_disabled+0x13/0x30 kernel/sched/core.c:7017
 __mutex_lock_common kernel/locking/mutex.c:692 [inline]
 __mutex_lock+0x7e6/0x1350 kernel/locking/mutex.c:776
 nfnl_lock net/netfilter/nfnetlink.c:98 [inline]
 nfnetlink_rcv_msg+0x9dc/0x1130 net/netfilter/nfnetlink.c:295
 netlink_rcv_skb+0x208/0x470 net/netlink/af_netlink.c:2550
 nfnetlink_rcv+0x282/0x2590 net/netfilter/nfnetlink.c:669
 netlink_unicast_kernel net/netlink/af_netlink.c:1318 [inline]
 netlink_unicast+0x82f/0x9e0 net/netlink/af_netlink.c:1344
 netlink_sendmsg+0x805/0xb30 net/netlink/af_netlink.c:1894
 sock_sendmsg_nosec net/socket.c:727 [inline]
 __sock_sendmsg+0x21c/0x270 net/socket.c:742
 ____sys_sendmsg+0x505/0x820 net/socket.c:2592
 ___sys_sendmsg+0x21f/0x2a0 net/socket.c:2646
 __sys_sendmsg net/socket.c:2678 [inline]
 __do_sys_sendmsg net/socket.c:2683 [inline]
 __se_sys_sendmsg net/socket.c:2681 [inline]
 __x64_sys_sendmsg+0x19b/0x260 net/socket.c:2681
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fa675b8f749
RSP: 002b:00007fa676af6038 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007fa675de5fa0 RCX: 00007fa675b8f749
RDX: 0000000000000080 RSI: 00002000000002c0 RDI: 000000000000000a
RBP: 00007fa675c13f91 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fa675de6038 R14: 00007fa675de5fa0 R15: 00007fa675f0fa28
 </TASK>

Showing all locks held in the system:
1 lock held by khungtaskd/31:
 #0: ffffffff8df419e0 (rcu_read_lock){....}-{1:3}, at: rcu_lock_acquire include/linux/rcupdate.h:331 [inline]
 #0: ffffffff8df419e0 (rcu_read_lock){....}-{1:3}, at: rcu_read_lock include/linux/rcupdate.h:867 [inline]
 #0: ffffffff8df419e0 (rcu_read_lock){....}-{1:3}, at: debug_show_all_locks+0x2e/0x180 kernel/locking/lockdep.c:6775
2 locks held by getty/5584:
 #0: ffff88814e12e0a0 (&tty->ldisc_sem){++++}-{0:0}, at: tty_ldisc_ref_wait+0x25/0x70 drivers/tty/tty_ldisc.c:243
 #1: ffffc9000332b2f0 (&ldata->atomic_read_lock){+.+.}-{4:4}, at: n_tty_read+0x449/0x1460 drivers/tty/n_tty.c:2211
4 locks held by kworker/u8:15/5950:
2 locks held by syz.1.1820/12285:
5 locks held by kworker/1:8/12380:
 #0: ffff88801fe93948 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3232 [inline]
 #0: ffff88801fe93948 ((wq_completion)usb_hub_wq){+.+.}-{0:0}, at: process_scheduled_works+0x9b4/0x1770 kernel/workqueue.c:3340
 #1: ffffc9000b58fb80 ((work_completion)(&hub->events)){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3233 [inline]
 #1: ffffc9000b58fb80 ((work_completion)(&hub->events)){+.+.}-{0:0}, at: process_scheduled_works+0x9ef/0x1770 kernel/workqueue.c:3340
 #2: ffff888028045198 (&dev->mutex){....}-{4:4}, at: device_lock include/linux/device.h:895 [inline]
 #2: ffff888028045198 (&dev->mutex){....}-{4:4}, at: hub_event+0x187/0x4ef0 drivers/usb/core/hub.c:5899
 #3: ffff888053b10198 (&dev->mutex){....}-{4:4}, at: device_lock include/linux/device.h:895 [inline]
 #3: ffff888053b10198 (&dev->mutex){....}-{4:4}, at: __device_attach+0x88/0x430 drivers/base/dd.c:1006
 #4: ffff888053b15160 (&dev->mutex){....}-{4:4}, at: device_lock include/linux/device.h:895 [inline]
 #4: ffff888053b15160 (&dev->mutex){....}-{4:4}, at: __device_attach+0x88/0x430 drivers/base/dd.c:1006
4 locks held by udevd/17748:
 #0: ffff88805ce04790 (&p->lock){+.+.}-{4:4}, at: seq_read_iter+0xb7/0xe20 fs/seq_file.c:182
 #1: ffff888055614488 (&of->mutex#2){+.+.}-{4:4}, at: kernfs_seq_start+0x5c/0x420 fs/kernfs/file.c:172
 #2: ffff888057715968 (kn->active#21){++++}-{0:0}, at: kernfs_get_active_of fs/kernfs/file.c:80 [inline]
 #2: ffff888057715968 (kn->active#21){++++}-{0:0}, at: kernfs_seq_start+0xb2/0x420 fs/kernfs/file.c:173
 #3: ffff888053b10198 (&dev->mutex){....}-{4:4}, at: device_lock_interruptible include/linux/device.h:900 [inline]
 #3: ffff888053b10198 (&dev->mutex){....}-{4:4}, at: manufacturer_show+0x26/0xa0 drivers/usb/core/sysfs.c:142
1 lock held by syz.6.3244/18586:
 #0: ffffffff99dc8278 (nfnl_subsys_ipset){+.+.}-{4:4}, at: nfnl_lock net/netfilter/nfnetlink.c:98 [inline]
 #0: ffffffff99dc8278 (nfnl_subsys_ipset){+.+.}-{4:4}, at: nfnetlink_rcv_msg+0x9dc/0x1130 net/netfilter/nfnetlink.c:295
1 lock held by syz.8.3259/18660:
 #0: ffffffff99dc8278 (nfnl_subsys_ipset){+.+.}-{4:4}, at: nfnl_lock net/netfilter/nfnetlink.c:98 [inline]
 #0: ffffffff99dc8278 (nfnl_subsys_ipset){+.+.}-{4:4}, at: nfnetlink_rcv_msg+0x9dc/0x1130 net/netfilter/nfnetlink.c:295
1 lock held by syz.3.3449/19803:
 #0: ffffffff99dc8278 (nfnl_subsys_ipset){+.+.}-{4:4}, at: nfnl_lock net/netfilter/nfnetlink.c:98 [inline]
 #0: ffffffff99dc8278 (nfnl_subsys_ipset){+.+.}-{4:4}, at: nfnetlink_rcv_msg+0x9dc/0x1130 net/netfilter/nfnetlink.c:295
1 lock held by syz.7.3593/20594:
 #0: ffffffff99dc8278 (nfnl_subsys_ipset){+.+.}-{4:4}, at: nfnl_lock net/netfilter/nfnetlink.c:98 [inline]
 #0: ffffffff99dc8278 (nfnl_subsys_ipset){+.+.}-{4:4}, at: nfnetlink_rcv_msg+0x9dc/0x1130 net/netfilter/nfnetlink.c:295
1 lock held by syz.4.3613/20669:
 #0: ffffffff99dc8278 (nfnl_subsys_ipset){+.+.}-{4:4}, at: nfnl_lock net/netfilter/nfnetlink.c:98 [inline]
 #0: ffffffff99dc8278 (nfnl_subsys_ipset){+.+.}-{4:4}, at: nfnetlink_rcv_msg+0x9dc/0x1130 net/netfilter/nfnetlink.c:295
1 lock held by syz.4.3613/20670:
 #0: ffffffff99dc8278 (nfnl_subsys_ipset){+.+.}-{4:4}, at: nfnl_lock net/netfilter/nfnetlink.c:98 [inline]
 #0: ffffffff99dc8278 (nfnl_subsys_ipset){+.+.}-{4:4}, at: nfnetlink_rcv_msg+0x9dc/0x1130 net/netfilter/nfnetlink.c:295
1 lock held by syz.4.3613/20671:
 #0: ffffffff99dc8278 (nfnl_subsys_ipset){+.+.}-{4:4}, at: nfnl_lock net/netfilter/nfnetlink.c:98 [inline]
 #0: ffffffff99dc8278 (nfnl_subsys_ipset){+.+.}-{4:4}, at: nfnetlink_rcv_msg+0x9dc/0x1130 net/netfilter/nfnetlink.c:295
1 lock held by syz.5.3626/20714:
 #0: ffffffff99dc8278 (nfnl_subsys_ipset){+.+.}-{4:4}, at: nfnl_lock net/netfilter/nfnetlink.c:98 [inline]
 #0: ffffffff99dc8278 (nfnl_subsys_ipset){+.+.}-{4:4}, at: nfnetlink_rcv_msg+0x9dc/0x1130 net/netfilter/nfnetlink.c:295
1 lock held by syz.1.3655/20911:
 #0: ffffffff99dc8278 (nfnl_subsys_ipset){+.+.}-{4:4}, at: nfnl_lock net/netfilter/nfnetlink.c:98 [inline]
 #0: ffffffff99dc8278 (nfnl_subsys_ipset){+.+.}-{4:4}, at: nfnetlink_rcv_msg+0x9dc/0x1130 net/netfilter/nfnetlink.c:295
1 lock held by syz.0.3714/21320:
 #0: ffffffff99dc8278 (nfnl_subsys_ipset){+.+.}-{4:4}, at: nfnl_lock net/netfilter/nfnetlink.c:98 [inline]
 #0: ffffffff99dc8278 (nfnl_subsys_ipset){+.+.}-{4:4}, at: nfnetlink_rcv_msg+0x9dc/0x1130 net/netfilter/nfnetlink.c:295
1 lock held by syz.6.3716/21340:
 #0: ffffffff99dc8278 (nfnl_subsys_ipset){+.+.}-{4:4}, at: nfnl_lock net/netfilter/nfnetlink.c:98 [inline]
 #0: ffffffff99dc8278 (nfnl_subsys_ipset){+.+.}-{4:4}, at: nfnetlink_rcv_msg+0x9dc/0x1130 net/netfilter/nfnetlink.c:295
1 lock held by syz.2.3719/21363:
 #0: ffffffff99dc8278 (nfnl_subsys_ipset){+.+.}-{4:4}, at: nfnl_lock net/netfilter/nfnetlink.c:98 [inline]
 #0: ffffffff99dc8278 (nfnl_subsys_ipset){+.+.}-{4:4}, at: nfnetlink_rcv_msg+0x9dc/0x1130 net/netfilter/nfnetlink.c:295
1 lock held by syz.8.3731/21463:
 #0: ffffffff99dc8278 (nfnl_subsys_ipset){+.+.}-{4:4}, at: nfnl_lock net/netfilter/nfnetlink.c:98 [inline]
 #0: ffffffff99dc8278 (nfnl_subsys_ipset){+.+.}-{4:4}, at: nfnetlink_rcv_msg+0x9dc/0x1130 net/netfilter/nfnetlink.c:295
1 lock held by syz.9.3734/21464:
 #0: ffffffff8df47538 (rcu_state.exp_mutex){+.+.}-{4:4}, at: exp_funnel_lock kernel/rcu/tree_exp.h:311 [inline]
 #0: ffffffff8df47538 (rcu_state.exp_mutex){+.+.}-{4:4}, at: synchronize_rcu_expedited+0x2f6/0x730 kernel/rcu/tree_exp.h:956

=============================================

NMI backtrace for cpu 1
CPU: 1 UID: 0 PID: 31 Comm: khungtaskd Tainted: G             L      syzkaller #0 PREEMPT(full) 
Tainted: [L]=SOFTLOCKUP
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/25/2025
Call Trace:
 <TASK>
 dump_stack_lvl+0x189/0x250 lib/dump_stack.c:120
 nmi_cpu_backtrace+0x39e/0x3d0 lib/nmi_backtrace.c:113
 nmi_trigger_cpumask_backtrace+0x17a/0x300 lib/nmi_backtrace.c:62
 trigger_all_cpu_backtrace include/linux/nmi.h:160 [inline]
 __sys_info lib/sys_info.c:157 [inline]
 sys_info+0x135/0x170 lib/sys_info.c:165
 check_hung_uninterruptible_tasks kernel/hung_task.c:346 [inline]
 watchdog+0xf95/0xfe0 kernel/hung_task.c:515
 kthread+0x711/0x8a0 kernel/kthread.c:463
 ret_from_fork+0x599/0xb30 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:246
 </TASK>
Sending NMI from CPU 1 to CPUs 0:
NMI backtrace for cpu 0
CPU: 0 UID: 0 PID: 0 Comm: swapper/0 Tainted: G             L      syzkaller #0 PREEMPT(full) 
Tainted: [L]=SOFTLOCKUP
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/25/2025
RIP: 0010:hlock_class kernel/locking/lockdep.c:229 [inline]
RIP: 0010:check_wait_context kernel/locking/lockdep.c:4879 [inline]
RIP: 0010:__lock_acquire+0x518/0x2cf0 kernel/locking/lockdep.c:5187
Code: 1d 44 89 e0 49 ff c7 49 63 8e 28 0b 00 00 48 83 c3 28 41 89 c4 49 39 cf 0f 8d c7 00 00 00 49 83 ff 31 0f 83 83 00 00 00 8b 03 <25> ff 1f 00 00 48 0f a3 05 7b 96 e7 11 73 10 48 69 c0 c8 00 00 00
RSP: 0018:ffffc90000007170 EFLAGS: 00000097
RAX: 0000000000022007 RBX: ffffffff8dc95e90 RCX: 00000000ffffffff
RDX: 0000000000000003 RSI: 0000000000002000 RDI: 0000000000000000
RBP: ffffffff8dc95ec0 R08: ffffffff81743f85 R09: ffffffff8df419e0
R10: ffffc90000007478 R11: ffffffff81ad9fb0 R12: ffffffffffffff03
R13: ffffffff8dc95ec0 R14: ffffffff8dc95340 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff888125e3a000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055be7a9c1000 CR3: 000000007e93c000 CR4: 00000000003526f0
Call Trace:
 <IRQ>
 lock_acquire+0x117/0x340 kernel/locking/lockdep.c:5868
 rcu_lock_acquire include/linux/rcupdate.h:331 [inline]
 rcu_read_lock include/linux/rcupdate.h:867 [inline]
 class_rcu_constructor include/linux/rcupdate.h:1195 [inline]
 unwind_next_frame+0xc2/0x2390 arch/x86/kernel/unwind_orc.c:479
 arch_stack_walk+0x11c/0x150 arch/x86/kernel/stacktrace.c:25
 stack_trace_save+0x9c/0xe0 kernel/stacktrace.c:122
 kasan_save_stack mm/kasan/common.c:56 [inline]
 kasan_save_track+0x3e/0x80 mm/kasan/common.c:77
 unpoison_slab_object mm/kasan/common.c:339 [inline]
 __kasan_slab_alloc+0x6c/0x80 mm/kasan/common.c:365
 kasan_slab_alloc include/linux/kasan.h:252 [inline]
 slab_post_alloc_hook mm/slub.c:4948 [inline]
 slab_alloc_node mm/slub.c:5258 [inline]
 kmem_cache_alloc_node_noprof+0x43c/0x720 mm/slub.c:5310
 kmalloc_reserve+0xbd/0x290 net/core/skbuff.c:586
 __alloc_skb+0x27e/0x430 net/core/skbuff.c:690
 __netdev_alloc_skb+0x108/0x960 net/core/skbuff.c:754
 netdev_alloc_skb include/linux/skbuff.h:3484 [inline]
 dev_alloc_skb include/linux/skbuff.h:3497 [inline]
 __ieee80211_beacon_get+0xc06/0x1880 net/mac80211/tx.c:5654
 ieee80211_beacon_get_tim+0xb4/0x2b0 net/mac80211/tx.c:5776
 ieee80211_beacon_get include/net/mac80211.h:5669 [inline]
 mac80211_hwsim_beacon_tx+0x3c5/0x870 drivers/net/wireless/virtual/mac80211_hwsim.c:2361
 __iterate_interfaces+0x2ab/0x590 net/mac80211/util.c:761
 ieee80211_iterate_active_interfaces_atomic+0xdb/0x180 net/mac80211/util.c:797
 mac80211_hwsim_beacon+0xbb/0x180 drivers/net/wireless/virtual/mac80211_hwsim.c:2395
 __run_hrtimer kernel/time/hrtimer.c:1777 [inline]
 __hrtimer_run_queues+0x51c/0xc30 kernel/time/hrtimer.c:1841
 hrtimer_run_softirq+0x187/0x2b0 kernel/time/hrtimer.c:1858
 handle_softirqs+0x27d/0x850 kernel/softirq.c:622
 __do_softirq kernel/softirq.c:656 [inline]
 invoke_softirq kernel/softirq.c:496 [inline]
 __irq_exit_rcu+0xca/0x1f0 kernel/softirq.c:723
 irq_exit_rcu+0x9/0x30 kernel/softirq.c:739
 instr_sysvec_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1056 [inline]
 sysvec_apic_timer_interrupt+0xa6/0xc0 arch/x86/kernel/apic/apic.c:1056
 </IRQ>
 <TASK>
 asm_sysvec_apic_timer_interrupt+0x1a/0x20 arch/x86/include/asm/idtentry.h:697
RIP: 0010:pv_native_safe_halt+0x13/0x20 arch/x86/kernel/paravirt.c:82
Code: 13 ee 02 00 cc cc cc 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 f3 0f 1e fa 66 90 0f 00 2d f3 50 0d 00 f3 0f 1e fa fb f4 <c3> cc cc cc cc cc cc cc cc cc cc cc cc 90 90 90 90 90 90 90 90 90
RSP: 0018:ffffffff8dc07d80 EFLAGS: 000002c6
RAX: 5f11becca7314500 RBX: ffffffff81978eba RCX: 5f11becca7314500
RDX: 0000000000000001 RSI: ffffffff8d78fddd RDI: ffffffff8bc07960
RBP: ffffffff8dc07ea8 R08: ffff8880b86336db R09: 1ffff110170c66db
R10: dffffc0000000000 R11: ffffed10170c66dc R12: ffffffff8f81f870
R13: 1ffffffff1b92a68 R14: 0000000000000000 R15: 0000000000000000
 arch_safe_halt arch/x86/include/asm/paravirt.h:107 [inline]
 default_idle+0x13/0x20 arch/x86/kernel/process.c:767
 default_idle_call+0x73/0xb0 kernel/sched/idle.c:122
 cpuidle_idle_call kernel/sched/idle.c:191 [inline]
 do_idle+0x1ea/0x520 kernel/sched/idle.c:332
 cpu_startup_entry+0x44/0x60 kernel/sched/idle.c:430
 rest_init+0x2de/0x300 init/main.c:757
 start_kernel+0x3a7/0x400 init/main.c:1206
 x86_64_start_reservations+0x24/0x30 arch/x86/kernel/head64.c:310
 x86_64_start_kernel+0x143/0x1c0 arch/x86/kernel/head64.c:291
 common_startup_64+0x13e/0x147
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
