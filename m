Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EE9F1F9F73;
	Mon, 26 May 2025 17:10:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748279430; cv=none; b=fzQLwQxRXWBJWyDk3ELsQXoqIVDqlvZLLJ5cV2VfUwsjK+U7QHrVVOyzT9Vc//CAVpG/4Sxw9yYlHtzXlhOmc3Ial5nzedepSKoE1ZDnjRmSz1JolvWl/XgDyGqunc4ATFxw07qi6H5YOhKHVT39lSgLJHhuZbpN2WuR6g5jWj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748279430; c=relaxed/simple;
	bh=c56hYC398RkvcabqIe4ipVU6vYAy+sVHiMui9bPlZHk=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=KoU+/aChW5mWC1nWurkGuBABG+Ejqs9CdFrpFzZwQiT0idSoq//4zO1GqxTJV3TkYcgMGLcLZd0rAI4IBmIvU1DhRXDWGR+qYioJSO5sDKtL5h57ukjXWHt8YThTffwu0y5+8MlgaDLOosUpq355utHVPOpMPoGhileRNIyLHz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HC9WtjLm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HC9WtjLm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7975C4CEE7;
	Mon, 26 May 2025 17:10:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748279429;
	bh=c56hYC398RkvcabqIe4ipVU6vYAy+sVHiMui9bPlZHk=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=HC9WtjLmk1xVsMYXBsUthSkKUdVa55bs89QqmmaabcAqt+/PRw3UIvnGp8z8sHs+G
	 jfaPZ5F4h+erzw7hb6RmYkOhIsGHJfH98IB1IRjGjq+izTinPNQNahnNP8V77tBY3y
	 zha2+Ddnvj2h8oQtuLdto1CIkiczU7fRG4pvqGs8V4cvvvNXg5EszAln0HBn9QaooH
	 0PebmMxafsXcnM7qnaG4vpU+6MP4Nn08G1UHV2q8BFmoS/1kxD2k5mFhNMzdJqqewh
	 bdCw4bdVuDJxS+U32COw3FzANDAdme/3qOOr66Y7j86r197rTSNxesBn9ZRW/zffou
	 b82cD1IlJYAMQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 70DE03805D8E;
	Mon, 26 May 2025 17:11:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 01/26] selftests: netfilter: nft_concat_range.sh: add
 coverage for 4bit group representation
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <174827946424.985160.18100606742772677450.git-patchwork-notify@kernel.org>
Date: Mon, 26 May 2025 17:11:04 +0000
References: <20250523132712.458507-2-pablo@netfilter.org>
In-Reply-To: <20250523132712.458507-2-pablo@netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 edumazet@google.com, fw@strlen.de, horms@kernel.org

Hello:

This series was applied to netdev/net-next.git (main)
by Pablo Neira Ayuso <pablo@netfilter.org>:

On Fri, 23 May 2025 15:26:47 +0200 you wrote:
> From: Florian Westphal <fw@strlen.de>
> 
> Pipapo supports a more compact '4 bit group' format that is chosen when
> the memory needed for the default exceeds a threshold (2mb).
> 
> Add coverage for those code paths, the existing tests use small sets that
> are handled by the default representation.
> 
> [...]

