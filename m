Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794916209;
	b=s8h/0OGQ5eQXCZD42K7VU4kknFuqwmEhbCu63IakmZKh+Ec/MREhI0nbGLtmlkt4K1Ua
	 s7g36WAEROvM0R1JWAobgvGS8AwJY9QKbjgvE5rMjZ6VpS4mHMKPflDdCzyePLZAfFFAu
	 GKx984JARjgcNDUk2OciMT91ly9l2NVpCvgYZqIIsIL3Ji3ftdMgSUZSIcxXrdc0gYqQu
	 tmqrT6WfgEvwjbcjP3mVb4P9xsGnJL/zBPBtxV51xkv9mzztlvzSzsYihWJ/esrvRtcJq
	 nFmh+4xXa/eOAvu0TAmq8BtzUXWOFQl7dUiONNk3OBjqAqfSBShyd7dB6Vv+zkIwjaA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794916209;
	h=Received:DKIM-Signature:Received:Content-Type:MIME-Version:
	 Content-Transfer-Encoding:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc;
	bh=NYCi6TRZf6fY/IIDQvm/vPxYiFe6DC8NUAUlATMW1bQ=;
	b=G7yEqutuCV6FocXPs5p/907PENpZpyT1cNUHDDs5EACOveijdJA3iUqTs9lm0U2F39Qs
	 NCRRKeZWG20MJVyGHRcxorp9eftfAF7RaHeGWdrCQ3mjw74+FUQ8Qzb2vsZJYYS1Em7bu
	 n6FMYvdcCJnJRLdXwBL2G0PQlD2vn+7VMRP8r5jU2JAO3+A/bHkBxd9ShcH10sMzUvgTr
	 3zNRGkXOBl/bTP0wvGN/uvWsJVlUn0EOCPvxld10K0qa/TPgtXHiToA/pm1ZuuxKkK5MQ
	 3i/PMqwRy4Qn8PQG/uJs81eUb7FUiWBNcDllFizo+mt8fYFBdIhK7jtjiGpZgnBrWYw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EYNZgfQt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5A60606A31C;
	Tue, 17 Nov 2026 11:50:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EYNZgfQt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF92C1F000CC;
	Tue, 17 Nov 2026 11:50:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794916208;
	bh=NYCi6TRZf6fY/IIDQvm/vPxYiFe6DC8NUAUlATMW1bQ=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=EYNZgfQtqgPkFFtYkvMeeDjpO9D7sYstMhGPrt7rJmjvIOVLAFFopt0IjLbwVoMoS
	 lux2ixZ1OmZ64tjp3jm5Ivdw0/9SHp2ZOiZD065Gj325xW4IhjVm3zHY0W4xxIJT9A
	 fjmTJUa2UxPfuoARQdjPQ/gXumPjJ9VurKHwfn1vmn3hqAHejDraWFgln3R7J5/88t
	 Ze6TlzdTN8u5FlkzqEblOtIIbyMBPa4FqCtJBBYcebh4hPwKLBJVh8dUVf7YyVQCFc
	 Wr7XeySyzfFZ6m8fXeZr9Tvwh+zOxSr4QgqTDe+knBSgJrTjGgXbvZMecsXmBg0pgi
	 B5I3k9MrHJvNQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id B43E13926661;
	Tue, 17 Nov 2026 11:50:08 +0000 (UTC)
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
Subject: Re: [PATCH net 01/11] ipvs: fix problems during connection deletion
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <179491620753.531240.17009155565990687416.git-patchwork-notify@kernel.org>
Date: Tue, 17 Nov 2026 11:50:07 +0000
References: <20261116004404.2821183-2-pablo@netfilter.org>
In-Reply-To: <20261116004404.2821183-2-pablo@netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 edumazet@kernel.org, horms@kernel.org, fw@strlen.de, ja@ssi.bg

Hello:

This series was applied to netdev/net.git (main)
by Pablo Neira Ayuso <pablo@netfilter.org>:

On Mon, 16 Nov 2026 01:43:54 +0100 you wrote:
> From: Julian Anastasov <ja@ssi.bg>
> 
> Sashiko reports for problem when deleting connections.
> 
> If connection timer expires, its callback can not be
> concurrently running but if connection is deleted
> the callback can be running on another CPU even
> after all references are released. Before now we
> continued with the connection freeing, risking the
> callback to access the deleted connection after it
> is freed. As ip_vs_conn_del() runs under RCU lock
> there is no risk for accessing a connection freed
> by concurrent timer callback. As Sashiko warns, the
> risk is present if normal connection expires and
> tries to delete its cp->control chain with
> ip_vs_conn_del_put() without holding a RCU read lock.
> 
> [...]

Here is the summary with links:
  - [net,01/11] ipvs: fix problems during connection deletion
    https://git.kernel.org/netdev/net/c/5ae07c10854f
  - [net,02/11] ipvs: avoid stack overflow from recursive connection expiration
    https://git.kernel.org/netdev/net/c/d4e4cd04de2c
  - [net,03/11] ipvs: reject FTP control ports as data ports
    https://git.kernel.org/netdev/net/c/a107e150e105
  - [net,04/11] ipvs: ftp: skip conntrack templates in ip_vs_ftp_out
    https://git.kernel.org/netdev/net/c/4656934d460d
  - [net,05/11] ipvs: update flags and seqs in backup server under lock
    https://git.kernel.org/netdev/net/c/f3aff3d80b57
  - [net,06/11] ipvs: read flags and seqs in master atomically
    https://git.kernel.org/netdev/net/c/aa9afc79f57b
  - [net,07/11] ipvs: honor the overload state and do not enter it forever
    https://git.kernel.org/netdev/net/c/567ca80d77ba
  - [net,08/11] ipvs: validate cport in received sync records
    https://git.kernel.org/netdev/net/c/1d1e8bc81f79
  - [net,09/11] ipvs: skip cport 0 connections in ip_vs_conn_out_get()
    https://git.kernel.org/netdev/net/c/5c8d6e2596e0
  - [net,10/11] ipvs: do not create conns from packets with port 0
    https://git.kernel.org/netdev/net/c/7439e0fed91f
  - [net,11/11] ipvs: wait grace period before reusing destinations
    https://git.kernel.org/netdev/net/c/5367e14e92bb

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


