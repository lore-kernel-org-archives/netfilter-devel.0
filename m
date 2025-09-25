Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 646712D7DF6;
	Thu, 25 Sep 2025 00:50:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758761432; cv=none; b=T7I4hqTWx+jncazqPSHZ1ehr55xpgEGLPVALgrQeQFYKNc7bHAesuTY74HKzsYFHCoYRYHdTXqWL72p6A6vH+mZzzkKtYTT30Ma/i3qz1DPUrbezhHZWKJNe3E5Ci8cFrafHEntg+eK8HGlYvRzDid8D1xfxyS0eNvszmiuAENw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758761432; c=relaxed/simple;
	bh=jW8GTZzdIDV1xOgTnZ5qtmNmh8KXvtcpO4RSLSCVNAM=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=bk/myTBVTb4qjZiOzS/O/YGhp2+rR2JwhetcN32gyIaTID82NzJRTT1qF9ghIrscmh57sYqj1lVa/XFdBH+izCm8DSHw2uJ9z0Z4JKFFJFpTmK1Drbby0WY8LqwWzMpSXVz+ThLixKagnThbl4wOY+4aHcCXZ9+qMMXaIevMYgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tCxtvk7p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tCxtvk7p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4408C4CEF0;
	Thu, 25 Sep 2025 00:50:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758761431;
	bh=jW8GTZzdIDV1xOgTnZ5qtmNmh8KXvtcpO4RSLSCVNAM=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=tCxtvk7p3xsEqZCOuQ/mwnoJzjmAQ/kCKhzDR+iKmjRAptN60yxWZOnm7y6jjc8NE
	 2ljAMCqPR6gkh/RoXUMFRrHIGX3uxsCpfp0vIr6ayzh/AmxqNzJuGlgISDHD+7Ok5C
	 H2vYMutZULQuSDIUvauXdaB/AZA3aHZxPu+69RDjJsaBSli8eRO1E3xzO5BFjGySd/
	 wugz47i5rnm6tdNTZ62dpmPwBs0+rEYOu3v3vnU+SOvaQsH3aQYLmIhhkNH4afWG3V
	 ZQsfbIkgZj5W2O0XKMc/7w3/U11gvII7pmsXwzDQ7ms+F2HYWYNR3eSeC7FpZkAIUF
	 ma/zPmqIxtp6A==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 70DAC39D0C20;
	Thu, 25 Sep 2025 00:50:29 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 1/6] ipvs: Defer ip_vs_ftp unregister during
 netns
 cleanup
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <175876142799.2757835.12600541116025822006.git-patchwork-notify@kernel.org>
Date: Thu, 25 Sep 2025 00:50:27 +0000
References: <20250924140654.10210-2-fw@strlen.de>
In-Reply-To: <20250924140654.10210-2-fw@strlen.de>
To: Florian Westphal <fw@strlen.de>
Cc: netdev@vger.kernel.org, pabeni@redhat.com, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, netfilter-devel@vger.kernel.org,
 pablo@netfilter.org

Hello:

This series was applied to netdev/net-next.git (main)
by Florian Westphal <fw@strlen.de>:

On Wed, 24 Sep 2025 16:06:49 +0200 you wrote:
> From: Slavin Liu <slavin452@gmail.com>
> 
> On the netns cleanup path, __ip_vs_ftp_exit() may unregister ip_vs_ftp
> before connections with valid cp->app pointers are flushed, leading to a
> use-after-free.
> 
> Fix this by introducing a global `exiting_module` flag, set to true in
> ip_vs_ftp_exit() before unregistering the pernet subsystem. In
> __ip_vs_ftp_exit(), skip ip_vs_ftp unregister if called during netns
> cleanup (when exiting_module is false) and defer it to
> __ip_vs_cleanup_batch(), which unregisters all apps after all connections
> are flushed. If called during module exit, unregister ip_vs_ftp
> immediately.
> 
> [...]

Here is the summary with links:
  - [net-next,1/6] ipvs: Defer ip_vs_ftp unregister during netns cleanup
    https://git.kernel.org/netdev/net-next/c/134121bfd99a
  - [net-next,2/6] netfilter: nfnetlink: reset nlh pointer during batch replay
    https://git.kernel.org/netdev/net-next/c/09efbac953f6
  - [net-next,3/6] netfilter: nft_set_pipapo: use 0 genmask for packetpath lookups
    https://git.kernel.org/netdev/net-next/c/4dbac7db17f1
  - [net-next,4/6] netfilter: nft_set_pipapo_avx2: fix skip of expired entries
    https://git.kernel.org/netdev/net-next/c/5823699a11cf
  - [net-next,5/6] selftests: netfilter: nft_concat_range.sh: add check for double-create bug
    https://git.kernel.org/netdev/net-next/c/94bd247bc25b
  - [net-next,6/6] netfilter: nf_conntrack: do not skip entries in /proc/net/nf_conntrack
    https://git.kernel.org/netdev/net-next/c/c5ba345b2d35

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


