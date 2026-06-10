Received: from mail-qt1-f194.google.com (mail-qt1-f194.google.com [209.85.160.194])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ED05379C48
	for <netfilter-devel@vger.kernel.org>; Wed, 10 Jun 2026 07:14:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.194
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781075696; cv=pass; b=b1i14pzFwdQUJsVUyRU1rM7Q+4qkkrCT11+arf71SKJxDQJDp4jWKw18dQagtCmYLLCaBy0Er5e6gFqWDONDL8KIwLJukdRvl+pHJ3BLmW9CPM3gUpafK6poQKX1wvEJ239oD0QJppCduk8OHNr0PBRVHZhhsBkbQsLYX6JAiao=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781075696; c=relaxed/simple;
	bh=XvsQhRozAFSw+a00aQIVWV8/Oa8NR4ozD3ww2/GBFyA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NMZmlvHhBACBGWFt+0Y7wOJEu+K1kLquBUYE0cESXiFum3NYaksf6fOVPn2NwHNVtlBMYN5UocBa9JrJgrYJEZNuJK7AknTcTrHZVjk1ptK//u/nZV1MizdmmVTnHohMzIyFbv8ETAX0bKvbQSsR3mumAJwTXDSy2Lw88m2ifwI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bhWD+zBC; arc=pass smtp.client-ip=209.85.160.194
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bhWD+zBC"
Received: by mail-qt1-f194.google.com with SMTP id d75a77b69052e-5176d4c14f5so51947071cf.0
        for <netfilter-devel@vger.kernel.org>; Wed, 10 Jun 2026 00:14:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781075693; cv=none;
        d=google.com; s=arc-20240605;
        b=LtkdqY8iWeU6xvNFyFtD2imXjOx1MFuCEy5R7ufU5UNuude6gTBV7L3hHhKoIobRPF
         px4gNwJUuTr7XubObQVB41mwiidPt9Gsjvr4sAMvlmp476uVHYFq30LWTMk61cq2Bb8y
         NaFpg54QSFf6XiepTMKNjbS7FOfAVy1JCUTAPpvZmBT4jVhyBeqVt6pESDK/l+z2fgYK
         dNzDz1DC/zZ2YAUqf+H9R134zP9R7u+zFjxVt0DznCAjJpi4izQ5px/Qybhz3eb3N/RW
         FCycFmZoyB5dazBtrXdpbHmUTu6CJlMa+EZ0gSGhIjmdAx7lze3ejOYYnn3WZE/ExYPM
         J6ZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=bgr8QlOOF3go8d3EZ2R2QFVaOFeEbXmRiccxCZXmpCE=;
        fh=gPsoQwzldog9TxuAywqgqgd5r2PkL9JpgCQHEgWtE0w=;
        b=jPsAZP2/LdcOMwPDNWK7qwD+JfrClTq8e/AR4G/Y8Vw6XUCI1oFjnsVGeHHObfrFUN
         4O6kGxH2ULeyKQ93s++16YA2XTc4mpMfW2uMMzFQFIT2ENp1rNwe54Cis6X1vB9UXQ38
         Hz98QRz+iqO9nJ1EInbSfnewKQHCuhoplyeJwskqfMMjs1ZckYb05liMLI4QQ0P4nnnP
         dycCNEqq6ddQaXRmAOOt6cRGySR7stniUUskzSiuuAyPIjSLadp1yFVYyPLccbG+M2aI
         M7Wlo3B9U1cFB0QK7HtkvFatBuF2lbuhaLsQIG0sEx6lL77Lq+XxY86Gb/FhQZFIav7d
         Ojxw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781075693; x=1781680493; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bgr8QlOOF3go8d3EZ2R2QFVaOFeEbXmRiccxCZXmpCE=;
        b=bhWD+zBCqjLlX+rVtQjSfpbGk8WNIg0AwlB2SSgwvFC2Tk1zww88/iq5bId17qxKJM
         Qc4S3/AwuOm0LlHitnJllQSekdhENc+47Lnk4si1SYIXBW/b2BXekTK85Tk4PDLfAcBZ
         vk1DLEdPSWJRcn+7mizELyOcPfC1OrxV0cn86zNl0CZxeQ0T3xIUhufqsF9PyHANI1HD
         lxxBYuyS9lpcxQ0oHCKJagkEb84FAdfMjoU3D3Cod3sf9o/3dBV/AcNvxqowHNHQ2HXp
         ZVSMLDY03lbobGSg4hY9M33lrzA5C9X7g8rwTC9KtcmiQpIEcepOwB+DIu5EEbXmv+V5
         RhUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781075693; x=1781680493;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=bgr8QlOOF3go8d3EZ2R2QFVaOFeEbXmRiccxCZXmpCE=;
        b=OrzEJl2t4yMO6Nd47kBitsPQyfLq/w372uEb5FJ7mEPnh4vP+ZDcg8QEgtevElWqU1
         ZwWvriBRwF15NAYv+b2QDGpyx0NFvMXDD4He19nn149r9fbEh4hQa6i+4+kdOnqAfOrX
         d0eWC3m3eKnEQAcIF6rnVQc5DOr+u7gXypuJgLLv0Qx3ofrYo1Ce1RrFiN2FjF0tv1WF
         gYDxN71edTR05aY5OeuZ9KrZbHfQ3Y4lsNEriQuzl2gceCinmYKXi08BZZy3ELxmqMco
         VAJ8ZgILrmLBCAOrivdTrQEIgxlzc8a+rnZGsJKqRp7sjPyK/jWfP+5N/6OrP2iBohDW
         6M8g==
X-Forwarded-Encrypted: i=1; AFNElJ9rSLI0wBCYINghj6Txofz2U0eoP2SaXz6S0nEzrSLLfk7lsW/VfjIzSag/8xwxo3Vt+xvmO1dsLPFNLaoVdwU=@vger.kernel.org
X-Gm-Message-State: AOJu0YzVlD6DcwOVegc6NhwQNfBnoKJq5DZuqYHh2VS22iyDa5ViRiP/
	kdIgak+NLrc7DJCW+XIv4Efr5WR273YYvL4/sb1YQ8NNuF/F3HyG9qJB9rn5k3Vg3GUC9a1WAym
	gXx69YosxD8yyLwvcaBVzmEyZpWQjxJw=
