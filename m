Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2F85C7113B
	for <netfilter-devel@archiver.kernel.org>; Thu, 24 Aug 2023 09:01:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234469AbjHXJAz (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 24 Aug 2023 05:00:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237551AbjHXJA2 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 24 Aug 2023 05:00:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81066172A
        for <netfilter-devel@vger.kernel.org>; Thu, 24 Aug 2023 02:00:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 00C5E667F1
        for <netfilter-devel@vger.kernel.org>; Thu, 24 Aug 2023 09:00:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5E04EC433CA;
        Thu, 24 Aug 2023 09:00:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1692867624;
        bh=9XYVyLZpKLxuO1xErncklKKu8T/pfo2AWEYbB5+ovjg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=HPpo5lr/tKmHZHrRQspMZ23aPRxFF7DIQVRFWAOE4/xsc1DNInP/q+bMlGkYf69Kc
         J/owr2y/1Q7P/v4DNEPMPpeZ4G19iuj55Pu7BHrSCNxCy3AOJTLDwd9uKkxj/JbhxX
         //swfIOnvLNbf7PJjNlH9HsFv5POxt3uupbi/gV36ageeLCoWWaAZAmiW78C74Kr3I
         qz7IdYTpKqGe+rKtzei1sBYtWdJnl5wpPJgm7hJTHZTBQj3ITZRYyykrLbxvwsLMOW
         CP5bgOWBSNuXXl1SefUlSCyp/aNFYZWO63QZxq1ql9cQZDt6WWiySSvBYPvEKf8V3j
         oh0F1h1DqVtMA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 3D6EDE33093;
        Thu, 24 Aug 2023 09:00:24 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/6] netfilter: nf_tables: validate all pending tables
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <169286762424.5211.395317324638298411.git-patchwork-notify@kernel.org>
Date:   Thu, 24 Aug 2023 09:00:24 +0000
References: <20230823152711.15279-2-fw@strlen.de>
In-Reply-To: <20230823152711.15279-2-fw@strlen.de>
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

On Wed, 23 Aug 2023 17:26:49 +0200 you wrote:
> We have to validate all tables in the transaction that are in
> VALIDATE_DO state, the blamed commit below did not move the break
> statement to its right location so we only validate one table.
> 
> Moreover, we can't init table->validate to _SKIP when a table object
> is allocated.
> 
> [...]

Here is the summary with links:
  - [net,1/6] netfilter: nf_tables: validate all pending tables
    https://git.kernel.org/netdev/net/c/4b80ced971b0
  - [net,2/6] netfilter: nf_tables: flush pending destroy work before netlink notifier
    https://git.kernel.org/netdev/net/c/2c9f0293280e
  - [net,3/6] netfilter: nf_tables: GC transaction race with abort path
    https://git.kernel.org/netdev/net/c/720344340fb9
  - [net,4/6] netfilter: nf_tables: use correct lock to protect gc_list
    https://git.kernel.org/netdev/net/c/8357bc946a2a
  - [net,5/6] netfilter: nf_tables: fix out of memory error handling
    https://git.kernel.org/netdev/net/c/5e1be4cdc98c
  - [net,6/6] netfilter: nf_tables: defer gc run if previous batch is still pending
    https://git.kernel.org/netdev/net/c/8e51830e29e1

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


