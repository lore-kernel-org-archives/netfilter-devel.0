Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B3D317A310;
	Tue,  6 May 2025 11:29:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746530996; cv=none; b=DfpN0Aj6rS9dWV4FyAvTEqyywzPsOf4WNgnmApt3R0jkRXTcs7KEvSsz6QB0Wn5V/w6rDd/r0JITJsfKmrNibmlMwO1FVI7EKSBL/4AWuyhsdP7ApA9n9NJIMv50BocsP2nO10FLXTe+usltVA6bpdD79G4m96eMnxtl7XD9UHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746530996; c=relaxed/simple;
	bh=i0gF6+9iAmY0MZaxMD7Mcx2ZxhDZnu+1hx/PpST1aDY=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=dqEiXndzXy1GI/asI2jCtXdF+7omxWnybLK+5A0N2SBV46N9PetCbEFnXmc0KCc/UdcibMBJoZxx9Q/TjsXJbbRXAbvT9bQSLrAYnkL+yr0YyHWzOrDWDKGW9p8x2JDSW7CyjIQChoPRx6o++qK6r4JubvSO2IFcgxr9UJrX63A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sEu8qczZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sEu8qczZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B439C4CEED;
	Tue,  6 May 2025 11:29:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746530994;
	bh=i0gF6+9iAmY0MZaxMD7Mcx2ZxhDZnu+1hx/PpST1aDY=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=sEu8qczZRJNi9nMAWH1Yh4y8yqFYjIHAv0hI8HR0V/SmTglhxCDRbZiOCSQjsQjoa
	 OAZ/IwMiVnstJrnUWGnmHhe0+Lv/nca+us7gEc1TKSrb9lPmZEnXhjAP40ffIQZcL4
	 Iv3MFkGdyK7/f/pzIyUY2Qg8ZQ9T7DrETE7gONYVUMw3iLFPOc34GjMmC0Z7dj3G5q
	 kOuL85khVpPMulGwLl7ullB4es+WKKbU/h7KvXBdRJ7IYkPg8xU5o1AiTYe74j5K3k
	 ERekzuemBSUEtzniihIrURhbAOxZLRybimFka1ZfUTgOswEyTuWZp35JKlz9FcrApn
	 MZ1K8uOQeheKw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id EAD6D380CFFB;
	Tue,  6 May 2025 11:30:34 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH nf-next 1/7] netfilter: bridge: Move specific fragmented
 packet to slow_path instead of dropping it
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <174653103375.1485451.11465333231560680057.git-patchwork-notify@kernel.org>
Date: Tue, 06 May 2025 11:30:33 +0000
References: <20250505234151.228057-2-pablo@netfilter.org>
In-Reply-To: <20250505234151.228057-2-pablo@netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 edumazet@google.com, fw@strlen.de, horms@kernel.org

Hello:

This series was applied to netdev/net-next.git (main)
by Pablo Neira Ayuso <pablo@netfilter.org>:

On Tue,  6 May 2025 01:41:45 +0200 you wrote:
> From: Huajian Yang <huajianyang@asrmicro.com>
> 
> The config NF_CONNTRACK_BRIDGE will change the bridge forwarding for
> fragmented packets.
> 
> The original bridge does not know that it is a fragmented packet and
> forwards it directly, after NF_CONNTRACK_BRIDGE is enabled, function
> nf_br_ip_fragment and br_ip6_fragment will check the headroom.
> 
> [...]

Here is the summary with links:
  - [nf-next,1/7] netfilter: bridge: Move specific fragmented packet to slow_path instead of dropping it
    https://git.kernel.org/netdev/net-next/c/aa04c6f45b92
  - [nf-next,2/7] selftests: netfilter: add conntrack stress test
    https://git.kernel.org/netdev/net-next/c/d33f889fd80c
  - [nf-next,3/7] netfilter: nft_quota: match correctly when the quota just depleted
    https://git.kernel.org/netdev/net-next/c/bfe7cfb65c75
  - [nf-next,4/7] netfilter: nf_conntrack: speed up reads from nf_conntrack proc file
    https://git.kernel.org/netdev/net-next/c/5e4d107abd79
  - [nf-next,5/7] netfilter: nft_set_pipapo: prevent overflow in lookup table allocation
    https://git.kernel.org/netdev/net-next/c/4c5c6aa9967d
  - [nf-next,6/7] netfilter: nft_set_pipapo: clamp maximum map bucket size to INT_MAX
    https://git.kernel.org/netdev/net-next/c/b85e3367a571
  - [nf-next,7/7] selftests: netfilter: nft_fib.sh: check lo packets bypass fib lookup
    https://git.kernel.org/netdev/net-next/c/fc91d5e6d948

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


