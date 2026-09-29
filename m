Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D57B7215161;
	Tue, 29 Sep 2026 02:40:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790649614; cv=none; b=M9UjsX8El9ti+hGxUUwxlF40ksTM1JL4RKTUFXE6edKl53edbbDtOOLgCDGOZroR1D6YluM200lc/ZKjQ/KwQ9mwzEIg7ssLU81Mmns5z6+dzUCp62qRF7Az1O32X8hhyfuO93B7I/L2WyOUbGqiE72JKwrwLJ622cn37/L9zpo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790649614; c=relaxed/simple;
	bh=Ws9v0d/ykAadyYg1HuaFQkAqVfvUa62xHgwssrLAXHA=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=ODv9ldiK0thUnJpWErbPJZUWrIirQnDAiBuVsR0btjXEX/olyZzeYOXSAZV9waUXR3T7QJaDwGSDIkQQhHUMKDN+boUPOnH3ANy4bQyZsfcJyONdKwuWLlWNIwJ6HGlqKACHxR0IkwLy3uzwEUZeLomdh2+vMh2Pfc3wtyJvsQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nET3uJIp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nET3uJIp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81F731F000FF;
	Tue, 29 Sep 2026 02:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790649612;
	bh=ND4rDC+Dj9qpMdUYg3dlfgOCarPg7t0DpY2MvdzzPZM=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=nET3uJIpjqTI112W1bHXMVsn7QhpVtS5/lENd3PcimiqoZjHqCmhNYmSkFWF9mhaa
	 ceENJy3+frFk68FMNNUnGQm5g/U7riHp5GTqqr+VSWLHfXghZXJbAx6TnETN7oQ7NP
	 yUQRgELfiEGyk6OEdDDzXhgk3kEJOzRbXjl3HYALgtgiAcZqLw8kKqZY1UJ4O8kj7U
	 FY4ZZI2wG4850Fn1SALoTmzUX7BzhSZoBRHqKmGG3Y+kqrvOnsJPviRtc6+Q/0MG13
	 nMZArBrFe9HKQgC+xrLM6TkGQsJAezhohWWbzP0RYByuGNRBnyk+BYmdlCDiQkNN3m
	 NPSfaT1el03tw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 773543924FF2;
	Tue, 29 Sep 2026 02:40:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 01/11] netfilter: synproxy: fix reset of ct
 seqadj
 when reopening a connection
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <179064961102.229594.11396134169189168960.git-patchwork-notify@kernel.org>
Date: Tue, 29 Sep 2026 02:40:11 +0000
References: <20260927223436.269024-2-pablo@netfilter.org>
In-Reply-To: <20260927223436.269024-2-pablo@netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 edumazet@google.com, horms@kernel.org, fw@strlen.de, ja@ssi.bg

Hello:

This series was applied to netdev/net-next.git (main)
by Pablo Neira Ayuso <pablo@netfilter.org>:

On Mon, 28 Sep 2026 00:34:26 +0200 you wrote:
> From: Fernando Fernandez Mancera <fmancera@suse.de>
> 
> SYNPROXY is resetting conntrack seqadj when a closed connection is
> re-opened, but it was using nf_ct_seqadj_init() which is a no-op for a
> zero offset.
> 
> This patch introduces nf_ct_seqadj_reset() which sets the offset values
> directly to zero and avoid setting IPS_SEQ_ADJUST_BIT flag, it changes
> SYNPROXY code to use it when needed.
> 
> [...]

Here is the summary with links:
  - [net-next,01/11] netfilter: synproxy: fix reset of ct seqadj when reopening a connection
    https://git.kernel.org/netdev/net-next/c/a8708aa9fe10
  - [net-next,02/11] netfilter: conntrack: fix nf_conntrack_expect_max default value in documentation
    https://git.kernel.org/netdev/net-next/c/409df11c5674
  - [net-next,03/11] netfilter: osf: remove unreachable break in nf_osf_ttl()
    https://git.kernel.org/netdev/net-next/c/32cbf7a8e556
  - [net-next,04/11] netfilter: fix several typos in comments
    https://git.kernel.org/netdev/net-next/c/d8cefdc18124
  - [net-next,05/11] netfilter: conntrack: Untangle insert_failed counter from others
    https://git.kernel.org/netdev/net-next/c/96ed91f5773a
  - [net-next,06/11] netfilter: conntrack: Untangle drop and invalid counters
    https://git.kernel.org/netdev/net-next/c/2ac41d7009c7
  - [net-next,07/11] net/sched: act_ct: set net pointer before publishing flowtable
    https://git.kernel.org/netdev/net-next/c/d4548625f38b
  - [net-next,08/11] netfilter: flowtable: check namespace before iterating flows
    https://git.kernel.org/netdev/net-next/c/c48fdf027a72
  - [net-next,09/11] netfilter: nfnetlink: Fix for interrupted hook dumps
    https://git.kernel.org/netdev/net-next/c/d3950004ba90
  - [net-next,10/11] netfilter: ctnetlink: fix inverted IPv6 address match in dump filter
    https://git.kernel.org/netdev/net-next/c/1ae2d094b020
  - [net-next,11/11] netfilter: conntrack: make filtering by zone discoverable
    https://git.kernel.org/netdev/net-next/c/46da6029bf46

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


