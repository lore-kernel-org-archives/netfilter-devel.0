Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0DEF1D58B7;
	Tue,  3 Sep 2024 22:30:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725402637; cv=none; b=pEiUnjNda0HkS55aF24yh3PtWSCop7WKshbRglyNBwoal6KO4MQ3e3pMV074iO3g9boJ2wLXYg//+LiLPAOHjKcol0gHPP/dHCKmiR8MkBqlZekRb25ccmaRLaNgLuonTd0oaryF8czAWyRXUQZoV5TGqbQk3htFWzGcqHL9g1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725402637; c=relaxed/simple;
	bh=eoYJxAieAZwfHdgDOPFUjTAIffqsQ2ooDq7vakydHeY=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=KdZxVyg1cNk9i04JSpxO/QLzzRgdBxQDHPjxEp1XzlJRgxNNMB/2mc1/97HKckkjk1vdN5n1sf7gYHwx5o5tHtL/yf2nZTQHLLe2pnZm2HpzTee/8e0r92HNWz7sdcC4RzyZKmj2X8K06QSAdq9yI4vemoq24/ElHOi1aMUu0yE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZsKOxTfI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZsKOxTfI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49692C4CEC4;
	Tue,  3 Sep 2024 22:30:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725402637;
	bh=eoYJxAieAZwfHdgDOPFUjTAIffqsQ2ooDq7vakydHeY=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=ZsKOxTfIqpjYeT8unt8fBFfhBlxQIa6dMS6vwYyNIL2bOhpo0gcZz854dQIJhUTGS
	 CLm/KvHR6lEofKLs17sGZtAa3uYsJQyMVCSOnza9TY7kDiA13ynm2up5d6Dic28L7q
	 3jDEitdn1hExyN88SW4JT9inYg9StUuqc6wWfUhPyd1/yV9v1JezKrlStDZ/TDlZsu
	 oNCsjYIFbFIqsS4eo7wp2wkmqBewt9Ed/6NZhFGBoPy6BIYnefT20vjRO1/8jx8XTy
	 /GzTHO+8SxkUCeM5VA4kzKRfifRegaQrzjHMza8VbOMJ8e4iJyOGmWwpJxgO7LFXXW
	 VdQxnyrNYYc4Q==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 33BE33806652;
	Tue,  3 Sep 2024 22:30:39 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net-next] netlink: specs: nftables: allow decode of default
 firewalld ruleset
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <172540263819.468499.10969902778159097878.git-patchwork-notify@kernel.org>
Date: Tue, 03 Sep 2024 22:30:38 +0000
References: <20240902214112.2549-1-fw@strlen.de>
In-Reply-To: <20240902214112.2549-1-fw@strlen.de>
To: Florian Westphal <fw@strlen.de>
Cc: netdev@vger.kernel.org, pabeni@redhat.com, edumazet@google.com,
 kuba@kernel.org, netfilter-devel@vger.kernel.org, donald.hunter@gmail.com

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Mon,  2 Sep 2024 23:41:06 +0200 you wrote:
> This update allows listing default firewalld ruleset on Fedora 40 via
>   tools/net/ynl/cli.py --spec \
>      Documentation/netlink/specs/nftables.yaml --dump getrule
> 
> Default ruleset uses fib, reject and objref expressions which were
> missing.
> 
> [...]

Here is the summary with links:
  - [v2,net-next] netlink: specs: nftables: allow decode of default firewalld ruleset
    https://git.kernel.org/netdev/net-next/c/d2088ca85ebc

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


