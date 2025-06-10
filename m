Received: from mail-io1-f77.google.com (mail-io1-f77.google.com [209.85.166.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84273EC4
	for <netfilter-devel@vger.kernel.org>; Tue, 10 Jun 2025 08:02:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.77
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749542558; cv=none; b=K/EKaty9g/Kbljczpzl+IajHEYKoxtUMOHwn6Hyw74zS7T9JIEZlCpgP/Ldaq/wakpWbEZdo4vKMpHTvIfapT0WFEjZyASLsbgHGwF8mzI146AZJKkzieEP5J1YSw7PRsiSbqn6kWtZ78x/kp61LY+5D5T6gp8C34p+zWHPZaKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749542558; c=relaxed/simple;
	bh=LVepFmuGXDN992D6LP/vclUeGcHQTg9ntUJwv/nErzY=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=Vd7WpOefJxMyR0jix9CnR/K+PtXcqYsJ+0bnK29cw0vE/mQnZcfKo4OUrKZyLS7QuKTGHsZ1vPR8Ow7JOschEjqAsO764mCgwL7ydttJrOjQYsXxQMcH89hLCytK8WW0FQFduw0zgp8T/Ju7Y0lGsp/oTJj4IRMdkYHgIDkWCYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f77.google.com with SMTP id ca18e2360f4ac-873fd6e896bso63770639f.3
        for <netfilter-devel@vger.kernel.org>; Tue, 10 Jun 2025 01:02:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749542556; x=1750147356;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Xj4vPv26zWkt7bkqTDYqd3v62tzLpe/KtfS3M8qESeI=;
        b=TOY3KePt1hkYphHPS4PDYp7A3vHVTf5++MJjoeJjbAB186sBIGmvA32oEx9FzCl5rF
         1AUrLYX4CaT6OFEDBmWcMvNb/7ZpEd8EW3o2xMAwntlHAuwT67wVPkmPLp+xK9sT0K4J
         4JunM7g6OsDcUkXJACkC9tcc3LTRQcPHuBwflMY2i+XmJXgQzJkMg/EcvPEcJr3wK837
         pNkYhfSSc64v6Mip5NzhfH8WIGoWIGtqML4qbyc36ZBACDW5WvpqluTecWHY/8S1LhOV
         OIVP1OTHpNhesXiYwOyqCMQ8tlEG4MH0c+juvkbMrSH+Qiq/m6zs0Vt3/E0XX3zHBGPD
         KWNw==
X-Forwarded-Encrypted: i=1; AJvYcCUx5GGJ1PA9Zdq/e5eNwl9cD7BjHQZxcKAbn/+fYgDDzCtGztQhfQ0BVJISUJXsvwJBZ/Y/tjo/jRq4Yx3vYLY=@vger.kernel.org
X-Gm-Message-State: AOJu0YziSiXsDVMUd5OKdTEH/pxszKKRZgMvnAKnHf3IGJzVl3D/jj6k
	SANrV3/tHPnSoftjkBzGjMJKMQsbuWDT2PlQ8yWsnxYbqpB3sa+rAb+/HFeWGDtjT4i3sR1SKID
	dxBKHApBJYs4fDjbYTZhAmOyRLiRLndS3aUjbtxvkWn7Q47Ph+VXtqw1B+4s=
X-Google-Smtp-Source: AGHT+IFPMDQqinEcAbhz/4hz3Vv8ZYqqoKZwFKb0qmCPXZC4SCu39RyWQe81dTOL8FjFx7GvtHfHoeVqDsmS84zYwXC8uFk9RGkd
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1fc4:b0:3dd:b556:18c5 with SMTP id
 e9e14a558f8ab-3ddede0282dmr16105525ab.21.1749542555716; Tue, 10 Jun 2025
 01:02:35 -0700 (PDT)
Date: Tue, 10 Jun 2025 01:02:35 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6847e69b.a70a0220.27c366.005e.GAE@google.com>
Subject: [syzbot] [netfilter?] WARNING: refcount bug in nf_nat_masq_schedule
From: syzbot <syzbot+e178f373ec62758ea18b@syzkaller.appspotmail.com>
To: coreteam@netfilter.org, davem@davemloft.net, edumazet@google.com, 
	horms@kernel.org, kadlec@netfilter.org, kuba@kernel.org, 
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org, 
	netfilter-devel@vger.kernel.org, pabeni@redhat.com, pablo@netfilter.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    c89756bcf406 Merge tag 'pm-6.16-rc1' of git://git.kernel.o..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=13abfdf4580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d2e9181801c1d2a6
dashboard link: https://syzkaller.appspot.com/bug?extid=e178f373ec62758ea18b
compiler:       gcc (Debian 12.2.0-14) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-c89756bc.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/e43d06e5b003/vmlinux-c89756bc.xz
kernel image: https://storage.googleapis.com/syzbot-assets/ae5bc446518d/bzImage-c89756bc.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+e178f373ec62758ea18b@syzkaller.appspotmail.com

------------[ cut here ]------------
refcount_t: saturated; leaking memory.
WARNING: CPU: 0 PID: 1150 at lib/refcount.c:19 refcount_warn_saturate+0x10d/0x210 lib/refcount.c:19
Modules linked in:
CPU: 0 UID: 0 PID: 1150 Comm: kworker/u32:8 Not tainted 6.15.0-syzkaller-03478-gc89756bcf406 #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
Workqueue: netns cleanup_net
RIP: 0010:refcount_warn_saturate+0x10d/0x210 lib/refcount.c:19
Code: cb 97 0b 31 ff 89 de e8 21 75 e4 fc 84 db 75 a3 e8 38 7a e4 fc c6 05 c5 cb 97 0b 01 90 48 c7 c7 e0 bc f4 8b e8 34 b3 a3 fc 90 <0f> 0b 90 90 eb 83 e8 18 7a e4 fc 0f b6 1d a2 cb 97 0b 31 ff 89 de
RSP: 0018:ffffc9000667f4f8 EFLAGS: 00010286
RAX: 0000000000000000 RBX: 0000000000000000 RCX: ffffffff817aa8e8
RDX: ffff888029688000 RSI: ffffffff817aa8f5 RDI: 0000000000000001
RBP: ffff888024f5016c R08: 0000000000000001 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000001 R12: ffff888024f5016c
R13: ffff888024f50000 R14: 1ffff92000ccfea6 R15: ffffc9000667f5f0
FS:  0000000000000000(0000) GS:ffff8880d69a1000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000110c2a109a CR3: 00000000481e5000 CR4: 0000000000352ef0
DR0: 000000000000006d DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 __refcount_add_not_zero include/linux/refcount.h:187 [inline]
 __refcount_inc_not_zero include/linux/refcount.h:317 [inline]
 refcount_inc_not_zero include/linux/refcount.h:335 [inline]
 maybe_get_net include/net/net_namespace.h:279 [inline]
 nf_nat_masq_schedule.part.0+0x4ef/0x5f0 net/netfilter/nf_nat_masquerade.c:111
 nf_nat_masq_schedule net/netfilter/nf_nat_masquerade.c:108 [inline]
 masq_inet6_event+0x205/0x250 net/netfilter/nf_nat_masquerade.c:295
 notifier_call_chain+0xbc/0x410 kernel/notifier.c:85
 atomic_notifier_call_chain+0x71/0x1c0 kernel/notifier.c:223
 addrconf_ifdown.isra.0+0xe98/0x1a90 net/ipv6/addrconf.c:3982
 addrconf_notify+0x220/0x19e0 net/ipv6/addrconf.c:3780
 notifier_call_chain+0xbc/0x410 kernel/notifier.c:85
 call_netdevice_notifiers_info+0xbe/0x140 net/core/dev.c:2176
 call_netdevice_notifiers_extack net/core/dev.c:2214 [inline]
 call_netdevice_notifiers net/core/dev.c:2228 [inline]
 dev_close_many+0x319/0x630 net/core/dev.c:1731
 unregister_netdevice_many_notify+0x578/0x26f0 net/core/dev.c:11942
 cleanup_net+0x596/0xb30 net/core/net_namespace.c:649
 process_one_work+0x9cf/0x1b70 kernel/workqueue.c:3238
 process_scheduled_works kernel/workqueue.c:3319 [inline]
 worker_thread+0x6c8/0xf10 kernel/workqueue.c:3400
 kthread+0x3c5/0x780 kernel/kthread.c:464
 ret_from_fork+0x5d4/0x6f0 arch/x86/kernel/process.c:148
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
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
