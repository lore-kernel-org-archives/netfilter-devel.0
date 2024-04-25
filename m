Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CD8BA3F;
	Thu, 25 Apr 2024 00:30:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714005029; cv=none; b=We7rwI7RSg77xO63zL4+MLLpLq0oPV+0VG0db5iNks6nNqh4IGr3z+VdblcTKiPLJLlKT851eiwQIHEf6yqs1LOT2AP+TRvaoxCQzt0NnaKdtKScKDOg9b5dEPTKdYsH+WzBYEFzpr8jn+832NDK+aAy3jmk6jxd44DLkzPXDw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714005029; c=relaxed/simple;
	bh=7V9b27qCWrZrOqKoA0pgyFCHk4yqPSPUuvkVppirZS4=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=kgrC7W7STimGwyxNQewn/bJ+dqPIkWhpkdqfaNPjEaWgG8KO9iwZ2A81AbfoQzZuCqkfrSRbINROldGePNOr0+PprcEJBx3X9KYBolrlXVWY/SDnbdOO2qIJCkHrPr4hLxzz2AgjZvK7w0fVQevTooaznkPfpybfhsmnmWxYiI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eYgliMNF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eYgliMNF"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 27045C113CE;
	Thu, 25 Apr 2024 00:30:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1714005029;
	bh=7V9b27qCWrZrOqKoA0pgyFCHk4yqPSPUuvkVppirZS4=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=eYgliMNFklftChCOl5/gsq/K2ZS8JC2p+6hHycQpe6SrkLPkasxS3OajEiFou/E4X
	 vvcsV2KZ/MSFxI/pOZWdhvHnYftlW1ETVIK3RFdxAAl0QUxAEPKQbwqZYTYxuzDGVK
	 B/8lMwxBGNo+MwSf0FSSoZDkePfCxoL/mAXvkYG/mmDiOxX3X0088U9xSZMdYL7Hxl
	 tAaz43uTXwpJFeyOGK/a4JJiC4G8pTY1fNgDIpOvUgDbONdA/ZPdS/5SxLbUdaVtnJ
	 DsU2RusorwrXrVYM9J+AsKZ+cdGdCTstb0fRhK4V7AsBJ9TMqlS4DHlm2GB+EQCiwt
	 n0vrQ8hgQx1fg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 11A6DCF21C0;
	Thu, 25 Apr 2024 00:30:29 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] selftests: netfilter: nft_zones_many.sh: set ct
 sysctl after ruleset load
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <171400502906.22410.3606824868899948697.git-patchwork-notify@kernel.org>
Date: Thu, 25 Apr 2024 00:30:29 +0000
References: <20240422102546.2494-1-fw@strlen.de>
In-Reply-To: <20240422102546.2494-1-fw@strlen.de>
To: Florian Westphal <fw@strlen.de>
Cc: netdev@vger.kernel.org, pabeni@redhat.com, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, netfilter-devel@vger.kernel.org,
 pablo@netfilter.org

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 22 Apr 2024 12:25:42 +0200 you wrote:
> nf_conntrack_udp_timeout sysctl only exist once conntrack module is loaded,
> if this test runs standalone on a modular kernel sysctl setting fails,
> this can result in test failure as udp conntrack entries expire too fast.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  tools/testing/selftests/net/netfilter/nft_zones_many.sh | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)

Here is the summary with links:
  - [net-next] selftests: netfilter: nft_zones_many.sh: set ct sysctl after ruleset load
    https://git.kernel.org/netdev/net-next/c/8e2b318a65c3

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


