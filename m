Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15A3D212B26;
	Thu, 12 Dec 2024 12:20:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734006015; cv=none; b=FKvdSMQYVGQEhOUUOcAaMfV2YhNhZVD0A+Qh9QgdheiUVTIQyOGh4dgSUlPq+/XphugUb2tco6U3FRRsUM6qm0qYaQ/9KpkuTITB3HQeYZCDFKoHk33wiQDOQ9H/+W5u/5PiZq/wTGt5o5w1w1HK2MeFWqcMX4X5WoFbVXLJAr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734006015; c=relaxed/simple;
	bh=9Ke5o8imFzwRQVn18D0rbR+9xDpwZ9micbPUq5JTGW4=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=d8oV+112Bg5iHyL4qYOytZvuf9dt71A5vL6ER70Krn02MqKzemG9NyOV0ma7w/uRAeJAcTkM8yM9xs9zXJzMtU5Z2LDhZT+QYor+a8P3lvEssOlej9hvxI3OMqaFWmeYzMlRV6msC26U31fr9SxGWAy/zUEaRvE1E/myMSAIHjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dSSdyS4E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dSSdyS4E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FED8C4CECE;
	Thu, 12 Dec 2024 12:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734006014;
	bh=9Ke5o8imFzwRQVn18D0rbR+9xDpwZ9micbPUq5JTGW4=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=dSSdyS4EtW1soE1fw1jeVqwAdchBsefSQIrzqZPDrx0Kfv15YsqMh4fgaDd3lNodJ
	 NkAIVqOkS053f0wbBOKRJ9csS5oQm5LrWspYYjxrCuDAEQ+b2cfZXDm8QehkMXRID9
	 HHQm1xn9ZsrwnIWMU8in75Cxpc0h8Uq0K2/kh7TR/uhWchDFgITei/RjlJWJI24Ogl
	 xxMt0LVGzUYmI3DuvGbaxOz5W5NaqRVeuekp+lzMVZauGClhqK//8/GLeW9JPXIYR0
	 ZUk+9K6kTlQEIxdEyLpR3ngZfpkUaZzRHG0X7GyJ0PQsiRsJidfpYjsuCbPGiJBxNy
	 pVpx3akrFwF8A==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id EBD2D380A959;
	Thu, 12 Dec 2024 12:20:31 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/3] selftests: netfilter: Stabilize rpath.sh
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <173400603083.2282402.15299642922508442484.git-patchwork-notify@kernel.org>
Date: Thu, 12 Dec 2024 12:20:30 +0000
References: <20241211230130.176937-2-pablo@netfilter.org>
In-Reply-To: <20241211230130.176937-2-pablo@netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 edumazet@google.com, fw@strlen.de, phil@netfilter.org

Hello:

This series was applied to netdev/net.git (main)
by Pablo Neira Ayuso <pablo@netfilter.org>:

On Thu, 12 Dec 2024 00:01:28 +0100 you wrote:
> From: Phil Sutter <phil@nwl.cc>
> 
> On some systems, neighbor discoveries from ns1 for fec0:42::1 (i.e., the
> martian trap address) would happen at the wrong time and cause
> false-negative test result.
> 
> Problem analysis also discovered that IPv6 martian ping test was broken
> in that sent neighbor discoveries, not echo requests were inadvertently
> trapped
> 
> [...]

Here is the summary with links:
  - [net,1/3] selftests: netfilter: Stabilize rpath.sh
    https://git.kernel.org/netdev/net/c/d92906fd1b94
  - [net,2/3] netfilter: IDLETIMER: Fix for possible ABBA deadlock
    https://git.kernel.org/netdev/net/c/f36b01994d68
  - [net,3/3] netfilter: nf_tables: do not defer rule destruction via call_rcu
    https://git.kernel.org/netdev/net/c/b04df3da1b5c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


