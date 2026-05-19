Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A321C22576E;
	Tue, 19 May 2026 00:20:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779150009; cv=none; b=m/9ytmx7098VcrJ76FwWDToK0DkfKVRl/IMx9hXKypz6rbmxoyIdfgF2l5lEfsQc0gpq3VyCL9L205AW9hw0KeiLgMI19hBgbPR0TryVAljDYG9PgLQApwLWQWRWGs/7z9BFNbVNZ23ozD9ggBilxMzS40GxhA9eGAzHQbtt264=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779150009; c=relaxed/simple;
	bh=wjbf9JjTtMoQj2xj9fFFwz63IXO0VcH1DmMnOaU6chw=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=cmjFa4FyEFnrHFYa9ENqFu0IUJy2AucNvwq0VB3t506VjJg//Lpfemf5mm5dtda5SmJZpouDSwlFL5RYmyr6RvPHa2xIjbeTGlfA58NpVSx4gDd/YdyFLnY/XRg29cXxgl2ma+8KBxcNJ+DFNK0IAI41g5Qov7Jy0+v4+L35YNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UeUVk/db; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UeUVk/db"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46BB9C2BCB7;
	Tue, 19 May 2026 00:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779150009;
	bh=wjbf9JjTtMoQj2xj9fFFwz63IXO0VcH1DmMnOaU6chw=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=UeUVk/dboZ2KfrV/kNbMmI+gA5+EqNCL8I2F1M94i/wPnQJ7c7fyK5MIiyczXIgcc
	 mqsEuPWksffC0DpBs00dAMZkdrMrVUjdELanVF0QTB/6q4mYd8ZgI1tpAkEGziMZBM
	 Cau4OklApLTW55/2NlSzKYWBv09CgaChTJUcfVcwQYGLCtNMNdvfA2WGhm+c9dXNyD
	 ND25MkasUWeTe5DuPma5u5gaKy0FHdZc2VVww4C/VHNYwMFjUmY5Sm2vzv3dH0qG7X
	 Qg1CRnuqLI/X1UvrT3bNJNxbKXUilrc09xOEfeUHBfAbj5hwnwLzN9l7I/gpGqe6Y2
	 IjTIXOtMJVY/A==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id D0A5E3930CBF;
	Tue, 19 May 2026 00:20:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v4] net: neigh: Reallocate headroom if necessary in
 neigh_hh_bridge()
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <177915002039.2025486.6837208699781727246.git-patchwork-notify@kernel.org>
Date: Tue, 19 May 2026 00:20:20 +0000
References: <20260514-nf-neigh_hh_bridge-fix-v4-1-a56f4301923c@kernel.org>
In-Reply-To: <20260514-nf-neigh_hh_bridge-fix-v4-1-a56f4301923c@kernel.org>
To: Lorenzo Bianconi <lorenzo@kernel.org>
Cc: davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
 pabeni@redhat.com, horms@kernel.org, pablo@netfilter.org, fw@strlen.de,
 phil@nwl.cc, razor@blackwall.org, idosch@nvidia.com, bdschuym@pandora.be,
 kaber@trash.net, netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
 coreteam@netfilter.org, bridge@lists.linux.dev

Hello:

This patch was applied to netdev/net.git (main)
by Pablo Neira Ayuso <pablo@netfilter.org>:

On Thu, 14 May 2026 16:46:38 +0200 you wrote:
> neigh_hh_bridge() assumes the skb always has sufficient headroom to copy
> the aligned  L2 header. This assumption can trigger the crash reported
> below using the following netfilter setup:
> 
> $modprobe br_netfilter
> $sysctl -w net.bridge.bridge-nf-call-iptables=1
> 
> [...]

Here is the summary with links:
  - [net,v4] net: neigh: Reallocate headroom if necessary in neigh_hh_bridge()
    https://git.kernel.org/netdev/net/c/b2870fc21601

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


