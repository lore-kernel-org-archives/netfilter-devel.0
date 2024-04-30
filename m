Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CCB6140E26;
	Tue, 30 Apr 2024 15:20:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714490432; cv=none; b=eV2C7Dx4HAr0qOcpz7UNOiwMoyImVg6MKj+0uJRE90Awnjy+5FbP9Ree2uO1w81d/tDMzT/hBaz7pxAwiHyeyPP+Rdjm+Uk2I84jUqxoGw0QEQVRl8lJ2+J0YAkJBWNeRobIQX3LScM+TOIx+B8qs/epY/n2NgTIAauMsfPDQ74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714490432; c=relaxed/simple;
	bh=JwUq2o3SycJ+v3mu19N1cEuDSkxRrtKf6DXZT8LZzzI=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=gbc3l0H0/zzowDZLfIRyhN5j0G65o26TLQQS9KBDUJjpXzHa4S2WeQQ9DRJHB3wXCzjkQRRnVYHl9I1lgRhqXeX+7PT9wum9UxTsKK76Icnp/AZxBDnOBo7EVMqXXcZ91nL6L+HRvGfwujj5ssFeeiGng9+5h++2GLRT3ZYx0i0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iqzKQoQM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iqzKQoQM"
Received: by smtp.kernel.org (Postfix) with ESMTPS id DD32CC4AF18;
	Tue, 30 Apr 2024 15:20:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1714490430;
	bh=JwUq2o3SycJ+v3mu19N1cEuDSkxRrtKf6DXZT8LZzzI=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=iqzKQoQMaXVfTnA+9lTRESVhcu3T+elFSXp++FIOWy127LmlTV0WcDWM+Zzn1SPaW
	 +NN2ONY7Aqnv+zgV0iYenGqjaFEyLZKFBkUwDU1WF3WsftDTBwx6uuyibCOojXanhR
	 zDfEGmXG4gHmzBb3NBc8HdiTcp/xhCVlW3zzSBDXj2DYtSC+ri0ZEdcGJZe8ywnga9
	 HmWeHWVHTN3uDEE1pR67KCMgmYLHxVMpo+v5v5rQFYIWPTq4XuAdELFSh4LSML82kg
	 FPs6oJvRISoeE+oA/KuKPN9cdjkCH3giAy3BKex7mSTsrRe4TF/qRQf+SUr5GxDO8c
	 nz1v31H3UlGWw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C9C6DC43617;
	Tue, 30 Apr 2024 15:20:30 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] selftests: netfilter: avoid test timeouts on debug
 kernels
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <171449043082.29434.12702226836543315240.git-patchwork-notify@kernel.org>
Date: Tue, 30 Apr 2024 15:20:30 +0000
References: <20240429105736.22677-1-fw@strlen.de>
In-Reply-To: <20240429105736.22677-1-fw@strlen.de>
To: Florian Westphal <fw@strlen.de>
Cc: netdev@vger.kernel.org, pabeni@redhat.com, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, netfilter-devel@vger.kernel.org,
 pablo@netfilter.org

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 29 Apr 2024 12:57:28 +0200 you wrote:
> Jakub reports that some tests fail on netdev CI when executed in a debug
> kernel.
> 
> Increase test timeout to 30m, this should hopefully be enough.
> Also reduce test duration where possible for "slow" machines.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>
> 
> [...]

Here is the summary with links:
  - [net-next] selftests: netfilter: avoid test timeouts on debug kernels
    https://git.kernel.org/netdev/net-next/c/f581bcf02f0e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


