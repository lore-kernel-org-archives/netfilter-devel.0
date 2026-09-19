Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84CA330FF30;
	Sat, 19 Sep 2026 00:31:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789777873; cv=none; b=DVFb0KUE/g9hPHcseCDJdfNPNDjC1A3jAycD4w3Xcd6veDWzxAKk3sRJ01b13WRkd3uO24fZwYyk9ThbI/SLXBz+Vss1zrBljaxVBbhokwijvKY/tLZisTd1EKA1gt0T+Ab4diSTK4Asnaap53UHGykjZln7BFhnOBqtom7S078=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789777873; c=relaxed/simple;
	bh=dMoJiW38JJqRtPxIswh1acO3Dkrz1uEJCqlw8vLR/S4=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=iV8jXofmY3c0fvl31NYTwgUsKuFpm7zYwf49uS7icJK0kEuT2g+rZmmfJZvBcdJjtHvHqdlGnFna2vVofNZ5jZLDQLpOPCje6De/9YRTxSgeMHoF3zfg7+FemGyGRjkl8gr46R5Xnx9DrpyEY8HbwBD5dhS6rY4vNslHFY70H/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZWUJA+tl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZWUJA+tl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BEA41F000FF;
	Sat, 19 Sep 2026 00:31:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789777872;
	bh=RsVM44NNXxzYW5W8RXxbc3bpmbVB+wlVWyRDEEzYfvc=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=ZWUJA+tlcj1jemfIp6vC/gWO+wRabVN6E9svOyn6LAUDcg4mnE7AGruEFExmxmmJW
	 igiuBKGUrhteaSHgdpQuQTHQLauzZgxW76YljwAVeIBsFQOI2GoA4SBOXPg65DPrY2
	 jbqoWVSJzsUmJlXhVfygOA/9Ul6Tnm2uoaYTIN9fI5qOzRvalPhvOtQXpRem8yxR5x
	 0+0SPENQky40ILcH6ANYLBJaed0KdoUOQPWBw77e1/dSN2gmkK6RMmt0/2So6WXMjx
	 9uevsooN02V5LjkRgOa2pYV7R6wsp0rwXyTjPHyDEBftDUo5knw5damSlehSrRBuT3
	 bn0273DfqRX/g==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 568DF3811978;
	Sat, 19 Sep 2026 00:30:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] selftests: net: update netfilter netlink config
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <178977780506.1204672.14114512440910864015.git-patchwork-notify@kernel.org>
Date: Sat, 19 Sep 2026 00:30:05 +0000
References: <20260917-selftest_config-v1-1-bf25ccbfb18e@kylinos.cn>
In-Reply-To: <20260917-selftest_config-v1-1-bf25ccbfb18e@kylinos.cn>
To: Hangbin Liu <hangbin.liu@linux.dev>
Cc: matttbe@kernel.org, martineau@kernel.org, geliang@kernel.org,
 davem@davemloft.net, edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
 horms@kernel.org, shuah@kernel.org, pablo@netfilter.org, fw@strlen.de,
 phil@nwl.cc, fmancera@suse.de, netdev@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
 netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
 mptcp@lists.linux.dev, liuhangbin@kylinos.cn

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 17 Sep 2026 10:17:01 +0800 you wrote:
> From: Hangbin Liu <liuhangbin@kylinos.cn>
> 
> Since commit d4349ba9872d ("netfilter: allow nfnetlink built-in only"),
> NETFILTER_NETLINK was changed to a bool. Use 'y' instead of 'm'.
> Otherwise the build emits:
> 
>   .config:5688:warning: symbol value 'm' invalid for NETFILTER_NETLINK
> 
> [...]

Here is the summary with links:
  - [net] selftests: net: update netfilter netlink config
    https://git.kernel.org/netdev/net-next/c/c2437bf72a37

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


