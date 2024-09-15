Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9EC61422D4;
	Sun, 15 Sep 2024 16:01:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726416080; cv=none; b=abxg+IVB1W1tlejfEfMjxzNUEe6wA1Uy4Fl/OXwTVPLB0ITczJyQLAy1+nDfs6nvg2ImF77zxcXRWKUzquYM6T6fXcA+Bs30TSeMTXJi02Z5hOujk9NkJ8XaiuiKhacDEb1109y7sG6OCNnpr5Huy1F0MZMZBbfE8zGUaaXMRc0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726416080; c=relaxed/simple;
	bh=cp73c9zPVoxi3lO5JBOl9BMEdEl+r5pUviYHEXCzGA4=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=hv5U2oQlAa1kOFfQaAYAcGEefe0PXi6/CoCBJKrVPPUk9mMKbsz66tVx3qZv2wHnRLFOklgyBiW6B3Em5JLBLsB6n/UkS9nxTS1veyscMRPO7/QI/wdDUIJ03aYJrkBWGw3peGuu/TyPR73n7ekpEFHKKZ4XuuoILU1dFCpGpO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QRw5Ou6c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QRw5Ou6c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4511AC4CEC3;
	Sun, 15 Sep 2024 16:01:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1726416080;
	bh=cp73c9zPVoxi3lO5JBOl9BMEdEl+r5pUviYHEXCzGA4=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=QRw5Ou6coXzdUu3yARKsKYu9B2nyDts5Sm9HNHu2lBAU2mRNPu0fCP8XlcOcORXM5
	 MVmYIqzaMZEP3l+Bpa/R1KJC7a7mWQsefdq5LKuVpIVf50Vjg94fkgRaV6YQpFl3qH
	 SojGqmoag2LekQfGOHyr845zV60nj/Q5KFWwu8C4uO2kFA0GK+A7Azx9NnL1ayGCh7
	 /ud7PHw9rAlZq2PUHep0RhaaETYUTNLv/79KPBWajsQUNb5wtormbQjS9kQXPt3W5W
	 KOUP3aVwsMbbpBseeKnkNS3M5hNFjGNen9xPOPMI6rLKdHSfUzODmS2enI5PhLPlNS
	 rNZzJfa5dpVpQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id EBC383804C85;
	Sun, 15 Sep 2024 16:01:22 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] netfilter: nft_socket: Fix a NULL vs IS_ERR() bug in
 nft_socket_cgroup_subtree_level()
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <172641608180.3111582.12970582241572787973.git-patchwork-notify@kernel.org>
Date: Sun, 15 Sep 2024 16:01:21 +0000
References: <bbc0c4e0-05cc-4f44-8797-2f4b3920a820@stanley.mountain>
In-Reply-To: <bbc0c4e0-05cc-4f44-8797-2f4b3920a820@stanley.mountain>
To: Dan Carpenter <dan.carpenter@linaro.org>
Cc: fw@strlen.de, pablo@netfilter.org, kadlec@netfilter.org,
 davem@davemloft.net, edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
 netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 kernel-janitors@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Sat, 14 Sep 2024 12:56:51 +0300 you wrote:
> The cgroup_get_from_path() function never returns NULL, it returns error
> pointers.  Update the error handling to match.
> 
> Fixes: 7f3287db6543 ("netfilter: nft_socket: make cgroupsv2 matching work with namespaces")
> Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
> ---
>  net/netfilter/nft_socket.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Here is the summary with links:
  - [net] netfilter: nft_socket: Fix a NULL vs IS_ERR() bug in nft_socket_cgroup_subtree_level()
    https://git.kernel.org/netdev/net/c/7052622fccb1

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


