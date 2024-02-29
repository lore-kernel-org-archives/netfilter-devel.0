Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBF545EE9F;
	Thu, 29 Feb 2024 11:40:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709206830; cv=none; b=Ox/FRqbpFieN6nn8nVzIllh18bKY2Slewx6KgBfvO2BxWtPQfV8oJLjY8bUo6Ru9+agAcj4j8dlDg5Vo26bIQRZrJPJxKYP+9gneCDfPmWBW1r6lcBAvoJyU8QjGJ18rkWIhM75kKFjxrd5kwr1ujIXeoZ7DnYsuhEq+L2YTcag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709206830; c=relaxed/simple;
	bh=ZKXe+Qg2W4somEFKLjM7zfljrZuuLuqexiwK4tDZZ8o=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=m1SptqMLKb2S0bbeAtrxLwbiz1jwRECvDzQkndMMMWXQ/CSMx1qy5oCPi7Nj5ofocUeIQ0bb0qs2DSpQeMTV1X6qPaRnugZcRJAI0nZjPON3oGO0sXOtdIqmhdTMEhwSjYx79WpfwljIhlBI1zkJ7m/u/Omtmsh8pfGz+QDNeWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZIyA9lP3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZIyA9lP3"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5E42CC43394;
	Thu, 29 Feb 2024 11:40:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1709206829;
	bh=ZKXe+Qg2W4somEFKLjM7zfljrZuuLuqexiwK4tDZZ8o=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=ZIyA9lP34Qhsf08b/ZBrbCwRGfVD6ZOIy4ue69Xz2M/6L9NUxZEvM3ycR0wM1qyI4
	 gZ9yi8xDp4qOL9WrXQeClFjtEqIdQMPOJLTY4xi9Ja5pHst+4wkFuRdVFpKwuHExK6
	 Vdgu69T41CUV4jhFLFdwB+14vdHVnt1mWKWiZSZkbaSHTDOVIM29nLPDZ5pQgBT2T0
	 ZL4bqqJATEVQxxtgxqMYlYlX24lX88tqoaaafMYOE93ZtlFgIRQgA+kanzFX7mIq58
	 9jKr0sMuJCo12YSD8xzdp2N1rsP1f9Y+V0gUPAtEak/r7FTJfQRfshFtwVrfjOlovT
	 Fly6+qN1uojNA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 4820EC595D2;
	Thu, 29 Feb 2024 11:40:29 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/3] netfilter: nf_tables: allow NFPROTO_INET in
 nft_(match/target)_validate()
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <170920682929.10157.5213246520413080680.git-patchwork-notify@kernel.org>
Date: Thu, 29 Feb 2024 11:40:29 +0000
References: <20240229000135.8780-2-pablo@netfilter.org>
In-Reply-To: <20240229000135.8780-2-pablo@netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 edumazet@google.com, fw@strlen.de

Hello:

This series was applied to netdev/net.git (main)
by Pablo Neira Ayuso <pablo@netfilter.org>:

On Thu, 29 Feb 2024 01:01:33 +0100 you wrote:
> From: Ignat Korchagin <ignat@cloudflare.com>
> 
> Commit d0009effa886 ("netfilter: nf_tables: validate NFPROTO_* family") added
> some validation of NFPROTO_* families in the nft_compat module, but it broke
> the ability to use legacy iptables modules in dual-stack nftables.
> 
> While with legacy iptables one had to independently manage IPv4 and IPv6
> tables, with nftables it is possible to have dual-stack tables sharing the
> rules. Moreover, it was possible to use rules based on legacy iptables
> match/target modules in dual-stack nftables.
> 
> [...]

Here is the summary with links:
  - [net,1/3] netfilter: nf_tables: allow NFPROTO_INET in nft_(match/target)_validate()
    https://git.kernel.org/netdev/net/c/7e0f122c6591
  - [net,2/3] netfilter: bridge: confirm multicast packets before passing them up the stack
    https://git.kernel.org/netdev/net/c/62e7151ae3eb
  - [net,3/3] selftests: netfilter: add bridge conntrack + multicast test case
    https://git.kernel.org/netdev/net/c/6523cf516c55

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


