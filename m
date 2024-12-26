Received: from mail-io1-f77.google.com (mail-io1-f77.google.com [209.85.166.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23D7417278D
	for <netfilter-devel@vger.kernel.org>; Thu, 26 Dec 2024 09:45:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.77
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735206325; cv=none; b=kUsAshBMt4QZCwvC4xsFsfZDCj33S6LL4ihINnAslral4exRPVFT8y9hIrnxhSkJ5HKPGrRyC49eaflPxxpjLZOhnvL9sisyIeezpy+aNnht/emR1J3Epmpw2QN3KRKusli4U91np1GImPcAkBkEmufEzhdXQYo2/szZzisYi4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735206325; c=relaxed/simple;
	bh=ukNxKuQeG4A2ckvjJQ/Ock42+GJAK9dnLGjYccvKYpk=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=egj8gR5UDg94974XyAsB2oqtu/KZJUGZyrUyNp6Shhgnn2zPzn+8aaJZ1mYVGHfrRBURiaHua10RUYlAeN2R+qRCDoWt1tT9Rr60i1KQkC1omWNzB62ZPrUID2fCsHNvIThvyvdgccKPy3ifctqs3frpEyIIiRthhoBxJPCIdoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f77.google.com with SMTP id ca18e2360f4ac-844dfe8dad5so1117609039f.1
        for <netfilter-devel@vger.kernel.org>; Thu, 26 Dec 2024 01:45:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735206322; x=1735811122;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Rl2QlGOpoARejqPekpD/D0qvG4MZxGycARNPehxhvYI=;
        b=pqlNIYFM5zY0YFwBYe648OZDwguC0zEAtjoNHeRkGZpRbZyCPfSOLip6jCRcZij60q
         Wrk89emSABf/XVMY0uoVyuzsFXjQeb5S599xIBmAeL47ARswBBmrdLKB3yMI9SgcuyZ3
         8dgoVrPn0SuD2ALap0tQ7pTBR9MpHRxvT+fFtt7MKbBH6vY9eJIOQlY+2MikzrbQZbYB
         xXD1RB/dXEw5Ugrxvw5JwWQuUl3YiCIMdZ/ESO6RYz98PJ1zaGFOiEmwHJ8U41CMqAaE
         8XxoMq1DKJMrWgBqo0pZHxTeWHb+IH9QKnMwaNNWqWyhr2YSbpwmTmAu84nQhqe6JTU1
         Xh7w==
X-Forwarded-Encrypted: i=1; AJvYcCXtbgUWHdDWElqqCB4OTTxsYkh/XmmVF0eTS7D4rc778gJHJkcUzliuk0TIERO8UAhLg2EKUyVM6RVTqfQzOYA=@vger.kernel.org
X-Gm-Message-State: AOJu0YyGbcfHiTKQJCm2HMvCbIZKquxz8ST/fXToSv4GP95qj1CoVMuh
	D3m3ctexZA862AWKC6m0n+enn/82qzKW5/UW4gm/8ZObRm7Sus4lWX26fA78F1rmJ/+DBms6L93
	O718P38ztfhBXVT9pgrW/zYdlOvem3H3xRB5Hq5Qg6z5qchI4fvgScnk=
X-Google-Smtp-Source: AGHT+IFKPEdWcUCVxFbuxMqCF+xVp95cwsfGDcboGgY1YtbcYr0l+gi/cklRsNIJ3OHlhwx0cvGFQ9zR3BC4YkR7BpLxx4xxZncI
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6602:6b86:b0:83b:5221:2a87 with SMTP id
 ca18e2360f4ac-8499e4f30d2mr2343358439f.3.1735206322379; Thu, 26 Dec 2024
 01:45:22 -0800 (PST)
Date: Thu, 26 Dec 2024 01:45:22 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <676d25b2.050a0220.2f3838.0464.GAE@google.com>
Subject: [syzbot] [netfilter?] INFO: task hung in inet_rtm_newaddr
From: syzbot <syzbot+adeb8550754921fece20@syzkaller.appspotmail.com>
To: davem@davemloft.net, dsahern@kernel.org, edumazet@google.com, 
	horms@kernel.org, jhs@mojatatu.com, jiri@resnulli.us, kadlec@netfilter.org, 
	kuba@kernel.org, linux-kernel@vger.kernel.org, netdev@vger.kernel.org, 
	netfilter-devel@vger.kernel.org, pabeni@redhat.com, pablo@netfilter.org, 
	syzkaller-bugs@googlegroups.com, vinicius.gomes@intel.com, 
	xiyou.wangcong@gmail.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    f932fb9b4074 Merge tag 'v6.13-rc2-ksmbd-server-fixes' of g..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=17fac730580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=fee25f93665c89ac
dashboard link: https://syzkaller.appspot.com/bug?extid=adeb8550754921fece20
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=110c5cdf980000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/25e1e42a2e65/disk-f932fb9b.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/505a28658f18/vmlinux-f932fb9b.xz
kernel image: https://storage.googleapis.com/syzbot-assets/f958e9890511/bzImage-f932fb9b.xz

The issue was bisected to:

commit 5a781ccbd19e4664babcbe4b4ead7aa2b9283d22
Author: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Date:   Sat Sep 29 00:59:43 2018 +0000

    tc: Add support for configuring the taprio scheduler

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=10de9adf980000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=12de9adf980000
console output: https://syzkaller.appspot.com/x/log.txt?x=14de9adf980000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+adeb8550754921fece20@syzkaller.appspotmail.com
Fixes: 5a781ccbd19e ("tc: Add support for configuring the taprio scheduler")

INFO: task syz-executor:5945 blocked for more than 163 seconds.
      Not tainted 6.13.0-rc2-syzkaller-00159-gf932fb9b4074 #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor    state:D stack:20352 pid:5945  tgid:5945  ppid:5935   flags:0x00000000
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5369 [inline]
 __schedule+0x1850/0x4c30 kernel/sched/core.c:6756
 __schedule_loop kernel/sched/core.c:6833 [inline]
 schedule+0x14b/0x320 kernel/sched/core.c:6848
 schedule_preempt_disabled+0x13/0x30 kernel/sched/core.c:6905
 __mutex_lock_common kernel/locking/mutex.c:665 [inline]
 __mutex_lock+0x7e7/0xee0 kernel/locking/mutex.c:735
 rtnl_net_lock include/linux/rtnetlink.h:128 [inline]
 inet_rtm_newaddr+0x47e/0x1bd0 net/ipv4/devinet.c:987
 rtnetlink_rcv_msg+0x791/0xcf0 net/core/rtnetlink.c:6921
 netlink_rcv_skb+0x1e3/0x430 net/netlink/af_netlink.c:2542
 netlink_unicast_kernel net/netlink/af_netlink.c:1321 [inline]
 netlink_unicast+0x7f6/0x990 net/netlink/af_netlink.c:1347
 netlink_sendmsg+0x8e4/0xcb0 net/netlink/af_netlink.c:1891
 sock_sendmsg_nosec net/socket.c:711 [inline]
 __sock_sendmsg+0x221/0x270 net/socket.c:726
 __sys_sendto+0x363/0x4c0 net/socket.c:2197
 __do_sys_sendto net/socket.c:2204 [inline]
 __se_sys_sendto net/socket.c:2200 [inline]
 __x64_sys_sendto+0xde/0x100 net/socket.c:2200
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f9730187bac
RSP: 002b:00007f973049f670 EFLAGS: 00000293 ORIG_RAX: 000000000000002c
RAX: ffffffffffffffda RBX: 00007f9730ea4620 RCX: 00007f9730187bac
RDX: 0000000000000028 RSI: 00007f9730ea4670 RDI: 0000000000000003
RBP: 0000000000000000 R08: 00007f973049f6c4 R09: 000000000000000c
R10: 0000000000000000 R11: 0000000000000293 R12: 0000000000000003
R13: 0000000000000000 R14: 00007f9730ea4670 R15: 0000000000000000
 </TASK>
INFO: task syz-executor:5946 blocked for more than 163 seconds.
      Not tainted 6.13.0-rc2-syzkaller-00159-gf932fb9b4074 #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor    state:D stack:18832 pid:5946  tgid:5946  ppid:5934   flags:0x00004000
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5369 [inline]
 __schedule+0x1850/0x4c30 kernel/sched/core.c:6756
 __schedule_loop kernel/sched/core.c:6833 [inline]
 schedule+0x14b/0x320 kernel/sched/core.c:6848
 schedule_preempt_disabled+0x13/0x30 kernel/sched/core.c:6905
 __mutex_lock_common kernel/locking/mutex.c:665 [inline]
 __mutex_lock+0x7e7/0xee0 kernel/locking/mutex.c:735
 ieee80211_register_hw+0x2c4e/0x3e10 net/mac80211/main.c:1520
 mac80211_hwsim_new_radio+0x2a9f/0x4a90 drivers/net/wireless/virtual/mac80211_hwsim.c:5519
 hwsim_new_radio_nl+0xece/0x2290 drivers/net/wireless/virtual/mac80211_hwsim.c:6203
 genl_family_rcv_msg_doit net/netlink/genetlink.c:1115 [inline]
 genl_family_rcv_msg net/netlink/genetlink.c:1195 [inline]
 genl_rcv_msg+0xb14/0xec0 net/netlink/genetlink.c:1210
 netlink_rcv_skb+0x1e3/0x430 net/netlink/af_netlink.c:2542
 genl_rcv+0x28/0x40 net/netlink/genetlink.c:1219
 netlink_unicast_kernel net/netlink/af_netlink.c:1321 [inline]
 netlink_unicast+0x7f6/0x990 net/netlink/af_netlink.c:1347
 netlink_sendmsg+0x8e4/0xcb0 net/netlink/af_netlink.c:1891
 sock_sendmsg_nosec net/socket.c:711 [inline]
 __sock_sendmsg+0x221/0x270 net/socket.c:726
 __sys_sendto+0x363/0x4c0 net/socket.c:2197
 __do_sys_sendto net/socket.c:2204 [inline]
 __se_sys_sendto net/socket.c:2200 [inline]
 __x64_sys_sendto+0xde/0x100 net/socket.c:2200
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fdf0ef87bac
RSP: 002b:00007fdf0f29fe80 EFLAGS: 00000293 ORIG_RAX: 000000000000002c
RAX: ffffffffffffffda RBX: 00007fdf0fca4620 RCX: 00007fdf0ef87bac
RDX: 0000000000000024 RSI: 00007fdf0fca4670 RDI: 0000000000000003
RBP: 0000000000000000 R08: 00007fdf0f29fed4 R09: 000000000000000c
R10: 0000000000000000 R11: 0000000000000293 R12: 0000000000000003
R13: 0000000000000000 R14: 00007fdf0fca4670 R15: 0000000000000000
 </TASK>

Showing all locks held in the system:
3 locks held by kworker/0:1/9:
 #0: ffff88801ac81948 ((wq_completion)events_power_efficient){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3204 [inline]
 #0: ffff88801ac81948 ((wq_completion)events_power_efficient){+.+.}-{0:0}, at: process_scheduled_works+0x93b/0x1840 kernel/workqueue.c:3310
 #1: ffffc900000e7d00 ((reg_check_chans).work){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3205 [inline]
 #1: ffffc900000e7d00 ((reg_check_chans).work){+.+.}-{0:0}, at: process_scheduled_works+0x976/0x1840 kernel/workqueue.c:3310
 #2: ffffffff8fcb13c8 (rtnl_mutex){+.+.}-{4:4}, at: reg_check_chans_work+0x99/0xfb0 net/wireless/reg.c:2480
3 locks held by kworker/1:0/25:
 #0: ffff88801ac80948 ((wq_completion)events){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3204 [inline]
 #0: ffff88801ac80948 ((wq_completion)events){+.+.}-{0:0}, at: process_scheduled_works+0x93b/0x1840 kernel/workqueue.c:3310
 #1: ffffc900001f7d00 ((work_completion)(&data->fib_event_work)){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3205 [inline]
 #1: ffffc900001f7d00 ((work_completion)(&data->fib_event_work)){+.+.}-{0:0}, at: process_scheduled_works+0x976/0x1840 kernel/workqueue.c:3310
 #2: ffff888034a42240 (&data->fib_lock){+.+.}-{4:4}, at: nsim_fib_event_work+0x2d1/0x4130 drivers/net/netdevsim/fib.c:1490
1 lock held by khungtaskd/30:
 #0: ffffffff8e937ae0 (rcu_read_lock){....}-{1:3}, at: rcu_lock_acquire include/linux/rcupdate.h:337 [inline]
 #0: ffffffff8e937ae0 (rcu_read_lock){....}-{1:3}, at: rcu_read_lock include/linux/rcupdate.h:849 [inline]
 #0: ffffffff8e937ae0 (rcu_read_lock){....}-{1:3}, at: debug_show_all_locks+0x55/0x2a0 kernel/locking/lockdep.c:6744
3 locks held by kworker/u9:0/54:
 #0: ffff888029ce0148 ((wq_completion)hci3){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3204 [inline]
 #0: ffff888029ce0148 ((wq_completion)hci3){+.+.}-{0:0}, at: process_scheduled_works+0x93b/0x1840 kernel/workqueue.c:3310
 #1: ffffc90000be7d00 ((work_completion)(&hdev->cmd_sync_work)){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3205 [inline]
 #1: ffffc90000be7d00 ((work_completion)(&hdev->cmd_sync_work)){+.+.}-{0:0}, at: process_scheduled_works+0x976/0x1840 kernel/workqueue.c:3310
 #2: ffff888029c40d80 (&hdev->req_lock){+.+.}-{4:4}, at: hci_cmd_sync_work+0x1ec/0x400 net/bluetooth/hci_sync.c:331
3 locks held by kworker/1:2/3075:
 #0: ffff88801ac80948 ((wq_completion)events){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3204 [inline]
 #0: ffff88801ac80948 ((wq_completion)events){+.+.}-{0:0}, at: process_scheduled_works+0x93b/0x1840 kernel/workqueue.c:3310
 #1: ffffc9000c6e7d00 ((work_completion)(&data->fib_event_work)){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3205 [inline]
 #1: ffffc9000c6e7d00 ((work_completion)(&data->fib_event_work)){+.+.}-{0:0}, at: process_scheduled_works+0x976/0x1840 kernel/workqueue.c:3310
 #2: ffff88803452e240 (&data->fib_lock){+.+.}-{4:4}, at: nsim_fib_event_work+0x2d1/0x4130 drivers/net/netdevsim/fib.c:1490
4 locks held by kworker/u9:1/5141:
 #0: ffff8880295ea148 ((wq_completion)hci1){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3204 [inline]
 #0: ffff8880295ea148 ((wq_completion)hci1){+.+.}-{0:0}, at: process_scheduled_works+0x93b/0x1840 kernel/workqueue.c:3310
 #1: ffffc900106b7d00 ((work_completion)(&hdev->cmd_sync_work)){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3205 [inline]
 #1: ffffc900106b7d00 ((work_completion)(&hdev->cmd_sync_work)){+.+.}-{0:0}, at: process_scheduled_works+0x976/0x1840 kernel/workqueue.c:3310
 #2: ffff888028ed8d80 (&hdev->req_lock){+.+.}-{4:4}, at: hci_cmd_sync_work+0x1ec/0x400 net/bluetooth/hci_sync.c:331
 #3: ffff888028ed8078 (&hdev->lock){+.+.}-{4:4}, at: hci_abort_conn_sync+0x1e4/0x11f0 net/bluetooth/hci_sync.c:5584
2 locks held by getty/5581:
 #0: ffff888034f1a0a0 (&tty->ldisc_sem){++++}-{0:0}, at: tty_ldisc_ref_wait+0x25/0x70 drivers/tty/tty_ldisc.c:243
 #1: ffffc90002fde2f0 (&ldata->atomic_read_lock){+.+.}-{4:4}, at: n_tty_read+0x6a6/0x1e00 drivers/tty/n_tty.c:2211
3 locks held by kworker/u9:2/5860:
 #0: ffff8880227a1948 ((wq_completion)hci4){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3204 [inline]
 #0: ffff8880227a1948 ((wq_completion)hci4){+.+.}-{0:0}, at: process_scheduled_works+0x93b/0x1840 kernel/workqueue.c:3310
 #1: ffffc900042afd00 ((work_completion)(&hdev->cmd_sync_work)){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3205 [inline]
 #1: ffffc900042afd00 ((work_completion)(&hdev->cmd_sync_work)){+.+.}-{0:0}, at: process_scheduled_works+0x976/0x1840 kernel/workqueue.c:3310
 #2: ffff8880284d4d80 (&hdev->req_lock){+.+.}-{4:4}, at: hci_cmd_sync_work+0x1ec/0x400 net/bluetooth/hci_sync.c:331
3 locks held by kworker/u9:3/5938:
 #0: ffff88805f9b6948 ((wq_completion)hci0){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3204 [inline]
 #0: ffff88805f9b6948 ((wq_completion)hci0){+.+.}-{0:0}, at: process_scheduled_works+0x93b/0x1840 kernel/workqueue.c:3310
 #1: ffffc90003b67d00 ((work_completion)(&hdev->cmd_sync_work)){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3205 [inline]
 #1: ffffc90003b67d00 ((work_completion)(&hdev->cmd_sync_work)){+.+.}-{0:0}, at: process_scheduled_works+0x976/0x1840 kernel/workqueue.c:3310
 #2: ffff888028edcd80 (&hdev->req_lock){+.+.}-{4:4}, at: hci_cmd_sync_work+0x1ec/0x400 net/bluetooth/hci_sync.c:331
3 locks held by kworker/u9:4/5939:
 #0: ffff8880295eb948 ((wq_completion)hci2){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3204 [inline]
 #0: ffff8880295eb948 ((wq_completion)hci2){+.+.}-{0:0}, at: process_scheduled_works+0x93b/0x1840 kernel/workqueue.c:3310
 #1: ffffc90003b57d00 ((work_completion)(&hdev->cmd_sync_work)){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3205 [inline]
 #1: ffffc90003b57d00 ((work_completion)(&hdev->cmd_sync_work)){+.+.}-{0:0}, at: process_scheduled_works+0x976/0x1840 kernel/workqueue.c:3310
 #2: ffff888027c4cd80 (&hdev->req_lock){+.+.}-{4:4}, at: hci_cmd_sync_work+0x1ec/0x400 net/bluetooth/hci_sync.c:331
1 lock held by syz-executor/5945:
 #0: ffffffff8fcb13c8 (rtnl_mutex){+.+.}-{4:4}, at: rtnl_net_lock include/linux/rtnetlink.h:128 [inline]
 #0: ffffffff8fcb13c8 (rtnl_mutex){+.+.}-{4:4}, at: inet_rtm_newaddr+0x47e/0x1bd0 net/ipv4/devinet.c:987
2 locks held by syz-executor/5946:
 #0: ffffffff8fd13d10 (cb_lock){++++}-{4:4}, at: genl_rcv+0x19/0x40 net/netlink/genetlink.c:1218
 #1: ffffffff8fcb13c8 (rtnl_mutex){+.+.}-{4:4}, at: nl80211_pre_doit+0x5f/0x8b0 net/wireless/nl80211.c:16587
2 locks held by syz-executor/5950:
 #0: ffffffff8fcb13c8 (rtnl_mutex){+.+.}-{4:4}, at: rtnl_lock net/core/rtnetlink.c:79 [inline]
 #0: ffffffff8fcb13c8 (rtnl_mutex){+.+.}-{4:4}, at: rtnl_nets_lock net/core/rtnetlink.c:326 [inline]
 #0: ffffffff8fcb13c8 (rtnl_mutex){+.+.}-{4:4}, at: rtnl_newlink+0xbcb/0x2150 net/core/rtnetlink.c:4010
 #1: ffff8880533214e8 (&wg->device_update_lock){+.+.}-{4:4}, at: wg_open+0x22d/0x420 drivers/net/wireguard/device.c:50
3 locks held by kworker/1:3/5980:
 #0: ffff88801ac80948 ((wq_completion)events){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3204 [inline]
 #0: ffff88801ac80948 ((wq_completion)events){+.+.}-{0:0}, at: process_scheduled_works+0x93b/0x1840 kernel/workqueue.c:3310
 #1: ffffc90003637d00 ((work_completion)(&data->fib_event_work)){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3205 [inline]
 #1: ffffc90003637d00 ((work_completion)(&data->fib_event_work)){+.+.}-{0:0}, at: process_scheduled_works+0x976/0x1840 kernel/workqueue.c:3310
 #2: ffff88807c492240 (&data->fib_lock){+.+.}-{4:4}, at: nsim_fib_event_work+0x2d1/0x4130 drivers/net/netdevsim/fib.c:1490
2 locks held by kworker/u8:7/5996:
3 locks held by kworker/u8:8/5997:
 #0: ffff888030cd7948 ((wq_completion)ipv6_addrconf){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3204 [inline]
 #0: ffff888030cd7948 ((wq_completion)ipv6_addrconf){+.+.}-{0:0}, at: process_scheduled_works+0x93b/0x1840 kernel/workqueue.c:3310
 #1: ffffc900035d7d00 ((work_completion)(&(&net->ipv6.addr_chk_work)->work)){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3205 [inline]
 #1: ffffc900035d7d00 ((work_completion)(&(&net->ipv6.addr_chk_work)->work)){+.+.}-{0:0}, at: process_scheduled_works+0x976/0x1840 kernel/workqueue.c:3310
 #2: ffffffff8fcb13c8 (rtnl_mutex){+.+.}-{4:4}, at: addrconf_verify_work+0x19/0x30 net/ipv6/addrconf.c:4755
2 locks held by syz-executor/6035:
 #0: ffffffff8fca4f10 (pernet_ops_rwsem){++++}-{4:4}, at: copy_net_ns+0x328/0x570 net/core/net_namespace.c:512
 #1: ffffffff8fcb13c8 (rtnl_mutex){+.+.}-{4:4}, at: register_nexthop_notifier+0x84/0x290 net/ipv4/nexthop.c:3878
2 locks held by dhcpcd/6036:
 #0: ffff888063090258 (sk_lock-AF_PACKET){+.+.}-{0:0}, at: lock_sock include/net/sock.h:1617 [inline]
 #0: ffff888063090258 (sk_lock-AF_PACKET){+.+.}-{0:0}, at: packet_do_bind+0x32/0xcb0 net/packet/af_packet.c:3267
 #1: ffffffff8e93cff8 (rcu_state.exp_mutex){+.+.}-{4:4}, at: exp_funnel_lock kernel/rcu/tree_exp.h:329 [inline]
 #1: ffffffff8e93cff8 (rcu_state.exp_mutex){+.+.}-{4:4}, at: synchronize_rcu_expedited+0x451/0x830 kernel/rcu/tree_exp.h:976
1 lock held by dhcpcd/6038:
 #0: ffff888011dc0258 (sk_lock-AF_PACKET){+.+.}-{0:0}, at: lock_sock include/net/sock.h:1617 [inline]
 #0: ffff888011dc0258 (sk_lock-AF_PACKET){+.+.}-{0:0}, at: packet_do_bind+0x32/0xcb0 net/packet/af_packet.c:3267
2 locks held by dhcpcd/6039:
 #0: ffff888078670258 (sk_lock-AF_PACKET){+.+.}-{0:0}, at: lock_sock include/net/sock.h:1617 [inline]
 #0: ffff888078670258 (sk_lock-AF_PACKET){+.+.}-{0:0}, at: packet_do_bind+0x32/0xcb0 net/packet/af_packet.c:3267
 #1: ffffffff8e93cff8 (rcu_state.exp_mutex){+.+.}-{4:4}, at: exp_funnel_lock kernel/rcu/tree_exp.h:329 [inline]
 #1: ffffffff8e93cff8 (rcu_state.exp_mutex){+.+.}-{4:4}, at: synchronize_rcu_expedited+0x451/0x830 kernel/rcu/tree_exp.h:976
1 lock held by dhcpcd/6040:
 #0: ffff88807fafe258 (sk_lock-AF_PACKET){+.+.}-{0:0}, at: lock_sock include/net/sock.h:1617 [inline]
 #0: ffff88807fafe258 (sk_lock-AF_PACKET){+.+.}-{0:0}, at: packet_do_bind+0x32/0xcb0 net/packet/af_packet.c:3267
1 lock held by dhcpcd/6041:
 #0: ffff88802abf8258 (sk_lock-AF_PACKET){+.+.}-{0:0}, at: lock_sock include/net/sock.h:1617 [inline]
 #0: ffff88802abf8258 (sk_lock-AF_PACKET){+.+.}-{0:0}, at: packet_do_bind+0x32/0xcb0 net/packet/af_packet.c:3267
1 lock held by dhcpcd/6042:
 #0: ffff88802abfe258 (sk_lock-AF_PACKET){+.+.}-{0:0}, at: lock_sock include/net/sock.h:1617 [inline]
 #0: ffff88802abfe258 (sk_lock-AF_PACKET){+.+.}-{0:0}, at: packet_do_bind+0x32/0xcb0 net/packet/af_packet.c:3267
2 locks held by syz-executor/6056:
 #0: ffffffff8fca4f10 (pernet_ops_rwsem){++++}-{4:4}, at: copy_net_ns+0x328/0x570 net/core/net_namespace.c:512
 #1: ffffffff8fcb13c8 (rtnl_mutex){+.+.}-{4:4}, at: register_nexthop_notifier+0x84/0x290 net/ipv4/nexthop.c:3878
2 locks held by syz-executor/6057:
 #0: ffffffff8fca4f10 (pernet_ops_rwsem){++++}-{4:4}, at: copy_net_ns+0x328/0x570 net/core/net_namespace.c:512
 #1: ffffffff8fcb13c8 (rtnl_mutex){+.+.}-{4:4}, at: register_nexthop_notifier+0x84/0x290 net/ipv4/nexthop.c:3878
2 locks held by syz-executor/6058:
 #0: ffffffff8fca4f10 (pernet_ops_rwsem){++++}-{4:4}, at: copy_net_ns+0x328/0x570 net/core/net_namespace.c:512
 #1: ffffffff8fcb13c8 (rtnl_mutex){+.+.}-{4:4}, at: register_nexthop_notifier+0x84/0x290 net/ipv4/nexthop.c:3878
2 locks held by syz-executor/6060:
 #0: ffffffff8fca4f10 (pernet_ops_rwsem){++++}-{4:4}, at: copy_net_ns+0x328/0x570 net/core/net_namespace.c:512
 #1: ffffffff8fcb13c8 (rtnl_mutex){+.+.}-{4:4}, at: register_nexthop_notifier+0x84/0x290 net/ipv4/nexthop.c:3878
3 locks held by syz-executor/6062:
 #0: ffff88814e9e4420 (sb_writers#4){.+.+}-{0:0}, at: mnt_want_write+0x3f/0x90 fs/namespace.c:515
 #1: ffff88807b46bf68 (&type->i_mutex_dir_key#3/1){+.+.}-{4:4}, at: inode_lock_nested include/linux/fs.h:853 [inline]
 #1: ffff88807b46bf68 (&type->i_mutex_dir_key#3/1){+.+.}-{4:4}, at: filename_create+0x260/0x540 fs/namei.c:4080
 #2: ffff8880320e0958 (jbd2_handle){++++}-{0:0}, at: start_this_handle+0x1e94/0x2110 fs/jbd2/transaction.c:448

=============================================

NMI backtrace for cpu 0
CPU: 0 UID: 0 PID: 30 Comm: khungtaskd Not tainted 6.13.0-rc2-syzkaller-00159-gf932fb9b4074 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 11/25/2024
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x241/0x360 lib/dump_stack.c:120
 nmi_cpu_backtrace+0x49c/0x4d0 lib/nmi_backtrace.c:113
 nmi_trigger_cpumask_backtrace+0x198/0x320 lib/nmi_backtrace.c:62
 trigger_all_cpu_backtrace include/linux/nmi.h:162 [inline]
 check_hung_uninterruptible_tasks kernel/hung_task.c:234 [inline]
 watchdog+0xff6/0x1040 kernel/hung_task.c:397
 kthread+0x2f0/0x390 kernel/kthread.c:389
 ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
 </TASK>
Sending NMI from CPU 0 to CPUs 1:
NMI backtrace for cpu 1
CPU: 1 UID: 0 PID: 5996 Comm: kworker/u8:7 Not tainted 6.13.0-rc2-syzkaller-00159-gf932fb9b4074 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 11/25/2024
Workqueue: events_unbound kfree_rcu_monitor
RIP: 0010:cpu_max_bits_warn include/linux/cpumask.h:135 [inline]
RIP: 0010:cpumask_check include/linux/cpumask.h:142 [inline]
RIP: 0010:cpumask_test_cpu include/linux/cpumask.h:570 [inline]
RIP: 0010:cpu_online include/linux/cpumask.h:1117 [inline]
RIP: 0010:trace_lock_release include/trace/events/lock.h:69 [inline]
RIP: 0010:lock_release+0x8c/0xa30 kernel/locking/lockdep.c:5860
Code: 03 48 b8 f1 f1 f1 f1 04 f2 00 f2 4b 89 04 3c 48 b8 f2 f2 00 f3 f3 f3 f3 f3 4b 89 44 3c 08 0f 1f 44 00 00 65 8b 05 10 15 89 7e <83> f8 08 0f 83 fe 05 00 00 89 c3 48 89 d8 48 c1 e8 06 48 8d 3c c5
RSP: 0018:ffffc90000a18b20 EFLAGS: 00000802
RAX: 0000000000000001 RBX: ffff888062af92e8 RCX: ffff88807d1c0000
RDX: 0000000000010000 RSI: ffffffff89cd5594 RDI: ffff888062af9300
RBP: ffffc90000a18c50 R08: ffff888029134087 R09: 1ffff11005226810
R10: dffffc0000000000 R11: ffffed1005226811 R12: 1ffff92000143170
R13: ffffffff89cd5594 R14: ffff888029134000 R15: dffffc0000000000
FS:  0000000000000000(0000) GS:ffff8880b8700000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fb14bd77bac CR3: 000000000e736000 CR4: 00000000003526f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <NMI>
 </NMI>
 <IRQ>
 __raw_spin_unlock include/linux/spinlock_api_smp.h:141 [inline]
 _raw_spin_unlock+0x16/0x50 kernel/locking/spinlock.c:186
 spin_unlock include/linux/spinlock.h:391 [inline]
 advance_sched+0x9b4/0xca0 net/sched/sch_taprio.c:981
 __run_hrtimer kernel/time/hrtimer.c:1739 [inline]
 __hrtimer_run_queues+0x59b/0xd30 kernel/time/hrtimer.c:1803
 hrtimer_interrupt+0x403/0xa40 kernel/time/hrtimer.c:1865
 local_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1038 [inline]
 __sysvec_apic_timer_interrupt+0x110/0x420 arch/x86/kernel/apic/apic.c:1055
 instr_sysvec_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1049 [inline]
 sysvec_apic_timer_interrupt+0xa1/0xc0 arch/x86/kernel/apic/apic.c:1049
 </IRQ>
 <TASK>
 asm_sysvec_apic_timer_interrupt+0x1a/0x20 arch/x86/include/asm/idtentry.h:702
RIP: 0010:__raw_spin_unlock_irqrestore include/linux/spinlock_api_smp.h:152 [inline]
RIP: 0010:_raw_spin_unlock_irqrestore+0xd8/0x140 kernel/locking/spinlock.c:194
Code: 9c 8f 44 24 20 42 80 3c 23 00 74 08 4c 89 f7 e8 3e c4 3a f6 f6 44 24 21 02 75 52 41 f7 c7 00 02 00 00 74 01 fb bf 01 00 00 00 <e8> 53 77 a2 f5 65 8b 05 f4 da 38 74 85 c0 74 43 48 c7 04 24 0e 36
RSP: 0018:ffffc9000433f8c0 EFLAGS: 00000206
RAX: 89bbc7aebfaa6600 RBX: 1ffff92000867f1c RCX: ffffffff817b11ca
RDX: dffffc0000000000 RSI: ffffffff8c0a9760 RDI: 0000000000000001
RBP: ffffc9000433f950 R08: ffffffff9429f8cf R09: 1ffffffff2853f19
R10: dffffc0000000000 R11: fffffbfff2853f1a R12: dffffc0000000000
R13: 1ffff92000867f18 R14: ffffc9000433f8e0 R15: 0000000000000246
 debug_object_active_state+0x239/0x360 lib/debugobjects.c:1055
 debug_rcu_head_unqueue kernel/rcu/rcu.h:233 [inline]
 kvfree_rcu_list+0xad/0x280 kernel/rcu/tree.c:3418
 kvfree_rcu_drain_ready kernel/rcu/tree.c:3573 [inline]
 kfree_rcu_monitor+0x817/0x990 kernel/rcu/tree.c:3642
 process_one_work kernel/workqueue.c:3229 [inline]
 process_scheduled_works+0xa66/0x1840 kernel/workqueue.c:3310
 worker_thread+0x870/0xd30 kernel/workqueue.c:3391
 kthread+0x2f0/0x390 kernel/kthread.c:389
 ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection

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
