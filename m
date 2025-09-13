Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37DBABA34;
	Sat, 13 Sep 2025 00:10:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757722213; cv=none; b=MaBpjK2sS9JhVkO1xLDPgiTrL/cMJiGFJFSnmpM0fBvw6lNadouqK9x7uIMkPgIm/kmMzW6GW6Rn3j6dDwLJAv5NNANZCRGeGWdasHBIbwc9mTOYJzMrMW2o3IBhc4k5o/zZ7uatIcrdIgF/fmT0GWO2+Qfqhu8HyL1Ir+qEhHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757722213; c=relaxed/simple;
	bh=rEBOCoBIkMyXvnVvbZwDIljs+0e5DTU8VaRVxDExesA=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=pjVnl5PM8It5bW6oEfiFLKOsXqbR/k4UWA4G7kuFKOnAaLDetBAqMoDZEiPVQJP8lvnPzE1GxDO/Nl6oUD1WxUi7kPLTFycjzWXFavWH2AE1yw01Wv/l1PlYUc3ocBk2b8MoDaZ0csihgHtFXunujAnMhXG3SK0vu5jv/73UZpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=G5VYBuLc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="G5VYBuLc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE420C4CEF8;
	Sat, 13 Sep 2025 00:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757722212;
	bh=rEBOCoBIkMyXvnVvbZwDIljs+0e5DTU8VaRVxDExesA=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=G5VYBuLcDyDl2n46M0LpHOgXgtxFTUxFLnJSrqSExV1SrmrIczeX6l3pp7Xznrc45
	 tnEERfDVIlXzNwGMJolBK16cOothL3mJXoo+r6oxZOr2pe7du9Yh4oVsciOl7rneRt
	 aMGNsEVzQCacFKUD0arI+pAqOHFaJoE9S+4CkOK7hhb9qVnILv4ZGc6zYwxvWhAHET
	 v/SlgDT/cFWi95JRf4LOsNCW/pwVANTwGxuYenLbCl+gzG9OvRxNENqIV0woIyjLsY
	 xFQB2LWmMpO3E+Zq12ksO6fFx69O+733o3QYfAKKiWXPDYaaRO2EdawQX5otimyM6F
	 aBdfS3DUV9c5w==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 33CEA383BF4E;
	Sat, 13 Sep 2025 00:10:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 1/5] selftest:net: fixed spelling mistakes
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <175772221475.3109205.13117121412963824859.git-patchwork-notify@kernel.org>
Date: Sat, 13 Sep 2025 00:10:14 +0000
References: <20250911143819.14753-2-fw@strlen.de>
In-Reply-To: <20250911143819.14753-2-fw@strlen.de>
To: Florian Westphal <fw@strlen.de>
Cc: netdev@vger.kernel.org, pabeni@redhat.com, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, netfilter-devel@vger.kernel.org,
 pablo@netfilter.org

Hello:

This series was applied to netdev/net-next.git (main)
by Florian Westphal <fw@strlen.de>:

On Thu, 11 Sep 2025 16:38:15 +0200 you wrote:
> From: Andres Urian Florez <andres.emb.sys@gmail.com>
> 
> Fixed spelling errors in test_redirect6() error message and
> test_port_shadowing() comments
> 
> Signed-off-by: Andres Urian Florez <andres.emb.sys@gmail.com>
> Reviewed-by: Hangbin Liu <liuhangbin@gmail.com>
> Signed-off-by: Florian Westphal <fw@strlen.de>
> 
> [...]

Here is the summary with links:
  - [net-next,1/5] selftest:net: fixed spelling mistakes
    https://git.kernel.org/netdev/net-next/c/496a6ed8405e
  - [net-next,2/5] netfilter: ipset: Remove unused htable_bits in macro ahash_region
    https://git.kernel.org/netdev/net-next/c/ba941796d7cd
  - [net-next,3/5] netfilter: nft_meta_bridge: introduce NFT_META_BRI_IIFHWADDR support
    https://git.kernel.org/netdev/net-next/c/cbd2257dc96e
  - [net-next,4/5] ipvs: Use READ_ONCE/WRITE_ONCE for ipvs->enable
    https://git.kernel.org/netdev/net-next/c/944b6b216c03
  - [net-next,5/5] netfilter: nf_reject: don't reply to icmp error messages
    https://git.kernel.org/netdev/net-next/c/db99b2f2b3e2

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


