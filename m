Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A4FA171A4;
	Tue, 23 Apr 2024 00:53:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713833593; cv=none; b=Urz/ODShqc0Q3te7wH3Lqf9/2LX9DE3MsXTDTWdAZfWsNHqZmgOfaIpm6bVEQcbhORW9muePx36GKt6uAiC/6FQ3RzzLLB7TIOOh2NoM+/iLElpG6bm55iPZEjn6COrmzXSsSbxI55lgYfTGsaNtySmTZRy/gBKqeklA1v/iHuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713833593; c=relaxed/simple;
	bh=mGGe9ThqcUB7ZTQjCZWi5VJqzjKOF1STkWW4HS5m8oc=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=FhyJheAUKE21GbvUO60eEu28mkiUVBJxmTHPj/3UwhWeunxCgU9m+/PbzmNFFedfR0w3/cajKsNlqRfyTKFobrgrYLq64OjOS4Zab++ByWIspsEbAeAu4g0M01Hh8jhMzKzSAakxtU71oE1DDd1QMFr+Qyol0/knnNLCkFp5mjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=l3tctvct; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="l3tctvct"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 418F6C113CC;
	Tue, 23 Apr 2024 00:53:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713833593;
	bh=mGGe9ThqcUB7ZTQjCZWi5VJqzjKOF1STkWW4HS5m8oc=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=l3tctvctopY7wJchX8TQdd8F3hs8hDan9QEXdkif+21NaOhvXKH4S/H3HO2THokWZ
	 1EFPR6Wfeaq0/ORdxsGxI7kN3RL0yJqD/B/EEow6+SalvFEGX1Vt/GkazGVPIeI+Y3
	 ZtmCbacvsV2AhSLzxKYKIKJsuieZQyoFZ0nk9vsq5M4QMPdxonsQYBKwTGTVJdVFf0
	 +boKZKtv4Qbruydy+j9Em1CAN7d6P2nBUnVH9Z5bIdpm8vQmpYlQ2KuHrjARkow/Ed
	 OovOxFp6S1ZJpA8mFrnADdOgEL6O1XRxCbaxWxPXgENysHlFkKN5YZJT2lgm5zHw2V
	 JOmVpBFHYX0Yw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 36DC2C433A2;
	Tue, 23 Apr 2024 00:53:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v4 0/4] netlink: Add nftables spec w/ multi messages
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <171383359322.888.1077638959430684768.git-patchwork-notify@kernel.org>
Date: Tue, 23 Apr 2024 00:53:13 +0000
References: <20240418104737.77914-1-donald.hunter@gmail.com>
In-Reply-To: <20240418104737.77914-1-donald.hunter@gmail.com>
To: Donald Hunter <donald.hunter@gmail.com>
Cc: netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
 edumazet@google.com, pabeni@redhat.com, jiri@resnulli.us,
 jacob.e.keller@intel.com, pablo@netfilter.org, kadlec@netfilter.org,
 netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
 donald.hunter@redhat.com

Hello:

This series was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 18 Apr 2024 11:47:33 +0100 you wrote:
> This series adds a ynl spec for nftables and extends ynl with a --multi
> command line option that makes it possible to send transactional batches
> for nftables.
> 
> This series includes a patch for nfnetlink which adds ACK processing for
> batch begin/end messages. If you'd prefer that to be sent separately to
> nf-next then I can do so, but I included it here so that it gets seen in
> context.
> 
> [...]

Here is the summary with links:
  - [net-next,v4,1/4] doc/netlink/specs: Add draft nftables spec
    https://git.kernel.org/netdev/net-next/c/1ee731687137
  - [net-next,v4,2/4] tools/net/ynl: Fix extack decoding for directional ops
    https://git.kernel.org/netdev/net-next/c/0a966d606c68
  - [net-next,v4,3/4] tools/net/ynl: Add multi message support to ynl
    https://git.kernel.org/netdev/net-next/c/ba8be00f68f5
  - [net-next,v4,4/4] netfilter: nfnetlink: Handle ACK flags for batch messages
    https://git.kernel.org/netdev/net-next/c/bf2ac490d28c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


