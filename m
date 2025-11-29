Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B83C1DED40;
	Sat, 29 Nov 2025 04:23:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764390215; cv=none; b=SdBQeiV3jqRsb/tW4mWGp0m5g0vVNEf/7wt9j6Zx4e2X+wNnTS7vEJGOU7g6fhknC21JsOGrrvywidEzkbdrgbeS//uCOZWkCY6PEeQNt5JUapI9ljjI/a6+Pc3twBOqfUXdd62udBU/HEH6Ibqx5ZYQwbR/TB+SzpzThdR6LTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764390215; c=relaxed/simple;
	bh=9Lb6Q6a6ZbFUilIGtODLpDXbVu9ihECtyWZmMDZEaUk=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=FFEMoPdpDIDfXMa5//0+Y4Xo6FqrjYCazEQDk6CKsF5G+1lwB4gQSr4HJ22/kgJym2mHHc2n0B3KNIgSemYBtZyl8ZHYuY7FDVT9zXQfpP7b1oKJbxWuMhKuAkQ6t8VG1O7XoeGkdwMr8d6A51juD/4jD89Ng61Ta9VizxKhvfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nxQlOGPm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nxQlOGPm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A259C4CEF7;
	Sat, 29 Nov 2025 04:23:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764390215;
	bh=9Lb6Q6a6ZbFUilIGtODLpDXbVu9ihECtyWZmMDZEaUk=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=nxQlOGPmeUOX0MVbvPFrMgk9GPJL8IlXHQLX1BvIa01wkWn5Skw71R8urM06VjJz7
	 H11sZV1fKthrLekmFPcthIAdmbRv7fV1P9J4Qy2TyO/AxwoymPSoGhH24dYfUjNuI/
	 3Vs5OlnEpIj5oMU5wxebFxIxgdSID/RywVJIUr2BI3OPXj3Fbn36D8Oa6pAldtp09I
	 L7Xs2JsSKqsu0/XM3vsvu0W+g0Wvn9ovC1B6dHvy2Bcq4XPK5XMmQqoJhEISp46Q6l
	 dWPzTc6m5n/YLK3V2a4MxRDKWTfkJSBTLfu2hdfyKA5HnCq9QBveB2oP94j0F9zgjR
	 Vn/4lSYsOoszw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id F2C4C380692B;
	Sat, 29 Nov 2025 04:20:37 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 01/17] netfilter: flowtable: check for maximum
 number
 of encapsulations in bridge vlan
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <176439003680.903126.14289643088710062788.git-patchwork-notify@kernel.org>
Date: Sat, 29 Nov 2025 04:20:36 +0000
References: <20251128002345.29378-2-pablo@netfilter.org>
In-Reply-To: <20251128002345.29378-2-pablo@netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 edumazet@google.com, fw@strlen.de, horms@kernel.org

Hello:

This series was applied to netdev/net-next.git (main)
by Pablo Neira Ayuso <pablo@netfilter.org>:

On Fri, 28 Nov 2025 00:23:28 +0000 you wrote:
> Add a sanity check to skip path discovery if the maximum number of
> encapsulation is reached. While at it, check for underflow too.
> 
> Fixes: 26267bf9bb57 ("netfilter: flowtable: bridge vlan hardware offload and switchdev")
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
>  net/netfilter/nft_flow_offload.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)

Here is the summary with links:
  - [net-next,01/17] netfilter: flowtable: check for maximum number of encapsulations in bridge vlan
    https://git.kernel.org/netdev/net-next/c/634f3853cc98
  - [net-next,02/17] netfilter: flowtable: move path discovery infrastructure to its own file
    https://git.kernel.org/netdev/net-next/c/93d7a7ed0734
  - [net-next,03/17] netfilter: flowtable: consolidate xmit path
    https://git.kernel.org/netdev/net-next/c/b5964aac51e0
  - [net-next,04/17] netfilter: flowtable: inline vlan encapsulation in xmit path
    https://git.kernel.org/netdev/net-next/c/c653d5a78f34
  - [net-next,05/17] netfilter: flowtable: inline pppoe encapsulation in xmit path
    https://git.kernel.org/netdev/net-next/c/18d27bed0880
  - [net-next,06/17] netfilter: flowtable: remove hw_ifidx
    https://git.kernel.org/netdev/net-next/c/030feea3097c
  - [net-next,07/17] netfilter: flowtable: use tuple address to calculate next hop
    https://git.kernel.org/netdev/net-next/c/a0d98b641d67
  - [net-next,08/17] netfilter: flowtable: Add IPIP rx sw acceleration
    https://git.kernel.org/netdev/net-next/c/ab427db17885
  - [net-next,09/17] netfilter: flowtable: Add IPIP tx sw acceleration
    https://git.kernel.org/netdev/net-next/c/d30301ba4b07
  - [net-next,10/17] selftests: netfilter: nft_flowtable.sh: Add IPIP flowtable selftest
    https://git.kernel.org/netdev/net-next/c/fe8313316eaf
  - [net-next,11/17] netfilter: nf_conncount: rework API to use sk_buff directly
    https://git.kernel.org/netdev/net-next/c/be102eb6a0e7
  - [net-next,12/17] netfilter: nf_conncount: make nf_conncount_gc_list() to disable BH
    https://git.kernel.org/netdev/net-next/c/c0362b574828
  - [net-next,13/17] netfilter: nft_connlimit: update the count if add was skipped
    https://git.kernel.org/netdev/net-next/c/69894e5b4c5e
  - [net-next,14/17] netfilter: nft_connlimit: add support to object update operation
    https://git.kernel.org/netdev/net-next/c/c4cbe4a4df39
  - [net-next,15/17] selftests: netfilter: nft_flowtable.sh: Add the capability to send IPv6 TCP traffic
    https://git.kernel.org/netdev/net-next/c/c0bd21682aed
  - [net-next,16/17] netfilter: ip6t_srh: fix UAPI kernel-doc comments format
    https://git.kernel.org/netdev/net-next/c/c4f0ab06e1e0
  - [net-next,17/17] netfilter: nf_tables: improve UAPI kernel-doc comments
    https://git.kernel.org/netdev/net-next/c/d3a439e55c19

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


