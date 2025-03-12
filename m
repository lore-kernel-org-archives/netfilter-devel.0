Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB4711EB191;
	Wed, 12 Mar 2025 20:19:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741810796; cv=none; b=Xwnq9H+ScFaLl/96fgEU6n/7JI1JjSlEIbszygnWDbEu8FznbRC2ItRU+W/aWHA+rfoRjCqtxshUFRYiwryWdRKpT6eCdS5yLgqgBPZMqU9hxqkUXn/M6QuJlCv9jMcgT8vt0t/GhIJskrctuykb34X0qvmQvwACIDaPVsKF888=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741810796; c=relaxed/simple;
	bh=eUPDWDjxdEdOfOSl6gOwd5Lk7nckPxgTXNP4nYLK3/g=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=Hm3Esr+CQzu8dyhRdTfwgev7Pjn71XLrl2TjOXXsv6J3lHouzM2LEyPbd1PzPayHaTHsVOQRqC568FA6tKnFqFAUrzs2AlXJA0AOLNTB8HRWgwAo+5HRbnZ2Vsgzk67BfUMCw2LOgcG+Xek6BuZ+GN/4JHbnAetnpjoWUhe9AwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GRopA5nT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GRopA5nT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 896CAC4CEDD;
	Wed, 12 Mar 2025 20:19:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741810796;
	bh=eUPDWDjxdEdOfOSl6gOwd5Lk7nckPxgTXNP4nYLK3/g=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=GRopA5nTl1UI8BIj/22q0D3CqVF1tD1x54XFYeQh3RA8o7+Okj90wto+YNjVCehC2
	 GXCGD8mOa7T5w25BoAHP2YpoWVLv/iV5V+b4jWzsDhfHISkB7DwmjopJ14px3LwvD5
	 2h0awpU+20q5NufImWzu7PQBiPfqUFYdZ/H8VPCKEXWpLEy3Fmd/EM3xj5yrSB1f4s
	 NYLS3IiBW3QcAuVnqYXvCYsGJuTvDnJOyH1QYnTduwJ2yP+tU39gd3tpS+8BuQU8N8
	 IIUJm+R3FlOhZc6W1FU21jpt+X4oGkIPx4Z8PFZxxcAH1XjN4UWY6YMKHSsN/Zp05z
	 RQQujsm+j69BA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 33DD8380DBDF;
	Wed, 12 Mar 2025 20:20:32 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: revert to lockless TC_SETUP_BLOCK and
 TC_SETUP_FT
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <174181083101.918963.13075833361323469787.git-patchwork-notify@kernel.org>
Date: Wed, 12 Mar 2025 20:20:31 +0000
References: <20250308044726.1193222-1-sdf@fomichev.me>
In-Reply-To: <20250308044726.1193222-1-sdf@fomichev.me>
To: Stanislav Fomichev <sdf@fomichev.me>
Cc: netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
 coreteam@netfilter.org, horms@kernel.org, corbet@lwn.net,
 andrew+netdev@lunn.ch, pablo@netfilter.org, kadlec@netfilter.org

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Fri,  7 Mar 2025 20:47:26 -0800 you wrote:
> There is a couple of places from which we can arrive to ndo_setup_tc
> with TC_SETUP_BLOCK/TC_SETUP_FT:
> - netlink
> - netlink notifier
> - netdev notifier
> 
> Locking netdev too deep in this call chain seems to be problematic
> (especially assuming some/all of the call_netdevice_notifiers
> NETDEV_UNREGISTER) might soon be running with the instance lock).
> Revert to lockless ndo_setup_tc for TC_SETUP_BLOCK/TC_SETUP_FT. NFT
> framework already takes care of most of the locking. Document
> the assumptions.
> 
> [...]

Here is the summary with links:
  - [net-next] net: revert to lockless TC_SETUP_BLOCK and TC_SETUP_FT
    https://git.kernel.org/netdev/net-next/c/0a13c1e0a449

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


