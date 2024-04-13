Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C76C6205E38;
	Sat, 13 Apr 2024 01:00:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712970032; cv=none; b=n9Ai2GS3XqMga6AIUTj84gudVOkgiooU4l/mm2/nYMYNm1/zHSqvqVBYFbRafr5NIdfuePyqN6YHaO0jK/OuAHXnaM+welQ1tr/rMTqi8UdiELGBprS/hedi+3q1BuZdQGiRTEkvi0BUuQuCLXVenNAWq/wCVGOq6hy/9Em2gOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712970032; c=relaxed/simple;
	bh=Ls4qzAKKyQ/OryboE/moaW4RK41APgjuaKKx3B2Wh5g=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=Zm31o0+lLDXtpS9T4zw1/fDK/KmdZQEXyY2UdBSWrN78xJjNVe2R+v6IE9IDsdtdRxGja1FdhqVJKoNTgZBO1DokBCGlDU9nAhlhIoGsO81QJfi46nW+nD+tw+Ia24MQ+baGbGDcv+Mi1tVQBhusHl0QUL6lqCpIntQNyIAl8oM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=el4v1UiB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="el4v1UiB"
Received: by smtp.kernel.org (Postfix) with ESMTPS id AB158C2BD10;
	Sat, 13 Apr 2024 01:00:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712970031;
	bh=Ls4qzAKKyQ/OryboE/moaW4RK41APgjuaKKx3B2Wh5g=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=el4v1UiBDMP0FLr4U8lPeyvqBmreqYfggiOEqH/XgKSLoP56xQ5K80wk/L2wvyFgg
	 Ese3w+ihnPx36LzpGZIy8kcTGStH2bDmOAbEI7jt0s+civfYcXpIGayIcVKQI693+J
	 YMQYwEE8P56Ns/Uv5/PqTaPDXBrMaqb6/GIvSC0o+73Dw7Wb5U1ptSlh/y5EdJc1Jz
	 vvxjcaiAoEGDoG3DIIj5036E5ViDg7ABLeL3K7S1zYjFQhA5JM8MUJHeUYX8rcAimt
	 RSjlcbbbHdWLmdL3cLhNSVMEfLlRooRCeWx2cyfZGDotjReqv0CcLHVuQlOEfA0yQU
	 m1fAMNqr/VVtg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 9634DDF7859;
	Sat, 13 Apr 2024 01:00:31 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 00/15] selftests: move netfilter tests to net
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <171297003161.29113.2369096057617956570.git-patchwork-notify@kernel.org>
Date: Sat, 13 Apr 2024 01:00:31 +0000
References: <20240411233624.8129-1-fw@strlen.de>
In-Reply-To: <20240411233624.8129-1-fw@strlen.de>
To: Florian Westphal <fw@strlen.de>
Cc: netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
 pabeni@redhat.com, davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
 pablo@netfilter.org

Hello:

This series was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 12 Apr 2024 01:36:05 +0200 you wrote:
> First patch in this series moves selftests/netfilter/
> to selftests/net/netfilter/.
> 
> Passing this via net-next rather than nf-next for this reason.
> 
> Main motivation is that a lot of these scripts only work on my old
> development VM, I hope that placing this in net/ will get these
> tests to get run in more regular intervals (and tests get more robust).
> 
> [...]

Here is the summary with links:
  - [net-next,01/15] selftests: netfilter: move to net subdir
    https://git.kernel.org/netdev/net-next/c/3f189349e52a
  - [net-next,02/15] selftests: netfilter: bridge_brouter.sh: move to lib.sh infra
    https://git.kernel.org/netdev/net-next/c/94831b130ded
  - [net-next,03/15] selftests: netfilter: br_netfilter.sh: move to lib.sh infra
    https://git.kernel.org/netdev/net-next/c/1286e106dd6f
  - [net-next,04/15] selftests: netfilter: conntrack_icmp_related.sh: move to lib.sh infra
    https://git.kernel.org/netdev/net-next/c/96f6c27371a9
  - [net-next,05/15] selftests: netfilter: conntrack_tcp_unreplied.sh: move to lib.sh infra
    https://git.kernel.org/netdev/net-next/c/6f864d391b29
  - [net-next,06/15] selftests: netfilter: conntrack_sctp_collision.sh: move to lib.sh infra
    https://git.kernel.org/netdev/net-next/c/9785517a2245
  - [net-next,07/15] selftests: netfilter: conntrack_vrf.sh: move to lib.sh infra
    https://git.kernel.org/netdev/net-next/c/954398b4d837
  - [net-next,08/15] selftests: netfilter: conntrack_ipip_mtu.sh" move to lib.sh infra
    https://git.kernel.org/netdev/net-next/c/0413156eec28
  - [net-next,09/15] selftests: netfilter: place checktool helper in lib.sh
    https://git.kernel.org/netdev/net-next/c/10e2ed3fcdf4
  - [net-next,10/15] selftests: netfilter: ipvs.sh: move to lib.sh infra
    https://git.kernel.org/netdev/net-next/c/87ce7d79075f
  - [net-next,11/15] selftests: netfilter: nf_nat_edemux.sh: move to lib.sh infra
    https://git.kernel.org/netdev/net-next/c/f51fe0256135
  - [net-next,12/15] selftests: netfilter: nft_conntrack_helper.sh: test to lib.sh infra
    https://git.kernel.org/netdev/net-next/c/fa03bb7c8c01
  - [net-next,13/15] selftests: netfilter: nft_fib.sh: move to lib.sh infra
    https://git.kernel.org/netdev/net-next/c/6bc0709bf111
  - [net-next,14/15] selftests: netfilter: nft_flowtable.sh: move test to lib.sh infra
    https://git.kernel.org/netdev/net-next/c/53e9426204a0
  - [net-next,15/15] selftests: netfilter: nft_nat.sh: move to lib.sh infra
    https://git.kernel.org/netdev/net-next/c/49af681bcab4

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


