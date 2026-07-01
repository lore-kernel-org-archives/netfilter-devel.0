Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A43F237881D;
	Wed,  1 Jul 2026 17:10:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782925840; cv=none; b=XuHetZSdPOux9jXYyqqNASGH4lQ17IqUvFv/uKLWRbvTw3EyqF3OI5FgDzcDqGVHP+pULEUHjZz5nHor76+FMeYO8L2jqwyb2IgHE1OJunyqh+ppD0hFThlsTURoeBXVZ2tAN3kfabhow0p5fBs/dbPYWOGhuCfaLKdqjFrTWaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782925840; c=relaxed/simple;
	bh=h866r80oAAouOTBSCidev3WeFJbSABkts1Ea7byzu1g=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=cgmbRokn1UHWzKhpVkvgI8AEedNiPvXAbQhyv7mhjmKDphYxV7dmS2tPPqj3VurEtAaHbY2KE7YtQ5Zt73tLaBnqKq7mjKFerELD830ur17VuknWPfFSdx4vVFgcbho9rAQ0ZXtcWH/YyNPYUHYa5Tgdxfbc3ssun98gfo6Tcmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DUWWnY3N; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DUWWnY3N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74B751F000E9;
	Wed,  1 Jul 2026 17:10:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782925839;
	bh=HUDgVJ499vbywMasekvTE9hogfK8wQhIIYPBtIVOn+I=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=DUWWnY3Nj0qWiNQJZzrXb888bRCuXLKz5ACIovPoDfI6js6pYn97q1KTYF9+q9Dg4
	 2uQXAkffGErP4Rffkjr0cREQ4MJW8c09qjROn3qGmYDm0NSkilBubbwnXOuC4CpXej
	 0htQLUdzmXb7/+d9OeX/ooph5yflEdR+8nuedYPeVlBDfOs3C4SvJTEQBGlN/pR3wF
	 D2i48c3cy/MTWAI1whGlSzV4S8oYStjLclCJm3dsSJFVFeXpdVoMsWNzhWeu7h96Jf
	 5NGfz6MhSubsTWAPsMohcWC5JsBRLzZV2iCyJZJK3oFzk6XtT73CBohkIw7yclITsh
	 OqSmUHZkbMK2Q==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 199353926272;
	Wed,  1 Jul 2026 17:10:24 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/9] netfilter: nf_conntrack_expect: zero at
 allocation
 time
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <178292582264.1213092.416770887913754964.git-patchwork-notify@kernel.org>
Date: Wed, 01 Jul 2026 17:10:22 +0000
References: <20260630045243.2657-2-fw@strlen.de>
In-Reply-To: <20260630045243.2657-2-fw@strlen.de>
To: Florian Westphal <fw@strlen.de>
Cc: netdev@vger.kernel.org, pabeni@redhat.com, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, netfilter-devel@vger.kernel.org,
 pablo@netfilter.org

Hello:

This series was applied to netdev/net.git (main)
by Florian Westphal <fw@strlen.de>:

On Tue, 30 Jun 2026 06:52:35 +0200 you wrote:
> There are occasional LLM hints wrt. leaking uninitialized data to
> userspace via ctnetlink.  Just zero at allocation time,
> expectations are not frequently used these days.
> 
> Intentionally keeps _init as-is because we could theoretically
> support re-init, so add the missing exp->dir there.
> 
> [...]

Here is the summary with links:
  - [net,1/9] netfilter: nf_conntrack_expect: zero at allocation time
    https://git.kernel.org/netdev/net/c/241ccd2fed90
  - [net,2/9] netfilter: nft_set_pipapo: don't leak bad clone into future transaction
    https://git.kernel.org/netdev/net/c/47e65eff5069
  - [net,3/9] netfilter: ipset: fix race between dump and ip_set_list resize
    https://git.kernel.org/netdev/net/c/7cd9103283b2
  - [net,4/9] netfilter: nf_conntrack_sip: validate skb_dst() before accessing it
    https://git.kernel.org/netdev/net/c/e5e24a365a5e
  - [net,5/9] netfilter: nfnetlink_cthelper: cap to maximum number of expectation per master
    https://git.kernel.org/netdev/net/c/bf5355cfdede
  - [net,6/9] netfilter: nft_fib: reject fib expression on the netdev egress hook
    https://git.kernel.org/netdev/net/c/d07955dd34ec
  - [net,7/9] netfilter: nfnetlink_queue: restrict writes to network header
    https://git.kernel.org/netdev/net/c/54f34607d184
  - [net,8/9] netfilter: nftables: restrict linklayer and network header writes
    https://git.kernel.org/netdev/net/c/df07998dfd40
  - [net,9/9] netfilter: nftables: restrict checkum update offset
    https://git.kernel.org/netdev/net/c/c3716a3c4346

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


