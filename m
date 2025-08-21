Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C0BF1DFCE;
	Thu, 21 Aug 2025 17:19:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755796798; cv=none; b=eBYHdbscJcz8bAoLDq8rtd1LQgcwXakMbupnT1VkdwaHCLS804XcOM5Xkk8Y15OQiUL2wluEHKr/IfcaLkFrkBwBUhVfkZotJ6PrN/LBO1qW2O374XZhUM58GSco002Zycsu43G25sPqsNo7gdkK26AWlgDmAduoe8vF0RGgrI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755796798; c=relaxed/simple;
	bh=srJorbUHKfSOi1LHnSkKnV8R63yQ/pJFq1r03NxyH20=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=cjXsQUa29X0NlyT2xLrKj7Q6pMyU6fKI0xLiF7etTUoq44qddAr26vMm2LE1eXuQPMrMUQ+MZFsyAPgDcr+apOwfspi02EyuCWYvvugGPS6YuIDzxzBz1EcwqPuAocf8YVB+MPyLTi4b7p4EIK+WjAvWW6HuoEEP+Dq9hdVUXJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=k2XyAQtJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="k2XyAQtJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B43B2C4CEEB;
	Thu, 21 Aug 2025 17:19:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755796796;
	bh=srJorbUHKfSOi1LHnSkKnV8R63yQ/pJFq1r03NxyH20=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=k2XyAQtJoRyhI7mW4or3koFKnvUNj8bARuVPU3XZHa53GQ9Z6xXHdo31KgVfHnWdp
	 nAMdWHhmNeS/dG0f2QKTHfl4n79R6GIWjDLt3b4Ht80H8sOxA73gJ4Wrjf0vIKxZ3L
	 Lhmoc5g/YuZ9IN3Sf9Tc7KbXxwDKYV4Je9CTqqkobQRuUSJ+tPWCjeaIz4r+4Tm4Sv
	 NDcHGzt+MLW6DaX+yTMD2gYVwxupr6ehm+1rGnkS35Rg93Z7LQx/QRZzgp60QAbB8O
	 4JzO4ZeAwHIKX8aDdd01EA45ruRnxDxTHls42NdGQ3UGTrsTnl5xwgg51pa7xQfS8i
	 YfTljyD/Uyjew==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 33C15383BF5B;
	Thu, 21 Aug 2025 17:20:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] netfilter: nf_reject: don't leak dst refcount for
 loopback packets
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <175579680600.1120781.8221767043922846856.git-patchwork-notify@kernel.org>
Date: Thu, 21 Aug 2025 17:20:06 +0000
References: <20250820123707.10671-1-fw@strlen.de>
In-Reply-To: <20250820123707.10671-1-fw@strlen.de>
To: Florian Westphal <fw@strlen.de>
Cc: netdev@vger.kernel.org, pabeni@redhat.com, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, netfilter-devel@vger.kernel.org,
 pablo@netfilter.org

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 20 Aug 2025 14:37:07 +0200 you wrote:
> recent patches to add a WARN() when replacing skb dst entry found an
> old bug:
> 
> WARNING: include/linux/skbuff.h:1165 skb_dst_check_unset include/linux/skbuff.h:1164 [inline]
> WARNING: include/linux/skbuff.h:1165 skb_dst_set include/linux/skbuff.h:1210 [inline]
> WARNING: include/linux/skbuff.h:1165 nf_reject_fill_skb_dst+0x2a4/0x330 net/ipv4/netfilter/nf_reject_ipv4.c:234
> [..]
> Call Trace:
>  nf_send_unreach+0x17b/0x6e0 net/ipv4/netfilter/nf_reject_ipv4.c:325
>  nft_reject_inet_eval+0x4bc/0x690 net/netfilter/nft_reject_inet.c:27
>  expr_call_ops_eval net/netfilter/nf_tables_core.c:237 [inline]
>  ..
> 
> [...]

Here is the summary with links:
  - [net] netfilter: nf_reject: don't leak dst refcount for loopback packets
    https://git.kernel.org/netdev/net/c/91a79b792204

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


