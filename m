Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84F8DEB64DD
	for <netfilter-devel@archiver.kernel.org>; Thu, 27 Jul 2023 05:20:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231527AbjG0FUZ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 27 Jul 2023 01:20:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230060AbjG0FUX (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 27 Jul 2023 01:20:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5839226A1
        for <netfilter-devel@vger.kernel.org>; Wed, 26 Jul 2023 22:20:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EA01F61D32
        for <netfilter-devel@vger.kernel.org>; Thu, 27 Jul 2023 05:20:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4DF76C433CA;
        Thu, 27 Jul 2023 05:20:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1690435221;
        bh=vSwZX0BIXyFbNfDAwkHdw6kvHKmRUxgspGD/XzL2DO4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=HftlvU74rHMFtFW2MhfJKNG2/soMFZlyCXiTYpQsnrwu/syFfyEOGhSwb51rtwg68
         yGfJidpLMKn4gVzwsSf4V6W1MXDD3uEUtmMLqunWUM7Lod+MiUE3Nkop+rgSFIXaqA
         bfxE/17uabZVu2N9hoiczVDrkHdtmHiBdOz7YhxCES/98tLqPs1EnqkyxupjBWOpI8
         zwGWPwSnzGYMU2dm4re3SyxJhLCUyKle4HclI1PK8dM10KtEVGCIpYi5AjzgvnlAHW
         5Bthtz96QH2zFC7GG7bxXck5HXDcHuTNYi6IxEBFTBYWQiUt72iw4Setskn0U3Vwiu
         DCC5IVx7VTclA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 2E27CC41672;
        Thu, 27 Jul 2023 05:20:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/3] netfilter: nft_set_rbtree: fix overlap expiration
 walk
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <169043522118.2558.8083806332093090188.git-patchwork-notify@kernel.org>
Date:   Thu, 27 Jul 2023 05:20:21 +0000
References: <20230726152524.26268-2-fw@strlen.de>
In-Reply-To: <20230726152524.26268-2-fw@strlen.de>
To:     Florian Westphal <fw@strlen.de>
Cc:     netdev@vger.kernel.org, pabeni@redhat.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org,
        netfilter-devel@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hello:

This series was applied to netdev/net.git (main)
by Florian Westphal <fw@strlen.de>:

On Wed, 26 Jul 2023 17:23:47 +0200 you wrote:
> The lazy gc on insert that should remove timed-out entries fails to release
> the other half of the interval, if any.
> 
> Can be reproduced with tests/shell/testcases/sets/0044interval_overlap_0
> in nftables.git and kmemleak enabled kernel.
> 
> Second bug is the use of rbe_prev vs. prev pointer.
> If rbe_prev() returns NULL after at least one iteration, rbe_prev points
> to element that is not an end interval, hence it should not be removed.
> 
> [...]

Here is the summary with links:
  - [net,1/3] netfilter: nft_set_rbtree: fix overlap expiration walk
    https://git.kernel.org/netdev/net/c/f718863aca46
  - [net,2/3] netfilter: nf_tables: skip immediate deactivate in _PREPARE_ERROR
    https://git.kernel.org/netdev/net/c/0a771f7b266b
  - [net,3/3] netfilter: nf_tables: disallow rule addition to bound chain via NFTA_RULE_CHAIN_ID
    https://git.kernel.org/netdev/net/c/0ebc1064e487

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


