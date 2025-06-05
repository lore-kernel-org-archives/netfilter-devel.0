Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F74238FB9;
	Thu,  5 Jun 2025 13:20:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749129602; cv=none; b=al1JGIOibN1KuuOzdkC4GR97gkT9OYaH30H1trL7sL7di9pNtX0qnqklA1UGmEotfk8VRKC34atH0aCw3KQENvEXKXDWZ8zEXYSolrNruJhtcTBtt4mPN7wdO7+4UlxYTZXJcs+5DTCN0z69mTGSsQ2TrRH/WD25dFLGsyHyXdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749129602; c=relaxed/simple;
	bh=E7/He3B0xCBq7u7uBhSii0J5lGaeIzae3IWWW9vbH4A=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=fD9iQ6ec9ixtuRISL+aa/TFu7I5QkVA6pvfLl9FLGHrtLcszQadFQgdRbECCCA5egQ1XFdBT5gdk45NZCToSi1Kfmr046qR3nuHtmEZc1ojBp6HqifeAtixnm4p/IyxzrD4kQZbPi4ZTi3t0WkvQBnCD6tY+e+fxcC97eJabhY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=thiiz6VL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="thiiz6VL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1209EC4CEE7;
	Thu,  5 Jun 2025 13:20:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749129602;
	bh=E7/He3B0xCBq7u7uBhSii0J5lGaeIzae3IWWW9vbH4A=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=thiiz6VLQXUAUUEsvo1iW8lQigPltvkQwF/NMOP884IZjr67xHl/mWx8FDS85Mqo4
	 /drmnPgUs94mBAEjMFQuuDm2icSrQnwGEYlJ9A1hKdR+DbU7EArwmnQjK1a/2cUjtb
	 HIeGASLs1Mb0xMZpRuSus4yshlSBb6vR/oniUrmesL5+b2cjs5Rz+29N5kuT1IIsPe
	 +ZoVEZGUPRCRWCgi2LuP6d7fFuc/1bHZv3D1ibfrd/40dwMZs353H0Om+RewhmZBdi
	 9jcNWmFZBY2NpJPp73ukxrJVlofCmhLHC0oKafJsHTLlvd4senUrN9ArWx5opYL2EN
	 c85/ToT+Cn31w==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 33EB238111D8;
	Thu,  5 Jun 2025 13:20:35 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/5] netfilter: nf_set_pipapo_avx2: fix initial map
 fill
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <174912963400.3069926.17729445468849750891.git-patchwork-notify@kernel.org>
Date: Thu, 05 Jun 2025 13:20:34 +0000
References: <20250605085735.52205-2-pablo@netfilter.org>
In-Reply-To: <20250605085735.52205-2-pablo@netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 edumazet@google.com, fw@strlen.de, horms@kernel.org

Hello:

This series was applied to netdev/net.git (main)
by Pablo Neira Ayuso <pablo@netfilter.org>:

On Thu,  5 Jun 2025 10:57:31 +0200 you wrote:
> From: Florian Westphal <fw@strlen.de>
> 
> If the first field doesn't cover the entire start map, then we must zero
> out the remainder, else we leak those bits into the next match round map.
> 
> The early fix was incomplete and did only fix up the generic C
> implementation.
> 
> [...]

Here is the summary with links:
  - [net,1/5] netfilter: nf_set_pipapo_avx2: fix initial map fill
    https://git.kernel.org/netdev/net/c/ea77c397bff8
  - [net,2/5] selftests: netfilter: nft_concat_range.sh: prefer per element counters for testing
    https://git.kernel.org/netdev/net/c/febe7eda74d1
  - [net,3/5] selftests: netfilter: nft_concat_range.sh: add datapath check for map fill bug
    https://git.kernel.org/netdev/net/c/38399f2b0fe4
  - [net,4/5] netfilter: nf_nat: also check reverse tuple to obtain clashing entry
    https://git.kernel.org/netdev/net/c/50d9ce9679dd
  - [net,5/5] selftests: netfilter: nft_nat.sh: add test for reverse clash with nat
    https://git.kernel.org/netdev/net/c/3c3c3248496a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


