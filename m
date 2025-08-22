Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4CF9249EB;
	Fri, 22 Aug 2025 00:30:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755822620; cv=none; b=bezjh5bBjmTkM250N1WfTiDYZnXgdjTvGpVguNSbBapJ0QKV+rAhI/NpZpFZNPo1eP0aZ+Uu7E1t6gkOQzvFGGqy0lV0XKYo+KNq08tt7ED6rLiRusBspz9jWUdfcc0sJf/hBIoOuaIaaXihMbEMHGfuuyxZNf4kPcNY56EpYhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755822620; c=relaxed/simple;
	bh=oCu+21hpHHRslBrIc9JKmXmCaImpZ5fj5kM0iwWiGWM=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=fi+CQOggoINgFuvEDxIJS3h40coAa/sf2Pq13mnypD9uwIuwKOA8GFKnKgXd4jgYgqqe4qxFODSfbi+HCg9hJx4Fb6Ubk+W2AZ3RwHKB53u4OuQsHDhHZgfn9aQrqoukWc4auRiDRMoU0XZgexNfI6qELSRpfMbHuEHIhK9Wz8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kvk0UQ8/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kvk0UQ8/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58AD6C4CEEB;
	Fri, 22 Aug 2025 00:30:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755822620;
	bh=oCu+21hpHHRslBrIc9JKmXmCaImpZ5fj5kM0iwWiGWM=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=kvk0UQ8/hI97OnJtaK61IEwaZgF48NpOXH5+UN/Wo6o/wIABG3Zm721wcOV9+X0hl
	 EeR/DJSydgo/7KLdVkvLolFdB2IgHS4gDc/lOAt6zuKcIxD7mPp2XnaY65nflFBK/w
	 nMEYL57PSZwq8HNYdk9YWapSYpNWtcamRIwt6JZVO5h7tTgSzIyQ9tuHkYhSHcaO9H
	 O4NwtOUf/VQShYixxmxUM1be39PitpRQUP+Yf8JaR9S4EqdAx8HfSLYsXWkvjFVszR
	 rZxa0sqHeuchYZiox+ORrdWWCrDsH3oCQbse96wHQdpiMFIhG5Hxc7FQPCuDyQwa3N
	 wg5U3KP2Dhf2A==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id ADF2B383BF68;
	Fri, 22 Aug 2025 00:30:30 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 1/6] netfilter: ctnetlink: remove refcounting in
 dying list dumping
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <175582262950.1251664.18196776225165187942.git-patchwork-notify@kernel.org>
Date: Fri, 22 Aug 2025 00:30:29 +0000
References: <20250820144738.24250-2-fw@strlen.de>
In-Reply-To: <20250820144738.24250-2-fw@strlen.de>
To: Florian Westphal <fw@strlen.de>
Cc: netdev@vger.kernel.org, pabeni@redhat.com, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, netfilter-devel@vger.kernel.org,
 pablo@netfilter.org

Hello:

This series was applied to netdev/net-next.git (main)
by Florian Westphal <fw@strlen.de>:

On Wed, 20 Aug 2025 16:47:33 +0200 you wrote:
> There is no need to keep the object alive via refcount, use a cookie and
> then use that as the skip hint for dump resumption.
> 
> Unlike the two earlier, similar patches in this file, this is a cleanup
> without intended side effects.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>
> 
> [...]

Here is the summary with links:
  - [net-next,1/6] netfilter: ctnetlink: remove refcounting in dying list dumping
    https://git.kernel.org/netdev/net-next/c/08d07f25fd5e
  - [net-next,2/6] netfilter: nft_set_pipapo_avx2: Drop the comment regarding protection
    https://git.kernel.org/netdev/net-next/c/d11b26402a33
  - [net-next,3/6] netfilter: nft_set_pipapo_avx2: split lookup function in two parts
    https://git.kernel.org/netdev/net-next/c/416e53e39516
  - [net-next,4/6] netfilter: nft_set_pipapo: use avx2 algorithm for insertions too
    https://git.kernel.org/netdev/net-next/c/84c1da7b38d9
  - [net-next,5/6] netfilter: nft_set_pipapo: Store real pointer, adjust later.
    https://git.kernel.org/netdev/net-next/c/6aa67d5706f0
  - [net-next,6/6] netfilter: nft_set_pipapo: Use nested-BH locking for nft_pipapo_scratch
    https://git.kernel.org/netdev/net-next/c/456010c8b99e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