X-Gm-Gg: Acq92OFre/DecW/eu23UnKOenQ6yUqA01/vdaoxbPSFNFc0Ft/7RiN588AbaRTWJuyH
	0ir6dCvJWR+MOx7hkDoX3NfaIRdkK0r0FSO86Y5izneB1Om8lUTAnNqeXdmfMtoqm519R4EkaFX
	OUCJG9u+Q/wUHbU4RU/YlbQ8l8frjPNhPtvq52+M9R8hoXt7oB1xv+x6NjB4m2fEylbBvgj8tEg
	HhNpNE5cwKJAzH8wY7x04VvY4TdXTWiNPCJusJodiis2FMfHWg6hKV5Qoy8lPaonWfSUc1cYKWM
	bb901jvDZKvWNmARVbI8
X-Received: by 2002:a05:622a:4a07:b0:517:6049:7e2 with SMTP id
 d75a77b69052e-51795b2bc76mr312147341cf.27.1781075693069; Wed, 10 Jun 2026
 00:14:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAHPqNmyfm4j0Vy--8rpYMEY1wOP-TgmnRWYd=7ragj1Z29=F7g@mail.gmail.com>
 <aih7PqPryonzP7cI@chamomile>
In-Reply-To: <aih7PqPryonzP7cI@chamomile>
From: Longxing Li <coregee2000@gmail.com>
Date: Wed, 10 Jun 2026 15:14:41 +0800
X-Gm-Features: AVVi8Cd8jcLFInNRL0PbgUOP03-NGXhR315QVzJGETBslAJNeyOGk4ofhCc9TQc
Message-ID: <CAHPqNmxbS+YLQeOLOibm5rOBxA_nciMAVuEe5ERCOs3uE6+8+Q@mail.gmail.com>
Subject: Re: [Kernel Bug] INFO: task hung in xt_find_table
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: syzkaller@googlegroups.com, edumazet@google.com, kuba@kernel.org, 
	pabeni@redhat.com, horms@kernel.org, netfilter-devel@vger.kernel.org, 
	coreteam@netfilter.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

sorry for not containing report plain text in last email. the report
is as follows:

INFO: task syz-executor.4:42949 blocked for more than 143 seconds.
      Not tainted 7.0.6 #1
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor.4  state:D stack:26456 pid:42949 tgid:42937
ppid:9759   task_flags:0x400140 flags:0x00080002
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5298 [inline]
 __schedule+0x1006/0x5f00 kernel/sched/core.c:6911
 __schedule_loop kernel/sched/core.c:6993 [inline]
 schedule+0xe7/0x3a0 kernel/sched/core.c:7008
 schedule_preempt_disabled+0x13/0x30 kernel/sched/core.c:7065
 __mutex_lock_common kernel/locking/mutex.c:692 [inline]
 __mutex_lock+0xd9e/0x1df0 kernel/locking/mutex.c:776
 xt_find_table+0x59/0x1a0 net/netfilter/x_tables.c:1245
 ip6t_unregister_table_exit+0x22/0x50 net/ipv6/netfilter/ip6_tables.c:1808
 ops_exit_list net/core/net_namespace.c:199 [inline]
 ops_undo_list+0x2dd/0xa50 net/core/net_namespace.c:252
 setup_net+0x1f3/0x3a0 net/core/net_namespace.c:462
 copy_net_ns+0x351/0x7c0 net/core/net_namespace.c:579
 create_new_namespaces+0x3f6/0xac0 kernel/nsproxy.c:130
 copy_namespaces+0x45c/0x580 kernel/nsproxy.c:195
 copy_process+0x30cc/0x76d0 kernel/fork.c:2227
 kernel_clone+0xea/0x8f0 kernel/fork.c:2655
 __do_sys_clone+0xce/0x120 kernel/fork.c:2796
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x11b/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x471ecd
RSP: 002b:00007f51f163e008 EFLAGS: 00000202 ORIG_RAX: 0000000000000038
RAX: ffffffffffffffda RBX: 000000000059bf80 RCX: 0000000000471ecd
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000040080020
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000202 R12: 000000000059bf8c
R13: 000000000000000b R14: 000000000059bf80 R15: 00007f51f161e000
 </TASK>

Showing all locks held in the system:
2 locks held by kthreadd/2:
 #0: ffffffff8e7a78a0 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim
mm/page_alloc.c:4429 [inline]
 #0: ffffffff8e7a78a0 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_direct_reclaim mm/page_alloc.c:4454 [inline]
 #0: ffffffff8e7a78a0 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_slowpath mm/page_alloc.c:4854 [inline]
 #0: ffffffff8e7a78a0 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_frozen_pages_noprof+0x860/0x27e0 mm/page_alloc.c:5271
 #1: ffffe8ffffc27170 (&per_cpu_ptr(pool->acomp_ctx,
cpu)->mutex){+.+.}-{4:4}, at: acomp_ctx_get_cpu_lock mm/zswap.c:834
[inline]
 #1: ffffe8ffffc27170 (&per_cpu_ptr(pool->acomp_ctx,
cpu)->mutex){+.+.}-{4:4}, at: zswap_compress mm/zswap.c:865 [inline]
 #1: ffffe8ffffc27170 (&per_cpu_ptr(pool->acomp_ctx,
cpu)->mutex){+.+.}-{4:4}, at: zswap_store_page mm/zswap.c:1422
[inline]
 #1: ffffe8ffffc27170 (&per_cpu_ptr(pool->acomp_ctx,
cpu)->mutex){+.+.}-{4:4}, at: zswap_store+0x875/0x2710 mm/zswap.c:1533
1 lock held by khungtaskd/25:
 #0: ffffffff8e5e6ce0 (rcu_read_lock){....}-{1:3}, at:
rcu_lock_acquire include/linux/rcupdate.h:312 [inline]
 #0: ffffffff8e5e6ce0 (rcu_read_lock){....}-{1:3}, at: rcu_read_lock
include/linux/rcupdate.h:850 [inline]
 #0: ffffffff8e5e6ce0 (rcu_read_lock){....}-{1:3}, at:
debug_show_all_locks+0x36/0x1c0 kernel/locking/lockdep.c:6775
4 locks held by kworker/u4:4/53:
 #0: ffff88801c73c948
