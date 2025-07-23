Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D08719CC29;
	Wed, 23 Jul 2025 01:29:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753234194; cv=none; b=o7HJJ63RpLlOLjvMeYttPZktWzyhQErpvkaKvklAc97jJIC5F9OzlMrGXWuAp4JlMTk7rpaeN02VzaZU2YbMcr1RB1Qn7aaO9vdX0QT5p2rOHLsUoKigcIUhGOEay32Ysk0l8I+ZSiDY1Wj/W643iAFtBHjSZ8tOX45k5gwh2yY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753234194; c=relaxed/simple;
	bh=VWKJc7ylCoJ9UM9J8dblvzszsYB29Cn5NRgB99tmpuo=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=J8h6Ec01Kmtu1Yb1RSxxKMXwMEEoeuO72KPkRHpHOfzbcMhOwvZxqWdpG//0IxzZLRkroG2YRe9X6TXKnFXQjmW0xvZensYGTHKjoFGDDtZ4KvTNDqfrpGeQuZcwVktuqpqeLgzVPZbiNTdYdbHIJCLzV8rXRhmRUFkEXCmyZ0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DNpG3Yrv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DNpG3Yrv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFDF6C4CEF7;
	Wed, 23 Jul 2025 01:29:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753234193;
	bh=VWKJc7ylCoJ9UM9J8dblvzszsYB29Cn5NRgB99tmpuo=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=DNpG3YrvH6PQnbfQuZfuNk398wd4esBgabN2wB4vq1Z8jw17v7aJeOypc53noI2RY
	 6860JxTwrGAnuKoqH5FlGgJbjAKDtZzxAGMvsdB81xN4BvOBa44+qFsA+mKBy9Yel9
	 g+T9tYdBT0cEoIiqxxU8uEcDLUaXEo/YNgMHdkgtA4I/WhquZTV8eg5q99orvgB8H7
	 +ZZDOfqcvk0Ubo1eRn+oWfOx4N5NUwkmZWczU1wV/Ae/l+/nK/CLTYSQm4qU0xsx4j
	 ET9oxuNLacW2clXwtuVxisR9vFPvyfCfKGrhqYgw//AhFsW4Ars31TxD+3lcfIpRr/
	 KlF14jcDRTSmQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 70C10383BF5D;
	Wed, 23 Jul 2025 01:30:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net] selftests: netfilter: tone-down conntrack clash
 test
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <175323421226.1016544.13216461197162224409.git-patchwork-notify@kernel.org>
Date: Wed, 23 Jul 2025 01:30:12 +0000
References: <20250721223652.6956-1-fw@strlen.de>
In-Reply-To: <20250721223652.6956-1-fw@strlen.de>
To: Florian Westphal <fw@strlen.de>
Cc: netdev@vger.kernel.org, netfilter-devel@vger.kernel.org, kuba@kernel.org,
 pabeni@redhat.com, davem@davemloft.net, edumazet@google.com

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 22 Jul 2025 00:36:49 +0200 you wrote:
> The test is supposed to observe that the 'clash_resolve' stat counter
> incremented (i.e., the code path was covered).
> This check was incorrect, 'conntrack -S' needs to be called in the
> revevant namespace, not the initial netns.
> 
> The clash resolution logic in conntrack is only exercised when multiple
> packets with the same udp quadruple race. Depending on kernel config,
> number of CPUs, scheduling policy etc.  this might not trigger even
> after several retries.  Thus the script eventually returns SKIP if the
> retry count is exceeded.
> 
> [...]

Here is the summary with links:
  - [v2,net] selftests: netfilter: tone-down conntrack clash test
    https://git.kernel.org/netdev/net/c/dca56cc8b5c3

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


