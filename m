Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 546531DC198;
	Thu,  5 Dec 2024 11:00:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733396418; cv=none; b=VbMeTuCs4ygo+nG8ZcaQAdvUA7yHbG6HWDkXNYeKpuBV9kpF8sWlwQr41+QftpOWFc5HPMy42nkpGrN6AImj2w9fZCDGSAk5LOMhWDom2SyFMj3jesUerFL/YJeO4WncGnr/XZ75Y9iq5F7dhLkq2pPL/EuF3U4cNL6aSLMHBoA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733396418; c=relaxed/simple;
	bh=zVUEksxV6lsfNmbMbA2clqzcZx3+KejHMgQTLDo6Y88=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=lrmM45gUitNUDq5TwcEK8RVLuT+lLpJmW8oGazkI4T8TOeOwwiXs5D2WT1BzwPloYM5+fMcTwVUbR2sAUY9emWwpWRvnGQTQK1I39ex+TgAJ3uoM1AQO3FYRs81lKueNfP5NuxV0CGs+uPEIY2S3vRQCEEwvA3GUHMTbeAMx56c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Wkb6DbDx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Wkb6DbDx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB0C8C4CED6;
	Thu,  5 Dec 2024 11:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733396417;
	bh=zVUEksxV6lsfNmbMbA2clqzcZx3+KejHMgQTLDo6Y88=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=Wkb6DbDxAsIIYCEpukjBsHZ6v6CgRMyQTdmIZvHsr6xq6/Aw7kImFK/Kr3Jb7wBSU
	 pP0iSroYprYS6v82EVQ02TJsGToUQz/zZrh9kAZ95o0dxeQcgznoKCu4qe5Cma3irp
	 UrOos88ycRfBWpZnIQ2LXRPDytOQ3Sn87scLfC54JwJ6+ZaRBr3CeCQ1vF65LH0lKB
	 5Agv5XuFqMcxv1OkgtvsrtlG/VrejGGGR5d1/JKz0AkqFPDNXe7bqoRU/rmmw00WBy
	 5gh0Vgww2SRDK0jRRYaBn5GGwjTyvo5V2SJaDzYzhJsBukF8C/2qHQg39Pf9HnOMWl
	 5xQam7+1n5cAg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id ADE2F380A94D;
	Thu,  5 Dec 2024 11:00:33 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/6] ipvs: fix UB due to uninitialized stack access in
 ip_vs_protocol_init()
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <173339643252.1549157.5671627566293760631.git-patchwork-notify@kernel.org>
Date: Thu, 05 Dec 2024 11:00:32 +0000
References: <20241205002854.162490-2-pablo@netfilter.org>
In-Reply-To: <20241205002854.162490-2-pablo@netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 edumazet@google.com, fw@strlen.de

Hello:

This series was applied to netdev/net.git (main)
by Pablo Neira Ayuso <pablo@netfilter.org>:

On Thu,  5 Dec 2024 01:28:49 +0100 you wrote:
> From: Jinghao Jia <jinghao7@illinois.edu>
> 
> Under certain kernel configurations when building with Clang/LLVM, the
> compiler does not generate a return or jump as the terminator
> instruction for ip_vs_protocol_init(), triggering the following objtool
> warning during build time:
> 
> [...]

Here is the summary with links:
  - [net,1/6] ipvs: fix UB due to uninitialized stack access in ip_vs_protocol_init()
    https://git.kernel.org/netdev/net/c/146b6f1112eb
  - [net,2/6] netfilter: x_tables: fix LED ID check in led_tg_check()
    https://git.kernel.org/netdev/net/c/04317f4eb2aa
  - [net,3/6] netfilter: nft_socket: remove WARN_ON_ONCE on maximum cgroup level
    https://git.kernel.org/netdev/net/c/b7529880cb96
  - [net,4/6] netfilter: nft_inner: incorrect percpu area handling under softirq
    https://git.kernel.org/netdev/net/c/7b1d83da254b
  - [net,5/6] netfilter: ipset: Hold module reference while requesting a module
    https://git.kernel.org/netdev/net/c/456f010bfaef
  - [net,6/6] netfilter: nft_set_hash: skip duplicated elements pending gc run
    https://git.kernel.org/netdev/net/c/7ffc7481153b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


