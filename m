Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B6641531E8
	for <netfilter-devel@vger.kernel.org>; Sun, 24 Nov 2024 05:34:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732426464; cv=none; b=CoRG0Agv6l6u8deDbHPDteqeg7MgP4S1suyH+K7pE+Ax8Rw/f4NyUoezpRe7A1xvDWqXBssuSEAZjU/q0T4Jnu6Ye/+U8RlUqW+0o4+SxQSnHMsAOcjpWjU5v9OeGGErf0DSFdxwu86cMgNEOCDSx19xGPILMtp9IF4og0PqLW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732426464; c=relaxed/simple;
	bh=mXh7kAqdmuCvYP6oafLjX5fe/yQ1e2QvANH1qF81Ek8=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=ul7hkh4LEv7+lK3pJldA0BolN3yd1RAsdo9U3WJg8ShADvLqkiacIMxFU0TejjqhR0uOzbGhZxIQy4fBwnFHZQ53Vhrzsn84UFCTTy/Rm0Is2MeOLgqTIvw/GrgY4eUG3rz7DgnEPmRrgwMy0AQ11kBEjlxxJp16efHo3i5bnXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-3a77a2d9601so40068145ab.3
        for <netfilter-devel@vger.kernel.org>; Sat, 23 Nov 2024 21:34:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732426461; x=1733031261;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xuQiBCpsKoL+MejE3uyezV1hXADQ2FKc/9M0c14aSVo=;
        b=AGNEG/9rHpbYw9ywrTkNI+BgWPm4N8EFh++EA0vwx5Rhdj1aVIwdNUWH10CvcMqQb+
         5+2Y1pJmTHwyd5cTTWq33THXVSwUpsHQuOrLJxOrt13AY0p4ftbyU+usf7BsBp2iSZyV
         ubSUUX4iSbVspJDlBMjRoa4KlDS1BQt/o0FhFIOo2RlfguMciWSYlKwiEdJ50IEiGlDd
         dBpI6vZvMj7v3MeNnhxXzPsAmbVDZ3rP33xBz2/O4YpJLzsO911umIoYAXunyl2Z5PSf
         X0Qek+5IXp75X43Fz1PsKcWQKsSlYW/tvlOIDg8p1aimOsXCoZo6+JcN4oNamdt0Cnnt
         oG7g==
X-Forwarded-Encrypted: i=1; AJvYcCW7eXc5mGnuW2geNF3Q+tmfP4YqkRfRlFQbVdAKsx3I1wTCN86rMKtjyYyuJisw46V/Z5HH23FpUr3hRDK4h+Y=@vger.kernel.org
X-Gm-Message-State: AOJu0YyXTKPPhERCcanI3f2jK7YXrgGJTPkj3dG1YRPuvmHuiPfr7JTF
	+b2+YDCfXKDg9gh3LJGwHs/CYjPui+5c1omq4Zd1qDr/Y2FV2W2+TFiKAE7/IgA9P2bj04+yvUB
	OHsQv1Syb8RoDgemICqFxVBD9BYuHOP+y5pA4ovq+uzc5S5PTCFKpsIk=
X-Google-Smtp-Source: AGHT+IE9IKWzkzxT0uC1bKBtFxdblhGrd/Q57xk578ufi8VW31t7PLHSyWrnLjn+B8KJLwe10gXX+X1QghSwewvPO7ZSwTf9h+RI
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:18ce:b0:3a7:86ab:be6c with SMTP id
 e9e14a558f8ab-3a79af54861mr95373415ab.15.1732426461207; Sat, 23 Nov 2024
 21:34:21 -0800 (PST)
Date: Sat, 23 Nov 2024 21:34:21 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6742badd.050a0220.1cc393.0034.GAE@google.com>
Subject: [syzbot] [netfilter?] INFO: task hung in htable_put (2)
From: syzbot <syzbot+013daa7966d4340a8b8f@syzkaller.appspotmail.com>
To: coreteam@netfilter.org, davem@davemloft.net, edumazet@google.com, 
	horms@kernel.org, kadlec@netfilter.org, kuba@kernel.org, 
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org, 
	netfilter-devel@vger.kernel.org, pabeni@redhat.com, pablo@netfilter.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    cfaaa7d010d1 Merge tag 'net-6.12-rc8' of git://git.kernel...
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=13fd6b5f980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d2aeec8c0b2e420c
dashboard link: https://syzkaller.appspot.com/bug?extid=013daa7966d4340a8b8f
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/5ab991f9cba7/disk-cfaaa7d0.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/b840e35f87ab/vmlinux-cfaaa7d0.xz
kernel image: https://storage.googleapis.com/syzbot-assets/0b16dd5db314/bzImage-cfaaa7d0.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+013daa7966d4340a8b8f@syzkaller.appspotmail.com

