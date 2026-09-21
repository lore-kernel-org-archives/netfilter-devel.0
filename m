Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1EAE51AEE0;
	Mon, 21 Sep 2026 22:21:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790029285; cv=none; b=eALi++w6kEtUDUFLHvbP/dLzKKItEDjkHbojLwirriiBHtT0PtJkF75tI9Y20opaTnhJZEco2nXkl0TlsNGU5pxQtvfofel8xgzH1DXieBur7i9O3UsnDxJNplnn8uZAhh9vwibl8/n4pyv4RDZ8sIm6b/ejvXavk+iY0NS7TKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790029285; c=relaxed/simple;
	bh=eEzvJSkZcAeOwGwiOJFzpDqZemIeIYUf3X8u1mu6Dcs=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=ED0D6wrLye9FCa1H03ZD2v/bLTZD0oXb5mro2/U1MocHqV5uvks5T1aYLgIK4fslZmUp2PH7ft1n9bHw2Oxw7Fz0yshCRXEL0fw9I7kCLrpMqObVAV8YVKq+jqgc4jIjdNUKijhB9fjygJ2lFpCvDvcV2/Kle9De3n+fQzMQKvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LWucIGy1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LWucIGy1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E142C1F000FF;
	Mon, 21 Sep 2026 22:21:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790029283;
	bh=1FCpLALQlGggQQXRKN+31vT81DR2kUF9lOniwLhoMRM=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=LWucIGy1gLziJrH8XMAvh5HL/agf3s1/TsetI9Z/8QL08XZLmaLZRJEIGPxwGLu2U
	 L3fKRggRGMWZnMe5k0MaJ/HqlPCBzu2HyPjPBh7Y2W8GR1nkjxBHQwteEcSHgjWFgr
	 9pP43cWyQqhigvi9LaJgcOYJxxAGgtAYCuNxEsRUDLV8SbymyvvHyBva6p6a/OVNBZ
	 fPE7Tpa5+XHnaMNxkh2i8+mdjnNSMOXGWrlXj9hhzDoFVNyMn5ciDiYE368U2/fGJo
	 PMoBQHOEGlNK5XHeaU++Oun/UQ6iqffxv+TICFaeMCEVZCDdpbQZMmkEzBKGQ1GHdg
	 mfssmI1aoMSYA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 93A583927202;
	Mon, 21 Sep 2026 22:20:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/8] netfilter: flowtable: publish HW_DEAD after
 worker is
 done
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <179002921521.3263747.10381944958738209082.git-patchwork-notify@kernel.org>
Date: Mon, 21 Sep 2026 22:20:15 +0000
References: <20260918112844.194503-2-pablo@netfilter.org>
In-Reply-To: <20260918112844.194503-2-pablo@netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 edumazet@google.com, horms@kernel.org, fw@strlen.de, ja@ssi.bg

Hello:

This series was applied to netdev/net.git (main)
by Pablo Neira Ayuso <pablo@netfilter.org>:

On Fri, 18 Sep 2026 13:28:37 +0200 you wrote:
> From: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
> 
> flow_offload_work_del() sets NF_FLOW_HW_DEAD before the work handler
> clears NF_FLOW_HW_PENDING. Once a flow is both HW_DYING and HW_DEAD, a
> concurrent garbage collection pass can remove it and schedule it for RCU
> freeing.
> 
> [...]

Here is the summary with links:
  - [net,1/8] netfilter: flowtable: publish HW_DEAD after worker is done
    https://git.kernel.org/netdev/net/c/d644b23afe1e
  - [net,2/8] netfilter: nfnetlink_queue: hold nfnl mutex in event notifier
    https://git.kernel.org/netdev/net/c/9461613afc59
  - [net,3/8] netfilter: ip6t_rpfilter: reject routes without inet6_dev
    https://git.kernel.org/netdev/net/c/1b9b5323725e
  - [net,4/8] netfilter: ip6t_rt: fix zero-address non-strict match out-of-bounds read
    https://git.kernel.org/netdev/net/c/82313c169edd
  - [net,5/8] netfilter: nft_synproxy: use the family-aware checksum helper
    https://git.kernel.org/netdev/net/c/a311a8981727
  - [net,6/8] ipvs: revalidate ihl before icmp_send
    https://git.kernel.org/netdev/net/c/e29014556488
  - [net,7/8] netfilter: ctnetlink: fix suspicious RCU usage in expect_iter_name
    https://git.kernel.org/netdev/net/c/207d591c3532
  - [net,8/8] netfilter: nf_tables: skip expired catchall elements on insert and delete
    https://git.kernel.org/netdev/net/c/70194dc37670

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


