Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA58E17E472;
	Fri,  7 Mar 2025 02:30:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741314604; cv=none; b=LJ9X4jbx4vDiJX4mEtgtm5xRgXCu9zXJUf3rE9V3sTDkLXwMaAMunA9S9CIXJ8dFEbYOf422BRZcN8+zjv2Cq/fPs1CjSjfLPBfsHK2i2JbGsKggaQBZNC+u1KgV2kZmCEY6MtbaDN83KoW4bnOLCwOUHgHCSYIEUO2xWjYfb10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741314604; c=relaxed/simple;
	bh=qOYNlxGvpwI9YokRQvVn4Dq14vflRZUeZT6YqYChAlU=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=qoRzuFktuMqFfdMKsQIbnTePvy27+cAYMKOTRDHsUq1WOK7qaKbxy+2i827Glpq3M94Z/c1ATyzR5mMatQ5v7ZExGj7RvlJC8HWxdl0wvpttpRHuPRMgfGWx1/mJbB0vj0hYTD4sV7i5k/3u+/gMpLqrx2GfTX7T4u9+mTuwzbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ltWNggIL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ltWNggIL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D4B3C4CEE0;
	Fri,  7 Mar 2025 02:30:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741314603;
	bh=qOYNlxGvpwI9YokRQvVn4Dq14vflRZUeZT6YqYChAlU=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=ltWNggILIneTHZxHcWxYbdSFa4XKntYI3tr5p9k3MY/bqdK65y6VlJBa2+2OPZA0e
	 ZydmZ9jf6AG26dDPkqqbcWu5GwIG7zBj/t/fZxiNeut6JRtqryY0D98XQJKoDaAvRW
	 XeuADTGyFyrkJJyK/EMvkwgwzMuKEG4AVwfbu9+cfD8rL1DurBpde+MeuowOgwfxi7
	 x3ziWqE022tRYwZbk9LuXk7g7MA/1Z8X60T6uUjw/sA438V1nBsM602uVlYGrDSC3m
	 NRhZNw1g9bzPZiu6Wcn6k3j0oiCzC3OrsEY/BjnNOU3K0obyC6I/f864d+3xU9zpdc
	 +rRaGnKrFzoVQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id EB6E2380CFF6;
	Fri,  7 Mar 2025 02:30:37 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/3] netfilter: nft_ct: Use __refcount_inc() for per-CPU
 nft_ct_pcpu_template.
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <174131463678.1860023.9118503742214228840.git-patchwork-notify@kernel.org>
Date: Fri, 07 Mar 2025 02:30:36 +0000
References: <20250306153446.46712-2-pablo@netfilter.org>
In-Reply-To: <20250306153446.46712-2-pablo@netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 edumazet@google.com, fw@strlen.de, horms@kernel.org

Hello:

This series was applied to netdev/net.git (main)
by Pablo Neira Ayuso <pablo@netfilter.org>:

On Thu,  6 Mar 2025 16:34:44 +0100 you wrote:
> From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> 
> nft_ct_pcpu_template is a per-CPU variable and relies on disabled BH for its
> locking. The refcounter is read and if its value is set to one then the
> refcounter is incremented and variable is used - otherwise it is already
> in use and left untouched.
> 
> [...]

Here is the summary with links:
  - [net,1/3] netfilter: nft_ct: Use __refcount_inc() for per-CPU nft_ct_pcpu_template.
    https://git.kernel.org/netdev/net/c/5cfe5612ca95
  - [net,2/3] netfilter: nf_conncount: garbage collection is not skipped when jiffies wrap around
    https://git.kernel.org/netdev/net/c/df08c94baafb
  - [net,3/3] netfilter: nf_tables: make destruction work queue pernet
    https://git.kernel.org/netdev/net/c/fb8286562ecf

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