INFO: task syz.2.6523:19093 blocked for more than 143 seconds.
      Not tainted 6.12.0-rc7-syzkaller-00125-gcfaaa7d010d1 #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz.2.6523      state:D stack:25776 pid:19093 tgid:19091 ppid:18127  flags:0x00004004
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5328 [inline]
 __schedule+0x184f/0x4c30 kernel/sched/core.c:6693
 __schedule_loop kernel/sched/core.c:6770 [inline]
 schedule+0x14b/0x320 kernel/sched/core.c:6785
 schedule_timeout+0xb0/0x310 kernel/time/timer.c:2591
 do_wait_for_common kernel/sched/completion.c:95 [inline]
 __wait_for_common kernel/sched/completion.c:116 [inline]
 wait_for_common kernel/sched/completion.c:127 [inline]
 wait_for_completion+0x355/0x620 kernel/sched/completion.c:148
 __flush_work+0xa37/0xc50 kernel/workqueue.c:4217
 __cancel_work_sync+0xbc/0x110 kernel/workqueue.c:4337
 htable_put+0x1e4/0x250 net/netfilter/xt_hashlimit.c:429
 cleanup_match net/ipv6/netfilter/ip6_tables.c:477 [inline]
 cleanup_entry+0x20f/0x4c0 net/ipv6/netfilter/ip6_tables.c:661
 translate_table+0x213c/0x2330 net/ipv6/netfilter/ip6_tables.c:744
 do_replace net/ipv6/netfilter/ip6_tables.c:1154 [inline]
 do_ip6t_set_ctl+0xe4c/0x1270 net/ipv6/netfilter/ip6_tables.c:1644
 nf_setsockopt+0x295/0x2c0 net/netfilter/nf_sockopt.c:101
 rawv6_setsockopt+0x327/0x740 net/ipv6/raw.c:1054
 do_sock_setsockopt+0x3af/0x720 net/socket.c:2334
 __sys_setsockopt+0x1a2/0x250 net/socket.c:2357
 __do_sys_setsockopt net/socket.c:2366 [inline]
 __se_sys_setsockopt net/socket.c:2363 [inline]
 __x64_sys_setsockopt+0xb5/0xd0 net/socket.c:2363
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f090e97e719
RSP: 002b:00007f090f6ed038 EFLAGS: 00000246 ORIG_RAX: 0000000000000036
RAX: ffffffffffffffda RBX: 00007f090eb35f80 RCX: 00007f090e97e719
RDX: 0000000000000040 RSI: 0000000000000029 RDI: 0000000000000004
RBP: 00007f090e9f175e R08: 0000000000000488 R09: 0000000000000000
R10: 0000000020000b00 R11: 0000000000000246 R12: 0000000000000000
R13: 0000000000000000 R14: 00007f090eb35f80 R15: 00007f090ec5fa28
 </TASK>

Showing all locks held in the system:
4 locks held by kworker/u8:1/12:
 #0: ffff88801baed948 ((wq_completion)netns){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3204 [inline]
 #0: ffff88801baed948 ((wq_completion)netns){+.+.}-{0:0}, at: process_scheduled_works+0x93b/0x1850 kernel/workqueue.c:3310
 #1: ffffc90000117d00 (net_cleanup_work){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3205 [inline]
 #1: ffffc90000117d00 (net_cleanup_work){+.+.}-{0:0}, at: process_scheduled_works+0x976/0x1850 kernel/workqueue.c:3310
 #2: ffffffff8fcc70d0 (pernet_ops_rwsem){++++}-{3:3}, at: cleanup_net+0x16a/0xcc0 net/core/net_namespace.c:580
 #3: ffffffff8fcd3c08 (rtnl_mutex){+.+.}-{3:3}, at: wg_destruct+0x25/0x2e0 drivers/net/wireguard/device.c:246
