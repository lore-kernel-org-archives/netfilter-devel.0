Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1D7347DD5A;
	Tue, 21 Jul 2026 10:40:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784630444; cv=none; b=dQSIzAUeyfHKfb1cB8fNjHyLIT8fniNcVBIzYrCdDyRR4m+q5iqjjkuxNj4Sv+Ym30xLUE65dY25Yti7ScFc0xp/I1aiyX2FinYymfJC+6ODlpY98BY4oL1mW3Z/wji6EozTK0+/EVN6iDFzZc4Up8a7LW/MdpWgw7xnH4vHzws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784630444; c=relaxed/simple;
	bh=HRy9gKga92/H7C/aymWvkurgdYfhGDgjW8M480dcD7s=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=WczhWcF0GY1kQYMYEkxHxLHq1oMoNga5D8NHv7tNK+a47ik1JQvDnboKq+MNK2z8xPkMcrwLvPCnVTU1BctC4keXLHv1liI4/inrDo/HWq7NVDrZNXhIkChV05pH30Albss6EZTOxk4m33ieoMCrCBQAb9nDWuEb2i9aLyO4IfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lkMd4k//; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lkMd4k//"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96E0E1F00A3D;
	Tue, 21 Jul 2026 10:40:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784630442;
	bh=rIM3YfmxfasNealaHX0MrKeA16cFP1pZgybt41B7t04=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=lkMd4k//tLJJA/NDqGvbBURXz5CJUtyZotSS+4zcc8opGfb0XinfFdd1u4QvXub52
	 JWCzWlz96wdpQc73QuviBremYj8LRBdcFVRcrb/XU2kWyFH02Lk0aL3Hb7q5ok0mrm
	 uApaoYrYFZ9VtxFglO8kvON7DVwHuPvpVfA5RAR+T2EpmqKZnDhCjHteEwoPb+LorF
	 AM631ByBNZ8KGfWVtnOSwANKUHWg73mzr8IrB+u5gZq3hQh2rLQS4rWBK3CpnLpJ9C
	 ObWipShDHcNriWq9jmgvU/XhafTWD4Bjx5TqXhNKplgDBhBHXY2ZoIe2AFJVgXZa/j
	 x1uY3vtEQ7mOA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 93A963924A70;
	Tue, 21 Jul 2026 10:40:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: ipip: use tunnel parameters for
 fill_forward_path route lookup
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <178463041214.221494.11968579734449028888.git-patchwork-notify@kernel.org>
Date: Tue, 21 Jul 2026 10:40:12 +0000
References: 
 <20260708-ipip-route-lookup-fill_forward_path-v1-1-b77df74822ed@kernel.org>
In-Reply-To: 
 <20260708-ipip-route-lookup-fill_forward_path-v1-1-b77df74822ed@kernel.org>
To: Lorenzo Bianconi <lorenzo@kernel.org>
Cc: dsahern@kernel.org, idosch@nvidia.com, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, horms@kernel.org,
 pablo@netfilter.org, fw@strlen.de, netdev@vger.kernel.org,
 netfilter-devel@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by Paolo Abeni <pabeni@redhat.com>:

On Wed, 08 Jul 2026 13:25:18 +0200 you wrote:
> Pass source address, DSCP and output interface from the tunnel
> configuration to ip_route_output() in ipip_fill_forward_path(), aligning
> the route lookup with the slow path in ipip_tunnel_xmit().
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
>  net/ipv4/ipip.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> [...]

Here is the summary with links:
  - [net-next] net: ipip: use tunnel parameters for fill_forward_path route lookup
    https://git.kernel.org/netdev/net-next/c/f6195e3c3026

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


