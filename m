Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DBC980025;
	Mon, 13 May 2024 20:40:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715632833; cv=none; b=EDP7T6GQmzmc4QjJH1detxI/Nh2uSvsyKycr36mlS+HHJ3kV63XHqzcq8l/pLILAzP4hEz5GB4Ukl/22e/eI351rY7u+J33lmOSew2PQOp85HBOVRBojMWTC6TK/5uZOAFl9m6GbhXerLLyDgion2shx7uxO32lubXzTACnw8rs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715632833; c=relaxed/simple;
	bh=nhREZzGfxBPZonTWw41F9AJ1wgiTA8z2Ts1mor1k/e8=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=EV/zU6MCnZQygrHohPp8Tbo65tPL5llzAhdleBIVlfYFjmokgcLmuAo2d8iZtu3Fx1YKBrgKUCYXuST7ZNLgulz4idOrkL2kAHUHYGQ76DWWrkUTNoM/SELVnR8985FB0NfjwahVau5rhoqPjz9Kc50D+fU0o+3DiAeL1DOT/yg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=U1upaMZ3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="U1upaMZ3"
Received: by smtp.kernel.org (Postfix) with ESMTPS id D2FBAC2BD11;
	Mon, 13 May 2024 20:40:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1715632832;
	bh=nhREZzGfxBPZonTWw41F9AJ1wgiTA8z2Ts1mor1k/e8=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=U1upaMZ3tOGXqSs2ecLDfmW7ABEGuAitxpoZuNm/s1Mm8AIM7kHbSM/aZDE6riecm
	 z5bkKmvPrNb+poXuBD/L1jw6QVI/FWcIBvCAB8+borWwhH58vWUupbdI4rY2qvBlNX
	 DVJBnXI0v9zErss0+E/c0sMXzfYFvx6slafTeECuPcraULv96vr3+XAftkoR0HKDEc
	 w/lERvd+hay46ztR5OiyHAlkLf/5niUsQgQy+qeQ51m5WYFYI3G3R9K4/pPmLxJ3PN
	 +fdJ2RHC0Ggx835wAtuv5FJWYZaDUTelDgXO1tSsci0nkjO3exik8oxODmOJLWAPDD
	 ZDOFfv/dQTTKQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C0F7AC433F2;
	Mon, 13 May 2024 20:40:32 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 01/17] netfilter: nf_tables: skip transaction if
 update object is not implemented
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <171563283278.13316.6020125107742527253.git-patchwork-notify@kernel.org>
Date: Mon, 13 May 2024 20:40:32 +0000
References: <20240512161436.168973-2-pablo@netfilter.org>
In-Reply-To: <20240512161436.168973-2-pablo@netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 edumazet@google.com, fw@strlen.de

Hello:

This series was applied to netdev/net-next.git (main)
by Pablo Neira Ayuso <pablo@netfilter.org>:

On Sun, 12 May 2024 18:14:20 +0200 you wrote:
> Turn update into noop as a follow up for:
> 
>   9fedd894b4e1 ("netfilter: nf_tables: fix unexpected EOPNOTSUPP error")
> 
> instead of adding a transaction object which is simply discarded at a
> later stage of the commit protocol.
> 
> [...]

Here is the summary with links:
  - [net-next,01/17] netfilter: nf_tables: skip transaction if update object is not implemented
    https://git.kernel.org/netdev/net-next/c/84b1a0c0140a
  - [net-next,02/17] netfilter: nf_tables: remove NETDEV_CHANGENAME from netdev chain event handler
    https://git.kernel.org/netdev/net-next/c/6e20eef413d5
  - [net-next,03/17] netfilter: conntrack: fix ct-state for ICMPv6 Multicast Router Discovery
    https://git.kernel.org/netdev/net-next/c/4a3540a8bf3c
  - [net-next,04/17] netfilter: conntrack: dccp: try not to drop skb in conntrack
    https://git.kernel.org/netdev/net-next/c/40616789ec46
  - [net-next,05/17] netfilter: use NF_DROP instead of -NF_DROP
    https://git.kernel.org/netdev/net-next/c/8edc27fc4f22
  - [net-next,06/17] netfilter: conntrack: documentation: remove reference to non-existent sysctl
    https://git.kernel.org/netdev/net-next/c/f9a6e7fb521c
  - [net-next,07/17] netfilter: conntrack: remove flowtable early-drop test
    https://git.kernel.org/netdev/net-next/c/119c790a271d
  - [net-next,08/17] netfilter: nft_set_pipapo: move prove_locking helper around
    https://git.kernel.org/netdev/net-next/c/a590f4760922
  - [net-next,09/17] netfilter: nft_set_pipapo: make pipapo_clone helper return NULL
    https://git.kernel.org/netdev/net-next/c/80efd2997fb9
  - [net-next,10/17] netfilter: nft_set_pipapo: prepare destroy function for on-demand clone
    https://git.kernel.org/netdev/net-next/c/8b8a2417558c
  - [net-next,11/17] netfilter: nft_set_pipapo: prepare walk function for on-demand clone
    https://git.kernel.org/netdev/net-next/c/6c108d9bee44
  - [net-next,12/17] netfilter: nft_set_pipapo: merge deactivate helper into caller
    https://git.kernel.org/netdev/net-next/c/c5444786d0ea
  - [net-next,13/17] netfilter: nft_set_pipapo: prepare pipapo_get helper for on-demand clone
    https://git.kernel.org/netdev/net-next/c/a238106703ab
  - [net-next,14/17] netfilter: nft_set_pipapo: move cloning of match info to insert/removal path
    https://git.kernel.org/netdev/net-next/c/3f1d886cc7c3
  - [net-next,15/17] netfilter: nft_set_pipapo: remove dirty flag
    https://git.kernel.org/netdev/net-next/c/532aec7e878b
  - [net-next,16/17] selftests: netfilter: add packetdrill based conntrack tests
    https://git.kernel.org/netdev/net-next/c/a8a388c2aae4
  - [net-next,17/17] netfilter: nf_tables: allow clone callbacks to sleep
    https://git.kernel.org/netdev/net-next/c/fa23e0d4b756

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


