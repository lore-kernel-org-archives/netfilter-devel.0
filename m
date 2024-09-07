Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C9F1A923;
	Sat,  7 Sep 2024 01:20:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725672028; cv=none; b=O+6RPs0Gpm0wzrcapJbyoquJLJmf0WLJxyrzmYLv2NAeiOBT5W/ILWrcB7Jo/4XIiG53OU8dfpL4/Y3ZDggH6JYPb+nYa576eKR4Vyno28mkPmAtYDJ5jG0NqQDb9eoUXkWimYpAWf0/DpiczNpYYGCK+dRk7cZrsJl+w6aAzRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725672028; c=relaxed/simple;
	bh=uUL+zGRZtnm04HNhLF8GSXUtW7Ukpc5lxFlmAkYLKHI=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=tBnCuy6WZ+WyL1pMP4JMLZxhYSssPFyR/MoDRGjX/OncvmaYXKUlUYCwYp2jjMkORURDZ93YidwETCJ45iAeLRBErpzbGuwfZLG1xMGgZhSO4h3JhJCO959TRaJrnaSmO0WKP40H1rV46A2BaHJGRVl6yzodf24HB6VYdw6bfjs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IjPLGVe6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IjPLGVe6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91FBEC4CEC4;
	Sat,  7 Sep 2024 01:20:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725672027;
	bh=uUL+zGRZtnm04HNhLF8GSXUtW7Ukpc5lxFlmAkYLKHI=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=IjPLGVe6ttiTlST1Ahvd65UYlYraPZ4Ulglul9yKGgkE4NygquE1kYr+dp/s+eV6a
	 kBJiWoUcafrYJ6AgoiF77Dqutt28etk30pqPf1oSjJjellhFScZmTvKB0bvPaxnE9M
	 LT1mcN10r2gu8PpJG1ULbKaKXdnA2BZVQ2cr+D3opcLD6h4/TLCDSPza8eRtZDmWZC
	 r5r+1CIEewuJzjL4KVUwMuIAPF+xLkt3IHFIHgkbPlaY6ql2XLy9NZokb4uTPWQQYm
	 ai5l2igv5NJb/QpRtGpMMKgYE/08m/c7svcJJUaZuI3w5TVWqJXuT8hnDHvmOQsXEI
	 /lvAQtv7ojrpg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id AE4BC3805D82;
	Sat,  7 Sep 2024 01:20:29 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 0/5] make use of the helper macro LIST_HEAD()
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <172567202850.2574896.10941650330610310039.git-patchwork-notify@kernel.org>
Date: Sat, 07 Sep 2024 01:20:28 +0000
References: <20240904093243.3345012-1-lihongbo22@huawei.com>
In-Reply-To: <20240904093243.3345012-1-lihongbo22@huawei.com>
To: Hongbo Li <lihongbo22@huawei.com>
Cc: davem@davemloft.net, dsahern@kernel.org, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, jmaloy@redhat.com,
 ying.xue@windriver.com, pablo@netfilter.org, kadlec@netfilter.org,
 horms@kernel.org, netdev@vger.kernel.org, netfilter-devel@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 4 Sep 2024 17:32:38 +0800 you wrote:
> The macro LIST_HEAD() declares a list variable and
> initializes it, which can be used to simplify the steps
> of list initialization, thereby simplifying the code.
> These serials just do some equivalatent substitutions,
> and with no functional modifications.
> 
> Changes in v2:
>   - Keep the reverse xmas tree order as Simon's and
>     Pablo's suggested.
> 
> [...]

Here is the summary with links:
  - [net-next,v2,1/5] net/ipv4: make use of the helper macro LIST_HEAD()
    https://git.kernel.org/netdev/net-next/c/cecbe5c8c803
  - [net-next,v2,2/5] net/tipc: make use of the helper macro LIST_HEAD()
    https://git.kernel.org/netdev/net-next/c/e636ba1a15e7
  - [net-next,v2,3/5] net/netfilter: make use of the helper macro LIST_HEAD()
    https://git.kernel.org/netdev/net-next/c/8b51455bbd45
  - [net-next,v2,4/5] net/ipv6: make use of the helper macro LIST_HEAD()
    https://git.kernel.org/netdev/net-next/c/2a7dd251b6fe
  - [net-next,v2,5/5] net/core: make use of the helper macro LIST_HEAD()
    https://git.kernel.org/netdev/net-next/c/17f01391903d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


