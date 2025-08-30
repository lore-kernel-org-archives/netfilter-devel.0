Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19D9415ADB4;
	Sat, 30 Aug 2025 01:59:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756519200; cv=none; b=lCVdB4XJWgr2c6t9Yci4pRboylMNFniO0t7rAbPs/z9FFYCroGM3cjqNr12A9r7JWfSaUDx/K2ONqgv/E/8RtK3t60oBGe3IorZPKHop8qh9rkfsRIZQKLtwJzbI+ZXXEMMHEHm6pY4F/Xn3OKGy4k8kz2+siXVRAib2xb/HFu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756519200; c=relaxed/simple;
	bh=TDWNaenUe18rF9ni1nc2aogsxqiY2nfstdkTaNkg7aU=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=fbg158A2NcSmP2bsmHzFgG8rSHsfwP6ip0KgYMs0TVS9Jg0zKn7qzvLYkcR5LlyP09BIDirDrfcC03Xsr7LkfKEN2wz7Rnpt4EP+dYjnD8joOmmmvIyb5+aFfDSOX5CH2Cfhf66rJm2CytiCHFPlf5fUPvKuOpdRxSGa15suKuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Uuhljkzv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Uuhljkzv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96583C4CEF0;
	Sat, 30 Aug 2025 01:59:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756519199;
	bh=TDWNaenUe18rF9ni1nc2aogsxqiY2nfstdkTaNkg7aU=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=UuhljkzvC4OZ9kltiasZmgclGRrS7MSwj+llWxk3uYpMujTEEYTqzwNudAUma62io
	 P2xH09qSY38zal6DXd697kTZGrc+UMJnBoxgmjMd9DAMNYDd6EVBPyktVj4sBLX8c2
	 lJprMZsEqgxt33FRq+dYbDfFfkxohGjFWmPDYS4ysSaBrnF5z7CmOuRI9kQb3211TF
	 RCPO1KDhGDIOPNiFQ16cttIRIu5eRRVwxMDI5cmKz2fAU4Yi7dWPRa3m+aMICHLoRZ
	 xizoYcWwBGkFP6cXGxfH+FUm3VorFwIzCEaRgY+S62lltPwjNBhlpTjEJWD2TD1MhU
	 zXO2vRRAByuiA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 70BF5383BF75;
	Sat, 30 Aug 2025 02:00:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] netfilter: nft_flowtable.sh: re-run with random mtu
 sizes
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <175651920625.2395248.8573870203898454025.git-patchwork-notify@kernel.org>
Date: Sat, 30 Aug 2025 02:00:06 +0000
References: <20250828214918.3385-1-fw@strlen.de>
In-Reply-To: <20250828214918.3385-1-fw@strlen.de>
To: Florian Westphal <fw@strlen.de>
Cc: netdev@vger.kernel.org, pabeni@redhat.com, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, netfilter-devel@vger.kernel.org,
 pablo@netfilter.org

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 28 Aug 2025 23:49:18 +0200 you wrote:
> Jakub says:
>  nft_flowtable.sh is one of the most flake-atious test for netdev CI currently :(
> 
> The root cause is two-fold:
> 1. the failing part of the test is supposed to make sure that ip
>    fragments are forwarded for offloaded flows.
>    (flowtable has to pass them to classic forward path).
>    path mtu discovery for these subtests is disabled.
> 
> [...]

Here is the summary with links:
  - [net] netfilter: nft_flowtable.sh: re-run with random mtu sizes
    https://git.kernel.org/netdev/net/c/d6a367ec6c96

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


