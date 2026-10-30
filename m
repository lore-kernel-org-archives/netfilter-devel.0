Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.167.197
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793381630;
	b=qGeaXCd1FB2eytFbdjR9c+IP6IssabHrMpuNFmZBsyHoE9zJkAppNfnjnKjPS2lOYij0
	 UHU0Q7lqa+Sup8P+/doQulTM2N3Clbmt+OO7FqC3Lm1ZdJteoKeVMMq7SLkFKdLrdIjLg
	 /BNHg0uZpOVwSM4AhCsB0s+4k0Ols8Woi9QYQYIcNKqAlgKgTaz0aNqPqM3EkGFDvZa3I
	 bsUcnonn0vEzS0LNlBTWxA5rY93Q9/LsCOH5Vg7INaUi1use5AJ23HgVdvHJX/fl+9OLb
	 QOZpw5R1wXHJldrN1XM7fLH6oSIlxXFoOrBjVf2NgBbnhhF5wnOt0MTWBgi9rx7wUBg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793381630;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 MIME-Version:X-Received:Date:In-Reply-To:X-Google-Appengine-App-Id:
	 X-Google-Appengine-App-Id-Alias:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=9swxJ5zXJJBY0nNfgb0A9dSPa8XR0GO6rxRhKw0+TpM=;
	b=SR9BSOJsC+JQB56bC7WhfnF93TbgJWJMiPIgGLPL4eJjnXhFvvtzD6QEtSYZu3TiKY9H
	 sU9H/D+jOgXYgiGXfqGDnW7BlP22rrjEsPDbwAf3FQx5fhU0fOdObtOC3cHS7FCPRbcKh
	 J5AZ2wlliOQxR7aC3/fUADJmcIAYuVmtgUciuptX+XQmFy9EBUNs5FgRoPCa1bS+bbMjh
	 Dbs821leMsM6nzHBOtPXyi5NkTiJmXQtJN8CZHqVA+ADvBubh1T7Ur0ihEAcl0XxO2v0Y
	 bkEI623nqziGab/OG7iCYPBbaIiBF72jevYb7oEYb5uQVs67M+nNxonTDPfgLSPS9VA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=syzkaller.appspotmail.com;
	spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	arc=none smtp.remote-ip=209.85.167.197
Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com [209.85.167.197])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3068606A31C
	for <netfilter-devel@vger.kernel.org>; Fri, 30 Oct 2026 17:33:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E3068606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f197.google.com with SMTP id 5614622812f47-4f4612a1a5cso2524458b6e.0
        for <netfilter-devel@vger.kernel.org>; Fri, 30 Oct 2026 10:33:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793381629; x=1793986429;
        h=content-type:cc:to:from:subject:message-id:in-reply-to:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=9swxJ5zXJJBY0nNfgb0A9dSPa8XR0GO6rxRhKw0+TpM=;
        b=Odvz5Wb0pLzs+G4pKZmlQFLbmzGYme7uPtNf/erOOMQ5MXkLC4UzLwiVIaId0/nyE5
         wmJ4Fg+K98e0oraIiKDAajg+SpmdBwqxTVKpwEUdEDwRx/xJKECPCxjnPV4Z+2+RiLQv
         nr+6/X33r0kfxrSVltKvEKTYSSH20i/6hSdqvaA3N8jjKecXvDhkUrh57HS+wHfxGNaG
         HzaCxdH1Olk3sJUKxbj3gCTdkHptqt63bDyotXB+uroUsQ7OzXsLhxAUasUuBU7dmytO
         4eELfgWBiXmQeAQmW4nMEIqmPH7YQzaaOQnyN/2DIEt/5Z37ZqW0PYE45fPKj7Z3Msys
         P22A==
X-Gm-Message-State: AFq9FYLUi6gqwMe8nJAdD/9z0fog+z0bAxxqeUI/2NkaoLN/ehGRHFok
	F+clpwaJTKWcQJt/t2SIOqo1pQHjFkveo8QcgED43XrSbVIxverUywxtruJBQ7OA2haBQISFqSi
	rBkxQRCdqJ6uujwLhMLbvh/f0rZR+IcCkkQqD1IM9i202v11N3mUjU0Z1DoI=
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-Received: by 2002:a05:6808:1691:b0:55c:844:989f with SMTP id
 5614622812f47-563ef9c9687mr3468494b6e.23.1793381628994; Fri, 30 Oct 2026
 10:33:48 -0700 (PDT)
Date: Fri, 30 Oct 2026 10:33:48 -0700
In-Reply-To: <20261029171950.222776-1-pablo@netfilter.org>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6ae4d4fc.0c1d3ab6.e3d48.0074.GAE@google.com>
Subject: [syzbot ci] Re: netfilter: flowtable: purge entries immediately when
 destroying the flowtable
