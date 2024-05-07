Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E73B86128;
	Tue,  7 May 2024 23:40:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715125230; cv=none; b=KKz/Vy3+Y1h2V8o8+JLZxwNCxDaGLedngO4seWCaCAMFnqx9TbhjzpJ3ViJtIR00TyF0hUiLzZfeAcuiI67WCUbAwPvo7BOxGa5zKPWcyUgP1TO7BIJx173JSjbzwz+G7L1Dskpl0fzKvWkoJtZSKd1lh13dtWxF3Ldyn6HYkro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715125230; c=relaxed/simple;
	bh=C7NSF3vJhM4BSvLjhB7M0TbuLFQ4Crn+An+CD8TYils=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=drZ+VZ20unmd6Xq5oHApWWlsv/kXjIxBz+wl5co9DLcVMQustYrs7q4hrqyTdBl/fPOnNbfqfbA6qTOoAmsWersBowhORaJnamhvNtzWnkz9pogEoqDd21UEfHvfSKMVOdmYTxDoeSmW09RvX8h9+N8qjQpo24bkBlqEdDOax78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=khlssk/S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="khlssk/S"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0F635C4AF63;
	Tue,  7 May 2024 23:40:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1715125230;
	bh=C7NSF3vJhM4BSvLjhB7M0TbuLFQ4Crn+An+CD8TYils=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=khlssk/SpyYlEs8LkVpq0Z5t6Tdqi+g3kxCMkKq2MpWdF9DngeQcYnMAx52Q69Oqz
	 3r/oTmctYWIapJuVcVy9/kf3snuZp2u48/t9/MQ4g+I9Ydx+QMTZFdfQUi4CQSxoYs
	 Ooh7ckXPP88M56dXmYvJNqffr5lLryrA/pVybuQWZaeDM2OIZolV96YjWHxIK38VBh
	 PudfJ0wObEDQUW5YN2Iy9drzZvYWDZTao16Pz7l7KT/wCKE9OfQkg1LHlXGiTQcbO3
	 iDFcKV85P+kjzag42WK5UytNqbmcNHn8/v8W5ZL+DuGep5o827WsURFYm8Odu7lilZ
	 XRqxKrif3Cjuw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id EBD59C43330;
	Tue,  7 May 2024 23:40:29 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] selftests: netfilter: conntrack_tcp_unreplied.sh:
 wait for initial connection attempt
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <171512522996.22016.2718919156181526257.git-patchwork-notify@kernel.org>
Date: Tue, 07 May 2024 23:40:29 +0000
References: <20240506114320.12178-1-fw@strlen.de>
In-Reply-To: <20240506114320.12178-1-fw@strlen.de>
To: Florian Westphal <fw@strlen.de>
Cc: netdev@vger.kernel.org, pabeni@redhat.com, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, netfilter-devel@vger.kernel.org,
 pablo@netfilter.org

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Mon,  6 May 2024 13:43:16 +0200 you wrote:
> Netdev CI reports occasional failures with this test
> ("ERROR: ns2-dX6bUE did not pick up tcp connection from peer").
> 
> Add explicit busywait call until the initial connection attempt shows
> up in conntrack rather than a one-shot 'must exist' check.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>
> 
> [...]

Here is the summary with links:
  - [net-next] selftests: netfilter: conntrack_tcp_unreplied.sh: wait for initial connection attempt
    https://git.kernel.org/netdev/net-next/c/76508154d7da

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


