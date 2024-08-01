Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3DA1446A1;
	Thu,  1 Aug 2024 10:20:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722507632; cv=none; b=lS5h1yDq0tiBz5YcbbvCbpiVmx4JWxFH1ZL/kyBuRlVbYvr6TU2St3M39tBHPWf8NVt8pdVAIWHuyqTiittq1XajzEGCIpr9hXQAZ20i5tm637qEJSzU1VYSheVO0LvXE5vaIa+k4GQrvuI69qHKHjBFSU9gOeLOMFBvA9wDzVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722507632; c=relaxed/simple;
	bh=yuY62z9Ku//bmBc4AvZQ6FsYTlrjf3h2pnOjtcjlIVI=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=j5QA31uUMj0zix5sFhQ7Lln/90Dl8LxgeDMmhS+hIs8UQzTP77huigRjuKA/PC3b3Us1YwBNI03ph8k/CzpInfJ9eA78OEBuwvmBnY5GpJBZZCkU2XUOB/0Z1RPUOp14OAehCLjaNbewKt+9uj2w6DiCfLOaaMh80i6nm/shNl8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dvNhcydO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dvNhcydO"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 627E8C4AF0A;
	Thu,  1 Aug 2024 10:20:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722507632;
	bh=yuY62z9Ku//bmBc4AvZQ6FsYTlrjf3h2pnOjtcjlIVI=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=dvNhcydO2PZNUbH4VA9fBCs4l7VqiScsXIUPbCcUj3ldhRfWtzngHLu5wOWUira44
	 7v/H9w38lDOQDk5E5kpwbUuevd5bqisl35+CCpYTNmMrHbvckwISO97iP3S9dwNjiC
	 pJJC6I/NjZdw8HfQxvtf88mYQB7UMNCyciqwFD1QjKSix/F2Qd34ayE/gjFqybPrNT
	 97lbmmPW5iaFJbccTlGg0af9LD7kXPqIf05fnvXZFaKKSPnDwtii+P82WIkP6s1J62
	 dJbmCE0bTAiRvWaFF/wkl98ZEcRWJM0GFqkxawE7eFKxFimubzWECPVHmCG/ZwFnlk
	 y1dBAYvDq+GoA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 52FDCC43443;
	Thu,  1 Aug 2024 10:20:32 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/2] netfilter: iptables: Fix null-ptr-deref in
 iptable_nat_table_init().
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <172250763233.8894.11448540825840373569.git-patchwork-notify@kernel.org>
Date: Thu, 01 Aug 2024 10:20:32 +0000
References: <20240731213046.6194-2-pablo@netfilter.org>
In-Reply-To: <20240731213046.6194-2-pablo@netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 edumazet@google.com, fw@strlen.de

Hello:

This series was applied to netdev/net.git (main)
by Pablo Neira Ayuso <pablo@netfilter.org>:

On Wed, 31 Jul 2024 23:30:45 +0200 you wrote:
> From: Kuniyuki Iwashima <kuniyu@amazon.com>
> 
> We had a report that iptables-restore sometimes triggered null-ptr-deref
> at boot time. [0]
> 
> The problem is that iptable_nat_table_init() is exposed to user space
> before the kernel fully initialises netns.
> 
> [...]

Here is the summary with links:
  - [net,1/2] netfilter: iptables: Fix null-ptr-deref in iptable_nat_table_init().
    https://git.kernel.org/netdev/net/c/5830aa863981
  - [net,2/2] netfilter: iptables: Fix potential null-ptr-deref in ip6table_nat_table_init().
    https://git.kernel.org/netdev/net/c/c22921df777d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


