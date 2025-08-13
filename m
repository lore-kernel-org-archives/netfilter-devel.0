Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 232481E89C;
	Wed, 13 Aug 2025 21:59:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755122397; cv=none; b=VB8Jw0T2/YEBpeWgU4HfzqiVeqTI8FV97rUBThEu+FFs+5I/Yb23DRMrQhgp5+8ik6PST3srNpT0Hq2Kq3kGRvuenDZhSB1VNnSnAwiDoYON/py+19UJjlc5/+4P72zSFR8iEaigXgMD722ZdinBtzAsVTqXUKJUxjZIAWCvosY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755122397; c=relaxed/simple;
	bh=Z4e4i4X5uqERSh9Pcz53hjps8rtveWNFQ/ZTU1YGBKE=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=OHs/zP3M1ORYnrrML/3Vdth4lqGdcYp2dkHe3Dpyj3Un1c4WSZgyW7dNxTKeUSFUhoEsSMxJBquyRUU5I/tIj8XiITus/om2R/i273VJvDdRQ1BvN4623WTy3v1ElmfLcSSvrrwGbF626EqzWn7ZMjJZmijnY36FBsacvAtIwy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FkI4cp7l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FkI4cp7l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1204C4CEEB;
	Wed, 13 Aug 2025 21:59:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755122396;
	bh=Z4e4i4X5uqERSh9Pcz53hjps8rtveWNFQ/ZTU1YGBKE=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=FkI4cp7lx/Up2BVzXUvBbDq3HDpkcla5imiMtusHKxZHYC6q9sDR3Aq2Qo9vlMeV9
	 RUOMW+9KjGXLNhWeqP1IewBZDzcjzkxewtvKR8SFGAcqprMFkcypjN07eOOjh9DPto
	 +m2i5RSeourU6AWsfKvW8FFD5dSGr2tMEPcFKqGlojfHHTkyLvAD6/9AeKglcVYiUR
	 zo5qEaUF1g9JOr5yYtuIlTIi4tXar0bQ7p78qOMKXNYqWaIqWZR8+yUkq7lYCLw6qC
	 DZJq8HM9NHQOtMOQaQYpbCqCNl/cpayuHppijwVt1wpe2NhKLZXMoWPODD6ZB7PRVG
	 iUtSYsBK4XtVA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 8071039D0C37;
	Wed, 13 Aug 2025 22:00:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/3] netfilter: nft_set_pipapo: fix null deref for
 empty
 set
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <175512240826.3763733.8039499862730693344.git-patchwork-notify@kernel.org>
Date: Wed, 13 Aug 2025 22:00:08 +0000
References: <20250813113800.20775-2-fw@strlen.de>
In-Reply-To: <20250813113800.20775-2-fw@strlen.de>
To: Florian Westphal <fw@strlen.de>
Cc: netdev@vger.kernel.org, pabeni@redhat.com, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, netfilter-devel@vger.kernel.org,
 pablo@netfilter.org

Hello:

This series was applied to netdev/net.git (main)
by Florian Westphal <fw@strlen.de>:

On Wed, 13 Aug 2025 13:36:36 +0200 you wrote:
> Blamed commit broke the check for a null scratch map:
>   -  if (unlikely(!m || !*raw_cpu_ptr(m->scratch)))
>   +  if (unlikely(!raw_cpu_ptr(m->scratch)))
> 
> This should have been "if (!*raw_ ...)".
> Use the pattern of the avx2 version which is more readable.
> 
> [...]

Here is the summary with links:
  - [net,1/3] netfilter: nft_set_pipapo: fix null deref for empty set
    https://git.kernel.org/netdev/net/c/30c1d25b9870
  - [net,2/3] ipvs: Fix estimator kthreads preferred affinity
    https://git.kernel.org/netdev/net/c/c0a23bbc98e9
  - [net,3/3] netfilter: nf_tables: reject duplicate device on updates
    https://git.kernel.org/netdev/net/c/cf5fb87fcdaa

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


