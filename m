Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71DFD38B7CD;
	Fri, 17 Jul 2026 09:30:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784280649; cv=none; b=MrQ4IjOgcMqlT4rMMoxRA9lVxAavyMwfu2iAll7721kNT/Z5gZfEqqXM6aa2+2I8W5vsccuKjDfwd9T3GoQSwW1IliA/y+pzINNUpjVUIhOqYDn1tGKjii+rIS/C+rdfTEXPqf6QLluguVfakF5+PXEWD6i/xGnONGYwrIiQBGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784280649; c=relaxed/simple;
	bh=LTfis0P9Tjh3Sq0uHdHrE/HDHAeBCvj+ck95VYlkdr8=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=kZ97fVbQkd/8/qJR0yB7rnRHzV5jz0DClq8bh69wnSO0O90QIG0g6Q2V0ecnXTJD8ZA8A2wEW4lAj4/jBc7O34UWlbYK35b2X3l58Qu45+beN9PJ1mg7hkpuP7mXbhgTM7CTh2t2xTKFKWAEsOjYOQDYAdj9eYFJ4GCZWk94LEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IoJWwF/T; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IoJWwF/T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F0201F000E9;
	Fri, 17 Jul 2026 09:30:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784280648;
	bh=rrjAt+mqJyXht3YkeIUSKlfLdN7tV57fGnjBQweeI2s=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=IoJWwF/TakHgCVMJ4wgKIBzAwZTZqYqH4PmQpVhGqH/gy3tfNvwu09El53Iqh3Yix
	 0CdBmqu9mKZrwEDBiJBEBcUarqb3De1c/k1gbG+reh2JSYSCcO316PGOnkZDGKzdzf
	 59mHEefXaALRaOBTma8DJuEFcXldeKBmHEAxeexncGv2MSoM+sFaRmSRyHv0DvkxBf
	 S8kVoLD3jwpQkcIC6iq4iFG47x/pXk9+TQqQSyo32rZUAmLw19F0ZC2hOkSbdf+hoA
	 gew8siECaEEZyK84wLKSS6+DV7br22aKzOfhprqbHtA+OrchLEifyGE5qs3vpEBln+
	 hIwMCn9zBMfBQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id D0AFD380CECB;
	Fri, 17 Jul 2026 09:30:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] netfilter: bridge: fix stale prevhdr pointer in
 br_ip6_fragment()
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <178428062039.1629459.13884661779658257379.git-patchwork-notify@kernel.org>
Date: Fri, 17 Jul 2026 09:30:20 +0000
References: <20260708181150.3944015-1-xmei5@asu.edu>
In-Reply-To: <20260708181150.3944015-1-xmei5@asu.edu>
To: Xiang Mei <xmei5@asu.edu>
Cc: fw@strlen.de, pablo@netfilter.org, phil@nwl.cc, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, horms@kernel.org,
 netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 AutonomousCodeSecurity@microsoft.com, tgopinath@linux.microsoft.com,
 kys@microsoft.com, stable@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Florian Westphal <fw@strlen.de>:

On Wed,  8 Jul 2026 18:11:50 +0000 you wrote:
> br_ip6_fragment() gets prevhdr, a pointer into the skb head, from
> ip6_find_1stfragopt(), then calls skb_checksum_help().  For a cloned skb
> skb_checksum_help() reallocates the head via pskb_expand_head(), leaving
> prevhdr dangling.  It is later dereferenced in ip6_frag_next(), causing a
> use-after-free write.
> 
> Save prevhdr's offset before skb_checksum_help() and recompute it after,
> like commit ef0efcd3bd3f ("ipv6: Fix dangling pointer when ipv6
> fragment").
> 
> [...]

Here is the summary with links:
  - [net,v2] netfilter: bridge: fix stale prevhdr pointer in br_ip6_fragment()
    https://git.kernel.org/netdev/net/c/86f3ce81dd2b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


