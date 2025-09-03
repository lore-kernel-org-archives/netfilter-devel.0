Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDC502C0F7E;
	Wed,  3 Sep 2025 23:10:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756941008; cv=none; b=cHfJeBicoq18LAQAn/Rt28a9RVuJ9NQ24c25qEtMcr7CQwAK4LrJKKekNoghPy8zTKfezqpKlSk+hiDVzUMonAgR1XOOlUC4NzXqZeuSOIxcdOQdsYypwzZMrzg3VAu5DcFxB2PGo2nhWqscNXVnicOJThSvo2XfTWn0NDIdqYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756941008; c=relaxed/simple;
	bh=mJtgD4W3yiYMw6XiikmRKJIyF08byUOEB1ix0VSVRvU=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=EmZoFG+VXyeDe7nAQCSHPkF7ktxecuTu25YFygGwcavO+ndQvVquBmOGRyQx2545+sh2zZSxgG1XxE31LRAOpC9gkEX/IlPg1vONjivfV2pvedG34HtonPLP9+Rz8pVwq6Dmi/x3Us1Cp1qWZCd+ecLfmstKkb8ucjn3TAU3YV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uQb4JGFN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uQb4JGFN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6307EC4CEE7;
	Wed,  3 Sep 2025 23:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756941008;
	bh=mJtgD4W3yiYMw6XiikmRKJIyF08byUOEB1ix0VSVRvU=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=uQb4JGFN3GBtshmG4tLWf/OZ2qoiUulT/VbJnIEIMQLl7vJ2ab1eMdxP1dpT3hEp1
	 1bxbk92LG8yLzMyIyv1uXttBcfqYPv6RBaawuEnQbelx7RqB1XdNYV7HUyjM+Mj/93
	 8vhuqrg04SSCuGgoI/iuOU/LY3MSNcxKJ8kPnPdJQxZ1tgMLed+kw8daX40p/Wb4LA
	 BVoi0ytkzAUzJ4DZRfqdEXzxhzL4tquzY1ECl2HvwaBk6ymNQYQbx3+f88Y+mFunlR
	 MfIYB+4hi9D5+GVerTx3kViboJDzjw2zfuKdQ442x4aPH7vrFm+Ct+h93188EDO8dk
	 5QsPOlBbygLaA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id AE07D383C259;
	Wed,  3 Sep 2025 23:10:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net-next 1/7] netfilter: ebtables: Use vmalloc_array()
 to
 improve code
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <175694101351.1231059.5169686861152250158.git-patchwork-notify@kernel.org>
Date: Wed, 03 Sep 2025 23:10:13 +0000
References: <20250902133549.15945-2-fw@strlen.de>
In-Reply-To: <20250902133549.15945-2-fw@strlen.de>
To: Florian Westphal <fw@strlen.de>
Cc: netdev@vger.kernel.org, pabeni@redhat.com, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, netfilter-devel@vger.kernel.org,
 pablo@netfilter.org

Hello:

This series was applied to netdev/net-next.git (main)
by Florian Westphal <fw@strlen.de>:

On Tue,  2 Sep 2025 15:35:43 +0200 you wrote:
> From: Qianfeng Rong <rongqianfeng@vivo.com>
> 
> Remove array_size() calls and replace vmalloc() with vmalloc_array() to
> simplify the code.  vmalloc_array() is also optimized better, uses fewer
> instructions, and handles overflow more concisely[1].
> 
> [1]: https://lore.kernel.org/lkml/abc66ec5-85a4-47e1-9759-2f60ab111971@vivo.com/
> Signed-off-by: Qianfeng Rong <rongqianfeng@vivo.com>
> Signed-off-by: Florian Westphal <fw@strlen.de>
> 
> [...]

Here is the summary with links:
  - [v2,net-next,1/7] netfilter: ebtables: Use vmalloc_array() to improve code
    https://git.kernel.org/netdev/net-next/c/46015e6b3ea7
  - [v2,net-next,2/7] netfilter: nft_payload: Use csum_replace4() instead of opencoding
    https://git.kernel.org/netdev/net-next/c/c015e17ba111
  - [v2,net-next,3/7] netfilter: nf_tables: allow iter callbacks to sleep
    https://git.kernel.org/netdev/net-next/c/a60a5abe19d6
  - [v2,net-next,4/7] netfilter: nf_tables: all transaction allocations can now sleep
    https://git.kernel.org/netdev/net-next/c/3d95a2e016ab
  - [v2,net-next,5/7] netfilter: nft_set_pipapo: remove redundant test for avx feature bit
    https://git.kernel.org/netdev/net-next/c/8959f27d39d6
  - [v2,net-next,6/7] netfilter: nf_reject: remove unneeded exports
    https://git.kernel.org/netdev/net-next/c/f4f9e05904e1
  - [v2,net-next,7/7] netfilter: nft_payload: extend offset to 65535 bytes
    https://git.kernel.org/netdev/net-next/c/077dc4a27579

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


