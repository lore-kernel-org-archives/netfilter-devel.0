Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94A2D178372;
	Sun,  4 Jan 2026 15:37:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767541059; cv=none; b=P9KpmRHIGwA6+H7RfyfsHIU7b3upd6c+/ucbpMocIy6sJtXcGi4z9OL7jTeXCL6MhrIKycyBMB71XURzx8hfddxKqy4aVxpOD7lqZpUtq6nHZ5YskVxoE86iYJO000OXtFXXKVfDZXXxkFPOYMJeIMonb6cvDRN0p3nZdVYuOGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767541059; c=relaxed/simple;
	bh=f8qA51GeLCIlhDQrH0p3jEQtUeHoC2nIO3MdcGWziF8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NW5X1jbeEcgs7RDeJXLNNIjAbV6/jlbK69YYDXUUpu08qZ1FSZnfJXxHJcZIWOusE7NnsozQkVsXiK19Ujvd+aReiGb9SFWl3tUNMhv1fUJ/WntzkTzpQ5ijB4W2F1lRgsbgy+z8yJNN9zCKr81mhmro0KQxwwoB3u3bvcdY6Uc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 6E7436033B; Sun, 04 Jan 2026 16:37:34 +0100 (CET)
Date: Sun, 4 Jan 2026 16:37:33 +0100
From: Florian Westphal <fw@strlen.de>
To: =?utf-8?B?546L5b+X?= <wangzhi_xd@stu.xidian.edu.cn>
Cc: pablo@netfilter.org, kadlec@netfilter.org,
	netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] netfilter: iptable_nat: fix null-ptr-deref in
 ipt_nat_register_lookups
Message-ID: <aVqJPbwPspQALMbt@strlen.de>
References: <70343c9f.96e5.19b8953d001.Coremail.wangzhi_xd@stu.xidian.edu.cn>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <70343c9f.96e5.19b8953d001.Coremail.wangzhi_xd@stu.xidian.edu.cn>

王志 <wangzhi_xd@stu.xidian.edu.cn> wrote:
> Dear Developers,
> 
> I am reporting a null-pointer dereference detected by Syzkaller on Linux 6.18.0. The issue occurs in the netfilter subsystem during concurrent network namespace creation and module loading.
> 1. Analysis
> The crash is triggered by a race condition between the registration of the iptable_nat template and the initialization of per-net private data.
> In ipt_nat_register_lookups(), the driver attempts to retrieve its private data using net_generic(net, iptable_nat_net_id). However, if the module is being loaded while a new network namespace is being initialized, net_generic can return NULL because the storage for this specific module ID has not yet been allocated or linked for the target namespace.
> The code currently proceeds without checking if xt_nat_net is valid. When it subsequently attempts to store the ops pointers: xt_nat_net->nf_nat_ops = ops; It results in a null-pointer dereference (GPF), specifically at an offset (e.g., 0x18) from the NULL base.

This needs a better description on the sequence of events that leads to
this bug.  I also don't understand the bit about the 0x18 offset.

struct iptable_nat_pernet {
        struct nf_hook_ops *nf_nat_ops;
};

... so where would 0x18 come from?

If this is AI generated, please don't do that :-|

> 2. Proposed Fix
> The fix involves adding a NULL check for the pointer returned by net_generic(). If it returns NULL, the registration should be aborted with -ENOMEM to prevent the kernel crash.
> 
> 3. Patch
> Diff
> --- a/net/ipv4/netfilter/iptable_nat.c
> +++ b/net/ipv4/netfilter/iptable_nat.c
> @@ -66,6 +66,9 @@ static int ipt_nat_register_lookups(struct net *net)
>  	int i, ret;
>  
>  	xt_nat_net = net_generic(net, iptable_nat_net_id);
> +	if (!xt_nat_net)
> +		return -ENOMEM;
> +

ip6t_nat_register_lookups() needs the same check, assuming this report
is correct.

> 4. Bug Trace Highlights
> KASAN: null-ptr-deref in range [0x0000000000000018-0x000000000000001f]
> RIP: 0010:ipt_nat_register_lookups+0xf6/0x1e0
> Code: 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 
> Call Trace:
>  <TASK>
>  xt_find_table_lock+0x20a/0x2f0 home/wmy/Fuzzer/third_tool/linux-6.7-defconfig/net/netfilter/x_tables.c:1259
>  xt_request_find_table_lock+0x2b/0xc0 home/wmy/Fuzzer/third_tool/linux-6.7-defconfig/net/netfilter/x_tables.c:1284
>  get_info+0xec/0x330 home/wmy/Fuzzer/third_tool/linux-6.7-defconfig/net/ipv4/netfilter/ip_tables.c:963
>  do_ipt_get_ctl+0x134/0xa60 home/wmy/Fuzzer/third_tool/linux-6.7-defconfig/net/ipv4/netfilter/ip_tables.c:1651
>  nf_getsockopt+0x6a/0xa0 home/wmy/Fuzzer/third_tool/linux-6.7-defconfig/net/netfilter/nf_sockopt.c:116
>  ip_getsockopt+0x190/0x1f0 home/wmy/Fuzzer/third_tool/linux-6.7-defconfig/net/ipv4/ip_sockglue.c:1781
>  tcp_getsockopt+0x7f/0xd0 home/wmy/Fuzzer/third_tool/linux-6.7-defconfig/net/ipv4/tcp.c:4340
>  do_sock_getsockopt+0x20b/0x280 home/wmy/Fuzzer/third_tool/linux-6.7-defconfig/net/socket.c:2377
>  __sys_getsockopt+0x115/0x1b0 home/wmy/Fuzzer/third_tool/linux-6.7-defconfig/net/socket.c:2406
>  __do_sys_getsockopt home/wmy/Fuzzer/third_tool/linux-6.7-defconfig/net/socket.c:2416 [inline]
>  __se_sys_getsockopt home/wmy/Fuzzer/third_tool/linux-6.7-defconfig/net/socket.c:2413 [inline]
>  __x64_sys_getsockopt+0x64/0x80 home/wmy/Fuzzer/third_tool/linux-6.7-defconfig/net/socket.c:2413
>  do_syscall_x64 home/wmy/Fuzzer/third_tool/linux-6.7-defconfig/arch/x86/entry/common.c:51 [inline]
>  do_syscall_64+0x46/0xf0 home/wmy/Fuzzer/third_tool/linux-6.7-defconfig/arch/x86/entry/common.c:82
>  entry_SYSCALL_64_after_hwframe+0x6f/0x77
>  </TASK>

Please describe the sequence of events that lead to this bug.

1. xt_find_table_lock() found the nat table in xt_templates[] list.
2. BUT iptable_nat_init calls xt_register_template() AFTER
   register_pernet_subsys() returns; not before.

How does xt_find_table_lock() observe the nat table but the associated
net generic slot is NULL?

Under what condition will register_pernet_subsys() return 0 but leave
net->gen->ptr[iptable_nat_net_id] == NULL?

5830aa863981 ("netfilter: iptables: Fix null-ptr-deref in iptable_nat_table_init().")
changed the ordering to avoid this exact problem, so I wonder what
was missing.
