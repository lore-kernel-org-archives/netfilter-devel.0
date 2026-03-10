Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23B5320D4E9;
	Tue, 10 Mar 2026 01:40:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773106809; cv=none; b=Zrcd5FWrc9IPMgUn0gZK1lSOqDZV28KdTXSXeftXoEaglbz5CNURLvItGMqzj1dpbw3I2cu0lCHsOuzo1oUtE1NDPMGlaxacuh6suc5X7bZXfnhWfFBcp5i0/DtYtClwC0Gtx5Bb9+4Ek9/eW8ZLokw2BalshOMIShSgKPSsG/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773106809; c=relaxed/simple;
	bh=CTyevbnLhVnXQRAgDkpKIDTxkEBqIOWP/NygntQpkPc=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=EuG7cVIhhGZdd0WifqZqEaKqj8V/Rhm5S6mp7T4rBWX50cu028glrXcT8X5BXU407U0LtDYaFA7BHybIagrBIcBhfH9lhj7aYHCdX3XFZ6tz0FRpHSrQE195ga0o435/D3sVD8fHnN95JZFlmCj48EIVfpmzDRvTrHHCnH6J128=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nZJsqB49; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nZJsqB49"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4D3FC4CEF7;
	Tue, 10 Mar 2026 01:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773106808;
	bh=CTyevbnLhVnXQRAgDkpKIDTxkEBqIOWP/NygntQpkPc=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=nZJsqB49gdW3S3YQZVSdK9IIF8yg671E/377F/IQc9DZZ1zcXuGZRh2xJZxw5+LNl
	 Wyc5MLYeZ7MQQK7D3ASFa4tMm/3KnaxlhM/mvXVTM5lDqNlUmvkT5KMFusfEpzxTtp
	 sLDqKkc5C3WXotFUWI/CHagz3xG87Tm0ew+tCIyRTGoAixp9+BdMnuh5Hh89EWzHDX
	 bRHZmX9DVrC8rILjp2tUSVi/qYButuw4d3yvGFi90klEi3cz5ECNgtdzgK/gEgLNDw
	 a2QGmTn76jKpHZFssau008Dm0Xvi6ey/JOGANWhXQoUPCW6AXXWRE7HbWtU2pCt60P
	 JFOzET4PdZ3Cg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 02DFE3808200;
	Tue, 10 Mar 2026 01:40:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: Add SPDX ids to some source files
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <177310680580.2015770.4327428961220043199.git-patchwork-notify@kernel.org>
Date: Tue, 10 Mar 2026 01:40:05 +0000
References: <20260305004724.87469-1-tim.bird@sony.com>
In-Reply-To: <20260305004724.87469-1-tim.bird@sony.com>
To: Tim Bird <Tim.Bird@sony.com>
Cc: davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
 pabeni@redhat.kernel.org, kuniyu@google.com, mubashirq@google.com,
 willemb@google.com, dsahern@kernel.org, pablo@netfilter.org,
 laforge@netfilter.org, fw@strlen.de, ncardwell@google.com, ycheng@google.com,
 xemul@parallels.com, idosch@mellanox.com, tim.bird@sony.com,
 netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
 coreteam@netfilter.org, linux-spdx@vger.kernel.org,
 linux-kernel@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Wed,  4 Mar 2026 17:47:22 -0700 you wrote:
> Add SPDX-License-Identifier lines to several source
> files under the network sub-directory.  Work on files
> in the core, dns_resolver, ipv4, ipv6 and
> netfilter sub-dirs.  Remove boilerplate
> and license reference text to avoid ambiguity.
> 
> Rusty Russell has expressed that his contributions
> were intended to be GPL-2.0-or-later.
> 
> [...]

Here is the summary with links:
  - net: Add SPDX ids to some source files
    https://git.kernel.org/netdev/net-next/c/2ed4b46b4fc7

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