1 lock held by khungtaskd/30:
 #0: ffffffff8e937da0 (rcu_read_lock){....}-{1:2}, at: rcu_lock_acquire include/linux/rcupdate.h:337 [inline]
 #0: ffffffff8e937da0 (rcu_read_lock){....}-{1:2}, at: rcu_read_lock include/linux/rcupdate.h:849 [inline]
 #0: ffffffff8e937da0 (rcu_read_lock){....}-{1:2}, at: debug_show_all_locks+0x55/0x2a0 kernel/locking/lockdep.c:6720
2 locks held by kworker/1:2/2146:
2 locks held by dhcpcd/5507:
 #0: ffffffff8fcb86c8 (vlan_ioctl_mutex){+.+.}-{3:3}, at: sock_ioctl+0x661/0x8e0 net/socket.c:1308
 #1: ffffffff8fcd3c08 (rtnl_mutex){+.+.}-{3:3}, at: vlan_ioctl_handler+0x112/0x9d0 net/8021q/vlan.c:553
2 locks held by getty/5592:
 #0: ffff8880306270a0 (&tty->ldisc_sem){++++}-{0:0}, at: tty_ldisc_ref_wait+0x25/0x70 drivers/tty/tty_ldisc.c:243
 #1: ffffc90002f062f0 (&ldata->atomic_read_lock){+.+.}-{3:3}, at: n_tty_read+0x6a6/0x1e00 drivers/tty/n_tty.c:2211
2 locks held by kworker/1:3/5890:
3 locks held by kworker/0:8/5947:
 #0: ffff88801ac80948 ((wq_completion)events){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3204 [inline]
 #0: ffff88801ac80948 ((wq_completion)events){+.+.}-{0:0}, at: process_scheduled_works+0x93b/0x1850 kernel/workqueue.c:3310
 #1: ffffc90004367d00 (deferred_process_work){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3205 [inline]
 #1: ffffc90004367d00 (deferred_process_work){+.+.}-{0:0}, at: process_scheduled_works+0x976/0x1850 kernel/workqueue.c:3310
 #2: ffffffff8fcd3c08 (rtnl_mutex){+.+.}-{3:3}, at: switchdev_deferred_process_work+0xe/0x20 net/switchdev/switchdev.c:104
3 locks held by kworker/u8:13/7287:
 #0: ffff88801ac89148 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3204 [inline]
 #0: ffff88801ac89148 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_scheduled_works+0x93b/0x1850 kernel/workqueue.c:3310
 #1: ffffc9000319fd00 ((linkwatch_work).work){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3205 [inline]
 #1: ffffc9000319fd00 ((linkwatch_work).work){+.+.}-{0:0}, at: process_scheduled_works+0x976/0x1850 kernel/workqueue.c:3310
 #2: ffffffff8fcd3c08 (rtnl_mutex){+.+.}-{3:3}, at: linkwatch_event+0xe/0x60 net/core/link_watch.c:276
5 locks held by kworker/1:8/9368:
6 locks held by kworker/1:10/29362:
2 locks held by kworker/1:4/8744:
6 locks held by kworker/1:6/12106:
3 locks held by kworker/u8:23/14349:
 #0: ffff88802feef948 ((wq_completion)ipv6_addrconf){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3204 [inline]
 #0: ffff88802feef948 ((wq_completion)ipv6_addrconf){+.+.}-{0:0}, at: process_scheduled_works+0x93b/0x1850 kernel/workqueue.c:3310
 #1: ffffc900015f7d00 ((work_completion)(&(&ifa->dad_work)->work)){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3205 [inline]
 #1: ffffc900015f7d00 ((work_completion)(&(&ifa->dad_work)->work)){+.+.}-{0:0}, at: process_scheduled_works+0x976/0x1850 kernel/workqueue.c:3310
 #2: ffffffff8fcd3c08 (rtnl_mutex){+.+.}-{3:3}, at: addrconf_dad_work+0xd0/0x16f0 net/ipv6/addrconf.c:4196
