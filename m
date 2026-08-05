Received: from mail-oo1-f72.google.com (mail-oo1-f72.google.com [209.85.161.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2E1538DC44
	for <netfilter-devel@vger.kernel.org>; Wed,  5 Aug 2026 14:42:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785940962; cv=none; b=Nn/4rCuxzphW9IGJ41H5s+qdNqkDoBtDINjsXjScnDhPM3MGY3sujMpt/2IMAb9Q9qi/SDbHTfdPtITBW67GS/ocEq6z8yIaTy/+Dmi7u3x5Jv8F9sNoRlZArKv+XWzKp+MPqFMRnvGvPiPngHAYowbA3e6LmfzFPam3JcvjMY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785940962; c=relaxed/simple;
	bh=NUxmVYrEfPKo+i8Q+bqh/D8r8C7Tr65MGzn7Zu0UeGQ=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=UiVVW0OtCayxASSJUY+IG5n37c6TSybB7uya6o2IF/sNrz/zi9RgbLrS8E8k26PmVBzvMMIWyjquUJr+6fs/3311q1TogvsPHOWt8VdwsljV8YBfiZCWi97g4rslwezhp8W8nfB3wK1YnE5w8jZq4uq+eMSB5RN6aUmuyZDhyMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f72.google.com with SMTP id 006d021491bc7-6ae46631c42so886117eaf.2
        for <netfilter-devel@vger.kernel.org>; Wed, 05 Aug 2026 07:42:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785940953; x=1786545753;
        h=content-type:to:from:subject:message-id:in-reply-to:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=DKMAEk7ixO/3UhOr8REpRipHtC42IVpmhe/7vaT9QaE=;
        b=sjNA/8pVpcQWBR/rHM/22DZQP+LjWvVVz5wSbKHD9cXO/y7aCRWNYVW3O7y80lZkDk
         aMFdpGiGOdMtsZpIjwOJv6V+lWzSZ2xXuwIKpmxvrF6pQcX60/M6ml/Uzv7CWF7NdlLQ
         SMfTu5tX2Vi273UYr7X2tilqg9+Xq+uOzYzir9nEXgmWDhrnQ9dIXGtLkwlRvnvIDlci
         Xi63OQIMv8Xjcy9wd5o0GfZoQ0lnRNqBzikz0hd4hVMXRDfXZ8x8DUB4ISfmf/RlSEQe
         glCxPxU4cMKsvneNHhicDTZUDvRGXythdEIGmpi1GMiGj2rhbADPuUCRQ1Fxa6OTKIwU
         mNag==
X-Forwarded-Encrypted: i=1; AHgh+Rowgp9X/59UlNpC/CCUs9HQqPdbusswr4cPC92+E7XJSBMOyekWsM/OhZj4kYWE2eIS/iAX6KAM5PY0a1m1Zig=@vger.kernel.org
X-Gm-Message-State: AOJu0YwhNDsd/se0l0ZDc321Kzje/OC37ZqvnJd1dg9eDZilxsfoIX+8
	VjjlajrMhkzzt5i18wY30qLpRu1WqL9Rp/3Kb4NoZYkxy+SfeNYNIgcOV7tb1Bu0GNKAnksExPH
	zDWyeXqoQjICj31dzP5xDdKYo12Uhlro0CcxhMV54QxZ/Qs5jGL2W+fQmC6A=
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:1a0f:b0:6ac:9729:6710 with SMTP id
 006d021491bc7-6ae96ecc61fmr4258233eaf.18.1785940952706; Wed, 05 Aug 2026
 07:42:32 -0700 (PDT)
Date: Wed, 05 Aug 2026 07:42:32 -0700
In-Reply-To: <69572c91.050a0220.a1b6.034b.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a734bd8.d1b4d54b.5552d.001d.GAE@google.com>
Subject: Re: [syzbot] [netfilter?] INFO: task hung in nfnetlink_rcv_msg (5)
From: syzbot <syzbot+c4b20b80ee6a7a2f5012@syzkaller.appspotmail.com>
To: coreteam@netfilter.org, davem@davemloft.net, edumazet@google.com, 
	fw@strlen.de, horms@kernel.org, kadlec@netfilter.org, kuba@kernel.org, 
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org, 
	netfilter-devel@vger.kernel.org, pabeni@redhat.com, pablo@netfilter.org, 
	phil@nwl.cc, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has found a reproducer for the following issue on:

HEAD commit:    c21bb4193868 Merge tag 'for_linus' of git://git.kernel.org..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=14723bb9580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=db2a459b73b0bd7c
dashboard link: https://syzkaller.appspot.com/bug?extid=c4b20b80ee6a7a2f5012
compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13c353b9580000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+c4b20b80ee6a7a2f5012@syzkaller.appspotmail.com

INFO: task syz-executor189:6036 blocked for more than 5 seconds.
      Not tainted syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor189 state:D stack:24232 pid:6036  tgid:6036  ppid:154    task_flags:0x400100 flags:0x00080000
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5510 [inline]
 __schedule+0x17e7/0x5630 kernel/sched/core.c:7234
 __schedule_loop kernel/sched/core.c:7311 [inline]
 schedule+0x164/0x2b0 kernel/sched/core.c:7326
 schedule_preempt_disabled+0x13/0x30 kernel/sched/core.c:7383
 __mutex_lock_common kernel/locking/mutex.c:726 [inline]
 __mutex_lock+0x7bf/0x1550 kernel/locking/mutex.c:821
 nfnl_lock net/netfilter/nfnetlink.c:96 [inline]
 nfnetlink_rcv_msg+0xa69/0x12b0 net/netfilter/nfnetlink.c:293
 netlink_rcv_skb+0x226/0x4a0 net/netlink/af_netlink.c:2556
 nfnetlink_rcv+0x2b9/0x28c0 net/netfilter/nfnetlink.c:667
 netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
 netlink_unicast+0x7bb/0x940 net/netlink/af_netlink.c:1345
 netlink_sendmsg+0x813/0xb40 net/netlink/af_netlink.c:1900
 sock_sendmsg_nosec+0x13a/0x180 net/socket.c:775
 __sock_sendmsg net/socket.c:790 [inline]
 __sys_sendto+0x408/0x5a0 net/socket.c:2252
 __do_sys_sendto net/socket.c:2259 [inline]
 __se_sys_sendto net/socket.c:2255 [inline]
 __x64_sys_sendto+0xde/0x100 net/socket.c:2255
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f581fdbc037
RSP: 002b:00007fff5c0188a0 EFLAGS: 00000202 ORIG_RAX: 000000000000002c
RAX: ffffffffffffffda RBX: 000055556b6f4400 RCX: 00007f581fdbc037
RDX: 0000000000000014 RSI: 00007fff5c018900 RDI: 0000000000000000
RBP: 0000000000000004 R08: 00007fff5c0188f4 R09: 000000000000000c
R10: 0000000000000000 R11: 0000000000000202 R12: 00007fff5c019f68
R13: 0000000000000002 R14: 00007f581fe22c80 R15: 0000000000000002
 </TASK>

Showing all locks held in the system:
1 lock held by khungtaskd/31:
 #0: ffffffff8e759c20 (rcu_read_lock){....}-{1:3}, at: rcu_lock_acquire include/linux/rcupdate.h:300 [inline]
 #0: ffffffff8e759c20 (rcu_read_lock){....}-{1:3}, at: rcu_read_lock include/linux/rcupdate.h:840 [inline]
 #0: ffffffff8e759c20 (rcu_read_lock){....}-{1:3}, at: debug_show_all_locks+0x2e/0x180 kernel/locking/lockdep.c:6775
2 locks held by kworker/u8:5/154:
 #0: ffff88813fe4c140 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3297 [inline]
 #0: ffff88813fe4c140 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_scheduled_works+0xa20/0x14e0 kernel/workqueue.c:3405
 #1: ffffc90002f5fc40 ((work_completion)(&sub_info->work)){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3297 [inline]
 #1: ffffc90002f5fc40 ((work_completion)(&sub_info->work)){+.+.}-{0:0}, at: process_scheduled_works+0xa20/0x14e0 kernel/workqueue.c:3405
2 locks held by getty/5372:
 #0: ffff888035e180a0 (&tty->ldisc_sem){++++}-{0:0}, at: tty_ldisc_ref_wait+0x25/0x70 drivers/tty/tty_ldisc.c:243
 #1: ffffc900032332e8 (&ldata->atomic_read_lock){+.+.}-{4:4}, at: n_tty_read+0x45a/0x1360 drivers/tty/n_tty.c:2211
1 lock held by syz-executor189/6035:
 #0: ffffffff9a7a3cb0 (nfnl_subsys_ctnetlink){+.+.}-{4:4}, at: nfnl_lock net/netfilter/nfnetlink.c:96 [inline]
 #0: ffffffff9a7a3cb0 (nfnl_subsys_ctnetlink){+.+.}-{4:4}, at: nfnetlink_rcv_msg+0xa69/0x12b0 net/netfilter/nfnetlink.c:293
1 lock held by syz-executor189/6036:
 #0: ffffffff9a7a3cb0 (nfnl_subsys_ctnetlink){+.+.}-{4:4}, at: nfnl_lock net/netfilter/nfnetlink.c:96 [inline]
 #0: ffffffff9a7a3cb0 (nfnl_subsys_ctnetlink){+.+.}-{4:4}, at: nfnetlink_rcv_msg+0xa69/0x12b0 net/netfilter/nfnetlink.c:293

=============================================

NMI backtrace for cpu 0
CPU: 0 UID: 0 PID: 31 Comm: khungtaskd Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/24/2026
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 nmi_cpu_backtrace+0x274/0x2d0 lib/nmi_backtrace.c:122
 nmi_trigger_cpumask_backtrace+0x17a/0x380 lib/nmi_backtrace.c:65
 trigger_all_cpu_backtrace include/linux/nmi.h:162 [inline]
 __sys_info lib/sys_info.c:157 [inline]
 sys_info+0x135/0x170 lib/sys_info.c:165
 check_hung_uninterruptible_tasks kernel/hung_task.c:353 [inline]
 watchdog+0xfd7/0x1030 kernel/hung_task.c:561
 kthread+0x388/0x470 kernel/kthread.c:436
 ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>
Sending NMI from CPU 0 to CPUs 1:
NMI backtrace for cpu 1
CPU: 1 UID: 0 PID: 0 Comm: swapper/1 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/24/2026
RIP: 0010:pv_native_safe_halt+0xf/0x20 arch/x86/kernel/paravirt.c:64
Code: ec 71 02 e9 d3 02 03 00 cc cc cc 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 f3 0f 1e fa 66 90 0f 00 2d d3 ca 0f 00 fb f4 <c3> cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc 90 90 90 90 90
RSP: 0018:ffffc90000197e40 EFLAGS: 00000242
RAX: 0000000000052637 RBX: ffffffff8199752c RCX: 0000000080000001
RDX: 0000000000000001 RSI: ffffffff8ddfd062 RDI: ffffffff8c0b0280
RBP: ffffc90000197f10 R08: ffff8880b87338db R09: 1ffff110170e671b
R10: dffffc0000000000 R11: ffffed10170e671c R12: 0000000000000000
R13: 1ffff11003ada000 R14: 1ffff92000032fd0 R15: dffffc0000000000
FS:  0000000000000000(0000) GS:ffff888125546000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055c1e9808200 CR3: 000000007a26e000 CR4: 00000000003526f0
Call Trace:
 <TASK>
 arch_safe_halt arch/x86/kernel/process.c:767 [inline]
 default_idle+0x9/0x20 arch/x86/kernel/process.c:768
 default_idle_call+0x72/0xb0 kernel/sched/idle.c:122
 cpuidle_idle_call kernel/sched/idle.c:199 [inline]
 do_idle+0x1cc/0x540 kernel/sched/idle.c:355
 cpu_startup_entry+0x43/0x60 kernel/sched/idle.c:454
 start_secondary+0x101/0x110 arch/x86/kernel/smpboot.c:312
 common_startup_64+0x13e/0x157
 </TASK>


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.
