Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E43571A238D;
	Tue, 25 Mar 2025 15:39:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742917199; cv=none; b=AAnlVkW/H2meFg4F1G9UaUwGVa2nFqESZLhxVwK0/RKwQz0YeGveZxbwx35WU8eq2bQazXpooZ87cYE9o+F6gKXQTtDMVtQosg/fUMiENa7cwDHhKQZCl3aTiooQlfEuX0L02RCPAOWDi8Heva8UmBpiBAOi+3712cIgzecO2qE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742917199; c=relaxed/simple;
	bh=am9FunDcKx0MSc3x6dOTCpKV2sXz1d5Pqt7ld9PVGEU=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=NuaRRN5dBG8zkUiqrpkMf6U1oYRdy9DpWfojlN+iNGPIMpt9ayBvwYyFs3+NIauNg1hHA2IZIBV4GcsLKLwqKIftyVHQ1RZpsFbx/1bgTB6hvqXWJ8HBpJJ8ln2v72N7UwtvDSDlEETr9uHxBg3H+QCTqNRW9YIzwkigMXn7JPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CLE7y3ot; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CLE7y3ot"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3DE7C4CEE4;
	Tue, 25 Mar 2025 15:39:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742917198;
	bh=am9FunDcKx0MSc3x6dOTCpKV2sXz1d5Pqt7ld9PVGEU=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=CLE7y3otIxitxaKDJUh6LoFJnrjkIyTTf/KyDLDDGw2mREPGjL9hlHkqOo+Lh7PK8
	 FoRfIHRNs50pMNxKu01Suy9e07boGr6AU7V3Ou6X3ABikWock07dPIc5rTuHOwoSxr
	 IrPwY1zW425UrSXsOP5CM6fY3hBd7i09mhSwHUz9NUlrW898CU1SgFIjvYF5ESHKv1
	 XzFWb0YiSvwu8GTaYzReLVTzQzmzuABKMKslxQbhktkPADqobM7RI3rm41UW95MFGm
	 talwCVQ486a/F29VcZ8cAGBGWYQNUDZmnR7zRISLB0r9LY2siTAjqhmMI2OdUR+eYY
	 iD52aic6UYuwg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 341E7380CFE7;
	Tue, 25 Mar 2025 15:40:36 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 1/7] netfilter: xt_hashlimit: replace vmalloc calls
 with kvmalloc
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <174291723501.621610.11595803602695403455.git-patchwork-notify@kernel.org>
Date: Tue, 25 Mar 2025 15:40:35 +0000
References: <20250323100922.59983-2-pablo@netfilter.org>
In-Reply-To: <20250323100922.59983-2-pablo@netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 edumazet@google.com, fw@strlen.de, horms@kernel.org

Hello:

This series was applied to netdev/net-next.git (main)
by Pablo Neira Ayuso <pablo@netfilter.org>:

On Sun, 23 Mar 2025 11:09:16 +0100 you wrote:
> From: Denis Kirjanov <kirjanov@gmail.com>
> 
> Replace vmalloc allocations with kvmalloc since
> kvmalloc is more flexible in memory allocation
> 
> Signed-off-by: Denis Kirjanov <kirjanov@gmail.com>
> Reviewed-by: Florian Westphal <fw@strlen.de>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> 
> [...]

Here is the summary with links:
  - [net-next,1/7] netfilter: xt_hashlimit: replace vmalloc calls with kvmalloc
    https://git.kernel.org/netdev/net-next/c/ddf8dec6db31
  - [net-next,2/7] netfilter: conntrack: Bound nf_conntrack sysctl writes
    https://git.kernel.org/netdev/net-next/c/8b6861390ffe
  - [net-next,3/7] netfilter: fib: avoid lookup if socket is available
    https://git.kernel.org/netdev/net-next/c/eaaff9b6702e
  - [net-next,4/7] netfilter: nfnetlink_queue: Initialize ctx to avoid memory allocation error
    https://git.kernel.org/netdev/net-next/c/778b09d91baa
  - [net-next,5/7] netfilter: xtables: Use strscpy() instead of strscpy_pad()
    https://git.kernel.org/netdev/net-next/c/3b4aff61ca5d
  - [net-next,6/7] netfilter: socket: Lookup orig tuple for IPv6 SNAT
    https://git.kernel.org/netdev/net-next/c/932b32ffd760
  - [net-next,7/7] netfilter: nf_tables: Only use nf_skip_indirect_calls() when MITIGATION_RETPOLINE
    https://git.kernel.org/netdev/net-next/c/e3a4182edd1a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


