Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C284B31BC9E;
	Fri, 23 Jan 2026 00:00:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769126413; cv=none; b=lfdTeMW9igvOZxuEUI7tCc+aQY0KkYptXPh0be3pg5h9KK7x28vY2C2lAcjliwj9yvyaBAHM/JcBK5GDx2AgH8oecZVygMZWyhvXRcbXGoCiHBfhy7Qd6PZUo+wdwqhtLJPgRglW2DuD6fGnAuQ9dzvopxsXdazUCspZKOh0mxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769126413; c=relaxed/simple;
	bh=jO6L/hzPe0ilE9T+6MWZ5gyH0HGsAh+O/AHfJ11qlEs=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=VcoM73GfOsEC6cJsoSQq89YT+s5Z48VT7NXVaQVlSSldg5RP8iJMHmKA5GR//dz6IuC3SsazjVJGkkFvY/JY6AHEM/BjubRa1YzXBCqMmdpXXHTdC00eVpD9TCcNLW5H/s+s+wja325DA7/klrwoF+fKJqSi+bGY3hxwqWl75OU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QP91yCft; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QP91yCft"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 117A7C116C6;
	Fri, 23 Jan 2026 00:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769126413;
	bh=jO6L/hzPe0ilE9T+6MWZ5gyH0HGsAh+O/AHfJ11qlEs=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=QP91yCft2aTcrXP3DkglGvWMs81eV/bPWTRRMKeSYcuQtzgnjw+fRawW3Cbu1OjrZ
	 GvJ60Ka4jozayZbLc0UfbGe9H4SOE3sQn9LB1LlD4Ob4Ct0qd1h5bCAgfFeMnT3U09
	 fONptRo/S8i4OtohPohflNkjRUZkT1DgCHrk2Z6GBz3QsX8EmB1tdXne92GjC9GCo/
	 uClCPa/IRVK40U273HmPFU5pRZr1Q0CZpIKzzFJKmyxE+QP6zmlNRXymVk50VdvO3i
	 VrXJ5+LNo8k8EgMphviyRCSCfU7Db1CfwWLbmsjp+vC+9eEg3G8Po+5VuxuxrSCfPE
	 qHGstSxfChJ2w==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 8BB363808200;
	Fri, 23 Jan 2026 00:00:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 1/4] netfilter: nf_tables: add
 .abort_skip_removal
 flag for set types
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <176912640898.2329686.4992612220362762335.git-patchwork-notify@kernel.org>
Date: Fri, 23 Jan 2026 00:00:08 +0000
References: <20260122162935.8581-2-fw@strlen.de>
In-Reply-To: <20260122162935.8581-2-fw@strlen.de>
To: Florian Westphal <fw@strlen.de>
Cc: netdev@vger.kernel.org, pabeni@redhat.com, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, netfilter-devel@vger.kernel.org,
 pablo@netfilter.org

Hello:

This series was applied to netdev/net-next.git (main)
by Florian Westphal <fw@strlen.de>:

On Thu, 22 Jan 2026 17:29:32 +0100 you wrote:
> From: Pablo Neira Ayuso <pablo@netfilter.org>
> 
> The pipapo set backend is the only user of the .abort interface so far.
> To speed up pipapo abort path, removals are skipped.
> 
> The follow up patch updates the rbtree to use to build an array of
> ordered elements, then use binary search. This needs a new .abort
> interface but, unlike pipapo, it also need to undo/remove elements.
> 
> [...]

Here is the summary with links:
  - [net-next,1/4] netfilter: nf_tables: add .abort_skip_removal flag for set types
    https://git.kernel.org/netdev/net-next/c/f175b46d9134
  - [net-next,2/4] netfilter: nft_set_rbtree: translate rbtree to array for binary search
    https://git.kernel.org/netdev/net-next/c/7e43e0a1141d
  - [net-next,3/4] netfilter: nft_set_rbtree: use binary search array in get command
    https://git.kernel.org/netdev/net-next/c/2aa34191f06f
  - [net-next,4/4] netfilter: nft_set_rbtree: remove seqcount_rwlock_t
    https://git.kernel.org/netdev/net-next/c/5599fa810b50

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


