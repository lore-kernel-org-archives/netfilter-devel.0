Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AC31245020;
	Thu, 17 Apr 2025 13:30:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744896603; cv=none; b=Zt4qD5HSyZuqv8wCvqkkMovUsxcpGkfufArvhxNYD7KzMScN2MT2U3OHr9Jbd43Eo8/d0FrzY+hrPdnM3Yv0zUY/G5HoBzDdVDmxdNHujgYTtP4TTJSsRA8p350HJaJ0y61cISZ+LJhWw9esE64poy/5xxkRl5yXT7xL3njoBNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744896603; c=relaxed/simple;
	bh=3dmSaeoEZ6OeeOgRybdvKpk2GEZ+hgqanPxBjeG5TI4=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=o5s4yqQpnb+OuOZYW3V8hcjno8b46i3hypFTeM5gkA+K/dHdB3z8XoFsXNFY/SZ8jakLs5+lJYNd4rQGVXqUHSDfcDzSo/uIu0tPI9dbdMx4gq6K7k0KclsAI2oF+DGmoGihH7C3F55ielFwbzYru9CnRwEzQJwonyFZl8ln1hk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ErPJacOw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ErPJacOw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27D28C4CEE4;
	Thu, 17 Apr 2025 13:30:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744896603;
	bh=3dmSaeoEZ6OeeOgRybdvKpk2GEZ+hgqanPxBjeG5TI4=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=ErPJacOwBsYioaq3Zp5E72ZWUYcJQzWX3y82HzHpxjhrI6/OWg4ZNcL11xyWlKHnI
	 yGHEYNkaukoNHktcGaw0VZn/QccX4v2rDhBqLzpRkdbN9koO7ubq4u5xgUUJX89HF+
	 w9DpPLvLbaqW5UckNAxKpqSyT8NSK8cY8RwXvwggvnYln2MBJes1z5b6LJ0+HFLayq
	 XWfq1wvWOPV53AgByEs0IPyEfHtYfUgAqh3fh6HccwKeeOHNs/Tv2/mNX+LlwedSu/
	 XTWc9tsbfYntdeS6Y90PWfBpwjzSzAYQM93yr/bLKoaKEyMBP8gnw0fMRkMdAifhbk
	 gkt9/qBDtJhAw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 70C14380664C;
	Thu, 17 Apr 2025 13:30:42 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/1] netfilter: conntrack: fix erronous removal of offload
 bit
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <174489664127.4077779.16037357822015559448.git-patchwork-notify@kernel.org>
Date: Thu, 17 Apr 2025 13:30:41 +0000
References: <20250417102847.16640-2-pablo@netfilter.org>
In-Reply-To: <20250417102847.16640-2-pablo@netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 edumazet@google.com, fw@strlen.de, horms@kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Pablo Neira Ayuso <pablo@netfilter.org>:

On Thu, 17 Apr 2025 12:28:47 +0200 you wrote:
> From: Florian Westphal <fw@strlen.de>
> 
> The blamed commit exposes a possible issue with flow_offload_teardown():
> We might remove the offload bit of a conntrack entry that has been
> offloaded again.
> 
> 1. conntrack entry c1 is offloaded via flow f1 (f1->ct == c1).
> 2. f1 times out and is pushed back to slowpath, c1 offload bit is
>    removed.  Due to bug, f1 is not unlinked from rhashtable right away.
> 3. a new packet arrives for the flow and re-offload is triggered, i.e.
>    f2->ct == c1.  This is because lookup in flowtable skip entries with
>    teardown bit set.
> 4. Next flowtable gc cycle finds f1 again
> 5. flow_offload_teardown() is called again for f1 and c1 offload bit is
>    removed again, even though we have f2 referencing the same entry.
> 
> [...]

Here is the summary with links:
  - [net,1/1] netfilter: conntrack: fix erronous removal of offload bit
    https://git.kernel.org/netdev/net/c/d2d31ea8cd80

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


