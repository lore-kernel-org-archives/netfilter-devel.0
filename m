Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45A6123535E;
	Wed, 27 May 2026 01:30:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779845438; cv=none; b=XWrJm9XA5LPYVk73Iwx/+wKyfUEdQohSwY2FMMI4wEcwwjsM2eDGwGTySOppi5TEv+TKHd8p30fIQnXJDh43SoQL/kJs0LMQVitbzWaeQyFkJZ1cI5JSL5LVcwx/Px1oThUirAN0Y/fsPNgSZDGseSDiPuCCjMF2ZP9FHkgwSC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779845438; c=relaxed/simple;
	bh=SBnRUBSRrwS9XB7Rl+DlyoVpd72TrYz1kS2B5xl3LFU=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=gKwyyfABXFsXHvjIM/mqrOSCxUZfObXOzBE8+mcHKCwxz3vPUZTMHD47q1ioObJQOC1KL2T1UJJkD4S61e9llvSYIYz1ihRlIll99j4/xfNjXPtZke4mh54tZRhm8FFseJtua61Gv/sUbXKtN80vjsM93uzvwHhRj27BNuIyBRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SVLDZx1F; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SVLDZx1F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEF791F000E9;
	Wed, 27 May 2026 01:30:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779845436;
	bh=8hwNbtXCRP5dWA4YMWQS1pttUdgZjZymII6OL6ansQY=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=SVLDZx1FeuG0Pelbh9thx3Hk1omBGLo6kAbZPCfW5nE/z5KplhyJjx30VnV7bd3hw
	 HRsgmi593F3+bDTdCExx9a/os7UH7fmm5BOecCyYlP/8Cl9WUfAFsae7OqlwaZ60LA
	 Fx8Y5E/NQd3LjzVfg38Ma8ih6G8WBPN4LK7aohPR/koXYiQNX3aBjshLIeI2HaADhW
	 Gj3T130cqmdRbEZE9jscWIOqKeK+jsZq5yJVQg+314DHI2bf8iGIIGUJHhMwgsV17j
	 kiSK/mT6J/pCFQL9pAWfXqVy+b0621v6E3JkI3GLiyWcJIY2cCRR30M5lQW8rrcbpK
	 5q8vF5HnySFsw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id D0C0A380CEED;
	Wed, 27 May 2026 01:30:43 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 01/11] netfilter: x_tables: disable 32bit compat
 interface in user namespaces
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <177984544239.4041297.5328673538852686069.git-patchwork-notify@kernel.org>
Date: Wed, 27 May 2026 01:30:42 +0000
References: <20260525182924.28456-2-fw@strlen.de>
In-Reply-To: <20260525182924.28456-2-fw@strlen.de>
To: Florian Westphal <fw@strlen.de>
Cc: netdev@vger.kernel.org, pabeni@redhat.com, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, netfilter-devel@vger.kernel.org,
 pablo@netfilter.org

Hello:

This series was applied to netdev/net-next.git (main)
by Florian Westphal <fw@strlen.de>:

On Mon, 25 May 2026 20:29:14 +0200 you wrote:
> This feature is required to use 32bit arp/ip/ip6/ebtables binaries on
> 64bit kernels.  I don't think there are many users left.
> 
> Support has been a compile-time option since 2021 and defaults to off
> since 2023.
> 
> The XTABLES_COMPAT config option is already off in many distributions
> including Debian and Fedora.
> 
> [...]

Here is the summary with links:
  - [net-next,01/11] netfilter: x_tables: disable 32bit compat interface in user namespaces
    https://git.kernel.org/netdev/net-next/c/ec1806a730a1
  - [net-next,02/11] netfilter: add option for GCOV profiling
    https://git.kernel.org/netdev/net-next/c/403cec8ab6d0
  - [net-next,03/11] netfilter: allow nfnetlink built-in only
    https://git.kernel.org/netdev/net-next/c/d4349ba9872d
  - [net-next,04/11] netfilter: nf_conncount: use per-rule hash initval
    https://git.kernel.org/netdev/net-next/c/e9fd2fb09cfe
  - [net-next,05/11] netfilter: ctnetlink: use nf_ct_exp_net() in expectation dump
    https://git.kernel.org/netdev/net-next/c/a7f57320bbbc
  - [net-next,06/11] netfilter: nft_set_rbtree: remove dead conditional
    https://git.kernel.org/netdev/net-next/c/73ce4a2949d9
  - [net-next,07/11] netfilter: nfnl_cthelper: apply per-class values when updating policies
    https://git.kernel.org/netdev/net-next/c/d738feccb98c
  - [net-next,08/11] netfilter: nf_conntrack_irc: fix parse_dcc() off-by-one OOB read
    https://git.kernel.org/netdev/net-next/c/ef6400ca25a1
  - [net-next,09/11] netfilter: nf_conntrack_proto_tcp: fix typos in comments
    https://git.kernel.org/netdev/net-next/c/22fad3d5b135
  - [net-next,10/11] netfilter: nft_set_pipapo_avx2: restore performance optimization
    https://git.kernel.org/netdev/net-next/c/e928ab085d8a
  - [net-next,11/11] netfilter: nf_conntrack_ftp: avoid u16 overflows
    https://git.kernel.org/netdev/net-next/c/2b413fc689ba

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


