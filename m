Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C31B800;
	Thu, 25 Apr 2024 00:30:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714005029; cv=none; b=JfynH0pclhcx8ztUWkUB9q0WH8vsu19igvz9Nk5G8PT+UI49X4jyIhcRweKrEWrrMPWCdZtBifK1kv50Y+RjkvqyMdjnvs9SyFLnAUyA9b70rLiQyXi4ihuMNpnRUYcW8FBiDICN+ljK4u9/FeQVzuSKB+HP3opIjpF7k6I7mO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714005029; c=relaxed/simple;
	bh=TMouWAKGI9DGVxwAmwJzKVQLS6yKS2cOmK2SttfRxW8=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=otTYrEI0GeFfLBiLpFlW5n/gpm14BUUqHR3LJZI+by2bUiL5TuktIwgKBh+k9D1x8lr+mJlj7n/znwfniT0l+9bT7NxWYD2WCivtcOog8eTd2qXGpipFA8uQbMJSLuZHz3MmtIGzHcAKtfjbNGCMiF/ud2HDAVQylLELqE73mQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=p70p+OkF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="p70p+OkF"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 18F40C2BBFC;
	Thu, 25 Apr 2024 00:30:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1714005029;
	bh=TMouWAKGI9DGVxwAmwJzKVQLS6yKS2cOmK2SttfRxW8=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=p70p+OkF6/xTwDinEY69hrufvEqdbK09wXCYXdKrGtPLZk6UmQVP+dcl/4lbI5yTQ
	 6OjEilgFLUMOAwzKUMH8p/OpjfQEhxCk+zr8r1+crPVPLbturoWMl/RHkEy5qllAmW
	 i1WmChTH+qQH9zAX1fDSjyTYfwGOyQfFE8YyJuu+a7d/BgSNrESsn0Fbhap1wXzHUo
	 VpViN5MsNQ9TDi12R1H+gUancwZzh9dUclpyuTs6NkioXgEMouoSEgAEH7xO5MRrrR
	 XSpVm6DL3rfUkpxdY4dvxBv6w/Db4nSfNi1Q23yjicQqXSbDQ/XwZR86drN/xjuifm
	 ZXLkE6XC4E7lg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 0A2ABC00448;
	Thu, 25 Apr 2024 00:30:29 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] selftests: netfilter: fix conntrack_dump_flush
 retval on unsupported kernel
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <171400502903.22410.6999732132330673626.git-patchwork-notify@kernel.org>
Date: Thu, 25 Apr 2024 00:30:29 +0000
References: <20240422103358.3511-1-fw@strlen.de>
In-Reply-To: <20240422103358.3511-1-fw@strlen.de>
To: Florian Westphal <fw@strlen.de>
Cc: netdev@vger.kernel.org, pabeni@redhat.com, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, netfilter-devel@vger.kernel.org,
 pablo@netfilter.org

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 22 Apr 2024 12:33:53 +0200 you wrote:
> With CONFIG_NETFILTER=n test passes instead of skip.  Before:
> 
>  ./run_kselftest.sh -t net/netfilter:conntrack_dump_flush
> [..]
>  # Starting 3 tests from 1 test cases.
>  #  RUN           conntrack_dump_flush.test_dump_by_zone ...
>  mnl_socket_open: Protocol not supported
> [..]
>  ok 3 conntrack_dump_flush.test_flush_by_zone_default
>  # PASSED: 3 / 3 tests passed.
>  # Totals: pass:3 fail:0 xfail:0 xpass:0 skip:0 error:0
> 
> [...]

Here is the summary with links:
  - [net-next] selftests: netfilter: fix conntrack_dump_flush retval on unsupported kernel
    https://git.kernel.org/netdev/net-next/c/dd99c29e83e4

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


