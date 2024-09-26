Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA2091CA81;
	Thu, 26 Sep 2024 14:00:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727359232; cv=none; b=XBdD77RIslacZIAYho7VcMlUPAWS+o+TzFEKgzhKiT6UFymHT0oNOqGV1FhkrRhKhe525hN/whmc5gGjUKPVvIRIrVTSNGqzImm3wmIWZlQ3lTiiN2FmXNblFC6FbQALRyJleP/n6glkhdc6bRog7wQijZaTycErOTOHs1Ckv8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727359232; c=relaxed/simple;
	bh=BCRp5U5t7Kf4yDdrERs9UeRnOLg2oCvuoL6YchP1C5c=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=tVTtg9mx67HWirwrg7Gwl189hjgQ5RauidhD26iTTXPrCKwqitqT/JY2HrYwr0oZgQoY/K+S2cNkxN3JLJdn+ig1NKHjpvvhN/Ml7wDBwMW7HaZdJf1OIgRMMg8iH8i22MuAO7cxW7g5qVqZP/Ar+9MDi8Z2r1gKwXzHCJu2cRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=E6W0T9/u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="E6W0T9/u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38577C4CEC6;
	Thu, 26 Sep 2024 14:00:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727359232;
	bh=BCRp5U5t7Kf4yDdrERs9UeRnOLg2oCvuoL6YchP1C5c=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=E6W0T9/u977N8jyIJf0bVmL+NoXKQaosJgvuxIutrk4Pr7/fHwNBdFck5z1XnII2b
	 ffUTY+9tlCWtkThf6RRD+ER0Ap+y3ljFaUNm9UGZSAkABkz4E1DZFoc4dR79FKvpnR
	 4fPkxZkY4Z3Cm07GplKZNyxIltmgBuJHJoQjJEjoK1U8Cv3xE/VJ579nYExU+mr8Cj
	 Pp3iu+EkQZ+jDqv9lL2lp1u1pPfirZ2QTJrpFnH8RMYDog80q4BKPgfNaG47qP9pK4
	 CdPaAejaxZOaqIMy1Y5ecBNSdX80m7pzs9zcWPwo9g1oQzxsMHTBjaK0QViIDU2Iqr
	 hJtkA721HwGVQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id EC920380DBF5;
	Thu, 26 Sep 2024 14:00:35 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 01/14] netfilter: nf_nat: don't try nat source port
 reallocation for reverse dir clash
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <172735923478.1264119.9767417416009097828.git-patchwork-notify@kernel.org>
Date: Thu, 26 Sep 2024 14:00:34 +0000
References: <20240926110717.102194-2-pablo@netfilter.org>
In-Reply-To: <20240926110717.102194-2-pablo@netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 edumazet@google.com, fw@strlen.de

Hello:

This series was applied to netdev/net.git (main)
by Pablo Neira Ayuso <pablo@netfilter.org>:

On Thu, 26 Sep 2024 13:07:04 +0200 you wrote:
> From: Florian Westphal <fw@strlen.de>
> 
> A conntrack entry can be inserted to the connection tracking table if there
> is no existing entry with an identical tuple in either direction.
> 
> Example:
> INITIATOR -> NAT/PAT -> RESPONDER
> 
> [...]

Here is the summary with links:
  - [net,01/14] netfilter: nf_nat: don't try nat source port reallocation for reverse dir clash
    https://git.kernel.org/netdev/net/c/d8f84a9bc7c4
  - [net,02/14] netfilter: conntrack: add clash resolution for reverse collisions
    https://git.kernel.org/netdev/net/c/a4e6a1031e77
  - [net,03/14] selftests: netfilter: add reverse-clash resolution test case
    https://git.kernel.org/netdev/net/c/a57856c0bbc2
  - [net,04/14] selftests: netfilter: nft_tproxy.sh: add tcp tests
    https://git.kernel.org/netdev/net/c/7e37e0eacd22
  - [net,05/14] netfilter: ctnetlink: Guard possible unused functions
    https://git.kernel.org/netdev/net/c/2cadd3b17738
  - [net,06/14] docs: tproxy: ignore non-transparent sockets in iptables
    https://git.kernel.org/netdev/net/c/aa758763be6d
  - [net,07/14] netfilter: nf_tables: Keep deleted flowtable hooks until after RCU
    https://git.kernel.org/netdev/net/c/642c89c47541
  - [net,08/14] netfilter: nf_reject: Fix build warning when CONFIG_BRIDGE_NETFILTER=n
    https://git.kernel.org/netdev/net/c/fc56878ca1c2
  - [net,09/14] netfilter: ctnetlink: compile ctnetlink_label_size with CONFIG_NF_CONNTRACK_EVENTS
    https://git.kernel.org/netdev/net/c/e1f1ee0e9ad8
  - [net,10/14] netfilter: nf_tables: use rcu chain hook list iterator from netlink dump path
    https://git.kernel.org/netdev/net/c/4ffcf5ca81c3
  - [net,11/14] netfilter: nf_tables: missing objects with no memcg accounting
    https://git.kernel.org/netdev/net/c/69e687cea79f
  - [net,12/14] netfilter: nfnetlink_queue: remove old clash resolution logic
    https://git.kernel.org/netdev/net/c/8af79d3edb5f
  - [net,13/14] kselftest: add test for nfqueue induced conntrack race
    https://git.kernel.org/netdev/net/c/e306e3739d9a
  - [net,14/14] selftests: netfilter: Avoid hanging ipvs.sh
    https://git.kernel.org/netdev/net/c/fc786304ad98

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


