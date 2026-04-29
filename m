Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DD461632E7;
	Wed, 29 Apr 2026 01:31:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777426280; cv=none; b=ljABqxkxqltVu7c6OAFwEUwW03TCSk2MfArzbHexz5kuYdbCJog4A4NEpFymLCurDXqzrhTn4XsBP037xLh0sCOGj9Y/8zZTtSSOy/4X20zN1IwhwRIlmlRxrD9bQmde6X1JOVTdw8p4dg9auQtgggTNtnQ6SC1//k/By564i/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777426280; c=relaxed/simple;
	bh=h89ZhOK/2rQgO5t9c/4hJ80hHOJV3qTYWpj9r/xokQE=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=pK3tO8EkXKgRT97jekvtwUJYBqKiSLX/DctW/kQILzhf4gxSFXDvV+gMx9/HuAa2MNmVtjaoZPgxkFsXS9LbA50PeiZovQG+4l0wnih3TsOTDDn9Udujp1MS18iRtf27qM5XkRRCMkL7AUEXfSkslmU1Qh9ljDqqqtxLMNPT+3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GkhxHw5h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GkhxHw5h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 108EEC2BCB7;
	Wed, 29 Apr 2026 01:31:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777426280;
	bh=h89ZhOK/2rQgO5t9c/4hJ80hHOJV3qTYWpj9r/xokQE=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=GkhxHw5hSueH+mFTZ5ORmH6pLrNTPAjf9pwATZQT0rWZSpnVL8AHiyPI1vGmYXb3U
	 7LQkdXNRA4QtBSdX9SqjibsC7PvEYoQ9r3ZqzqcKX2Txb3BgHkKAsxjSfKB/0VcNch
	 RggFqhkXq3CUya+yIh0lYC+UX7G5E6CZ1SiCsLU+I6Dt4O7ZWXsxlcOpa0q1JqdJCL
	 rBtRiqCa19RNFcTus5h+oXGKTQyZyZORBfEiOifKHUnIsaCTtI/XLEr8nkHBgrxdCn
	 v2rwp0E8tHKoUC2kUARzh2aru6DuwYdqyZU4oZMnQwe05fXgbIG79VFnb2yJ7JM6/N
	 2rQ7CaC+KVwdg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 7CCFE39302C2;
	Wed, 29 Apr 2026 01:30:37 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2 0/2] sctp: fix a vtag verification failure caused
 by
 stale INITs
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <177742623604.1288483.6985872404359862871.git-patchwork-notify@kernel.org>
Date: Wed, 29 Apr 2026 01:30:36 +0000
References: <cover.1777214801.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1777214801.git.lucien.xin@gmail.com>
To: Xin Long <lucien.xin@gmail.com>
Cc: netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
 linux-sctp@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
 edumazet@google.com, pabeni@redhat.com, horms@kernel.org,
 pablo@netfilter.org, fw@strlen.de, phil@nwl.cc, marcelo.leitner@gmail.com,
 yiche.cy@gmail.com

Hello:

This series was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Sun, 26 Apr 2026 10:46:39 -0400 you wrote:
> Similar to Scenario B in commit 8e56b063c865 ( netfilter: handle the
> connecting collision properly in nf_conntrack_proto_sctp"):
> 
> Scenario B: INIT_ACK is delayed until the peer completes its own handshake
> 
>   192.168.1.2 > 192.168.1.1: sctp (1) [INIT] [init tag: 3922216408]
>     192.168.1.1 > 192.168.1.2: sctp (1) [INIT] [init tag: 144230885]
>     192.168.1.2 > 192.168.1.1: sctp (1) [INIT ACK] [init tag: 3922216408]
>     192.168.1.1 > 192.168.1.2: sctp (1) [COOKIE ECHO]
>     192.168.1.2 > 192.168.1.1: sctp (1) [COOKIE ACK]
>   192.168.1.1 > 192.168.1.2: sctp (1) [INIT ACK] [init tag: 3914796021] *
> 
> [...]

Here is the summary with links:
  - [net,v2,1/2] netfilter: skip recording stale or retransmitted INIT
    https://git.kernel.org/netdev/net/c/576a5d2bad48
  - [net,v2,2/2] sctp: discard stale INIT after handshake completion
    https://git.kernel.org/netdev/net/c/8a92cb475ca9

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


