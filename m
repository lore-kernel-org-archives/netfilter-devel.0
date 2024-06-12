Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E685E5464A;
	Wed, 12 Jun 2024 23:40:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718235632; cv=none; b=bJU84NUUvYS2zH8bOLSlSQRkcVmsVFgLqeVxHYXsehdnfCORaFVdXuv2QU20d/N5k/DqSlC7Qgqh5MSUaEXj3H7/gOvxgP7dpmVkafAgRWy+Wt5TMCtN4Pt5Qq821kJHKpFoAZOSGPETu4iK8cznpDyYpxcd6uoNfQKHmVYrsdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718235632; c=relaxed/simple;
	bh=u/1ZhRoSK6DYugjITnqFLcvkbHf/Fl9cjvLm/mlltyA=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=Xl3xXklCviK/LJTTm//gc7S7YIjAVfn9i4FHnTzfdGLe/82xFdMq3/AKhjv+pnuyTLKR0E7img6BXcSJwBy8sRXdNjaWsg41q7F8Qv0hLqkiz0EFLOAkVCLsk7Z7avLi+5Uw3hXdiwy7Q/pz763XjMMAFmV5fjsYwBzHugFQSdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EfxZkYl/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EfxZkYl/"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 640B5C32786;
	Wed, 12 Jun 2024 23:40:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718235631;
	bh=u/1ZhRoSK6DYugjITnqFLcvkbHf/Fl9cjvLm/mlltyA=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=EfxZkYl/kiBICSiQ3HviRkGJVZjIlMqkxkndsYJd+XZbwmKOdfbFurh3PW2OiehhE
	 z8sA86nJEz0ctHOGLnraa/DTIveCgt31RKOLveOjK0Rtswj3oD/4wt9u3/xFOcIK1V
	 Weu4Asli+4jB4j2YxLZtTx+Udj61PICe7ymUTv48hUE/cKAqtRYHXJ7zYjDDfpqsEu
	 R8oGLCuwFzwEsRiWd9aJ4y0kK7BKlgyhsbByXw0usAMTuSfdniGkSYeQVQAxr4Ugu7
	 FqDJ/EurvI7DVJHz+L4BNstYGDcL/rWw314kzSvuE5PTVfVJCt1awzSiZWnVBHD05I
	 9ts2oCZIRHSXA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 5277EC43616;
	Wed, 12 Jun 2024 23:40:31 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/3] netfilter: nft_inner: validate mandatory meta and
 payload
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <171823563133.20930.12583380415171865572.git-patchwork-notify@kernel.org>
Date: Wed, 12 Jun 2024 23:40:31 +0000
References: <20240611220323.413713-2-pablo@netfilter.org>
In-Reply-To: <20240611220323.413713-2-pablo@netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 edumazet@google.com, fw@strlen.de

Hello:

This series was applied to netdev/net.git (main)
by Pablo Neira Ayuso <pablo@netfilter.org>:

On Wed, 12 Jun 2024 00:03:21 +0200 you wrote:
> From: Davide Ornaghi <d.ornaghi97@gmail.com>
> 
> Check for mandatory netlink attributes in payload and meta expression
> when used embedded from the inner expression, otherwise NULL pointer
> dereference is possible from userspace.
> 
> Fixes: a150d122b6bd ("netfilter: nft_meta: add inner match support")
> Fixes: 3a07327d10a0 ("netfilter: nft_inner: support for inner tunnel header matching")
> Signed-off-by: Davide Ornaghi <d.ornaghi97@gmail.com>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> 
> [...]

Here is the summary with links:
  - [net,1/3] netfilter: nft_inner: validate mandatory meta and payload
    https://git.kernel.org/netdev/net/c/c4ab9da85b9d
  - [net,2/3] netfilter: ipset: Fix race between namespace cleanup and gc in the list:set type
    https://git.kernel.org/netdev/net/c/4e7aaa6b82d6
  - [net,3/3] netfilter: Use flowlabel flow key when re-routing mangled packets
    https://git.kernel.org/netdev/net/c/6f8f132cc7ba

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


