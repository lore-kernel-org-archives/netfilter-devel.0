Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1DFC14B098;
	Thu, 25 Apr 2024 15:50:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714060228; cv=none; b=bduw4uYXzmwx/y3pTFvv9VbXRV0tl5EfblndGo66DC+sivxCJWIp2H1zM3/skd1x9QKgOt/Cp4mLTAMHNyAln0xJDxuwj5YNYLpn+w2CmSzhXJjP0ELSXpxG511wsEVvqTyw63pr8UitOZt5+E7SyXeEVlRMIEUETeuea7MIBV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714060228; c=relaxed/simple;
	bh=8++MObKo1hHc9ffKYaUgO+WC2meH48Ztf80tXfFARHc=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=cVEV1H49FFsxZlxQk2mQvmo8gT4V7K+yAjQHTeaQpWAz3TSRrcNu1zG2pIAGjzMlPeCORbagBAY6+fKRSe2Q61QYLhREKn+DIgoaJNa5ACwVmnYbNGz8+tC81L6cjr5L8+p8PBI3Izwb081kmRnCikChr/K38YYGaaBwssFNYNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lcJrwTKd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lcJrwTKd"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 55AF2C2BD11;
	Thu, 25 Apr 2024 15:50:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1714060228;
	bh=8++MObKo1hHc9ffKYaUgO+WC2meH48Ztf80tXfFARHc=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=lcJrwTKdBf/wFWlWZ26ZI7KhYGZDkLoKFYnAdUidvXO0k+86DOpxCiMovEKUTqsd9
	 g4FANb5z28cJfh4JxnKRPv7kQgNxzN2GROpgSXKKSTLm2Sprsq7jGbpWz6Ki1U/Jx2
	 Qnb/hR4Eney4sXMEtoXx1vV3Dbm9jYS4Ch7eTYglRWBYKQmLBIVPjFGhi13ck6ZMFr
	 j6NkGlVJ/oRcrPlVe3NZTKUhugXCu8VhrGzcXbqhGs7g2roq/cvmlfJO1hYhKDvlXM
	 F7jQ+CLzs9WqqDLBlr19InCXcKDnGRN+td7EfA/B9+2Hcr4Wd07wxdtmmekRHbqzfr
	 8DO8DeOvnTNYQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 45775CF21C2;
	Thu, 25 Apr 2024 15:50:28 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/2] ipvs: Fix checksumming on GSO of SCTP packets
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <171406022828.18400.2283631341467593246.git-patchwork-notify@kernel.org>
Date: Thu, 25 Apr 2024 15:50:28 +0000
References: <20240425090149.1359547-2-pablo@netfilter.org>
In-Reply-To: <20240425090149.1359547-2-pablo@netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 edumazet@google.com, fw@strlen.de

Hello:

This series was applied to netdev/net.git (main)
by Pablo Neira Ayuso <pablo@netfilter.org>:

On Thu, 25 Apr 2024 11:01:48 +0200 you wrote:
> From: Ismael Luceno <iluceno@suse.de>
> 
> It was observed in the wild that pairs of consecutive packets would leave
> the IPVS with the same wrong checksum, and the issue only went away when
> disabling GSO.
> 
> IPVS needs to avoid computing the SCTP checksum when using GSO.
> 
> [...]

Here is the summary with links:
  - [net,1/2] ipvs: Fix checksumming on GSO of SCTP packets
    https://git.kernel.org/netdev/net/c/e10d3ba4d434
  - [net,2/2] netfilter: nf_tables: honor table dormant flag from netdev release event path
    https://git.kernel.org/netdev/net/c/8e30abc9ace4

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