2 locks held by syz-executor/15375:
 #0: ffffffff8fcd3c08 (rtnl_mutex){+.+.}-{3:3}, at: tun_detach drivers/net/tun.c:698 [inline]
 #0: ffffffff8fcd3c08 (rtnl_mutex){+.+.}-{3:3}, at: tun_chr_close+0x3b/0x1b0 drivers/net/tun.c:3517
 #1: ffffffff8e7d1d90 (cpu_hotplug_lock){++++}-{0:0}, at: flush_all_backlogs net/core/dev.c:6029 [inline]
 #1: ffffffff8e7d1d90 (cpu_hotplug_lock){++++}-{0:0}, at: unregister_netdevice_many_notify+0x5ea/0x1da0 net/core/dev.c:11388
1 lock held by syz-executor/18786:
 #0: ffffffff8fcd3c08 (rtnl_mutex){+.+.}-{3:3}, at: tun_detach drivers/net/tun.c:698 [inline]
 #0: ffffffff8fcd3c08 (rtnl_mutex){+.+.}-{3:3}, at: tun_chr_close+0x3b/0x1b0 drivers/net/tun.c:3517
1 lock held by syz-executor/19172:
 #0: ffffffff8fcd3c08 (rtnl_mutex){+.+.}-{3:3}, at: tun_detach drivers/net/tun.c:698 [inline]
 #0: ffffffff8fcd3c08 (rtnl_mutex){+.+.}-{3:3}, at: tun_chr_close+0x3b/0x1b0 drivers/net/tun.c:3517
7 locks held by syz-executor/19380:
 #0: ffff8880353fe420 (sb_writers#8){.+.+}-{0:0}, at: file_start_write include/linux/fs.h:2931 [inline]
 #0: ffff8880353fe420 (sb_writers#8){.+.+}-{0:0}, at: vfs_write+0x225/0xd30 fs/read_write.c:679
 #1: ffff88806b265c88 (&of->mutex){+.+.}-{3:3}, at: kernfs_fop_write_iter+0x1ea/0x500 fs/kernfs/file.c:325
 #2: ffff88802720b968 (kn->active#49){.+.+}-{0:0}, at: kernfs_fop_write_iter+0x20e/0x500 fs/kernfs/file.c:326
 #3: ffffffff8f571a48 (nsim_bus_dev_list_lock){+.+.}-{3:3}, at: del_device_store+0xfc/0x480 drivers/net/netdevsim/bus.c:216
 #4: ffff8880436fe0e8 (&dev->mutex){....}-{3:3}, at: device_lock include/linux/device.h:1014 [inline]
 #4: ffff8880436fe0e8 (&dev->mutex){....}-{3:3}, at: __device_driver_lock drivers/base/dd.c:1095 [inline]
 #4: ffff8880436fe0e8 (&dev->mutex){....}-{3:3}, at: device_release_driver_internal+0xce/0x7c0 drivers/base/dd.c:1293
 #5: ffff8880436fa250 (&devlink->lock_key#86){+.+.}-{3:3}, at: nsim_drv_remove+0x50/0x160 drivers/net/netdevsim/dev.c:1675
 #6: ffffffff8fcd3c08 (rtnl_mutex){+.+.}-{3:3}, at: nsim_destroy+0x71/0x5c0 drivers/net/netdevsim/netdev.c:773
3 locks held by syz.0.6579/19489:
 #0: ffff8880467d8d80 (&hdev->req_lock){+.+.}-{3:3}, at: hci_dev_do_close net/bluetooth/hci_core.c:481 [inline]
 #0: ffff8880467d8d80 (&hdev->req_lock){+.+.}-{3:3}, at: hci_unregister_dev+0x203/0x510 net/bluetooth/hci_core.c:2698
 #1: ffff8880467d8078 (&hdev->lock){+.+.}-{3:3}, at: hci_dev_close_sync+0x5c8/0x11c0 net/bluetooth/hci_sync.c:5193
 #2: ffffffff90039128 (uevent_sock_mutex){+.+.}-{3:3}, at: uevent_net_broadcast_untagged lib/kobject_uevent.c:317 [inline]
 #2: ffffffff90039128 (uevent_sock_mutex){+.+.}-{3:3}, at: kobject_uevent_net_broadcast+0x280/0x580 lib/kobject_uevent.c:410
