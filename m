Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 899A72BCF8;
	Tue, 22 Oct 2024 10:50:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729594224; cv=none; b=pjcW86RCTc3hLB48YW/Ug604DEuxNkwkXInnYOwWeOGKEqMC2RfH7oFJmDKIaimJAlXhL6WJgYV9ZjWjEgESpREjXhhg6KSMcBvp9WKgJlDvwvwJ7zQrPahtL2HKmlwGO3J4nLvW05m2FH8nAFtT1cOC1YGEIBatyTyX96IlQHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729594224; c=relaxed/simple;
	bh=V0HZ8+q8D/5rX5lhyyi5Yrx1N9npKknpz8hvtD1SFFY=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=fGhA5boSmne/bUG3vdKksyxUgFLKSfFaZlhoU5mj4LsFU9cpJK6Cpo9w4PN0N1nDGeJ/cXdLyeZPGI6HlTgiKtlC1MbnGFIrTN7z+57/oI18bVkr15NUlBOHHvvt/fGiC+O4iUoSMzzvgTZbW0wqv/bFnotsMLpWub0c0cgEM8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qheG6HPQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qheG6HPQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E68A2C4CEEE;
	Tue, 22 Oct 2024 10:50:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729594224;
	bh=V0HZ8+q8D/5rX5lhyyi5Yrx1N9npKknpz8hvtD1SFFY=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=qheG6HPQN8hrHsHtg08sytByBqqG0CLzEPKswpwfTLr6d2edqZboa0baXYtaZDNZi
	 sHSl3A7Wmzoo9JA+b9jCRfS4Cvg1zISQ+b6DM9GN0TeRRkV5BUrFs1mp0cs7gENUcn
	 3WzB772rZ+eOxjArDuozsMixvfBG9Y7qx5mv2nr22iqPONvMBI4TepA5KrsiIgS3R2
	 Ks7yk6RiZEOqtY0CZXBmZXeqhh5FgvAo/a9b6YsyQVllRuC+i6R/SBa/+Kmr09Tbgy
	 Nct5OIB94fPdGxadiStPhyO+HHxAOqlX00aMAh44xbBXJWO4rvRozhc1yap0FXUZe0
	 2OReXtOsgyBpw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 33C1E3809A8A;
	Tue, 22 Oct 2024 10:50:31 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/2] netfilter: bpf: must hold reference on net namespace
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <172959423000.927462.18176559432730180146.git-patchwork-notify@kernel.org>
Date: Tue, 22 Oct 2024 10:50:30 +0000
References: <20241021094536.81487-2-pablo@netfilter.org>
In-Reply-To: <20241021094536.81487-2-pablo@netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 edumazet@google.com, fw@strlen.de

Hello:

This series was applied to netdev/net.git (main)
by Pablo Neira Ayuso <pablo@netfilter.org>:

On Mon, 21 Oct 2024 11:45:35 +0200 you wrote:
> From: Florian Westphal <fw@strlen.de>
> 
> BUG: KASAN: slab-use-after-free in __nf_unregister_net_hook+0x640/0x6b0
> Read of size 8 at addr ffff8880106fe400 by task repro/72=
> bpf_nf_link_release+0xda/0x1e0
> bpf_link_free+0x139/0x2d0
> bpf_link_release+0x68/0x80
> __fput+0x414/0xb60
> 
> [...]

Here is the summary with links:
  - [net,1/2] netfilter: bpf: must hold reference on net namespace
    https://git.kernel.org/netdev/net/c/1230fe7ad397
  - [net,2/2] netfilter: xtables: fix typo causing some targets not to load on IPv6
    https://git.kernel.org/netdev/net/c/306ed1728e84

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


