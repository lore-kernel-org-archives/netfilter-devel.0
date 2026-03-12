Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0AD22741DF;
	Thu, 12 Mar 2026 02:20:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773282024; cv=none; b=Myb6TlAy+aQU/chj/GhpTyqZxYjLUPI9pODpSCd+ozau4tWmrFLvZ0KNRdyVVYl76zCtzBGFA816BSOZo7tVgYqHjdqB2Kw2Z8u6rt94X1p3Es4X01jtxJDhvR0eWjqEvhtXFHZb/pMwi07/ie67q3P/++aPs+y3Q3AZ3NMN1P0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773282024; c=relaxed/simple;
	bh=8E3m2kBkRFYIoTamH3B0frDzxwADFNihLYSGx85Zu7A=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=cdUlY57mrufSpAuAT9GCsZrzRp1GXAMbKz5klwpfICkAX+QqwAXemnW71uSOi2SiRySaglOTAiX2wLc6eYkRV3bP9oN8v07hHA+rX2/LczWEIXgjNwjbVY4LqEvoXZjKLFa0/JbTQ408SMPwk4rnCRv2iLMxhM5lKhsMDHn3A8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RZATrwQj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RZATrwQj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D031C4CEF7;
	Thu, 12 Mar 2026 02:20:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773282024;
	bh=8E3m2kBkRFYIoTamH3B0frDzxwADFNihLYSGx85Zu7A=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=RZATrwQjBYtdelB70HI5NcoqyLiJ3fToy4p5u44GSvtOf+iKWz5FeR071kxzJXL2k
	 AnwCzVnhYlmOli0421QTiPq+M21jJ2AkjqGk0MoD8eKHerjCgpwnyWUxrpUJahQmdj
	 vBBVNzOJES4EDH1W2ApMkdc70+U9RAoeOd2UVZXBwweHH7UUPNe1NiXoivumoifC/C
	 hY6ZMUNeZhS7+iKvEYsuLcxbZSwSBGioJQMFkU2/Y8FUrIAAu5kxuRJhkroSQAQIRd
	 XwkElyfS0FAn5ZXTWi+qjGqQCBiFjX+olunlqT9n9/DF7e0Y8/h2drZXJE+xc59lZx
	 Rdd5QfkDxy4WA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 7D1123808200;
	Thu, 12 Mar 2026 02:20:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2 1/7] netfilter: nf_tables: Fix for duplicate device
 in
 netdev hooks
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <177328202030.3908053.15004377110338250690.git-patchwork-notify@kernel.org>
Date: Thu, 12 Mar 2026 02:20:20 +0000
References: <20260310132050.630-2-fw@strlen.de>
In-Reply-To: <20260310132050.630-2-fw@strlen.de>
To: Florian Westphal <fw@strlen.de>
Cc: netdev@vger.kernel.org, pabeni@redhat.com, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, netfilter-devel@vger.kernel.org,
 pablo@netfilter.org

Hello:

This series was applied to netdev/net.git (main)
by Florian Westphal <fw@strlen.de>:

On Tue, 10 Mar 2026 14:20:43 +0100 you wrote:
> From: Phil Sutter <phil@nwl.cc>
> 
> When handling NETDEV_REGISTER notification, duplicate device
> registration must be avoided since the device may have been added by
> nft_netdev_hook_alloc() already when creating the hook.
> 
> Suggested-by: Florian Westphal <fw@strlen.de>
> Reported-by: syzbot+bb9127e278fa198e110c@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=bb9127e278fa198e110c
> Fixes: a331b78a5525 ("netfilter: nf_tables: Respect NETDEV_REGISTER events")
> Tested-by: Helen Koike <koike@igalia.com>
> Signed-off-by: Phil Sutter <phil@nwl.cc>
> Signed-off-by: Florian Westphal <fw@strlen.de>
> 
> [...]

Here is the summary with links:
  - [net,v2,1/7] netfilter: nf_tables: Fix for duplicate device in netdev hooks
    https://git.kernel.org/netdev/net/c/b7cdc5a97d02
  - [net,v2,2/7] netfilter: nf_tables: always walk all pending catchall elements
    https://git.kernel.org/netdev/net/c/7cb9a23d7ae4
  - [net,v2,3/7] netfilter: nft_set_pipapo: fix stack out-of-bounds read in pipapo_drop()
    https://git.kernel.org/netdev/net/c/d6d8cd2db236
  - [net,v2,4/7] netfilter: x_tables: guard option walkers against 1-byte tail reads
    https://git.kernel.org/netdev/net/c/cfe770220ac2
  - [net,v2,5/7] netfilter: nfnetlink_queue: fix entry leak in bridge verdict error path
    https://git.kernel.org/netdev/net/c/f1ba83755d81
  - [net,v2,6/7] netfilter: nfnetlink_cthelper: fix OOB read in nfnl_cthelper_dump_table()
    https://git.kernel.org/netdev/net/c/6dcee8496d53
  - [net,v2,7/7] netfilter: xt_IDLETIMER: reject rev0 reuse of ALARM timer labels
    https://git.kernel.org/netdev/net/c/329f0b9b48ee

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


