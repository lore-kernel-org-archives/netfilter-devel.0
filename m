Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5836860B8A;
	Thu, 19 Sep 2024 11:20:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726744827; cv=none; b=UWp62l7mJGlqf3ew1wTtY21t4CXb2SsbRhUNrsGk96cWnBhWr8lEPCT9eQu5p6mQR1PcGBd3rskBFdSkIfMkm2tG9R8BJ5kKDl9Ag3WTx4R2efrwv8bDCtjuVmTRHfEXp12faF59Swzlm5+At+F7cPvW0Mj807PZLgBdcz/iH7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726744827; c=relaxed/simple;
	bh=n8Ldv+DfjhfaShguwU+j54nHLA4SVTQ/GX3MDlSTt54=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=qhMxU7NuuRpiebaGXQMP1BOrb2jw6Vd2/KVIm82QIvxIlmWtbHT0+C3KJuXSv7Ws/Yo1dI0cobwIH6T6VHi4zjAgvXaO2bj51LijGhTWL0zSXY+GPsNvA46hJic1CT0hkVUfwlW5v5UHC+0BmFpJ1aJfV5G4UmBjuN6Q9NsapzA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Fjqw8V2q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Fjqw8V2q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E58D0C4CEC4;
	Thu, 19 Sep 2024 11:20:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1726744827;
	bh=n8Ldv+DfjhfaShguwU+j54nHLA4SVTQ/GX3MDlSTt54=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=Fjqw8V2qDCtLpC2jfy5KaOWcMp4+LEKr9urPeGtNcNfetDMAWaFMghoeKDD5Q7Hqo
	 ZCY9R0UMBQcFGVpev0NDQe3jzRNC1xAQ3UTT0A0wnVrTEhDWWrF1tP3oeaXjZ+hBuY
	 9+CSiB//i83zkkloSLaz7uM0tlmHmZn9k0u5vAIn2rild6Cpomw8vdo2y6WcsawoQl
	 CxjfzXvx44ChT4mPZyiXOujdCaKecQnLqkYd4qYbeGWJmSAizWZr3O0GT2Dz3L8vVh
	 FCSpqhVKs6KMhn0F4t7oZWt+ZjybWuhKisnUhz0gBianvIJPa1RFHsNgR1ipRE+xZB
	 FE8Yd8iUe0tDw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id EB3963809A80;
	Thu, 19 Sep 2024 11:20:29 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] netfilter: nf_reject_ipv6: fix nf_reject_ip6_tcphdr_put()
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <172674482877.1515218.14271525362714951094.git-patchwork-notify@kernel.org>
Date: Thu, 19 Sep 2024 11:20:28 +0000
References: <20240913170615.3670897-1-edumazet@google.com>
In-Reply-To: <20240913170615.3670897-1-edumazet@google.com>
To: Eric Dumazet <edumazet@google.com>
Cc: davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
 pablo@netfilter.org, kadlec@netfilter.org, netdev@vger.kernel.org,
 netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
 eric.dumazet@gmail.com, syzkaller@googlegroups.com

Hello:

This patch was applied to netdev/net.git (main)
by Paolo Abeni <pabeni@redhat.com>:

