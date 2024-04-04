Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD0001CF8D;
	Thu,  4 Apr 2024 16:50:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712249431; cv=none; b=pBHratFbF5m/V3m3FZSsNOVXl2OELL7QSCseZ2KpZWXZU76QyAshFpv2cxOBjqMyBEzRqL74k8xZXEZoUgCOjA3tfCY7uiaIWkExYn4cF/DhhYazubD/+AFDb8srQ/CZa63znJENtz82z+zAHinE2amkfdrZwxOhwXNBw8E6ZCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712249431; c=relaxed/simple;
	bh=I3wUW6qD9CEJ993pfHmt7cNytxgaYjo+MqnY+bwrqgg=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=oWp8zQL+QBuJV1X/ZYfNPNnnl8JIeB3MZtwDMSJgfwSTrrtvUXaIY4gy+HsQy/D50DT+1LwqkBBQONz6ZFKKtv8A5FxZ8mNIDSlSULdjOEF8hyUZKwQN9BdUuSIhP6f2Z15U+kEqppaf9PSwpIZ8RFVJQWzMZNZgyzdDbr6TI24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TCPwzQwP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TCPwzQwP"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 553D7C433C7;
	Thu,  4 Apr 2024 16:50:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712249431;
	bh=I3wUW6qD9CEJ993pfHmt7cNytxgaYjo+MqnY+bwrqgg=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=TCPwzQwP0vYKVv9EBUIGo/3AiDZIWz2tvAIT0WXh6LskcRLksBPBVQj1u81fDb5lg
	 GdecBy2DgFjqXYVGZL4yxnSreWyyGJnK9jIB9sf1Obtk373TF8xgaGu8UOJORO2/76
	 PgME11CgILvZncm3aWGm1l20kY71Fr71foPIGdezg4iX1XikEVKi9xcEAu4pPEX8vI
	 07S1VKlmfqT0QFqPqfUGjlfKV3ClgI7FiWFg29AvQaVWiu5mRUby4uGSZmv/bXUS9N
	 z0aNd52Y2W/ZzQ8vRt5oawfvdsY4LdNi+WVowM0N0paKyOQIiXAyfHUogrHapXq1vG
	 Rmke2fS3gE3Wg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 4683BD9A150;
	Thu,  4 Apr 2024 16:50:31 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] netfilter: validate user input for expected length
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <171224943128.12619.2837538958298672942.git-patchwork-notify@kernel.org>
Date: Thu, 04 Apr 2024 16:50:31 +0000
References: <20240404122051.2303764-1-edumazet@google.com>
In-Reply-To: <20240404122051.2303764-1-edumazet@google.com>
To: Eric Dumazet <edumazet@google.com>
Cc: davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
 pablo@netfilter.org, kadlec@netfilter.org, netdev@vger.kernel.org,
 netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
 eric.dumazet@gmail.com, syzkaller@googlegroups.com

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Thu,  4 Apr 2024 12:20:51 +0000 you wrote:
> I got multiple syzbot reports showing old bugs exposed
> by BPF after commit 20f2505fb436 ("bpf: Try to avoid kzalloc
> in cgroup/{s,g}etsockopt")
> 
> setsockopt() @optlen argument should be taken into account
> before copying data.
> 
> [...]

Here is the summary with links:
  - [net] netfilter: validate user input for expected length
    https://git.kernel.org/netdev/net/c/0c83842df40f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


