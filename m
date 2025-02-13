Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E31928A2D6;
	Thu, 13 Feb 2025 17:50:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739469004; cv=none; b=dwcAmGEhABrxy2yEVqHbhTjkgcD/alwiWLmPMjUZwYKO3v/M5O9wEoeoXBsGmX0777itTDFImnav7zkpfEEwop7iRndOMH9y8C0FCvkAJRFAY3N9SQomESUIrk3/tt6A8Bck97ykSV6DiJhxAQ2HI21s+PHnwy6f7HTGDh8jVyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739469004; c=relaxed/simple;
	bh=GZMSTBr2rpSdNhxqSrf53W6uk2Y9irn1FNBDE035ABI=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=C+7lBy16nx1j0ywvNJ9+ZBEAjiKnrh6+aOcppe4wqM/syFP1ya51rr344XMTDf4bYEs8VmSUyF4Smeb7lJFzfiMrEvz3ToRH31ClljVnFuiGdm0FbJs5FicUJHWJPOUiXoMuT0Z2afKF+//A0VmjTMjjxXQIDLQdMINxm1y6WT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PnB0LNLI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PnB0LNLI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0CBAC4CED1;
	Thu, 13 Feb 2025 17:50:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739469003;
	bh=GZMSTBr2rpSdNhxqSrf53W6uk2Y9irn1FNBDE035ABI=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=PnB0LNLIizyzGRkWwgkeGq9Dgyef9IHsjK2U2t2G5lllj2fBIpPzeoMwG7ojL5udI
	 rofWVxHGrQ2nevOPrnnNU+2Q49st9W1M8Y1hFRIWt1KPtH0fwKuzKjmEVJteC+YJ/a
	 CdIdgm9HFVIa6QPT3T1Az6ReE0N/5aIBXLWKPrDR40RTV33unU3krlvCbUgtpQ5IFc
	 QGhk/HbWTnGPWyE8Kse4We9UMIunHpymAKngw5rVfozMKtJDqPzugykFKIzzEBNLSq
	 /CRBKWWmfMa1/GQAYMBlWvRFN3Q+n2CbdTBRVXPfyN9M/4LtBnRkOfIHTZwOrGCZH1
	 c6AMnDitvkUgg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 34028380CEEF;
	Thu, 13 Feb 2025 17:50:34 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/1] Revert "netfilter: flowtable: teardown flow if cached
 mtu is stale"
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <173946903302.1314369.16377887601628365815.git-patchwork-notify@kernel.org>
Date: Thu, 13 Feb 2025 17:50:33 +0000
References: <20250213100502.3983-2-pablo@netfilter.org>
In-Reply-To: <20250213100502.3983-2-pablo@netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 edumazet@google.com, fw@strlen.de, horms@kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Pablo Neira Ayuso <pablo@netfilter.org>:

On Thu, 13 Feb 2025 11:05:02 +0100 you wrote:
> This reverts commit b8baac3b9c5cc4b261454ff87d75ae8306016ffd.
> 
> IPv4 packets with no DF flag set on result in frequent flow entry
> teardown cycles, this is visible in the network topology that is used in
> the nft_flowtable.sh test.
> 
> nft_flowtable.sh test ocassionally fails reporting that the dscp_fwd
> test sees no packets going through the flowtable path.
> 
> [...]

Here is the summary with links:
  - [net,1/1] Revert "netfilter: flowtable: teardown flow if cached mtu is stale"
    https://git.kernel.org/netdev/net/c/cf56aa8dd263

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


