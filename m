Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1810C1FA4;
	Thu,  4 Jan 2024 02:10:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mJrWaxKI"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 691A6C433C8;
	Thu,  4 Jan 2024 02:10:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704334225;
	bh=PPazzLB1rEZxd54FDz5nDQDpsED9Bs/qUuR9PT+80Nw=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=mJrWaxKIUgaFMCxyn+bwFu3DVdQvn0Ubh19QPdTaUY3epzMVFONYPW5tYBdvn8jUs
	 KDqvBXdkukpWfhOZC3m2PCKdCN/s5KWNNtHi5fLZJuMUTC0oBeuDdrhQ4xz1Y1DZ+l
	 0EsJ9U6x7Wv9UsT/sNgo04lsiaiDTi+nHTTtyn6Bq7DNrSQELHj51bAiEK1f5VLvxC
	 zWZRBYldGHceQuDLU2yvk9RKrp1VlpCKBLNhZ6i/bkQtmOr/ox670fEGue31A7+sc4
	 tifqnlb5tLNSkjOl2Y4Q6wwRb0aYZ1lKFV1e/GevIggCsl2jNr0443YbYYOD7e07rO
	 e+Ml7BXAuhMsg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 4E0B1C395C5;
	Thu,  4 Jan 2024 02:10:25 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/2] netfilter: nf_nat: fix action not being set for all
 ct states
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <170433422531.9915.14111159023443400877.git-patchwork-notify@kernel.org>
Date: Thu, 04 Jan 2024 02:10:25 +0000
References: <20240103113001.137936-2-pablo@netfilter.org>
In-Reply-To: <20240103113001.137936-2-pablo@netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 edumazet@google.com, fw@strlen.de

Hello:

This series was applied to netdev/net.git (main)
by Pablo Neira Ayuso <pablo@netfilter.org>:

On Wed,  3 Jan 2024 12:30:00 +0100 you wrote:
> From: Brad Cowie <brad@faucet.nz>
> 
> This fixes openvswitch's handling of nat packets in the related state.
> 
> In nf_ct_nat_execute(), which is called from nf_ct_nat(), ICMP/ICMPv6
> packets in the IP_CT_RELATED or IP_CT_RELATED_REPLY state, which have
> not been dropped, will follow the goto, however the placement of the
> goto label means that updating the action bit field will be bypassed.
> 
> [...]

Here is the summary with links:
  - [net,1/2] netfilter: nf_nat: fix action not being set for all ct states
    https://git.kernel.org/netdev/net/c/e6345d2824a3
  - [net,2/2] netfilter: nft_immediate: drop chain reference counter on error
    https://git.kernel.org/netdev/net/c/b29be0ca8e81

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


