Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E93A71917D7;
	Thu, 10 Oct 2024 12:00:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728561629; cv=none; b=LaHJfrkkXKCC0oGhyZN0w5tpGhKXyzv/JNOk9GZ8MbLCewU8qqznxu2pWXMXF6bL++oYByBbSpiFxDkvs0aWzXupdbWyccmuR+gI++FIGhZbuGxeync2jVKxzNTkw7PAbssLilRvQ6jqAEtME05a2THFZnAaOt/nKBq7zG5PDOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728561629; c=relaxed/simple;
	bh=kFUuJQ/Y3gbUCXUle8uFcow8gEZ23gMM6oj9oZMU5HM=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=c5aMBhgtqKUVrE14oPuXYx+N9zb27uI7rP/YIxMGKNX0Ljqas4q1SJhaI4C/ea1WmSmE0IVh8d5u2QZJFxNELJrZ615hHmG8G19c9pxH4Feqc9YHvpbQR+TrajGOsCn0FtDwLZ1whVm4M6E3htN/asY9liqKGftn4RmAQo0C6TQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ak0kpoSy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ak0kpoSy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 585F8C4CEC5;
	Thu, 10 Oct 2024 12:00:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728561626;
	bh=kFUuJQ/Y3gbUCXUle8uFcow8gEZ23gMM6oj9oZMU5HM=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=Ak0kpoSyyigr6F0sUvDIWUQBYW53XHXmkaADwt5yKE5V7awXIRPCHhQbpadBbjB67
	 dcGe2sKIWeXovGe33wq8jbGSQCmuli+K6WtGiKgFOGnqH25AtDNN3PSfVucHQkSJUa
	 8hNFNSSCSfNU/Atm1GMhcEstpFgm+N4M/XS868FN6ujg7mscTIYMCeLGNO32/EGhca
	 Kgr/BygOx5ZCrIpeu7gbF5k0kQBWN77XyVcPZHX5XJtZ10UOQ1qar/UB5YH4bwVA9y
	 OTrP0njG3S+hJOjnWh4Ovn5l/pr6Fj42XkbDkrKatZtW0Aq7b8UfGqILH1s8qIswMk
	 quAlT+21SyMWg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id EAFB53803263;
	Thu, 10 Oct 2024 12:00:31 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/3] netfilter: xtables: avoid NFPROTO_UNSPEC where needed
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <172856163076.1995536.7466933968388077286.git-patchwork-notify@kernel.org>
Date: Thu, 10 Oct 2024 12:00:30 +0000
References: <20241009213858.3565808-2-pablo@netfilter.org>
In-Reply-To: <20241009213858.3565808-2-pablo@netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 edumazet@google.com, fw@strlen.de

Hello:

This series was applied to netdev/net.git (main)
by Pablo Neira Ayuso <pablo@netfilter.org>:

On Wed,  9 Oct 2024 23:38:56 +0200 you wrote:
> From: Florian Westphal <fw@strlen.de>
> 
> syzbot managed to call xt_cluster match via ebtables:
> 
>  WARNING: CPU: 0 PID: 11 at net/netfilter/xt_cluster.c:72 xt_cluster_mt+0x196/0x780
>  [..]
>  ebt_do_table+0x174b/0x2a40
> 
> [...]

Here is the summary with links:
  - [net,1/3] netfilter: xtables: avoid NFPROTO_UNSPEC where needed
    https://git.kernel.org/netdev/net/c/0bfcb7b71e73
  - [net,2/3] netfilter: fib: check correct rtable in vrf setups
    https://git.kernel.org/netdev/net/c/05ef7055debc
  - [net,3/3] selftests: netfilter: conntrack_vrf.sh: add fib test case
    https://git.kernel.org/netdev/net/c/c6a0862bee69

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


