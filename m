Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55C7A206E9D;
	Tue, 29 Oct 2024 18:30:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730226635; cv=none; b=Za0rN7UtsMfA1r2eKbf4OiWDnZqe7GfHDsjoOh8FyI5jVQQksubXSZFUNNEYIdunjuHL8vmQw7MM5T9HUKQf9XuyO7MKX2qqGWt2pTG8zj7o7XzI2Okg1KgAaLD1mWRgA97+bV7G2m5sF2Y3F81WQrJrZty66X1QWHHbFIkXNqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730226635; c=relaxed/simple;
	bh=Pfc85nbiHEIfgvnySvDgIjQELfRGWpLGUR9MrNG1G6E=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=eL+BveaCcpRdY0M8FeE+YHuFxykh4TMTZ397Luh6iM3/0vNb6vVU7WhDPPDxl9hADXqle1OF0wlENddwhd7lbFX6XazJYKk6nG6R4GJxgLfW7dUed4i1ET4k0EAvJeUjGQ+8iS87Jc9YncBunNhredmt9ZeJeMhYxqMka0yfmX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZAl14pdc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZAl14pdc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D82DFC4CEE7;
	Tue, 29 Oct 2024 18:30:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730226634;
	bh=Pfc85nbiHEIfgvnySvDgIjQELfRGWpLGUR9MrNG1G6E=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=ZAl14pdcFcQeEwPrMuQ6e51X1VC7exQB/a5u7FjoA/xmbRv/pYNgjrEijzU3/dLMu
	 hg7vKOpefKkoFGXEP46aSPfGuF0HFME8o+4ztTIeWfxOuUQ01tEBHlNPKqPuwBb3Do
	 mdV0aWMh44jUUiUG+QtfCHllC2LtPiLcdVEXoex3wSWNv7GRzkEEz+iy0aHgxGpuhp
	 bCCc6H0R99OYmnQcMELCFUc8fd+Ryhp5KrNj4tAtO2h7AZYsG07MgOF0yRPuZI9dUk
	 84h984+tDdHE76L7HVm0GrjWWLPZb0ekKDqZwuFBYZlmBa8zoUAbsVOeq3p9Gn+pQy
	 rRWBo6IcFlHkg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id ADD9F380AC08;
	Tue, 29 Oct 2024 18:30:43 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] selftests: netfilter: nft_flowtable.sh: make first pass
 deterministic
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <173022664223.781637.3768453317314234157.git-patchwork-notify@kernel.org>
Date: Tue, 29 Oct 2024 18:30:42 +0000
References: <20241022152324.13554-1-fw@strlen.de>
In-Reply-To: <20241022152324.13554-1-fw@strlen.de>
To: Florian Westphal <fw@strlen.de>
Cc: netdev@vger.kernel.org, pabeni@redhat.com, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, netfilter-devel@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 22 Oct 2024 17:23:18 +0200 you wrote:
> The CI occasionaly encounters a failing test run.  Example:
>  # PASS: ipsec tunnel mode for ns1/ns2
>  # re-run with random mtus: -o 10966 -l 19499 -r 31322
>  # PASS: flow offloaded for ns1/ns2
> [..]
>  # FAIL: ipsec tunnel ... counter 1157059 exceeds expected value 878489
> 
> [...]

Here is the summary with links:
  - [net] selftests: netfilter: nft_flowtable.sh: make first pass deterministic
    https://git.kernel.org/netdev/net/c/c59d72d0a4fb

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


