Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B801634041B;
	Thu,  6 Aug 2026 00:20:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785975652; cv=none; b=bo83tYqKZmOJ2mqXJ8rJRUXaRZL4KwQC5wSr2ZAPgpCcGyamBAFTX1rvtDfM5ZwgecokIjZjCrcgbBDtPJ7s6tFE2bK8H3gUyDscnLMmz2TqxZxh4ZQeDOb32QWngoAWai80/MpYr0WTEHcbh81a2kxOdRUNPJ17pQWNZOUb7uQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785975652; c=relaxed/simple;
	bh=n04CMGwp6tEBl8c8aByqFwlkxfDsn2TwSXbaFfMK9tc=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=FSCvWK3yokSc2RSxFRorcpYIVAf3+KfwewVSXddqWZ1MEwmgznH31GEGwylME6VvfvFQTnSnuQcW8Vn2gI4qzKeSRu6wazNnrDwhiK1J7fxcAN+lm5iT16JX/5FjwsOtP+qLTGaOuxevPfYN/IenUCvH4pNzl90YNcMQP2Xs2XA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dQH5gZdF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dQH5gZdF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4E301F00A3A;
	Thu,  6 Aug 2026 00:20:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785975648;
	bh=wh4J+Bc28JG16+2tCsVeZ0u9k3JKqG5SRh6FCAyfgTo=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=dQH5gZdF+JQ/BELyK2ZxyxKCrSv/uqnJccAQlC8lZKBHLZjRa6K9ACn7Fr7vcSa6t
	 +YS7zRHlh8HfW2yskJbcsA8Azq8oScPKcUP84od8tmGu11Pwc4imbj/Kw5S2QThwEq
	 5IEdqfmPE4vuVM6MUGEnP9zpgxRbRolXKENdEa5ICgnqCG1sN8+7OJ6noO7ZNS+8lK
	 +1FGX/Byqa8gwjA5nevtRgE0mPAfQuwl/Y3e2OUqgDX6DskMSG8JVufbOT2n4qkAfm
	 myJ5ORrkR+D3bEQ7L/H3RnommTy6GV2GUfdztlkV3HwRk7B/9nMkQpWZoeTl1D5p00
	 8QkE9TBHxehJw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id D09A8392FFD8;
	Thu,  6 Aug 2026 00:20:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] netfilter: nf_flow_table: drop existing skb dst
 before
 skb_dst_set_noref()
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <178597560839.575509.1356511922096738928.git-patchwork-notify@kernel.org>
Date: Thu, 06 Aug 2026 00:20:08 +0000
References: <20260804093328.1831847-1-edumazet@google.com>
In-Reply-To: <20260804093328.1831847-1-edumazet@google.com>
To: Eric Dumazet <edumazet@google.com>
Cc: davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
 pablo@netfilter.org, fw@strlen.de, netdev@vger.kernel.org,
 netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
 eric.dumazet@gmail.com, syzbot+76d4e3a055aec3b007ec@syzkaller.appspotmail.com

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Tue,  4 Aug 2026 09:33:28 +0000 you wrote:
> Incoming skbs passing through netfilter flowtable offload hooks (or XFRM
> offload path) might already carry a ref-counted dst_entry assigned during
> earlier RX or routing steps.
> 
> Calling skb_dst_set_noref() when skb already holds a ref-counted dst
> overwrites skb->_skb_refdst, leaking the previous dst_entry reference
> count and triggering a DEBUG_NET_WARN_ON_ONCE assertion in
> skb_dst_check_unset():
> 
> [...]

Here is the summary with links:
  - [net] netfilter: nf_flow_table: drop existing skb dst before skb_dst_set_noref()
    https://git.kernel.org/netdev/net/c/8aecf0bbcc72

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


