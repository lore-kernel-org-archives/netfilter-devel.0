Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BB9D37F8BB;
	Mon, 19 Jan 2026 14:22:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768832576; cv=none; b=Rv35RJMHAsKKkinp6JvWQTFcCAh/YiVApV9FYY9Im60TtisyL+wEmB0HUSSsGSF//gF3z1BmfVFXz38L5xfxdzqmiDp4OVv/gzq05NOAygidicfvm2ci55aIlXwCTphbl/3clmhwm4p8nzogw41Fh4GO3FRKECxyeAMwScSkNxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768832576; c=relaxed/simple;
	bh=ECIb465qm6AbJk6DuW36tEygSGmQ3RAq9oydfNAzbG4=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=FALzMTbm0Y6GFxvXCVd60WwbWbT5VYg9wV4ULqSiTS0jjaO3nEvS91Qdki3cjFixy8W9Brsr2XDza3/7pecP4/lbLzUa2ADQ+KEwyNjB2y0y6KbbU4JncGNdUrUbFzZ7/4BxEbWyKOKzlZ3vU7egjJzqiYDAxVPX7lMxH+y4CxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Fd7gEMKh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Fd7gEMKh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9486C116C6;
	Mon, 19 Jan 2026 14:22:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768832576;
	bh=ECIb465qm6AbJk6DuW36tEygSGmQ3RAq9oydfNAzbG4=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=Fd7gEMKhdgXRtU8KShud49/bCBi0Abx7X2/MKpg4ypjCGNShkZcL8QHh5oG75qSDC
	 wXMzTV019SMUhnQl1OhtxpffUgtXPAsTZ8xTPcDHW+jf7Xqa9vnQ31iz4dUxz/X6lK
	 YSPDLh5I2/4W2UnTjPrWXowwsTz63/qrijT7RAh7W9PMpgUyVnAhxXTZdXI0eiIRfc
	 ooc8wbQ3xP1ENkeiY/NOHB94apZqL5lzLVVp3fn7uZZ2m80eSP712vURGpemZ8z0V8
	 4QVDbExtfcVoWVjsojmCM5F5wdgHtLtUm2T1yU4JCoyIrl2IqVcvEObShSjFSXa1Jl
	 03dtp0Y/iqzzQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id F2C803A55FAF;
	Mon, 19 Jan 2026 14:19:26 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 0/3] uapi: Use UAPI definitions of INT_MAX and INT_MIN
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <176883236571.1426077.1683546457075624017.git-patchwork-notify@kernel.org>
Date: Mon, 19 Jan 2026 14:19:25 +0000
References: <20260113-uapi-limits-v2-0-93c20f4b2c1a@linutronix.de>
In-Reply-To: <20260113-uapi-limits-v2-0-93c20f4b2c1a@linutronix.de>
To: =?utf-8?q?Thomas_Wei=C3=9Fschuh_=3Cthomas=2Eweissschuh=40linutronix=2Ede=3E?=@aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org
Cc: davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
 pabeni@redhat.com, horms@kernel.org, andrew@lunn.ch, pablo@netfilter.org,
 kadlec@netfilter.org, fw@strlen.de, phil@nwl.cc, arnd@arndb.de,
 linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
 netfilter-devel@vger.kernel.org, coreteam@netfilter.org

Hello:

This series was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 13 Jan 2026 08:44:16 +0100 you wrote:
> Using <limits.h> to gain access to INT_MAX and INT_MIN introduces a
> dependency on a libc, which UAPI headers should not do.
> 
> Introduce and use equivalent UAPI constants.
> 
> Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
> 
> [...]

Here is the summary with links:
  - [v2,1/3] uapi: add INT_MAX and INT_MIN constants
    https://git.kernel.org/netdev/net-next/c/ca9d74eb5f6a
  - [v2,2/3] ethtool: uapi: Use UAPI definition of INT_MAX
    https://git.kernel.org/netdev/net-next/c/a8a11e5237ae
  - [v2,3/3] netfilter: uapi: Use UAPI definition of INT_MAX and INT_MIN
    https://git.kernel.org/netdev/net-next/c/0b3877bec78b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


