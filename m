Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8827C171B6;
	Thu, 30 May 2024 08:30:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717057831; cv=none; b=XBhLAXJJ5JVgJ3uRLP7FYuRWcxW/e3X5czX0EEkylPEVH9elTI3YyJ0qdkfU32I/RumTs8ahWvxXwnITaqWGNg4dUaordVshUGrVLagT78vEotPT1duevZVoB8qoyWHYpGTaumh8B58YjgC0M6Kfw0a55DeAFJNrkW6luzw7ezI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717057831; c=relaxed/simple;
	bh=U0wpfOaiA60pJBqJkCFS7H/vswpEsThJgZwp2bBSNRs=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=FXMfg8S4JNh7+lcJ273wTL50qB6hqFlsKkcjdpSPx+adkPVpIKy+39SosmdX8luXXy8F65G3mG5MinwB/lazG2d+jKMN54xSlpD04RoJd5AJreJ34aJBqx3jV94/WKSX5JL44OL7GKM/jX44gSGkUdi3bWl5dwdViVERveqFwTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cuEPnCQ8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cuEPnCQ8"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3B7D4C32786;
	Thu, 30 May 2024 08:30:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717057830;
	bh=U0wpfOaiA60pJBqJkCFS7H/vswpEsThJgZwp2bBSNRs=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=cuEPnCQ8VF+WbBQ3P5yHXopZ+H8n4hS7ED6FNkYhQ0cdIvtdRqjY9lnwiSgl9n4s5
	 qm4gjotjWWorp1OtEFmeeQpM6x9HrDyezLomwbLXqZoCbptTxFM060EEitbwPi4Lzc
	 /OT6cdpTUFlA2GYPrssBlMXq8398fWIIeLn5MXR/ZW4CwUoiNwAFCTcrUJtNrngk8u
	 S3ngR/3Ij0xYss0BR4AhH8Rt/8ZGjXNx5DhFQvOigfMLjTEWHiYFpW9cK+BdD8wTQM
	 wkrkdIeBd7ZPnari2sPTRuarR9mWhQr5G42D5BrO9uoLs2FAPWQWMonh3HCnqh7buL
	 /Xey8/mMza0ZQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 2D378D40190;
	Thu, 30 May 2024 08:30:30 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/6] netfilter: nfnetlink_queue: acquire rcu_read_lock()
 in instance_destroy_rcu()
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <171705783018.21028.13096652860732569624.git-patchwork-notify@kernel.org>
Date: Thu, 30 May 2024 08:30:30 +0000
References: <20240528225519.1155786-2-pablo@netfilter.org>
In-Reply-To: <20240528225519.1155786-2-pablo@netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 edumazet@google.com, fw@strlen.de, kadlec@netfilter.org

Hello:

This series was applied to netdev/net.git (main)
by Pablo Neira Ayuso <pablo@netfilter.org>:

On Wed, 29 May 2024 00:55:14 +0200 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> syzbot reported that nf_reinject() could be called without rcu_read_lock() :
> 
> WARNING: suspicious RCU usage
> 6.9.0-rc7-syzkaller-02060-g5c1672705a1a #0 Not tainted
> 
> [...]

Here is the summary with links:
  - [net,1/6] netfilter: nfnetlink_queue: acquire rcu_read_lock() in instance_destroy_rcu()
    https://git.kernel.org/netdev/net/c/dc21c6cc3d69
  - [net,2/6] netfilter: ipset: Add list flush to cancel_gc
    https://git.kernel.org/netdev/net/c/c1193d9bbbd3
  - [net,3/6] netfilter: nft_payload: restore vlan q-in-q match support
    https://git.kernel.org/netdev/net/c/aff5c01fa128
  - [net,4/6] netfilter: nft_payload: skbuff vlan metadata mangle support
    https://git.kernel.org/netdev/net/c/33c563ebf8d3
  - [net,5/6] netfilter: tproxy: bail out if IP has been disabled on the device
    https://git.kernel.org/netdev/net/c/21a673bddc8f
  - [net,6/6] netfilter: nft_fib: allow from forward/input without iif selector
    https://git.kernel.org/netdev/net/c/e8ded22ef0f4

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


