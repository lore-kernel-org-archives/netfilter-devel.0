Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3835829CE8;
	Thu,  7 Nov 2024 12:00:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730980822; cv=none; b=U9iVqFrV4ndUKu9u6ZG7Y91KngEguxanC6wnYo55QpYil3jH+8KumWe61W/W0XKGvMKutqoT40xwXf0a9hZarzdncFyYa0lfm67uo240EvMe848YlLSHpHpC6N25Sig5SKk/3ozJqKfEHaXRh+6yFZrtgjzfUy6OxJ2mWWO91/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730980822; c=relaxed/simple;
	bh=kMlZNNjGdqNjNmWbRWRq6OA7ugoN85rBSVa5GoQGYj4=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=mr/8X7aSq5ESji+lesXR6N7kUEGyta+L0UrC8Ez2xW7qi2xYcTz9FqEA2ueCCXPU/2RXP2t7ZMj5c+pN9x65HgWZyqprucPMC5/Ig5h56SVsTSIvRFnhHumE80USLmlLz7vIpulRBVm3Dh8eTFPQX9y0pc731qrIUZpL2Fzzlv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PUq3GjPC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PUq3GjPC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C472EC4CECC;
	Thu,  7 Nov 2024 12:00:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730980821;
	bh=kMlZNNjGdqNjNmWbRWRq6OA7ugoN85rBSVa5GoQGYj4=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=PUq3GjPCOsb5FeCJBLpL05zUpyV4Rl8R9J210w1x6SEV5ZyHIviTJox2/g8ESEDhO
	 cfs0HM4wWJYxhYKmpC5wiHqoL9tZ7eoy3CjqiAEGZzW4SL18fL3lLQPCQ+oWqf2/1I
	 Dfaz2sPXaHKHkmB1cyUeLJNJAmpQhi2ksMsfDqyeMv/nkud2QLySXNTxnG1iDVkQ/m
	 RhKEvEWwLrhWZdcKKPeMFMRNoGM0+Tv9RHRAANCRQrUxqvNeG8n4vJOCNn1SRkExWG
	 JUOGvx1/1wCmhKY5vX+Aa8+nd0tvKCeS6PJhy2d/qsBs/96kOg3/T0W2X1CKRciYfr
	 Xls1YLi9cCchQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 3429B3809A80;
	Thu,  7 Nov 2024 12:00:32 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 01/11] netfilter: Make legacy configs user selectable
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <173098083100.1632973.8651936222963627218.git-patchwork-notify@kernel.org>
Date: Thu, 07 Nov 2024 12:00:31 +0000
References: <20241106234625.168468-2-pablo@netfilter.org>
In-Reply-To: <20241106234625.168468-2-pablo@netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 edumazet@google.com, fw@strlen.de

Hello:

This series was applied to netdev/net-next.git (main)
by Pablo Neira Ayuso <pablo@netfilter.org>:

On Thu,  7 Nov 2024 00:46:15 +0100 you wrote:
> From: Breno Leitao <leitao@debian.org>
> 
> This option makes legacy Netfilter Kconfig user selectable, giving users
> the option to configure iptables without enabling any other config.
> 
> Make the following KConfig entries user selectable:
>  * BRIDGE_NF_EBTABLES_LEGACY
>  * IP_NF_ARPTABLES
>  * IP_NF_IPTABLES_LEGACY
>  * IP6_NF_IPTABLES_LEGACY
> 
> [...]

Here is the summary with links:
  - [net-next,01/11] netfilter: Make legacy configs user selectable
    https://git.kernel.org/netdev/net-next/c/6c959fd5e173
  - [net-next,02/11] netfilter: nf_tables: Fix percpu address space issues in nf_tables_api.c
    https://git.kernel.org/netdev/net-next/c/0741f5559354
  - [net-next,03/11] netfilter: nf_tables: replace deprecated strncpy with strscpy_pad
    https://git.kernel.org/netdev/net-next/c/544dded8cb63
  - [net-next,04/11] netfilter: nf_tables: prefer nft_trans_elem_alloc helper
    https://git.kernel.org/netdev/net-next/c/08e52cccae11
  - [net-next,05/11] netfilter: nf_tables: avoid false-positive lockdep splat on rule deletion
    https://git.kernel.org/netdev/net-next/c/9adbb4198bf6
  - [net-next,06/11] netfilter: nf_tables: avoid false-positive lockdep splats with sets
    https://git.kernel.org/netdev/net-next/c/8f5f3786dba7
  - [net-next,07/11] netfilter: nf_tables: avoid false-positive lockdep splats with flowtables
    https://git.kernel.org/netdev/net-next/c/b3e8f29d6b45
  - [net-next,08/11] netfilter: nf_tables: avoid false-positive lockdep splats in set walker
    https://git.kernel.org/netdev/net-next/c/28b7a6b84c0a
  - [net-next,09/11] netfilter: nf_tables: avoid false-positive lockdep splats with basechain hook
    https://git.kernel.org/netdev/net-next/c/3567146b94af
  - [net-next,10/11] netfilter: nf_tables: must hold rcu read lock while iterating expression type list
    https://git.kernel.org/netdev/net-next/c/ee666a541ed9
  - [net-next,11/11] netfilter: nf_tables: must hold rcu read lock while iterating object type list
    https://git.kernel.org/netdev/net-next/c/cddc04275f95

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


