Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93BFD3B14C6;
	Fri, 28 Aug 2026 23:01:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787958074; cv=none; b=SR83D1ZV3K5l+XYoTP0y1QHL+hFpzNEZ3Yzs5kwx/35HcsWmorT9EJOShIOkBDi0Xjp5Lcq5EtycAhRHuUNSAzhciYPLh4P+R8evKj2gG+4lSB3z2A78TMMRdvnQigAFnl3EiacLjmhHcO/95u4Aj81xO5OiJFWJZmEeJ5e/tu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787958074; c=relaxed/simple;
	bh=PPeG5YKwww2XuYRnneRrs0ve93HXjp1lGixZDJxZUmE=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=lPyq54UQqAjRt8+UE9LxOn5qdIIgMJDzdIUemAc5boYDPVqAHk3d3dMmpK2CW+1EVWEYpQEkMSY4LWQekCg/4qslBlAbNX8cppbC1UJIMnJvLfs5WCobzfILa/LQUwa5heHgOV7FF9kLJMota+yXlCy6dxlLWFICPrEpaYuHnj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZPqkEj2G; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZPqkEj2G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C89C1F00A3D;
	Fri, 28 Aug 2026 23:01:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787958073;
	bh=pmCvNyGR8BfcjGV8vuTR2JD9A97SHyuiLHn7yTZHmWI=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=ZPqkEj2G6Q3itfhdaA26MQlan0yNxTa2MFvIdFE5icBR6EKpoVVqHBCOIwnrFzmtm
	 u9+PsFVXXFjKmlmIYxNJ8QLpUS3MPfq5wvu5yz81ZtRzMaxG0hPbg0G0Lq97RjeS39
	 OZFt1QEqN9Tb3KCpao1d9jDyy6rpGFUonkwBqqz91JC1kskvkvUrrgRDd+gwT3smEd
	 Suem4oArd2o7dzi+ZPUiiIf2gU0wiG4DByPme8ewn61JwgnhptX+WPX3N+Nw4lZ4lT
	 IChLw0yluBsYUGBb9vMSq7GmQgsOC3uorzqhX1XBZTIOdQO4tjSvLoMa/PaYPajVE2
	 Db1bibu5iV8pA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 196E8380AA69;
	Fri, 28 Aug 2026 23:00:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2 0/2] netlink: specs: fixes for conntrack dump
 filtering
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <178795801796.2832451.10191767513560282573.git-patchwork-notify@kernel.org>
Date: Fri, 28 Aug 2026 23:00:17 +0000
References: <20260826220444.4054714-1-i.maximets@ovn.org>
In-Reply-To: <20260826220444.4054714-1-i.maximets@ovn.org>
To: Ilya Maximets <i.maximets@ovn.org>
Cc: netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, horms@kernel.org,
 donald.hunter@gmail.com, one-d-wide@protonmail.com, matttbe@kernel.org,
 fw@strlen.de, linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
 ast@fiberby.net

Hello:

This series was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 27 Aug 2026 00:01:10 +0200 you wrote:
> Version 2:
>  - Also added missing tuple attributes for the dump request.
>  - Converted into a set by adding the patch 2.
> 
> Version 1:
>  - https://lore.kernel.org/r/20260825155832.3685714-1-i.maximets@ovn.org
> 
> [...]

Here is the summary with links:
  - [net,v2,1/2] netlink: specs: fix the conntrack filter type
    https://git.kernel.org/netdev/net/c/2a004bfb62bd
  - [net,v2,2/2] netlink: specs: add missing mask attributes for conntrack dump
    https://git.kernel.org/netdev/net/c/8b348496cbec

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


