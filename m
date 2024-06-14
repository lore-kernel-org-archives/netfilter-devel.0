Received: from mail-io1-f77.google.com (mail-io1-f77.google.com [209.85.166.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CA0D185086
	for <netfilter-devel@vger.kernel.org>; Fri, 14 Jun 2024 08:20:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.77
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718353221; cv=none; b=TpnaEKNDQjdMb/R8DBXSc3MrRpjkfysbWo+U/EMNbqgDueTvK7J8kdyYPDpyAML8i8K5hWz5IpaCnODI7WNdKyXPOWfJekTAYqx4x+yEyDL39GxZRpG/6oEZns/+5A0zx/V/ZoXGs6csjlGUNwNzKhPZXrDXLdio1h4l+/R5CBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718353221; c=relaxed/simple;
	bh=ISPOFElUhPfORR5OTgaw5Rb0UncyFlwjMM+BnZW/tY0=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=Herr5qbbpWSLjdkvSEJV04UGazu1M7Dei3eM/fh2cdqcfYq81QyYMKCUJrpR+YUs39GXe2hL8h4m/finpQhwhOkBCe11hba3jK65jGAEgfXX0k+RXZz6bKSO1/9I0vXtF2yDt4CgeTuQxInkr8K+iwdSO8ZlClK3FFiaEhSy35o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f77.google.com with SMTP id ca18e2360f4ac-7eb4c4378c0so196103739f.1
        for <netfilter-devel@vger.kernel.org>; Fri, 14 Jun 2024 01:20:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718353219; x=1718958019;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=uyixLgySkZFyTY3mdGYpcbq5ugcacH5aYgYfssaBYrk=;
        b=DiJZw5JgNIxTc5cRin918KDE1OAFyBTjNZc32cnn9QbNyxILjpKRs0jx+N4N96bR8P
         bcKMKTWQ6KyWLamYVBrkeOYBkVhFzPbOiTxPPW1MWc9THVrxwAB15FLsAHWjPdBkEuV+
         buGuh6BtVfqu+CqPUqHabBZH4bIgvDXPPZoMTTzLsw/0YaIA41VSSqr8tb//BdrYxozO
         lnwWqOQppoXqbN1rhH3BcC4KceTdys5IvNsPhGuQJvm5scHn88WwLYvvAjqpFI6qTgBc
         Fn363F/VVBUkjBIWUQEdkKIXFdpdIqOaAQMVymGLPI7SEoV9vbeCWS4n9pRX5DSwpyP/
         402Q==
X-Forwarded-Encrypted: i=1; AJvYcCWDSHfX9hmME1TopL0hZv+3SoXtIAiXnGxbxuQrpvdZ86JK2VdE0V1XVs2CsBuga0gzeWOhXKFtmEFoEwxfBbEIEzWRuCCCKY9duyXnHaAE
X-Gm-Message-State: AOJu0YwgrhsU2YbAwhqHavQOhCXoOXJIiJ4F5LFKqiQEczm6Fiunh4u8
	0RxWjhJzaovzWWZzt9TfpQwnAHAU1TPo31OvZiZ9H9venunPDmVLdlAj91B+ojycxSbcBOtZ667
	OfPDoZSIh+Z9nzd+qEVVk75pNWBMSWRqJbVucVWs2f71S6yNXYLSKNnI=
X-Google-Smtp-Source: AGHT+IHeQ4/CpDpeiPcPyxbqwa8q2xOsL6kEA4Mhc/1f2HelZdksUCn4qpOO7MZ52eZ3zLI2EVkJQJ19VPbxYScJ/QNdCjOee6Qc
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6602:3fd5:b0:7eb:99c1:373c with SMTP id
 ca18e2360f4ac-7ebeaeff0eemr3926039f.0.1718353217830; Fri, 14 Jun 2024
 01:20:17 -0700 (PDT)
Date: Fri, 14 Jun 2024 01:20:17 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000025d569061ad54981@google.com>
Subject: [syzbot] [netfilter?] upstream test error: WARNING: suspicious RCU
 usage in _destroy_all_sets
From: syzbot <syzbot+b62c37cdd58103293a5a@syzkaller.appspotmail.com>
To: coreteam@netfilter.org, davem@davemloft.net, edumazet@google.com, 
	kadlec@netfilter.org, kuba@kernel.org, linux-kernel@vger.kernel.org, 
	netdev@vger.kernel.org, netfilter-devel@vger.kernel.org, pabeni@redhat.com, 
	pablo@netfilter.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    d20f6b3d747c Merge tag 'net-6.10-rc4' of git://git.kernel...
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1720df36980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=fa0ce06dcc735711
dashboard link: https://syzkaller.appspot.com/bug?extid=b62c37cdd58103293a5a
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/682e40151249/disk-d20f6b3d.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/5b5e6dd23e74/vmlinux-d20f6b3d.xz
kernel image: https://storage.googleapis.com/syzbot-assets/08385974a61e/bzImage-d20f6b3d.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+b62c37cdd58103293a5a@syzkaller.appspotmail.com

=============================
WARNING: suspicious RCU usage
6.10.0-rc3-syzkaller-00099-gd20f6b3d747c #0 Not tainted
-----------------------------
net/netfilter/ipset/ip_set_core.c:1200 suspicious rcu_dereference_protected() usage!

other info that might help us debug this:


rcu_scheduler_active = 2, debug_locks = 1
3 locks held by kworker/u8:13/2892:
 #0: ffff888015ed5948 ((wq_completion)netns){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3206 [inline]
 #0: ffff888015ed5948 ((wq_completion)netns){+.+.}-{0:0}, at: process_scheduled_works+0x90a/0x1830 kernel/workqueue.c:3312
 #1: ffffc90009bcfd00 (net_cleanup_work){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3207 [inline]
 #1: ffffc90009bcfd00 (net_cleanup_work){+.+.}-{0:0}, at: process_scheduled_works+0x945/0x1830 kernel/workqueue.c:3312
 #2: ffffffff8f5db250 (pernet_ops_rwsem){++++}-{3:3}, at: cleanup_net+0x16a/0xcc0 net/core/net_namespace.c:594

stack backtrace:
CPU: 1 PID: 2892 Comm: kworker/u8:13 Not tainted 6.10.0-rc3-syzkaller-00099-gd20f6b3d747c #0
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
