Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57C6E3630B2;
	Thu,  9 Apr 2026 01:51:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775699477; cv=none; b=E2IjT2E7b4jRjpwkJz5gpGEREpfTr0nvbtBvhm+uIY0vPcRK/5GqRMEF+UOv/Js3Zfr69kTokgZhFj/ygXWi0ldaTUnxOpHBb4JwqDm34b2nTMJQNmGUvY29UbJNxpqTEGO59VbhfgI2mp7G9bW1HnlRgLikqXpeMy7ZjxeneNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775699477; c=relaxed/simple;
	bh=4tiPiLc0ubj/toDkCFd3Kanmf/vGuOCItA7BcG8m7dI=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=G6kb3aDmCHmY7Kt8Ujy6KvjpppJ+vH0gLOC2E7muUViUYSGGcsZGTBXR1SabAhTbJ0FWqirifyTAPwNkCllNZapR/IEFgpGRt55ARhOMBUQTXuENWOcw7C0oPm8cIKAGAgdIV2MC68p8QCoMx8fWJWoJ4iKSOiUZ6q5ChFEWgdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VzNMksFH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VzNMksFH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F39B3C2BC9E;
	Thu,  9 Apr 2026 01:51:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775699477;
	bh=4tiPiLc0ubj/toDkCFd3Kanmf/vGuOCItA7BcG8m7dI=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=VzNMksFHoV6aND36MDY/hkIUoZUAU0zwJ82EBaLrq/HspZiycQmenGv+jqdSO1qfy
	 o+XGCaigT6yDgeqnDdMpdfCkaGAhAjB23Z0+rTzBOzqPVgpqbjY4jTkKadJs4Ri9eT
	 r0BYI5wU2fAcFHrqgUBnO/IXiZjIMe5B9gXndAxjDrCZcvdnjJlexiprj1u+qoBkF9
	 2IkVaJYwn094Ll7GTzdsImsrm8p5Mzfd3JsB0ZUp20jjCJfxxE4S8tqiF42vVb1dO1
	 4rzO8mvya9c7jAZrP2tL+A2qobpUGpIYdAPPCYHt3kX1Tqx0k7scvgPyr0CxeyDHn0
	 zPbxm4Jm4YkKw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 7CF783930793;
	Thu,  9 Apr 2026 01:50:54 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/7] ipvs: fix NULL deref in ip_vs_add_service error
 path
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <177569945304.949482.10774857473121933938.git-patchwork-notify@kernel.org>
Date: Thu, 09 Apr 2026 01:50:53 +0000
References: <20260408163512.30537-2-fw@strlen.de>
In-Reply-To: <20260408163512.30537-2-fw@strlen.de>
To: Florian Westphal <fw@strlen.de>
Cc: netdev@vger.kernel.org, pabeni@redhat.com, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, netfilter-devel@vger.kernel.org,
 pablo@netfilter.org

Hello:

This series was applied to netdev/net.git (main)
by Florian Westphal <fw@strlen.de>:

On Wed,  8 Apr 2026 18:35:06 +0200 you wrote:
> From: Weiming Shi <bestswngs@gmail.com>
> 
> When ip_vs_bind_scheduler() succeeds in ip_vs_add_service(), the local
> variable sched is set to NULL.  If ip_vs_start_estimator() subsequently
> fails, the out_err cleanup calls ip_vs_unbind_scheduler(svc, sched)
> with sched == NULL.  ip_vs_unbind_scheduler() passes the cur_sched NULL
> check (because svc->scheduler was set by the successful bind) but then
> dereferences the NULL sched parameter at sched->done_service, causing a
> kernel panic at offset 0x30 from NULL.
> 
> [...]

Here is the summary with links:
  - [net,1/7] ipvs: fix NULL deref in ip_vs_add_service error path
    https://git.kernel.org/netdev/net/c/9a91797e61d2
  - [net,2/7] netfilter: nfnetlink_log: initialize nfgenmsg in NLMSG_DONE terminator
    https://git.kernel.org/netdev/net/c/1f3083aec883
  - [net,3/7] netfilter: xt_multiport: validate range encoding in checkentry
    https://git.kernel.org/netdev/net/c/ff64c5bfef12
  - [net,4/7] netfilter: ip6t_eui64: reject invalid MAC header for all packets
    https://git.kernel.org/netdev/net/c/fdce0b3590f7
  - [net,5/7] netfilter: nft_ct: fix use-after-free in timeout object destroy
    https://git.kernel.org/netdev/net/c/f8dca15a1b19
  - [net,6/7] netfilter: nfnetlink_queue: make hash table per queue
    https://git.kernel.org/netdev/net/c/936206e3f6ff
  - [net,7/7] selftests: nft_queue.sh: add a parallel stress test
    https://git.kernel.org/netdev/net/c/dde1a6084c5c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


