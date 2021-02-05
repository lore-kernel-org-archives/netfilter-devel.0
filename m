Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E24FC433E0
	for <netfilter-devel@archiver.kernel.org>; Fri,  5 Feb 2021 05:51:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CD43B64FA0
	for <netfilter-devel@archiver.kernel.org>; Fri,  5 Feb 2021 05:51:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230394AbhBEFut (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 5 Feb 2021 00:50:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:51508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229586AbhBEFus (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 5 Feb 2021 00:50:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id DE2D764FA0;
        Fri,  5 Feb 2021 05:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612504207;
        bh=qzTqGev1hBUdwU64Jik155APlHGdFqTFwNx27Ifl0PA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Wn82XKYDLUplpHSrRiQjWeL8irYUuO1zGO9K4FlSjtjuM/tcd+pic5pWX2LoO33lG
         FN5mVkCvWKzXBK3MsEeCb+E4JXB2PNW+Vx2o2bQXr6jHhU9aHyOjVdER46sKRpWDSn
         HFO/ejiGMY0ZtP7MPblh0opzmat8GhD3tTBLNqKVNTbw8vbP0AQZwBXrPhZful+5xo
         cHM4rQRsj4kloNN6jaFGx+FBDX5qkSIveB2x1ozCd7Mf4upck9+NC7WzHPm8dZxDzi
         0h9M9usjA6c5cxJJOEwvVqRqcxDan5SWDzA5R4Yq1HgtxmXDz5QgPKVDRhEAsqPRQR
         8rUq0cjj22CiA==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/4] netfilter: xt_recent: Fix attempt to update deleted
 entry
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161250420785.25728.14599762510510974298.git-patchwork-notify@kernel.org>
Date:   Fri, 05 Feb 2021 05:50:07 +0000
References: <20210205001727.2125-2-pablo@netfilter.org>
In-Reply-To: <20210205001727.2125-2-pablo@netfilter.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, kuba@kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Fri,  5 Feb 2021 01:17:24 +0100 you wrote:
> From: Jozsef Kadlecsik <kadlec@mail.kfki.hu>
> 
> When both --reap and --update flag are specified, there's a code
> path at which the entry to be updated is reaped beforehand,
> which then leads to kernel crash. Reap only entries which won't be
> updated.
> 
> [...]

Here is the summary with links:
  - [net,1/4] netfilter: xt_recent: Fix attempt to update deleted entry
    https://git.kernel.org/netdev/net/c/b1bdde33b723
  - [net,2/4] selftests: netfilter: fix current year
    https://git.kernel.org/netdev/net/c/a3005b0f83f2
  - [net,3/4] netfilter: nftables: fix possible UAF over chains from packet path in netns
    https://git.kernel.org/netdev/net/c/767d1216bff8
  - [net,4/4] netfilter: flowtable: fix tcp and udp header checksum update
    https://git.kernel.org/netdev/net/c/8d6bca156e47

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


