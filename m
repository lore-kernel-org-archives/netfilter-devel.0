Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7240A149DF4;
	Thu, 19 Dec 2024 09:10:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734599411; cv=none; b=rCP91GRRVNE+MFaItCz8aA3xswlK8sywwxHIDzop2iEQNhYwu9pvqgmEtrMdVvTnGGcXCao8MG/jgBZHvq0VGtmPXMpUeFEz3YwyAb8A553VnsE6O2U3q+ySfqSTWX8xa2IwO2sNbFjQglnyM4scBj+hk+oFTv4IZkcbRoRYJ24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734599411; c=relaxed/simple;
	bh=VYAOV0DQQggPY2XmjJx09Xty29Hn2skvfDGqACr2QpI=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=MpTCoEnnH76MY7Zcyvwk+X4iUEAQNwyz2ND2CfVNtGGitZ9g6Z2rjkhchsgNAmRKOMYHj7eH68zmsnR7oyT7bKhgOGII7dTrzZUlSEVp9Rgp5yuSABBqoSJa0Q9HjBSmOyKUNuQ3Iy3C1Uz1ltTBp3Szr1b4U8dH0uLaDXwDMwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F6/Z/kej; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F6/Z/kej"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5DD4C4CED0;
	Thu, 19 Dec 2024 09:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734599411;
	bh=VYAOV0DQQggPY2XmjJx09Xty29Hn2skvfDGqACr2QpI=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=F6/Z/kejTxoCZqW+Mj3gLNbc0+CDeS3X/zdp1MUaJwLB+3zHVxFtIEyA4dHNGRwic
	 2chdZCJKxsa2UsidXjHByNJHr2CKcq8+/2Q+KELhh6sb5mYCsXa2Bo0a/ESHdkDeBE
	 eJT2WeeyFcmWWgECKFrx6ygZZF8V50KEzfgaQLcjGF/7vFlmhS16HDxONZmHMkQeOd
	 I5mRy3zboIyO5IOHZARR+OhcXBaB/kaY7vif4xhnQeFz3HM+lh+PHGFweyX88LDFog
	 fQ354put+wzCPYAX0fF+HTgH6G/efXiYY3rGi23sj4XAMzL0K12b7N0TGq5xOL24DK
	 1T//xJm+uOZQQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id ADEFF3806656;
	Thu, 19 Dec 2024 09:10:29 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/2] ipvs: Fix clamp() of ip_vs_conn_tab on small memory
 systems
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <173459942851.2189520.15547045150510561758.git-patchwork-notify@kernel.org>
Date: Thu, 19 Dec 2024 09:10:28 +0000
References: <20241218234137.1687288-2-pablo@netfilter.org>
In-Reply-To: <20241218234137.1687288-2-pablo@netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 edumazet@google.com, fw@strlen.de

Hello:

This series was applied to netdev/net.git (main)
by Pablo Neira Ayuso <pablo@netfilter.org>:

On Thu, 19 Dec 2024 00:41:36 +0100 you wrote:
> From: David Laight <David.Laight@ACULAB.COM>
> 
> The 'max_avail' value is calculated from the system memory
> size using order_base_2().
> order_base_2(x) is defined as '(x) ? fn(x) : 0'.
> The compiler generates two copies of the code that follows
> and then expands clamp(max, min, PAGE_SHIFT - 12) (11 on 32bit).
> This triggers a compile-time assert since min is 5.
> 
> [...]

Here is the summary with links:
  - [net,1/2] ipvs: Fix clamp() of ip_vs_conn_tab on small memory systems
    https://git.kernel.org/netdev/net/c/cf2c97423a4f
  - [net,2/2] netfilter: ipset: Fix for recursive locking warning
    https://git.kernel.org/netdev/net/c/70b6f46a4ed8

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


