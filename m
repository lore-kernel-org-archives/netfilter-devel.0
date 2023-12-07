Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9E214B5B4;
	Thu,  7 Dec 2023 18:00:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H4sAwZ4F"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2AEECC433C9;
	Thu,  7 Dec 2023 18:00:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701972027;
	bh=BNgG2XcLw8MDkFfa2rSgbI3xP88YKF1v7QhBayKpcPo=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=H4sAwZ4FeEtxNan7Jo1Rq3udgJdxS8Ps5UqsPC0AfcFrmxRkuSYDO1zqCyCuNBQSR
	 UQqKdaYMrj2fXB4kd5ysZG+UDNYQ3plGf2zGn2DbDHEJdcOWKxPp0wi+bylp0zIFYq
	 TTVt63AUrRYksiWu4nT5RJ9zLeFiksSFsDG7tXgiCdbxWMLnI9SNeuuM0tggVi8hvu
	 JGFdpdRYFjCdv5++WjVm6oEB4OqQOW4B+zBPWaksHtZ4Rx/2jZ75i6JzBYqd7akkmt
	 uAPEjRjojVTjL3B9QBRBItb4Ou5dbPMnMCpOllMCEDZyq9F42nXyNpcJkXp+prH7Lv
	 xeJBF/+kB3K8Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 10891C43170;
	Thu,  7 Dec 2023 18:00:27 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/6] netfilter: bpf: fix bad registration on nf_defrag
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <170197202706.7796.7312229960355473959.git-patchwork-notify@kernel.org>
Date: Thu, 07 Dec 2023 18:00:27 +0000
References: <20231206180357.959930-2-pablo@netfilter.org>
In-Reply-To: <20231206180357.959930-2-pablo@netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 edumazet@google.com, fw@strlen.de

Hello:

This series was applied to netdev/net.git (main)
by Pablo Neira Ayuso <pablo@netfilter.org>:

On Wed,  6 Dec 2023 19:03:52 +0100 you wrote:
> From: "D. Wythe" <alibuda@linux.alibaba.com>
> 
> We should pass a pointer to global_hook to the get_proto_defrag_hook()
> instead of its value, since the passed value won't be updated even if
> the request module was loaded successfully.
> 
> Log:
> 
> [...]

Here is the summary with links:
  - [net,1/6] netfilter: bpf: fix bad registration on nf_defrag
    https://git.kernel.org/netdev/net/c/1834d62ae885
  - [net,2/6] netfilter: nft_set_pipapo: skip inactive elements during set walk
    https://git.kernel.org/netdev/net/c/317eb9685095
  - [net,3/6] netfilter: nf_tables: fix 'exist' matching on bigendian arches
    https://git.kernel.org/netdev/net/c/63331e37fb22
  - [net,4/6] netfilter: nf_tables: bail out on mismatching dynset and set expressions
    https://git.kernel.org/netdev/net/c/3701cd390fd7
  - [net,5/6] netfilter: nf_tables: validate family when identifying table via handle
    https://git.kernel.org/netdev/net/c/f6e1532a2697
  - [net,6/6] netfilter: xt_owner: Fix for unsafe access of sk->sk_socket
    https://git.kernel.org/netdev/net/c/7ae836a3d630

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