From: syzbot ci <syzbot+ciffc525b53c2bb5ba@syzkaller.appspotmail.com>
To: netfilter-devel@vger.kernel.org, pablo@netfilter.org
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v1] netfilter: flowtable: purge entries immediately when destroying the flowtable
https://lore.kernel.org/all/20261029171950.222776-1-pablo@netfilter.org
* [PATCH nf] netfilter: flowtable: purge entries immediately when destroying the flowtable

and found the following issues:
* BUG: sleeping function called from invalid context in flow_offload_work_del
* WARNING: locking bug in flow_offload_work_del

Full report is available here:
https://ci.syzbot.org/series/5482d6d8-0683-4f36-bb55-ffcf94a9edcc

***

BUG: sleeping function called from invalid context in flow_offload_work_del

tree:      nf
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netfilter/nf.git
base:      734bef548a96e8774d6eef5dfa2026c6edc4e80b
arch:      amd64
compiler:  Debian clang version 22.1.8 (1~deb13u4), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/94e4012e-ffd8-430a-9ba4-d5a167bf8988/config
syz repro: https://ci.syzbot.org/findings/6c0e698b-3bb6-4d1f-94cb-9ebf1c0a71db/syz_repro

BUG: sleeping function called from invalid context at kernel/locking/rwsem.c:1573
in_atomic(): 0, irqs_disabled(): 0, non_block: 0, pid: 5686, name: kworker/u8:3
preempt_count: 0, expected: 0
RCU nest depth: 1, expected: 0
locks held by kworker/u8:3/5686: 3, last CPU#0:
 #0: ffff8881108f3948 ((wq_completion)act_ct_workqueue){+.+.}-{0:0}, at: rcu_lock_acquire include/linux/rcupdate.h:309 [inline]
 #0: ffff8881108f3948 ((wq_completion)act_ct_workqueue){+.+.}-{0:0}, at: rcu_read_lock include/linux/rcupdate.h:849 [inline]
 #0: ffff8881108f3948 ((wq_completion)act_ct_workqueue){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3460 [inline]
 #0: ffff8881108f3948 ((wq_completion)act_ct_workqueue){+.+.}-{0:0}, at: process_scheduled_works+0x97a/0x1630 kernel/workqueue.c:3578
 #1: ffffc90004e67c40 ((work_completion)(&(&ct_ft->rwork)->work)){+.+.}-{0:0}, at: rcu_lock_acquire include/linux/rcupdate.h:309 [inline]
 #1: ffffc90004e67c40 ((work_completion)(&(&ct_ft->rwork)->work)){+.+.}-{0:0}, at: rcu_read_lock include/linux/rcupdate.h:849 [inline]
 #1: ffffc90004e67c40 ((work_completion)(&(&ct_ft->rwork)->work)){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3460 [inline]
 #1: ffffc90004e67c40 ((work_completion)(&(&ct_ft->rwork)->work)){+.+.}-{0:0}, at: process_scheduled_works+0x97a/0x1630 kernel/workqueue.c:3578
 #2: ffffffff8fd59ca0 (rcu_read_lock){....}-{1:3}, at: rcu_lock_acquire include/linux/rcupdate.h:309 [inline]
 #2: ffffffff8fd59ca0 (rcu_read_lock){....}-{1:3}, at: rcu_read_lock include/linux/rcupdate.h:849 [inline]
 #2: ffffffff8fd59ca0 (rcu_read_lock){....}-{1:3}, at: rhashtable_walk_start_check+0x64/0xcf0 lib/rhashtable.c:872
CPU: 0 UID: 0 PID: 5686 Comm: kworker/u8:3 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Workqueue: act_ct_workqueue tcf_ct_flow_table_cleanup_work
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 __might_resched+0x36a/0x4c0 kernel/sched/core.c:9195
 down_read+0x26/0x320 kernel/locking/rwsem.c:1573
 nf_flow_offload_tuple net/netfilter/nf_flow_table_offload.c:920 [inline]
 flow_offload_tuple_del net/netfilter/nf_flow_table_offload.c:951 [inline]
 flow_offload_work_del+0x240/0x5e0 net/netfilter/nf_flow_table_offload.c:995
 nf_flow_table_offload_purge+0x51/0x80 net/netfilter/nf_flow_table_offload.c:1184
 nf_flow_table_do_purge net/netfilter/nf_flow_table_core.c:776 [inline]
 nf_flow_table_iterate net/netfilter/nf_flow_table_core.c:459 [inline]
 nf_flow_table_free+0x29b/0x3b0 net/netfilter/nf_flow_table_core.c:789
 tcf_ct_flow_table_cleanup_work+0x1a/0x90 net/sched/act_ct.c:386
 process_one_work kernel/workqueue.c:3495 [inline]
 process_scheduled_works+0xc3d/0x1630 kernel/workqueue.c:3578
 worker_thread+0xa47/0xfb0 kernel/workqueue.c:3659
 kthread+0x38b/0x480 kernel/kthread.c:436
 ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>

