Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D6BD19ADBF;
	Tue, 22 Oct 2024 10:50:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729594225; cv=none; b=I7ZG4CdJ7ACQijeKbUKudACHvk2iH+zO6eox+i+QchwRvia+S7vW+mo6SrT8XCAymf4RDe4N/SgtZJ/OILnuVmtXnbpoTb6lRD+2tV34f0VEWTx6HE4B1vCTRsWF7/wfUunp0ZaIl/LVRzEztgF8cdqAmdrkV1MOQ1xQ7oZhLT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729594225; c=relaxed/simple;
	bh=gtai55HkwxYZfoMnSDnSAsj/PHQAOWKTEW7Fma1XVbM=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=e+HdBwetIPtQMIEcWtI9GRBa4P1KaImTiSlbCuvcjmcEd6hNfSF5U0hX9iMGemNdZyrB3hVzr73+l902MlkMyxm5c6AoRw1wzq+C3b3rF0SfdCUxJPe2joykPcAScFSKL7xqqZq3mS5uPkYxOmeWPT/W1+DmxxtiP2Xq9P5JRxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kR43Yr4K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kR43Yr4K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D9D4C4CEEA;
	Tue, 22 Oct 2024 10:50:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729594225;
	bh=gtai55HkwxYZfoMnSDnSAsj/PHQAOWKTEW7Fma1XVbM=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=kR43Yr4KSeVBQSLIxcIo9ziVgB4UMc610uI/cnSqxyEJorWIGbCYEkBigsddnzDdb
	 03GjVPHsu1Dg0S3gtG4SyXK8xKvTlhEUMt36isemJe780GQEga2Vax7+QqLqlcvzxc
	 kKACiB2c6zfZhDWcL3jiM/Gm0/PebPDptYvW9oF7q606CO1HznJASH9vTF48alwAsV
	 B/59BiqamMb2ZJirvECBAYWGEiuiO/iTjyUgf50SBwVv/1avIR2h6lxT2NcHFUZm5N
	 PMjRZ2Lef4J1vgtzy8iG15Xm6LhjU7xsOojme6TPL50BqoE68DArCwXGJv2DXgQbLo
	 hi0XKdjrHLFVg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 70B2D3809A8A;
	Tue, 22 Oct 2024 10:50:32 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/1] Netfilter fixes for net
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <172959423123.927462.18180587610240591445.git-patchwork-notify@kernel.org>
Date: Tue, 22 Oct 2024 10:50:31 +0000
References: <20241017123413.4306-1-pablo@netfilter.org>
In-Reply-To: <20241017123413.4306-1-pablo@netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 edumazet@google.com, fw@strlen.de

Hello:

This patch was applied to netdev/net.git (main)
by Pablo Neira Ayuso <pablo@netfilter.org>:

On Thu, 17 Oct 2024 14:34:12 +0200 you wrote:
> Hi,
> 
> The following series contains one fix:
> 
> syzkaller managed to triger UaF due to missing reference on netns in
> bpf infrastructure, from Florian Westphal.
> 
> [...]

Here is the summary with links:
  - [net,1/1] netfilter: bpf: must hold reference on net namespace
    https://git.kernel.org/netdev/net/c/1230fe7ad397

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


