Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A36D284B4B;
	Thu, 10 Apr 2025 12:40:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744288803; cv=none; b=dXKDkuKnTtn91bsbekq/LsLmL9PuFLpAEs1aELj+2SSNfzHcNWPgMkmAf9ubK7bldIa7yD2fbkzOOrgdIOJvtAQJgi2cuhz1KJZ/XDfBTVfrIZgLtX0UmgZ2RrcIK1EdcZcSBz+MCYfNthfvyv74fmnQeH/oE4DHCDFICVpSRlg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744288803; c=relaxed/simple;
	bh=jZtzN/+Cb6gOitadW2d3v4gSNHImegz7YXSWHHoo5OM=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=D29KraCavj2GAI35grCA/lYm65ffOA74wEuoBelWDj0NqbNkr2z7UjauBsnrs5CoQ6jkoHSFgYC8883nCcjk8V6NQsGphHQGFIzcmkycwOBj3ebInGAJKiv6YfBL/xMTQUb4mo4cXdLzgrtasakPk+0y3j8YY6PM2qaGd4fCJbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=foBFv3Lm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="foBFv3Lm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4096AC4CEDD;
	Thu, 10 Apr 2025 12:40:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744288803;
	bh=jZtzN/+Cb6gOitadW2d3v4gSNHImegz7YXSWHHoo5OM=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=foBFv3LmT7zeJV9DYKupnQgXFsdcQDuyuULXQc+VS2eIdR+YjsuA1CgBnr4kvp5fp
	 h3EP4TyMYvglYDrqXihmCGBzeOFVeVM90zbmFs+UpWx8YhB4DQnsCu/2Lmj4oFwAYn
	 DQ8clJgm1R+fBAc6adOoEQ5CjD7YMgF9QgEiLpC+hY4M+cnihWwdU8DqU9Br+hHRtq
	 cu0wJJHAZqPVVt27SSSQax9X4Vl/ie5+STFGpmbVeXMp8UmugctXzexvTzgHXpgW2W
	 d6fZqvSWMmma129gwGp1cy5+rn0KEfR8fnWiRBRVvj92j9USfy+Ms7s3Ssgwu5SRoH
	 86sS5jhWgALAA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 001AE380CEF4;
	Thu, 10 Apr 2025 12:40:41 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/2] nft_set_pipapo: fix incorrect avx2 match of 5th field
 octet
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <174428884093.3651632.8182681897819384772.git-patchwork-notify@kernel.org>
Date: Thu, 10 Apr 2025 12:40:40 +0000
References: <20250410103647.1030244-2-pablo@netfilter.org>
In-Reply-To: <20250410103647.1030244-2-pablo@netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 edumazet@google.com, fw@strlen.de, horms@kernel.org

Hello:

This series was applied to netdev/net.git (main)
by Pablo Neira Ayuso <pablo@netfilter.org>:

On Thu, 10 Apr 2025 12:36:46 +0200 you wrote:
> From: Florian Westphal <fw@strlen.de>
> 
> Given a set element like:
> 
> 	icmpv6 . dead:beef:00ff::1
> 
> The value of 'ff' is irrelevant, any address will be matched
> as long as the other octets are the same.
> 
> [...]

Here is the summary with links:
  - [net,1/2] nft_set_pipapo: fix incorrect avx2 match of 5th field octet
    https://git.kernel.org/netdev/net/c/e042ed950d4e
  - [net,2/2] selftests: netfilter: add test case for recent mismatch bug
    https://git.kernel.org/netdev/net/c/27eb86e22f10

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


