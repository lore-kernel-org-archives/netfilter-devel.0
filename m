Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E76C7188A0E;
	Mon, 20 Jan 2025 20:10:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737403809; cv=none; b=NUIYPQVLelx+oskjAxz5Y3nnp0tkxg7Yr6hKh7iOmTyuWzk6LYYxQ6ZPXAVWeB63cq2DqzvWwj5TArS24GKDZoyaTmz0ZIYNZ02xAiq01miYtqc+Cvq+F8DJ3U0zkVVQasl0qbVRsxgPd8PqFqEmDRHBXs7Gu18POUlyLMlACbI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737403809; c=relaxed/simple;
	bh=cfLnt++NPYwNNYtP3/HMZ/z1M8zT/QZwu+lKb2XBcmo=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=r1eLCEluuDGYPjq1MSJw6WMgtMgvKo2BrUrmBg6gAIAOpYL6UXKR7wRn37Y1u8Bl4P6nYgP81OqtaaxY7Gkje84s8fnQSl1wKJrPocmHHh4SnuOcjGjDBFluMiBi6KhUvi4OZJ+edNiMnFrjoAjqBnPqTN9tb4j27j029o1zuwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lsixud2D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lsixud2D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47BC4C4CEDD;
	Mon, 20 Jan 2025 20:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737403808;
	bh=cfLnt++NPYwNNYtP3/HMZ/z1M8zT/QZwu+lKb2XBcmo=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=lsixud2Db6TPFlqxHVd7S9USTbDyZKZC7eyNOtpWbASps0BfbfLypKb9MyzKWjyE6
	 hBCgr2JcKvxSnv5YQj9/JkEsNYqPNV18Na/ysOT0KevAMF3YMjpASTcdV2qLF+AQiE
	 ipNLJ3f8zdKNev9izn9CPOTy4N2cE46Pg3LmDnbFMCcngMDPT1ajcfXsf1hHmtnGEF
	 Jkqz8QAgNn5beooZdEH/nW2wGdKmfG1ENd76iUJbzBJLG4ioKlTdw913/om9rHH+JW
	 sd1B4TrzGATTSQ+/uXNl0TVCGLZ6vclUscf+hp+8e3nxNsoUOeBYgw7gYR587kZa4v
	 BRnBihvj59VJw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 711A7380AA62;
	Mon, 20 Jan 2025 20:10:33 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 01/14] netfilter: nf_tables: fix set size with rbtree
 backend
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <173740383227.3638218.4903727390571556542.git-patchwork-notify@kernel.org>
Date: Mon, 20 Jan 2025 20:10:32 +0000
References: <20250119172051.8261-2-pablo@netfilter.org>
In-Reply-To: <20250119172051.8261-2-pablo@netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 edumazet@google.com, fw@strlen.de

Hello:

This series was applied to netdev/net-next.git (main)
by Pablo Neira Ayuso <pablo@netfilter.org>:

On Sun, 19 Jan 2025 18:20:38 +0100 you wrote:
> The existing rbtree implementation uses singleton elements to represent
> ranges, however, userspace provides a set size according to the number
> of ranges in the set.
> 
> Adjust provided userspace set size to the number of singleton elements
> in the kernel by multiplying the range by two.
> 
> [...]

Here is the summary with links:
  - [net-next,01/14] netfilter: nf_tables: fix set size with rbtree backend
    https://git.kernel.org/netdev/net-next/c/8d738c1869f6
  - [net-next,02/14] netfilter: br_netfilter: remove unused conditional and dead code
    https://git.kernel.org/netdev/net-next/c/d01ed3240b22
  - [net-next,03/14] netfilter: nf_tables: Flowtable hook's pf value never varies
    https://git.kernel.org/netdev/net-next/c/2a67414a143e
  - [net-next,04/14] netfilter: nf_tables: Store user-defined hook ifname
    https://git.kernel.org/netdev/net-next/c/b7c2d793c28c
  - [net-next,05/14] netfilter: nf_tables: Use stored ifname in netdev hook dumps
    https://git.kernel.org/netdev/net-next/c/880ccec0d02e
  - [net-next,06/14] netfilter: nf_tables: Compare netdev hooks based on stored name
    https://git.kernel.org/netdev/net-next/c/bc87b75847d8
  - [net-next,07/14] netfilter: nf_tables: Tolerate chains with no remaining hooks
    https://git.kernel.org/netdev/net-next/c/fc0133428e7a
  - [net-next,08/14] netfilter: nf_tables: Simplify chain netdev notifier
    https://git.kernel.org/netdev/net-next/c/375f222800bc
  - [net-next,09/14] netfilter: nft_flow_offload: clear tcp MAXACK flag before moving to slowpath
    https://git.kernel.org/netdev/net-next/c/d9d7b489416d
  - [net-next,10/14] netfilter: nft_flow_offload: update tcp state flags under lock
    https://git.kernel.org/netdev/net-next/c/7a4b61406395
  - [net-next,11/14] netfilter: conntrack: remove skb argument from nf_ct_refresh
    https://git.kernel.org/netdev/net-next/c/31768596b15a
  - [net-next,12/14] netfilter: conntrack: rework offload nf_conn timeout extension logic
    https://git.kernel.org/netdev/net-next/c/03428ca5cee9
  - [net-next,13/14] netfilter: flowtable: teardown flow if cached mtu is stale
    https://git.kernel.org/netdev/net-next/c/b8baac3b9c5c
  - [net-next,14/14] netfilter: flowtable: add CLOSING state
    https://git.kernel.org/netdev/net-next/c/fdbaf5163331

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


