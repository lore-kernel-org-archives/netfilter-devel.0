Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A8EBC433B4
	for <netfilter-devel@archiver.kernel.org>; Fri,  7 May 2021 23:20:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E4B5E61151
	for <netfilter-devel@archiver.kernel.org>; Fri,  7 May 2021 23:20:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229920AbhEGXVM (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 7 May 2021 19:21:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:51280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229880AbhEGXVL (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 7 May 2021 19:21:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 5BE62613C8;
        Fri,  7 May 2021 23:20:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620429611;
        bh=THr0F/hFQpqBAth+hbYvknveZ4BrYgFvYTKEURFHNxM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Vr/WpDjV53YHbL7fV5Zvnlfsr6/WJ3QEEfaImMagGNcqFVmoEoKRTnoO+5qDkNUox
         8fy51aV3oxP3cWvjfi7SDmpSa9y+HkiK8p7JkmyUpPiiIOh0JOXO5Nz1ypA00JvrZ8
         I4LlkGGOhLxJkDQKE1B6Mr3t8f+ZnXGRwf7hFj+DmBh8+udXZgYB9AirRw8LnArPFx
         cY+ueSq2GLrACucbrQ33jJPeMfgZ9yFLye9PhY9m6VbRArWFoAmOMjFDs6ymhDRyat
         isdtjjoKkxl2pmKGyQp5sEVfBM7pqKp6DiZZB6ncYQN9Mcqn/+DVg32lYjUiUMkd9y
         epIZ8IfOr52Rg==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/8] netfilter: xt_SECMARK: add new revision to fix
 structure layout
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162042961130.24697.11074658314120530630.git-patchwork-notify@kernel.org>
Date:   Fri, 07 May 2021 23:20:11 +0000
References: <20210507174739.1850-2-pablo@netfilter.org>
In-Reply-To: <20210507174739.1850-2-pablo@netfilter.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, kuba@kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Fri,  7 May 2021 19:47:32 +0200 you wrote:
> This extension breaks when trying to delete rules, add a new revision to
> fix this.
> 
> Fixes: 5e6874cdb8de ("[SECMARK]: Add xtables SECMARK target")
> Signed-off-by: Phil Sutter <phil@nwl.cc>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> 
> [...]

Here is the summary with links:
  - [net,1/8] netfilter: xt_SECMARK: add new revision to fix structure layout
    https://git.kernel.org/netdev/net/c/c7d13358b6a2
  - [net,2/8] netfilter: arptables: use pernet ops struct during unregister
    https://git.kernel.org/netdev/net/c/43016d02cf6e
  - [net,3/8] netfilter: nfnetlink: add a missing rcu_read_unlock()
    https://git.kernel.org/netdev/net/c/7072a355ba19
  - [net,4/8] netfilter: nfnetlink_osf: Fix a missing skb_header_pointer() NULL check
    https://git.kernel.org/netdev/net/c/5e024c325406
  - [net,5/8] netfilter: remove BUG_ON() after skb_header_pointer()
    https://git.kernel.org/netdev/net/c/198ad973839c
  - [net,6/8] netfilter: nftables: Fix a memleak from userdata error path in new objects
    https://git.kernel.org/netdev/net/c/85dfd816fabf
  - [net,7/8] netfilter: nftables: avoid overflows in nft_hash_buckets()
    https://git.kernel.org/netdev/net/c/a54754ec9891
  - [net,8/8] netfilter: nftables: avoid potential overflows on 32bit arches
    https://git.kernel.org/netdev/net/c/6c8774a94e6a

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