((wq_completion)ext4-rsv-conversion){+.+.}-{0:0}, at:
process_one_work+0x139e/0x1c60 kernel/workqueue.c:3263
 #1: ffffc9000100fd08
((work_completion)(&ei->i_rsv_conversion_work)){+.+.}-{0:0}, at:
process_one_work+0x938/0x1c60 kernel/workqueue.c:3264
 #2: ffff888025a86950 (jbd2_handle){++++}-{0:0}, at:
start_this_handle+0xe33/0x12d0 fs/jbd2/transaction.c:444
 #3: ffffe8ffffc27170 (&per_cpu_ptr(pool->acomp_ctx,
cpu)->mutex){+.+.}-{4:4}, at: acomp_ctx_get_cpu_lock mm/zswap.c:834
[inline]
 #3: ffffe8ffffc27170 (&per_cpu_ptr(pool->acomp_ctx,
cpu)->mutex){+.+.}-{4:4}, at: zswap_compress mm/zswap.c:865 [inline]
 #3: ffffe8ffffc27170 (&per_cpu_ptr(pool->acomp_ctx,
cpu)->mutex){+.+.}-{4:4}, at: zswap_store_page mm/zswap.c:1422
[inline]
 #3: ffffe8ffffc27170 (&per_cpu_ptr(pool->acomp_ctx,
cpu)->mutex){+.+.}-{4:4}, at: zswap_store+0x875/0x2710 mm/zswap.c:1533
7 locks held by kworker/u4:5/74:
 #0: ffff88801c723148 ((wq_completion)writeback){+.+.}-{0:0}, at:
process_one_work+0x139e/0x1c60 kernel/workqueue.c:3263
 #1: ffffc9000125fd08
((work_completion)(&(&wb->dwork)->work)){+.+.}-{0:0}, at:
process_one_work+0x938/0x1c60 kernel/workqueue.c:3264
 #2: ffff888025a820e0 (&type->s_umount_key#56){++++}-{4:4}, at:
super_trylock_shared+0x21/0x100 fs/super.c:565
 #3: ffff888025a80c18 (&sbi->s_writepages_rwsem){++++}-{0:0}, at:
do_writepages+0x242/0x5b0 mm/page-writeback.c:2575
 #4: ffff888025a86950 (jbd2_handle){++++}-{0:0}, at:
start_this_handle+0xe33/0x12d0 fs/jbd2/transaction.c:444
 #5: ffff88802b266260 (&ei->i_data_sem){++++}-{4:4}, at:
ext4_map_blocks+0x54c/0xcc0 fs/ext4/inode.c:818
 #6: ffffe8ffffc27170 (&per_cpu_ptr(pool->acomp_ctx,
cpu)->mutex){+.+.}-{4:4}, at: acomp_ctx_get_cpu_lock mm/zswap.c:834
[inline]
 #6: ffffe8ffffc27170 (&per_cpu_ptr(pool->acomp_ctx,
cpu)->mutex){+.+.}-{4:4}, at: zswap_compress mm/zswap.c:865 [inline]
 #6: ffffe8ffffc27170 (&per_cpu_ptr(pool->acomp_ctx,
cpu)->mutex){+.+.}-{4:4}, at: zswap_store_page mm/zswap.c:1422
[inline]
 #6: ffffe8ffffc27170 (&per_cpu_ptr(pool->acomp_ctx,
cpu)->mutex){+.+.}-{4:4}, at: zswap_store+0x875/0x2710 mm/zswap.c:1533
2 locks held by kswapd1/79:
 #0: ffffffff8e7a78a0 (fs_reclaim){+.+.}-{0:0}, at:
balance_pgdat+0xc0b/0x1b60 mm/vmscan.c:7083
 #1: ffffe8ffffc27170 (&per_cpu_ptr(pool->acomp_ctx,
cpu)->mutex){+.+.}-{4:4}, at: acomp_ctx_get_cpu_lock mm/zswap.c:834
[inline]
 #1: ffffe8ffffc27170 (&per_cpu_ptr(pool->acomp_ctx,
cpu)->mutex){+.+.}-{4:4}, at: zswap_compress mm/zswap.c:865 [inline]
 #1: ffffe8ffffc27170 (&per_cpu_ptr(pool->acomp_ctx,
cpu)->mutex){+.+.}-{4:4}, at: zswap_store_page mm/zswap.c:1422
[inline]
 #1: ffffe8ffffc27170 (&per_cpu_ptr(pool->acomp_ctx,
cpu)->mutex){+.+.}-{4:4}, at: zswap_store+0x875/0x2710 mm/zswap.c:1533
5 locks held by kworker/u4:6/340:
4 locks held by kworker/u4:7/3543:
 #0: ffff88801b894948 ((wq_completion)events_unbound#2){+.+.}-{0:0},
at: process_one_work+0x139e/0x1c60 kernel/workqueue.c:3263
 #1: ffffc9000b77fd08
((work_completion)(&sub_info->work)){+.+.}-{0:0}, at:
process_one_work+0x938/0x1c60 kernel/workqueue.c:3264
 #2: ffffffff8e7a78a0 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim
mm/page_alloc.c:4429 [inline]
 #2: ffffffff8e7a78a0 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_direct_reclaim mm/page_alloc.c:4454 [inline]
 #2: ffffffff8e7a78a0 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_slowpath mm/page_alloc.c:4854 [inline]
 #2: ffffffff8e7a78a0 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_frozen_pages_noprof+0x860/0x27e0 mm/page_alloc.c:5271
 #3: ffffe8ffffc27170 (&per_cpu_ptr(pool->acomp_ctx,
cpu)->mutex){+.+.}-{4:4}, at: acomp_ctx_get_cpu_lock mm/zswap.c:834
[inline]
 #3: ffffe8ffffc27170 (&per_cpu_ptr(pool->acomp_ctx,
cpu)->mutex){+.+.}-{4:4}, at: zswap_compress mm/zswap.c:865 [inline]
 #3: ffffe8ffffc27170 (&per_cpu_ptr(pool->acomp_ctx,
cpu)->mutex){+.+.}-{4:4}, at: zswap_store_page mm/zswap.c:1422
[inline]
 #3: ffffe8ffffc27170 (&per_cpu_ptr(pool->acomp_ctx,
