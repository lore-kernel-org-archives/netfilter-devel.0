Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C47D3126C5;
	Thu,  4 Sep 2025 14:40:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756996830; cv=none; b=myd9+usurfKY29Ct6R+JIT2EbbT6SVxkB7tOIlREmD/nZKUToBbMnXspMc7SFxgrCVxfVD+sZyPWV80Nxk5vwvdPbEaOBIY9FlMn8FVj2VfPIkXnPmv03EyGwwg+irN1J14aGTg/e3nLOxlQ3UiHVtYj3GATYzt4HEMSS7RcaiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756996830; c=relaxed/simple;
	bh=zLL5RYX12tQnydPFucGhVNmYZb5bvJKkl4lN7Q+TVhE=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=unDzZa9FH+cUwbo8jogLIJnHX0X3NgJV+65ZwYmPuIGcjl47TEo0oLcptb9x+dYTupVwAk1KGxLkVpo0DCroPqXGH8EH5Mz+TvN0r1IYT0CLcxDrPOdO8L1Ws+1b8i2XtoZ9QdlojkOCp/B+ZaniCTncbkpfudK9pAhzq80PzQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Bi9gj1bo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Bi9gj1bo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FF3FC4CEF0;
	Thu,  4 Sep 2025 14:40:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756996830;
	bh=zLL5RYX12tQnydPFucGhVNmYZb5bvJKkl4lN7Q+TVhE=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=Bi9gj1bo9iUHSAEGZUBP9o/Hh2sK1uU1Z3bSyQve9bWypS97Vlbom1L5Dtfrq4qx0
	 tY1sv7BFudG8xS9LRjCeTUdYeQrDahPvCa58ZljQWuuFm2loB1Y7qyFGomYt7CyEaV
	 Xnff6fVuhavNza104DDlGF+jx4+Ud62qqpla0h27uQxVCRKC6aZtE4oIGN7H7Uztl9
	 sRvYe3SEIj/sVHH2LbYe02Zu3SsQHvGP/vQhubeY1ygZ/+C2YhBet6awOPHIdqO91p
	 OTvVFD9sVg+Rol+5qKIC1iLgb2Ij7ViO145VgoCTbkL7EAILJieUgkhiza0KzniZyo
	 JD3gQWBHRtymg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 34AC8383BF69;
	Thu,  4 Sep 2025 14:40:36 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net 1/2] selftests: netfilter: fix udpclash tool hang
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <175699683476.1834386.17488693717476628261.git-patchwork-notify@kernel.org>
Date: Thu, 04 Sep 2025 14:40:34 +0000
References: <20250904072548.3267-2-fw@strlen.de>
In-Reply-To: <20250904072548.3267-2-fw@strlen.de>
To: Florian Westphal <fw@strlen.de>
Cc: netdev@vger.kernel.org, pabeni@redhat.com, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, netfilter-devel@vger.kernel.org,
 pablo@netfilter.org

Hello:

This series was applied to netdev/net.git (main)
by Florian Westphal <fw@strlen.de>:

On Thu,  4 Sep 2025 09:25:47 +0200 you wrote:
> Yi Chen reports that 'udpclash' loops forever depending on compiler
> (and optimization level used); while (x == 1) gets optimized into
> for (;;).  Add volatile qualifier to avoid that.
> 
> While at it, also run it under timeout(1) and fix the resize script
> to not ignore the timeout passed as second parameter to insert_flood.
> 
> [...]

Here is the summary with links:
  - [v2,net,1/2] selftests: netfilter: fix udpclash tool hang
    https://git.kernel.org/netdev/net/c/661a4f307fe0
  - [v2,net,2/2] netfilter: nf_tables: Introduce NFTA_DEVICE_PREFIX
    https://git.kernel.org/netdev/net/c/4039ce7ef404

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


