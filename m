Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6482D746A;
	Fri, 29 Dec 2023 08:00:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="i0MNrwGI"
Received: by smtp.kernel.org (Postfix) with ESMTPS id DA97BC433C9;
	Fri, 29 Dec 2023 08:00:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1703836825;
	bh=C1DVgPbHvBriNYsQuGAjsQx3wtajfxYgTBxjJSiXu8A=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=i0MNrwGIlj4rlB5EbkaXtlTss128MjNxneRw0YtOUoR8hEJ9HbaRa4dy0gEqQhQ6z
	 9Ax42dpnzaRQj3NYk7X3lYQKgUfsRsP88CEKlpgvX+4rVaqfHTDWX+KT187pjrn31z
	 nQO+PaG/m0GGOJHHjsPeWf10N5fIl5H8JQJxikq7fweC5rWiCpn4cp4Y/4u8GFewS7
	 +rZIoGsjPIYXAiVX9NX7jnowPvitUNV+iNmNdYw5Srfg2b8Zf/huhbdZoEUTvXc8xZ
	 FfezUs4MviGIk0Rq9c3rGWm31Ox5PPIbBCsQEAFSn5dhT1N+exIIRLdVDnNRBOP9wd
	 psk1w/WGLTcnA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C54ABE333D8;
	Fri, 29 Dec 2023 08:00:25 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/2] netfilter: nf_tables: set transport offset from mac
 header for netdev/egress
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <170383682580.6676.16830645380063126929.git-patchwork-notify@kernel.org>
Date: Fri, 29 Dec 2023 08:00:25 +0000
References: <20231222104205.354606-2-pablo@netfilter.org>
In-Reply-To: <20231222104205.354606-2-pablo@netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 edumazet@google.com, fw@strlen.de

Hello:

This series was applied to netdev/net.git (main)
by Pablo Neira Ayuso <pablo@netfilter.org>:

On Fri, 22 Dec 2023 11:42:04 +0100 you wrote:
> Before this patch, transport offset (pkt->thoff) provides an offset
> relative to the network header. This is fine for the inet families
> because skb->data points to the network header in such case. However,
> from netdev/egress, skb->data points to the mac header (if available),
> thus, pkt->thoff is missing the mac header length.
> 
> Add skb_network_offset() to the transport offset (pkt->thoff) for
> netdev, so transport header mangling works as expected. Adjust payload
> fast eval function to use skb->data now that pkt->thoff provides an
> absolute offset. This explains why users report that matching on
> egress/netdev works but payload mangling does not.
> 
> [...]

Here is the summary with links:
  - [net,1/2] netfilter: nf_tables: set transport offset from mac header for netdev/egress
    https://git.kernel.org/netdev/net/c/0ae8e4cca787
  - [net,2/2] netfilter: nf_tables: skip set commit for deleted/destroyed sets
    https://git.kernel.org/netdev/net/c/7315dc1e122c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


