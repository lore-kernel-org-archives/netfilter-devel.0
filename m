Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06B06355030;
	Thu,  5 Feb 2026 16:50:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770310209; cv=none; b=UKNkHjI18Ar0Dc9R6rP0oLp/VZAECcQAtuHhjNeL5DcRcW4kOpH1f3OmRGOFSVIqat+arKcOcHTedM3AEiQw7ZV0F15YaQS443tVxKLjjRA8HvEIZ4p+tzrNIweqP+Ltw/CtVT80lJHGM/jly4dC52fMJDdJKg7/+wflBsfzATQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770310209; c=relaxed/simple;
	bh=+lqJkPRlZVrNbFLDywMJUxiG2RrzMjYqH0TlN3zmDHU=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=YtKh1iU4sLJxbuqB1WXcXtylYbP4ewNMVqRUVb+yIzBidXCO8Fhum+ypMZ3RASs8w4hjHdp6atVu7UgpwGm4HOiRcCHK3Eg26ddEsPxFgiVRA8mhmQGgyFeG3P1Qh/8QuuqN63clBAU/gdniRMJLJ4TiuUomcTnodLa2mu9uo28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YoAA+4iI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YoAA+4iI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82B8EC4CEF7;
	Thu,  5 Feb 2026 16:50:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770310208;
	bh=+lqJkPRlZVrNbFLDywMJUxiG2RrzMjYqH0TlN3zmDHU=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=YoAA+4iIeEDMstoKQVsLQwwdo3c5ef9EAxj1i6TL2tLEWSlwsbvMhhhfz4VYkZT4B
	 dSS+e1EeXMOsD19zQig67MQAbvKPVluk1Ab+quU6lZJ2NlZpUI42X3tFL2JJOWddYs
	 rPbyo3UClPJbiY69Cg7zFiZU0PwX9MtI3QoITK9or9p8nTVvKzsUN97Opz0Oo7E49j
	 aoX8OvCadFKLA9E2g6pKVJFVleSPm15Kvg4fdzEw3ZTjiRjFkbKm58xqEXPR7WG+iB
	 /Y1DZoZJj2wEsKCP3HEMcSFHVvh4figxpdouYxd+dHiDULbjPK/3u2TvVwdLyv5qaA
	 qoRBdOhmUBjTQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 853253808200;
	Thu,  5 Feb 2026 16:50:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/1] netfilter: nf_tables: fix inverted genmask check
 in
 nft_map_catchall_activate()
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <177031020633.485120.17507212737106778136.git-patchwork-notify@kernel.org>
Date: Thu, 05 Feb 2026 16:50:06 +0000
References: <20260205074450.3187-2-fw@strlen.de>
In-Reply-To: <20260205074450.3187-2-fw@strlen.de>
To: Florian Westphal <fw@strlen.de>
Cc: netdev@vger.kernel.org, pabeni@redhat.com, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, netfilter-devel@vger.kernel.org,
 pablo@netfilter.org

Hello:

This patch was applied to netdev/net.git (main)
by Florian Westphal <fw@strlen.de>:

On Thu,  5 Feb 2026 08:44:50 +0100 you wrote:
> From: Andrew Fasano <andrew.fasano@nist.gov>
> 
> nft_map_catchall_activate() has an inverted element activity check
> compared to its non-catchall counterpart nft_mapelem_activate() and
> compared to what is logically required.
> 
> nft_map_catchall_activate() is called from the abort path to re-activate
> catchall map elements that were deactivated during a failed transaction.
> It should skip elements that are already active (they don't need
> re-activation) and process elements that are inactive (they need to be
> restored). Instead, the current code does the opposite: it skips inactive
> elements and processes active ones.
> 
> [...]

Here is the summary with links:
  - [net,1/1] netfilter: nf_tables: fix inverted genmask check in nft_map_catchall_activate()
    https://git.kernel.org/netdev/net/c/f41c5d151078

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


