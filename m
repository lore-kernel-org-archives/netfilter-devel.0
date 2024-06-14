Received: from mail-io1-f77.google.com (mail-io1-f77.google.com [209.85.166.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BC9C18FC67
	for <netfilter-devel@vger.kernel.org>; Fri, 14 Jun 2024 08:20:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.77
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718353220; cv=none; b=M6bUHXciKDfSTSrUAEqDGosg9v29hFbqYpJuQUFnJm+xvnM7I9JhjLkYGkhGFa0XmRbRY4VMkQ20llkWWGqK2TAm2344TwMtCzNFoHq6hQnpCa+TBj7hwXTATtCarfcYANgbQsBsPx1GTwiFqRNuMN8N2c2WwaAd9bzu5pQcj1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718353220; c=relaxed/simple;
	bh=4IyZUPiN7XkzOKxC9ha9pjCQBoOIxTEwiHoGnTYoB4w=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=hq94JnTGBcMSDNuFwKbPwNonhSSEMZSZpG+M7zGD/YPnqh1vrM75roQ4hiJqVIq8os9xN9tUtDydfQM5kwid9ztJBXEn3yw6JjHiTDKZk42tz2rc8iXdcMsXzDahRfwtb89gw8c6Thwwgg7e4nW5Jm90b686gN6NYH4gLc6wbVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f77.google.com with SMTP id ca18e2360f4ac-7ebea0e968eso98178839f.3
        for <netfilter-devel@vger.kernel.org>; Fri, 14 Jun 2024 01:20:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718353218; x=1718958018;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xFXScuID2XY3qkGj3x/dO8+McuUiGZggiBg1rAExOaM=;
        b=owwhSJ73JpcvXyPsbChITsfFyAQ0TWmU2MpdK3yI22mBIXALiBeSsL4rdScqs4Q2AC
         g5KPy8VNj8EQWjuU6wpz2QD5LMBSxpHlpF/u+mDKb22R5ENzHXGKIlXDKTx7Tfaw2oA6
         waYRIxOCoK0DuRhlPq5XilOg8GwsYBYoFJTn80bptngv9Q03mjXzAgCyRudReDmqPmwp
         vL+mkVEIOFqN+HV6awzsbTOsF3Q4spJTSW/vd6O3WbpsLzTj5zG/rYLPCyX1QJrWFjUC
         4Iy0IV714ysXCu2sQTgnzYY8Z//zlSPlqcGiWGkFGpbc6L/HiM6XjRLbyXQCIS48z2Ds
         i5vQ==
X-Forwarded-Encrypted: i=1; AJvYcCVU6mcCCaiAY0vAfVPRjNmEFfxrK22j+Vnvn2zN18ktLFXAIT9fluCcxfQF/erQKiBMolD69WPM9uLypP1s0rCMR0oHMwhfiVKoXvdPlLZd
X-Gm-Message-State: AOJu0YxVn1j4DiLlbVGhyh++Mrx2cHiBehfXQsT6zPpyoStTqMRsKORP
	3KL1Es9Olgf3tga2x+R7tk/KIkz+RZYYSv9oo6Q7T9oGYtn7h470+8bj4XxwtbqT5scV9ZMRymU
	2HTC4SLYC58nsdoTB8OvKqsm+A+6W6J94L/LFbdHZGlKL3WMOl/FVrpE=
X-Google-Smtp-Source: AGHT+IHpJTJ2gAQazRe7iSSah696ZKLUaFKIlZT4SQeysZWw5IgR4M+G8gsYeVz0EUdKstB8FEO60uuCaZ0bmQDeTZjkOOJZgGb1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6638:1307:b0:4b9:43be:d3fd with SMTP id
 8926c6da1cb9f-4b9640e3aadmr106374173.4.1718353218321; Fri, 14 Jun 2024
 01:20:18 -0700 (PDT)
Date: Fri, 14 Jun 2024 01:20:18 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000002d4832061ad549c9@google.com>
Subject: [syzbot] [netfilter?] net-next test error: WARNING: suspicious RCU
 usage in _destroy_all_sets
From: syzbot <syzbot+cfbe1da5fdfc39efc293@syzkaller.appspotmail.com>
To: coreteam@netfilter.org, davem@davemloft.net, edumazet@google.com, 
	kadlec@netfilter.org, kuba@kernel.org, linux-kernel@vger.kernel.org, 
	netdev@vger.kernel.org, netfilter-devel@vger.kernel.org, pabeni@redhat.com, 
	pablo@netfilter.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    5f703ce5c981 net: hsr: Send supervisory frames to HSR netw..
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=1313bb36980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=7266aeba025a54a4
dashboard link: https://syzkaller.appspot.com/bug?extid=cfbe1da5fdfc39efc293
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/739147e76c4b/disk-5f703ce5.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/4a1004e7b8ba/vmlinux-5f703ce5.xz
kernel image: https://storage.googleapis.com/syzbot-assets/544a55547eb9/bzImage-5f703ce5.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+cfbe1da5fdfc39efc293@syzkaller.appspotmail.com

=============================
WARNING: suspicious RCU usage
6.10.0-rc3-syzkaller-00655-g5f703ce5c981 #0 Not tainted
-----------------------------
net/netfilter/ipset/ip_set_core.c:1200 suspicious rcu_dereference_protected() usage!

other info that might help us debug this:


rcu_scheduler_active = 2, debug_locks = 1
3 locks held by kworker/u8:8/3913:
 #0: ffff888015edd948 ((wq_completion)netns){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3206 [inline]
 #0: ffff888015edd948 ((wq_completion)netns){+.+.}-{0:0}, at: process_scheduled_works+0x90a/0x1830 kernel/workqueue.c:3312
 #1: ffffc9000c4bfd00 (net_cleanup_work){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3207 [inline]
 #1: ffffc9000c4bfd00 (net_cleanup_work){+.+.}-{0:0}, at: process_scheduled_works+0x945/0x1830 kernel/workqueue.c:3312
 #2: ffffffff8f5db390 (pernet_ops_rwsem){++++}-{3:3}, at: cleanup_net+0x16a/0xcc0 net/core/net_namespace.c:594

stack backtrace:
CPU: 0 PID: 3913 Comm: kworker/u8:8 Not tainted 6.10.0-rc3-syzkaller-00655-g5f703ce5c981 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 06/07/2024
Workqueue: netns cleanup_net
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0x241/0x360 lib/dump_stack.c:114
 lockdep_rcu_suspicious+0x221/0x340 kernel/locking/lockdep.c:6712
 _destroy_all_sets+0x232/0x5f0 net/netfilter/ipset/ip_set_core.c:1200
 ip_set_net_exit+0x20/0x50 net/netfilter/ipset/ip_set_core.c:2396
 ops_exit_list net/core/net_namespace.c:173 [inline]
 cleanup_net+0x802/0xcc0 net/core/net_namespace.c:640
 process_one_work kernel/workqueue.c:3231 [inline]
 process_scheduled_works+0xa2c/0x1830 kernel/workqueue.c:3312
 worker_thread+0x86d/0xd70 kernel/workqueue.c:3393
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
