Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D90B757E0;
	Mon,  1 Jul 2024 09:00:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719824431; cv=none; b=lJzDIrqqbfJaA4yRQt2W9DUN+AZG0HbBl2zk/IYh9ud/FyvFMLIBYaF/x+Qc8nioRozY494eUiP5FH3r4Cz9G4t6V6+zupWGkK60GWbhVapy8refqvDM0zMW1OmDWrvQBvw1beUn/hMXnBm23bQQThrYvZ9J3HqJLg0ykP/QC3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719824431; c=relaxed/simple;
	bh=2lsvwq81FQ+ZKQLJ9E0WAkmayhyWfEr2c81SPuxNFLc=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=LSnendDrWso2IXg9w7Z8AJnVLWmmpV82Y6E1dXNR9oGRGgc7DLsa+X9OhefsQknfepwM+o/liWo73UrbczhR7WQVONgdhquggUev7JpBE3WPgS3sx/m2qDNkmzoNXPLkvJoICthDLGb88uGlwF40UM2QVqBd4YbvHDGwUZihYGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uwFK+6Nh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uwFK+6Nh"
Received: by smtp.kernel.org (Postfix) with ESMTPS id CFCC6C4AF0E;
	Mon,  1 Jul 2024 09:00:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719824430;
	bh=2lsvwq81FQ+ZKQLJ9E0WAkmayhyWfEr2c81SPuxNFLc=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=uwFK+6NhzKBugUg7E2KfvsbSwWbXxFi7Ih+j6fazMk1+VhqnTp8imKreuB6kW0wiP
	 D7SZfv6vi7BLmFkmXA392ZMWJSkAvkWgiDxTgHJw4VIkT8lV0Gu+zVo5L5Ne/91dGK
	 uXL/YsT8QHgXEzi/LFiAjyRWn2CHmKBjhgY+SJYsMshO5jX521+s2NwOwurmwvUGKF
	 Pl2lReqKzN/eeCkg1LdBl87lZVUt3XkhWi5lXbu3nvDi6enwM9dScM9jpfjJ/kjrlO
	 Pk3l9kTMvfIFj8gAbkbwWXhQ4vsAHunH351o/AASug6S5B1bFxh+7CHILzqbsaCYqw
	 TiJl0vvR8dv3A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id BEC4BDE8E15;
	Mon,  1 Jul 2024 09:00:30 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 01/17] netfilter: nf_tables: make struct nft_trans
 first member of derived subtypes
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <171982443077.24948.16419049555710785067.git-patchwork-notify@kernel.org>
Date: Mon, 01 Jul 2024 09:00:30 +0000
References: <20240628160505.161283-2-pablo@netfilter.org>
In-Reply-To: <20240628160505.161283-2-pablo@netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 edumazet@google.com, fw@strlen.de

Hello:

This series was applied to netdev/net-next.git (main)
by Pablo Neira Ayuso <pablo@netfilter.org>:

On Fri, 28 Jun 2024 18:04:49 +0200 you wrote:
> From: Florian Westphal <fw@strlen.de>
> 
> There is 'struct nft_trans', the basic structure for all transactional
> objects, and the the various different transactional objects, such as
> nft_trans_table, chain, set, set_elem and so on.
> 
> Right now 'struct nft_trans' uses a flexible member at the tail
> (data[]), and casting is needed to access the actual type-specific
> members.
> 
> [...]

Here is the summary with links:
  - [net-next,01/17] netfilter: nf_tables: make struct nft_trans first member of derived subtypes
    https://git.kernel.org/netdev/net-next/c/605efd54b504
  - [net-next,02/17] netfilter: nf_tables: move bind list_head into relevant subtypes
    https://git.kernel.org/netdev/net-next/c/17d8f3ad36a5
  - [net-next,03/17] netfilter: nf_tables: compact chain+ft transaction objects
    https://git.kernel.org/netdev/net-next/c/b3f4c216f7af
  - [net-next,04/17] netfilter: nf_tables: reduce trans->ctx.table references
    https://git.kernel.org/netdev/net-next/c/06fcaca2ed1f
  - [net-next,05/17] netfilter: nf_tables: pass nft_chain to destroy function, not nft_ctx
    https://git.kernel.org/netdev/net-next/c/8965d42bcf54
  - [net-next,06/17] netfilter: nf_tables: pass more specific nft_trans_chain where possible
    https://git.kernel.org/netdev/net-next/c/0c2e0ee861de
  - [net-next,07/17] netfilter: nf_tables: avoid usage of embedded nft_ctx
    https://git.kernel.org/netdev/net-next/c/d4f6f3994e13
  - [net-next,08/17] netfilter: nf_tables: store chain pointer in rule transaction
    https://git.kernel.org/netdev/net-next/c/13f20bc9ec4f
  - [net-next,09/17] netfilter: nf_tables: reduce trans->ctx.chain references
    https://git.kernel.org/netdev/net-next/c/551b3886401c
  - [net-next,10/17] netfilter: nf_tables: pass nft_table to destroy function
    https://git.kernel.org/netdev/net-next/c/0be908750162
  - [net-next,11/17] netfilter: nf_tables: do not store nft_ctx in transaction objects
    https://git.kernel.org/netdev/net-next/c/e169285f8c56
  - [net-next,12/17] ipvs: Avoid unnecessary calls to skb_is_gso_sctp
    https://git.kernel.org/netdev/net-next/c/53796b03295c
  - [net-next,13/17] netfilter: nf_conncount: fix wrong variable type
    https://git.kernel.org/netdev/net-next/c/0b88d1654d55
  - [net-next,14/17] netfilter: cttimeout: remove 'l3num' attr check
    https://git.kernel.org/netdev/net-next/c/fe87a8deaad4
  - [net-next,15/17] netfilter: nf_tables: rise cap on SELinux secmark context
    https://git.kernel.org/netdev/net-next/c/e29630247be2
  - [net-next,16/17] selftests: netfilter: nft_queue.sh: add test for disappearing listener
    https://git.kernel.org/netdev/net-next/c/742ad979f500
  - [net-next,17/17] netfilter: xt_recent: Lift restrictions on max hitcount value
    https://git.kernel.org/netdev/net-next/c/f4ebd03496f6

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


