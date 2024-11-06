Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89FE71D95AA;
	Wed,  6 Nov 2024 02:20:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730859632; cv=none; b=Dmtml51Nrq5M2kKIUoSkiGl5/TQa2y/5pKEbvW00vM+RlsjQss39OxgGxBL1fu1inf32xXrJQMXTBRk1WzNk+rpgB3196WrW5MGjlQRDpIkukpnCKriHiOho5gom6FlDIaudU0NvKfgt+DfpVyzSQOKnTAnv1cdQx3hFdAlJ4NY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730859632; c=relaxed/simple;
	bh=GH/ijA90ACXI9EyWgDudJz9qdmdqn2HPtNQfSCFLVmM=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=ALhpL2vdQoqSGY2eIVBo8ZX/0uGi+J95dhUG1xCNk89scfKw+MBNA55b0525Vg8WReEG82op/PeFhNDsWAnrPI+2eTVHdpj+5nO3piSCYNN/rXO/1BgsMrEjWifQ/bZLUWWLMvQaBK0s2NYCgVrNiEEW2DzFqOH515upK/XiBAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GdXdvaGW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GdXdvaGW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1457BC4CECF;
	Wed,  6 Nov 2024 02:20:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730859632;
	bh=GH/ijA90ACXI9EyWgDudJz9qdmdqn2HPtNQfSCFLVmM=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=GdXdvaGWwX26zZnJEVQ3N0h2sJSLOLzPG3+Zlq8mOtGGQ+H3cExovDd+zRM11G0Si
	 IkwlpWIaM6Df9cDylSXBvBJIUZAi5TM6ZlFW3Umv21uKYWmrnfHkv6osJ2wGWPGvOn
	 sJPofedKViW0DdPVXQLp6RFjLx4B1HfHsAX+qveQDYfNN9vlkX7DvClRQM66qL0k3+
	 40KTS/tWGTqTa3Ukgx+FjaxQU+Ax7dvQlqU5G58ZepuyuWf1PwspUY5JIQNm5peHLz
	 2rATiBhzN6e2JtnYXz34+S9B16qMP6uRsGNORubyg3f57werfKFvbqoy0/Rm7nqmNZ
	 mw/rlvTjIvITQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 33C653809A80;
	Wed,  6 Nov 2024 02:20:42 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] selftests: netfilter: nft_queue.sh: fix warnings
 with socat 1.8.0.0
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <173085964073.771890.13403219362259265718.git-patchwork-notify@kernel.org>
Date: Wed, 06 Nov 2024 02:20:40 +0000
References: <20241104142821.2608-1-fw@strlen.de>
In-Reply-To: <20241104142821.2608-1-fw@strlen.de>
To: Florian Westphal <fw@strlen.de>
Cc: netdev@vger.kernel.org, netfilter-devel@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Mon,  4 Nov 2024 15:28:18 +0100 you wrote:
> Updated to a more recent socat release and saw this:
>  socat E xioopen_ipdgram_listen(): unknown address family 0
>  socat W address is opened in read-write mode but only supports read-only
> 
> First error is avoided via pf=ipv4 option, second one via -u
> (unidirectional) mode.
> 
> [...]

Here is the summary with links:
  - [net-next] selftests: netfilter: nft_queue.sh: fix warnings with socat 1.8.0.0
    https://git.kernel.org/netdev/net-next/c/a84e8c05f583

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


