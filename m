Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD04C1D559;
	Thu,  4 Apr 2024 16:50:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712249431; cv=none; b=HOt90p6SolA22ZRiV4JAn+9MfNsWnMTM0ZVBdPh0kM+gFA9am90GctdlgqhLFcMdpzIOGcWdxPyLnCtV7LoTAhReQas9u4JsP/Mhi3/ofw2+5hlqVEbN8ClgPsEO0tKjSDCNrSkvjFQwnhKo8PKYDwegPv2sLsxUycn+4djxSJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712249431; c=relaxed/simple;
	bh=FQiQZX+LQsOfl2q++ChwsNsrrFJ2zGfRR0kUSpqByrA=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=Kct6jErgq5Ax/j5jWDbn1LecPFAVLKUAopTbBM9DE2UwLI7TCsEEaRCAU4lVGg7o5A2/BeX+iPbagr+iSlqmQJnHJDKj6HoE6SCPotIgJOq/u4cCKgqzXZAdkj2g6tyAt+cZTKS4F5m3NjtrIYs0UbE86jjE6aiM8asHeGwzu1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MLukqSpn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MLukqSpn"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4A25BC433A6;
	Thu,  4 Apr 2024 16:50:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712249431;
	bh=FQiQZX+LQsOfl2q++ChwsNsrrFJ2zGfRR0kUSpqByrA=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=MLukqSpnSJlyGzAJStlCDfg7UD3Z7xFnhStyEFPa8/2hWSWTRWCukm06k2ZicQq/1
	 Wrdqw3T5HcRDmcI9OCSyKbsiNtQgqIDGTXJ/fp1rGrGgnDVjvONrPL9CFAGn/FtZRC
	 wXI/dkJIIcuJQPGdP4E+e4b5z4O1oNk1XWbxvDuhh5ov7rHtnDoCOzRlDW9eJEpxrO
	 FV6Pl4P83B0FqKqVCVyCkepKTDshChGbWKfgCMg97iyvN10abEMaeT2uiOl8WyjpZb
	 pjNVMP/VeyCaqBAhPYFVq5A3m6XAqMlyUiyKJkBLhDAJXKRp2FMNv1sbPfLh82MlBh
	 2+7GHiRjk9AGQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 3CD4DD9A155;
	Thu,  4 Apr 2024 16:50:31 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/6] netfilter: nf_tables: release batch on table
 validation from abort path
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <171224943124.12619.15153866465943308687.git-patchwork-notify@kernel.org>
Date: Thu, 04 Apr 2024 16:50:31 +0000
References: <20240404104334.1627-2-pablo@netfilter.org>
In-Reply-To: <20240404104334.1627-2-pablo@netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 edumazet@google.com

Hello:

This series was applied to netdev/net.git (main)
by Pablo Neira Ayuso <pablo@netfilter.org>:

On Thu,  4 Apr 2024 12:43:29 +0200 you wrote:
> Unlike early commit path stage which triggers a call to abort, an
> explicit release of the batch is required on abort, otherwise mutex is
> released and commit_list remains in place.
> 
> Add WARN_ON_ONCE to ensure commit_list is empty from the abort path
> before releasing the mutex.
> 
> [...]

Here is the summary with links:
  - [net,1/6] netfilter: nf_tables: release batch on table validation from abort path
    https://git.kernel.org/netdev/net/c/a45e6889575c
  - [net,2/6] netfilter: nf_tables: release mutex after nft_gc_seq_end from abort path
    https://git.kernel.org/netdev/net/c/0d459e2ffb54
  - [net,3/6] netfilter: nf_tables: flush pending destroy work before exit_net release
    https://git.kernel.org/netdev/net/c/24cea9677025
  - [net,4/6] netfilter: nf_tables: reject new basechain after table flag update
    https://git.kernel.org/netdev/net/c/994209ddf4f4
  - [net,5/6] netfilter: nf_tables: Fix potential data-race in __nft_flowtable_type_get()
    https://git.kernel.org/netdev/net/c/24225011d81b
  - [net,6/6] netfilter: nf_tables: discard table flag update with pending basechain deletion
    https://git.kernel.org/netdev/net/c/1bc83a019bbe

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


