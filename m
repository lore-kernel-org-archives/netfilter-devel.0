Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB9B33BED4A
	for <netfilter-devel@vger.kernel.org>; Wed, 10 Jun 2026 09:26:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781083595; cv=none; b=XigrSFC/m/Ua5XHumcmx0G1mvThx1tCuo31nJdtzd4nqhDH0dtmjYc51VF5RO2HHlCeXL+STamPm13hiLWzQeEZ9JNgxQ0abpzDKtdKIvvDaAnJDle13mZrwGAznwDBrSjc156vMDDpS0Fnc/w+LlwEStui6VkKJStc9KPWCMgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781083595; c=relaxed/simple;
	bh=rDYf0gnIrYdQKrUthpTVKGSXzN6k7STc6mNhFd5HTq8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PmRhp04mFb2dE+mHvF6MESJegKHQB4j7uWzt1VEWkmkJaXt6B6V2xcK+frAQzpTpygIKhvBRm5FZaVbA/NP7t33mygpoqiRclJW9YuX3ZyASnoNIL1sds8focysBd0qDI1C5Hxraxrk4DUgErbuxsjvDM0bZsod+D6AruxHWq2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=AspQ/LZa; arc=none smtp.client-ip=91.218.175.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="AspQ/LZa"
Message-ID: <d26c8934-6d4c-4171-9e6f-f58a249dd9ff@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781083589;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hBbMp/terYy4HVPHHevofPr5zOE+Mp6tKWsqJZs/Bdc=;
	b=AspQ/LZakOFXxrC2SCXedf0yZ3uQXNlZ64Y9A5eYt+43qCH6ANEViDyPPbNSHxH+NtVN0v
	eC/mlBawAupz6KoDEM2cO0tzxBxFotGX2gjr9JjnzByOYHBZZzON+QniA2+PgL53c/dP84
	3+m0JXoe9FR2NFr7Tfq+KfqtoF44VK0=
Date: Wed, 10 Jun 2026 17:26:19 +0800
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [Kernel Bug] INFO: task hung in xt_find_table
To: Longxing Li <coregee2000@gmail.com>,
 Pablo Neira Ayuso <pablo@netfilter.org>
Cc: syzkaller@googlegroups.com, edumazet@google.com, kuba@kernel.org,
 pabeni@redhat.com, horms@kernel.org, netfilter-devel@vger.kernel.org,
 coreteam@netfilter.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <CAHPqNmyfm4j0Vy--8rpYMEY1wOP-TgmnRWYd=7ragj1Z29=F7g@mail.gmail.com>
 <aih7PqPryonzP7cI@chamomile>
 <CAHPqNmxbS+YLQeOLOibm5rOBxA_nciMAVuEe5ERCOs3uE6+8+Q@mail.gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Jiayuan Chen <jiayuan.chen@linux.dev>
In-Reply-To: <CAHPqNmxbS+YLQeOLOibm5rOBxA_nciMAVuEe5ERCOs3uE6+8+Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT


On 6/10/26 3:14 PM, Longxing Li wrote:
> sorry for not containing report plain text in last email. the report
> is as follows:
>
> INFO: task syz-executor.4:42949 blocked for more than 143 seconds.
>        Not tainted 7.0.6 #1
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> task:syz-executor.4  state:D stack:26456 pid:42949 tgid:42937
> ppid:9759   task_flags:0x400140 flags:0x00080002
> Call Trace:
>   <TASK>
>   context_switch kernel/sched/core.c:5298 [inline]
>   __schedule+0x1006/0x5f00 kernel/sched/core.c:6911
>   __schedule_loop kernel/sched/core.c:6993 [inline]
>   schedule+0xe7/0x3a0 kernel/sched/core.c:7008
>   schedule_preempt_disabled+0x13/0x30 kernel/sched/core.c:7065
>   __mutex_lock_common kernel/locking/mutex.c:692 [inline]
>   __mutex_lock+0xd9e/0x1df0 kernel/locking/mutex.c:776
>   xt_find_table+0x59/0x1a0 net/netfilter/x_tables.c:1245
>   ip6t_unregister_table_exit+0x22/0x50 net/ipv6/netfilter/ip6_tables.c:1808
>   ops_exit_list net/core/net_namespace.c:199 [inline]
>   ops_undo_list+0x2dd/0xa50 net/core/net_namespace.c:252
>   setup_net+0x1f3/0x3a0 net/core/net_namespace.c:462
>   copy_net_ns+0x351/0x7c0 net/core/net_namespace.c:579
>   create_new_namespaces+0x3f6/0xac0 kernel/nsproxy.c:130
>   copy_namespaces+0x45c/0x580 kernel/nsproxy.c:195
>   copy_process+0x30cc/0x76d0 kernel/fork.c:2227
>   kernel_clone+0xea/0x8f0 kernel/fork.c:2655
>   __do_sys_clone+0xce/0x120 kernel/fork.c:2796
>   do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>   do_syscall_64+0x11b/0xf80 arch/x86/entry/syscall_64.c:94
>   entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x471ecd
> RSP: 002b:00007f51f163e008 EFLAGS: 00000202 ORIG_RAX: 0000000000000038
> RAX: ffffffffffffffda RBX: 000000000059bf80 RCX: 0000000000471ecd
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000040080020
> RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000202 R12: 000000000059bf8c
> R13: 000000000000000b R14: 000000000059bf80 R15: 00007f51f161e000
>   </TASK>



This is not a deadlock — there's no lock cycle.

The runner is simply under heavy pressure on all three axes: CPU (zswap 
compression) + memory (direct reclaim) + IO (swap).

The hung task is just a victim. The actual holder is another task that 
took the mutex and then fell into direct reclaim.

Likely stack of the holder:
get_entries
   xt_find_table_lock
   copy_entries_to_user
     alloc_counters
        vzalloc  -> direct reclaim

"INFO: task hung" reports of this kind are common on the official 
syzkaller dashboard https://syzkaller.appspot.com/upstream/


