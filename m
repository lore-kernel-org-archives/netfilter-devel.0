Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C272C40DFC6;
	Thu, 19 Mar 2026 12:20:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773922814; cv=none; b=ozqcQq9sBksmx2VXblOqwiitX0BOi/ldI9tFig/6XA6E2DEMlTokA/XI1RG69QkCT8hOX7Tn02I/O5N3KknPLWJXLnnyODmHtJXq0nMlMinRqzjB7Sv6R92MmkHErwpREZHpzZ5YXrxY06tg8cvsnz7OpcgdHKtIsL/CU8Uuzp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773922814; c=relaxed/simple;
	bh=fKL+rf0TuZqdH2hKMMHYKXOXdGXDr7iU8f430CSUfTI=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=k6N3vusrXLWsDoEg4A19R8pm6tnM32T/n7LWrDXmV4d9jBhUkupbv2k2k/Tym3XwTePm9q4RpOaU1i8G+kLyJBwBPaDFjVLLjWVZB0BTV3WnRW6N5QoZYHZ/h9eNLCBqmHQtkTTYfjZ6AfOLk/di6Q7P3paqVp0agmDcRLxMl9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gC/XF1KR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gC/XF1KR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EBC7C19424;
	Thu, 19 Mar 2026 12:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773922814;
	bh=fKL+rf0TuZqdH2hKMMHYKXOXdGXDr7iU8f430CSUfTI=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=gC/XF1KRB3pQnxCuS8oTBjkgeaaPcvsozjI9vj0AMrdcMo/VrbI+nRjjHVCiA0S8x
	 M66WcO0b+N7xVfYG26BQJe9V/sxTMTxdpXNMehe6C9HC6RrW3DC5t4Xbs26cWHCOLK
	 hGlY92w/4c5yEIZ5L+1TYYRg9RThlG+HWb2K5OVbWxcOYOSyTzx3hlLyODVwqUwtz+
	 JoPji4wM5PBUIDNN5soz57uldDdc7Bj0MPRy9GNGP5KlrGwNc4Bfvr1W2tDuK4aLXB
	 ZuYejDkQifQMzfpe/2oy0jSXmUBpkgR/xIcOwdimmfCSLZ/iCYAyxK5YfaanpJxw6P
	 GJKxAnd41+7oA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id B9E963808203;
	Thu, 19 Mar 2026 12:20:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v12 net-next] bridge: No DEV_PATH_BR_VLAN_UNTAG_HW for dsa
 foreign
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <177392280529.1176382.11436011876341832939.git-patchwork-notify@kernel.org>
Date: Thu, 19 Mar 2026 12:20:05 +0000
References: <20260317110347.363875-1-ericwouds@gmail.com>
In-Reply-To: <20260317110347.363875-1-ericwouds@gmail.com>
To: Eric Woudstra <ericwouds@gmail.com>
Cc: jiri@resnulli.us, ivecera@redhat.com, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, horms@kernel.org,
 razor@blackwall.org, idosch@nvidia.com, pablo@netfilter.org, fw@strlen.de,
 netdev@vger.kernel.org, bridge@lists.linux.dev,
 netfilter-devel@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by Paolo Abeni <pabeni@redhat.com>:

On Tue, 17 Mar 2026 12:03:47 +0100 you wrote:
> In network setup as below:
> 
>              fastpath bypass
>  .----------------------------------------.
> /                                          \
> |                        IP - forwarding    |
> |                       /                \  v
> |                      /                  wan ...
> |                     /
> |                     |
> |                     |
> |                   brlan.1
> |                     |
> |    +-------------------------------+
> |    |           vlan 1              |
> |    |                               |
> |    |     brlan (vlan-filtering)    |
> |    |               +---------------+
> |    |               |  DSA-SWITCH   |
> |    |    vlan 1     |               |
> |    |      to       |               |
> |    |   untagged    1     vlan 1    |
> |    +---------------+---------------+
> .         /                   \
> 
> [...]

Here is the summary with links:
  - [v12,net-next] bridge: No DEV_PATH_BR_VLAN_UNTAG_HW for dsa foreign
    https://git.kernel.org/netdev/net-next/c/96450df197bd

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


