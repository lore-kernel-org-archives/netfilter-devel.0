Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 805CE3B42C4;
	Wed,  9 Sep 2026 21:01:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788987671; cv=none; b=QtYAmc/HUV7BkkK5+KMtmO72yBfGX/cPoDpIzqJBWbV0LKKj6SLWN+WAqiHHgbps52Wai2UmFjRBk0Cdj56JD3sFYMVv9dytdMtbHn2URfEbr1VU/DM5V0wqlEx7/UznUMdHcRiZWaxmw/Q2HroHFkWR2D9SQVeQQi7uMKIkK5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788987671; c=relaxed/simple;
	bh=X6J+KpfIVlps9C2G5gYMw/H/73R2ExZuXAhaqmNMkeI=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=rxlYo4ErlaC0ZlL/w4As/GLRPV6CvC6Ct2KLSFR7JDsFgvVSCYP7Kb/b0aHd25UOJT9HeQxMevYn1+oAuwS9Ney4vknt9+WG5rLowloxYBxAF17s4xXwsUHV1ZyYxRVGDCnTQEiXAH+CPji10yrFTSjmMvhT6Cyf5ap30SFJP/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Bu+uEvED; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Bu+uEvED"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A3951F00893;
	Wed,  9 Sep 2026 21:01:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788987670;
	bh=cHolC4QZBXMHC+eGeHQBdsftvXg+UmOrME8g4AMvue4=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=Bu+uEvEDW48aaO112/xfDdM0f08dCUKF+NEe+0A5j/yfeCPMJZzFXNCwywmIC8i8T
	 y2kwMKFZ1SIqKbfXrnZoiXCYxxw58F10Zy0PTGmkOdJRKvcZbPy2OgmDdCydHXBVNV
	 DHzE+6uIlGcoinQAaoDWBck6Y/vYNGCjmvWvo9fMYZ2CvG2C9RtRyCVVN4yDbNBUkf
	 O4GPjGDGGB/UhQKZ2h9T15nxK4kC9Z/6/NaTkLegU+KYYOJ35iOOx80H9RSOd66xyR
	 yLDn1l7ODeTrxoAQswsXodYrPL3qluSGBCxJpQqIZDI2RIn5ygRE8zYuVRTGEblo5W
	 PNy/6Gec6yWbA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 5E775380AAFF;
	Wed,  9 Sep 2026 21:00:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/2] selftests: net: use KHDR_INCLUDES in CFLAGS
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <178898760816.1057294.3450681331632331152.git-patchwork-notify@kernel.org>
Date: Wed, 09 Sep 2026 21:00:08 +0000
References: <20260904-net-sft-nf-khdr_includes-v1-0-92455af428e9@kernel.org>
In-Reply-To: <20260904-net-sft-nf-khdr_includes-v1-0-92455af428e9@kernel.org>
To: Matthieu Baerts <matttbe@kernel.org>
Cc: pablo@netfilter.org, fw@strlen.de, phil@nwl.cc, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, horms@kernel.org,
 shuah@kernel.org, dsahern@kernel.org, idosch@nvidia.com, i.maximets@ovn.org,
 netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
 netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 04 Sep 2026 18:13:01 +0200 you wrote:
> KHDR_INCLUDES is typically used to include headers from the kernel
> source directory instead of only relying on the ones from the host: they
> can be missing or outdated. See the issue reported in [1] where users
> have to set USERCFLAGS instead, which shouldn't be needed.
> 
> The kselftest doc [2] recommends assigning KHDR_INCLUDES to CFLAGS in a
> target Makefile. lib.mk will set KHDR_INCLUDES to "-isystem
> $(top_srcdir)/usr/include" if the user didn't set it, e.g. if the kernel
> was built in a different build directory.
> 
> [...]

Here is the summary with links:
  - [net,1/2] selftests: netfilter: use KHDR_INCLUDES in CFLAGS
    https://git.kernel.org/netdev/net-next/c/9a5d20a88afb
  - [net,2/2] selftests: forwarding: use KHDR_INCLUDES in CFLAGS
    https://git.kernel.org/netdev/net-next/c/f1f4394a8bb4

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


