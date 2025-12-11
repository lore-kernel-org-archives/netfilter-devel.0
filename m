Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C2812F60DD;
	Thu, 11 Dec 2025 09:03:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765443802; cv=none; b=hZW+9iOHdZTLqDb0oGv02Js3TaLeAnjW7vn2fN1HQY0Y0ua81/r2Nl3JDzrN65MFxyWL2Y13icQSbOLLnh7o7Ljebre0JXdyLO8QBbPE2Cluq3+a03tEd99xfCVU15+sQe/5uXpH+b4Ajr8NuBjXVsQyymFisRtou6OgCE4PKeo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765443802; c=relaxed/simple;
	bh=77npxH+ztraEDScdRP3cLMYQif4Yt5VZTBzNtGXTLfg=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=Dj3wjS1VZyOIq2/ON3E8Kesoqrm12EUToUqy/v4xrmqoORonPshwHr1KnFOTHeuGwIGwvP4/Hd4A07+0eDHUdpM+5eEgOMvMSxT+43wjmVAOaHEVkGTPvnntqGSgNFTqeQSABqLMZJpHw51CYRUEL9ytjstr4xWVxefrybsw20I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oQ0f/juR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oQ0f/juR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E86F9C4CEFB;
	Thu, 11 Dec 2025 09:03:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765443802;
	bh=77npxH+ztraEDScdRP3cLMYQif4Yt5VZTBzNtGXTLfg=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=oQ0f/juR29h/FJyj3lrzMCj8TZ9iYP7spZsG/2iTADK2citlSSAt2z0IlB6fAkuDz
	 /xm8oZ3wiWadijBZOvVo/ySXqEP8EpANWW7WYm0QWEn8yuuVsU6yOG8WSmybw2wzZR
	 A/+e4ZKxpQ593mXAeoeZUsDqev7OxEOMCU4uPdT4DyToV6vSbMDA8pmBKGQP15tyEy
	 Eq6Z9nRNxzpjCqj2qkQMaXOB2NRKRFBVpI7dkGjn3b1EnI09Nkopb/cqU8/e9LCFUS
	 qxSz1u8jjgZu91KiBVAQ3ZXFkJDJOJUJy8JgWTm2NDZhVDhX3s0ndqB/9OkI2LzpP3
	 AP4wvvm95EIKQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 3B8173809A34;
	Thu, 11 Dec 2025 09:00:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/4] netfilter: nf_conncount: fix leaked ct in error
 paths
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <176544361603.1297204.5379023139514419610.git-patchwork-notify@kernel.org>
Date: Thu, 11 Dec 2025 09:00:16 +0000
References: <20251210110754.22620-2-fw@strlen.de>
In-Reply-To: <20251210110754.22620-2-fw@strlen.de>
To: Florian Westphal <fw@strlen.de>
Cc: netdev@vger.kernel.org, pabeni@redhat.com, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, netfilter-devel@vger.kernel.org,
 pablo@netfilter.org

Hello:

This series was applied to netdev/net.git (main)
by Florian Westphal <fw@strlen.de>:

On Wed, 10 Dec 2025 12:07:51 +0100 you wrote:
> From: Fernando Fernandez Mancera <fmancera@suse.de>
> 
> There are some situations where ct might be leaked as error paths are
> skipping the refcounted check and return immediately. In order to solve
> it make sure that the check is always called.
> 
> Fixes: be102eb6a0e7 ("netfilter: nf_conncount: rework API to use sk_buff directly")
> Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
> Signed-off-by: Florian Westphal <fw@strlen.de>
> 
> [...]

Here is the summary with links:
  - [net,1/4] netfilter: nf_conncount: fix leaked ct in error paths
    https://git.kernel.org/netdev/net/c/2e2a72076688
  - [net,2/4] ipvs: fix ipv4 null-ptr-deref in route error path
    https://git.kernel.org/netdev/net/c/ad891bb3d079
  - [net,3/4] netfilter: always set route tuple out ifindex
    https://git.kernel.org/netdev/net/c/2bdc536c9da7
  - [net,4/4] selftests: netfilter: prefer xfail in case race wasn't triggered
    https://git.kernel.org/netdev/net/c/b8a81b0ce539

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


