Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8844A198E8C;
	Fri, 25 Jul 2025 23:50:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753487412; cv=none; b=YOP9IOqXBYkYlSp2O+Vf0ydyl7yT7g7us3j42UZZy6EPGacJOr+zQbbpWlwIqS4DSqgVmFCHacp75lqDDgTsM0pZ7QbHSdb4HJvDGy9y1oj4268ecgPwn7VQNNsfdW9iEWoFVMCRJHxu5swNCQnrEaNHWJz6S28xLjd1l7OEBME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753487412; c=relaxed/simple;
	bh=8oAXluIav9BzRKGJIC4r2ibVPEzBBaKaC8TqhSOVjNc=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=pMCSb9+JUi1NFdbr7mKWJvJrL0MV6h0+GA0ZesEUBDa5jpO3G9SXG3eSD4dCZqzzrUFoqKm862KF2/q4ah1T4/mKkdw9OyVU7hTsG9D0emNgXFMVtqF8AYxWc0F0ky+C0fbClNWminXQnLFJHEWu6Awii7ms6tq5M6dDX2gzy/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=C2U5vM7f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C2U5vM7f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12198C4CEE7;
	Fri, 25 Jul 2025 23:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753487412;
	bh=8oAXluIav9BzRKGJIC4r2ibVPEzBBaKaC8TqhSOVjNc=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=C2U5vM7fuBKR9H6IuRerp0kQUei446GBOWNyAdgNDoRm3CP5JhjOl+aBiMfLrnNSB
	 asyAG9+Imul0xa/dE3F95/Fnqwjkl7PQQdrDQpbEI6dbMpHavKTDQUUgBdZmuh8f0N
	 7q3TVv5cksHzL9C/BHr5ItV89fxLW3eHyWZncMvyOELO/e2HpNtRGksX1IcuMnhWI9
	 a09mI/mFEAMgeiPpWxS2AlR3b61PbHVeAffAUkkvmUmr0LyrlePQtYgREgz73aVPuZ
	 NlPcnaBTZHfBGBSR0IwB3hBzLAws489DXNIksOZ6HU4dz+f2ojN9BYyLV79kd1h7Fz
	 Ri4UXHHAPu2gw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id ADE2F383BF4E;
	Fri, 25 Jul 2025 23:50:30 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 01/19] netfilter: conntrack: table full detailed
 log
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <175348742951.3449488.12512237437033240060.git-patchwork-notify@kernel.org>
Date: Fri, 25 Jul 2025 23:50:29 +0000
References: <20250725170340.21327-2-pablo@netfilter.org>
In-Reply-To: <20250725170340.21327-2-pablo@netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 edumazet@google.com, fw@strlen.de, horms@kernel.org

Hello:

This series was applied to netdev/net-next.git (main)
by Pablo Neira Ayuso <pablo@netfilter.org>:

On Fri, 25 Jul 2025 19:03:22 +0200 you wrote:
> From: lvxiafei <lvxiafei@sensetime.com>
> 
> Add the netns field in the "nf_conntrack: table full, dropping packet"
> log to help locate the specific netns when the table is full.
> 
> Signed-off-by: lvxiafei <lvxiafei@sensetime.com>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> 
> [...]

Here is the summary with links:
  - [net-next,01/19] netfilter: conntrack: table full detailed log
    https://git.kernel.org/netdev/net-next/c/aa5840167780
  - [net-next,02/19] netfilter: load nf_log_syslog on enabling nf_conntrack_log_invalid
    https://git.kernel.org/netdev/net-next/c/e89a68046687
  - [net-next,03/19] netfilter: x_tables: Remove unused functions xt_{in|out}name()
    https://git.kernel.org/netdev/net-next/c/031a71247194
  - [net-next,04/19] netfilter: nf_tables: Remove unused nft_reduce_is_readonly()
    https://git.kernel.org/netdev/net-next/c/bf6788742b8d
  - [net-next,05/19] netfilter: conntrack: Remove unused net in nf_conntrack_double_lock()
    https://git.kernel.org/netdev/net-next/c/29f0f4cefc28
  - [net-next,06/19] netfilter: Exclude LEGACY TABLES on PREEMPT_RT.
    https://git.kernel.org/netdev/net-next/c/9fce66583f06
  - [net-next,07/19] selftests: net: Enable legacy netfilter legacy options.
    https://git.kernel.org/netdev/net-next/c/3c3ab65f00eb
  - [net-next,08/19] selftests: netfilter: Enable CONFIG_INET_SCTP_DIAG
    https://git.kernel.org/netdev/net-next/c/ba71a6e58b38
  - [net-next,09/19] ipvs: Rename del_timer in comment in ip_vs_conn_expire_now()
    https://git.kernel.org/netdev/net-next/c/bfabc4f70ee7
  - [net-next,10/19] netfilter: nfnetlink: New NFNLA_HOOK_INFO_DESC helper
    https://git.kernel.org/netdev/net-next/c/b65504e7cf0a
  - [net-next,11/19] netfilter: nfnetlink_hook: Dump flowtable info
    https://git.kernel.org/netdev/net-next/c/bc8c43adfdc5
  - [net-next,12/19] netfilter: nft_set_pipapo: remove unused arguments
    https://git.kernel.org/netdev/net-next/c/7792c1e03054
  - [net-next,13/19] netfilter: nft_set: remove one argument from lookup and update functions
    https://git.kernel.org/netdev/net-next/c/17a20e09f086
  - [net-next,14/19] netfilter: nft_set: remove indirection from update API call
    https://git.kernel.org/netdev/net-next/c/531e61312104
  - [net-next,15/19] netfilter: nft_set_pipapo: merge pipapo_get/lookup
    https://git.kernel.org/netdev/net-next/c/d8d871a35ca9
  - [net-next,16/19] netfilter: nft_set_pipapo: prefer kvmalloc for scratch maps
    https://git.kernel.org/netdev/net-next/c/897eefee2eb7
  - [net-next,17/19] netfilter: xt_nfacct: don't assume acct name is null-terminated
    https://git.kernel.org/netdev/net-next/c/bf58e667af7d
  - [net-next,18/19] selftests: netfilter: Ignore tainted kernels in interface stress test
    https://git.kernel.org/netdev/net-next/c/8d1c91850d06
  - [net-next,19/19] selftests: netfilter: ipvs.sh: Explicity disable rp_filter on interface tunl0
    https://git.kernel.org/netdev/net-next/c/8b4a1a46e84a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


