Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DEB8846F;
	Thu,  4 Jul 2024 13:40:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720100430; cv=none; b=kr7ZEQoo0l5h+MM7c5X0MYq1zr5KcF+MtLyoc73wFPtpe7W33OoTwM2aoGv8P657YMk0x3kWZv2dm5LNMUQVKtGY0x9Xoik7Yc+3CWRxhiiMIHyZDLl8vlGTGHU4ar1qnnDS5MUrY4ALETT8a+xvQXxcKmSLz5MACbXYO1sAj14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720100430; c=relaxed/simple;
	bh=5/r6i5wmdCxJw2ZxGWDwAE2rJyWQofV1YUOvRnZzFs8=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=WjlSquGyF1fL5q7a7lRQXsMDjTnQXwdWj5eAcOvGeYsGz/IoenZyYmE9G9v2GQHHiA/6PzoSwFdUcLz5L1aRDWnlxlwE+A2x5j81RIAVFf6h1kIKIHcn0oo7I7emk9ljS3V8uFa6KMN7783BmZhLBIF6QUEIZguKqKzuBwzO954=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uupMZK+I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uupMZK+I"
Received: by smtp.kernel.org (Postfix) with ESMTPS id C1F97C4AF07;
	Thu,  4 Jul 2024 13:40:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720100429;
	bh=5/r6i5wmdCxJw2ZxGWDwAE2rJyWQofV1YUOvRnZzFs8=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=uupMZK+ITDfQQuuGvrquMGn6I4AWGSmVCRfLkOODTx2nTpeymKlceXD9C+CCWzrUu
	 nHjfZnxEKrfFBfAbfAvQhl1+/b8+9XT8F4xgLV/fuh0sk3kWJVXqdPke8PicndNKob
	 O1cZXkms8+idCpX4TwS18QzPSNoxzMWywIrC9jUQoVe/dSZo88urOigUqpuWO/7v+s
	 u8lStAbM2IH778bREkZZe5vR7B6q0Ax6E1h00koPkNLM14GEhmAhHFik0rrP2Dgayu
	 F+CAKpRmpaeuWCW+KCY2dlRxI24gkF2muJkpyDBcyzrmalcXPs3XdLMeiqOYbjb6sS
	 U2HdK0bCiRe2A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id AFCE9C43446;
	Thu,  4 Jul 2024 13:40:29 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/1] netfilter: nf_tables: unconditionally flush pending
 work before notifier
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <172010042971.3030.15847151045152419383.git-patchwork-notify@kernel.org>
Date: Thu, 04 Jul 2024 13:40:29 +0000
References: <20240703223304.1455-2-pablo@netfilter.org>
In-Reply-To: <20240703223304.1455-2-pablo@netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 edumazet@google.com, fw@strlen.de

Hello:

This patch was applied to netdev/net.git (main)
by Pablo Neira Ayuso <pablo@netfilter.org>:

On Thu,  4 Jul 2024 00:33:04 +0200 you wrote:
> From: Florian Westphal <fw@strlen.de>
> 
> syzbot reports:
> 
> KASAN: slab-uaf in nft_ctx_update include/net/netfilter/nf_tables.h:1831
> KASAN: slab-uaf in nft_commit_release net/netfilter/nf_tables_api.c:9530
> KASAN: slab-uaf int nf_tables_trans_destroy_work+0x152b/0x1750 net/netfilter/nf_tables_api.c:9597
> Read of size 2 at addr ffff88802b0051c4 by task kworker/1:1/45
> [..]
> Workqueue: events nf_tables_trans_destroy_work
> Call Trace:
>  nft_ctx_update include/net/netfilter/nf_tables.h:1831 [inline]
>  nft_commit_release net/netfilter/nf_tables_api.c:9530 [inline]
>  nf_tables_trans_destroy_work+0x152b/0x1750 net/netfilter/nf_tables_api.c:9597
> 
> [...]

Here is the summary with links:
  - [net,1/1] netfilter: nf_tables: unconditionally flush pending work before notifier
    https://git.kernel.org/netdev/net/c/9f6958ba2e90

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


