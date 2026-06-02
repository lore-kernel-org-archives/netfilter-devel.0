Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93F56288C2C;
	Tue,  2 Jun 2026 19:10:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780427420; cv=none; b=lqvCSX+GnZ6cPsISs/Gf8qmnpSQ9YHKJ1niQQ4GznVD25tT0OOz51fvUkP/zFqQ0zHXoWTYKRiSMD/zwRKr79HpZhDEnzUf7rcZ/DIH7uYT+1aTE/NV4xWoKu7fzsJ7h4d9RFojnqlhwQXyo3x/zKZKmIRJHoysxI0DnrtwjIBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780427420; c=relaxed/simple;
	bh=Wxm+ic9/esR2PVwyyETe+0Loc103q2DsCNpRaa9fVNY=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=RybcRMRM6xNT+SRNN2GXRWho/9B4TftKRaNr93MeKD2LxW7KmejffXHPO5UePBOz1Q9g/2caqY/5QtuyP7st/rTQ8rj+h7Krm/5M3j0BTbI+ALzuTN59TpMVY2EzUEO2ehL8O63T3iHBjBJIntw4hhDV7oDcEBKcy7pGvwbDen8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hV+3uf3a; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hV+3uf3a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E3AE1F00893;
	Tue,  2 Jun 2026 19:10:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780427419;
	bh=JtGt++R/f8bgq6fQ3CReSoelNNyd2mwUPWmDDgrIImo=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=hV+3uf3aELKEVBVbvk75S6L4xoSn5MR7u1gR1824C0DkQbJI0+Y1cKVs9vhlV+Kd5
	 RABcY4qL54W9MJyNkGk8Rzxj4j8pKtPMgtf9Ni2HtLNHe4xpTkKSCQiJtwg9fPfzvp
	 Lcxq+38Py5pmULr55ldprN52j7SqOFQHrzfbZ3LLhadh7nWX/G/VLjMbN1IuQfqgKp
	 IeRX0A3NrvY1S6BYA0Lzl7ANTebPSaf5SGI3AJ0Q/ITpvDncD9Ol7QWAPhggYftpkt
	 hK3dtgkoiTlitEHNQQS4gv22fFeGny3pfTBkYey36F6BBAWSaCmm1WYQkPh+BfZitU
	 YOjUtIVTz/Xbg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 568E83811A6C;
	Tue,  2 Jun 2026 19:10:22 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/9] netfilter: xt_NFQUEUE: prefer
 raw_smp_processor_id
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <178042742088.1010994.13923507851088748199.git-patchwork-notify@kernel.org>
Date: Tue, 02 Jun 2026 19:10:20 +0000
References: <20260601115923.433946-2-pablo@netfilter.org>
In-Reply-To: <20260601115923.433946-2-pablo@netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 edumazet@google.com, fw@strlen.de, horms@kernel.org

Hello:

This series was applied to netdev/net.git (main)
by Pablo Neira Ayuso <pablo@netfilter.org>:

On Mon,  1 Jun 2026 13:59:15 +0200 you wrote:
> From: Fernando Fernandez Mancera <fmancera@suse.de>
> 
> With PREEMPT_RCU this triggers a splat because smp_processor_id() can be
> preempted while inside a RCU critical section. If xt_NFQUEUE target is
> invoked via nft_compat_eval() path, we are inside a RCU critical
> section.
> 
> [...]

Here is the summary with links:
  - [net,1/9] netfilter: xt_NFQUEUE: prefer raw_smp_processor_id
    https://git.kernel.org/netdev/net/c/c6c5327dd18b
  - [net,2/9] ipvs: clear the svc scheduler ptr early on edit
    https://git.kernel.org/netdev/net/c/193989cc6d80
  - [net,3/9] netfilter: nft_fib_ipv6: bail out of sibling walk if rt got unlinked
    https://git.kernel.org/netdev/net/c/36d29ceec32c
  - [net,4/9] netfilter: synproxy: add mutex to guard hook reference counting
    https://git.kernel.org/netdev/net/c/2fcba19caaeb
  - [net,5/9] netfilter: conntrack_irc: fix possible out-of-bounds read
    https://git.kernel.org/netdev/net/c/66eba0ffce3b
  - [net,6/9] netfilter: nft_tunnel: fix use-after-free on object destroy
    https://git.kernel.org/netdev/net/c/c32b26aaa2f9
  - [net,7/9] netfilter: nft_ct: bail out on template ct in get eval
    https://git.kernel.org/netdev/net/c/3027ecbdb5fd
  - [net,8/9] netfilter: bridge: make ebt_snat ARP rewrite writable
    https://git.kernel.org/netdev/net/c/67ba971ae025
  - [net,9/9] netfilter: nft_byteorder: remove multi-register support
    https://git.kernel.org/netdev/net/c/bb061d3de417

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


