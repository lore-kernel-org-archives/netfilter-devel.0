Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD17E1E3DED;
	Sun,  4 Jan 2026 20:17:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767557830; cv=none; b=itPrsY2gahS0ZbdGFngHUnrwa3ahz+cDYWMN5t2sI+It5ejVXA2X/og2bw2bckzF9VjUZNh6gnqtWFOtY/BwyB0Ymr4MdrJ00Vatv0OL1jw/ZcOJAzC40md+Qu7qsz+MKTPli2J5g4TcTifYa+K6VAT7pNodfspaBMA+qkKZni8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767557830; c=relaxed/simple;
	bh=MbcUpwDFt9twtpPtCl2E6jvD3/Jkl6ammYkMQpIgrQU=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=WeYYweaG46J+BFseoZcL8s/SEtSF+u7xRSvJ48LHcUcQTo2yP1yvQ0/DCkDvUF6xZUAhjicSBGJ0OtIiOIfahNAx/WjOCzcmDoVXLKlbj9Y4bM7WYTtxm/WFoGkckFXIORz6g8UEbwtQweB/v2HweB8JeMSXc+skvA4IjU5ttmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IF0DWggP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IF0DWggP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B6BCC4CEF7;
	Sun,  4 Jan 2026 20:17:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767557830;
	bh=MbcUpwDFt9twtpPtCl2E6jvD3/Jkl6ammYkMQpIgrQU=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=IF0DWggP8w6TB/caRLMcb9h/jpwQLVq3Bokz+L1lFzAH8czbUzaQgXAT6AC2tf/tO
	 gF3NadBQ75aZ3JD1/grpOTmZkesuRaeFY02aEVVKMMjFNGgq68b22UPC4r230VRiRh
	 Ecq0jnv64WN0UfhKRPu2W0eF9kvXAWGNaDFiKy/qiNf6dB4aEz0O+rP7xFMhHnOkWk
	 UrDFNj4MXKWVoTgCYMiv5YR9t7fK/NudPUkmgDC/tm5trsWTbRgwNS+B7CfDiG5jBI
	 vE0e6rRsBtwBBBy1Z0f91TborMFGkZUEoPxUmqXQ8UijoTmp3/1xGJYsTefOR92J8j
	 QPXu6bT9ZeIUw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 78906380AA58;
	Sun,  4 Jan 2026 20:13:50 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/6] netfilter: nft_set_pipapo: fix range overlap
 detection
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <176755762931.155813.1576847923477813062.git-patchwork-notify@kernel.org>
Date: Sun, 04 Jan 2026 20:13:49 +0000
References: <20260102114128.7007-2-fw@strlen.de>
In-Reply-To: <20260102114128.7007-2-fw@strlen.de>
To: Florian Westphal <fw@strlen.de>
Cc: netdev@vger.kernel.org, pabeni@redhat.com, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, netfilter-devel@vger.kernel.org,
 pablo@netfilter.org

Hello:

This series was applied to netdev/net.git (main)
by Florian Westphal <fw@strlen.de>:

On Fri,  2 Jan 2026 12:41:23 +0100 you wrote:
> set->klen has to be used, not sizeof().  The latter only compares a
> single register but a full check of the entire key is needed.
> 
> Example:
> table ip t {
>         map s {
>                 typeof iifname . ip saddr : verdict
>                 flags interval
>         }
> }
> 
> [...]

Here is the summary with links:
  - [net,1/6] netfilter: nft_set_pipapo: fix range overlap detection
    https://git.kernel.org/netdev/net/c/7711f4bb4b36
  - [net,2/6] selftests: netfilter: nft_concat_range.sh: add check for overlap detection bug
    https://git.kernel.org/netdev/net/c/a675d1caa204
  - [net,3/6] netfilter: nft_synproxy: avoid possible data-race on update operation
    https://git.kernel.org/netdev/net/c/36a320057564
  - [net,4/6] netfilter: replace -EEXIST with -EBUSY
    https://git.kernel.org/netdev/net/c/2bafeb8d2f38
  - [net,5/6] netfilter: nf_tables: fix memory leak in nf_tables_newrule()
    https://git.kernel.org/netdev/net/c/d077e8119ddb
  - [net,6/6] netfilter: nf_conncount: update last_gc only when GC has been performed
    https://git.kernel.org/netdev/net/c/7811ba452402

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


