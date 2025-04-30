Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFCD52DC761;
	Wed, 30 Apr 2025 00:19:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745972398; cv=none; b=gwMq3ZTFVdFNZmpuEWqhV0ykj/cHEpWe7RpwO68jRzwTOPti+nDMvnLlo2G1Q+stT1troYYAB3ZFcbXx8cKKjlphSB3En3LQef/J81CbEEdyDZ11yKK4rDhLa/n8K2LQ4mZAfsXqo9imku/y+fk7iGLG+st9c9J6FPmMBrm1d4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745972398; c=relaxed/simple;
	bh=zP+nPvwhrjpFQt8o5V51U7DeMphw+ykLZjsaNV+96+Y=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=MItIBGchhRHsmUjjIU0cPnhMCDd03s5SFjJkGo6XSYIq4QuIdTBDCrxn0VxS8JuQUUHW9XLPJIAT7/ACRdLIM6+vOX1zceIC8L9uNU87kFtdRRkJWJCzF01E8UDscdyZ1CxeTVEZc8jlGnfHyFSNV/ZPDKDj3s8uSBIFDpDPSto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sgrw7AP7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sgrw7AP7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 459D5C4CEE3;
	Wed, 30 Apr 2025 00:19:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745972398;
	bh=zP+nPvwhrjpFQt8o5V51U7DeMphw+ykLZjsaNV+96+Y=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=sgrw7AP7/uZfDjKulohV9nb4Q9Zn9VCpBKGoUWLzn2NqKfNR18NzSVr22LT644JBI
	 Xlu0YETo0HZ8PUrk43bax296NBvkKKpwI1P7SxqhaLQI585d9hEHQgsidJbIcqYErS
	 75RoEC58Vn8d5guBT3BH1zNr8FHemLnWOEXsg5UcIGMuv4+pGDISLLKilsrzSAYvVX
	 1T5OEWEqIET7sGA5nkito/awH+/pZWYtX+IoRoJxTkSJ83znm0ot0v1Li07wAdBkfa
	 Rn6Pnce7n2ipszEgcFiGDGr7ubvLxcIbNp5gFAZ7PjwjPCmJ+/lSFPpYWjXOTz4TeN
	 IjW5XMysCW0QA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 70F153822D4E;
	Wed, 30 Apr 2025 00:20:38 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 1/6] netfilter: xt_IDLETIMER: convert timeouts to
 secs_to_jiffies()
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <174597243725.1842791.14946610720814251605.git-patchwork-notify@kernel.org>
Date: Wed, 30 Apr 2025 00:20:37 +0000
References: <20250428221254.3853-2-pablo@netfilter.org>
In-Reply-To: <20250428221254.3853-2-pablo@netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 edumazet@google.com, fw@strlen.de, horms@kernel.org

Hello:

This series was applied to netdev/net-next.git (main)
by Pablo Neira Ayuso <pablo@netfilter.org>:

On Tue, 29 Apr 2025 00:12:49 +0200 you wrote:
> From: Easwar Hariharan <eahariha@linux.microsoft.com>
> 
> Commit b35108a51cf7 ("jiffies: Define secs_to_jiffies()") introduced
> secs_to_jiffies().  As the value here is a multiple of 1000, use
> secs_to_jiffies() instead of msecs_to_jiffies to avoid the multiplication.
> 
> This is converted using scripts/coccinelle/misc/secs_to_jiffies.cocci with
> the following Coccinelle rules:
> 
> [...]

Here is the summary with links:
  - [net-next,1/6] netfilter: xt_IDLETIMER: convert timeouts to secs_to_jiffies()
    https://git.kernel.org/netdev/net-next/c/f4293c2baf6f
  - [net-next,2/6] netfilter: xt_cgroup: Make it independent from net_cls
    https://git.kernel.org/netdev/net-next/c/3ba0032afea8
  - [net-next,3/6] net: cgroup: Guard users of sock_cgroup_classid()
    https://git.kernel.org/netdev/net-next/c/087645314745
  - [net-next,4/6] netfilter: conntrack: Remove redundant NFCT_ALIGN call
    https://git.kernel.org/netdev/net-next/c/eaa2b34db021
  - [net-next,5/6] docs: tproxy: fix formatting for nft code block
    https://git.kernel.org/netdev/net-next/c/149a133a5481
  - [net-next,6/6] netfilter: nf_tables: export set count and backend name to userspace
    https://git.kernel.org/netdev/net-next/c/0014af802193

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


