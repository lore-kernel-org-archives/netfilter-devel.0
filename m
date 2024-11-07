Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B91E217F21;
	Thu,  7 Nov 2024 19:40:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731008421; cv=none; b=FK0o1kVSGIpE1Lzcmi25xtZ0uTFlRA5d35aehEkOjp5o1EEmsXbR9Bv4pW8aACXCTAIP+DOm8QO5Rgl+I6F/lPCCBDs52dFVbEmn+rgshZDCmGb1oBRy+n52KQJjg6AMjTJk8luq7ifXQeJ/2ZDI8BxV6n8PTW7K5MtcYevQoZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731008421; c=relaxed/simple;
	bh=IWvqkmTISTARZW0y3rN5iLDc3lj9CpSikNJUn4V2T2A=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=jARD3Hf9ToMiWuEy23wdeZNpAM9fEHrxzqr4PGOlHdWy+YDjFjrs+qD0pERdAZ+sZbXmSdBXHnXAGLKHIEh4BbTPulnBblfM4nFgsIyhP0w1XlrUBaE1yy9Zrbbr/qYh3Y15Iq9pFrJFS3rl5Fp1ipP1WSL2Q+JVr8RdIDWv4gc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Er5cwivK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Er5cwivK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFBA1C4CED3;
	Thu,  7 Nov 2024 19:40:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731008420;
	bh=IWvqkmTISTARZW0y3rN5iLDc3lj9CpSikNJUn4V2T2A=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=Er5cwivKMuEEAWYBP8V80Wo1Yk2uTHAiDvMF9sfrny17jJpVfK5siM5dNs2Jw5hFI
	 tqpuMoT55ZfPIOSoSAnvK1dSJ1I7QvmSc3GEoNqGAGt5SZiRGPR8rteuUp5r9ErtXa
	 gQfpBFB8MWhN+iDjg1paKniFzyDwhufAohWAdl6ye0OleUMG5TX3IPZMHHw9o8p2UJ
	 x80ifmvyfY0HiyTgadV67oYRPwe8rah1TQ3FEC313JgtNKf0GADdwWkdg6bKNO7Mlp
	 d0oauorayYPrOEeX/v/Z6KX8oedPuEjR9+y4Ohqhz3CTeM5ZrOpEvlCh1PxjXhXa41
	 OfMaERBsreXGQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 33D7D3809A80;
	Thu,  7 Nov 2024 19:40:31 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/1] netfilter: nf_tables: wait for rcu grace period on
 net_device removal
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <173100843000.2072933.7866260416336178549.git-patchwork-notify@kernel.org>
Date: Thu, 07 Nov 2024 19:40:30 +0000
References: <20241107113212.116634-2-pablo@netfilter.org>
In-Reply-To: <20241107113212.116634-2-pablo@netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 edumazet@google.com, fw@strlen.de

Hello:

This patch was applied to netdev/net.git (main)
by Pablo Neira Ayuso <pablo@netfilter.org>:

On Thu,  7 Nov 2024 12:32:12 +0100 you wrote:
> 8c873e219970 ("netfilter: core: free hooks with call_rcu") removed
> synchronize_net() call when unregistering basechain hook, however,
> net_device removal event handler for the NFPROTO_NETDEV was not updated
> to wait for RCU grace period.
> 
> Note that 835b803377f5 ("netfilter: nf_tables_netdev: unregister hooks
> on net_device removal") does not remove basechain rules on device
> removal, I was hinted to remove rules on net_device removal later, see
> 5ebe0b0eec9d ("netfilter: nf_tables: destroy basechain and rules on
> netdevice removal").
> 
> [...]

Here is the summary with links:
  - [net,1/1] netfilter: nf_tables: wait for rcu grace period on net_device removal
    https://git.kernel.org/netdev/net/c/c03d278fdf35

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


