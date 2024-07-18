Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7F5E2E419;
	Thu, 18 Jul 2024 09:10:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721293832; cv=none; b=P62T0Rgnjzo14PJ4tgQcqYXvMcDw/6rONAA2sODhmrXqGMiBvOoZg7SK1B+OA0ZjOl2AXZu+jNDt0WMAXiKt3Bjq0g3DTvPQcNsXB4R0OCXIIgZFhqSq/Ru7ut4Rf1PMQj3n+kMh+5q4hCGHNW280m11Q24kWBPZeV9y32mK0vs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721293832; c=relaxed/simple;
	bh=RTr7rPrLIL6CGX77kwpKGFS9yCbpc7dlzIaN4v88C4Y=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=ZrzgCy5K9BwhqCdnmy2/0x6SN0Z6RBQZzUpi1Ib6Tqrz41DLNnyYfkdz3JgXImYjnH5VSSDGqbyML2Fnwkihcm4MxfDl3pC5I1+22LwuBF/ndiDJ61VPqrfb5BcJrAE3NNumtFNc0tf0vL6DSzKc2BvvEKVeXIYwnkab6G/llO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KBFNv1Kb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KBFNv1Kb"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3808BC4AF0C;
	Thu, 18 Jul 2024 09:10:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1721293832;
	bh=RTr7rPrLIL6CGX77kwpKGFS9yCbpc7dlzIaN4v88C4Y=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=KBFNv1KbiGDKU1VTjWrYtbyTynPxHtfzBnR3dQgaTggsSSj3xQ2OmQ4sS2C4EZyeN
	 mNeKSj+iDHYsA0VGZJ31hHBgGr8tgeLJoyYjfs2ZACURd7eJf4FRSiyulPq2h4XGjX
	 YoyelPE38tZ98qAEKrXEkyr6oVnuyKpWrARpbfaHmohTXu1vBlFfQX0AnbUaBhhoPj
	 /znditAkwzqqJA62PVTr9+SzZI10hvmCDEzoUQCTjDNTIrv/YrX7U4gUwst4HmyJhc
	 nP5i16gG4baXfXbtFFDPkO0q1ulHWsmgJReFIt3EahQLxJAfQPXJBemVy+C51VLhT5
	 xGpBN+z5wroLg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 1DC86C4332D;
	Thu, 18 Jul 2024 09:10:32 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: flow_dissector: use DEBUG_NET_WARN_ON_ONCE
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <172129383211.13763.771580327257467031.git-patchwork-notify@kernel.org>
Date: Thu, 18 Jul 2024 09:10:32 +0000
References: <20240715141442.43775-1-pablo@netfilter.org>
In-Reply-To: <20240715141442.43775-1-pablo@netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
 davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com, edumazet@google.com,
 fw@strlen.de, sdf@google.com, daniel@iogearbox.net

Hello:

This patch was applied to netdev/net.git (main)
by Paolo Abeni <pabeni@redhat.com>:

On Mon, 15 Jul 2024 16:14:42 +0200 you wrote:
> The following splat is easy to reproduce upstream as well as in -stable
> kernels. Florian Westphal provided the following commit:
> 
>   d1dab4f71d37 ("net: add and use __skb_get_hash_symmetric_net")
> 
> but this complementary fix has been also suggested by Willem de Bruijn
> and it can be easily backported to -stable kernel which consists in
> using DEBUG_NET_WARN_ON_ONCE instead to silence the following splat
> given __skb_get_hash() is used by the nftables tracing infrastructure to
> to identify packets in traces.
> 
> [...]

Here is the summary with links:
  - [net] net: flow_dissector: use DEBUG_NET_WARN_ON_ONCE
    https://git.kernel.org/netdev/net/c/120f1c857a73

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


