Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 480063EBF2C;
	Wed, 11 Feb 2026 05:00:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770786025; cv=none; b=tqxUPHJJ5gNDsnbNVDiPC0KYKd+e3COaDJ/0D3TAZnzrC2AYnNOkvr+ibBTFVdrnERpwuuR8JBSA+R0H0VkYE0pJ/XYHDz2NqvR7pOz5sOMEjL42RRi7XoSNnZGFiIboYtloo+sf5JyGSDUal3DCl162jsuzlrg0MYjqned9MuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770786025; c=relaxed/simple;
	bh=xictI2KULnt7DCf7A1EHEUU3ErFAdvM3icWLKZoDHc4=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=kdzVj0XC3b6mJXWaaTzLRkjak/JVT6Nq/JIoNc5ix7tksjDgmUC3P71LYOgqtie5QMRgk3etjRyy1ZCOtRNklXJwugDcC078ohKGe3TcXzeubVWGZQnMDzMe7eV6SzI9nuvSBivTTEFIukHcksJTawXSVXF34SElJw7gBHAevj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nx8S7zPB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nx8S7zPB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4BEFC4CEF7;
	Wed, 11 Feb 2026 05:00:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770786024;
	bh=xictI2KULnt7DCf7A1EHEUU3ErFAdvM3icWLKZoDHc4=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=nx8S7zPB+yckcllYqexSnF75EMvIZ7FPgjzAG4mYi6FZi5wL9EU8zOu97lrrzreUu
	 h1q9MoKqCIU1k8XIjSupx849zJDhpmYOJI41UiNpTO0Buv3uizGfYp9GoowQ+S9tIE
	 /QrBQGi9U/CBxOl1M/9TQPdyPlDWrTbHbPgWeHmTutSWOwyJL2mY+SkVwF4SCLqy6H
	 ehIoVoo5TaXHEGR91fexHbsqJ7mtscYdCKzs1gvX+zA5STEjAuTVIw02wpbEFtZJm4
	 K2GjFFnMWV183w3ywI+b0bOi+uP3Jjd2V7OsNEYq21GV9sJq9W4GssDRY6x270IhNq
	 z9JTUmNdvk0Mw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 0B101380AA50;
	Wed, 11 Feb 2026 05:00:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net-next 01/11] netfilter: nft_set_rbtree: don't gc
 elements on insert
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <177078601958.5556.12670147258887198547.git-patchwork-notify@kernel.org>
Date: Wed, 11 Feb 2026 05:00:19 +0000
References: <20260206153048.17570-2-fw@strlen.de>
In-Reply-To: <20260206153048.17570-2-fw@strlen.de>
To: Florian Westphal <fw@strlen.de>
Cc: netdev@vger.kernel.org, pabeni@redhat.com, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, netfilter-devel@vger.kernel.org,
 pablo@netfilter.org

Hello:

This series was applied to netdev/net-next.git (main)
by Florian Westphal <fw@strlen.de>:

On Fri,  6 Feb 2026 16:30:38 +0100 you wrote:
> During insertion we can queue up expired elements for garbage
> collection.
> 
> In case of later abort, the commit hook will never be called.
> Packet path and 'get' requests will find free'd elements in the
> binary search blob:
> 
> [...]

Here is the summary with links:
  - [v2,net-next,01/11] netfilter: nft_set_rbtree: don't gc elements on insert
    https://git.kernel.org/netdev/net-next/c/35f83a75529a
  - [v2,net-next,02/11] netfilter: nfnetlink_queue: do shared-unconfirmed check before segmentation
    https://git.kernel.org/netdev/net-next/c/207b3ebacb61
  - [v2,net-next,03/11] selftests: netfilter: nft_queue.sh: add udp fraglist gro test case
    https://git.kernel.org/netdev/net-next/c/59ecffa3995e
  - [v2,net-next,04/11] netfilter: flowtable: dedicated slab for flow entry
    https://git.kernel.org/netdev/net-next/c/2a441a9aacaa
  - [v2,net-next,05/11] selftests: netfilter: add IPV6_TUNNEL to config
    https://git.kernel.org/netdev/net-next/c/1d79ae50e310
  - [v2,net-next,06/11] netfilter: nft_set_hash: fix get operation on big endian
    https://git.kernel.org/netdev/net-next/c/2f635adbe264
  - [v2,net-next,07/11] netfilter: nft_counter: fix reset of counters on 32bit archs
    https://git.kernel.org/netdev/net-next/c/1e13f27e0675
  - [v2,net-next,08/11] netfilter: nft_set_rbtree: fix bogus EEXIST with NLM_F_CREATE with null interval
    https://git.kernel.org/netdev/net-next/c/7f9203f41aae
  - [v2,net-next,09/11] netfilter: nft_set_rbtree: check for partial overlaps in anonymous sets
    https://git.kernel.org/netdev/net-next/c/4780ec142cbb
  - [v2,net-next,10/11] netfilter: nft_set_rbtree: validate element belonging to interval
    https://git.kernel.org/netdev/net-next/c/782f2688128e
  - [v2,net-next,11/11] netfilter: nft_set_rbtree: validate open interval overlap
    https://git.kernel.org/netdev/net-next/c/648946966a08

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


