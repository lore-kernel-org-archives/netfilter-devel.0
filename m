Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4701022AE5D;
	Fri, 31 Oct 2025 01:20:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761873633; cv=none; b=a9DgnuhiB68jAKA+DfClEV63c+wZSuxMVVsGYZZYKCXiwOu8kVMYtll/3BCYOi5LzpUWpoQYPEDEo3RS8Wb+NTM/Lxvj4e165UzNBPOmgmSinrlo/WajWRF+bdknkzlRUNmrBqDevLYOCu/optSR+twtyYS4BFn/t2An1vbvLDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761873633; c=relaxed/simple;
	bh=CAo3OxX2uG3PZzjUXz2YNm0P/qibiIW2jtTnvTQBIA4=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=RI0IKFeyAJGdHftKIkQOVyuedxBLW7BL1tbmpazlpoAPazBGDrizB6P1fuJNVRYl4kwFSyBaf1aruuJq86OxYthZdqZYwHc0p+UHPqcOHsgvhyAuCPGOMCvoDPSE/yoHdf6LEXCRdvnn65+WPy++zeYQA6sdWdUskBlHQmCCa5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=au+a82oi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="au+a82oi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B473FC4CEF1;
	Fri, 31 Oct 2025 01:20:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761873631;
	bh=CAo3OxX2uG3PZzjUXz2YNm0P/qibiIW2jtTnvTQBIA4=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=au+a82oiR+U76K8+J/eSzggNHPf75M3JjQPP38aNm+P/q9ScFoyAIOJXCwhS+xVE9
	 Y6IqyjNKXz2DrF5sPEFAbtg8n3mrG3twt6dlc4sJ4FGCQMLpkRcYATQQXoYvlnBMJ6
	 /Xba8bD/zxgFOdZYMranHHkVWfDYN9FcU4+Fw6Gp4nv95pgqOtjN/dRLdGImsL6tvX
	 P+JmVI7X49x9gzduhrwsyGHGAaUk5CwI/zSCvdLQYujbjYEwTOE8CUZzkj0X9lCKe8
	 ndOmvJcbgbyfCWbrfiy5MEPOfXxB0vRXJC8bTpvCVrIuKKz1MvByrqF1b+En2RC1mF
	 5JC0smbEsA8/g==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 70C2C3A78A6F;
	Fri, 31 Oct 2025 01:20:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 1/3] netfilter: nf_tables: use C99 struct
 initializer
 for nft_set_iter
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <176187360825.4097866.13802964435117341064.git-patchwork-notify@kernel.org>
Date: Fri, 31 Oct 2025 01:20:08 +0000
References: <20251030121954.29175-2-fw@strlen.de>
In-Reply-To: <20251030121954.29175-2-fw@strlen.de>
To: Florian Westphal <fw@strlen.de>
Cc: netdev@vger.kernel.org, pabeni@redhat.com, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, netfilter-devel@vger.kernel.org,
 pablo@netfilter.org

Hello:

This series was applied to netdev/net-next.git (main)
by Florian Westphal <fw@strlen.de>:

On Thu, 30 Oct 2025 13:19:52 +0100 you wrote:
> From: Fernando Fernandez Mancera <fmancera@suse.de>
> 
> Use C99 struct initializer for nft_set_iter, simplifying the code and
> preventing future errors due to uninitialized fields if new fields are
> added to the struct.
> 
> Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
> Signed-off-by: Florian Westphal <fw@strlen.de>
> 
> [...]

Here is the summary with links:
  - [net-next,1/3] netfilter: nf_tables: use C99 struct initializer for nft_set_iter
    https://git.kernel.org/netdev/net-next/c/320d80eeb222
  - [net-next,2/3] netfilter: conntrack: disable 0 value for conntrack_max setting
    https://git.kernel.org/netdev/net-next/c/2b749f257645
  - [net-next,3/3] netfilter: fix typo in nf_conntrack_l4proto.h comment
    https://git.kernel.org/netdev/net-next/c/57347d58a401

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


