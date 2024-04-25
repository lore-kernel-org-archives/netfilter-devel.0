Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B80E136E;
	Thu, 25 Apr 2024 00:20:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714004432; cv=none; b=VPQhDVd1RG0XVAdf30RJE7yD+4j2y7MvpNtAwsmrl3EVVpByIKcaPbzcN4J46w4bwrllxInaLYwWLc5M7ekBfljasbnVoNtb79jWF/sv3Gqqjyn79Zsca+Lijp2XRGopVCWEMS5htgpdntFN3U3sBvI6eri08Ed/6510PAf+/Gk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714004432; c=relaxed/simple;
	bh=qSWWjL7tB5KUSxbPiYTwravedXCx7m/IfUKjfVO5Zx8=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=h2DvfKs08mA7O2mLDTZF30zjFqcc8qb+MwUh+Se/DZYzeX5ViVXUx2EjAk8rOxDz/p/FAFBeB2sJ4gPp6L8ftXAd/Sr5QraqTU0iK7U/jtCwYf7345CNVcFDCF1v2IGxa6CwODzv2j8p99ZeceB7+NUNVXW9aqCPw3+VZxJTuwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MUXf/Lx5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MUXf/Lx5"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4CB42C113CD;
	Thu, 25 Apr 2024 00:20:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1714004432;
	bh=qSWWjL7tB5KUSxbPiYTwravedXCx7m/IfUKjfVO5Zx8=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=MUXf/Lx5cKQgYdVgPD55K4jG5PZ82jGOBfwOGb22ebeiBwFE7mh9AJ3w+BhIVa78t
	 FvLWooZ+oBiZl79OyBjdlRfDdZmKVz9KD9FId6K4I9e/x9gUuEOulvb8WwFA0/ILrh
	 YL1Bs463AjuzuSt721xY9QcUiQrFVVqUsuW5oA5xsxTCWgZOEJ3siDOqoDVS+UwRM6
	 xDH8r/BdGRkjEhXAmsNJJOf2/13zapYeuiUuU2+LUd8tyDCNI1TMvAzNnXIrtaq4Ua
	 6vfWEXnbI8GkErJKRoONgkvQKwAYOGNOHVZJWVc9XtyjFp43w4YFbYhLh/EsqqVM0t
	 uX7KIgnx6UIng==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 3D720C43614;
	Thu, 25 Apr 2024 00:20:32 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/7] selftest: netfilter: additional cleanups
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <171400443224.18029.12861058417990114215.git-patchwork-notify@kernel.org>
Date: Thu, 25 Apr 2024 00:20:32 +0000
References: <20240423130604.7013-1-fw@strlen.de>
In-Reply-To: <20240423130604.7013-1-fw@strlen.de>
To: Florian Westphal <fw@strlen.de>
Cc: netdev@vger.kernel.org, pabeni@redhat.com, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, netfilter-devel@vger.kernel.org,
 pablo@netfilter.org

Hello:

This series was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 23 Apr 2024 15:05:43 +0200 you wrote:
> This is the last planned series of the netfilter-selftest-move.
> It contains cleanups (and speedups) and a few small updates to
> scripts to improve error/skip reporting.
> 
> I intend to route future changes, if any, via nf(-next) trees
> now that the 'massive code churn' phase is over.
> 
> [...]

Here is the summary with links:
  - [net-next,1/7] selftests: netfilter: nft_concat_range.sh: move to lib.sh infra
    https://git.kernel.org/netdev/net-next/c/546fb63fe85e
  - [net-next,2/7] selftests: netfilter: nft_concat_range.sh: drop netcat support
    https://git.kernel.org/netdev/net-next/c/ba6fbd383c12
  - [net-next,3/7] selftests: netfilter: nft_concat_range.sh: shellcheck cleanups
    https://git.kernel.org/netdev/net-next/c/c54fa6ae35b9
  - [net-next,4/7] selftests: netfilter: nft_flowtable.sh: re-run with random mtu sizes
    https://git.kernel.org/netdev/net-next/c/f84ab634904c
  - [net-next,5/7] selftests: netfilter: nft_flowtable.sh: shellcheck cleanups
    https://git.kernel.org/netdev/net-next/c/a18f284574ad
  - [net-next,6/7] selftests: netfilter: skip tests on early errors
    https://git.kernel.org/netdev/net-next/c/bb0ee78f9418
  - [net-next,7/7] selftests: netfilter: conntrack_vrf.sh: prefer socat, not iperf3
    https://git.kernel.org/netdev/net-next/c/99bc5950ebd4

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


