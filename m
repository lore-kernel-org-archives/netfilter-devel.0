Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C3B03BC673;
	Fri, 17 Jul 2026 09:30:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784280648; cv=none; b=JMV/hQ9pHt0ACL5+04c0FkjSn7k6u0s9xVii7XQtMia+ryBMTz/vHtdEaZ3ynQiGOMK8FH6W8/mQKF6ICwc8ivGTTzr+DQSTEvEbf13zhMSlxdBVoFuJFSlR7z8RMqML2Jw8srPkEdBfMh3gKPuC+bg+E62nK45MFIHEpf3ROA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784280648; c=relaxed/simple;
	bh=LqYGIDNByOvBi0ZYmn84+YWGss6Nl6w5252phscZ0Mc=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=hLL7hdlXYA64CcGXU7k/9k3oVaCDUIc2LU/cJrV3Cryo3Hj3mNi+NvcxdiZgEa134hT9V1E9uUw5REE8Iu7BcmEbMSUiDLSc+Rb1D3+l0ToOliop5iyP2j6G6x/2gExoAqQF6KeCA/ifUEiWAj8L8gdSwQDDPvI+hEFPW29vPmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fSxu3GAu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fSxu3GAu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 895321F00A3D;
	Fri, 17 Jul 2026 09:30:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784280646;
	bh=j7KPNetEq/jQajgeasNKN6mLklWHVozvteh4q1qI94U=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=fSxu3GAuH26hwxsZuqf9cyUudc6ZCL1zzqu899L63c4O5DjZcROJt+pFB3Qz1h51Y
	 V1SRqtCm/EhpwzN7khZKyXflEioFxMJX6hKvRUG7YZ8vtapmvOaasldbR26X9vSENO
	 RMjthFRi0i+aXtqIINqN2PhePaX7YmykqNgEd5c/esP38ERLEr1X9MfDJkiU8VQiPc
	 YpUJsCyFdr6UG1t1BX/JlPEL/u7NqFyhcmtdtMVMvaaXhgQfn2xdFyOEXVMhytTK2J
	 /4RMNDF3nbLlMXta8SucX6afpyqCtP/bREReT6sdhnM6GiT3MoCulfNeSAVcemOaQb
	 rWHJasKkhKe0w==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 56BB7380CECB;
	Fri, 17 Jul 2026 09:30:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/9] netfilter: xt_nat: reject unsupported target
 families
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <178428061915.1629459.3441388363052531602.git-patchwork-notify@kernel.org>
Date: Fri, 17 Jul 2026 09:30:19 +0000
References: <20260710143733.29741-2-fw@strlen.de>
In-Reply-To: <20260710143733.29741-2-fw@strlen.de>
To: Florian Westphal <fw@strlen.de>
Cc: netdev@vger.kernel.org, pabeni@redhat.com, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, netfilter-devel@vger.kernel.org,
 pablo@netfilter.org

Hello:

This series was applied to netdev/net.git (main)
by Florian Westphal <fw@strlen.de>:

On Fri, 10 Jul 2026 16:37:25 +0200 you wrote:
> From: Wyatt Feng <bronzed_45_vested@icloud.com>
> 
> xt_nat SNAT and DNAT target handlers assume IP-family conntrack state
> is present and can dereference a NULL pointer when instantiated from an
> unsupported family through nft_compat. A bridge-family compat rule can
> therefore trigger a NULL-dereference in nf_nat_setup_info().
> 
> [...]

Here is the summary with links:
  - [net,1/9] netfilter: xt_nat: reject unsupported target families
    https://git.kernel.org/netdev/net/c/5d1a2240935e
  - [net,2/9] netfilter: ecache: fix inverted time_after() check
    https://git.kernel.org/netdev/net/c/b06163ce52ec
  - [net,3/9] netfilter: bridge: fix stale prevhdr pointer in br_ip6_fragment()
    https://git.kernel.org/netdev/net/c/86f3ce81dd2b
  - [net,4/9] netfilter: nf_conncount: fix zone comparison in tuple dedup
    https://git.kernel.org/netdev/net/c/f62c41b4910e
  - [net,5/9] selftests: netfilter: add bridge tunnel flowtable regression
    https://git.kernel.org/netdev/net/c/bd0bdfae1cf0
  - [net,6/9] netfilter: flowtable: use correct direction to set up tunnel route
    https://git.kernel.org/netdev/net/c/90941d9c925d
  - [net,7/9] ipvs: reload ip header after head reallocation
    https://git.kernel.org/netdev/net/c/a2f57827bf7c
  - [net,8/9] ipvs: fix more places with wrong ipv6 transport offsets
    https://git.kernel.org/netdev/net/c/b3fe4cbd5838
  - [net,9/9] netfilter: xt_physdev: masks are not c-strings
    https://git.kernel.org/netdev/net/c/f468c48d488d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


