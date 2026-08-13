Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 672D8432BE9;
	Thu, 13 Aug 2026 11:41:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786621269; cv=none; b=e/Cv17xkU9Dxiw7hbSgBokmK6HiV/NroXt3Pfk4k6GuQkQeQHIBuA58ckDYSDhqpsdrcQBAwSFJL1JSSiWkuNCcPu3BDHf1Q1UgGXPL+mU5rwOkuNMrzMUTJHLlJBoSgx94nT5/xw8wEd4Rm2rQlMGn4ptfeXONxxp/bpTEqHkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786621269; c=relaxed/simple;
	bh=/ct/rvBnE/g3w+nEus/IAD3FvCW1XeksJtAwtJHGrug=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=Z5eMTKt3ltcG1kAYw/tQqWNufgviK1Gfs5m39ZOb6ux2M1SLxZ4hXj2gmR17vIFMRQD+qnOmQJyk2XHeJqwMKuAtkPjQuJmTQdIqk3k+LtCZDUyVPcFUXoaMEaHPp6ImfGadN83sEYKBv1LgSaUjJapWZCQ4LazxDfuiGEBJGek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=B0saoH6k; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="B0saoH6k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2F3D1F000E9;
	Thu, 13 Aug 2026 11:41:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786621267;
	bh=gQc2+E/gAq8sUEiNZRdN1voNtsSEL4VuG6ZWckO0gnQ=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc;
	b=B0saoH6k860U7RUTnXNpEkVVa1qRtxp6+fx4f//EoKcKwduy+2ovgsXujvjAmAKxF
	 qPTCTK4ZEL+Lr3LtMwPDDlspWlP+NdNNZrol+LuDEUDiA9GnmBGbDxE3cakn6V7boE
	 i9VjS2fTiMJRLIaucOnYcd3s1ryrH0X5/dqHwNm2PbeCZpvdh2KTqo+Fjbpmn0omrA
	 hUkUtT6PEKnGLbVw1qkW3cW1jZsl4ID3ngZUGrSURSnkFgvDYOL4Ubo32AsNeSloCJ
	 FApC56WiRSSKSaeEEbyjWHA+8F2ts0Ck7z8COZNjBEYX4uGe37lfO1t4507HEEpkws
	 M6MFlrH0eXllw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 198E9380CFD7;
	Thu, 13 Aug 2026 11:40:23 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v4 0/3] net: sysctl: Const Qualify sysctl ctl_table arrays
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <178662122164.2389593.14118025636716368071.git-patchwork-notify@kernel.org>
Date: Thu, 13 Aug 2026 11:40:21 +0000
References: <20260810-jag-net_const_qualify-v4-0-77e888237c69@kernel.org>
In-Reply-To: <20260810-jag-net_const_qualify-v4-0-77e888237c69@kernel.org>
To: Joel Granados <joel.granados@kernel.org>
Cc: davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
 pabeni@redhat.com, horms@kernel.org, dsahern@kernel.org, idosch@nvidia.com,
 pablo@netfilter.org, fw@strlen.de, phil@nwl.cc, marcelo.leitner@gmail.com,
 lucien.xin@gmail.com, steffen.klassert@secunet.com,
 herbert@gondor.apana.org.au, alibuda@linux.alibaba.com,
 dust.li@linux.alibaba.com, sidraya@linux.ibm.com, wenjia@linux.ibm.com,
 mjambigi@linux.ibm.com, tonylu@linux.alibaba.com, guwen@linux.alibaba.com,
 kuniyu@google.com, sgarzare@redhat.com, chia-yu.chang@nokia-bell-labs.com,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
 linux-sctp@vger.kernel.org, linux-rdma@vger.kernel.org,
 linux-s390@vger.kernel.org, virtualization@lists.linux.dev

Hello:

This series was applied to netdev/net-next.git (main)
by Paolo Abeni <pabeni@redhat.com>:

On Mon, 10 Aug 2026 15:01:01 +0200 you wrote:
> What?
> =====
> We do two things:
> 1. Reject netns-unsafe: Replace warning and file permission change with
>    an error (reject registration) when an "unsafe" net sysctl
>    registration is detected.
> 2. Const qualify: Const qualify network templated ctl_table arrays and
>    unconditional kmemdup'ed ctl_table arrays.
> 
> [...]

Here is the summary with links:
  - [v4,1/3] net: enforce net sysctl registration
    https://git.kernel.org/netdev/net-next/c/ef6cb145e216
  - [v4,2/3] net: Const qualify ctl_tables that kmemdup unconditionally
    https://git.kernel.org/netdev/net-next/c/09190c59cd10
  - [v4,3/3] net: Const qualify network templated ctl_tables Arrays
    https://git.kernel.org/netdev/net-next/c/0abc76bc2082

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


