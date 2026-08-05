Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 707CF5A79B;
	Wed,  5 Aug 2026 23:50:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785973858; cv=none; b=Z4OuW2jBknn6OBHPpexMkZpGaMITFVbn6WJjZxHrbTCXJEnK5jzm8chrtuLVTYTc09Chyfeq9KVZqKpDjaUXDzQFib+4H9Tcdq1jdIgaMNqUL7L8u9CDj2coiRQZMRd9BBmHeXcusLJqXLSqGkzExYNfZtKs2/3guXBQQ5GMulc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785973858; c=relaxed/simple;
	bh=vRZWRjhp49/dQBd0qcdo37BrR2kBNGlsrsMBR/eweH8=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=rRPXA2/HaA+n/7+bc5ySLIZPjK7iL72CVln6Ld/jO6CJS2jVWDX6Za19dNl58rfVDiJAjIVg3bIOBmknY4idmRC6jnS6wXs7+1i79DWwFPtx0Sjx7L3f9gBLrP5OpaD7S/nWGXUGnABMx+gUbTXrZDXFh7FQQDKFmm1PwaIQp38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SRClgifc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SRClgifc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DED101F000E9;
	Wed,  5 Aug 2026 23:50:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785973856;
	bh=RB+eHuex3Qbm8gTW9/VwZ20lopgsZ0i4+C3p+dCVa0c=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=SRClgifcs6vDpxk1VlbO8GKOoSEfRD+Tc/aU4KnFu3k9UGYyxQouJnEzinEgA0Z+h
	 C2FvJu2tMOyjC+ByJab9AGzGi/S5r+hG0x9hsDLWE0xou1cISh+S22NGMJjO2l+tZB
	 wiXaXiJytTpWVj+AhCiMZ9bYX+dqb4yAkeX+vFPfc5pX/HGt3Wv/a/c8MBaB3iVdnd
	 j6KLk9UX6aXcj/SMlMqasfeDgcI8E9xWO8P91s/3igz7bSyX1NrpHY+LC/gHjGFIMT
	 Z9fsV8VnY6u5fim+Y0dbLpInTz/e9wz0RZ3ZFsHAwzSBCUnMecfhG/3JkxLOhLtlf2
	 V5XNIpDpxNVng==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id D0AA6392FFD8;
	Wed,  5 Aug 2026 23:50:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 01/10] ipvs: stop estimator after disabled calc phase
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <178597381664.567483.1491675233336234568.git-patchwork-notify@kernel.org>
Date: Wed, 05 Aug 2026 23:50:16 +0000
References: <20260731151806.849724-2-pablo@netfilter.org>
In-Reply-To: <20260731151806.849724-2-pablo@netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 edumazet@google.com, fw@strlen.de, horms@kernel.org

Hello:

This series was applied to netdev/net.git (main)
by Pablo Neira Ayuso <pablo@netfilter.org>:

On Fri, 31 Jul 2026 17:17:57 +0200 you wrote:
> From: Zhiling Zou <zhilinz@nebusec.ai>
> 
> IPVS estimator kthread 0 starts with zeroed chain and tick limits until
> its initial calculation phase completes. If network namespace teardown
> clears ipvs->enable during that phase, ip_vs_est_calc_phase() can return
> without installing positive limits.
> 
> [...]

Here is the summary with links:
  - [net,01/10] ipvs: stop estimator after disabled calc phase
    https://git.kernel.org/netdev/net/c/558f67f1340f
  - [net,02/10] netfilter: ebt_nflog: pin the NFLOG backend
    https://git.kernel.org/netdev/net/c/30825970339c
  - [net,03/10] netfilter: ipset: rework cidr bookkeeping
    https://git.kernel.org/netdev/net/c/8e5fd2a55e24
  - [net,04/10] netfilter: ipset: switch ext_size to atomic64_t
    https://git.kernel.org/netdev/net/c/712a6f545c35
  - [net,05/10] netfilter: ipset: add small wrappers for hash and bucket sizes
    https://git.kernel.org/netdev/net/c/c266769e9ede
  - [net,06/10] netfilter: ipset: add and use mtype_del_cidr_all helper
    https://git.kernel.org/netdev/net/c/cdd97fae0e96
  - [net,07/10] netfilter: ipset: switch to rcu work
    https://git.kernel.org/netdev/net/c/7defddefa95b
  - [net,08/10] ipvs: avoid out-of-bounds write in ip_vs_nat_icmp
    https://git.kernel.org/netdev/net/c/646922a03794
  - [net,09/10] ipvs: return the csum validation for forward hook
    https://git.kernel.org/netdev/net/c/99609cb0aa78
  - [net,10/10] netfilter: nft_ct: move custom expectation support to helper
    (no matching commit)

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


