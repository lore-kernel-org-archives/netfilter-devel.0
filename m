Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792530045;
	b=NMI1H4n6oZYHzXxkUHw5X0+r5pzPmskzRcSyvG1aj0HNID2YoyrYSdS0vXKsNX6Lhecu
	 RaWkIsFWsNolmGcvipPTEaBuTDn+khHkUF1bdcRidmyh3YI29zI/dg8JZx/464zYRLpy6
	 0oK13oMpmJVN/I+3EZ6xrkZe4X7hmy5+EUusuCtUZg5mzn8uyWtaVoLkF019E6f+NQQQ0
	 aL5e3qQaSGD+zHdxglS4Ah3ddkcCs5apiBAmb4RSAoI7zP444xUWW9clPEmxrtkYmPsI+
	 t+Dn+AGjrG5nkGbto9FPRxs+8u5ecEamUr7jK5vuuiV6qcHxzWQqgw51mQclWOZ9t8Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792530045;
	h=Received:DKIM-Signature:Received:Content-Type:MIME-Version:
	 Content-Transfer-Encoding:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc;
	bh=WQmw8JaP3VSFTlCi3DIqvpbvYVlQLx0xSG3G05L6TNA=;
	b=CGbhNXQjgRTTvutGflpt8KgecOiy1F7iZws57ruCQGXtOlAPx/nlLzn2vpE5KlQHVH9c
	 y4OW5mQ94CaxadWVUvsv0zv5UBObQOncsEa3tPftuRrhygJAs8IBgrA4Z0chNMdeQIHx7
	 S9PU90LVhpmv2+gEgWdykADo57Tw6bNarh8leLG5Khg1I4J7zX/ypZGa1n9FT0arWbvWB
	 KmlIMwCyQSSa60dLl+GAlYRpFtvCDgvQdy258mGI2499CzgplolRr/rObVxObsnYaZEVw
	 u1y0CvJeKJpmYC2M6VyjqfXQNXhI8olx11y0LFu/RXiSJD6W4B7hfO6REfrld/moGMA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jzZ+Dg+O;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28A3A606A31A;
	Tue, 20 Oct 2026 21:00:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jzZ+Dg+O
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC7511F000C9;
	Tue, 20 Oct 2026 21:00:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792530044;
	bh=WQmw8JaP3VSFTlCi3DIqvpbvYVlQLx0xSG3G05L6TNA=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=jzZ+Dg+O6hjZ8J8JBRZ0rwHMm+gIBj2rEuiML+0qU9l4sw3Vrkls9y75CSBFbnyAq
	 cKJLuD7row92eRrhVLsNRE5eS+Mq+O54mf1XnAzuEPASt2ezh9PYGR0fTOFs3iYdpZ
	 5xXZ3YWNymIu5qxCgcLEwIFe/fWZ1R5WZOXvKKAbs0cXtqUYJUlPwvYZuvsYQsZcB4
	 3UH1b4UsbjXAqpYmqM+KUNAwuKLldGT3zC/FnC4ebROHaCPxoBw8Rl+N1bCLkxAiZN
	 HNldVBNhVklEt9Xh5Z5kKJEUDalZlG/HWsnR2afkhIzVfeOVdU0smywweBf4Wg5ker
	 UP3EwEzqYXjig==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id B43AC3809A09;
	Tue, 20 Oct 2026 21:00:44 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 01/15] netfilter: disable br_netfilter in user
 namespaces
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <179253004327.208021.16875772320746323664.git-patchwork-notify@kernel.org>
Date: Tue, 20 Oct 2026 21:00:43 +0000
References: <20261018005638.1776148-2-pablo@netfilter.org>
In-Reply-To: <20261018005638.1776148-2-pablo@netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 edumazet@kernel.org, horms@kernel.org, fw@strlen.de, ja@ssi.bg

Hello:

This series was applied to netdev/net-next.git (main)
by Pablo Neira Ayuso <pablo@netfilter.org>:

On Sun, 18 Oct 2026 02:56:24 +0200 you wrote:
> From: Florian Westphal <fw@strlen.de>
> 
> br_netfilter has way too many bugs, schedule for removal and disable
> the feature in user namespaces.
> 
> In particular, we get more and more gadgets to have bridge ports escape
> rcu_read_lock() protection, then underlying device gets reconfigured
> (macvlan or something else), then reinject into network stack causes
> crash because net_device is assumed to still have bridge rx data
> associated with it.
> 
> [...]

Here is the summary with links:
  - [net-next,01/15] netfilter: disable br_netfilter in user namespaces
    https://git.kernel.org/netdev/net-next/c/18e03721933c
  - [net-next,02/15] selftests: netfilter: nft_queue.sh: only queue icmp echo request/reply
    https://git.kernel.org/netdev/net-next/c/99fa01d7d1fe
  - [net-next,03/15] ipvs: fix buffer overflow when sending sync messages
    https://git.kernel.org/netdev/net-next/c/3e3fe49e8678
  - [net-next,04/15] netfilter: nf_queue: limit the hook drop flush to the unregistered hook point
    https://git.kernel.org/netdev/net-next/c/72ac1c0937df
  - [net-next,05/15] selftests: netfilter: nft_queue: check the scope of the hook drop flush
    https://git.kernel.org/netdev/net-next/c/853d419bfb34
  - [net-next,06/15] netfilter: conntrack: fix unlikely UaF in gc worker
    https://git.kernel.org/netdev/net-next/c/9836164821a4
  - [net-next,07/15] netfilter: nf_tables: switch chain_types array to rcu
    https://git.kernel.org/netdev/net-next/c/a3217c51a317
  - [net-next,08/15] netfilter: nft_exthdr: remove redundant op parsing in tcp_set_init
    https://git.kernel.org/netdev/net-next/c/540aab0e415d
  - [net-next,09/15] netfilter: nft_exthdr: avoid 60 bytes stack buffer in TCP option mangling
    https://git.kernel.org/netdev/net-next/c/d7c4b903f349
  - [net-next,10/15] selftests: netfilter: fix return value in zone subtest
    https://git.kernel.org/netdev/net-next/c/a20a01ae8981
  - [net-next,11/15] netfilter: nft_compat: restrict raw table targets/matches
    https://git.kernel.org/netdev/net-next/c/ac364eb4d6d7
  - [net-next,12/15] netfilter: flowtable: set inner protocol when popping tunnel header
    https://git.kernel.org/netdev/net-next/c/cae023143d25
  - [net-next,13/15] netfilter: flowtable: populate tunnel tuple regardless of inner protocol
    https://git.kernel.org/netdev/net-next/c/97874c7c5f2c
  - [net-next,14/15] netfilter: flowtable: add encap_proto to flow_offload_tunnel
    https://git.kernel.org/netdev/net-next/c/3dcafe6cb5e1
  - [net-next,15/15] netfilter: flowtable: unify tunnel push for IPv4 and IPv6
    https://git.kernel.org/netdev/net-next/c/d0107f381622

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


