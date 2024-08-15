Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DF601AC88A;
	Thu, 15 Aug 2024 11:30:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723721433; cv=none; b=fvDQi5aCkPPDy4aXNIwAHGPhCIfbMjHT4BrtRpsW0ZLpB+7ebEv7xMvm5PKnOCjMeO2N1+1XgOME0mKZq7mp9WNe0h+We7zO5h6eRY5qTusEJ58SkrpRe4RjLkfbqkmu1ckiiaGFz4ftJhAjAtPfK9vXYdyPfKJu3+qDuPk87jg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723721433; c=relaxed/simple;
	bh=VXKwRhcRuxEu298WKTNUffaBAZ2wVb1AlEfAAloaUgw=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=SQqsvEfsN/qmUleJgRxroLHkxGhBzvn1+qVnvCaZxrUUb+hO//Kk5iJzJGZP0T1MYMYZK3WJiI73ZEyjD+dKZFJXKbNanYRsDiW+9pfptQ4JQGUbZf/0NbxLQJbrNTd9yxIq+KadEBuEejvVGpodAhn/3SX96kgwgXUUPhob4lw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bGoUdKVW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bGoUdKVW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0BECC32786;
	Thu, 15 Aug 2024 11:30:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723721431;
	bh=VXKwRhcRuxEu298WKTNUffaBAZ2wVb1AlEfAAloaUgw=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=bGoUdKVW4TEfvONLBae7FZBy+q776xblF2IBc99KOlwG8z58sbHz3o8jQkOLE4ld5
	 2f9GNUDOiinlNrkUez5VH505pDj57ofvJXezXj0nIu/zL3H2FlhGGuSuAAqjNsFxkT
	 T6U4LBdbqO7Ouh1xIpnuFjAeLHtGb7+ngTxXnNWB4XdFa3Buic24jKU8GpFQGHLZPc
	 CY7EZCrinZHlFZUPYUJcCS1c+sc7YMxTe5TsmNZcn6mXWS3D0PoAfTG+/PkzDGUwOl
	 VxyrrbzXNxctPy2BKkEhQjBhf6OKTAbOXfeWginQUHvjh+p9+FNn+R6D5wxzVK8Ld2
	 qPUsAIDiJ4TlQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 342CA382327A;
	Thu, 15 Aug 2024 11:30:32 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/8] netfilter: allow ipv6 fragments to arrive on
 different devices
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <172372143101.2826755.5906949342368006907.git-patchwork-notify@kernel.org>
Date: Thu, 15 Aug 2024 11:30:31 +0000
References: <20240814222042.150590-2-pablo@netfilter.org>
In-Reply-To: <20240814222042.150590-2-pablo@netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 edumazet@google.com, fw@strlen.de

Hello:

This series was applied to netdev/net.git (main)
by Pablo Neira Ayuso <pablo@netfilter.org>:

On Thu, 15 Aug 2024 00:20:35 +0200 you wrote:
> From: Tom Hughes <tom@compton.nu>
> 
> Commit 264640fc2c5f4 ("ipv6: distinguish frag queues by device
> for multicast and link-local packets") modified the ipv6 fragment
> reassembly logic to distinguish frag queues by device for multicast
> and link-local packets but in fact only the main reassembly code
> limits the use of the device to those address types and the netfilter
> reassembly code uses the device for all packets.
> 
> [...]

Here is the summary with links:
  - [net,1/8] netfilter: allow ipv6 fragments to arrive on different devices
    https://git.kernel.org/netdev/net/c/3cd740b98596
  - [net,2/8] netfilter: nfnetlink: Initialise extack before use in ACKs
    https://git.kernel.org/netdev/net/c/d1a7b382a9d3
  - [net,3/8] netfilter: flowtable: initialise extack before use
    https://git.kernel.org/netdev/net/c/e9767137308d
  - [net,4/8] netfilter: nf_queue: drop packets with cloned unconfirmed conntracks
    https://git.kernel.org/netdev/net/c/7d8dc1c7be8d
  - [net,5/8] selftests: netfilter: add test for br_netfilter+conntrack+queue combination
    https://git.kernel.org/netdev/net/c/ea2306f0330c
  - [net,6/8] netfilter: nf_tables: Audit log dump reset after the fact
    https://git.kernel.org/netdev/net/c/e0b6648b0446
  - [net,7/8] netfilter: nf_tables: Introduce nf_tables_getobj_single
    https://git.kernel.org/netdev/net/c/69fc3e9e90f1
  - [net,8/8] netfilter: nf_tables: Add locking for NFT_MSG_GETOBJ_RESET requests
    https://git.kernel.org/netdev/net/c/bd662c4218f9

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


