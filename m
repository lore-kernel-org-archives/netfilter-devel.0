Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CC5A1F81B9
	for <netfilter-devel@vger.kernel.org>; Thu, 24 Oct 2024 16:56:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729789017; cv=none; b=QivO5UPTCe1qupQ7bXmTCWuY6TdoVJSTfdfoF502T9sGtBmSrvurGNOoc3AxmM1rrtcN26yxujJ3+Brxerndb6zLlz3IrvdUpZw7Gt0K7snZQxYeEQVaaT+DbPD1boPvnPbn+YJHT5ThCJFiIF6zuOxYHI4GAfCBK1ckf5b7L8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729789017; c=relaxed/simple;
	bh=z/AIaT8CJJY4yUUDDdmDRVd1Isnlqte6iwO0+hdXKTQ=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:Content-Type; b=sqmBJenyJ1Hs/xJx0m/WAgPDaU8DTb10fMayAMpj+oCycC+cFO5o1eG8LtU7fc1M7hSchHNB8czMzQGknxqgZfpP72CRh6GrJXNcQFAfL8E9WQKpAUR/1wnXUbx9/7+f1kydvCRrdkGI/OyHgDcMzT6obVykbMKG7VLHBdIfMvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Wpn43i4w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Wpn43i4w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFC30C4CEC7;
	Thu, 24 Oct 2024 16:56:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729789016;
	bh=z/AIaT8CJJY4yUUDDdmDRVd1Isnlqte6iwO0+hdXKTQ=;
	h=Date:From:Subject:To:Cc:From;
	b=Wpn43i4wKfKlWEW+Gd86RhVzopR7yMBdu6ukTaEl+nwAEgtvDCLENYm/G5il+gveJ
	 +HK4JgS4tJlw1ttbZOxrrZmKrtFvtcBY5fZ1ncDbsZewDzQ7fE58/v19L9jO8djsC1
	 eoxSlxafv69oJlymV5x1+6bt7amNsYXrZUZvbFnUuSZ3RjRDqy9ntxI5CJuNaf0cZC
	 9YgiDxdCdYLd01uNtmsRKbGMVY1T8qLLwb4Yitu4kOsKcXo65FD9UHvqqUURGlcL/L
	 0EHBMJl20q+Z1ViYN5aGORuY/dbNHRS9mLdjzfygl9SMpKotBSb7GEf7Hfnv3aC/m9
	 qvgkdgTtCOQLA==
Message-ID: <da27f17f-3145-47af-ad0f-7fd2a823623e@kernel.org>
Date: Thu, 24 Oct 2024 18:56:43 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird Beta
Content-Language: en-GB
From: Matthieu Baerts <matttbe@kernel.org>
Subject: Netfilter: suspicious RCU usage in __nft_rule_lookup
Autocrypt: addr=matttbe@kernel.org; keydata=
 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
 lzVbFe7fduHbABmYz9cefQpO7wDE/Q==
Organization: NGI0 Core
To: netfilter-devel@vger.kernel.org
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
 Jozsef Kadlecsik <kadlec@netfilter.org>, Florian Westphal <fw@strlen.de>,
 Phil Sutter <phil@nwl.cc>, coreteam@netfilter.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hello,

First, thank you for all the work you did and are still doing around
Netfilter!

I'm writing you this email, because when I run the MPTCP test suite with
a VM running a kernel built with a debug config including
CONFIG_PROVE_RCU_LIST=y (and CONFIG_RCU_EXPERT=y), I get the following
warning:


