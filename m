Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDA0A142E67;
	Mon, 26 Aug 2024 15:50:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724687428; cv=none; b=qkBIVviKp46AUdvcqYACi44Pp/ZlYcx9AwkMRDs3RTpSdi3rEW/O+SqAmO3rGkq2wFK7fJfmcaftoY3pfPm4y3LVtnMt6hye0xcJ/6Yo0N09wA1PUXt0creiJ+Dai7hwRwliDtOzLABenkHI9s+HgYkOoDW9AsggLph4pNx4lKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724687428; c=relaxed/simple;
	bh=WueF2IHfN6obkFFeiB3uVRWOVxEr/p0ieCD3kJV6UnA=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=h2p+c4Y/s9hmzE4HzWanZn5v3u2DR0f8iYfP0Y40ATsKXynq9cWXkZzRMLEit6AqgEBuPxhyYEYSGRV0E2XcNUkFmCljmxT+qHdYzMFwKvKFZd5+petWCk0RxItuNIp34STEsWVaM90cO7Kpr5F3SPY1RXk2mcDHpRUFwd7WUqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=i6EWTX/L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="i6EWTX/L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6672BC4FF52;
	Mon, 26 Aug 2024 15:50:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724687428;
	bh=WueF2IHfN6obkFFeiB3uVRWOVxEr/p0ieCD3kJV6UnA=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=i6EWTX/LqSLoXGUmpxiqwx2MjOsYe04BHMJeA1QT8aqm5cdtG02fCV9YVuYFG0Oy0
	 YfY3xRuJ4/p0NpOR01ybQ10EXdPHETvxrclYv1YdcL72uPbT/abnrTw5iDqRfFuf+C
	 zp3bctPZTog+q+ozH8omvmjnXbZtnYmTNzhlHQcH+4fDiVEO0ZEHDTrDwRhVmVRXxO
	 URXF8kJ2bqLBMKaPFGQqKzFFLglPai/ZQoURZBJLeFLvra9IgmK1ZStadhEI4B0ahl
	 pAYNeEmJwW1ZntVNJxeF2Q9gW7q2AIYw1cpcayRYCeaT/woyXvHdtJYOAH4bkwrGOo
	 QLv3fvnHsrT4A==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id ADEBE3822D6D;
	Mon, 26 Aug 2024 15:50:29 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 1/9] netfilter: nfnetlink_queue: unbreak SCTP traffic
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <172468742851.50278.6245777387124477552.git-patchwork-notify@kernel.org>
Date: Mon, 26 Aug 2024 15:50:28 +0000
References: <20240822221939.157858-2-pablo@netfilter.org>
In-Reply-To: <20240822221939.157858-2-pablo@netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 edumazet@google.com, fw@strlen.de

Hello:

This series was applied to netdev/net-next.git (main)
by Pablo Neira Ayuso <pablo@netfilter.org>:

On Fri, 23 Aug 2024 00:19:31 +0200 you wrote:
> From: Antonio Ojea <aojea@google.com>
> 
> when packet is enqueued with nfqueue and GSO is enabled, checksum
> calculation has to take into account the protocol, as SCTP uses a
> 32 bits CRC checksum.
> 
> Enter skb_gso_segment() path in case of SCTP GSO packets because
> skb_zerocopy() does not support for GSO_BY_FRAGS.
> 
> [...]

Here is the summary with links:
  - [net-next,1/9] netfilter: nfnetlink_queue: unbreak SCTP traffic
    https://git.kernel.org/netdev/net-next/c/26a77d02891a
  - [net-next,2/9] selftests: netfilter: nft_queue.sh: sctp coverage
    https://git.kernel.org/netdev/net-next/c/4e97d521c2be
  - [net-next,3/9] netfilter: nfnetlink: convert kfree_skb to consume_skb
    https://git.kernel.org/netdev/net-next/c/e2444c1d4639
  - [net-next,4/9] netfilter: nf_tables: store new sets in dedicated list
    https://git.kernel.org/netdev/net-next/c/c1aa38866b9c
  - [net-next,5/9] netfilter: nf_tables: do not remove elements if set backend implements .abort
    https://git.kernel.org/netdev/net-next/c/c9526aeb4998
  - [net-next,6/9] netfilter: move nf_ct_netns_get out of nf_conncount_init
    https://git.kernel.org/netdev/net-next/c/d5283b47e225
  - [net-next,7/9] netfilter: nf_tables: pass context structure to nft_parse_register_load
    https://git.kernel.org/netdev/net-next/c/7ea0522ef81a
  - [net-next,8/9] netfilter: nf_tables: allow loads only when register is initialized
    https://git.kernel.org/netdev/net-next/c/14fb07130c7d
  - [net-next,9/9] netfilter: nf_tables: don't initialize registers in nft_do_chain()
    https://git.kernel.org/netdev/net-next/c/c88baabf16d1

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