=============================
[ BUG: Invalid wait context ]
syzkaller #0 Tainted: G        W           
-----------------------------
kworker/u8:3/5686 is trying to lock:
ffff88817589eb28 (&flowtable->flow_block_lock){.+.+}-{4:4}, at: nf_flow_offload_tuple net/netfilter/nf_flow_table_offload.c:920 [inline]
ffff88817589eb28 (&flowtable->flow_block_lock){.+.+}-{4:4}, at: flow_offload_tuple_del net/netfilter/nf_flow_table_offload.c:951 [inline]
ffff88817589eb28 (&flowtable->flow_block_lock){.+.+}-{4:4}, at: flow_offload_work_del+0x240/0x5e0 net/netfilter/nf_flow_table_offload.c:995
other info that might help us debug this:
context-{5:5}
locks held by kworker/u8:3/5686: 3, last CPU#0:
 #0: ffff8881108f3948 ((wq_completion)act_ct_workqueue){+.+.}-{0:0}, at: rcu_lock_acquire include/linux/rcupdate.h:309 [inline]
 #0: ffff8881108f3948 ((wq_completion)act_ct_workqueue){+.+.}-{0:0}, at: rcu_read_lock include/linux/rcupdate.h:849 [inline]
 #0: ffff8881108f3948 ((wq_completion)act_ct_workqueue){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3460 [inline]
 #0: ffff8881108f3948 ((wq_completion)act_ct_workqueue){+.+.}-{0:0}, at: process_scheduled_works+0x97a/0x1630 kernel/workqueue.c:3578
 #1: ffffc90004e67c40 ((work_completion)(&(&ct_ft->rwork)->work)){+.+.}-{0:0}, at: rcu_lock_acquire include/linux/rcupdate.h:309 [inline]
 #1: ffffc90004e67c40 ((work_completion)(&(&ct_ft->rwork)->work)){+.+.}-{0:0}, at: rcu_read_lock include/linux/rcupdate.h:849 [inline]
 #1: ffffc90004e67c40 ((work_completion)(&(&ct_ft->rwork)->work)){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3460 [inline]
 #1: ffffc90004e67c40 ((work_completion)(&(&ct_ft->rwork)->work)){+.+.}-{0:0}, at: process_scheduled_works+0x97a/0x1630 kernel/workqueue.c:3578
 #2: ffffffff8fd59ca0 (rcu_read_lock){....}-{1:3}, at: rcu_lock_acquire include/linux/rcupdate.h:309 [inline]
 #2: ffffffff8fd59ca0 (rcu_read_lock){....}-{1:3}, at: rcu_read_lock include/linux/rcupdate.h:849 [inline]
 #2: ffffffff8fd59ca0 (rcu_read_lock){....}-{1:3}, at: rhashtable_walk_start_check+0x64/0xcf0 lib/rhashtable.c:872
stack backtrace:
CPU: 0 UID: 0 PID: 5686 Comm: kworker/u8:3 Tainted: G        W            syzkaller #0 PREEMPT(full) 
Tainted: [W]=WARN
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Workqueue: act_ct_workqueue tcf_ct_flow_table_cleanup_work
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 print_lock_invalid_wait_context kernel/locking/lockdep.c:4874 [inline]
 check_wait_context kernel/locking/lockdep.c:4946 [inline]
 __lock_acquire+0xf5b/0x2de0 kernel/locking/lockdep.c:5238
 lock_acquire+0x115/0x350 kernel/locking/lockdep.c:5942
 down_read+0x45/0x320 kernel/locking/rwsem.c:1574
 nf_flow_offload_tuple net/netfilter/nf_flow_table_offload.c:920 [inline]
 flow_offload_tuple_del net/netfilter/nf_flow_table_offload.c:951 [inline]
 flow_offload_work_del+0x240/0x5e0 net/netfilter/nf_flow_table_offload.c:995
 nf_flow_table_offload_purge+0x51/0x80 net/netfilter/nf_flow_table_offload.c:1184
 nf_flow_table_do_purge net/netfilter/nf_flow_table_core.c:776 [inline]
 nf_flow_table_iterate net/netfilter/nf_flow_table_core.c:459 [inline]
 nf_flow_table_free+0x29b/0x3b0 net/netfilter/nf_flow_table_core.c:789
 tcf_ct_flow_table_cleanup_work+0x1a/0x90 net/sched/act_ct.c:386
 process_one_work kernel/workqueue.c:3495 [inline]
 process_scheduled_works+0xc3d/0x1630 kernel/workqueue.c:3578
 worker_thread+0xa47/0xfb0 kernel/workqueue.c:3659
 kthread+0x38b/0x480 kernel/kthread.c:436
 ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>


