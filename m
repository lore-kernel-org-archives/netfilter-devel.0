Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2AC92D8386;
	Thu, 17 Jul 2025 12:59:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752757194; cv=none; b=ActNbXOZiIehxttnrHQeb3pW25oTaMENKC8MNVHGWKD7zMRHFgMKt5t7DhOVYWHk/biGnZca3SZ3vEgx566qYswNDX+Xio+t4nuZ6/zTVyMSVhZ48/eQvRhMePS9ivXpY/+x7pEEL6MepD8wRWMW1ivXQ1dQ6y3dYKclBh6tTo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752757194; c=relaxed/simple;
	bh=VFftH6h4HsP0XC6BQKW+4f/pKHAZo41LjhVUrvlvyDE=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=NSt85ROcikccNe3pnOSY+/58wR5aG0fzGGoAkdpe4jkA846GpJONlZe4iD1iBK84y8ZIKbJkLJoEJ1zRMh3FqJOXrvAqELgkkRVrUXO/FCFOGpkJDYpgqRDCiUGKkIv1r20mPN8mzDtrD/YKlkoXr2S3uempddxhEx1FL68salY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=l5bd83GK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="l5bd83GK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4769C4CEEB;
	Thu, 17 Jul 2025 12:59:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752757193;
	bh=VFftH6h4HsP0XC6BQKW+4f/pKHAZo41LjhVUrvlvyDE=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=l5bd83GK2SyLn4gONn00H862EebXnZy2vxF4ZYxVGFhdNisWA6SWRxY8NdMEYZ/Gs
	 fH+aaAk1PaiqIcUFEgkvSYdj39rJSDNey28rEYJWlA0Zks+7gXhq2dic1TKGV/NzTf
	 1vSgTDAXWBduG8z1O92Ept8Grn4e/ZKGsK8kjqr9hpREO3uYwdGcVj/VGBklMQxeH4
	 C4htfXPWHK8PLjil4uB7B33+obEYAGpHmrmbeyyMtcqAFNEzRwEafqiQOvwCn5w9Ps
	 5SkyPuRtU5HiQtJ9LdWK1AHKmsnPPA7tGaoH/opmEXO27frI+wWamLvfQWyTzO8nmM
	 tQ1avwE1QofuQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 33BE8383BF47;
	Thu, 17 Jul 2025 13:00:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/7] selftests: netfilter: conntrack_resize.sh: extend
 resize test
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <175275721401.1927272.84138225536078200.git-patchwork-notify@kernel.org>
Date: Thu, 17 Jul 2025 13:00:14 +0000
References: <20250717095122.32086-2-pablo@netfilter.org>
In-Reply-To: <20250717095122.32086-2-pablo@netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 edumazet@google.com, fw@strlen.de, horms@kernel.org

Hello:

This series was applied to netdev/net.git (main)
by Pablo Neira Ayuso <pablo@netfilter.org>:

On Thu, 17 Jul 2025 11:51:16 +0200 you wrote:
> From: Florian Westphal <fw@strlen.de>
> 
> Extend the resize test:
>  - continuously dump table both via /proc and ctnetlink interfaces while
>    table is resized in a loop.
>  - if socat is available, send udp packets in additon to ping requests.
>  - increase/decrease the icmp and udp timeouts while resizes are happening.
>    This makes sure we also exercise the 'ct has expired' check that happens
>    on conntrack lookup.
> 
> [...]

Here is the summary with links:
  - [net,1/7] selftests: netfilter: conntrack_resize.sh: extend resize test
    https://git.kernel.org/netdev/net/c/b08590559f4b
  - [net,2/7] selftests: netfilter: add conntrack clash resolution test case
    https://git.kernel.org/netdev/net/c/78a588363587
  - [net,3/7] selftests: netfilter: conntrack_resize.sh: also use udpclash tool
    https://git.kernel.org/netdev/net/c/aa085ea1a68d
  - [net,4/7] selftests: netfilter: nft_concat_range.sh: send packets to empty set
    https://git.kernel.org/netdev/net/c/6dc2fae7f8a2
  - [net,5/7] netfilter: nf_tables: hide clash bit from userspace
    https://git.kernel.org/netdev/net/c/6ac86ac74e3a
  - [net,6/7] Revert "netfilter: nf_tables: Add notifications for hook changes"
    https://git.kernel.org/netdev/net/c/36a686c0784f
  - [net,7/7] netfilter: nf_conntrack: fix crash due to removal of uninitialised entry
    https://git.kernel.org/netdev/net/c/2d72afb34065

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


