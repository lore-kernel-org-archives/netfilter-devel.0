Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8044F305691;
	Fri, 15 May 2026 22:59:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778885992; cv=none; b=meNfsquuJA4NdjpEiZL3lK6+i0iGliWBgSvloDha0ergtzbCgD69x+8fLNa1wBD/U1z21bMSxB7kK8CJHuw8dJXkkSCwFd9IJADBDya9KKGj1397TBgf2VMGCnKJpB/JuNm28JTXZHQSo3tMVmH8UyRxhz3D7vU2sFYUPFbMD5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778885992; c=relaxed/simple;
	bh=3cBXiBfCIc1U8M0AW3NaHM5GwnUNv3EqlVzsAWuhJng=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=HeDTH0+OcZ/rBzm0AYn17Ie0yupRs8KbQdV0LG8PpXCZvWJq9mquClhO2n3YtiDCU1OMKr+qwuZZaNXGeTRDtLD6ceIzIdqpOemAqQYq5iQJoICO73FZcJSHfwZ/HbbZAms5NBWpoRMDNXij8Vb5jmjVL/AS7JqzqWxEzsmgmTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SyDUwcRL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SyDUwcRL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6057DC2BCB0;
	Fri, 15 May 2026 22:59:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778885992;
	bh=3cBXiBfCIc1U8M0AW3NaHM5GwnUNv3EqlVzsAWuhJng=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=SyDUwcRLhLlxtrcCAv/hJdexMm2/FSUjB0anb7ix5Z9a8h3uTaRczUe8oZ3fsM3H7
	 uzKGcEBGyS0xaKpJsPZ5EKHQRBUtF6rgTWN9aArh/ZQgbjfuFvQQFBxxQs0NyBpA7o
	 dOVyjq1/rmRjFFXigMxRmlSs+I9z1W4EUUj7OuitRVB3s0cQY+V+1BiL/vIkAcVbBP
	 hw5zMw4UjToMn3BFzUmoNArMT64xhQZOt/DSUSfm0+ievTjJxoSsNNsJk2W3KZO+/L
	 WzRHzuGe6dZSW7+QlWDl5fSbOzUVWj2Ce4Ix5mj1TkqwelNezDd+LAlL0XES7uhOGp
	 t7zVO1/wL3xpQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id D09493930A1F;
	Fri, 15 May 2026 23:00:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/2] ipv4: harden against ihl < 5 IP_HDRINCL packets
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <177888600564.188709.2225332951271422634.git-patchwork-notify@kernel.org>
Date: Fri, 15 May 2026 23:00:05 +0000
References: <cover.1778614451.git.michael.bommarito@gmail.com>
In-Reply-To: <cover.1778614451.git.michael.bommarito@gmail.com>
To: Michael Bommarito <michael.bommarito@gmail.com>
Cc: steffen.klassert@secunet.com, herbert@gondor.apana.org.au,
 edumazet@google.com, netdev@vger.kernel.org, davem@davemloft.net,
 kuba@kernel.org, pabeni@redhat.com, kuniyu@google.com, maze@google.com,
 kees@kernel.org, jlayton@kernel.org, gustavoars@kernel.org,
 pablo@netfilter.org, fw@strlen.de, netfilter-devel@vger.kernel.org,
 coreteam@netfilter.org, linux-kernel@vger.kernel.org

Hello:

This series was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 12 May 2026 16:51:13 -0400 you wrote:
> This series fixes a size_t underflow in net/ipv4/ah4.c:ah_output()
> reachable when a raw IP_HDRINCL socket sends a packet with ihl < 5
> through an xfrm AH policy.  Originally triaged on security@kernel.org;
> moving to netdev at Herbert's suggestion so nftables / netfilter
> maintainers can weigh in on a related question (see "Open question"
> below).  Herbert also asked for the malformed packet to be rejected
> upstream of AH rather than guarded at the AH consumer; that is
> patch 1/2.  v1's AH-side guard is kept here as 2/2 defense-in-depth.
> 
> [...]

Here is the summary with links:
  - [net,1/2] ipv4: raw: reject IP_HDRINCL packets with ihl < 5
    https://git.kernel.org/netdev/net/c/915fab69823a
  - [net,2/2] ipv4: ah: harden ah_output options-copy guard against ihl < 5
    (no matching commit)

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


