Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A27FC54E94
	for <netfilter-devel@archiver.kernel.org>; Wed, 25 Jan 2023 03:10:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229778AbjAYDKY (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 24 Jan 2023 22:10:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229754AbjAYDKX (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 24 Jan 2023 22:10:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BCBB2367A;
        Tue, 24 Jan 2023 19:10:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 35775B81892;
        Wed, 25 Jan 2023 03:10:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C9102C4339B;
        Wed, 25 Jan 2023 03:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674616216;
        bh=24Jiq9WinHM7H/7vVdn0/MneZbxBoh7NZy+b5NRXnWs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=FcFAQe/sUZbNpfNe/u6CSewY6Q5YzX1+PIEyAcPNAi62+/oiXyjgf078gBQuEvGlv
         4VkZR2hXIEvUPe3jyuNZgh2KqPBPSrM4mCY7WfPEtgPOW2wOFkGzP+SObwaKcuwllN
         iOkCAEZ+fhD3NoCagWRVYPJdQPBCXJMQbRVlfYomUKSMhP1FJleqsF3XuqOrUI8pmz
         KxcsQ8uTMaqmEhqVlanNTQvBfjzin9L0WM3IQ/I93HtjKcvI+0xEL0wtq0FYi33Get
         CsxmXKrWKL8k2c68i4oiOE7kuzm+6C1pzgy0U/TWBWsWDTLE/SaS7FETtMOUtyemQy
         AV8wJWAnPbnUw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id AEBA1E21EE1;
        Wed, 25 Jan 2023 03:10:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/4] netfilter: conntrack: fix vtag checks for
 ABORT/SHUTDOWN_COMPLETE
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167461621671.15286.11489367104029709339.git-patchwork-notify@kernel.org>
Date:   Wed, 25 Jan 2023 03:10:16 +0000
References: <20230124183933.4752-2-pablo@netfilter.org>
In-Reply-To: <20230124183933.4752-2-pablo@netfilter.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by Pablo Neira Ayuso <pablo@netfilter.org>:

On Tue, 24 Jan 2023 19:39:30 +0100 you wrote:
> From: Sriram Yagnaraman <sriram.yagnaraman@est.tech>
> 
> RFC 9260, Sec 8.5.1 states that for ABORT/SHUTDOWN_COMPLETE, the chunk
> MUST be accepted if the vtag of the packet matches its own tag and the
> T bit is not set OR if it is set to its peer's vtag and the T bit is set
> in chunk flags. Otherwise the packet MUST be silently dropped.
> 
> [...]

Here is the summary with links:
  - [net,1/4] netfilter: conntrack: fix vtag checks for ABORT/SHUTDOWN_COMPLETE
    https://git.kernel.org/netdev/net/c/a9993591fa94
  - [net,2/4] netfilter: conntrack: fix bug in for_each_sctp_chunk
    https://git.kernel.org/netdev/net/c/98ee00774525
  - [net,3/4] Revert "netfilter: conntrack: add sctp DATA_SENT state"
    https://git.kernel.org/netdev/net/c/13bd9b31a969
  - [net,4/4] netfilter: conntrack: unify established states for SCTP paths
    https://git.kernel.org/netdev/net/c/a44b7651489f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


