Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73CC955C3E;
	Fri, 12 Apr 2024 12:10:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712923831; cv=none; b=D/8YU11rlX50HHysS8QUocPPAU1WWM8S4JFhaMr54zFSiovwZxJ0Uf8LAfJwbodcZvjE99lhlNMWCI9aQkDrzkVpXoCDv0p5sE/0fRSdRgg0Mi3bylPOiFuhtbCS+8gxDRMUWWbkpKLtjGxKxkCKKrpsEA1UJpErJpmOQH4i0kI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712923831; c=relaxed/simple;
	bh=EGC6IOB32v5EgW5psGMt0IUfmPrl5LjT6mKyt6p+rXc=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=tffg141b5h2iH/eb38evDtbisuCfRdA3oaQ/C7Wh8t3bEaXx4otsuWeqUzY5/mR4+ms2XSPUGz5vO4t4Q0xDTL14ir2QbmA/G6n47C/DtA2u34wg2eVZ92OHvGzF0z1zQnWOfFehA7fK22XP5db6XXEM4hPz+8iitXUhopi8Gh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VYzTpDH4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VYzTpDH4"
Received: by smtp.kernel.org (Postfix) with ESMTPS id DC112C2BD11;
	Fri, 12 Apr 2024 12:10:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712923830;
	bh=EGC6IOB32v5EgW5psGMt0IUfmPrl5LjT6mKyt6p+rXc=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=VYzTpDH42f4EFWAZ2/eWTO4ctWHGdcX4V/CzegkwOuiheoohTMDl8JuJFToJuNe1Q
	 60DJix+xQdg3fElqhDGuHOXBbPxr5eRglF0VtBQ9XUYlRfPmgLQAyVVk7R7yBznnk3
	 sXtkfyIv38EJbNnDnqQ3liCc30anRWusz2FDp2JiNTEvyeTl0duzRK9dM46P/TVCFh
	 y8tYsHBb/IQnEfRl3l1qLTvAIOJCt9f3hZyAD7YkbKjS3fC/zDV5qa/84PrrHr6YAn
	 MOQ4ngCzwMLMy7Yx9e+/nZcZZXYh1O7AwOWBdGetsDyLmDcN0w8URKyf4QZerenjcz
	 hvIehqbNRnyYQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C8E5AC32751;
	Fri, 12 Apr 2024 12:10:30 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/7] netfilter: nf_tables: Fix potential data-race in
 __nft_expr_type_get()
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <171292383081.25342.1876215062663485603.git-patchwork-notify@kernel.org>
Date: Fri, 12 Apr 2024 12:10:30 +0000
References: <20240411112900.129414-2-pablo@netfilter.org>
In-Reply-To: <20240411112900.129414-2-pablo@netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 edumazet@google.com, fw@strlen.de

Hello:

This series was applied to netdev/net.git (main)
by Pablo Neira Ayuso <pablo@netfilter.org>:

On Thu, 11 Apr 2024 13:28:54 +0200 you wrote:
> From: Ziyang Xuan <william.xuanziyang@huawei.com>
> 
> nft_unregister_expr() can concurrent with __nft_expr_type_get(),
> and there is not any protection when iterate over nf_tables_expressions
> list in __nft_expr_type_get(). Therefore, there is potential data-race
> of nf_tables_expressions list entry.
> 
> [...]

Here is the summary with links:
  - [net,1/7] netfilter: nf_tables: Fix potential data-race in __nft_expr_type_get()
    https://git.kernel.org/netdev/net/c/f969eb84ce48
  - [net,2/7] netfilter: nf_tables: Fix potential data-race in __nft_obj_type_get()
    https://git.kernel.org/netdev/net/c/d78d867dcea6
  - [net,3/7] netfilter: br_netfilter: skip conntrack input hook for promisc packets
    https://git.kernel.org/netdev/net/c/751de2012eaf
  - [net,4/7] netfilter: nft_set_pipapo: walk over current view on netlink dump
    https://git.kernel.org/netdev/net/c/29b359cf6d95
  - [net,5/7] netfilter: nft_set_pipapo: do not free live element
    https://git.kernel.org/netdev/net/c/3cfc9ec039af
  - [net,6/7] netfilter: flowtable: validate pppoe header
    https://git.kernel.org/netdev/net/c/87b3593bed18
  - [net,7/7] netfilter: flowtable: incorrect pppoe tuple
    https://git.kernel.org/netdev/net/c/6db5dc7b351b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