2 locks held by syz-executor/19502:
 #0: ffffffff8fcc70d0 (pernet_ops_rwsem){++++}-{3:3}, at: copy_net_ns+0x328/0x570 net/core/net_namespace.c:490
 #1: ffffffff8fcd3c08 (rtnl_mutex){+.+.}-{3:3}, at: register_nexthop_notifier+0x84/0x290 net/ipv4/nexthop.c:3885
2 locks held by syz-executor/19504:
 #0: ffffffff8fcc70d0 (pernet_ops_rwsem){++++}-{3:3}, at: copy_net_ns+0x328/0x570 net/core/net_namespace.c:490
 #1: ffffffff8fcd3c08 (rtnl_mutex){+.+.}-{3:3}, at: register_nexthop_notifier+0x84/0x290 net/ipv4/nexthop.c:3885
2 locks held by syz-executor/19505:
 #0: ffffffff8fcc70d0 (pernet_ops_rwsem){++++}-{3:3}, at: copy_net_ns+0x328/0x570 net/core/net_namespace.c:490
 #1: ffffffff8fcd3c08 (rtnl_mutex){+.+.}-{3:3}, at: register_nexthop_notifier+0x84/0x290 net/ipv4/nexthop.c:3885
2 locks held by syz-executor/19507:
 #0: ffffffff8fcc70d0 (pernet_ops_rwsem){++++}-{3:3}, at: copy_net_ns+0x328/0x570 net/core/net_namespace.c:490
 #1: ffffffff8fcd3c08 (rtnl_mutex){+.+.}-{3:3}, at: register_nexthop_notifier+0x84/0x290 net/ipv4/nexthop.c:3885
2 locks held by syz-executor/19512:
 #0: ffffffff8fcc70d0 (pernet_ops_rwsem){++++}-{3:3}, at: copy_net_ns+0x328/0x570 net/core/net_namespace.c:490
 #1: ffffffff8fcd3c08 (rtnl_mutex){+.+.}-{3:3}, at: register_nexthop_notifier+0x84/0x290 net/ipv4/nexthop.c:3885
2 locks held by syz-executor/19517:
 #0: ffffffff8fcc70d0 (pernet_ops_rwsem){++++}-{3:3}, at: copy_net_ns+0x328/0x570 net/core/net_namespace.c:490
 #1: ffffffff8fcd3c08 (rtnl_mutex){+.+.}-{3:3}, at: register_nexthop_notifier+0x84/0x290 net/ipv4/nexthop.c:3885
2 locks held by syz-executor/19523:
 #0: ffffffff8fcc70d0 (pernet_ops_rwsem){++++}-{3:3}, at: copy_net_ns+0x328/0x570 net/core/net_namespace.c:490
 #1: ffffffff8fcd3c08 (rtnl_mutex){+.+.}-{3:3}, at: register_nexthop_notifier+0x84/0x290 net/ipv4/nexthop.c:3885
2 locks held by syz-executor/19526:
 #0: ffffffff8fcc70d0 (pernet_ops_rwsem){++++}-{3:3}, at: copy_net_ns+0x328/0x570 net/core/net_namespace.c:490
 #1: ffffffff8fcd3c08 (rtnl_mutex){+.+.}-{3:3}, at: register_nexthop_notifier+0x84/0x290 net/ipv4/nexthop.c:3885
2 locks held by syz-executor/19528:
 #0: ffffffff8fcc70d0 (pernet_ops_rwsem){++++}-{3:3}, at: copy_net_ns+0x328/0x570 net/core/net_namespace.c:490
 #1: ffffffff8fcd3c08 (rtnl_mutex){+.+.}-{3:3}, at: register_nexthop_notifier+0x84/0x290 net/ipv4/nexthop.c:3885
2 locks held by syz-executor/19532:
 #0: ffffffff8fcc70d0 (pernet_ops_rwsem){++++}-{3:3}, at: copy_net_ns+0x328/0x570 net/core/net_namespace.c:490
 #1: ffffffff8fcd3c08 (rtnl_mutex){+.+.}-{3:3}, at: register_nexthop_notifier+0x84/0x290 net/ipv4/nexthop.c:3885

=============================================

