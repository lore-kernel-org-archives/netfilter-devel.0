Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8EE815E5B0;
	Thu, 18 Apr 2024 11:20:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713439227; cv=none; b=sdm12HgEj+XyvfYNuVuXkO2J9AsE9KCemw4bwu7shsz8VE44ZFnKUzOQY7pcmvIQYZVf+tRhN9a/2lnkkCeVcnmN+Y+KEOh8PBP2lo6bYoFAV+4dfvl6uYYFmdooC9Gv3p9uPM8BIZ2IphzyDymAs907SUsQ+lzj9fh8UQfYVI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713439227; c=relaxed/simple;
	bh=mK+bh3vfgVoq9njLn9DSVemJKPUCQTG16xKzx2RPQms=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=fgCrMsaE8Zp4IGBsOTTi9/LoxrqZBp9XL6dycvwH6FkQKzSHOv0Sdpq2yuQaiql5t5UtsRnYSBv/M+BfEQGPIn60kLo0RtOQAF/bhGbWxYGeHjq9l0DJZrcetp/iXx1+ZajyroXKQd8NJupznqdzj39u+7/G4ci9pw/oXb67fx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=H74+1guu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H74+1guu"
Received: by smtp.kernel.org (Postfix) with ESMTPS id AA489C2BD11;
	Thu, 18 Apr 2024 11:20:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713439227;
	bh=mK+bh3vfgVoq9njLn9DSVemJKPUCQTG16xKzx2RPQms=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=H74+1guuidOVgNknDPokvzDtwfV+E6LhRrhodgZpF1hkIsL/o6OPwlLopPI0wHTvY
	 3uJAIHFgrvp68FNowf88ewtQ9pYTp2WIUwbuNYDS9cHHxncQghe/3k2wTVIW5RXzo5
	 3XF9vuxj/IQurzwpPp2odA2nybMnTbecaSoXDB7bRJ0Gbr/BhGr7ExZYtMoLOuq1r6
	 tmio+8y2rvzKjRzka3cyLjMwLRS4k9jjwsGIycvmVNUURZNDV8jYJVT4v09sRuida0
	 Z9SGYEybnsS4rqg+8b3dDnhyR6lEx+Cc+BsnWtc/nRnbELOlM7ENRJ0jNd3+vv2kOW
	 9V3KXFiy7MZeQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 9A58DC4361B;
	Thu, 18 Apr 2024 11:20:27 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/3] netfilter: nf_tables: missing iterator type in lookup
 walk
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <171343922762.25572.17378961976403355276.git-patchwork-notify@kernel.org>
Date: Thu, 18 Apr 2024 11:20:27 +0000
References: <20240418010948.3332346-2-pablo@netfilter.org>
In-Reply-To: <20240418010948.3332346-2-pablo@netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 edumazet@google.com

Hello:

This series was applied to netdev/net.git (main)
by Pablo Neira Ayuso <pablo@netfilter.org>:

On Thu, 18 Apr 2024 03:09:46 +0200 you wrote:
> Add missing decorator type to lookup expression and tighten WARN_ON_ONCE
> check in pipapo to spot earlier that this is unset.
> 
> Fixes: 29b359cf6d95 ("netfilter: nft_set_pipapo: walk over current view on netlink dump")
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
>  net/netfilter/nft_lookup.c     | 1 +
>  net/netfilter/nft_set_pipapo.c | 3 ++-
>  2 files changed, 3 insertions(+), 1 deletion(-)

Here is the summary with links:
  - [net,1/3] netfilter: nf_tables: missing iterator type in lookup walk
    https://git.kernel.org/netdev/net/c/efefd4f00c96
  - [net,2/3] netfilter: nf_tables: restore set elements when delete set fails
    https://git.kernel.org/netdev/net/c/e79b47a8615d
  - [net,3/3] netfilter: nf_tables: fix memleak in map from abort path
    https://git.kernel.org/netdev/net/c/86a1471d7cde

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


