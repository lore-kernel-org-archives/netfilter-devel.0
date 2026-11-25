Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619427;
	b=KioF8DO59JXIeK3rermdbkMEgQaF0DqanXhSz1RG8lwms5+15RK5llOxdhewtpnflix0
	 6pXNv+b/tFohZLj30KCXIcWwdCwzJbMn/kNMCwOfI5LJl6IZIEmUv0LwlXdtZErGckH2w
	 om394uCp1n/TeE/zGiwkx5bsCPVWlv4FSi2RrSXQl/1gAJbiJGgicK1TCI0LdnLSJI3V0
	 AzI5iAD0RNXIZODYCRKYCx9VBdVJaIRcQ2GjjRweiNNykuW/Z19rCzeEydBe38yG1Ui5c
	 L48GrDMPaxhd6WmTY8FaEso/a9SrfLaIpfWkQfQJNXjeUGmJGFa1olUwuRjrHNTUmzA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619427;
	h=Received:DKIM-Signature:Received:Content-Type:MIME-Version:
	 Content-Transfer-Encoding:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc;
	bh=V7wLsvA3UlFdEIUuC/+imEtNqiWK0HK3KvMhOoraiZo=;
	b=4cV/oun6Dq44VTuwC0QpPVeS1iiDFENe7b0WRZO4kp+/il8aJOJlVwWeKRwZupzgOf5+
	 mnmrbjltB0t2e+W/nb5cf0+r5bgB0Gm/W6Acp3V4SVuNuASU1aH9MQB1elvdpOI68ImfH
	 pfT4l1cEOSvKA0fTKh3GP0K4VG17X4X/v9CCoLs+iqdzm5TjL42mlWQHWYvHM9miFCPHK
	 0KwwcytDbtvyXB9dJvrHeB5sUCm+BVvClk6yYMNKG5gi3cbQDdsWE0LtibcEvlUZ3jN/y
	 ihbCYZ8LXGTfrPqM0vUh6O1JKRJyWY3LOMYlYDFhSuWV3ws1TyWBnd7JriMxijisuEA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=j6KMgQwH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3074C606A31E;
	Wed, 25 Nov 2026 15:10:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=j6KMgQwH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0575C1F000C0;
	Wed, 25 Nov 2026 15:10:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795619427;
	bh=V7wLsvA3UlFdEIUuC/+imEtNqiWK0HK3KvMhOoraiZo=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=j6KMgQwHtnVkS22EeeMapkKenQJkJtTZfjjd3/4ZGHRo8r7f6Ctv3HEVN2E2wpVM4
	 fRyyoqK12q+IWcVeJZp5j2OKkQWJVnRjluohXIgp6mfQNV/vpPBN5YGwwjgJBQt8mV
	 Sk1H0f6+6e8ta0NKfyu1ovDcpcDJj3YdgubKvhlBTcL2aj2DX8rYXTStVzITfQuvKN
	 C7XmjRSnPtrLTGzBkJNas5Ss/uZ9xxWDRAi7isnGQgM4Hb+dnniKyfSLcxOW0Neam4
	 hLpswAC5cAWuHDqWeKLdGkLVj4lb9Vv3o5f1XiyMB/vkTIkWD7BK0S1V5sEyhK4rRj
	 p8JNWWqw4HyMA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id F14753808209;
	Wed, 25 Nov 2026 15:10:26 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v4 0/2] ipv6: Honor suppress_prefixlength in
 fib6_lookup()
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <179561942551.592665.10151486679595255146.git-patchwork-notify@kernel.org>
Date: Wed, 25 Nov 2026 15:10:25 +0000
References: <20261117110813.9894-2-leonard@lausen.nl>
In-Reply-To: <20261117110813.9894-2-leonard@lausen.nl>
To: Leonard Lausen <leonard@lausen.nl>
Cc: netdev@vger.kernel.org, dsahern@kernel.org, idosch@nvidia.com,
 davem@davemloft.net, edumazet@kernel.org, kuba@kernel.org, pabeni@redhat.com,
 horms@kernel.org, pablo@netfilter.org, fw@strlen.de, phil@nwl.cc,
 shuah@kernel.org, daniel@iogearbox.net, netfilter-devel@vger.kernel.org,
 coreteam@netfilter.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org

Hello:

This series was applied to netdev/net.git (main)
by Paolo Abeni <pabeni@redhat.com>:

On Tue, 17 Nov 2026 11:08:10 +0000 you wrote:
> This revision removes the cached-exception patch and its PMTU test, as
> requested. The series fixes the nftables regression introduced by
> 1c32b24c234b and leaves dst-based prefix suppression unchanged. The
> cached-exception work is deferred to net-next after the fib6_lookup()
> fix is present there. Interface-group suppression also remains deferred.
> 
> Patch 1 makes fib6_lookup() honor suppress_prefixlength while preserving
> terminal reject results, including blackhole nexthop objects. Patch 2
> adds six checks to nft_fib.sh using its existing fixture.
> 
> [...]

Here is the summary with links:
  - [net,v4,1/2] ipv6: Honor suppress_prefixlength in fib6_lookup()
    https://git.kernel.org/netdev/net/c/94df5595e31b
  - [net,v4,2/2] selftests: netfilter: cover IPv6 FIB prefix suppression
    https://git.kernel.org/netdev/net/c/a0bf14e17fb2

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


