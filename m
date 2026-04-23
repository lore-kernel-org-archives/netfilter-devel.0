Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B02AF3E4C8E;
	Thu, 23 Apr 2026 09:30:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776936653; cv=none; b=Vp47YiG2ajUhaXIMNuEXWH91LAHyOjELG3oO3O+LG2XPtwIBTh52nDn9CA/uFWyg9iyWFgAfvY+dPOiaFLIC+i1TJ8o6adqA79f0dzqNiG1Ym5ztYt4UEYhvGtmSszw2rIvVi3B1jFkMuCbRu86O02j8y7qmbtGTTkomsuPHg+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776936653; c=relaxed/simple;
	bh=xTAI9xIr1VqM9v3nC9pXYRhVtz4waWq5chM0ORi9Wbg=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=Q78ZwQCNkapRA6EyqsmO6GuKrDCqfdF6S/C7vDZS1uWzG5Ni9s8gMmtSeWTWQTfcsWQc/2OHSuEj8fveqlpNyI8sO3FAcLjPkc2ZvjsyD0cB4KMBoYMYDgJ174UKtmLOerirha9jzxEuAxS2C1xdXjhyUPdkF14Sgjx9EkbToec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CaunIDfd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CaunIDfd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C639C2BCAF;
	Thu, 23 Apr 2026 09:30:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776936653;
	bh=xTAI9xIr1VqM9v3nC9pXYRhVtz4waWq5chM0ORi9Wbg=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=CaunIDfd4/pt10XfBFZ0GfjQRfAXfNICMw6MfenaiMV35NlnfkZj3YBQQ60H3wmyI
	 Z0cYjgZgdEP3jzd7bZ8eF1+cpp+qalyX8N5bjOhOvwF9TvTeT/deNo0nRrV/wOLV4D
	 h7EW3qu7V7Bd0FK2yKa5j0DOmhv9FTs/PYAbfeEYZ8+/DIRrNAaBBZiXS0YwyLgdWy
	 KVjZVPZFdcWql7CkDSXYMkEJuBGkw9nrokRP9QhA9OcweJMbxJHHgbBFTtr/NVQiw1
	 kzwYmCQHDnGrL/2PDGNUWMxdnaB76crtp8H7naXdQOcWORsQDY0NfCs3dMRV9o+cZM
	 +cMi399n851uw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 3FD82380CFF9;
	Thu, 23 Apr 2026 09:30:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/8] netfilter: nft_osf: restrict it to ipv4
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <177693661488.73226.2217297170932768226.git-patchwork-notify@kernel.org>
Date: Thu, 23 Apr 2026 09:30:14 +0000
References: <20260420220215.111510-2-pablo@netfilter.org>
In-Reply-To: <20260420220215.111510-2-pablo@netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 edumazet@google.com, fw@strlen.de, horms@kernel.org

Hello:

This series was applied to netdev/net.git (main)
by Pablo Neira Ayuso <pablo@netfilter.org>:

On Tue, 21 Apr 2026 00:02:08 +0200 you wrote:
> This expression only supports for ipv4, restrict it.
> 
> Fixes: b96af92d6eaf ("netfilter: nf_tables: implement Passive OS fingerprint module in nft_osf")
> Acked-by: Florian Westphal <fw@strlen.de>
> Reviewed-by: Fernando Fernandez Mancera <fmancera@suse.de>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> 
> [...]

Here is the summary with links:
  - [net,1/8] netfilter: nft_osf: restrict it to ipv4
    https://git.kernel.org/netdev/net/c/b336fdbb7103
  - [net,2/8] netfilter: nfnetlink_osf: fix divide-by-zero in OSF_WSS_MODULO
    https://git.kernel.org/netdev/net/c/2195574dc6d9
  - [net,3/8] netfilter: conntrack: remove sprintf usage
    https://git.kernel.org/netdev/net/c/6e7066bdb481
  - [net,4/8] netfilter: xtables: restrict several matches to inet family
    https://git.kernel.org/netdev/net/c/b6fe26f86a16
  - [net,5/8] netfilter: nat: use kfree_rcu to release ops
    https://git.kernel.org/netdev/net/c/6eda0d771f94
  - [net,6/8] ipvs: fix MTU check for GSO packets in tunnel mode
    https://git.kernel.org/netdev/net/c/67bf42cae41d
  - [net,7/8] netfilter: nfnetlink_osf: fix out-of-bounds read on option matching
    https://git.kernel.org/netdev/net/c/f5ca450087c3
  - [net,8/8] netfilter: nfnetlink_osf: fix potential NULL dereference in ttl check
    https://git.kernel.org/netdev/net/c/711987ba281f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