cpu)->mutex){+.+.}-{4:4}, at: zswap_store+0x875/0x2710 mm/zswap.c:1533
1 lock held by jbd2/sda-8/5138:
 #0: ffffe8ffffc27170 (&per_cpu_ptr(pool->acomp_ctx,
cpu)->mutex){+.+.}-{4:4}, at: acomp_ctx_get_cpu_lock mm/zswap.c:834
[inline]
 #0: ffffe8ffffc27170 (&per_cpu_ptr(pool->acomp_ctx,
cpu)->mutex){+.+.}-{4:4}, at: zswap_compress mm/zswap.c:865 [inline]
 #0: ffffe8ffffc27170 (&per_cpu_ptr(pool->acomp_ctx,
cpu)->mutex){+.+.}-{4:4}, at: zswap_store_page mm/zswap.c:1422
[inline]
 #0: ffffe8ffffc27170 (&per_cpu_ptr(pool->acomp_ctx,
cpu)->mutex){+.+.}-{4:4}, at: zswap_store+0x875/0x2710 mm/zswap.c:1533
4 locks held by systemd-journal/5165:
 #0: ffff88804ebcbd08 (vm_lock){++++}-{0:0}, at:
lock_vma_under_rcu+0x118/0x5a0 mm/mmap_lock.c:310
 #1: ffff888025a82518 (sb_pagefaults){.+.+}-{0:0}, at:
do_page_mkwrite+0x17a/0x390 mm/memory.c:3602
 #2: ffff888025a86950 (jbd2_handle){++++}-{0:0}, at:
start_this_handle+0xe33/0x12d0 fs/jbd2/transaction.c:444
 #3: ffffe8ffffc27170 (&per_cpu_ptr(pool->acomp_ctx,
cpu)->mutex){+.+.}-{4:4}, at: acomp_ctx_get_cpu_lock mm/zswap.c:834
[inline]
 #3: ffffe8ffffc27170 (&per_cpu_ptr(pool->acomp_ctx,
cpu)->mutex){+.+.}-{4:4}, at: zswap_compress mm/zswap.c:865 [inline]
 #3: ffffe8ffffc27170 (&per_cpu_ptr(pool->acomp_ctx,
cpu)->mutex){+.+.}-{4:4}, at: zswap_store_page mm/zswap.c:1422
[inline]
 #3: ffffe8ffffc27170 (&per_cpu_ptr(pool->acomp_ctx,
cpu)->mutex){+.+.}-{4:4}, at: zswap_store+0x875/0x2710 mm/zswap.c:1533
2 locks held by systemd-udevd/5178:
2 locks held by cron/9006:
 #0: ffffffff8f04c678 (tomoyo_ss){.+.+}-{0:0}, at: srcu_lock_acquire
include/linux/srcu.h:187 [inline]
 #0: ffffffff8f04c678 (tomoyo_ss){.+.+}-{0:0}, at: srcu_read_lock
include/linux/srcu.h:294 [inline]
 #0: ffffffff8f04c678 (tomoyo_ss){.+.+}-{0:0}, at: tomoyo_read_lock
security/tomoyo/common.h:1112 [inline]
 #0: ffffffff8f04c678 (tomoyo_ss){.+.+}-{0:0}, at:
tomoyo_path_perm+0x223/0x420 security/tomoyo/file.c:826
 #1: ffffe8ffffc27170 (&per_cpu_ptr(pool->acomp_ctx,
cpu)->mutex){+.+.}-{4:4}, at: acomp_ctx_get_cpu_lock mm/zswap.c:834
[inline]
 #1: ffffe8ffffc27170 (&per_cpu_ptr(pool->acomp_ctx,
cpu)->mutex){+.+.}-{4:4}, at: zswap_compress mm/zswap.c:865 [inline]
 #1: ffffe8ffffc27170 (&per_cpu_ptr(pool->acomp_ctx,
cpu)->mutex){+.+.}-{4:4}, at: zswap_store_page mm/zswap.c:1422
[inline]
 #1: ffffe8ffffc27170 (&per_cpu_ptr(pool->acomp_ctx,
cpu)->mutex){+.+.}-{4:4}, at: zswap_store+0x875/0x2710 mm/zswap.c:1533
1 lock held by in:imklog/9071:
5 locks held by rs:main Q:Reg/9072:
 #0: ffff888050036d38 (&f->f_pos_lock){+.+.}-{4:4}, at:
fdget_pos+0x2a0/0x370 fs/file.c:1261
 #1: ffff888025a82420 (sb_writers#4){.+.+}-{0:0}, at:
ksys_write+0x121/0x240 fs/read_write.c:740
 #2: ffff88802b2663d0 (&sb->s_type->i_mutex_key#10){++++}-{4:4}, at:
inode_lock include/linux/fs.h:1028 [inline]
 #2: ffff88802b2663d0 (&sb->s_type->i_mutex_key#10){++++}-{4:4}, at:
ext4_buffered_write_iter+0xab/0x430 fs/ext4/file.c:295
 #3: ffff888025a86950 (jbd2_handle){++++}-{0:0}, at:
start_this_handle+0xe33/0x12d0 fs/jbd2/transaction.c:444
 #4: ffffe8ffffc27170 (&per_cpu_ptr(pool->acomp_ctx,
cpu)->mutex){+.+.}-{4:4}, at: acomp_ctx_get_cpu_lock mm/zswap.c:834
[inline]
 #4: ffffe8ffffc27170 (&per_cpu_ptr(pool->acomp_ctx,
cpu)->mutex){+.+.}-{4:4}, at: zswap_compress mm/zswap.c:865 [inline]
 #4: ffffe8ffffc27170 (&per_cpu_ptr(pool->acomp_ctx,
cpu)->mutex){+.+.}-{4:4}, at: zswap_store_page mm/zswap.c:1422
[inline]
 #4: ffffe8ffffc27170 (&per_cpu_ptr(pool->acomp_ctx,
cpu)->mutex){+.+.}-{4:4}, at: zswap_store+0x875/0x2710 mm/zswap.c:1533
3 locks held by syz-fuzzer/9743:
 #0: ffff88804ea40bc8 (vm_lock){++++}-{0:0}, at:
lock_vma_under_rcu+0x118/0x5a0 mm/mmap_lock.c:310
 #1: ffffffff8e7a78a0 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim
