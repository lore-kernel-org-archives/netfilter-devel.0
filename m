Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8390218C901;
	Thu, 29 Aug 2024 08:40:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724920828; cv=none; b=RmWxmrRX3BXTSPPhX0H2SCAEPGsDK3fCHXSD2gl5WLtm3RH1v7YeXyyzy+2jI99+Bwxdv9CtddZGsLog44wKSEUN/+em3ahkJlnq5oDLtoK1o19+IbYVJQgaW8mXyL0b/EhUZCFxvntgG1KzXcHuBJ/Cjb5VHENGSgiToIDaikk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724920828; c=relaxed/simple;
	bh=7TZpA6nhKeHEw9HE36y8c0innkFQ17lG9uoWouj77cM=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=YmNoXAehfqFf0Lpocef+ZUhE3tJtiFeeUmQwY90d7WA0mDF0hG/aLala1nvnkqlyilpb/LR3B5ksFWe/ynAuntcxXbUozpjGsbVjV5rpKfPMDiAyt5ZrYqx/GG+2BP4MLOjNeUe1I+Y/odhMRTklEakBcMKneugngoO1O6HAplY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qxCoO7a2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qxCoO7a2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1203C4CEC1;
	Thu, 29 Aug 2024 08:40:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724920828;
	bh=7TZpA6nhKeHEw9HE36y8c0innkFQ17lG9uoWouj77cM=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=qxCoO7a2F09dszlgyn+0Q032i6pbiFmNqwAQgS7bvIwJapRSPH583c0Vcs08rRjQc
	 ums+lRMc3EELg0Pwt4WDVg0QaXoMadtVehcH0oydHsqNK7H0AkwhMqTkl7GVWbo2yc
	 j616LB12HLfQc+xsNZcfa2FnMRUh+5j4l+uNXeO02cW1eZHovxrFFS9dg9mq/isMuG
	 UaapGyFftTmkGFRGrytB8l5qgYdGTpO4rl/sAkMV34Z4td9vThdqYQHeRLJf9dLajJ
	 ZIvXFsoCJsfo09VDH7E8vy3SI5ZcJw9z9Yq+HLL4Y0A1EErn9PKVAJGuuXmtGxn9K3
	 iGqb87eHpKrhA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 70CF93809A80;
	Thu, 29 Aug 2024 08:40:29 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] selftests: netfilter: nft_queue.sh: reduce test file
 size for debug build
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <172492082825.1867547.6955538013977129327.git-patchwork-notify@kernel.org>
Date: Thu, 29 Aug 2024 08:40:28 +0000
References: <20240827090023.8917-1-fw@strlen.de>
In-Reply-To: <20240827090023.8917-1-fw@strlen.de>
To: Florian Westphal <fw@strlen.de>
Cc: netdev@vger.kernel.org, netfilter-devel@vger.kernel.org, kuba@kernel.org,
 pabeni@redhat.com, edumazet@google.com, davem@davemloft.net

Hello:

This patch was applied to netdev/net-next.git (main)
by Paolo Abeni <pabeni@redhat.com>:

On Tue, 27 Aug 2024 11:00:12 +0200 you wrote:
> The sctp selftest is very slow on debug kernels.
> 
> Reported-by: Jakub Kicinski <kuba@kernel.org>
> Closes: https://lore.kernel.org/netdev/20240826192500.32efa22c@kernel.org/
> Fixes: 4e97d521c2be ("selftests: netfilter: nft_queue.sh: sctp coverage")
> Signed-off-by: Florian Westphal <fw@strlen.de>
> 
> [...]

Here is the summary with links:
  - [net-next] selftests: netfilter: nft_queue.sh: reduce test file size for debug build
    https://git.kernel.org/netdev/net-next/c/0a8b08c554da

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


