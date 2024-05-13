Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5991E83CD8;
	Mon, 13 May 2024 21:50:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715637031; cv=none; b=k4GS/KnZPaqKDHpB5J2YTfvz8ME72j3FgB/LihzDe9BkPMle/GwK3PDkajFhkC86SAtQBfLs6Nfzunq4A9d8fRtrcGxTILz/cGX1Wr2d7ickcGTQDhmIiU9CyjedLElIadFThSAEPxmuu5Fp9COl4pZZopyYjl2lxCB0IPFvKb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715637031; c=relaxed/simple;
	bh=/v94wCrI5Tt9uoU+Je782os68BLsBtrCi4hB4GKppGg=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=FMy613OqHu1qWQzCne3yJayf9E2+Kshvpixo6xD4ASnQ9ewu7XFr/TIoISX7l4Xn9TrJK/uQvAxHovxO8LOZrCrCXiEYXcYSS6AhugoFO00k/L1xZPKymgyJ5cImZrROMyKwzZCdmV2BuDCXZcyVkNY+cUUeRnmXP1my+SYisd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oMykfLG7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oMykfLG7"
Received: by smtp.kernel.org (Postfix) with ESMTPS id D5CCBC4AF09;
	Mon, 13 May 2024 21:50:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1715637030;
	bh=/v94wCrI5Tt9uoU+Je782os68BLsBtrCi4hB4GKppGg=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=oMykfLG7R0bIQpPLGUFIeNvpzB6hyIwSB8t8P8ZokkJe2l+PheXP9FCZdUoq3JaWu
	 txOI89oOG3IxdZQ40MsaM4fO/M+mKNab8d28n+mb/ZSOIjD75SAWz6QBbO60LmdK+I
	 BS/qBve0X3pe1hVeGBV0UcFLpxpzMQcj2loS4VQOblyamUzQ3JVCB6wd5sC6DNKMPO
	 jfsis7StpoGmAv1eFOHrmuazigeD7mJ85JlZXlMtE1Jv61++Otkuyyze4FYtXJCfZc
	 6a2SGsfgfP5O9aD8S9W9/iLBRSD8TFe2AeWwQi5CNQ9le/iDGGdAHCGR3s0Ci6JP03
	 VEQse3CPCJHjQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id BB0A4C43443;
	Mon, 13 May 2024 21:50:30 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] selftests: netfilter: nft_flowtable.sh: bump socat
 timeout to 1m
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <171563703076.25518.10933025249444977806.git-patchwork-notify@kernel.org>
Date: Mon, 13 May 2024 21:50:30 +0000
References: <20240511064814.561525-1-fw@strlen.de>
In-Reply-To: <20240511064814.561525-1-fw@strlen.de>
To: Florian Westphal <fw@strlen.de>
Cc: netdev@vger.kernel.org, kuba@kernel.org, netfilter-devel@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Sat, 11 May 2024 08:48:03 +0200 you wrote:
> Now that this test runs in netdev CI it looks like 10s isn't enough
> for debug kernels:
>   selftests: net/netfilter: nft_flowtable.sh
>   2024/05/10 20:33:08 socat[12204] E write(7, 0x563feb16a000, 8192): Broken pipe
>   FAIL: file mismatch for ns1 -> ns2
>   -rw------- 1 root root 37345280 May 10 20:32 /tmp/tmp.Am0yEHhNqI
>  ...
> 
> [...]

Here is the summary with links:
  - [net-next] selftests: netfilter: nft_flowtable.sh: bump socat timeout to 1m
    https://git.kernel.org/netdev/net-next/c/5fcc17dfe05e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