mm/page_alloc.c:4429 [inline]
 #1: ffffffff8e7a78a0 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_direct_reclaim mm/page_alloc.c:4454 [inline]
 #1: ffffffff8e7a78a0 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_slowpath mm/page_alloc.c:4854 [inline]
 #1: ffffffff8e7a78a0 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_frozen_pages_noprof+0x860/0x27e0 mm/page_alloc.c:5271
 #2: ffffe8ffffc27170 (&per_cpu_ptr(pool->acomp_ctx,
cpu)->mutex){+.+.}-{4:4}, at: acomp_ctx_get_cpu_lock mm/zswap.c:834
[inline]
 #2: ffffe8ffffc27170 (&per_cpu_ptr(pool->acomp_ctx,
cpu)->mutex){+.+.}-{4:4}, at: zswap_compress mm/zswap.c:865 [inline]
 #2: ffffe8ffffc27170 (&per_cpu_ptr(pool->acomp_ctx,
cpu)->mutex){+.+.}-{4:4}, at: zswap_store_page mm/zswap.c:1422
[inline]
 #2: ffffe8ffffc27170 (&per_cpu_ptr(pool->acomp_ctx,
cpu)->mutex){+.+.}-{4:4}, at: zswap_store+0x875/0x2710 mm/zswap.c:1533
5 locks held by syz-executor.2/9744:
 #0: ffff888025a412b8 (&f->f_pos_lock){+.+.}-{4:4}, at:
fdget_pos+0x2a0/0x370 fs/file.c:1261
 #1: ffff88804cd26d68 (&type->i_mutex_dir_key#3){++++}-{4:4}, at:
iterate_dir+0x197/0xb00 fs/readdir.c:101
 #2: ffff888025a82420 (sb_writers#4){.+.+}-{0:0}, at: file_accessed
include/linux/fs.h:2261 [inline]
 #2: ffff888025a82420 (sb_writers#4){.+.+}-{0:0}, at:
iterate_dir+0x869/0xb00 fs/readdir.c:111
 #3: ffff888025a86950 (jbd2_handle){++++}-{0:0}, at:
start_this_handle+0xe33/0x12d0 fs/jbd2/transaction.c:444
 #4: ffffe8ffffc27170 (&per_cpu_ptr(pool->acomp_ctx,
cpu)->mutex){+.+.}-{4:4}, at: acomp_ctx_get_cpu_lock mm/zswap.c:834
[inline]
 #4: ffffe8ffffc27170 (&per_cpu_ptr(pool->acomp_ctx,
cpu)->mutex){+.+.}-{4:4}, at: zswap_compress mm/zswap.c:865 [inline]
 #4: ffffe8ffffc27170 (&per_cpu_ptr(pool->acomp_ctx,
cpu)->mutex){+.+.}-{4:4}, at: zswap_store_page mm/zswap.c:1422
[inline]
 #4: ffffe8ffffc27170 (&per_cpu_ptr(pool->acomp_ctx,
cpu)->mutex){+.+.}-{4:4}, at: zswap_store+0x875/0x2710 mm/zswap.c:1533
3 locks held by syz-executor.0/9745:
3 locks held by syz-executor.4/9759:
 #0: ffff8880469e2d08 (vm_lock){++++}-{0:0}, at:
lock_vma_under_rcu+0x118/0x5a0 mm/mmap_lock.c:310
 #1: ffffffff8e7a78a0 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim
mm/page_alloc.c:4429 [inline]
 #1: ffffffff8e7a78a0 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_direct_reclaim mm/page_alloc.c:4454 [inline]
 #1: ffffffff8e7a78a0 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_slowpath mm/page_alloc.c:4854 [inline]
 #1: ffffffff8e7a78a0 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_frozen_pages_noprof+0x860/0x27e0 mm/page_alloc.c:5271
 #2: ffffe8ffffc27170 (&per_cpu_ptr(pool->acomp_ctx,
cpu)->mutex){+.+.}-{4:4}, at: acomp_ctx_get_cpu_lock mm/zswap.c:834
[inline]
 #2: ffffe8ffffc27170 (&per_cpu_ptr(pool->acomp_ctx,
cpu)->mutex){+.+.}-{4:4}, at: zswap_compress mm/zswap.c:865 [inline]
 #2: ffffe8ffffc27170 (&per_cpu_ptr(pool->acomp_ctx,
cpu)->mutex){+.+.}-{4:4}, at: zswap_store_page mm/zswap.c:1422
[inline]
 #2: ffffe8ffffc27170 (&per_cpu_ptr(pool->acomp_ctx,
cpu)->mutex){+.+.}-{4:4}, at: zswap_store+0x875/0x2710 mm/zswap.c:1533
3 locks held by syz-executor.6/9760:
 #0: ffff8880501b4bc8 (vm_lock){++++}-{0:0}, at:
lock_vma_under_rcu+0x118/0x5a0 mm/mmap_lock.c:310
 #1: ffffffff8e7a78a0 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim
mm/page_alloc.c:4429 [inline]
 #1: ffffffff8e7a78a0 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_direct_reclaim mm/page_alloc.c:4454 [inline]
 #1: ffffffff8e7a78a0 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_slowpath mm/page_alloc.c:4854 [inline]
 #1: ffffffff8e7a78a0 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_frozen_pages_noprof+0x860/0x27e0 mm/page_alloc.c:5271
 #2: ffffe8ffffc27170 (&per_cpu_ptr(pool->acomp_ctx,
cpu)->mutex){+.+.}-{4:4}, at: acomp_ctx_get_cpu_lock mm/zswap.c:834
[inline]
 #2: ffffe8ffffc27170 (&per_cpu_ptr(pool->acomp_ctx,
cpu)->mutex){+.+.}-{4:4}, at: zswap_compress mm/zswap.c:865 [inline]
 #2: ffffe8ffffc27170 (&per_cpu_ptr(pool->acomp_ctx,
cpu)->mutex){+.+.}-{4:4}, at: zswap_store_page mm/zswap.c:1422
[inline]
 #2: ffffe8ffffc27170 (&per_cpu_ptr(pool->acomp_ctx,
cpu)->mutex){+.+.}-{4:4}, at: zswap_store+0x875/0x2710 mm/zswap.c:1533
5 locks held by syz-executor.3/9761:
 #0: ffff888020c5ed38 (&f->f_pos_lock){+.+.}-{4:4}, at:
