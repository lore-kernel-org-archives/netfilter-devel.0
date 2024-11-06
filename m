Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04BE61D95AA;
	Wed,  6 Nov 2024 02:20:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730859631; cv=none; b=LNT7fvjvbYD5tAdPsPT/WS0u0lG2etQ9YAJkNPepMEQg44bRJxRkPTMdHcAaoihHjx4mHrhAay5YJjP+PwTzu4pORHAKIAFVUEDGycSVTD+T+smmwGVpqEF1HNBMWsgJMjCXIwbpzTzBv5aoV59FB3ltxQRNdendX72IFZDQolc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730859631; c=relaxed/simple;
	bh=lpFvM7OZwrkLaZJSn+dHV7eCffsP/oorN980LuDH8Io=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=bImEhU6nRjdpTlkBOL/ze3oTDvAsSLTviBa18NwN6HSPH5T3x8JsVzg2O6bi/12m46+LQBBDkO5TA95SoIYn8tp+PnRD+4muH4c2CTmlBv7z+SURSdboCXI1/cj3i8vV32z/Bg4x8XINnLNrnllMsveqZiMDle/Yxm8/mWN8pLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JrMPUMEr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JrMPUMEr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91EF2C4CECF;
	Wed,  6 Nov 2024 02:20:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730859630;
	bh=lpFvM7OZwrkLaZJSn+dHV7eCffsP/oorN980LuDH8Io=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=JrMPUMErMh8a2pLqs55pnHEt8rNUjAHtRt/kSweik6nOIehepqcS0/+nY/9UK7Mgv
	 kwOPJru++S/fCx1RU8DVbXSN+ywX1TRxDri1xc3zdFURNzC0dhf2nkIhF/zm9IW1lu
	 JSyKzszC5P0mCJkPbVmj9hpRk/sgs89sc/6MTiXXXqqbI8Tr5X7nN/XFrKPsDW8loE
	 7MldDaJW5MZ4DHMwR+J2Qng4Y6FX6T5Wk3npyugYWHiGXSZYDLV2Lbh3/aSGnwZfuo
	 mO9hL96u9LhZ919fOeuX0j5TKeI+8cmIN0+huk6oTM3JQ37A0Csndj+OQ8OhDiIVKD
	 0iOoZn85zIQuw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id ADC953809A80;
	Wed,  6 Nov 2024 02:20:40 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] selftests: netfilter: run conntrack_dump_flush in
 netns
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <173085963950.771890.5162812398917192565.git-patchwork-notify@kernel.org>
Date: Wed, 06 Nov 2024 02:20:39 +0000
References: <20241104142529.2352-1-fw@strlen.de>
In-Reply-To: <20241104142529.2352-1-fw@strlen.de>
To: Florian Westphal <fw@strlen.de>
Cc: netdev@vger.kernel.org, netfilter-devel@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Mon,  4 Nov 2024 15:25:24 +0100 you wrote:
> This test will fail if the initial namespace has conntrack
> active due to unexpected number of flows returned on dump:
> 
>   conntrack_dump_flush.c:451:test_flush_by_zone:Expected ret (7) == 2 (2)
>   test_flush_by_zone: Test failed
>   FAIL  conntrack_dump_flush.test_flush_by_zone
>   not ok 2 conntrack_dump_flush.test_flush_by_zone
> 
> [...]

Here is the summary with links:
  - [net-next] selftests: netfilter: run conntrack_dump_flush in netns
    https://git.kernel.org/netdev/net-next/c/fc49b804967e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


