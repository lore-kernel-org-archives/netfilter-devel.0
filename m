Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 875A71DA632;
	Tue, 14 Jan 2025 11:20:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736853610; cv=none; b=FkqxgEKzQ5dqD2hjHHLJK9mQguHvEq2tZvKLpbAyRq/NutxiI4eJhQqjCfdf+U39H9kKShhWq6iR+HdTDnIVOl58LIwAmG8ZD0i6xSFTijqfNtuvATD1za+tQhX/5CP3WX4kX6SdhSWHCra/qym/o/JnBQDHTHJy8HV3u3LeLPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736853610; c=relaxed/simple;
	bh=rtSuoYZ8+u7cOPC1UoChNdOz/UVNmfAvyoY+o51ePSE=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=ZpYa6iMld/4vgacNT0+B+1USvPnKImy99jGVzdlqxGS3MBVS8mV2xKwEBSVhqNDmr4xKeYHD07ExG0peRjnYkff10jSGVLfBJFWbyh/MEto74epunXup09wbX2M1PPDt1A23t35zN+z87xs1torVLmMmhW/E2g5vmoCwpIVIhvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FhX2sWbJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FhX2sWbJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13CF1C4CEDD;
	Tue, 14 Jan 2025 11:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736853610;
	bh=rtSuoYZ8+u7cOPC1UoChNdOz/UVNmfAvyoY+o51ePSE=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=FhX2sWbJtWbJfYBiw/KcDzcX04xoU3PvKVpm2Lu3vMwfQpxywRaPgwDviRxTvTryB
	 B6BPWUjDFFw5WEeYvIUQM2VQyVdHKxum+BFDLGsXuwnIW4bxzDSWqEgLqyVH9qqBp8
	 yQWxbjrL46KUoMVxa1g8LU0ACsjpqw2TAc1V1Z98k8tnTzMcNkhcRAn1TgvMcY2UwL
	 3BPfIIf2M+W1ZM458fG4vjRH9rAd6DkwV+4TVv+sBNBH+0mGCEsx07KdGEdCt5u0nE
	 QvD1Vk0rWN83vMUNgKXl6f0J4FnVUXqolR+8Zhs7Wz7ONJ0pV3xOwqPp1wA+tfzYTg
	 502/DQisXZF5g==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id EB192380AA5F;
	Tue, 14 Jan 2025 11:20:33 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 1/4] netfilter: nf_tables: remove the genmask
 parameter
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <173685363276.4143472.17608678538687236861.git-patchwork-notify@kernel.org>
Date: Tue, 14 Jan 2025 11:20:32 +0000
References: <20250111230800.67349-2-pablo@netfilter.org>
In-Reply-To: <20250111230800.67349-2-pablo@netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 edumazet@google.com, fw@strlen.de, kadlec@netfilter.org

Hello:

This series was applied to netdev/net-next.git (main)
by Pablo Neira Ayuso <pablo@netfilter.org>:

On Sun, 12 Jan 2025 00:07:57 +0100 you wrote:
> From: tuqiang <tu.qiang35@zte.com.cn>
> 
> The genmask parameter is not used within the nf_tables_addchain function
>  body. It should be removed to simplify the function parameter list.
> 
> Signed-off-by: tuqiang <tu.qiang35@zte.com.cn>
> Signed-off-by: Jiang Kun <jiang.kun2@zte.com.cn>
> Reviewed-by: Simon Horman <horms@kernel.org>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> 
> [...]

Here is the summary with links:
  - [net-next,1/4] netfilter: nf_tables: remove the genmask parameter
    https://git.kernel.org/netdev/net-next/c/da0a090a3c62
  - [net-next,2/4] ipvs: speed up reads from ip_vs_conn proc file
    https://git.kernel.org/netdev/net-next/c/178883fd039d
  - [net-next,3/4] netfilter: xt_hashlimit: htable_selective_cleanup() optimization
    https://git.kernel.org/netdev/net-next/c/95f1c1e98db3
  - [net-next,4/4] netfilter: conntrack: add conntrack event timestamp
    https://git.kernel.org/netdev/net-next/c/601731fc7c61

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