fdget_pos+0x2a0/0x370 fs/file.c:1261
 #1: ffff88804745e3d0 (&type->i_mutex_dir_key#3){++++}-{4:4}, at:
iterate_dir+0x197/0xb00 fs/readdir.c:101
 #2: ffff888025a82420 (sb_writers#4){.+.+}-{0:0}, at: file_accessed
include/linux/fs.h:2261 [inline]
 #2: ffff888025a82420 (sb_writers#4){.+.+}-{0:0}, at:
iterate_dir+0x869/0xb00 fs/readdir.c:111
 #3: ffff888025a86950 (jbd2_handle){++++}-{0:0}, at:
start_this_handle+0xe33/0x12d0 fs/jbd2/transaction.c:444
 #4: ffffe8ffffc27170 (&per_cpu_ptr(pool->acomp_ctx,
cpu)->mutex){+.+.}-{4:4}, at: acomp_ctx_get_cpu_lock mm/zswap.c:834
[inline]
 #4: ffffe8ffffc27170 (&per_cpu_ptr(pool->acomp_ctx,
cpu)->mutex){+.+.}-{4:4}, at: zswap_compress mm/zswap.c:865 [inline]
 #4: ffffe8ffffc27170 (&per_cpu_ptr(pool->acomp_ctx,
cpu)->mutex){+.+.}-{4:4}, at: zswap_store_page mm/zswap.c:1422
[inline]
 #4: ffffe8ffffc27170 (&per_cpu_ptr(pool->acomp_ctx,
cpu)->mutex){+.+.}-{4:4}, at: zswap_store+0x875/0x2710 mm/zswap.c:1533
3 locks held by syz-executor.1/9765:
 #0: ffff888022db2d88 (&xt[i].mutex){+.+.}-{4:4}, at:
xt_find_table_lock+0x5f/0x540 net/netfilter/x_tables.c:1266
 #1: ffffffff8e7a78a0 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim
mm/page_alloc.c:4429 [inline]
 #1: ffffffff8e7a78a0 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_direct_reclaim mm/page_alloc.c:4454 [inline]
 #1: ffffffff8e7a78a0 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_slowpath mm/page_alloc.c:4854 [inline]
 #1: ffffffff8e7a78a0 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_frozen_pages_noprof+0x860/0x27e0 mm/page_alloc.c:5271
 #2: ffffe8ffffc27170 (&per_cpu_ptr(pool->acomp_ctx,
cpu)->mutex){+.+.}-{4:4}, at: acomp_ctx_get_cpu_lock mm/zswap.c:834
[inline]
 #2: ffffe8ffffc27170 (&per_cpu_ptr(pool->acomp_ctx,
cpu)->mutex){+.+.}-{4:4}, at: zswap_compress mm/zswap.c:865 [inline]
 #2: ffffe8ffffc27170 (&per_cpu_ptr(pool->acomp_ctx,
cpu)->mutex){+.+.}-{4:4}, at: zswap_store_page mm/zswap.c:1422
[inline]
 #2: ffffe8ffffc27170 (&per_cpu_ptr(pool->acomp_ctx,
cpu)->mutex){+.+.}-{4:4}, at: zswap_store+0x875/0x2710 mm/zswap.c:1533
3 locks held by syz-executor.7/9772:
 #0: ffff88804d15cd08 (vm_lock){++++}-{0:0}, at:
lock_vma_under_rcu+0x118/0x5a0 mm/mmap_lock.c:310
 #1: ffffffff8e7a78a0 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim
mm/page_alloc.c:4429 [inline]
 #1: ffffffff8e7a78a0 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_direct_reclaim mm/page_alloc.c:4454 [inline]
 #1: ffffffff8e7a78a0 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_slowpath mm/page_alloc.c:4854 [inline]
 #1: ffffffff8e7a78a0 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_frozen_pages_noprof+0x860/0x27e0 mm/page_alloc.c:5271
 #2: ffffe8ffffc27170 (&per_cpu_ptr(pool->acomp_ctx,
cpu)->mutex){+.+.}-{4:4}, at: acomp_ctx_get_cpu_lock mm/zswap.c:834
[inline]
 #2: ffffe8ffffc27170 (&per_cpu_ptr(pool->acomp_ctx,
cpu)->mutex){+.+.}-{4:4}, at: zswap_compress mm/zswap.c:865 [inline]
 #2: ffffe8ffffc27170 (&per_cpu_ptr(pool->acomp_ctx,
cpu)->mutex){+.+.}-{4:4}, at: zswap_store_page mm/zswap.c:1422
[inline]
 #2: ffffe8ffffc27170 (&per_cpu_ptr(pool->acomp_ctx,
cpu)->mutex){+.+.}-{4:4}, at: zswap_store+0x875/0x2710 mm/zswap.c:1533
5 locks held by syz-executor.5/9790:
 #0: ffffffff8e71f1d0 (dup_mmap_sem){.+.+}-{0:0}, at: dup_mm
kernel/fork.c:1531 [inline]
 #0: ffffffff8e71f1d0 (dup_mmap_sem){.+.+}-{0:0}, at: copy_mm
kernel/fork.c:1584 [inline]
 #0: ffffffff8e71f1d0 (dup_mmap_sem){.+.+}-{0:0}, at:
copy_process+0x6535/0x76d0 kernel/fork.c:2224
 #1: ffff888012e54cc0 (&mm->mmap_lock){++++}-{4:4}, at:
mmap_write_lock_killable include/linux/mmap_lock.h:554 [inline]
 #1: ffff888012e54cc0 (&mm->mmap_lock){++++}-{4:4}, at:
dup_mmap+0x124/0x2330 mm/mmap.c:1740
 #2: ffff88805c1cccc0 (&mm->mmap_lock/1){+.+.}-{4:4}, at:
mmap_write_lock_nested include/linux/mmap_lock.h:544 [inline]
 #2: ffff88805c1cccc0 (&mm->mmap_lock/1){+.+.}-{4:4}, at:
dup_mmap+0x1c6/0x2330 mm/mmap.c:1747
 #3: ffffffff8e7a78a0 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim
