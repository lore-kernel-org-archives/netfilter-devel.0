Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8A86149E17;
	Fri, 11 Jul 2025 01:49:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752198594; cv=none; b=so25raNXLwjCqOH5ohf1PIYDicDHkDDMn229eF+zTLnJOKGoxM8F+5t91DigLfum80Tuc0cZW8no1EpZ/yTNZZrKIBT2Au8EASDiJ7oEk9DMphzDDmwmX3CK1rHjrQ6PdUr2OprhmeJRwzzuwEckkl4eGSV8r4nsJYyXDVe23Sg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752198594; c=relaxed/simple;
	bh=6qdlX+BArxzatPjQKfku5qGPnlaIjLLeDt7xiA3QmwY=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=jL4eu6EcR/i8lT7E8RJJT3rFDLXMBIKifPPwnXmQANJOoKojK9S9SzMHBYt+CukM0Hz+ZScB1nxdWjP+YM6KuvGaTxcvYJ9W/qqiaTWCWw5eMEjbxC0uqY60ZxVwrZ32usODFz2dv+wBjm9FAs4pIbip9QwrO3dBVrUdUpsU7u4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Lx6Fyup6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Lx6Fyup6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C022C4CEF7;
	Fri, 11 Jul 2025 01:49:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752198594;
	bh=6qdlX+BArxzatPjQKfku5qGPnlaIjLLeDt7xiA3QmwY=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=Lx6Fyup6U4MyU75HXSHYuxNbqjdp7+c5+oWfmgAJizHNBV3/WRvWMIAx6IMyCYU7X
	 d+yLugnDK2WOFyrQ2Io3eyysxtKOk1tExeqFwJEDEiF8kQzTPb4cgKkH0GRYALw/7A
	 JWaGFQp+3mWnIdlrSfmAUEZAG9qjTyyT/W2PV5wiSLioPx64kk49C3dVPCoR94qw7h
	 ppp0sCpjdB5c1OzFKvs/rC1p7dV1tYARLfUlF/FRHGyne86QYxw2jCGCwr+4UU1Kr0
	 wS4OM1/XQ7E+4tuoSsyts5CMEeoOX4DTuks0zwnMGDaRjVhwpNsoifF8PeHWbP8Cof
	 pil0arMjkWcCA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id ADCF8383B266;
	Fri, 11 Jul 2025 01:50:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 1/4] netfilter: conntrack: remove DCCP protocol
 support
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <175219861629.1732536.14715819729944005611.git-patchwork-notify@kernel.org>
Date: Fri, 11 Jul 2025 01:50:16 +0000
References: <20250710010706.2861281-2-pablo@netfilter.org>
In-Reply-To: <20250710010706.2861281-2-pablo@netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 edumazet@google.com, fw@strlen.de, horms@kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by Pablo Neira Ayuso <pablo@netfilter.org>:

On Thu, 10 Jul 2025 03:07:03 +0200 you wrote:
> The DCCP socket family has now been removed from this tree, see:
> 
>   8bb3212be4b4 ("Merge branch 'net-retire-dccp-socket'")
> 
> Remove connection tracking and NAT support for this protocol, this
> should not pose a problem because no DCCP traffic is expected to be seen
> on the wire.
> 
> [...]

Here is the summary with links:
  - [net-next,1/4] netfilter: conntrack: remove DCCP protocol support
    https://git.kernel.org/netdev/net-next/c/fd72f265bb00

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


