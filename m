Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBC0E42A80;
	Sat,  1 Aug 2026 19:00:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785610844; cv=none; b=IHFCOcgZtWjDi3M+VznC2czmVuAEK0EcZnIQGupinSxz5/3tzgdyqSTrfdWJnICJhcof0vE59kv1hKJT9/zeTUAFm8Y7KqbIUgEw9jG1YbvW4RToxnAA0ccB4BfAtRWKNcFR5MFD5RRcxQCWkcuy3FJwWwd1gjdZasw25RqPEhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785610844; c=relaxed/simple;
	bh=5TwfFPHxatI0Aq4rrmzYPyQqaCvawx2I6nY/BlFh7Cg=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=GCBkMpmkFCDaT8+S/XIUpZiw/hcCS4nrmc7gc5913n4AdAbviElgI2jgRl61wps5n8SBXJ20mMvEjaOLliNhBPYN3HLqySHDdN8uOpZ1IYn9gZZzk2LKddDN9pJ9CYAAUjHifxlQPqqA6q8nD98ikO7zOfCtPxrQYKzFFUA3mXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iBndGI4x; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iBndGI4x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4C081F00ACA;
	Sat,  1 Aug 2026 19:00:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785610843;
	bh=ZXU5F67pm9fxJcOvkWQZuSY6oggn4VlPEm7ge1PjZJ0=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=iBndGI4xZOnaa5l7eTchYYLoJnT2x7ldd1kSUQhYXb9/SKpU51N+R6BnxwzbmUGGh
	 cOVgdLtqRSam9tGBfQV2setgBSRWfoHUs7lCKGhr7ohwcT5TnUYKmcZad2s5d9vzkT
	 EwRojp76mcSHDKvK6JbVqB3hJc0sxZ/XsWXjaI8UuA8TzOt5aUpgkRrRpfvZXBb1/I
	 JVogPMJe7cA5HGTHR7CmYSk2LumGcVYvdpSxTq4JyJUcv3y/0tzDrWU4AMMJ9ReUot
	 vOtul0+EKZKVWRTDyK5HzJTims7tjF53Bh2rTaO5bABQfw29cuEmMtl/ATPfNcBrdR
	 Ssu0X95pFpVrw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 19932380820D;
	Sat,  1 Aug 2026 19:00:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf v3] bpf: Fix netns reference imbalance in conntrack
 kfuncs
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <178561080575.1189978.12237534381784349721.git-patchwork-notify@kernel.org>
Date: Sat, 01 Aug 2026 19:00:05 +0000
References: <20260731160921.3245840-1-nicoyip.dev@gmail.com>
In-Reply-To: <20260731160921.3245840-1-nicoyip.dev@gmail.com>
To: Chengfeng Ye <nicoyip.dev@gmail.com>
Cc: pablo@netfilter.org, fw@strlen.de, phil@nwl.cc, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, horms@kernel.org,
 ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
 john.fastabend@gmail.com, sdf@fomichev.me, memxor@gmail.com,
 lorenzo@kernel.org, netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org, bpf@vger.kernel.org

Hello:

This patch was applied to bpf/bpf.git (master)
by Kumar Kartikeya Dwivedi <memxor@gmail.com>:

On Sat,  1 Aug 2026 00:09:21 +0800 you wrote:
> The opts argument of the BPF conntrack kfuncs can point to a shared
> map value.  __bpf_nf_ct_lookup() and __bpf_nf_ct_alloc_entry() read
> opts->netns_id separately when acquiring and releasing the network
> namespace reference.
> 
> The reference imbalance can occur as follows:
> 
> [...]

Here is the summary with links:
  - [bpf,v3] bpf: Fix netns reference imbalance in conntrack kfuncs
    https://git.kernel.org/bpf/bpf/c/fdeba03fea78

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