NMI backtrace for cpu 0
CPU: 0 UID: 0 PID: 30 Comm: khungtaskd Not tainted 6.12.0-rc7-syzkaller-00125-gcfaaa7d010d1 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/30/2024
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x241/0x360 lib/dump_stack.c:120
 nmi_cpu_backtrace+0x49c/0x4d0 lib/nmi_backtrace.c:113
 nmi_trigger_cpumask_backtrace+0x198/0x320 lib/nmi_backtrace.c:62
 trigger_all_cpu_backtrace include/linux/nmi.h:162 [inline]
 check_hung_uninterruptible_tasks kernel/hung_task.c:223 [inline]
 watchdog+0xff4/0x1040 kernel/hung_task.c:379
 kthread+0x2f0/0x390 kernel/kthread.c:389
 ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
 </TASK>
Sending NMI from CPU 0 to CPUs 1:
NMI backtrace for cpu 1
CPU: 1 UID: 0 PID: 9368 Comm: kworker/1:8 Not tainted 6.12.0-rc7-syzkaller-00125-gcfaaa7d010d1 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/30/2024
Workqueue: events_power_efficient htable_gc
RIP: 0010:get_reg arch/x86/kernel/unwind_orc.c:452 [inline]
RIP: 0010:unwind_next_frame+0x1634/0x22d0 arch/x86/kernel/unwind_orc.c:643
Code: 24 28 0f b7 30 c1 ee 04 83 e6 0f 83 fe 04 0f 84 d0 00 00 00 83 fe 01 0f 84 28 01 00 00 85 f6 0f 85 cb 02 00 00 48 8b 44 24 38 <80> 3c 28 00 74 08 4c 89 ff e8 fe 49 bd 00 49 8b 1f 48 85 db 0f 84
RSP: 0018:ffffc90000a18610 EFLAGS: 00000246
RAX: 1ffff920001430e6 RBX: 1ffffffff215f1b6 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffc90000a18740
RBP: dffffc0000000000 R08: ffffc90000a1873f R09: 0000000000000000
R10: ffffc90000a18730 R11: fffff520001430e8 R12: ffffc90000a19000
R13: ffffc90000a186e0 R14: ffffffff81fe9019 R15: ffffc90000a18730
FS:  0000000000000000(0000) GS:ffff8880b8700000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000002030c030 CR3: 000000000e734000 CR4: 00000000003526f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <NMI>
 </NMI>
 <IRQ>
 arch_stack_walk+0x11c/0x150 arch/x86/kernel/stacktrace.c:25
 stack_trace_save+0x118/0x1d0 kernel/stacktrace.c:122
 kasan_save_stack mm/kasan/common.c:47 [inline]
 kasan_save_track+0x3f/0x80 mm/kasan/common.c:68
 kasan_save_free_info+0x40/0x50 mm/kasan/generic.c:579
 poison_slab_object mm/kasan/common.c:247 [inline]
 __kasan_slab_free+0x59/0x70 mm/kasan/common.c:264
 kasan_slab_free include/linux/kasan.h:230 [inline]
 slab_free_hook mm/slub.c:2342 [inline]
 slab_free mm/slub.c:4579 [inline]
 kfree+0x1a0/0x440 mm/slub.c:4727
 ref_tracker_free+0x4ef/0x7e0 lib/ref_tracker.c:272
 netdev_tracker_free include/linux/netdevice.h:4082 [inline]
 netdev_put include/linux/netdevice.h:4099 [inline]
 dst_destroy+0x105/0x360 net/core/dst.c:114
 rcu_do_batch kernel/rcu/tree.c:2567 [inline]
 rcu_core+0xaaa/0x17a0 kernel/rcu/tree.c:2823
 handle_softirqs+0x2c5/0x980 kernel/softirq.c:554
 do_softirq+0x11b/0x1e0 kernel/softirq.c:455
 </IRQ>
 <TASK>
 __local_bh_enable_ip+0x1bb/0x200 kernel/softirq.c:382
 spin_unlock_bh include/linux/spinlock.h:396 [inline]
 htable_selective_cleanup+0x25f/0x310 net/netfilter/xt_hashlimit.c:374
 htable_gc+0x1f/0xa0 net/netfilter/xt_hashlimit.c:385
 process_one_work kernel/workqueue.c:3229 [inline]
 process_scheduled_works+0xa63/0x1850 kernel/workqueue.c:3310
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

If the report is already addressed, let syzbot know by replying with:
#syz fix: exact-commit-title

If you want to overwrite report's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the report is a duplicate of another one, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup
