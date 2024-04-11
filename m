Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E17F313B28D;
	Thu, 11 Apr 2024 02:50:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712803828; cv=none; b=K6oQillmGpf7FEk4FYAQ9JQgOXfklsltuaUKawXutOftAKHJU7w7Qc7g2uiEIMQFVQQOww4GhHIK4wd07cjFFiK6OveUDPzjn2qGfJL3Teg6hMGsDp3KjRkLgkVZEgnxhYAo4ZcR4JRvHujyIGJB0NRlYUbmAbJvyDs4sgesxUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712803828; c=relaxed/simple;
	bh=BXwOUb94B0aeTXI2iXmNwcmPP3CbC1OC03DofIcmIf0=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=r5AvuacYPo7K33GKZ5Lcquqaj372omuhb/5vSVC3J2hA65j46haSa15y0rX33x/t9UeTnKXOjk/1pX68wZ+ZFNOVPhAj8weB4QvVDXvpWChA2axJX7xE+YrG9zzT0pUi726H65aFPrgz7P5qAwqKDhxSrdNWfWf3nrSaUaCyfcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AGAO8/oW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AGAO8/oW"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6DC0FC43390;
	Thu, 11 Apr 2024 02:50:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712803827;
	bh=BXwOUb94B0aeTXI2iXmNwcmPP3CbC1OC03DofIcmIf0=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=AGAO8/oWrszXoVTPJ/SWuS3ggI+sgdJ3aRRl82+g8Cmc9yeOyO/FD8ctdO53DaThR
	 hzCJj0vbK9VDMUSd4mmYI5Fllp12fN0vOWr7YAaFIH8Uf/8JW96MrxiiTGDP2AcSAe
	 G5gdr3Vl0zIOcZil/5aRypDF2D+5tOQM9WWWGLzbaUDUp4LGA5gHe1NJeSt0ISHzPd
	 qU0msNwCaszBUuAdc95VRqAftQ8FgQvIXFZKIX68llcgJWD6y1y5IibuXlIm60w2g6
	 op9KG8ftojjkXyY26Hy0GZ9eLV5sVeCe00JIPrPFZb2UxFKvt1jR6Atb9jLGcaiqUe
	 9AFQa+d6di8Jw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 5BAE0C395F6;
	Thu, 11 Apr 2024 02:50:27 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] netfilter: complete validation of user input
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <171280382737.28291.10185015760254158015.git-patchwork-notify@kernel.org>
Date: Thu, 11 Apr 2024 02:50:27 +0000
References: <20240409120741.3538135-1-edumazet@google.com>
In-Reply-To: <20240409120741.3538135-1-edumazet@google.com>
To: Eric Dumazet <edumazet@google.com>
Cc: davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
 pablo@netfilter.org, kadlec@netfilter.org, netdev@vger.kernel.org,
 netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
 eric.dumazet@gmail.com, syzkaller@googlegroups.com

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Tue,  9 Apr 2024 12:07:41 +0000 you wrote:
> In my recent commit, I missed that do_replace() handlers
> use copy_from_sockptr() (which I fixed), followed
> by unsafe copy_from_sockptr_offset() calls.
> 
> In all functions, we can perform the @optlen validation
> before even calling xt_alloc_table_info() with the following
> check:
> 
> [...]

Here is the summary with links:
  - [net] netfilter: complete validation of user input
    https://git.kernel.org/netdev/net/c/65acf6e0501a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


