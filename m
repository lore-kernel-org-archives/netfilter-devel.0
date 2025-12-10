Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD84D2FE053;
	Wed, 10 Dec 2025 09:53:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765360397; cv=none; b=dph7iFeEPNTtviV5ZBg442+lomqvHx3MNsWdR9DXcv0NHcE80A9pSnc3QC6drB0QJG/OcO++uGuR6hmrbncI+hnydBo6cz1mjtDBMs2kGr6bIDCaXxv3Nz1lt6I1/Lj4iPiUFVbYetXMYZ0/EYTWJUBfocPO/vDXn8GxbZtTLhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765360397; c=relaxed/simple;
	bh=+1iuG26qlwxaL6MV8fpa5GVIUtaMHnVUq4nDGQ8Z1zI=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=lKzqvSpSPigDEhtJb3U2Xiey4X2Ch2QvZLsHBVVhyZh31ct7Hfrww9BcxvoH9HVrgbCXS7ePbc6a/4MIJN+bF6AOaBf8qjjyQNCWmHieOG0AWjsUMxTQ39T/iiDnMQdN8zabY/D5LFeH/wueAC8/IGHtPI7bARxG4hSx62/ceRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=d7JZOrPl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d7JZOrPl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DE3AC4CEF1;
	Wed, 10 Dec 2025 09:53:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765360396;
	bh=+1iuG26qlwxaL6MV8fpa5GVIUtaMHnVUq4nDGQ8Z1zI=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=d7JZOrPl+I6WNO9a6Di5P2s+N0X99m6puf3FDVeuRADF6n09fZOzGD+XdiNHAk7V4
	 1lYGWVT1pwGZNE9q6M6mlPc1kia0XIjSh/vxtzQtplCjAAicVOgaDfWVQFjlEEA2rJ
	 DxbZmnd+iSNtkZIycxRLbwr/E5WmPMelr8nvstAegtjgqtb84/6ChkD55D+CkkU2de
	 ksvjwP4gC9dBvdQn+3LdmM7wb0jkBj+cY2UtMTNlzBoakTdlcZe4IeR6nw9pApX6p8
	 luX16Og1wxxmOEjaUfdwcTmZOEwcArt0uX7OQHX30/6k6HPTzIuBjqO4+oNHK6bm4m
	 xF6iTEjFlvKPw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 3B8FD3809A18;
	Wed, 10 Dec 2025 09:50:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/4] inet: frags: flush pending skbs in
 fqdir_pre_exit()
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <176536021103.532791.16522947311403253332.git-patchwork-notify@kernel.org>
Date: Wed, 10 Dec 2025 09:50:11 +0000
References: <20251207010942.1672972-1-kuba@kernel.org>
In-Reply-To: <20251207010942.1672972-1-kuba@kernel.org>
To: Jakub Kicinski <kuba@kernel.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
 pabeni@redhat.com, andrew+netdev@lunn.ch, horms@kernel.org,
 pablo@netfilter.org, fw@strlen.de, netfilter-devel@vger.kernel.org,
 willemdebruijn.kernel@gmail.com, kuniyu@google.com

Hello:

This series was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Sat,  6 Dec 2025 17:09:38 -0800 you wrote:
> Fix the issue reported by NIPA starting on Sep 18th [1], where
> pernet_ops_rwsem is constantly held by a reader, preventing writers
> from grabbing it (specifically driver modules from loading).
> 
> The fact that reports started around that time seems coincidental.
> The issue seems to be skbs queued for defrag preventing conntrack
> from exiting.
> 
> [...]

Here is the summary with links:
  - [net,1/4] inet: frags: avoid theoretical race in ip_frag_reinit()
    https://git.kernel.org/netdev/net/c/8ef522c8a59a
  - [net,2/4] inet: frags: add inet_frag_queue_flush()
    https://git.kernel.org/netdev/net/c/1231eec6994b
  - [net,3/4] inet: frags: flush pending skbs in fqdir_pre_exit()
    https://git.kernel.org/netdev/net/c/006a5035b495
  - [net,4/4] netfilter: conntrack: warn when cleanup is stuck
    https://git.kernel.org/netdev/net/c/92df4c56cf5b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


