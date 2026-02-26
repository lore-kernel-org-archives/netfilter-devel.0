Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 020FC389446;
	Thu, 26 Feb 2026 03:50:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772077813; cv=none; b=lgfu39WG69AaTqR7cL1yargWvxUAQzSjKxJ/fEeCfS5MI1IbQyb1RF+FOYEvOcQP1GvT+kBz0Au7zbGo6h2Pv6ISxpuuSAW06ItFckcwqEzD7tpGIHQ+JTavpdlBTyG/HTLhmNRC6wOUPkF3i4dXeRuvKRY6Mf9kbshsulUicyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772077813; c=relaxed/simple;
	bh=fci/qBn+7ygH24gFYFDNon8C8dvf2G87OGJVy6Fr98Y=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=JBOmf4wCckbOS/4xZ5re/8+eJeby5PKUINmrKKOf7oD1zuYRq4oiKwIfm1l5GPLyvkfU+ToBWIYeho2kEwqDuXqtr3laJEFKKr8QEupTkkcX1hURJmWtzXCWYwuoqmwWaHctVhORq2OY9ByIoGVswxYXUCNDP9JhEBx4eyRVGQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=l54H8jwF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="l54H8jwF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94071C116C6;
	Thu, 26 Feb 2026 03:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772077812;
	bh=fci/qBn+7ygH24gFYFDNon8C8dvf2G87OGJVy6Fr98Y=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=l54H8jwFcYn+CoGiToEUpVJIKGbLauP2FomTNkREPUto78k7V+Bo3X1RyPLcX4/Hn
	 DXGUG46kWNf7zkaY1nuID9VoaftAGCna9zGNcxpXebJ3A2NLBXKEcIcjkhguZWTkzH
	 YL6IxOHaOmqAreFK70WMFCxZhVxpuhF9Pqct5s7jjlI8MMJaoOm56ygVW9ibYaRefl
	 /gMoIZxVj61usDzoEPOiJLKJVb7CZR0bjPE6MOaS6sb8vONA3FYbtjebhsViVWJR6U
	 xsvGza7/GnqX2/eZN15zFsjwWLvNcKCt6K0fjZuXgAlTKEL0rHI3aFjqmvjlDc0D6/
	 4lA2DLqiD0wtQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 7CFB8380A94B;
	Thu, 26 Feb 2026 03:50:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/9] netfilter: updates for net-next
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <177207781729.1027914.17116155293102678686.git-patchwork-notify@kernel.org>
Date: Thu, 26 Feb 2026 03:50:17 +0000
References: <20260224205048.4718-1-fw@strlen.de>
In-Reply-To: <20260224205048.4718-1-fw@strlen.de>
To: Florian Westphal <fw@strlen.de>
Cc: netdev@vger.kernel.org, pabeni@redhat.com, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, netfilter-devel@vger.kernel.org,
 pablo@netfilter.org

Hello:

This series was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 24 Feb 2026 21:50:39 +0100 you wrote:
> Hi,
> 
> The following patchset contains Netfilter fixes for *net-next*,
> including IPVS updates from and via Julian Anastasov.
> 
> First updates for IPVS. From Julians cover-letter:
> 
> [...]

Here is the summary with links:
  - [net-next,1/9] ipvs: make ip_vs_svc_table and ip_vs_svc_fwm_table per netns
    https://git.kernel.org/netdev/net-next/c/74455a5b4326
  - [net-next,2/9] ipvs: some service readers can use RCU
    https://git.kernel.org/netdev/net-next/c/3de0ec2873ea
  - [net-next,3/9] ipvs: use single svc table
    https://git.kernel.org/netdev/net-next/c/b24ae1a387e4
  - [net-next,4/9] ipvs: do not keep dest_dst after dest is removed
    https://git.kernel.org/netdev/net-next/c/40fb72209fd8
  - [net-next,5/9] ipvs: use more counters to avoid service lookups
    https://git.kernel.org/netdev/net-next/c/c59bd9e62e06
  - [net-next,6/9] ipvs: no_cport and dropentry counters can be per-net
    https://git.kernel.org/netdev/net-next/c/09b71fb45946
  - [net-next,7/9] netfilter: nft_set_rbtree: don't disable bh when acquiring tree lock
    https://git.kernel.org/netdev/net-next/c/3aea466a4399
  - [net-next,8/9] netfilter: nf_tables: drop obsolete EXPORT_SYMBOLs
    https://git.kernel.org/netdev/net-next/c/b6461103e01a
  - [net-next,9/9] netfilter: nf_tables: remove register tracking infrastructure
    https://git.kernel.org/netdev/net-next/c/6b94d081f81d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


