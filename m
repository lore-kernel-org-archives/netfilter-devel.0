Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAD1B1D0498;
	Thu, 22 Aug 2024 20:10:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724357441; cv=none; b=mTYRAEBY5jRfY7yV4XOXwFjoBTB7bD1OTsi97oth0XspBinrtUtKd29Fp3m2kLPTeWTfGp6M45Bt4L9RCQxSYIg5HFMnyLhKsYLkMe9DzmcSllSS/omArSZu8kQCmPGIkcJYTJ7XkE9RVtFpzi/a1YnD5CJWEQk9tlRz4jKsXlE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724357441; c=relaxed/simple;
	bh=VfzQf5sIhyCxwrOTKypIn9Tzg+S4uUV3V4N1ACjeAb0=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=vDkUmFT8uL1uM7XyCj83v2ffgBlyS6DE+0NFQOYw8xRgRB0ZasP0lNS5cmtTaCJfNrCzR+BMzxU5fxL5jVxIVp+XTfVyR5z64HJCPZt2HP8GzdBgRqQT41SG7qmPB0+9unHmGg3pAugqP7yONRvgUzCHNLyri0N/hPVzgvgImvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SPofPW9T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SPofPW9T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51480C4AF12;
	Thu, 22 Aug 2024 20:10:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724357441;
	bh=VfzQf5sIhyCxwrOTKypIn9Tzg+S4uUV3V4N1ACjeAb0=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=SPofPW9TJ8q9ZrXSoZrxw7OKlKL8inwRxrjAegelNHOvEZqJysXX5Kq0iDniwpvKV
	 dfKiF38fkexNG4r0UYiRCdi4h2SfzpN2xe89Xxea4kWiNPi9GyjG8FMHXkKGlQX7h6
	 Y0bq4RIx10zHwrKmznhPUceZon9X+w5xG34w0vSEyMuwsrfNAEJMtQ7Pp4B0ybsMCa
	 0lt555oqQhotswDo7zKLuaDPeCKZNeYJi/xcFUDyjcdLAgberb30EgWF75o4XCRQsF
	 ppOzzT2OUsSHWo6dukj+BB6lDkNjMZsx1q8QpHH8Uw+qd8GFO53mocIVnHLPtvIyNb
	 XwqdqjV5NBrjg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 340BE3809A81;
	Thu, 22 Aug 2024 20:10:42 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/3] netfilter: nft_counter: Disable BH in
 nft_counter_offload_stats().
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <172435744075.2469005.11253775629517796126.git-patchwork-notify@kernel.org>
Date: Thu, 22 Aug 2024 20:10:40 +0000
References: <20240822101842.4234-2-pablo@netfilter.org>
In-Reply-To: <20240822101842.4234-2-pablo@netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 edumazet@google.com, fw@strlen.de

Hello:

This series was applied to netdev/net.git (main)
by Pablo Neira Ayuso <pablo@netfilter.org>:

On Thu, 22 Aug 2024 12:18:40 +0200 you wrote:
> From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> 
> The sequence counter nft_counter_seq is a per-CPU counter. There is no
> lock associated with it. nft_counter_do_eval() is using the same counter
> and disables BH which suggest that it can be invoked from a softirq.
> This in turn means that nft_counter_offload_stats(), which disables only
> preemption, can be interrupted by nft_counter_do_eval() leading to two
> writer for one seqcount_t.
> This can lead to loosing stats or reading statistics while they are
> updated.
> 
> [...]

Here is the summary with links:
  - [net,1/3] netfilter: nft_counter: Disable BH in nft_counter_offload_stats().
    https://git.kernel.org/netdev/net/c/1eacdd71b343
  - [net,2/3] netfilter: nft_counter: Synchronize nft_counter_reset() against reader.
    https://git.kernel.org/netdev/net/c/a0b39e2dc701
  - [net,3/3] netfilter: flowtable: validate vlan header
    https://git.kernel.org/netdev/net/c/6ea14ccb60c8

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


