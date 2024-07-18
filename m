Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 269731386B4;
	Thu, 18 Jul 2024 11:40:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721302836; cv=none; b=L7mM8wSGiF7lDRAHAQPYAVDCqd0yFVv92VfEDR6IKSUardFW/EvEkRAeZFRk6XT+7XoqVHGEru0a0XQGVBv48htKsf53kwNAJLdSKWY1a4ABEDM28aFQMlSWrdhfYzxLbSQ3KGcAb/guMzuE6Jak43SLXg+D4NK7seLz2WEhWyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721302836; c=relaxed/simple;
	bh=Fiq8mpT79ZcKdgSfyau1kQ/5oPMpIDXwJSEouLosKHk=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=FwoXypI02X+Wn5o9ck7w1ZaXobUmsunk+dSLghJHrHN6tjQeHKcl++05tsBF7+kXCR61YRvdkX0QQHz1Nyn72Q/VGN4FyIwtUg/pk4xiHIgOFADvqTlEb8XliNYEaQ/+7qO+MeublTMRMXr12HzPng3/1LcOns08thqGEnBqiPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pmoGx5h2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pmoGx5h2"
Received: by smtp.kernel.org (Postfix) with ESMTPS id A72CDC4AF0B;
	Thu, 18 Jul 2024 11:40:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1721302835;
	bh=Fiq8mpT79ZcKdgSfyau1kQ/5oPMpIDXwJSEouLosKHk=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=pmoGx5h2r1gVdJCnbgJOMvCQ8cjT+sa0gJ0qKDAu9oObhnMUXWdajlnfrlZo+6LL6
	 UYU2XrP6v7yxFK61nvnQqLQJSilWaHfWwO5HvjSAI5rW5cSz4rKdv6KPOt9hyqVu1G
	 xKONxjq7v0zUZJGetKzzLIG1gRnaF0eEDSuml6eon85RRfWASUds2+YmpOZERqcAOP
	 CXlnhdpxO7RcrpV9PSYRmkOlnkl+q+1yCsZ2OQZyCeCy3nAnX1ThiDHgkaL3WGjxfP
	 TGZMlLz3p9w6/6IJJeheNpH50/BSTxGrTzTKXliO6OMn0jXHEdAkTUBYzzxa4tA9KM
	 3+ZTLMWfFVymw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 913C4C4333D;
	Thu, 18 Jul 2024 11:40:35 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/4] netfilter: ctnetlink: use helper function to
 calculate expect ID
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <172130283558.6088.1082454972873953114.git-patchwork-notify@kernel.org>
Date: Thu, 18 Jul 2024 11:40:35 +0000
References: <20240717215214.225394-2-pablo@netfilter.org>
In-Reply-To: <20240717215214.225394-2-pablo@netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 edumazet@google.com, fw@strlen.de

Hello:

This series was applied to netdev/net.git (main)
by Pablo Neira Ayuso <pablo@netfilter.org>:

On Wed, 17 Jul 2024 23:52:11 +0200 you wrote:
> Delete expectation path is missing a call to the nf_expect_get_id()
> helper function to calculate the expectation ID, otherwise LSB of the
> expectation object address is leaked to userspace.
> 
> Fixes: 3c79107631db ("netfilter: ctnetlink: don't use conntrack/expect object addresses as id")
> Reported-by: zdi-disclosures@trendmicro.com
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> 
> [...]

Here is the summary with links:
  - [net,1/4] netfilter: ctnetlink: use helper function to calculate expect ID
    https://git.kernel.org/netdev/net/c/782161895eb4
  - [net,2/4] netfilter: nf_set_pipapo: fix initial map fill
    https://git.kernel.org/netdev/net/c/791a615b7ad2
  - [net,3/4] selftests: netfilter: add test case for recent mismatch bug
    https://git.kernel.org/netdev/net/c/0935ee6032df
  - [net,4/4] ipvs: properly dereference pe in ip_vs_add_service
    https://git.kernel.org/netdev/net/c/cbd070a4ae62

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


