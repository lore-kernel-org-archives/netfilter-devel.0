Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEC98367294;
	Thu, 27 Aug 2026 20:21:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787862072; cv=none; b=HSPUA1/GKRqdxxoUeCOcG1vHAM8MW+IPPKQMYFX2McHJ5d67CTaXjClk4TzcQh7TKgdafllJOEbBeBr/4X/z42yvTLhRrw5JRyn+vdnKhPFTfp3wGNtjtY9LWZFUn0Ya+252L3LKkV8GYxUdIPd57Ed9N1x2i/AhRwxrhLtGAAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787862072; c=relaxed/simple;
	bh=Hy6k6rtknp1wLepsLUlPrQj6De3LF//lAJAv4AsW/I0=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=kYYwnH52SqVbk6wG4R7IYrj0Cpuk/RJZWRg8GLDLxu4jQRRSCK1az8eOVzcbgUNxU7RcgFQmNu80qDVtxU5AGN1sNY70SapPERK7opvTZwzp6YAgTVVenpNaes+gMB80GFcFiVRb9NpGS+rJY0WvHu6LKlvPfGPTxJIrFZh3Bfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LJGXolVP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LJGXolVP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 321CD1F000E9;
	Thu, 27 Aug 2026 20:21:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787862071;
	bh=B4NewAbYGOMvD6sf8OmhzS8aGOIsOZ5GWtY1xLdv0C0=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=LJGXolVP+P9osXAMyEIVXvGkHe+5lSJ88DyxtdwqA2GEo+7ggCovd66LwnUSxrU93
	 qM1txxxjaM3rx/aKIwBhXk9JI2ZiQ62eyAcoKAidnGLnZzYew9h0fO6bvrDAlAV1Lb
	 WwzjIewM/u6Ksd0rNtsYXA8T+dRCpDoX9dSCnCVuZiwMTLFtABwqp7oqgR9e24g6qd
	 RNfLTNq0FZWJFM9EowC3FfuiPMsMej41qVpUEZPJRrFb8QHsSHjaW1/1wglmf8F035
	 BW1Y6shX6NO5ZLUZUdsc+a3pQb6WP6e6jXAwDBBuRaSfQZFHjM8byg+e6Wl/eEb/Q3
	 +3Zm/UmU3p/1A==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id D0A323809A8D;
	Thu, 27 Aug 2026 20:20:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/9] netfilter: tproxy: use DEBUG_NET_WARN_ON_ONCE for
 protocol fallbacks
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <178786201649.1828680.14620589672296774268.git-patchwork-notify@kernel.org>
Date: Thu, 27 Aug 2026 20:20:16 +0000
References: <20260827141733.423453-2-pablo@netfilter.org>
In-Reply-To: <20260827141733.423453-2-pablo@netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 edumazet@google.com, horms@kernel.org, fw@strlen.de, ja@ssi.bg

Hello:

This series was applied to netdev/net.git (main)
by Pablo Neira Ayuso <pablo@netfilter.org>:

On Thu, 27 Aug 2026 16:17:25 +0200 you wrote:
> From: Fernando Fernandez Mancera <fmancera@suse.de>
> 
> Replace WARN_ON calls with DEBUG_NET_WARN_ON_ONCE in the default switch
> blocks of nf_tproxy_get_sock_v4 and v6. Unsupported transport protocols
> are already safely handled by returning a NULL socket pointer. This
> prevents unnecessary system panics when panic_on_warn=1 is enabled in
> production systems.
> 
> [...]

Here is the summary with links:
  - [net,1/9] netfilter: tproxy: use DEBUG_NET_WARN_ON_ONCE for protocol fallbacks
    https://git.kernel.org/netdev/net/c/1f0391aea883
  - [net,2/9] netfilter: conncount: use DEBUG_NET_WARN_ON_ONCE on reaching count limit
    https://git.kernel.org/netdev/net/c/9b4ab1f3fed8
  - [net,3/9] netfilter: nf_tables: move hardware offload step after building the chain blob
    https://git.kernel.org/netdev/net/c/b1881d362e19
  - [net,4/9] netfilter: nft_set_pipapo_avx2: add missing vzeroupper
    https://git.kernel.org/netdev/net/c/55dd20f0f4b1
  - [net,5/9] netfilter: x_tables: remove pr_debug
    https://git.kernel.org/netdev/net/c/f43358489db4
  - [net,6/9] netfilter: x_tables: replace pr_{info,err}() by pr_info_ratelimited()
    https://git.kernel.org/netdev/net/c/793d9eda4821
  - [net,7/9] netfilter: nf_tables: skip double clone set expressions on element insert
    https://git.kernel.org/netdev/net/c/43559058d21e
  - [net,8/9] netfilter: nf_tables: set on dead bit when performing early element removal
    https://git.kernel.org/netdev/net/c/132a02beb46f
  - [net,9/9] netfilter: nf_tables: remove leftover set_update_list
    https://git.kernel.org/netdev/net/c/fc04229727d8

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