mm/page_alloc.c:4429 [inline]
 #3: ffffffff8e7a78a0 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_direct_reclaim mm/page_alloc.c:4454 [inline]
 #3: ffffffff8e7a78a0 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_slowpath mm/page_alloc.c:4854 [inline]
 #3: ffffffff8e7a78a0 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_frozen_pages_noprof+0x860/0x27e0 mm/page_alloc.c:5271
 #4: ffffe8ffffc27170 (&per_cpu_ptr(pool->acomp_ctx,
cpu)->mutex){+.+.}-{4:4}, at: acomp_ctx_get_cpu_lock mm/zswap.c:834
[inline]
 #4: ffffe8ffffc27170 (&per_cpu_ptr(pool->acomp_ctx,
cpu)->mutex){+.+.}-{4:4}, at: zswap_compress mm/zswap.c:865 [inline]
 #4: ffffe8ffffc27170 (&per_cpu_ptr(pool->acomp_ctx,
cpu)->mutex){+.+.}-{4:4}, at: zswap_store_page mm/zswap.c:1422
[inline]
 #4: ffffe8ffffc27170 (&per_cpu_ptr(pool->acomp_ctx,
cpu)->mutex){+.+.}-{4:4}, at: zswap_store+0x875/0x2710 mm/zswap.c:1533
2 locks held by kworker/0:8/11473:
7 locks held by kworker/u4:8/12707:
 #0: ffff88801c723148 ((wq_completion)writeback){+.+.}-{0:0}, at:
process_one_work+0x139e/0x1c60 kernel/workqueue.c:3263
 #1: ffffc9000bfdfd08
((work_completion)(&(&wb->dwork)->work)){+.+.}-{0:0}, at:
process_one_work+0x938/0x1c60 kernel/workqueue.c:3264
 #2: ffff888025a820e0 (&type->s_umount_key#56){++++}-{4:4}, at:
super_trylock_shared+0x21/0x100 fs/super.c:565
 #3: ffff888025a80c18 (&sbi->s_writepages_rwsem){++++}-{0:0}, at:
do_writepages+0x242/0x5b0 mm/page-writeback.c:2575
 #4: ffff888025a86950 (jbd2_handle){++++}-{0:0}, at:
start_this_handle+0xe33/0x12d0 fs/jbd2/transaction.c:444
 #5: ffff8880475115a0 (&ei->i_data_sem){++++}-{4:4}, at:
ext4_map_blocks+0x54c/0xcc0 fs/ext4/inode.c:818
 #6: ffffe8ffffc27170 (&per_cpu_ptr(pool->acomp_ctx,
cpu)->mutex){+.+.}-{4:4}, at: acomp_ctx_get_cpu_lock mm/zswap.c:834
[inline]
 #6: ffffe8ffffc27170 (&per_cpu_ptr(pool->acomp_ctx,
cpu)->mutex){+.+.}-{4:4}, at: zswap_compress mm/zswap.c:865 [inline]
 #6: ffffe8ffffc27170 (&per_cpu_ptr(pool->acomp_ctx,
cpu)->mutex){+.+.}-{4:4}, at: zswap_store_page mm/zswap.c:1422
[inline]
 #6: ffffe8ffffc27170 (&per_cpu_ptr(pool->acomp_ctx,
cpu)->mutex){+.+.}-{4:4}, at: zswap_store+0x875/0x2710 mm/zswap.c:1533
2 locks held by kworker/u4:9/15616:
 #0: ffff88801b894948 ((wq_completion)events_unbound#2){+.+.}-{0:0},
at: process_one_work+0x139e/0x1c60 kernel/workqueue.c:3263
 #1: ffffc9001a077d08
((work_completion)(&sub_info->work)){+.+.}-{0:0}, at:
process_one_work+0x938/0x1c60 kernel/workqueue.c:3264
6 locks held by kworker/0:6/31120:
2 locks held by syz-executor.0/42951:
 #0: ffffffff903e44b0 (pernet_ops_rwsem){++++}-{4:4}, at:
copy_net_ns+0x335/0x7c0 net/core/net_namespace.c:575
 #1: ffff888022db2d88 (&xt[i].mutex){+.+.}-{4:4}, at:
xt_find_table+0x59/0x1a0 net/netfilter/x_tables.c:1245
2 locks held by syz-executor.4/42949:
 #0: ffffffff903e44b0 (pernet_ops_rwsem){++++}-{4:4}, at:
copy_net_ns+0x335/0x7c0 net/core/net_namespace.c:575
 #1: ffff888022db2d88 (&xt[i].mutex){+.+.}-{4:4}, at:
xt_find_table+0x59/0x1a0 net/netfilter/x_tables.c:1245
3 locks held by modprobe/43044:
 #0: ffff8880501b41c8 (vm_lock){++++}-{0:0}, at:
lock_vma_under_rcu+0x118/0x5a0 mm/mmap_lock.c:310
 #1: ffffffff8e7a78a0 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim
mm/page_alloc.c:4429 [inline]
 #1: ffffffff8e7a78a0 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_direct_reclaim mm/page_alloc.c:4454 [inline]
 #1: ffffffff8e7a78a0 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_slowpath mm/page_alloc.c:4854 [inline]
 #1: ffffffff8e7a78a0 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_frozen_pages_noprof+0x860/0x27e0 mm/page_alloc.c:5271
 #2: ffffe8ffffc27170 (&per_cpu_ptr(pool->acomp_ctx,
cpu)->mutex){+.+.}-{4:4}, at: acomp_ctx_get_cpu_lock mm/zswap.c:834
[inline]
 #2: ffffe8ffffc27170 (&per_cpu_ptr(pool->acomp_ctx,
cpu)->mutex){+.+.}-{4:4}, at: zswap_compress mm/zswap.c:865 [inline]
 #2: ffffe8ffffc27170 (&per_cpu_ptr(pool->acomp_ctx,
cpu)->mutex){+.+.}-{4:4}, at: zswap_store_page mm/zswap.c:1422
[inline]
 #2: ffffe8ffffc27170 (&per_cpu_ptr(pool->acomp_ctx,
cpu)->mutex){+.+.}-{4:4}, at: zswap_store+0x875/0x2710 mm/zswap.c:1533
3 locks held by syz-executor.7/43046:
 #0: ffff888049241808 (vm_lock){++++}-{0:0}, at:
lock_vma_under_rcu+0x118/0x5a0 mm/mmap_lock.c:310
 #1: ffffffff8e7a78a0 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim
