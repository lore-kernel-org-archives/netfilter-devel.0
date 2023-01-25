Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77CFDC38142
	for <netfilter-devel@archiver.kernel.org>; Wed, 25 Jan 2023 01:00:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232601AbjAYBAT (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 24 Jan 2023 20:00:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230126AbjAYBAS (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 24 Jan 2023 20:00:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F12D222ED;
        Tue, 24 Jan 2023 17:00:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 052376137B;
        Wed, 25 Jan 2023 01:00:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 52E26C433EF;
        Wed, 25 Jan 2023 01:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674608416;
        bh=pR4ZwRL4CQen7r3ld5OZIkwir9lyVdoPsLWcMjxgiws=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=q6AKjCkfD9KFVbjLNm0itN9bKJUfTZ6BSyCeWrjjbpN8jNGj4hH237uH/6PjveQug
         hpNpv5TTVRP24ejfhN7Pzx1VJl6BeGJvoTC52h4qc0ibnO2oG+khXP3hJLJ8uWUfE3
         YrURmT4PMSIJwj3DKA0Bs41Ch6nUwm17OEwHwKDW4Pq9nQhvEWJ6RUBUuLjlGWULb3
         IgxupDdiGGFx8Utr384pk1jgJxQDAZGvE6JKmeivZQm6fewEMcy1IXdwcqlqycfjEU
         NBpYZkDpRcKGDxE8p0jCvzyCOL460sOms98ezmR9bbaXMuZJmpnEHshc9FFzHtv8Mf
         IjFUJNJKC3Opw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 320DEF83ED3;
        Wed, 25 Jan 2023 01:00:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] netlink: fix spelling mistake in dump size assert
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167460841619.24500.5551422169194789078.git-patchwork-notify@kernel.org>
Date:   Wed, 25 Jan 2023 01:00:16 +0000
References: <20230123222224.732338-1-kuba@kernel.org>
In-Reply-To: <20230123222224.732338-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, idosch@idosch.org, jiri@nvidia.com,
        pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de,
        johannes@sipsolutions.net, ecree.xilinx@gmail.com,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 23 Jan 2023 14:22:24 -0800 you wrote:
> Commit 2c7bc10d0f7b ("netlink: add macro for checking dump ctx size")
> misspelled the name of the assert as asset, missing an R.
> 
> Reported-by: Ido Schimmel <idosch@idosch.org>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
> CC: jiri@nvidia.com
> CC: pablo@netfilter.org
> CC: kadlec@netfilter.org
> CC: fw@strlen.de
> CC: johannes@sipsolutions.net
> CC: ecree.xilinx@gmail.com
> CC: netfilter-devel@vger.kernel.org
> CC: coreteam@netfilter.org
> 
> [...]

Here is the summary with links:
  - [net-next] netlink: fix spelling mistake in dump size assert
    https://git.kernel.org/netdev/net-next/c/ec8f7d495b3d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


