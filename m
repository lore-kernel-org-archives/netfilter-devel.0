Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F2311EF082;
	Thu, 30 Jan 2025 17:10:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738257012; cv=none; b=Q5wR9Vatm3B9chMw6qv5Ql2+X1K/Vl+PVD50zNK/sXpkA5r8IKfMKU35RLMPYY3eNFQ4rFqAMM/W646yjFUxdA0aExUoozXH0VPbhllEt1qt3r/d8scjpZ9xzonfW1qV//YD4b7dm5SODJrv6Oc8h7b4a9WJNnDqXVbLzbTs79k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738257012; c=relaxed/simple;
	bh=qMa9+69Qnz4QJkdoaxVsPsN973FZlTe+3qF2RAzybKs=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=YwALvW4vPEzj3a/Q2ebPav9gUnTW29OxMGRa2Mfo2o4qPx0X27hq1EHjAFdAdPgnlr9f/aNdop6m4vv8jPiP42/pvOsK0ahOvBH5OYz3rMfmpMVag295nzVZXQ/4AmuJosXi3KrvI6W0yr6+HFy9UEkRyC+dBkMG0PNjI+CM0Dc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Eo+j/cj+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Eo+j/cj+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E799BC4CEE2;
	Thu, 30 Jan 2025 17:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738257011;
	bh=qMa9+69Qnz4QJkdoaxVsPsN973FZlTe+3qF2RAzybKs=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=Eo+j/cj+OAjzCh6aAROi70K6+6eE4P3D1r3gTM38l1Z1kt3AhKNKEvScx8QKMBSIH
	 o3L84wgqLOAabwFXE+dhVkP764TZOMR181HfPo7JYhtIqHychoav0Dk5pb2F+RPg/O
	 mQUIPM3gstj4F7a9Tsy9VJGn+t94nntqJkg0vewC6YEpB2CTN5eTSumuMyGXPRAYDD
	 XbwpvKviv3Gt0OYe38ylKt40RWcoIXYCx36k8vzS9REbwxqERGLylfIoYYHPkp6EvJ
	 JLKmceJsRzDPngu5iwNw0A4ok5O6AJr88UuQm1d3Vku+hGc2+TjchKSB2ExxPes2nA
	 fVr/KY2/GIlqA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 711FE380AA66;
	Thu, 30 Jan 2025 17:10:39 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/1] netfilter: nf_tables: reject mismatching sum of
 field_len with set key length
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <173825703824.1021356.11128421779204214286.git-patchwork-notify@kernel.org>
Date: Thu, 30 Jan 2025 17:10:38 +0000
References: <20250130113307.2327470-2-pablo@netfilter.org>
In-Reply-To: <20250130113307.2327470-2-pablo@netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 edumazet@google.com, fw@strlen.de, horms@kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Pablo Neira Ayuso <pablo@netfilter.org>:

On Thu, 30 Jan 2025 12:33:07 +0100 you wrote:
> The field length description provides the length of each separated key
> field in the concatenation, each field gets rounded up to 32-bits to
> calculate the pipapo rule width from pipapo_init(). The set key length
> provides the total size of the key aligned to 32-bits.
> 
> Register-based arithmetics still allows for combining mismatching set
> key length and field length description, eg. set key length 10 and field
> description [ 5, 4 ] leading to pipapo width of 12.
> 
> [...]

Here is the summary with links:
  - [net,1/1] netfilter: nf_tables: reject mismatching sum of field_len with set key length
    https://git.kernel.org/netdev/net/c/1b9335a8000f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


