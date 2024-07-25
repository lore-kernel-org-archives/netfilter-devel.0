Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 920D81103;
	Thu, 25 Jul 2024 09:30:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721899832; cv=none; b=ZUwYMsCGDrWut43wEnr0/APCayQ99SpWTLse+DvhYk9cg4mLcmrKdwrt7S1M9rHUXZRBK0MlMDtKtU5DaxHvLVUbaZUkgCc24VwjFdpvanHAwPNbnfH6hgvxYaSSynUEkJffBP2fWx0kU0oPasMXdIKF90APDoUxldov4wRICDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721899832; c=relaxed/simple;
	bh=6TSVDKLMqh24E5QF/HTHBHDa7+w0DqajX9ijQHETEpk=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=qLsAvog0Dz4Y4C/Y/7Uf5iq24+rubT9o5IkZ4lsIkeUS0wQ+pm+umc1d2LAU/AdTHQVkwhiahObUCTBFhKUGH0huaX7qwE/DnwOmMKSNTSX6slzBhIrF64898IlmJ7yejRNQzCkxMY/36q1EnakAd/jSjixOfxjIz/ilhHcp0JM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sAYp0GGl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sAYp0GGl"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0ADE8C4AF0A;
	Thu, 25 Jul 2024 09:30:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1721899832;
	bh=6TSVDKLMqh24E5QF/HTHBHDa7+w0DqajX9ijQHETEpk=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=sAYp0GGlKdiIaLG53cwb/MFugDgy3d6lv0Gd3/qI9A2CYlPdzPXjOYyfTDzAOeEdE
	 x52beIXzjQOfKcUWscVF2H/fTsiUc5FF8QsksXGty3nftPFbFwktFnXJ58z7dMtTqQ
	 fuafKyWPq0iCtKJZ/+TpF22qXLdR2QTS2Wp41F2Gnud6o8OQ9TrYHYnxtHvTSsem9E
	 M3t3x+JBjlkrsRlsecEUiB1y63Ev5wm177CNO2Ounm1xuqHPKpfeDFC95gsOGyiD5Z
	 7fWF/wW5klCEp5FWKZ5/Fi1+GHl+sHFUsL0dV14tCtAdctW2b/ubGhdMOXVlGAOxX2
	 0lVzn92toKpiQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id EB7D6C43445;
	Thu, 25 Jul 2024 09:30:31 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/1] netfilter: nft_set_pipapo_avx2: disable
 softinterrupts
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <172189983195.31991.1859048379532037477.git-patchwork-notify@kernel.org>
Date: Thu, 25 Jul 2024 09:30:31 +0000
References: <20240724081305.3152-2-pablo@netfilter.org>
In-Reply-To: <20240724081305.3152-2-pablo@netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 edumazet@google.com, fw@strlen.de

Hello:

This patch was applied to netdev/net.git (main)
by Pablo Neira Ayuso <pablo@netfilter.org>:

On Wed, 24 Jul 2024 10:13:05 +0200 you wrote:
> From: Florian Westphal <fw@strlen.de>
> 
> We need to disable softinterrupts, else we get following problem:
> 
> 1. pipapo_avx2 called from process context; fpu usable
> 2. preempt_disable() called, pcpu scratchmap in use
> 3. softirq handles rx or tx, we re-enter pipapo_avx2
> 4. fpu busy, fallback to generic non-avx version
> 5. fallback reuses scratch map and index, which are in use
>    by the preempted process
> 
> [...]

Here is the summary with links:
  - [net,1/1] netfilter: nft_set_pipapo_avx2: disable softinterrupts
    https://git.kernel.org/netdev/net/c/a16909ae9982

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


