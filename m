Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E51F11272C7;
	Wed, 31 Jan 2024 15:20:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706714427; cv=none; b=LkTFYadnl5w092AQpnbsd7jqbJaOl+AIjEqGqF1RmlXsS+DDpTrWDMQVnR+agELIXxE4NYx8PmM33UA62nfSuuhf4yeWsfeDQQAePOlQCB+qStRr1XPdbHpdmpa2hk/WcEK73Vx51QkNPfUpErfubQbkyCEMmh3ytWFa05C5ppI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706714427; c=relaxed/simple;
	bh=VPQwVKLc1ieUZsLBonDIWiKk0HT4ZtNcfZ3v6pz4USY=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=WAc/9ILG9M4V0KCx4FDpDD1E6Vco5F1H0Nd4IXr5g5ixFbRQW4jfiD+xhBPpdQMvKBjwO6lzL9Xz3sB9sBl4lhcCMxgmFfs5KJsBn9IfjUvAuUvmlt6FBpvtvH9e9wXFWM7sA1EDmrNxE1qP0yjbYfb5WrA9H9hjhpE7yI7Aj0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IAKE8oC1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IAKE8oC1"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 50992C43143;
	Wed, 31 Jan 2024 15:20:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706714426;
	bh=VPQwVKLc1ieUZsLBonDIWiKk0HT4ZtNcfZ3v6pz4USY=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=IAKE8oC1usrfAH7ThbDhzdg+KjbEs8FAokMm4B821D1pNB+js7EtmAtdJfNXN8WUV
	 RFl4ZLZI0+7ByyV0FggtOyeq/ausP/PS4KcUvq78gw/Gov0Cnh/BtLuYR2RmvCcum2
	 EYPTx4Pyyfs/ZH0Fd6JE92N3dYMwm5NrN3wkAiBMu1tWHRL2qpCBft5wreqyRXokSt
	 clo3V156T237XfbDrI327zR0ioYVDouGcWOcvv+xM6z4io7l++Pr6NoZ7zqfgvZ25G
	 FOXBGeZfs2pYZBpmLFZ1QyhVj5e8ImE5bc0kcgxYYvDT9qsXCaGGMDhw8epQC5qQiT
	 LGGwx+Ekxl/OQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 3CF8FDC99E6;
	Wed, 31 Jan 2024 15:20:26 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH nf-next 1/9] netfilter: uapi: Document NFT_TABLE_F_OWNER flag
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <170671442624.26040.11285982214401722283.git-patchwork-notify@kernel.org>
Date: Wed, 31 Jan 2024 15:20:26 +0000
References: <20240129145807.8773-2-fw@strlen.de>
In-Reply-To: <20240129145807.8773-2-fw@strlen.de>
To: Florian Westphal <fw@strlen.de>
Cc: netdev@vger.kernel.org, pabeni@redhat.com, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, netfilter-devel@vger.kernel.org,
 phil@nwl.cc

Hello:

This series was applied to netdev/net-next.git (main)
by Florian Westphal <fw@strlen.de>:

On Mon, 29 Jan 2024 15:57:51 +0100 you wrote:
> From: Phil Sutter <phil@nwl.cc>
> 
> Add at least this one-liner describing the obvious.
> 
> Fixes: 6001a930ce03 ("netfilter: nftables: introduce table ownership")
> Signed-off-by: Phil Sutter <phil@nwl.cc>
> Signed-off-by: Florian Westphal <fw@strlen.de>
> 
> [...]

Here is the summary with links:
  - [nf-next,1/9] netfilter: uapi: Document NFT_TABLE_F_OWNER flag
    https://git.kernel.org/netdev/net-next/c/941988af5724
  - [nf-next,2/9] netfilter: nf_tables: Introduce NFT_TABLE_F_PERSIST
    https://git.kernel.org/netdev/net-next/c/da5141bbe0c2
  - [nf-next,3/9] netfilter: nf_tables: Implement table adoption support
    https://git.kernel.org/netdev/net-next/c/31bf508be656
  - [nf-next,4/9] netfilter: nf_tables: pass flags to set backend selection routine
    https://git.kernel.org/netdev/net-next/c/a128885ace60
  - [nf-next,5/9] netfilter: nf_conncount: Use KMEM_CACHE instead of kmem_cache_create()
    https://git.kernel.org/netdev/net-next/c/2ae6e9a03dad
  - [nf-next,6/9] ipvs: Simplify the allocation of ip_vs_conn slab caches
    https://git.kernel.org/netdev/net-next/c/d5f9142fb96d
  - [nf-next,7/9] netfilter: arptables: allow xtables-nft only builds
    https://git.kernel.org/netdev/net-next/c/4654467dc7e1
  - [nf-next,8/9] netfilter: xtables: allow xtables-nft only builds
    https://git.kernel.org/netdev/net-next/c/a9525c7f6219
  - [nf-next,9/9] netfilter: ebtables: allow xtables-nft only builds
    https://git.kernel.org/netdev/net-next/c/7ad269787b66

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


