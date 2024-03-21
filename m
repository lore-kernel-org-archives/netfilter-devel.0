Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29E5885266;
	Thu, 21 Mar 2024 14:20:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711030828; cv=none; b=rDUYsTSRL3YC785GZikWpTv1aN9aYUUbK7nWwFrycX0SckfBBM26nLywPDqNUzz5/A8oyw0TPZzt0eDJfb+YewV/S9tzZdv5VcfHFchKHrU3SSJu3Ss1e9D7KGOw1Fjv9Rg3JMF7j/xpdHLBKHHLjbJyVp8xB4R4w1J2SawRwPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711030828; c=relaxed/simple;
	bh=YsaJU7yU5UXT4dwymitMoladXmLHepBOYhkmIslJq/I=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=hzUn4k+F7ZKDppW2pOAny7lboOHYS7TiEnHU1kTG5TJVZ4wzlrdb/Evcw8QOvlV4d8ENoEmcEv/eB4G/IsiiSWyQSPxW/VI6lQf/AOehUroIQiOM4yQc8gHp8ErzfIRSU1iXmx2DE1lL3c28Emp6FeU6GJZSjRDMjGtGuQ0yF/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pYEOeXfG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pYEOeXfG"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 934BCC43390;
	Thu, 21 Mar 2024 14:20:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711030827;
	bh=YsaJU7yU5UXT4dwymitMoladXmLHepBOYhkmIslJq/I=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=pYEOeXfGnRVAbqxBcvCan2jnhrC9JDNzYWDqSmvi7v+6tZh8jIxSvb1eVHZn2zSSE
	 SJGn7EWSuaqz8PdqtTPDu1L3H4uVYN5+/DfVFHwzkH9Q1rjdOOE9PiD+99VpyqsqLW
	 T1R90/yJkeCZlO23U94zh20ZxiYtkgkrPrfA+B360qE8fpY6fbZIoyFObGxrUSGFQF
	 Jj4GTXAWMYajgB2+/0qaJGATWGSGDj6p7Rrp6x9b4UHIeyEcPWMBOPzUgTjomBjTrc
	 wHM/61XcZSvBgy0lraF4MZ3WeNyg/4XXQb/pQWplrm/zlSNtp5fYKkoNgrbTfEWU3J
	 rgP5S1y3Nc87A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7D918D982E4;
	Thu, 21 Mar 2024 14:20:27 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/3] netfilter: nft_set_pipapo: release elements in clone
 only from destroy path
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <171103082750.11634.16678808488889700011.git-patchwork-notify@kernel.org>
Date: Thu, 21 Mar 2024 14:20:27 +0000
References: <20240321112117.36737-2-pablo@netfilter.org>
In-Reply-To: <20240321112117.36737-2-pablo@netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 edumazet@google.com

Hello:

This series was applied to netdev/net.git (main)
by Pablo Neira Ayuso <pablo@netfilter.org>:

On Thu, 21 Mar 2024 12:21:15 +0100 you wrote:
> Clone already always provides a current view of the lookup table, use it
> to destroy the set, otherwise it is possible to destroy elements twice.
> 
> This fix requires:
> 
>  212ed75dc5fb ("netfilter: nf_tables: integrate pipapo into commit protocol")
> 
> [...]

Here is the summary with links:
  - [net,1/3] netfilter: nft_set_pipapo: release elements in clone only from destroy path
    https://git.kernel.org/netdev/net/c/b0e256f3dd2b
  - [net,2/3] netfilter: nf_tables: do not compare internal table flags on updates
    https://git.kernel.org/netdev/net/c/4a0e7f2decbf
  - [net,3/3] netfilter: nf_tables: Fix a memory leak in nf_tables_updchain
    https://git.kernel.org/netdev/net/c/7eaf837a4eb5

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


