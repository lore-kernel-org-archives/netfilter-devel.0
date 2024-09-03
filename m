Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 805E61B12D9;
	Tue,  3 Sep 2024 11:10:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725361828; cv=none; b=s7EYkUPyLyzpPegnUhPaGhsxg9dLeJQYNC/TPJsBPS8PNleCfr8neeuCp7/suXAQdJvEBUWOHb72EaBMxPJuX7Rq4q6H1IetNLR6pW9rlSz+MVKkuoKN8ccJcTONal6UYXDpdJJd8mgtjHLip+cCRIAY9/HFCjgWuPIhpCog530=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725361828; c=relaxed/simple;
	bh=apccRSTU41sd4C0qxJY0CZtiCRI4BnLHHUk1r7IxsNI=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=gXmdSMNf6rzNp/nU1Ld9Exf736Ll0JZVv1zH3sJC9mI6Oja47Np5PKSpZRbRxmaQCwTB4jT1jjhk3stLamTQxJzRo/M7e450oUJ3m6/Wgc4OXF0iFFE4Pt8TZpt02UX8w/bgxff+6eUwR0Oo5nrmP4oZxZMtZ2a9Vi/QiDTw3t4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YhmUG0Bc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YhmUG0Bc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C2CEC4CEC4;
	Tue,  3 Sep 2024 11:10:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725361828;
	bh=apccRSTU41sd4C0qxJY0CZtiCRI4BnLHHUk1r7IxsNI=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=YhmUG0BcsioZ/Z9m5ZVPfOqx/oHNyk0JOi2Ct3CXwcBmOkqYGmxPah9VbPCdveQsz
	 9SFS7s0y6DVZWvh4ur4My1wtcSQVto5BUftrvdHlCUZVeC1bqDJE8QpXdAxzbahrmB
	 vyUp5ZyN5ID0yLJ0sP8ejD2x7ppGHAIOfjV7w99n6WcVe2GXgun7bKDZy8vkmLEzdJ
	 dN/ZltUZXTAJIMOaSsXh53hKH5P0Fy4wPJ530biKZSgWDSsq95vf9zLC8YLPAJbp8o
	 af+L/aW24qdmpyOH/+5As66kDYWtOLJWBLX8G2/kleqGSR58zwCdSn2jnw8jCaJoT1
	 e4xUzWjHxX9Dw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id EB5773822D30;
	Tue,  3 Sep 2024 11:10:29 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] selftests: netfilter: nft_queue.sh: fix spurious
 timeout on debug kernel
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <172536182876.258777.18006579321312248065.git-patchwork-notify@kernel.org>
Date: Tue, 03 Sep 2024 11:10:28 +0000
References: <20240830092254.8029-1-fw@strlen.de>
In-Reply-To: <20240830092254.8029-1-fw@strlen.de>
To: Florian Westphal <fw@strlen.de>
Cc: netdev@vger.kernel.org, pabeni@redhat.com, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, netfilter-devel@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by Paolo Abeni <pabeni@redhat.com>:

On Fri, 30 Aug 2024 11:22:39 +0200 you wrote:
> The sctp selftest is very slow on debug kernels.
> 
> Its possible that the nf_queue listener program exits due to timeout
> before first sctp packet is processed.
> 
> In this case socat hangs until script times out.
> Fix this by removing the -t option where possible and kill the test
> program once the file transfer/socat has exited.
> 
> [...]

Here is the summary with links:
  - [net-next] selftests: netfilter: nft_queue.sh: fix spurious timeout on debug kernel
    https://git.kernel.org/netdev/net-next/c/5ceb87dc76ab

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


