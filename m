Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9809CDB483
	for <netfilter-devel@archiver.kernel.org>; Sat, 14 Oct 2023 01:00:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229649AbjJNBA2 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 13 Oct 2023 21:00:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232431AbjJNBA0 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 13 Oct 2023 21:00:26 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F321C0
        for <netfilter-devel@vger.kernel.org>; Fri, 13 Oct 2023 18:00:25 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2DEACC433C9;
        Sat, 14 Oct 2023 01:00:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697245225;
        bh=kSmVt9zmG9FehpYGin07k7CMV8LujE3xnbHWAa/hy2c=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=mxMLKdS/SEQiUVLVz2y0Hjyz9tHqbX/2+lpN2vMkmnVYGJz9lzAGdZL48RG8Yf6bl
         Kmz5RVyOko1RdIzQo91yR1O/9BEdiUm46aGe7lEvV+JOkKNVhrOwTpUMH6UseTy+5L
         BacL4yS5TkyfEAzaEe20JtMeqnE63d0WNGsw2PutsRf2ab8GKYLumBOkG+Ys+P4lpN
         LKlE/2vjNww2zSiTKl/pIuXB8hpBhDxIAH5sK7XrbIoLVCYhFf6QuAVT8o3SfyXiVL
         tlegBZVK8ci2716E8ofm3xS49LIu3Q4ez7MElzuMlaESUJKDwjGNEEbUYQ+/CDdPUH
         GroQNHlCPr1WA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 13D03E1F666;
        Sat, 14 Oct 2023 01:00:25 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/7] netfilter: nf_tables: do not remove elements if set
 backend implements .abort
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <169724522507.6466.3383347310826066954.git-patchwork-notify@kernel.org>
Date:   Sat, 14 Oct 2023 01:00:25 +0000
References: <20231012085724.15155-2-fw@strlen.de>
In-Reply-To: <20231012085724.15155-2-fw@strlen.de>
To:     Florian Westphal <fw@strlen.de>
Cc:     netdev@vger.kernel.org, pabeni@redhat.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org,
        netfilter-devel@vger.kernel.org, pablo@netfilter.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hello:

This series was applied to netdev/net.git (main)
by Florian Westphal <fw@strlen.de>:

On Thu, 12 Oct 2023 10:57:04 +0200 you wrote:
> From: Pablo Neira Ayuso <pablo@netfilter.org>
> 
> pipapo set backend maintains two copies of the datastructure, removing
> the elements from the copy that is going to be discarded slows down
> the abort path significantly, from several minutes to few seconds after
> this patch.
> 
> [...]

Here is the summary with links:
  - [net,1/7] netfilter: nf_tables: do not remove elements if set backend implements .abort
    https://git.kernel.org/netdev/net/c/ebd032fa8818
  - [net,2/7] netfilter: nfnetlink_log: silence bogus compiler warning
    https://git.kernel.org/netdev/net/c/2e1d17541097
  - [net,3/7] netfilter: nf_tables: Annotate struct nft_pipapo_match with __counted_by
    https://git.kernel.org/netdev/net/c/d51c42cdef5f
  - [net,4/7] netfilter: nf_tables: do not refresh timeout when resetting element
    https://git.kernel.org/netdev/net/c/4c90bba60c26
  - [net,5/7] nf_tables: fix NULL pointer dereference in nft_inner_init()
    https://git.kernel.org/netdev/net/c/52177bbf19e6
  - [net,6/7] nf_tables: fix NULL pointer dereference in nft_expr_inner_parse()
    https://git.kernel.org/netdev/net/c/505ce0630ad5
  - [net,7/7] netfilter: nft_payload: fix wrong mac header matching
    https://git.kernel.org/netdev/net/c/d351c1ea2de3

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


