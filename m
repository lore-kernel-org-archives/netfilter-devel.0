Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DFD429BD90;
	Thu, 30 Oct 2025 01:40:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761788433; cv=none; b=m8D8niVtWoWES6vU/vLdxzsvIZ5x/tqBIV6rERpSG+TtXCz0+jgWbGkXqmQq5J6Qtx57OpOLA7k2c4IBbG2c6iiJBh3mtGwyQf2vm74+81NrnviKEjEGenCUa9xb405OD2es2JINbXpV+NlWLeoG3wtBrRMqqmoqOcwFXl9hs0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761788433; c=relaxed/simple;
	bh=TWJ1k0H1ocYselqyxOQ/3As1uWAFGaYMbyhgwulx7bE=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=O8D7dDiMZVJ4I+6Q85tisheEgCtT0HDXv1vs7z0tnJMhyVuK1fHtsmx4pUUu/eZ9R92LARBl1c0Wa9h2WZU+nBLbyatQaDvYyXVI54zQ2V2XQCUJ1Is7TmYLc5IufuXYpeNXmYRtFtfC2YBVgplvuffA/BZmpbHDeazDc9BJqrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TujuCcKQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TujuCcKQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8AE3C4CEFD;
	Thu, 30 Oct 2025 01:40:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761788431;
	bh=TWJ1k0H1ocYselqyxOQ/3As1uWAFGaYMbyhgwulx7bE=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=TujuCcKQ9JVAuB3hz+R5KGD9QgEHaYWtxTtR+0Xa/oqREQgaFuBlFTqZAFggKCE7D
	 ymRRlon+OjXk8vksO2zZ3thJtuAvL4xcNA7ydTSPvkQ5gj6oDvN0cwLHdxprXAuE4C
	 YrfQurf9RL7ybhndwhIKdAitNPFipnk4Ofo+Yt0FQAlbKIht6W0fX+stbNAm76PMBD
	 jkKaNjRyrKdMCGcrSGGJCIxydSMrq9CYn5cCh5y2gAtIbEJ4GbA84RjzrUj+Wz1Ijn
	 0OEzLncdgJ7SmDU1OA1+1Y2RwRtVQMvsI2DVw4vay0espNTqTPezSl86LW6FBeBOo+
	 g6U33nZb3MyRg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id EAEFC3A55ED9;
	Thu, 30 Oct 2025 01:40:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/3] netfilter: nft_ct: enable labels for get case too
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <176178840875.3278679.16981730284389717212.git-patchwork-notify@kernel.org>
Date: Thu, 30 Oct 2025 01:40:08 +0000
References: <20251029135617.18274-2-fw@strlen.de>
In-Reply-To: <20251029135617.18274-2-fw@strlen.de>
To: Florian Westphal <fw@strlen.de>
Cc: netdev@vger.kernel.org, pabeni@redhat.com, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, netfilter-devel@vger.kernel.org,
 pablo@netfilter.org

Hello:

This series was applied to netdev/net.git (main)
by Florian Westphal <fw@strlen.de>:

On Wed, 29 Oct 2025 14:56:15 +0100 you wrote:
> conntrack labels can only be set when the conntrack has been created
> with the "ctlabel" extension.
> 
> For older iptables (connlabel match), adding an "-m connlabel" rule
> turns on the ctlabel extension allocation for all future conntrack
> entries.
> 
> [...]

Here is the summary with links:
  - [net,1/3] netfilter: nft_ct: enable labels for get case too
    https://git.kernel.org/netdev/net/c/514f1dc8f2ca
  - [net,2/3] netfilter: nft_connlimit: fix possible data race on connection count
    https://git.kernel.org/netdev/net/c/8d96dfdcabef
  - [net,3/3] netfilter: nft_ct: add seqadj extension for natted connections
    https://git.kernel.org/netdev/net/c/90918e3b6404

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


