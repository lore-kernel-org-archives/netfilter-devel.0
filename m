Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2418627AC31;
	Tue, 19 May 2026 00:20:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779150008; cv=none; b=Szt6nNRRcMfpEbwkb48JNsIDuxqu7+OmUhmZNRCcxYRwWlh7ci1/47bhs5tGGW5H10rBHjLQemT7HncSW3lZ5bzADYIhPjQqQFi8DbZKBUugGNU4Tt1/qoOYE9NFVyG3e/6bB7vkwWHlhn+YRa2fktcUS93slg4wYQkjCf093/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779150008; c=relaxed/simple;
	bh=RVx8CFUO+GB5qOO2fMEugdltUJRH0uwQkbgZGVOsebE=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=uaS6Q9jopPeCOUnqklo2YZY+ZUsHQcC6XA/5UcVMsS3D2G84Vv8VHGXUGhyYVmrBd8BZpX1u/ZacJw5QP+IA8tW0gefFk65tAa0egjRmcLy9Ve8ycC5avtPTdMxw59jua46FyH/oNx7b1X+xd5TeJAar148ZYgEPAxtxTg8WVzc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KiQ24fZW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KiQ24fZW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B57FEC2BCB7;
	Tue, 19 May 2026 00:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779150007;
	bh=RVx8CFUO+GB5qOO2fMEugdltUJRH0uwQkbgZGVOsebE=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=KiQ24fZWNlyBAx1a4b+L7gzg7Y6FZTgyDp38LcSd/rSz+/vVcB+CxT3lofvhXMTlf
	 a8tVP1xPPSQMa2lc8ihp+LIhfXyi/cMeNDYDqoMEHgrRKnoxnStuwZ/BglPhHERu7T
	 NTzCZjKT/xl2F3x8/O7b7eSTrl9APiL1PwEzu8dcFPnQk8tPH2876AvgInWUNpvf0f
	 vib+JocEbLmDVCOfxpwEh3XpDs5F7dzDVRpNjZpn8P6fhJ19DoWxU3fzs6m2AGwjpd
	 e5hjGvaHLsNaL2SMxpGJbIx98VjVaVHWe+o5y3up1HCelIjU/LjwZEcLVWC2olV14s
	 7wDPTEkCCRb6Q==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 56A113930CBF;
	Tue, 19 May 2026 00:20:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 01/12] netfilter: nf_conntrack_helper: fix possible
 null
 deref during error log
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <177915001914.2025486.8839670790372088379.git-patchwork-notify@kernel.org>
Date: Tue, 19 May 2026 00:20:19 +0000
References: <20260516115627.967773-2-pablo@netfilter.org>
In-Reply-To: <20260516115627.967773-2-pablo@netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 edumazet@google.com, fw@strlen.de, horms@kernel.org

Hello:

This series was applied to netdev/net.git (main)
by Pablo Neira Ayuso <pablo@netfilter.org>:

On Sat, 16 May 2026 13:56:16 +0200 you wrote:
> From: Florian Westphal <fw@strlen.de>
> 
> Reported by sashiko: there is a small race window.
> 
> If a helper module is unloaded or a userspace-defined helper is
> removed, nf_conntrack_helper_unregister() sets ->helper to NULL.
> 
> [...]

Here is the summary with links:
  - [net,01/12] netfilter: nf_conntrack_helper: fix possible null deref during error log
    https://git.kernel.org/netdev/net/c/1afc25ae7528
  - [net,02/12] ipvs: avoid possible loop in ip_vs_dst_event on resizing
    https://git.kernel.org/netdev/net/c/5522d65d81a7
  - [net,03/12] netfilter: ipset: fix a potential dump-destroy race
    https://git.kernel.org/netdev/net/c/53d7fd878c28
  - [net,04/12] netfilter: nft_inner: Fix IPv6 inner_thoff desync
    https://git.kernel.org/netdev/net/c/b6a91f68ebfe
  - [net,05/12] netfilter: ipset: stop hash:* range iteration at end
    https://git.kernel.org/netdev/net/c/0d3a282ab5f1
  - [net,06/12] netfilter: nft_inner: release local_lock before re-enabling softirqs
    https://git.kernel.org/netdev/net/c/a6cb3ff97985
  - [net,07/12] netfilter: ip6t_hbh: reject oversized option lists
    https://git.kernel.org/netdev/net/c/4322dcde6b41
  - [net,08/12] netfilter: ipset: Fix data race between add and list header in all hash types
    https://git.kernel.org/netdev/net/c/c0c42a0fb271
  - [net,09/12] netfilter: ipset: Fix data race between add and dump in all hash types
    https://git.kernel.org/netdev/net/c/2358f7427ccd
  - [net,10/12] netfilter: ipset: annotate "pos" for concurrent readers/writers
    https://git.kernel.org/netdev/net/c/7f7445840b77
  - [net,11/12] netfilter: br_netfilter: Reallocate headroom if necessary in neigh_hh_bridge()
    https://git.kernel.org/netdev/net/c/b2870fc21601
  - [net,12/12] netfilter: nf_queue: hold bridge skb->dev while queued
    https://git.kernel.org/netdev/net/c/e196115ec330

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


