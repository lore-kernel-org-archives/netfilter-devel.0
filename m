Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE5E6374CF;
	Thu, 22 Feb 2024 09:30:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708594228; cv=none; b=qz2aswFD6gDJBmzCjBJ9+DEL1iICqrgOqRCLooS6c8cY0NC8hrZBF6wAdomnZdZNJtBn1Dqfb4VNR65HumlqLZezUTKwBmL/NHsPBFIzZz/HKJPWVpX58eN7aJooa0KZqX7Tt1bed4wnfzUzrlgAIL9H908mY2vxcV+U0jhq1JU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708594228; c=relaxed/simple;
	bh=p+V+MJet+2kldWiWq/3IuJ5/SfiEHjoi9/OOnfUp4aU=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=kVRa+gnWjuVnIXK6E6D4LoNMhgXO98Vlh1tU9oAkYx2yAeTkqVrmi/YbYatA1n7iA2E1FAnBXY1DacJMg0geFTFPuqUWxC2LKN/Z6exX66mcSPiEFHWusHPxkU3ZKfrMCSYgJp7ql/1lKVb0Q9HC/Q/IiRR8Ac70mtP5CDT9esw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jIijsT0D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jIijsT0D"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 59D0FC433C7;
	Thu, 22 Feb 2024 09:30:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1708594227;
	bh=p+V+MJet+2kldWiWq/3IuJ5/SfiEHjoi9/OOnfUp4aU=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=jIijsT0DF2laR/8axLBrYUxiUHktNNP+RCSibCPwngX7SKfUGVzZ86VSLcVljocz0
	 l1A01pFPhLMStcIwyyU8QzCBs5leZRv/iCn9L25DYEf7arIf9gXR0dQhDiQajMvgxf
	 CVuPnfkg1ECUAroCLxwsEDdB1k11ptnjDuqmMRtKBg0uLReom2+BSCqPz1BFEF6bnM
	 rA6Zvy/2NLHXpbY9f4C0DFsZzP011HQ5wQW8sTesPFwSSJdYXYLhAtsmyuYLOmcD+M
	 bdQnQJTV1WVfvZWlhYhtlTQsVW5JGw8ldAJS2dGQzr9orVdCw3ZhblhzRQ04uWwdqj
	 /HzVYR3kMVtOQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 43C96D84BBB;
	Thu, 22 Feb 2024 09:30:27 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/5] netfilter: nf_tables: set dormant flag on hook
 register failure
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <170859422727.22324.12421215387235975352.git-patchwork-notify@kernel.org>
Date: Thu, 22 Feb 2024 09:30:27 +0000
References: <20240222000843.146665-2-pablo@netfilter.org>
In-Reply-To: <20240222000843.146665-2-pablo@netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 edumazet@google.com, fw@strlen.de

Hello:

This series was applied to netdev/net.git (main)
by Pablo Neira Ayuso <pablo@netfilter.org>:

On Thu, 22 Feb 2024 01:08:39 +0100 you wrote:
> From: Florian Westphal <fw@strlen.de>
> 
> We need to set the dormant flag again if we fail to register
> the hooks.
> 
> During memory pressure hook registration can fail and we end up
> with a table marked as active but no registered hooks.
> 
> [...]

Here is the summary with links:
  - [net,1/5] netfilter: nf_tables: set dormant flag on hook register failure
    https://git.kernel.org/netdev/net/c/bccebf647017
  - [net,2/5] netfilter: nft_flow_offload: reset dst in route object after setting up flow
    https://git.kernel.org/netdev/net/c/9e0f0430389b
  - [net,3/5] netfilter: nft_flow_offload: release dst in case direct xmit path is used
    https://git.kernel.org/netdev/net/c/8762785f459b
  - [net,4/5] netfilter: nf_tables: register hooks last when adding new chain/flowtable
    https://git.kernel.org/netdev/net/c/d472e9853d7b
  - [net,5/5] netfilter: nf_tables: use kzalloc for hook allocation
    https://git.kernel.org/netdev/net/c/195e5f88c2e4

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