On Fri, 13 Sep 2024 17:06:15 +0000 you wrote:
> syzbot reported that nf_reject_ip6_tcphdr_put() was possibly sending
> garbage on the four reserved tcp bits (th->res1)
> 
> Use skb_put_zero() to clear the whole TCP header,
> as done in nf_reject_ip_tcphdr_put()
> 
> BUG: KMSAN: uninit-value in nf_reject_ip6_tcphdr_put+0x688/0x6c0 net/ipv6/netfilter/nf_reject_ipv6.c:255
>   nf_reject_ip6_tcphdr_put+0x688/0x6c0 net/ipv6/netfilter/nf_reject_ipv6.c:255
>   nf_send_reset6+0xd84/0x15b0 net/ipv6/netfilter/nf_reject_ipv6.c:344
>   nft_reject_inet_eval+0x3c1/0x880 net/netfilter/nft_reject_inet.c:48
>   expr_call_ops_eval net/netfilter/nf_tables_core.c:240 [inline]
>   nft_do_chain+0x438/0x22a0 net/netfilter/nf_tables_core.c:288
>   nft_do_chain_inet+0x41a/0x4f0 net/netfilter/nft_chain_filter.c:161
>   nf_hook_entry_hookfn include/linux/netfilter.h:154 [inline]
>   nf_hook_slow+0xf4/0x400 net/netfilter/core.c:626
>   nf_hook include/linux/netfilter.h:269 [inline]
>   NF_HOOK include/linux/netfilter.h:312 [inline]
>   ipv6_rcv+0x29b/0x390 net/ipv6/ip6_input.c:310
>   __netif_receive_skb_one_core net/core/dev.c:5661 [inline]
>   __netif_receive_skb+0x1da/0xa00 net/core/dev.c:5775
>   process_backlog+0x4ad/0xa50 net/core/dev.c:6108
>   __napi_poll+0xe7/0x980 net/core/dev.c:6772
>   napi_poll net/core/dev.c:6841 [inline]
>   net_rx_action+0xa5a/0x19b0 net/core/dev.c:6963
>   handle_softirqs+0x1ce/0x800 kernel/softirq.c:554
>   __do_softirq+0x14/0x1a kernel/softirq.c:588
>   do_softirq+0x9a/0x100 kernel/softirq.c:455
>   __local_bh_enable_ip+0x9f/0xb0 kernel/softirq.c:382
>   local_bh_enable include/linux/bottom_half.h:33 [inline]
>   rcu_read_unlock_bh include/linux/rcupdate.h:908 [inline]
>   __dev_queue_xmit+0x2692/0x5610 net/core/dev.c:4450
>   dev_queue_xmit include/linux/netdevice.h:3105 [inline]
>   neigh_resolve_output+0x9ca/0xae0 net/core/neighbour.c:1565
>   neigh_output include/net/neighbour.h:542 [inline]
>   ip6_finish_output2+0x2347/0x2ba0 net/ipv6/ip6_output.c:141
>   __ip6_finish_output net/ipv6/ip6_output.c:215 [inline]
>   ip6_finish_output+0xbb8/0x14b0 net/ipv6/ip6_output.c:226
>   NF_HOOK_COND include/linux/netfilter.h:303 [inline]
>   ip6_output+0x356/0x620 net/ipv6/ip6_output.c:247
>   dst_output include/net/dst.h:450 [inline]
>   NF_HOOK include/linux/netfilter.h:314 [inline]
>   ip6_xmit+0x1ba6/0x25d0 net/ipv6/ip6_output.c:366
>   inet6_csk_xmit+0x442/0x530 net/ipv6/inet6_connection_sock.c:135
>   __tcp_transmit_skb+0x3b07/0x4880 net/ipv4/tcp_output.c:1466
>   tcp_transmit_skb net/ipv4/tcp_output.c:1484 [inline]
>   tcp_connect+0x35b6/0x7130 net/ipv4/tcp_output.c:4143
>   tcp_v6_connect+0x1bcc/0x1e40 net/ipv6/tcp_ipv6.c:333
>   __inet_stream_connect+0x2ef/0x1730 net/ipv4/af_inet.c:679
>   inet_stream_connect+0x6a/0xd0 net/ipv4/af_inet.c:750
>   __sys_connect_file net/socket.c:2061 [inline]
>   __sys_connect+0x606/0x690 net/socket.c:2078
>   __do_sys_connect net/socket.c:2088 [inline]
>   __se_sys_connect net/socket.c:2085 [inline]
>   __x64_sys_connect+0x91/0xe0 net/socket.c:2085
>   x64_sys_call+0x27a5/0x3ba0 arch/x86/include/generated/asm/syscalls_64.h:43
>   do_syscall_x64 arch/x86/entry/common.c:52 [inline]
>   do_syscall_64+0xcd/0x1e0 arch/x86/entry/common.c:83
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> 
> [...]

Here is the summary with links:
  - [net] netfilter: nf_reject_ipv6: fix nf_reject_ip6_tcphdr_put()
    https://git.kernel.org/netdev/net/c/9c778fe48d20

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


