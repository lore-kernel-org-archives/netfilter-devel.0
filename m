Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 619CEEC874B
	for <netfilter-devel@archiver.kernel.org>; Thu,  7 Sep 2023 18:22:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343916AbjIGSWL (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 7 Sep 2023 14:22:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343829AbjIGSWD (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 7 Sep 2023 14:22:03 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30B7FB9
        for <netfilter-devel@vger.kernel.org>; Thu,  7 Sep 2023 11:21:59 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6F010C4163C;
        Thu,  7 Sep 2023 10:40:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1694083223;
        bh=21RQWXpD02TqS/zvxOy7m9s2aew4LtFlQ1gyV19ttEY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=IgNs5oYqwpwZb5e1uUlRRGApxXIAGIG4DNJsaCoJPBaW7Ix/P0ZCaTizkeX7ZccBi
         bxQ2DmkK+mEW+6/csnDtJ+4zooo35ZQk8m6ZKoamNtsaCL3P/y6NVdIO/dPELyPdxj
         Wy0EJezKcTPCgzIShSwq3ba+bRzCyZIQj6pwgbpHDHwRtyUpq6XVCKMIM3kllJ4Nas
         ge2xSwmYET9NkkDs/uOJj6MfNgIHZ0tqycGFcFfZtzkL8+bORPzuznASzkMRePAdyq
         Ax84thvbTI3tvALaUzvi0XdhkcABrKnCTApejz8louYLtZvZtxDlYEr0OBZIdBxlQw
         MQNXP0akxImMQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 551C5C4166F;
        Thu,  7 Sep 2023 10:40:23 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/6] netfilter: nftables: exthdr: fix 4-byte stack OOB
 write
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <169408322334.9013.1006951814262380531.git-patchwork-notify@kernel.org>
Date:   Thu, 07 Sep 2023 10:40:23 +0000
References: <20230906162525.11079-2-fw@strlen.de>
In-Reply-To: <20230906162525.11079-2-fw@strlen.de>
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

On Wed,  6 Sep 2023 18:25:07 +0200 you wrote:
> If priv->len is a multiple of 4, then dst[len / 4] can write past
> the destination array which leads to stack corruption.
> 
> This construct is necessary to clean the remainder of the register
> in case ->len is NOT a multiple of the register size, so make it
> conditional just like nft_payload.c does.
> 
> [...]

Here is the summary with links:
  - [net,1/6] netfilter: nftables: exthdr: fix 4-byte stack OOB write
    https://git.kernel.org/netdev/net/c/fd94d9dadee5
  - [net,2/6] netfilter: nfnetlink_osf: avoid OOB read
    https://git.kernel.org/netdev/net/c/f4f8a7803119
  - [net,3/6] netfilter: nf_tables: uapi: Describe NFTA_RULE_CHAIN_ID
    https://git.kernel.org/netdev/net/c/fdc04cc2d5fd
  - [net,4/6] netfilter: nft_set_rbtree: skip sync GC for new elements in this transaction
    https://git.kernel.org/netdev/net/c/2ee52ae94baa
  - [net,5/6] netfilter: ipset: add the missing IP_SET_HASH_WITH_NET0 macro for ip_set_hash_netportnet.c
    https://git.kernel.org/netdev/net/c/050d91c03b28
  - [net,6/6] netfilter: nf_tables: Unbreak audit log reset
    https://git.kernel.org/netdev/net/c/9b5ba5c9c510

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