> =============================
> WARNING: suspicious RCU usage
> 6.12.0-rc3+ #7 Not tainted
> -----------------------------
> net/netfilter/nf_tables_api.c:3420 RCU-list traversed in non-reader section!!
> 
> other info that might help us debug this:
> 
> 
> rcu_scheduler_active = 2, debug_locks = 1
> 1 lock held by iptables/134:
>   #0: ffff888008c4fcc8 (&nft_net->commit_mutex){+.+.}-{3:3}, at: nf_tables_valid_genid (include/linux/jiffies.h:101) nf_tables
> 
> stack backtrace:
> CPU: 1 UID: 0 PID: 134 Comm: iptables Not tainted 6.12.0-rc3+ #7
> Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
> Call Trace:
>  <TASK>
>  dump_stack_lvl (lib/dump_stack.c:123)
>  lockdep_rcu_suspicious (kernel/locking/lockdep.c:6822)
>  __nft_rule_lookup (net/netfilter/nf_tables_api.c:3420 (discriminator 7)) nf_tables
>  nf_tables_delrule (net/netfilter/nf_tables_api.c:4300 (discriminator 1)) nf_tables
>  ? __pfx_nf_tables_delrule (net/netfilter/nf_tables_api.c:4262) nf_tables
>  ? __mutex_unlock_slowpath (arch/x86/include/asm/atomic64_64.h:101 (discriminator 1))
>  ? __nla_validate_parse (lib/nlattr.c:638)
>  nfnetlink_rcv_batch (net/netfilter/nfnetlink.c:524)
>  ? __pfx_nfnetlink_rcv_batch (net/netfilter/nfnetlink.c:373)
>  ? rcu_read_lock_any_held (kernel/rcu/update.c:386 (discriminator 1))
>  ? validate_chain (kernel/locking/lockdep.c:3797 (discriminator 1))
>  ? rcu_read_lock_any_held (kernel/rcu/update.c:386 (discriminator 1))
>  ? validate_chain (kernel/locking/lockdep.c:3797 (discriminator 1))
>  ? __pfx_validate_chain (kernel/locking/lockdep.c:3860)
>  ? __nla_validate_parse (lib/nlattr.c:638)
>  nfnetlink_rcv (net/netfilter/nfnetlink.c:647)
>  ? __pfx___netlink_lookup (net/netlink/af_netlink.c:512)
>  ? __pfx_nfnetlink_rcv (net/netfilter/nfnetlink.c:651)
>  netlink_unicast (net/netlink/af_netlink.c:1331)
>  ? __pfx_netlink_unicast (net/netlink/af_netlink.c:1342)
>  ? find_held_lock (kernel/locking/lockdep.c:5315 (discriminator 1))
>  ? __might_fault (mm/memory.c:6700 (discriminator 5))
>  netlink_sendmsg (net/netlink/af_netlink.c:1901)
>  ? __pfx_netlink_sendmsg (net/netlink/af_netlink.c:1820)
>  ? __import_iovec (lib/iov_iter.c:1433 (discriminator 1))
>  ____sys_sendmsg (net/socket.c:729 (discriminator 1))
>  ? __pfx_____sys_sendmsg (net/socket.c:2553)
>  ? __pfx_copy_msghdr_from_user (net/socket.c:2533)
>  ? lockdep_hardirqs_on_prepare (kernel/locking/lockdep.c:4347)
>  ? sk_setsockopt (net/core/sock.c:1129)
>  ? __local_bh_enable_ip (arch/x86/include/asm/irqflags.h:42)
>  ___sys_sendmsg (net/socket.c:2663)
>  ? __pfx_sk_setsockopt (net/core/sock.c:1163)
>  ? __pfx____sys_sendmsg (net/socket.c:2650)
>  ? mark_lock (kernel/locking/lockdep.c:4703 (discriminator 1))
>  ? fdget (include/linux/atomic/atomic-arch-fallback.h:479 (discriminator 2))
>  ? find_held_lock (kernel/locking/lockdep.c:5315 (discriminator 1))
>  __sys_sendmsg (net/socket.c:2690 (discriminator 1))
>  ? __pfx___sys_sendmsg (net/socket.c:2678)
>  ? __sys_setsockopt (include/linux/file.h:35)
>  do_syscall_64 (arch/x86/entry/common.c:52 (discriminator 1))
>  entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:130)
> RIP: 0033:0x7ff6a026e004


It is very easy for me to reproduce it: simply by adding and removing an
IPTables rule. Just in case, here are the steps that can be used to have
the same behaviour:

  $ cd [kernel source code]
  $ echo "iptables -A OUTPUT -j REJECT; iptables -D OUTPUT -j REJECT" \
        > .virtme-exec-run
  $ docker run -v "${PWD}:${PWD}:rw" -w "${PWD}" --privileged --rm -it \
        --pull always mptcp/mptcp-upstream-virtme-docker:latest \
        auto-debug -e RCU_EXPERT -e PROVE_RCU_LIST


I looked a bit at the code in net/netfilter/nf_tables_api.c, and I can
see that rcu_read_(un)lock() are probably missing, but I'm a bit
confused by how the chain->rules list is protected, and modified using
or not the RCU helpers.

Do you mind looking at this issue please?
(No urgency on my side.)

Cheers,
Matt
-- 
Sponsored by the NGI0 Core fund.

