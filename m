Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DF6C14D281;
	Thu, 25 Apr 2024 16:20:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714062032; cv=none; b=QSHVWAg7xX8dFc1es4cnl5XHljJXWJU3v/QMk0x1WT/sZtJLvBYj7Buc+DWM0VpOuA3ew/FhcMtwrmmQFqYDL7tDsn3pI5B49I4dl1+3QFX75bbMN8ytCqJNKUmnGEqtrQVKZW4oHE486Nk9AumWBVVaf+e7d38r4Ct6yA5w+T4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714062032; c=relaxed/simple;
	bh=R0mxdShhTDL7VTLtZ6+utPzT0eRF3gUyyl7/6aAEuos=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=p4SLCa3D1CEj5g+v4NecL9Mee/EvzwoUXTdkqZ2GyhQFw4DJqkMQ8wHxRilyUAddwUxkI0Tw6YFDaxgQs/zwwUrYxe9YrjUJ6G9esK+0GeHFaK3KT8b422sAMrpt5M69EeN2fzK8DiWWTDlTuvq0lH0eGGSWOGbjpayFHnm305M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tXybKwWG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tXybKwWG"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 42D18C2BD10;
	Thu, 25 Apr 2024 16:20:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1714062032;
	bh=R0mxdShhTDL7VTLtZ6+utPzT0eRF3gUyyl7/6aAEuos=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=tXybKwWGbS97h34is7Xd45F008tSWBSfV0XpUROnwWeFJ2lyR/87hdzZdnNY9CTdZ
	 sEtf/D/UJ4tCbIki8f39E8m+QI4vbVc1tfRbn0apyiVVxaDl9gQZ1eTlZizUFts78r
	 zrXa5ZwECRDdKSdrweJUtj7CoL/tcm6E7U/Hyi27J33xVfkMbi7FdZDJVjYtGRiSqv
	 dhyaONozg4uFTZzgnqkWixcb5mTDqhPCeOwjHjqKQNBBUtG/AowHlaqbMJT48zKbCc
	 tA/mpcn1YJZQ1cZZW2as7epkxa78Cdt4sdMS3u0KdGfYDMO1c0I6EDvlwPbDkwjlA9
	 MtVnPRPiG7X1Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 27EA0C595CE;
	Thu, 25 Apr 2024 16:20:32 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net-next] tools: testing: selftests: prefer TEST_PROGS for
 conntrack_dump_flush
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <171406203215.4535.17689780559788049960.git-patchwork-notify@kernel.org>
Date: Thu, 25 Apr 2024 16:20:32 +0000
References: <20240424095824.5555-1-fw@strlen.de>
In-Reply-To: <20240424095824.5555-1-fw@strlen.de>
To: Florian Westphal <fw@strlen.de>
Cc: netdev@vger.kernel.org, pabeni@redhat.com, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, netfilter-devel@vger.kernel.org,
 pablo@netfilter.org

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 24 Apr 2024 11:58:20 +0200 you wrote:
> Currently conntrack_dump_flush test program always runs when passing
> TEST_PROGS argument:
> 
> % make -C tools/testing/selftests TARGETS=net/netfilter \
>  TEST_PROGS=conntrack_ipip_mtu.sh run_tests
> make: Entering [..]
> TAP version 13
> 1..2 [..]
>   selftests: net/netfilter: conntrack_dump_flush [..]
> 
> [...]

Here is the summary with links:
  - [v2,net-next] tools: testing: selftests: prefer TEST_PROGS for conntrack_dump_flush
    https://git.kernel.org/netdev/net-next/c/a9e59f712582

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


