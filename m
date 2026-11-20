Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795141209;
	b=I+BiXQB4TI7KPHEFhBAabxOxsl7jrC4itAik5dG8QpcFrThc5vI+scJKyPzaM4A02VkP
	 WAVch3KhL+l8af7JQ85ZOEbEqeFtrT9U1HADiiitqBi6TxsFaOzf0Mp2WpLmzUQF925Wv
	 Q2jObH9G0OFDy4I7HgN80JqONd9jGGtCbbOv69hqfd9WSw7VJWv/EVSsgUmJkt7ONYrpz
	 KB0ccc91wkakUgoCeHQ3tijVZyVaKEwcLFDXxFCRgH2JCws2M2LzfQNodABTvKxppCAuI
	 DP902ZnGN/OB3c6XmQeNxq+264Zckx4sLelZ0Yz5b+1QEtgg8UrcSKa/fX6/llbmQNw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795141209;
	h=Received:DKIM-Signature:Received:Content-Type:MIME-Version:
	 Content-Transfer-Encoding:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc;
	bh=mfJyAF4Nrl+hgTB1RD7oeC4gMN7pBo8CsmEpvgXkV68=;
	b=Z7sxUJ1OmSyxRH8BbR+IXRmcP8pjnCUuTKmJtfHSl/yEhQXA7xwB6DZgJB72onIQcrHG
	 QcW7KTym33n8lGkbYjPrUMT5VxHsnWh6lpWzYgLUhnr+Sghbs9sZJrWJIletaUoRUjZC6
	 bt7P5+yhjIUJyeiveaGG/NMFxC81II2Q23s7SDmooo4Uon5zxMnIVOQr6TAaZMjOrAPFs
	 Cpmk74DyMYkIpGd5hi1606NOKqCIjY19i2YxRI/5LQoN0ziXFxnmLoEViBGpo0cuNV62c
	 x6oGyr+ZpqXz4RuMBznYxrf6+MiPCRiV2RECZCBF1qPCcHMy3GK8+kKf3jxMPiETH3g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=m+LG1K9b;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FB38606A320;
	Fri, 20 Nov 2026 02:20:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=m+LG1K9b
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06E711F000C4;
	Fri, 20 Nov 2026 02:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795141209;
	bh=mfJyAF4Nrl+hgTB1RD7oeC4gMN7pBo8CsmEpvgXkV68=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=m+LG1K9bvGCj2R2kG8VaDT0ED2pIi/KORQkjlzO1qsGLGLRn5bB9VbcEpODdxY0xn
	 f7KeMnyZ+DefcVHOfVI6EUb7PLXyagaWfTs8NADjgD7LS2vgchej+xdeiuwzGYYxZN
	 r6kbiD32Cmk3/KmIDICo4aHlt1C7sC0xVpEP0BYsVydoLfwfCqgy28alOLSuy82ISd
	 Ga9F5rg0uc9d0nhY4K2JEN7sBUvxjL9I1fQcEBSog2JS8FIKZwSYJpzEe/AXrLYYAY
	 CAW/opvXrZ63KGXjYfxlGo2Xme9+CbQF/tCIZtIOF7gC0Rx0IWEZoMtZt5RN+3hyey
	 XgpzZaeKHucnw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id F15A83808209;
	Fri, 20 Nov 2026 02:20:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: dropreason: add
 SKB_DROP_REASON_FRAG_MEM_LIMIT
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <179514120753.3982074.11609481457097425457.git-patchwork-notify@kernel.org>
Date: Fri, 20 Nov 2026 02:20:07 +0000
References: <20261118070524.310356-1-jiayuan.chen@linux.dev>
In-Reply-To: <20261118070524.310356-1-jiayuan.chen@linux.dev>
To: Jiayuan Chen <jiayuan.chen@linux.dev>
Cc: netdev@vger.kernel.org, davem@davemloft.net, edumazet@kernel.org,
 kuba@kernel.org, pabeni@redhat.com, horms@kernel.org, alex.aring@gmail.com,
 stefan@datenfreihafen.org, miquel.raynal@bootlin.com, dsahern@kernel.org,
 idosch@nvidia.com, pablo@netfilter.org, fw@strlen.de, phil@nwl.cc,
 linux-kernel@vger.kernel.org, linux-wpan@vger.kernel.org,
 netfilter-devel@vger.kernel.org, coreteam@netfilter.org

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 18 Nov 2026 15:05:19 +0800 you wrote:
> This is used to track fragments dropped when the reassembly memory is
> over the limit (ipfrag_high_thresh, ip6frag_high_thresh).
> 
> Fragments dropped because high_thresh is 0 get this reason too, the
> same way they are counted in IPSTATS_MIB_REASMFAILS.
> 
> Tested with pwru.
> 
> [...]

Here is the summary with links:
  - [net-next] net: dropreason: add SKB_DROP_REASON_FRAG_MEM_LIMIT
    https://git.kernel.org/netdev/net-next/c/2cb41b6bea62

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