***

WARNING: locking bug in flow_offload_work_del

tree:      nf
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netfilter/nf.git
base:      734bef548a96e8774d6eef5dfa2026c6edc4e80b
arch:      amd64
compiler:  Debian clang version 22.1.8 (1~deb13u4), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/94e4012e-ffd8-430a-9ba4-d5a167bf8988/config

BUG: sleeping function called from invalid context at kernel/locking/rwsem.c:1573
in_atomic(): 0, irqs_disabled(): 0, non_block: 0, pid: 5634, name: kworker/u8:2
preempt_count: 0, expected: 0
RCU nest depth: 1, expected: 0
locks held by kworker/u8:2/5634: 3, last CPU#1:
 #0: ffff888115805948 ((wq_completion)act_ct_workqueue){+.+.}-{0:0}, at: process_scheduled_works+0x97a/0x1630
 #1: ffffc9000473fc40 ((work_completion)(&(&ct_ft->rwork)->work)){+.+.}-{0:0}, at: process_scheduled_works+0x97a/0x1630
 #2: ffffffff8fd59ca0 (rcu_read_lock){....}-{1:3}, at: rhashtable_walk_start_check+0x64/0xcf0
CPU: 1 UID: 0 PID: 5634 Comm: kworker/u8:2 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Workqueue: act_ct_workqueue tcf_ct_flow_table_cleanup_work
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150
 __might_resched+0x36a/0x4c0
 down_read+0x26/0x320
 flow_offload_work_del+0x240/0x5e0
 nf_flow_table_offload_purge+0x51/0x80
 nf_flow_table_free+0x29b/0x3b0
 tcf_ct_flow_table_cleanup_work+0x1a/0x90
 process_scheduled_works+0xc3d/0x1630
 worker_thread+0xa47/0xfb0
 kthread+0x38b/0x480
 ret_from_fork+0x514/0xb70
 ret_from_fork_asm+0x1a/0x30
 </TASK>
=============================
[ BUG: Invalid wait context ]
syzkaller #0 Tainted: G        W           
-----------------------------
kworker/u8:2/5634 is trying to lock:
ffff8881b9d94b28 (&flowtable->flow_block_lock){++++}-{4:4}, at: flow_offload_work_del+0x240/0x5e0
other info that might help us debug this:
context-{5:5}
locks held by kworker/u8:2/5634: 3, last CPU#0:
 #0: ffff888115805948 ((wq_completion)act_ct_workqueue){+.+.}-{0:0}, at: process_scheduled_works+0x97a/0x1630
 #1: ffffc9000473fc40 ((work_completion)(&(&ct_ft->rwork)->work)){+.+.}-{0:0}, at: process_scheduled_works+0x97a/0x1630
 #2: ffffffff8fd59ca0 (rcu_read_lock){....}-{1:3}, at: rhashtable_walk_start_check+0x64/0xcf0
stack backtrace:
CPU: 0 UID: 0 PID: 5634 Comm: kworker/u8:2 Tainted: G        W            syzkaller #0 PREEMPT(full) 
Tainted: [W]=WARN
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Workqueue: act_ct_workqueue tcf_ct_flow_table_cleanup_work
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150
 __lock_acquire+0xf5b/0x2de0
 lock_acquire+0x115/0x350
 down_read+0x45/0x320
 flow_offload_work_del+0x240/0x5e0
 nf_flow_table_offload_purge+0x51/0x80
 nf_flow_table_free+0x29b/0x3b0
 tcf_ct_flow_table_cleanup_work+0x1a/0x90
 process_scheduled_works+0xc3d/0x1630
 worker_thread+0xa47/0xfb0
 kthread+0x38b/0x480
 ret_from_fork+0x514/0xb70
 ret_from_fork_asm+0x1a/0x30
 </TASK>


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

To test a fix for this bug, please reply with `#syz test`
(on a separate line) and attach the patch to the email.

Notes:
- The patch will be applied on top of the tested series (as an
  incremental fix).
- To test a new version of the whole series, please send it directly
  to syzbot@lists.linux.dev.
- Arguments like custom git repos and branches are not supported.
