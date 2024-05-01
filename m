Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF68C165FAA;
	Wed,  1 May 2024 22:00:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714600831; cv=none; b=XBrMfXlCRMN4T9xxKG7jInyPgZblOh32kPjOuY2iP+ar9qyIKzTlZLbABnhRp7TR7LGA2U/s1HDSmLxVE0izsATA+V5iOY/bVw6OJf5cDvQpBGSMb9lXHdJJEDC8MzKpR3VZ+PARaTu2O1Nf1OzntOL8pSJIBSQkqH+wI264wK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714600831; c=relaxed/simple;
	bh=7lj6j3p1J31BkRE1bBmMJsLh1g6Wji4W6zmoyg64ShA=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=nohWA3WCiN39TxTg4AIBVAdb4IF6cziwGpVY9SkZ6d1Xn3UnZVIInlr3WWvoNJx8JUoBSujqyf75FS2r9xnPZtcAXw2VPWykxbHhwfLpVAvg/cmIXtUai7THjl4/de/ruleGxFs9LiaKLjisTpFQB+NR5ZdXxdk82N8bL6Kjj0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=g1DomE3u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="g1DomE3u"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5BFD8C4AF48;
	Wed,  1 May 2024 22:00:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1714600831;
	bh=7lj6j3p1J31BkRE1bBmMJsLh1g6Wji4W6zmoyg64ShA=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=g1DomE3ulsOzQWtN3deCTGsMM9sbsp4Y9PHqaQTMkvgkZove57sXPo1wbazJSMaDW
	 uo5Yfcvp4aEDx8aM61gKiq/9t0TS2FIl8TdnnzTEK38Heu1k3OcdH6DDkpF9d2r3MG
	 XbJLun2o6LpYFwiSu9201o3Aqt5Xk7AjzK187AgAMC7b9HXF6mHZ2a1x48qyL5AcBO
	 OotwxHAmooOje58hIeRPbRNbdRhukzKU72Wr6ED1moAcwnr+GCAGPbDlAugvZxmovo
	 T507fOPdLCZ9F2OGalYDMZ3mWGk1qZ4ogjA2liI/JJ2eeKNrfOb2t0yE9SVULnihbX
	 5bUwLWNPJakug==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 5074DC433A2;
	Wed,  1 May 2024 22:00:31 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] selftests: netfilter: nft_concat_range.sh: reduce
 debug kernel run time
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <171460083132.4291.7145095168769929770.git-patchwork-notify@kernel.org>
Date: Wed, 01 May 2024 22:00:31 +0000
References: <20240430145810.23447-1-fw@strlen.de>
In-Reply-To: <20240430145810.23447-1-fw@strlen.de>
To: Florian Westphal <fw@strlen.de>
Cc: netdev@vger.kernel.org, pabeni@redhat.com, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, netfilter-devel@vger.kernel.org,
 pablo@netfilter.org

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 30 Apr 2024 16:58:07 +0200 you wrote:
> Even a 1h timeout isn't enough for nft_concat_range.sh to complete on
> debug kernels.
> 
> Reduce test complexity and only match on single entry if
> KSFT_MACHINE_SLOW is set.
> 
> To spot 'slow' tests, print the subtest duration (in seconds) in
> addition to the status.
> 
> [...]

Here is the summary with links:
  - [net-next] selftests: netfilter: nft_concat_range.sh: reduce debug kernel run time
    https://git.kernel.org/netdev/net-next/c/496bc5861c73

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


