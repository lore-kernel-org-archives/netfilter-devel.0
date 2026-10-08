Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C5A74DDB31;
	Thu,  8 Oct 2026 18:40:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791484812; cv=none; b=kol+ZRq88GozVRbRFZIMuN6JuW7q6GVlXxDFofIxtfCSRGPjeQWDyZVVa6DgpDwYIfbCMrT9h9W5HWAoVVr6WBqa49v9Syro82CTe4i4tWgGr1sGnzP5Tib84w2qCKyVntSQfX0hEUo4t8V3VxbGf34ipf4V4V1WogbjcBNLqoc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791484812; c=relaxed/simple;
	bh=lHEfRP0X3S/XPTmII8KvHZ2dsrEM/XJZDkdisO/QJZQ=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=CzRubkpDnEtFLdbSW+7eCHgDTVNkwB+CxNHiZxWW1OS0monAwjsZG1epI1efTzY3VTYctqpL6x0Tsc3TJx/MyKuWB9Ur4X8dP5PB5b9Sz887pyZWOtaroYibw4Kmtm7dZjGciICqbj94WRpv5HuyWZEGxTAvU3aSf/gQQbRAgCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MWwuDYT+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MWwuDYT+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CAAB1F0089D;
	Thu,  8 Oct 2026 18:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791484811;
	bh=7Rf+eyYaG9U/bMmoktQ3BwZa9LqnSqguhQVu3gdpBEw=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=MWwuDYT+CG8wkzfbibtXBdmSO/dqcwNc+f/L2T/6SVhawzAc/l/XfiRJr0tKWSXDp
	 KXTOQtiBZ1RJfdtOBIXH920IdhPyXABRXPRS/ubUZ6cJGno8P4DK2EXH0Fcb4wvmPe
	 iSyNmhVipj49Xr3LK7YGwEHvsOEGiHWwNafexmced6UGxMNOzxaCiIVhTwW3tW/vCT
	 PE3NNDl49odCjxFJVXXGw92mvFSOF0yOECz22QB0Aae5Zm3ECSSty/LBom27gM/6dD
	 W9f6hobjll1aDM51rxps2Lz0jxA/zJYkvZ4eT+jHcyHLtmY3SmETbtTNlXsEe3yBrZ
	 qMhGBebQQQztw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id F1750380CEC8;
	Thu,  8 Oct 2026 18:40:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] ipv4: validate checksum_start before completing
 checksum
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <179148480952.386807.5254564638914693441.git-patchwork-notify@kernel.org>
Date: Thu, 08 Oct 2026 18:40:09 +0000
References: 
 <0a012b4923e189c4c593ef4f471e5ff0edbe9030.1791412497.git.mst@redhat.com>
In-Reply-To: 
 <0a012b4923e189c4c593ef4f471e5ff0edbe9030.1791412497.git.mst@redhat.com>
To: Michael S. Tsirkin <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, dsahern@kernel.org, idosch@nvidia.com,
 davem@davemloft.net, edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
 horms@kernel.org, pablo@netfilter.org, fw@strlen.de, phil@nwl.cc,
 razor@blackwall.org, steffen.klassert@secunet.com,
 herbert@gondor.apana.org.au, willemdebruijn.kernel@gmail.com,
 netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
 coreteam@netfilter.org, bridge@lists.linux.dev

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 7 Oct 2026 18:42:49 -0400 you wrote:
> If a packet with bad checksum metadata gets into the ipv4 stack,
> skb_checksum_help can corrupt the network header and cause a bunch of
> mischief.
> 
> This was discovered and reported by Paulos, and has been reporoduced
> by others independently since.
> 
> [...]

Here is the summary with links:
  - [net] ipv4: validate checksum_start before completing checksum
    https://git.kernel.org/netdev/net/c/6785011f8b16

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


