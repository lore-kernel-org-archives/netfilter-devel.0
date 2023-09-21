Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A908E7D0AF
	for <netfilter-devel@archiver.kernel.org>; Thu, 21 Sep 2023 22:11:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233018AbjIUWL0 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 21 Sep 2023 18:11:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232577AbjIUWLB (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 21 Sep 2023 18:11:01 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 825008333F
        for <netfilter-devel@vger.kernel.org>; Thu, 21 Sep 2023 10:37:29 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 00A1BC4AF5C;
        Thu, 21 Sep 2023 09:20:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695288023;
        bh=/M9gDZgRl0G96EDpzfP/SP+62+5bj7V8RhOws+XasC8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=X+LNU8qSah75ovGBsLbjtQezeyXFimrCInAwLL1U4iSf09M5vi8iKlz3B6gEpWAOt
         i1TzCyI+bFcfmPaWlMi2u6ooscLB2q/flnbGHJHOqzJaiVv6i3c/QBoeuWpM6cCAH4
         zdfntK5TH56pPzlY5/IUhmejs4g1uUaQ4mvmdJ670cXLIY4SRC7luUOhn+i6qO7sfl
         52WKqze82IZa76Q2b9khbjY5zp3VCmvpXItqZKvLUPVIImknnKMjMqZU2TgUaSV22O
         pQ0MPedJSOIogHyOBLQqxa/o0KGJrHRyHZadNd+WEyJRmk91kBq2eYxTjlSecA+LpO
         eaD+75OF5hrcw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id DC6A6C595C0;
        Thu, 21 Sep 2023 09:20:22 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/3] netfilter: nf_tables: disable toggling dormant table
 state more than once
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <169528802289.18364.6481033051092265766.git-patchwork-notify@kernel.org>
Date:   Thu, 21 Sep 2023 09:20:22 +0000
References: <20230920084156.4192-2-fw@strlen.de>
In-Reply-To: <20230920084156.4192-2-fw@strlen.de>
To:     Florian Westphal <fw@strlen.de>
Cc:     netdev@vger.kernel.org, pabeni@redhat.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org,
        netfilter-devel@vger.kernel.org, cherie.lee@starlabs.sg,
        billy@starlabs.sg, info@starlabs.sg
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hello:

This series was applied to netdev/net.git (main)
by Florian Westphal <fw@strlen.de>:

On Wed, 20 Sep 2023 10:41:49 +0200 you wrote:
> nft -f -<<EOF
> add table ip t
> add table ip t { flags dormant; }
> add chain ip t c { type filter hook input priority 0; }
> add table ip t
> EOF
> 
> [...]

Here is the summary with links:
  - [net,1/3] netfilter: nf_tables: disable toggling dormant table state more than once
    https://git.kernel.org/netdev/net/c/c9bd26513b3a
  - [net,2/3] netfilter: nf_tables: fix memleak when more than 255 elements expired
    https://git.kernel.org/netdev/net/c/cf5000a7787c
  - [net,3/3] netfilter: ipset: Fix race between IPSET_CMD_CREATE and IPSET_CMD_SWAP
    https://git.kernel.org/netdev/net/c/7433b6d2afd5

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


