Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8FE71802B6;
	Tue, 14 May 2024 18:00:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715709636; cv=none; b=gus/o+mpkS0PJennkigNvT36tjexTHTFFUUW6l3XqgQSgCypAmGjYujmbdu6ERrsK/CfcNFAkz82l3jUtDkvXjOJLCLi5oxAnE2oAcJfLKW6xUil70NuHKk6ShUz5PByANeMb4WChrw5+2vDxvH8HWE3G+33ci0UDO8Ifn/4AFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715709636; c=relaxed/simple;
	bh=gWj3fG5ZnY7U44F+K62ZaU89IC+Dfdcn3LBo82zut0g=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=VuASJEpe3bLfotp0kBhGRABi4m1qNSQ16/PVZM7HbHlOdQ1N2nj2L8uIOfXKJyHDy3Q2j+W2+dtYvLSL6Q6byp44fpfpmEbcGGppKkjc71hnecNaEH+ugf5rbGdfxZndXPsdRkD9sgI2EAiUIHJjHzisKM/mCwA9O5Lwn/qYY18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=smzu9orB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="smzu9orB"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5D63BC2BD11;
	Tue, 14 May 2024 18:00:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1715709636;
	bh=gWj3fG5ZnY7U44F+K62ZaU89IC+Dfdcn3LBo82zut0g=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=smzu9orBPiC+x/wxDv7HfvOKKHrKXhGSSC1L3XMfhMjtbWoYW5NHQw+duyrZCLMr0
	 YrFSiCCwOUWC6h+C2RmJ34ZDf1akQG8MOyakkCY5pYctDDyY39Q6gMFdulk6YUAHSq
	 1fXe0il15pWpbKmp1WTIG0GIpJ780HSjAznBLo+X/fpA8XxBZTbDgbl9uMpHbmpvZj
	 6YiRupM3TsW/TYx61/iYeGJwgvk7G3mil1JPn4PnJ9ZVTcCZYRCgeHyUUsAYKRWt6r
	 LGXahcjoijVb2HeVW0kJsqp0o1H03laeqnaiqIM2UX2T406SZHF7f4mevk/T4uF33T
	 pt4DN314rZBdw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 495ABC1614E;
	Tue, 14 May 2024 18:00:36 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] selftests: netfilter: fix packetdrill conntrack
 testcase
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <171570963629.9672.16728319012552942219.git-patchwork-notify@kernel.org>
Date: Tue, 14 May 2024 18:00:36 +0000
References: <20240514144415.11433-1-fw@strlen.de>
In-Reply-To: <20240514144415.11433-1-fw@strlen.de>
To: Florian Westphal <fw@strlen.de>
Cc: netdev@vger.kernel.org, kuba@kernel.org, pablo@netfilter.org,
 netfilter-devel@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 14 May 2024 16:44:09 +0200 you wrote:
> Some versions of conntrack(8) default to ipv4-only, so this needs to request
> ipv6 explicitly, like all other spots already do.
> 
> Fixes: a8a388c2aae4 ("selftests: netfilter: add packetdrill based conntrack tests")
> Reported-by: Jakub Kicinski <kuba@kernel.org>
> Closes: https://lore.kernel.org/netdev/20240513114649.6d764307@kernel.org/
> Signed-off-by: Florian Westphal <fw@strlen.de>
> 
> [...]

Here is the summary with links:
  - [net-next] selftests: netfilter: fix packetdrill conntrack testcase
    https://git.kernel.org/netdev/net-next/c/dc9dfd8ae4b5

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


