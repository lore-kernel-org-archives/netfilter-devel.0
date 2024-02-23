Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52EED10A11;
	Fri, 23 Feb 2024 03:20:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708658430; cv=none; b=NvUqpabJ8x5Q9Zhwkg/PxcL7R5rNrkQCAQT1cbckIocRUOWwKF8Z0hIfH1vhUkX/OdFbk9571pz5NW9Lylnp2aOhQOnMpOvzRCx5nIXIIxt4WQse/3QQW4vDWpGNPj9Lu441QwxCJF/m9ei9EM6plVNl/sxcIu3ygiDUxYd3Lp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708658430; c=relaxed/simple;
	bh=2vw8GtchVLrQXFFGhj/djRC7fV0hkU+GsPf/yB/3Nno=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=BP7qZhKMCkhST1WontQ5Hdo4K/j+b2s4D5Fa5OSe1NwW8/g4vXTOkRewnH6dJz2mR5OPIG4O//XqofaHOKgs+xTwyaRbrUURuQRENKxnzfueBSX34mcYyo2vC1bgCmAbKvR/2P43BQhBX204pFuTjN22V+Yu28p6tr/+6yufPNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gGtEbHf3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gGtEbHf3"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 011DBC43399;
	Fri, 23 Feb 2024 03:20:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1708658430;
	bh=2vw8GtchVLrQXFFGhj/djRC7fV0hkU+GsPf/yB/3Nno=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=gGtEbHf3pcWJTRGBOVS2D5lY0a4JTf+lpTW3cQ7Z/XdXkjn/6nH1JXkOf0R01fIqn
	 +CUHB2NiEevxCgiQVdesMVFJn7/Q4WWtjGM1RDUu4w3crpium0tzE+j4peorYYEP1W
	 FOaeKJlAZPmruErj+QrxW21WexMGfntv9dZ9IqcrMSBPeNFTbtrfumdpot5xjF87RO
	 55Cu7FfK4ABy967SxRJR3mW/nkg96m0c5X4Dz3sqcaljj/rd/vm5ITHionFzzLf/Gn
	 ByZLgrnq3YxXzXT+VimfvmCwqPTJLQ02Rdj3fbSIfLowGIF5QnQWYmVjgvM2wMe0Wq
	 SjeEJ8witEL8Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E1F3CD84BB8;
	Fri, 23 Feb 2024 03:20:29 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 01/12] netfilter: expect: Simplify the allocation of
 slab caches in nf_conntrack_expect_init
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <170865842992.21611.7211914750245168540.git-patchwork-notify@kernel.org>
Date: Fri, 23 Feb 2024 03:20:29 +0000
References: <20240221112637.5396-2-fw@strlen.de>
In-Reply-To: <20240221112637.5396-2-fw@strlen.de>
To: Florian Westphal <fw@strlen.de>
Cc: netdev@vger.kernel.org, pabeni@redhat.com, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, netfilter-devel@vger.kernel.org,
 chentao@kylinos.cn

Hello:

This series was applied to netdev/net-next.git (main)
by Florian Westphal <fw@strlen.de>:

On Wed, 21 Feb 2024 12:26:03 +0100 you wrote:
> From: Kunwu Chan <chentao@kylinos.cn>
> 
> Use the new KMEM_CACHE() macro instead of direct kmem_cache_create
> to simplify the creation of SLAB caches.
> 
> Signed-off-by: Kunwu Chan <chentao@kylinos.cn>
> Signed-off-by: Florian Westphal <fw@strlen.de>
> 
> [...]

Here is the summary with links:
  - [net-next,01/12] netfilter: expect: Simplify the allocation of slab caches in nf_conntrack_expect_init
    https://git.kernel.org/netdev/net-next/c/aa23cfe6ab50
  - [net-next,02/12] netfilter: nf_log: consolidate check for NULL logger in lookup function
    https://git.kernel.org/netdev/net-next/c/79578be4d35c
  - [net-next,03/12] netfilter: nf_log: validate nf_logger_find_get()
    https://git.kernel.org/netdev/net-next/c/c47ec2b120b4
  - [net-next,04/12] netfilter: nft_osf: simplify init path
    https://git.kernel.org/netdev/net-next/c/29a280025580
  - [net-next,05/12] netfilter: xtables: fix up kconfig dependencies
    https://git.kernel.org/netdev/net-next/c/749d4ef0868c
  - [net-next,06/12] netfilter: nft_set_pipapo: constify lookup fn args where possible
    https://git.kernel.org/netdev/net-next/c/f04df573faf9
  - [net-next,07/12] netfilter: nft_set_pipapo: do not rely on ZERO_SIZE_PTR
    https://git.kernel.org/netdev/net-next/c/07ace0bbe03b
  - [net-next,08/12] netfilter: nft_set_pipapo: shrink data structures
    https://git.kernel.org/netdev/net-next/c/aac14d516c2b
  - [net-next,09/12] netfilter: nft_set_pipapo: speed up bulk element insertions
    https://git.kernel.org/netdev/net-next/c/9f439bd6ef4f
  - [net-next,10/12] netfilter: nft_set_pipapo: use GFP_KERNEL for insertions
    https://git.kernel.org/netdev/net-next/c/5b651783d80b
  - [net-next,11/12] netfilter: move nf_reinject into nfnetlink_queue modules
    https://git.kernel.org/netdev/net-next/c/3f8019688894
  - [net-next,12/12] netfilter: x_tables: Use unsafe_memcpy() for 0-sized destination
    https://git.kernel.org/netdev/net-next/c/26f4dac11775

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


