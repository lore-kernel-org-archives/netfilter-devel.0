Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43C4CC001B0
	for <netfilter-devel@archiver.kernel.org>; Wed, 16 Aug 2023 10:21:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243853AbjHPKVU (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 16 Aug 2023 06:21:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243877AbjHPKUw (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 16 Aug 2023 06:20:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2266326B7
        for <netfilter-devel@vger.kernel.org>; Wed, 16 Aug 2023 03:20:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1A6216271C
        for <netfilter-devel@vger.kernel.org>; Wed, 16 Aug 2023 10:20:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7CA07C433CA;
        Wed, 16 Aug 2023 10:20:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1692181222;
        bh=doM3/PdM9uIr1zyCkGyE2Q2VUWaBnTtjGUUQp/b8+To=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=SoCHY/xGytK7wKRq8kc3m+kWYFirWYYwwXGJjt0QM5bHlxt0fStLIrvz9Om8n1Ocw
         0eOpz/uJ+kNLcez9Cp29P0fZ6Snlq4L2/5iBqR/6G0xn7VtP5U82/uGMwf9FrN5Cg8
         lsYFBFpRWye4/PVr2mZ6tyXQXEthJFQ+tT1xtW0HcIVQNbo6B3hyX91U8Sv3BJ/Xn5
         tuO910jRWvajeOwJ1Y61lAgraCysqfHH8zVsiQ9XUdfXxpEY6UrjcNozs3goeQzyYz
         aQI6GxXkluzWjXwm6j+G0cc2Vk8dpTBwnhTvxhlmWtKOGXrQMIsgRr5JjKMJDXCtw5
         3OVvLMzuzSOVg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 62378E93B34;
        Wed, 16 Aug 2023 10:20:22 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/9] netfilter: nf_tables: fix false-positive lockdep
 splat
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <169218122239.20553.16931689912170452244.git-patchwork-notify@kernel.org>
Date:   Wed, 16 Aug 2023 10:20:22 +0000
References: <20230815223011.7019-2-fw@strlen.de>
In-Reply-To: <20230815223011.7019-2-fw@strlen.de>
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

On Wed, 16 Aug 2023 00:29:51 +0200 you wrote:
> ->abort invocation may cause splat on debug kernels:
> 
> WARNING: suspicious RCU usage
> net/netfilter/nft_set_pipapo.c:1697 suspicious rcu_dereference_check() usage!
> [..]
> rcu_scheduler_active = 2, debug_locks = 1
> 1 lock held by nft/133554: [..] (nft_net->commit_mutex){+.+.}-{3:3}, at: nf_tables_valid_genid
> [..]
>  lockdep_rcu_suspicious+0x1ad/0x260
>  nft_pipapo_abort+0x145/0x180
>  __nf_tables_abort+0x5359/0x63d0
>  nf_tables_abort+0x24/0x40
>  nfnetlink_rcv+0x1a0a/0x22c0
>  netlink_unicast+0x73c/0x900
>  netlink_sendmsg+0x7f0/0xc20
>  ____sys_sendmsg+0x48d/0x760
> 
> [...]

Here is the summary with links:
  - [net,1/9] netfilter: nf_tables: fix false-positive lockdep splat
    https://git.kernel.org/netdev/net/c/b9f052dc68f6
  - [net,2/9] netfilter: nf_tables: fix kdoc warnings after gc rework
    https://git.kernel.org/netdev/net/c/08713cb006b6
  - [net,3/9] netfilter: nf_tables: deactivate catchall elements in next generation
    https://git.kernel.org/netdev/net/c/90e5b3462efa
  - [net,4/9] netfilter: nf_tables: don't fail inserts if duplicate has expired
    https://git.kernel.org/netdev/net/c/7845914f45f0
  - [net,5/9] netfilter: set default timeout to 3 secs for sctp shutdown send and recv state
    https://git.kernel.org/netdev/net/c/9bfab6d23a28
  - [net,6/9] ipvs: fix racy memcpy in proc_do_sync_threshold
    https://git.kernel.org/netdev/net/c/5310760af1d4
  - [net,7/9] netfilter: nf_tables: fix GC transaction races with netns and netlink event exit path
    https://git.kernel.org/netdev/net/c/6a33d8b73dfa
  - [net,8/9] netfilter: nf_tables: GC transaction race with netns dismantle
    https://git.kernel.org/netdev/net/c/02c6c24402bf
  - [net,9/9] netfilter: nft_dynset: disallow object maps
    https://git.kernel.org/netdev/net/c/23185c6aed1f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


