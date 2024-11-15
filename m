Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76508824BD;
	Fri, 15 Nov 2024 22:20:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731709222; cv=none; b=QNLNe0M1f5ryMnlr7D2Cd3u+4ODJYUdHIaUQPVnoH0v1e/dOXDLgLFgG9q39Q20bPM5JirCr9/VPgpsbzwsE1QpbTeaaVP7bfZu871y8nyOBrYW02nsf4c3p6OB1EWoZnCQ4Wq4U1tIeXeIMo+VLGqGEWmQRgcHZUr4djx3k3+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731709222; c=relaxed/simple;
	bh=B+2xRedtL/liNFw5J11WdSIGow4Ng61KZCkJd6ZdxsI=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=tMKaCRV8ZEitmTcH73c5htX9SMxIQiFoDNEAHefvQaAZAXtEIiJ4yu5zO6BlGmddADSBbS3eNKRCzwfhy4eIgozAQ86yyuPp8kFuaNKqrLX11qZBjvwvSEpq2//2Va52VAy4/yYe1ay/UZibT5J1bqF30/TRXgfkX7XGO19ecn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GvQC2ciw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GvQC2ciw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7ACFC4CECF;
	Fri, 15 Nov 2024 22:20:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731709222;
	bh=B+2xRedtL/liNFw5J11WdSIGow4Ng61KZCkJd6ZdxsI=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=GvQC2ciwB6frXDhJqaeRX5j055GFdvN/04YMXfQQMYOx7tsmpPQ4pZotHkhxsZnYv
	 8PiwZve1vgD4GLnVdi7yD1bMPr6NEUfvAy7Q0kzyXu6HI67M2vfTF8sSbi+rh9ClnL
	 2WZELIhQuNrc5aHqvlbargTPBxbEKbe0IRDIPMFAlGbOotFqncWAjBDeVTFQ9FxLgF
	 NPQ2pUdY+60uaTIQtVx7a4XSDKLiz7nu9SKHb4Yko8c2+AWYyQMdOINywHbrHnyBmO
	 GhXmdEAkhBA3KPkV9ok8ETNLJB4XAIM/smLZwxUKfAZgvCzDyFgDjMiIj7JOqbpflY
	 IEGKtMTWPgwng==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id EAFD63809A80;
	Fri, 15 Nov 2024 22:20:33 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 01/14] netfilter: nfnetlink: Report extack policy
 errors for batched ops
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <173170923276.2750070.17765103576205976526.git-patchwork-notify@kernel.org>
Date: Fri, 15 Nov 2024 22:20:32 +0000
References: <20241115133207.8907-2-pablo@netfilter.org>
In-Reply-To: <20241115133207.8907-2-pablo@netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 edumazet@google.com, fw@strlen.de

Hello:

This series was applied to netdev/net-next.git (main)
by Pablo Neira Ayuso <pablo@netfilter.org>:

On Fri, 15 Nov 2024 14:31:54 +0100 you wrote:
> From: Donald Hunter <donald.hunter@gmail.com>
> 
> The nftables batch processing does not currently populate extack with
> policy errors. Fix this by passing extack when parsing batch messages.
> 
> Signed-off-by: Donald Hunter <donald.hunter@gmail.com>
> Reviewed-by: Simon Horman <horms@kernel.org>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> 
> [...]

Here is the summary with links:
  - [net-next,01/14] netfilter: nfnetlink: Report extack policy errors for batched ops
    https://git.kernel.org/netdev/net-next/c/3f5495962824
  - [net-next,02/14] netfilter: bpf: Pass string literal as format argument of request_module()
    https://git.kernel.org/netdev/net-next/c/8340b0056ac7
  - [net-next,03/14] netfilter: nf_tables: add nft_trans_commit_list_add_elem helper
    https://git.kernel.org/netdev/net-next/c/4ee29181216d
  - [net-next,04/14] netfilter: nf_tables: prepare for multiple elements in nft_trans_elem structure
    https://git.kernel.org/netdev/net-next/c/a8ee6b900c14
  - [net-next,05/14] netfilter: nf_tables: prepare nft audit for set element compaction
    https://git.kernel.org/netdev/net-next/c/466c9b3b2a92
  - [net-next,06/14] netfilter: nf_tables: switch trans_elem to real flex array
    https://git.kernel.org/netdev/net-next/c/b0c49466043a
  - [net-next,07/14] netfilter: nf_tables: allocate element update information dynamically
    https://git.kernel.org/netdev/net-next/c/508180850b73
  - [net-next,08/14] netfilter: ipv4: Convert ip_route_me_harder() to dscp_t.
    https://git.kernel.org/netdev/net-next/c/0608746f95b2
  - [net-next,09/14] netfilter: flow_offload: Convert nft_flow_route() to dscp_t.
    https://git.kernel.org/netdev/net-next/c/6f9615a6e686
  - [net-next,10/14] netfilter: rpfilter: Convert rpfilter_mt() to dscp_t.
    https://git.kernel.org/netdev/net-next/c/f694ce6de589
  - [net-next,11/14] netfilter: nft_fib: Convert nft_fib4_eval() to dscp_t.
    https://git.kernel.org/netdev/net-next/c/f12b67cc7d1b
  - [net-next,12/14] netfilter: nf_dup4: Convert nf_dup_ipv4_route() to dscp_t.
    https://git.kernel.org/netdev/net-next/c/f0d839c13ed5
  - [net-next,13/14] netfilter: bitwise: rename some boolean operation functions
    https://git.kernel.org/netdev/net-next/c/a12143e6084c
  - [net-next,14/14] netfilter: bitwise: add support for doing AND, OR and XOR directly
    https://git.kernel.org/netdev/net-next/c/b0ccf4f53d96

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