Here is the summary with links:
  - [net-next,01/26] selftests: netfilter: nft_concat_range.sh: add coverage for 4bit group representation
    https://git.kernel.org/netdev/net-next/c/d31c1cafc4a7
  - [net-next,02/26] netfilter: xtables: support arpt_mark and ipv6 optstrip for iptables-nft only builds
    https://git.kernel.org/netdev/net-next/c/c38eb2973c18
  - [net-next,03/26] selftests: netfilter: nft_fib.sh: add 'type' mode tests
    https://git.kernel.org/netdev/net-next/c/839340f7c7bb
  - [net-next,04/26] selftests: netfilter: move fib vrf test to nft_fib.sh
    https://git.kernel.org/netdev/net-next/c/98287045c979
  - [net-next,05/26] netfilter: nf_tables: nft_fib_ipv6: fix VRF ipv4/ipv6 result discrepancy
    https://git.kernel.org/netdev/net-next/c/8b53f46eb430
  - [net-next,06/26] netfilter: nf_tables: nft_fib: consistent l3mdev handling
    https://git.kernel.org/netdev/net-next/c/9a119669fb19
  - [net-next,07/26] selftests: netfilter: nft_fib.sh: add type and oif tests with and without VRFs
    https://git.kernel.org/netdev/net-next/c/996d62ece031
  - [net-next,08/26] netfilter: nft_tunnel: fix geneve_opt dump
    https://git.kernel.org/netdev/net-next/c/22a9613de4c2
  - [net-next,09/26] netfilter: nf_dup{4, 6}: Move duplication check to task_struct
    https://git.kernel.org/netdev/net-next/c/a1f1acb9c5db
  - [net-next,10/26] netfilter: nft_inner: Use nested-BH locking for nft_pcpu_tun_ctx
    https://git.kernel.org/netdev/net-next/c/ba36fada9ab4
  - [net-next,11/26] netfilter: nf_dup_netdev: Move the recursion counter struct netdev_xmit
    https://git.kernel.org/netdev/net-next/c/f37ad9127039
  - [net-next,12/26] netfilter: conntrack: make nf_conntrack_id callable without a module dependency
    https://git.kernel.org/netdev/net-next/c/90869f43d06d
  - [net-next,13/26] netfilter: nf_tables: add packets conntrack state to debug trace info
    https://git.kernel.org/netdev/net-next/c/7e5c6aa67e6f
  - [net-next,14/26] netfilter: nf_tables: Introduce functions freeing nft_hook objects
    https://git.kernel.org/netdev/net-next/c/75e20bcdce24
  - [net-next,15/26] netfilter: nf_tables: Introduce nft_hook_find_ops{,_rcu}()
    https://git.kernel.org/netdev/net-next/c/e225376d78fb
  - [net-next,16/26] netfilter: nf_tables: Introduce nft_register_flowtable_ops()
    https://git.kernel.org/netdev/net-next/c/21aa0a03eb53
  - [net-next,17/26] netfilter: nf_tables: Pass nf_hook_ops to nft_unregister_flowtable_hook()
    https://git.kernel.org/netdev/net-next/c/91a089d0569d
  - [net-next,18/26] netfilter: nf_tables: Have a list of nf_hook_ops in nft_hook
    https://git.kernel.org/netdev/net-next/c/73319a8ee18b
  - [net-next,19/26] netfilter: nf_tables: Prepare for handling NETDEV_REGISTER events
    https://git.kernel.org/netdev/net-next/c/104031ac8980
  - [net-next,20/26] netfilter: nf_tables: Respect NETDEV_REGISTER events
    https://git.kernel.org/netdev/net-next/c/a331b78a5525
  - [net-next,21/26] netfilter: nf_tables: Wrap netdev notifiers
    https://git.kernel.org/netdev/net-next/c/9669c1105b16
  - [net-next,22/26] netfilter: nf_tables: Handle NETDEV_CHANGENAME events
    https://git.kernel.org/netdev/net-next/c/7b4856493d78
  - [net-next,23/26] netfilter: nf_tables: Sort labels in nft_netdev_hook_alloc()
    https://git.kernel.org/netdev/net-next/c/6f670935b470
  - [net-next,24/26] netfilter: nf_tables: Support wildcard netdev hook specs
    https://git.kernel.org/netdev/net-next/c/6d07a289504a
  - [net-next,25/26] netfilter: nf_tables: Add notifications for hook changes
    https://git.kernel.org/netdev/net-next/c/465b9ee0ee7b
  - [net-next,26/26] selftests: netfilter: Torture nftables netdev hooks
    https://git.kernel.org/netdev/net-next/c/73db1b5dab6f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


