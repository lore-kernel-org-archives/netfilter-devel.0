Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF58E24469C;
	Wed, 28 May 2025 07:52:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748418760; cv=none; b=oDEF75YIh0m616Emobx/iaTNA3fr5UEDc4Uzyf4iLndjbvMATeAQjh/AKiNDa2me0/2k/RN34w+3NTR+HCkwzK8DyCbLIzGS3S5Arsr0XEUtoDfuvcwMv3noLW9rud+s8sva/w4AZER/v7Gadv8O6YY2xHuPnJ3+jaxzoD18yLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748418760; c=relaxed/simple;
	bh=rt+7JeKmps68fMndKUlV1+BUdpX6FKpnBJ3SldOugZ0=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=QCQiM46ZfD4n1LRZfPOIFvDbiyeSjZjofb+qBiNZSHYwn6G0gogVTtdxnszzTnQRM623YeF+ibjcfy/3zzXjEJKlmrJzk9EqLc29z2Vn/NYxUNdFI7ky+R/NnSwhrqDY7vnDjO1C4jTiw3b0iak0DStVdyJ0oGIwP6cbVL4uMfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sKWxF4kP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sKWxF4kP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2312FC4CEE7;
	Wed, 28 May 2025 07:52:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748418760;
	bh=rt+7JeKmps68fMndKUlV1+BUdpX6FKpnBJ3SldOugZ0=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=sKWxF4kPBysp6z9SIsIfDiIxyLKPUslSs8qIcLNZlf+R/UYp8wizEJ2BJ8hqW6cn8
	 CuWAQ4++DqFkQ07texPmQW2R0wcTH0kID97ufsbDw828xZHWEibITUGFFFDwXnV6D7
	 aul3Do+OQ1ak8/yD7UdD+t2c1V+RI6rxbpvUtxUMvt0EP4ieB+SMIuy4mWs4bTB5td
	 O4u/PsBs7DdCCkYU1/cNKJ2NEnd9C3teOFMqrPFIbLe+A9DRGaQEoSFt2wubcIrSY8
	 uhO5xRy6pSp8CFDQ0amZ4ccNJRtgMISdza1gQE2SKnWe/cB7aTydKBGkuFxF8SENxf
	 HzyVXOhs9LTtQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 7107039F1DE4;
	Wed, 28 May 2025 07:53:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next PATCH] selftests: netfilter: Fix skip of wildcard interface
 test
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <174841879424.2284365.14495950610695273901.git-patchwork-notify@kernel.org>
Date: Wed, 28 May 2025 07:53:14 +0000
References: <20250527094117.18589-1-phil@nwl.cc>
In-Reply-To: <20250527094117.18589-1-phil@nwl.cc>
To: Phil Sutter <phil@nwl.cc>
Cc: pabeni@redhat.com, pablo@netfilter.org, netfilter-devel@vger.kernel.org,
 davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
 edumazet@google.com, fw@strlen.de, horms@kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by Paolo Abeni <pabeni@redhat.com>:

On Tue, 27 May 2025 11:41:17 +0200 you wrote:
> The script is supposed to skip wildcard interface testing if unsupported
> by the host's nft tool. The failing check caused script abort due to
> 'set -e' though. Fix this by running the potentially failing nft command
> inside the if-conditional pipe.
> 
> Fixes: 73db1b5dab6f ("selftests: netfilter: Torture nftables netdev hooks")
> Signed-off-by: Phil Sutter <phil@nwl.cc>
> 
> [...]

Here is the summary with links:
  - [net-next] selftests: netfilter: Fix skip of wildcard interface test
    https://git.kernel.org/netdev/net-next/c/6da5f1b4b4a0

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


