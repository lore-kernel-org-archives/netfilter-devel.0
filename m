Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8662917A317;
	Fri,  4 Apr 2025 00:19:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743725996; cv=none; b=DRGdIJE+mvZ9brfK4GU8GlAkau8TSmD+PIu36OPayqdS6Q0QP1FVrlkPs1dy+fFx/eHAyr1t7mPWWhSGap/w/ci3GQ4kt6KtvzLsOatCqzQMQshkNR4mbiIY5A5IAIN357kaIBZNXiBoTmXLXuPzR1EO/r7K2lw4GTzXxXZHa+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743725996; c=relaxed/simple;
	bh=+/Ic4+vp4AFTX37HfBOPK7D8KX5wnRymFcm+lBoVFU4=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=BcvORpws+LgZhH1uDMVm+7RsEHrox2Qjw0VZ83g6uJitkTl1CVMea00FlcM7wZV3NpVZ0rs6HlG+Z3kZYt7qqgRGhYIzrugoPH4LDoCG7EBUyKSmBYfAzerhpP8fLEbD+Bba0ypY3NdbnFT4SOEHkRVWz+D+rqEIpTm8Os18zNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oeqTGg6k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oeqTGg6k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06B58C4CEE3;
	Fri,  4 Apr 2025 00:19:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1743725995;
	bh=+/Ic4+vp4AFTX37HfBOPK7D8KX5wnRymFcm+lBoVFU4=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=oeqTGg6kqhActm+2jbD4g5QFov+eWR/e/SHs6QQcVV7uRjxEbIxeXC6pa6nrMUbW6
	 f1p7WAlfviw1vjuQ9GTCiZTwlUZ1dp6m7fTvLZ9+7GQfEK9vEw9yUUNcrgakgU4WWE
	 SyjCFnzPlIPYkI3IWirOhg7gYXftR9azZgSWo7TgPIugWHEFXYcUZ/q88Y1BkEoDQk
	 TAw0gKqqpAMeCuv5FGNKhACzDoUs9gxTaYbP1VUsMKPAdRAaN72XTrGm7CCtCa49Cd
	 GA1wWO7q2KN3eNAmD8V3pvugLNFWyOTK1umkh2XsLKVnvKGNtLrxwtCaESwRIZtE6I
	 23UaBTBkMN3lQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 34FA3380664C;
	Fri,  4 Apr 2025 00:20:33 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/3] netfilter: nft_set_hash: GC reaps elements with
 conncount for dynamic sets only
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <174372603200.2734712.7906268134976015940.git-patchwork-notify@kernel.org>
Date: Fri, 04 Apr 2025 00:20:32 +0000
References: <20250403115752.19608-2-pablo@netfilter.org>
In-Reply-To: <20250403115752.19608-2-pablo@netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 edumazet@google.com, fw@strlen.de, horms@kernel.org

Hello:

This series was applied to netdev/net.git (main)
by Pablo Neira Ayuso <pablo@netfilter.org>:

On Thu,  3 Apr 2025 13:57:50 +0200 you wrote:
> conncount has its own GC handler which determines when to reap stale
> elements, this is convenient for dynamic sets. However, this also reaps
> non-dynamic sets with static configurations coming from control plane.
> Always run connlimit gc handler but honor feedback to reap element if
> this set is dynamic.
> 
> Fixes: 290180e2448c ("netfilter: nf_tables: add connlimit support")
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> 
> [...]

Here is the summary with links:
  - [net,1/3] netfilter: nft_set_hash: GC reaps elements with conncount for dynamic sets only
    https://git.kernel.org/netdev/net/c/9d74da1177c8
  - [net,2/3] netfilter: nf_tables: don't unregister hook when table is dormant
    https://git.kernel.org/netdev/net/c/688c15017d5c
  - [net,3/3] netfilter: nft_tunnel: fix geneve_opt type confusion addition
    https://git.kernel.org/netdev/net/c/1b755d8eb1ac

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


