Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F4B71607B0;
	Thu, 11 Jul 2024 11:10:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720696233; cv=none; b=dvfw7wy9toxQziAwjJH2023Ql5rKplmxyhB953yRfo6FUXVWqWZAKfEAkQ8JxmZigdeugUXUJp0caNarc5ZnMhASlklnfFIk/EDAUimiALMznIWs5eJ+RBSG0XyKwc1Nm5dUpBXKyUX3l8sFV4gJfKgd8loSB8xVYSYwm9wBZWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720696233; c=relaxed/simple;
	bh=4hKIMYTmtAdNLMixl2zs0Yg0I2YHp3wPsGiGjgoumBE=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=TpRWoyp10lOOMhXFCET4fwIKHLbnMIP4dN5TYqDY/PucA0bFz6c8GyaJ6dAmTK/z9bLtcGoKZiclXPitakH93sfX4yp6yoEx344721zE5b4xECgmOy4Smnpf2QB3laMTdOdDDPBhR5wqxMhZ+SkiV3xwBThxvGiVRL9buJRwuPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ELLpf1Sx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ELLpf1Sx"
Received: by smtp.kernel.org (Postfix) with ESMTPS id EDD6BC32786;
	Thu, 11 Jul 2024 11:10:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720696231;
	bh=4hKIMYTmtAdNLMixl2zs0Yg0I2YHp3wPsGiGjgoumBE=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=ELLpf1SxpnHV4OWR8+YrAFq4udugrBcXBvR7tL8cVNqpkW9yKVpH/wCrjdxOPTD7s
	 /vlFndpM30OIwb46Nl1ZSI4xaycwOE7X/kgT4IIjgukv4U400uZdxDity3Fh0Y51Qj
	 HioKzUBkQk71MsPrNvNIoMfPuN8lsPdD3HKSd7gBoNU3ZSb7G/buA8OqffCpv8YBDX
	 UqdgA6KOjLypSifVU3Ameg8OHecimpu819wVvwVARxf2yu8nZsWmuowL7878uqpPH9
	 FXaLYbM8C1mpl42/0vatx5OO/R/qData+X4E7g0ReIc8pADYeS9+6j2q8OGmeHWoBJ
	 f+fsfK4jQUZUQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id DB252DAE95C;
	Thu, 11 Jul 2024 11:10:30 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/2] netfilter: nfnetlink_queue: drop bogus WARN_ON
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <172069623089.9362.7077661478574364269.git-patchwork-notify@kernel.org>
Date: Thu, 11 Jul 2024 11:10:30 +0000
References: <20240711093948.3816-2-pablo@netfilter.org>
In-Reply-To: <20240711093948.3816-2-pablo@netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 edumazet@google.com, fw@strlen.de

Hello:

This series was applied to netdev/net.git (main)
by Pablo Neira Ayuso <pablo@netfilter.org>:

On Thu, 11 Jul 2024 11:39:47 +0200 you wrote:
> From: Florian Westphal <fw@strlen.de>
> 
> Happens when rules get flushed/deleted while packet is out, so remove
> this WARN_ON.
> 
> This WARN exists in one form or another since v4.14, no need to backport
> this to older releases, hence use a more recent fixes tag.
> 
> [...]

Here is the summary with links:
  - [net,1/2] netfilter: nfnetlink_queue: drop bogus WARN_ON
    https://git.kernel.org/netdev/net/c/631a4b3ddc78
  - [net,2/2] netfilter: nf_tables: prefer nft_chain_validate
    https://git.kernel.org/netdev/net/c/cff3bd012a95

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


