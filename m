Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2BBF2BCF8;
	Tue, 22 Oct 2024 10:50:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729594223; cv=none; b=ZfeEh7RJskh1NMjhC/2U6QUmx0YtzavlOhr+sEuzSuDCHlYeMSAbo5uRtEyKv9wZg3j3u23qjqJA3lalj3pIhnLvoQySqO8cKHEK113BrHUzFBWSdVgtr8MezK/nvVaUzb4GT+gAZi6/3vxpdAlWs6uMwxCCUWKEjoOixkm7Tbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729594223; c=relaxed/simple;
	bh=E2T2zcNRbhjX5Yu+7I/h613ofyU3kF0hptsdle0CjKg=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=GJYdxQk/H1KMy0+CtE2hd3uzjAOg88cAsmnNO+JabFo7xbNHz4tSzlHio8rv7JXUAyB+2csbMzgxJt2qqGURizzkSnf7DsZCeMwQDZODM3cDRD5hl30zLw0k+cbX7wXp6NGzPYL0Jry47zDuFnUmA4vyHGmag9Al8692fl5OJuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=C7YH8j0/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C7YH8j0/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82A17C4CEE4;
	Tue, 22 Oct 2024 10:50:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729594222;
	bh=E2T2zcNRbhjX5Yu+7I/h613ofyU3kF0hptsdle0CjKg=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=C7YH8j0/P5h31KlxrgVIFquRdLHnmx4mnOGWdevd1FGbMBrcW6dr8wFYP/q/9qu7I
	 ob1LdvMpv6w1/nLTqTtyTjfDILG+P4to0y2cZu+wSLgnCVvhL4eMO0N5pts34jiUCR
	 oq++dHfIHsDB0BwTds3A1rh0TnhZCnJxD1R2Yr+sr35pZFyzcHr8QE/Z9IatCGnLHg
	 2a7iVbbGTL0w/6sU2Z1FK2mTa7/FD3cbGB0fGVHDnUBlo6xe6EcYO+uGiL/QV4ASYN
	 eDos+zgMZe0FmPpXKhqGWO8cwTW/iIPwUHqTxlh++fWaPCpSW0TrfWRBpcegp2aMnE
	 rWMLuICp0OxHw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id EC6E83809A8A;
	Tue, 22 Oct 2024 10:50:29 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH nf] netfilter: xtables: fix typo causing some targets to not
 load on IPv6
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <172959422878.927462.7005433281456352476.git-patchwork-notify@kernel.org>
Date: Tue, 22 Oct 2024 10:50:28 +0000
References: <20241020124951.180350-1-pablo@netfilter.org>
In-Reply-To: <20241020124951.180350-1-pablo@netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Pablo Neira Ayuso <pablo@netfilter.org>:

On Sun, 20 Oct 2024 14:49:51 +0200 you wrote:
> - There is no NFPROTO_IPV6 family for mark and NFLOG.
> - TRACE is also missing module autoload with NFPROTO_IPV6.
> 
> This results in ip6tables failing to restore a ruleset. This issue has been
> reported by several users providing incomplete patches.
> 
> Fixes: 0bfcb7b71e73 ("netfilter: xtables: avoid NFPROTO_UNSPEC where needed")
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> 
> [...]

Here is the summary with links:
  - [nf] netfilter: xtables: fix typo causing some targets to not load on IPv6
    https://git.kernel.org/netdev/net/c/306ed1728e84

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


