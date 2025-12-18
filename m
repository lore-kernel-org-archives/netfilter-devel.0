Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7BEA34165E;
	Thu, 18 Dec 2025 13:13:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766063603; cv=none; b=c+NwnpCrxFYyEia1AxD4pDh7J52zTjva1I7/kbbO5onDgA/+YEXKCo/8YJ7XscZHz8pi9dI0x6FGIMSlx1u5Y1DdG6OpK4qQASy+fliOS2Sw006Atd/d/upUcbz0p6XlgPu+pimEUjTykO0utMhMR9qEQQzm0jtMYXQhVgWwD8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766063603; c=relaxed/simple;
	bh=vgVok/kR5phQdGcyQzsaXUO5SngPNNzKGfR3VoPT6Pg=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=Cl8JCSRy79zP1JSKiVs0YT1K58PMUcRke0QX3/Vrsf7UGJ0qM1nfYiCi1RkK/CD0xSKs4BeYuwpPEmlBwroOgqSLyZaufA7b4so29rQ9uuABLcNW84v3GNrF7cL9nDV7pMAuwwIm9APOAuEfQOdO4+qz2qpTxq8jpIEeNNK/rEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ojvj+r0v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ojvj+r0v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46641C4CEFB;
	Thu, 18 Dec 2025 13:13:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766063602;
	bh=vgVok/kR5phQdGcyQzsaXUO5SngPNNzKGfR3VoPT6Pg=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=ojvj+r0vzjlshyJ84ht0SoMMsSvM/VpR8MMwRC06guL76Xqjj1jh95iJJHk2GVPmi
	 5mlEeLND3fH0Q3AAXu+AtfjBlLXDMnTqwLmWtlc33U5Z5veI9vIkViz3qIqZS3onu8
	 qHkjLYbFKyLKtm43guKmtstJZEolW4nU++G2ya9Kmr9N1B0n7tpCyVU6g369GUeVuv
	 KtnU9Oaj12ONcWg2eJQapHH0BvgTz4UoLwGC4wNpLwHc4kUz8B92RMP/z6Nx8jdAhd
	 a338QWt8EWrgH8hSVkBDS3Heaq0VqBUCOnd0r65IHEx9VUdOGVC8m/pjii+7xZhOxl
	 5kGaBDV2AHyoQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id F33D1380A955;
	Thu, 18 Dec 2025 13:10:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/6] MAINTAINERS: Remove Jozsef Kadlecsik from
 MAINTAINERS
 file
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <176606341180.2948593.16330889517640025371.git-patchwork-notify@kernel.org>
Date: Thu, 18 Dec 2025 13:10:11 +0000
References: <20251216190904.14507-2-fw@strlen.de>
In-Reply-To: <20251216190904.14507-2-fw@strlen.de>
To: Florian Westphal <fw@strlen.de>
Cc: netdev@vger.kernel.org, pabeni@redhat.com, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, netfilter-devel@vger.kernel.org,
 pablo@netfilter.org

Hello:

This series was applied to netdev/net.git (main)
by Florian Westphal <fw@strlen.de>:

On Tue, 16 Dec 2025 20:08:59 +0100 you wrote:
> From: Jozsef Kadlecsik <kadlec@netfilter.org>
> 
> I'm retiring from maintaining netfilter. I'll still keep an
> eye on ipset and respond to anything related to it.
> 
> Thank you!
> 
> [...]

Here is the summary with links:
  - [net,1/6] MAINTAINERS: Remove Jozsef Kadlecsik from MAINTAINERS file
    https://git.kernel.org/netdev/net/c/99c6931fe1f5
  - [net,2/6] netfilter: nf_nat: remove bogus direction check
    https://git.kernel.org/netdev/net/c/5ec8ca26fe93
  - [net,3/6] netfilter: nf_tables: remove redundant chain validation on register store
    https://git.kernel.org/netdev/net/c/a67fd55f6a09
  - [net,4/6] netfilter: nf_tables: avoid chain re-validation if possible
    https://git.kernel.org/netdev/net/c/8e1a1bc4f5a4
  - [net,5/6] netfilter: nf_tables: avoid softlockup warnings in nft_chain_validate
    https://git.kernel.org/netdev/net/c/7e7a817f2dfd
  - [net,6/6] selftests: netfilter: packetdrill: avoid failure on HZ=100 kernel
    https://git.kernel.org/netdev/net/c/fec7b0795548

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