mm/page_alloc.c:4429 [inline]
 #1: ffffffff8e7a78a0 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_direct_reclaim mm/page_alloc.c:4454 [inline]
 #1: ffffffff8e7a78a0 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_slowpath mm/page_alloc.c:4854 [inline]
 #1: ffffffff8e7a78a0 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_frozen_pages_noprof+0x860/0x27e0 mm/page_alloc.c:5271
 #2: ffffe8ffffc27170 (&per_cpu_ptr(pool->acomp_ctx,
cpu)->mutex){+.+.}-{4:4}, at: acomp_ctx_get_cpu_lock mm/zswap.c:834
[inline]
 #2: ffffe8ffffc27170 (&per_cpu_ptr(pool->acomp_ctx,
cpu)->mutex){+.+.}-{4:4}, at: zswap_compress mm/zswap.c:865 [inline]
 #2: ffffe8ffffc27170 (&per_cpu_ptr(pool->acomp_ctx,
cpu)->mutex){+.+.}-{4:4}, at: zswap_store_page mm/zswap.c:1422
[inline]
 #2: ffffe8ffffc27170 (&per_cpu_ptr(pool->acomp_ctx,
cpu)->mutex){+.+.}-{4:4}, at: zswap_store+0x875/0x2710 mm/zswap.c:1533
2 locks held by syz-executor.7/43047:
 #0: ffffffff8e7a78a0 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim
mm/page_alloc.c:4429 [inline]
 #0: ffffffff8e7a78a0 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_direct_reclaim mm/page_alloc.c:4454 [inline]
 #0: ffffffff8e7a78a0 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_slowpath mm/page_alloc.c:4854 [inline]
 #0: ffffffff8e7a78a0 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_frozen_pages_noprof+0x860/0x27e0 mm/page_alloc.c:5271
 #1: ffffe8ffffc27170 (&per_cpu_ptr(pool->acomp_ctx,
cpu)->mutex){+.+.}-{4:4}, at: acomp_ctx_get_cpu_lock mm/zswap.c:834
[inline]
 #1: ffffe8ffffc27170 (&per_cpu_ptr(pool->acomp_ctx,
cpu)->mutex){+.+.}-{4:4}, at: zswap_compress mm/zswap.c:865 [inline]
 #1: ffffe8ffffc27170 (&per_cpu_ptr(pool->acomp_ctx,
cpu)->mutex){+.+.}-{4:4}, at: zswap_store_page mm/zswap.c:1422
[inline]
 #1: ffffe8ffffc27170 (&per_cpu_ptr(pool->acomp_ctx,
cpu)->mutex){+.+.}-{4:4}, at: zswap_store+0x875/0x2710 mm/zswap.c:1533
3 locks held by syz-executor.6/43050:
 #0: ffff88804d7b8a88 (vm_lock){++++}-{0:0}, at:
lock_vma_under_rcu+0x118/0x5a0 mm/mmap_lock.c:310
 #1: ffffffff8e7a78a0 (fs_reclaim){+.+.}-{0:0}, at: __perform_reclaim
mm/page_alloc.c:4429 [inline]
 #1: ffffffff8e7a78a0 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_direct_reclaim mm/page_alloc.c:4454 [inline]
 #1: ffffffff8e7a78a0 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_pages_slowpath mm/page_alloc.c:4854 [inline]
 #1: ffffffff8e7a78a0 (fs_reclaim){+.+.}-{0:0}, at:
__alloc_frozen_pages_noprof+0x860/0x27e0 mm/page_alloc.c:5271
 #2: ffffe8ffffc27170 (&per_cpu_ptr(pool->acomp_ctx,
cpu)->mutex){+.+.}-{4:4}, at: acomp_ctx_get_cpu_lock mm/zswap.c:834
[inline]
 #2: ffffe8ffffc27170 (&per_cpu_ptr(pool->acomp_ctx,
cpu)->mutex){+.+.}-{4:4}, at: zswap_compress mm/zswap.c:865 [inline]
 #2: ffffe8ffffc27170 (&per_cpu_ptr(pool->acomp_ctx,
cpu)->mutex){+.+.}-{4:4}, at: zswap_store_page mm/zswap.c:1422
[inline]
 #2: ffffe8ffffc27170 (&per_cpu_ptr(pool->acomp_ctx,
cpu)->mutex){+.+.}-{4:4}, at: zswap_store+0x875/0x2710 mm/zswap.c:1533

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

NMI backtrace for cpu 0
CPU: 0 UID: 0 PID: 25 Comm: khungtaskd Not tainted 7.0.6 #1 PREEMPT(full)
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.15.0-1 04/01/=
2014
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x116/0x1b0 lib/dump_stack.c:120
 nmi_cpu_backtrace+0x2a0/0x350 lib/nmi_backtrace.c:113
 nmi_trigger_cpumask_backtrace+0x29c/0x300 lib/nmi_backtrace.c:62
 trigger_all_cpu_backtrace include/linux/nmi.h:161 [inline]
 __sys_info lib/sys_info.c:157 [inline]
 sys_info+0x133/0x180 lib/sys_info.c:165
 check_hung_uninterruptible_tasks kernel/hung_task.c:346 [inline]
 watchdog+0xeac/0x11e0 kernel/hung_task.c:515
 kthread+0x38d/0x4a0 kernel/kthread.c:436
 ret_from_fork+0x942/0xe50 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>

Pablo Neira Ayuso <pablo@netfilter.org> =E4=BA=8E2026=E5=B9=B46=E6=9C=8810=
=E6=97=A5=E5=91=A8=E4=B8=89 04:44=E5=86=99=E9=81=93=EF=BC=9A
>
> Hi,
>
> On Tue, Jun 09, 2026 at 07:55:34PM +0800, Longxing Li wrote:
> > Dear Linux kernel developers and maintainers,
> >
> > We would like to report a new kernel bug found by our tool. INFO: task
> > hung in xt_find_table. Details are as follows.
> >
> > Kernel commit: v7.0.6
> > Kernel config: see attachment
> > report: see attachment
> >
> > We are currently analyzing the root cause and  working on a
> > reproducible PoC. We will provide further updates in this thread as
> > soon as we have more information.
>
> No links to external web, please, inline in plain text to this email
> the description of what you found.
>
> Thanks.
