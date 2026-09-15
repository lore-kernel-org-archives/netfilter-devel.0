Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67E8927A47F;
	Tue, 15 Sep 2026 00:21:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789431672; cv=none; b=gTk3UldlpS8+i0bY68BlQjGp+JRVEirAze6lmOwLrWmehiGzNYFeCCbasGfv4O608YV0TtV8vWVvLXA8C2wgGtVwalmpKDKdE3mpEv274bvDN8APzS2rB8HMgdWt1q3CUyO8zUenzrkIFodEnIe6aJsOYmClSMc3rHFAzd/LZG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789431672; c=relaxed/simple;
	bh=cUnjdvNRb1PXE6Rc0wmy0k+B6Job5/nz4WuKYy68McU=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=SUi1vDe4aN0huO2rxANeK0QFUPXYABPe1LvP1t4TmJ17xhWkVLvKWTVtp9uRfYuSNtM1OP4KB5myg+dvnf4fZYKI66V92d4466ziL7NcTN1RN4V1mcTdtGsks5YDKmgvGobybkUSVxYFJEAERXMjpSlZNDVCD2zXIIj3WTYZj8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Xv6P3Sgb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Xv6P3Sgb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E260C1F000FF;
	Tue, 15 Sep 2026 00:21:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789431670;
	bh=E20L9yKp4XRKGgOaSdJzezBFqCiY2QemMpeF4gDk6tc=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=Xv6P3SgbR/XPl5VzWg8N63sVLz/BrKmz+QY7D4+vjHj9SGXvxBJK1la/WTDyzq552
	 EnWb/KE+C6x1RDJXJuqAzD6AdukGDMMoFZ4ZyACNqMqcbf0m7cBsufjB6gPHd6bRIG
	 TR+dx9+/bZGuVGVY5zf9UWOVzu8vwLXyggwmYg64DVlGx7xJGrAxcz0Z8AqeWkB/V5
	 wzdB3PzN5yFWC/hydeBSSs9lWNQCeRcCShCk/VHaISLw/oAL/3DkhVr1zl0UP69X7V
	 BB0f/5E7hfMZJD0Yd6FsprKyqHJSK49E4RSFOd9bkmw1DU0yV4EYVDnwedcqwsQtgm
	 B7SvbU70rlb7A==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 1983C3924FFC;
	Tue, 15 Sep 2026 00:20:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 1/8] netfilter: seqadj: do not take ct lock if
 seqadj
 is NULL
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <178943160590.1282643.5687217999370487767.git-patchwork-notify@kernel.org>
Date: Tue, 15 Sep 2026 00:20:05 +0000
References: <20260911084437.1838161-2-pablo@netfilter.org>
In-Reply-To: <20260911084437.1838161-2-pablo@netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 edumazet@google.com, horms@kernel.org, fw@strlen.de, ja@ssi.bg

Hello:

This series was applied to netdev/net-next.git (main)
by Pablo Neira Ayuso <pablo@netfilter.org>:

On Fri, 11 Sep 2026 10:44:30 +0200 you wrote:
> From: Fernando Fernandez Mancera <fmancera@suse.de>
> 
> This is a small optimization, only take ct lock if seqadj is present. In
> the unlikely case seqadj isn't present we can return immediately. This
> is consistent with the behavior of other functions that checks seqadj.
> 
> Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> 
> [...]

Here is the summary with links:
  - [net-next,1/8] netfilter: seqadj: do not take ct lock if seqadj is NULL
    https://git.kernel.org/netdev/net-next/c/1b9c4f3f9cd2
  - [net-next,2/8] netfilter: x_tables: use GFP_KERNEL_ACCOUNT in match/target
    https://git.kernel.org/netdev/net-next/c/ba100f6f2a02
  - [net-next,3/8] netfilter: nfnetlink: use GFP_KERNEL_ACCOUNT
    https://git.kernel.org/netdev/net-next/c/ef2344e67c0c
  - [net-next,4/8] netfilter: nf_tables: use GFP_KERNEL_ACCOUNT
    https://git.kernel.org/netdev/net-next/c/e8609e8d56fb
  - [net-next,5/8] netfilter: synproxy: use GFP_KERNEL_ACCOUNT
    https://git.kernel.org/netdev/net-next/c/399a0b7f3258
  - [net-next,6/8] netfilter: sysctl: use GFP_KERNEL_ACCOUNT
    https://git.kernel.org/netdev/net-next/c/324ca7a2b6fe
  - [net-next,7/8] netfilter: nat: use GFP_KERNEL_ACCOUNT
    https://git.kernel.org/netdev/net-next/c/70deb8ec08cf
  - [net-next,8/8] netfilter: conncount: use GFP_KERNEL_ACCOUNT
    https://git.kernel.org/netdev/net-next/c/0e28586ee444

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


