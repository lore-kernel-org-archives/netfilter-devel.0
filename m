Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFB571EEE6;
	Thu,  7 Mar 2024 10:20:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709806831; cv=none; b=hLPvTqH/mhbbNaSHTIidsWIclVkpYvsHPYEVVX5teQ4067r5GG+jICRg1BspwNRK9QN/YWFVhaKFe+aOnwrKIycIkaF4CsmNFjFY6pgC4KxS37Rc0AJD1FU/KJtr5jtAObk1ze15hZllmMZH6njv38WjB+OF9j7G3oM7SAUcvBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709806831; c=relaxed/simple;
	bh=u43Ll0cUlDP5oSFIx0/nXfUKDYLk2iLHFT+MSRWlBrE=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=bLtEwAnXLXsMIvMFYUtgvxmtBilegl2WY9WVWYOSgbKG98i4KpM8qOQj3Q9q+jry3rS7ottjWQrj4PRDIImd5b/9TzDKZ2QhEES1GfM0FbLSxkwJjn5nbXxGYLkWgSRJltJoTjXKG03x/RfUaATZMhN1EkSp9pdgTTKJu3FrItk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ttw7ww5y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ttw7ww5y"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6E8BFC433C7;
	Thu,  7 Mar 2024 10:20:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1709806830;
	bh=u43Ll0cUlDP5oSFIx0/nXfUKDYLk2iLHFT+MSRWlBrE=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=ttw7ww5yGQ8TqD+HZgDU65tOF6LqtgUh/mlc2ngx/BYjWmm6B+SfvAEKz2pWjU6uH
	 F6aeMPzTs9bSG2/BL5eh/WE+Cg9noS7uwxXfW2Bc8MCkj3bGW8mRNFgWrqhVYqpUfn
	 02//NnoV3JpQNlqeQ5AeG/Tcp1/NFOmp2BC9w7iJGooGg0SFw/LQT8sS0XrJZmL104
	 z5Gyb+aOIEB8GZQlUvqDXtUneNuVT1ctE93CIZuP/J7rmZ7Z/ltFK+HYTgHOAIJ6Lu
	 cL/NS5QQ71B4936kvy6PKquJLBeIzsjqA150MRQQIUaAskkG88iYUPdzqIgYdYQK4H
	 TNtlcGzV1mqmQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 5914DC3274B;
	Thu,  7 Mar 2024 10:20:30 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/5] netfilter: nf_tables: disallow anonymous set with
 timeout flag
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <170980683036.8281.10281573201075981874.git-patchwork-notify@kernel.org>
Date: Thu, 07 Mar 2024 10:20:30 +0000
References: <20240307021545.149386-2-pablo@netfilter.org>
In-Reply-To: <20240307021545.149386-2-pablo@netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 edumazet@google.com, fw@strlen.de

Hello:

This series was applied to netdev/net.git (main)
by Pablo Neira Ayuso <pablo@netfilter.org>:

On Thu,  7 Mar 2024 03:15:41 +0100 you wrote:
> Anonymous sets are never used with timeout from userspace, reject this.
> Exception to this rule is NFT_SET_EVAL to ensure legacy meters still work.
> 
> Cc: stable@vger.kernel.org
> Fixes: 761da2935d6e ("netfilter: nf_tables: add set timeout API support")
> Reported-by: lonial con <kongln9170@gmail.com>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> 
> [...]

Here is the summary with links:
  - [net,1/5] netfilter: nf_tables: disallow anonymous set with timeout flag
    https://git.kernel.org/netdev/net/c/16603605b667
  - [net,2/5] netfilter: nf_tables: reject constant set with timeout
    https://git.kernel.org/netdev/net/c/5f4fc4bd5cdd
  - [net,3/5] netfilter: nft_ct: fix l3num expectations with inet pseudo family
    https://git.kernel.org/netdev/net/c/99993789966a
  - [net,4/5] netfilter: nf_tables: mark set as dead when unbinding anonymous set with timeout
    https://git.kernel.org/netdev/net/c/552705a3650b
  - [net,5/5] netfilter: nf_conntrack_h323: Add protection for bmp length out of range
    https://git.kernel.org/netdev/net/c/767146637efc

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


