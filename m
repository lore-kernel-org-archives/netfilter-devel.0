Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DDF11B7F6;
	Thu,  8 Feb 2024 12:30:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707395430; cv=none; b=GhcT+z4N+yw7Rgpu81hM1um2exV+dEk0ytDpJaw1oP6DC57+rKjNONL+Wy9P1vot22D84IEKdZ1O/8AypeE7FMqbLaLDO2eTlTf49cGAB81eAOq7z+xaLAqbnO2aCT11j+1dC4YS75xyVY22DXloC6SXFwRnwJiFk1xFfMbWp+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707395430; c=relaxed/simple;
	bh=RTaUdoh+BAG+eyTkiOwrqSe1WubALAkCc+XbhNrFSAs=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=guKPeNMc+2Y8xTb1KhW3spVpO9RpGhZ5HXa4bsRNJSaIptvCP9UaCEFnGYiEn8jf/WOOoDBNbpCG1SJqXY/hynoac2/LLaQh4H+JrxUe+T8sJxpbzgN73qkDv1wC0zQRdcUBhNFVxbgWJiD+wKR8TPp7L/Z8y0aiVNhNwVxeeEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SszNSoTF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SszNSoTF"
Received: by smtp.kernel.org (Postfix) with ESMTPS id BE07DC433F1;
	Thu,  8 Feb 2024 12:30:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1707395429;
	bh=RTaUdoh+BAG+eyTkiOwrqSe1WubALAkCc+XbhNrFSAs=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=SszNSoTFn039KPGvS1ht3yRqiaBx60akO0qsy1zE8ZFymfv2J62HSBDsqk9zSz8JG
	 39/hXSwhS/gdPwGPAeu4oP2BzeDjYfXI474fvxAdOVYaOhjK6t1k7KliqurXeQXIFK
	 84OVC8DF0aQOXffqIJU2wWONflCsaAnC1vT/dcZLtF0WJejBJFM0wu7NcEWs9QR4ER
	 2Fw0JoR4Tgk+DR+Racd+TJIWjgbc05I9Nfx4dLnT7rjohgz9JTRRCMpwwtSsT+sStn
	 ABOuZJQphH167rgDD/6YdZrv3F7ObuPj6YD739xtmuDff+pKAfWbPKlJsKQKw3bljr
	 jzvct/CA4d0TQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A4AD6E2F2F9;
	Thu,  8 Feb 2024 12:30:29 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 01/13] netfilter: nft_compat: narrow down revision to
 unsigned 8-bits
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <170739542966.30179.12730184449437976359.git-patchwork-notify@kernel.org>
Date: Thu, 08 Feb 2024 12:30:29 +0000
References: <20240208112834.1433-2-pablo@netfilter.org>
In-Reply-To: <20240208112834.1433-2-pablo@netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 edumazet@google.com, fw@strlen.de, kadlec@netfilter.org

Hello:

This series was applied to netdev/net.git (main)
by Pablo Neira Ayuso <pablo@netfilter.org>:

On Thu,  8 Feb 2024 12:28:22 +0100 you wrote:
> xt_find_revision() expects u8, restrict it to this datatype.
> 
> Fixes: 0ca743a55991 ("netfilter: nf_tables: add compatibility layer for x_tables")
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
>  net/netfilter/nft_compat.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)

Here is the summary with links:
  - [net,01/13] netfilter: nft_compat: narrow down revision to unsigned 8-bits
    https://git.kernel.org/netdev/net/c/36fa8d697132
  - [net,02/13] netfilter: nft_compat: reject unused compat flag
    https://git.kernel.org/netdev/net/c/292781c3c548
  - [net,03/13] netfilter: nft_compat: restrict match/target protocol to u16
    https://git.kernel.org/netdev/net/c/d694b754894c
  - [net,04/13] netfilter: nft_set_pipapo: remove static in nft_pipapo_get()
    https://git.kernel.org/netdev/net/c/ab0beafd52b9
  - [net,05/13] netfilter: ipset: Missing gc cancellations fixed
    https://git.kernel.org/netdev/net/c/27c5a095e251
  - [net,06/13] netfilter: ctnetlink: fix filtering for zone 0
    https://git.kernel.org/netdev/net/c/fa173a1b4e3f
  - [net,07/13] netfilter: nft_ct: reject direction for ct id
    https://git.kernel.org/netdev/net/c/38ed1c7062ad
  - [net,08/13] netfilter: nf_tables: use timestamp to check for set element timeout
    https://git.kernel.org/netdev/net/c/7395dfacfff6
  - [net,09/13] netfilter: nfnetlink_queue: un-break NF_REPEAT
    https://git.kernel.org/netdev/net/c/f82777e8ce6c
  - [net,10/13] netfilter: nft_set_rbtree: skip end interval element from gc
    https://git.kernel.org/netdev/net/c/60c0c230c6f0
  - [net,11/13] netfilter: nft_set_pipapo: store index in scratch maps
    https://git.kernel.org/netdev/net/c/76313d1a4aa9
  - [net,12/13] netfilter: nft_set_pipapo: add helper to release pcpu scratch area
    https://git.kernel.org/netdev/net/c/47b1c03c3c1a
  - [net,13/13] netfilter: nft_set_pipapo: remove scratch_aligned pointer
    https://git.kernel.org/netdev/net/c/5a8cdf6fd860

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


