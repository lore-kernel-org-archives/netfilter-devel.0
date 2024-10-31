Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D4628479;
	Thu, 31 Oct 2024 11:20:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730373623; cv=none; b=IAqhrbEiNxOasGEeLXxuesfbrP9k84cObBbNjb/43r6gnJHAcPcJB7yRbIxnZL0TlTY2w+tfFimdPuCQUDkvj+A0PgkJeE2ug7TIlKh0Zz9K8z33nw7+1iPwB90sarYox4N7cOz3HiH8h4BCv40FRQszsnjLm11tRTVuPCxQ8U0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730373623; c=relaxed/simple;
	bh=bcUV1oO0taCkOr+m0J9rZ3aYP2Ij3NCj+Qi0cbZ1QC0=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=j7rhfHTC0GBsiLQHm2WNX69suOi9qy9NylajuC2AO+kwziIJjWX6jrTSlr+y6GxS8Ded1AV9nh2c8iNJTRVpvjKr9BLYZ4/Hf+c9M+lZ/7gcV2phI2Xqm6UuGWy554uOLXKWpdsrjHQVLCR6A/VjYBDE+cPigXSfMPjqmXcuo3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FEgcAG8l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FEgcAG8l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B16AC4DE09;
	Thu, 31 Oct 2024 11:20:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730373623;
	bh=bcUV1oO0taCkOr+m0J9rZ3aYP2Ij3NCj+Qi0cbZ1QC0=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=FEgcAG8lUZsicgOUPX1Jm5pfpmILWtRYmPgBNS5Qybk0+KHjsW4ehPnWqZr5wHbkg
	 jNjDp4XIztLsf5//M483Hc9cS3IL4mlN3C7/PL2Ext0sD3PLTg9feFZOCoPp+qKReK
	 j4C7coNHzW+XHaLw+79k7yZGrdUSgk0rFbCyasoRQElHerFpwUDpi0eYo+kJoUjuzS
	 mXE4swuI69foNZNe6eAcxvvh+oJdiK5uOiNsSut6UevSWKABdbGj5+tmpLCLkkQ3LB
	 oJSJdKt28xt6+PZ2FD0/U8hYs8mqSMIB069ku8MLNfMPP+SQ5cRdZqZLtE7r24S5Bl
	 UlmoyJiHWSf1Q==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 33D58380AC02;
	Thu, 31 Oct 2024 11:20:32 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/4] Netfilter fixes for net
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <173037363103.1933707.12664103566543266487.git-patchwork-notify@kernel.org>
Date: Thu, 31 Oct 2024 11:20:31 +0000
References: <20241031100117.152995-1-pablo@netfilter.org>
In-Reply-To: <20241031100117.152995-1-pablo@netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 edumazet@google.com, fw@strlen.de

Hello:

This series was applied to netdev/net.git (main)
by Pablo Neira Ayuso <pablo@netfilter.org>:

On Thu, 31 Oct 2024 11:01:13 +0100 you wrote:
> Hi,
> 
> The following patchset contains Netfilter fixes for net:
> 
> 1) Remove unused parameters in conntrack_dump_flush.c used by
>    selftests, from Liu Jing.
> 
> [...]

Here is the summary with links:
  - [net,1/4] selftests: netfilter: remove unused parameter
    https://git.kernel.org/netdev/net/c/76342e842587
  - [net,2/4] netfilter: Fix use-after-free in get_info()
    https://git.kernel.org/netdev/net/c/f48d258f0ac5
  - [net,3/4] netfilter: nf_reject_ipv6: fix potential crash in nf_send_reset6()
    https://git.kernel.org/netdev/net/c/4ed234fe793f
  - [net,4/4] netfilter: nft_payload: sanitize offset and length before calling skb_checksum()
    https://git.kernel.org/netdev/net/c/d5953d680f7e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


