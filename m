Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B65C13D556;
	Thu, 12 Sep 2024 13:50:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726149032; cv=none; b=V8B3OTlPaRWJYfZrdSF+XH9B2bv5/xAVNnPplLr/zA8hZqbC9RH7rRhvdzXsAz9iBit5N4sluid3gf31CclGBu3U395FY7eEIwaO6ysmzr22y64+ZCdhfnPNo+sgWBkRXMcvag5b1XLPLNjGOsXz4nY7LikHxEnBllDbxjOcfxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726149032; c=relaxed/simple;
	bh=g+uJC+Sev/eO8N8f57gatkGyrIOD9acM6qNnMfKi4BE=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=oQ4WLOXDHxSgh87OyiDZF5EKsoyQ5qLGIsIBgkGhKt+wHpDYUDS8cAsHtW/ZLfKgcKQtsyKml34sXrYRRJsS7NZAwacq6chYqqyNuWUQJ2z2emA67jiXsC5M97akN++UUWiH/smmuFD8vor628Wjc2PaMYg1ocpJwyiY2pq8np8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bGRSCog6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bGRSCog6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10E76C4CEC3;
	Thu, 12 Sep 2024 13:50:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1726149031;
	bh=g+uJC+Sev/eO8N8f57gatkGyrIOD9acM6qNnMfKi4BE=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=bGRSCog6CDRQ9mm+cTiiem2ZiIKkECitl+STD+9NToS3mhbtUxox114c4f0RRngB/
	 8dFdCBFLmTELG/6J/4KFHBRhZ6mn8GmIc3Fz/apqfMFMdoNmEsEyLXpwhfFCwbjI1R
	 iGhm5X8ebynIRAwnEb6D6dmdFwhsnDgT+Mf61i87KKkhGuMLu8YTGu+D6lzw1Dt57z
	 H/Z2qC7Isn0pJjxsnMScD6+e4/g9CO20LtuCTWAJYii1H21Z3pLKmKN5iq5Rr2hr80
	 U4KzQKtzAdFMdvD6qREWBF2uerRWK9CpgAyN2r6lg42wl5thzRigv2/pRP0A5D7JU8
	 wPGQKskpxN42g==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 713203822D1B;
	Thu, 12 Sep 2024 13:50:33 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/2] netfilter: nft_socket: fix sk refcount leaks
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <172614903228.1599668.9462521259963772352.git-patchwork-notify@kernel.org>
Date: Thu, 12 Sep 2024 13:50:32 +0000
References: <20240911222520.3606-2-pablo@netfilter.org>
In-Reply-To: <20240911222520.3606-2-pablo@netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 edumazet@google.com, fw@strlen.de

Hello:

This series was applied to netdev/net.git (main)
by Pablo Neira Ayuso <pablo@netfilter.org>:

On Thu, 12 Sep 2024 00:25:19 +0200 you wrote:
> From: Florian Westphal <fw@strlen.de>
> 
> We must put 'sk' reference before returning.
> 
> Fixes: 039b1f4f24ec ("netfilter: nft_socket: fix erroneous socket assignment")
> Signed-off-by: Florian Westphal <fw@strlen.de>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> 
> [...]

Here is the summary with links:
  - [net,1/2] netfilter: nft_socket: fix sk refcount leaks
    https://git.kernel.org/netdev/net/c/8b26ff7af8c3
  - [net,2/2] netfilter: nft_socket: make cgroupsv2 matching work with namespaces
    https://git.kernel.org/netdev/net/c/7f3287db6543

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


