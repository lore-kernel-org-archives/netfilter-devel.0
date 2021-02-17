Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-21.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C0CEC433E0
	for <netfilter-devel@archiver.kernel.org>; Wed, 17 Feb 2021 21:40:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D145C64E76
	for <netfilter-devel@archiver.kernel.org>; Wed, 17 Feb 2021 21:40:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231717AbhBQVkt (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 17 Feb 2021 16:40:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:53560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231286AbhBQVks (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 17 Feb 2021 16:40:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 474D564E7A;
        Wed, 17 Feb 2021 21:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613598008;
        bh=C0HVsCRKKaDg3pRmNF1I2inmMUjrw5hd/iR5exeW/iU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Xb3+4Fdkay7S2BxKWlYK7SrMZcQ7x2I+b2M5iWzzPwqUWYiJJ60oPinCSTy/pXO5v
         BYPFWq6Wrq/PDDUNXr8Vf8+heY5NXaSQfXWiyqr3nKNBt1V0fjxN5Ftizr+56/LgzJ
         LYLFKt36z6GQPrt7v+ZfmiWHju2X1QQnrva5oGJ6cAu4CpLf7u634Gy5QNdLISWIH9
         yK+/wX7dUvK2hr9unGj5AbuITM8IGbMCiWiyw0Hbnrhl7CCO0I0zRxgXFalSx2Ag4u
         Div6jnBECKmmoyesJLt6mDks3Nhv3mS3nfkS0eG+pnvszdpr15GA4KpTfHfl85gZj5
         SkydJdRnUZp/w==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 1/3] netfilter: nftables: add helper function to
 release one table
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161359800821.6903.13300035200453538751.git-patchwork-notify@kernel.org>
Date:   Wed, 17 Feb 2021 21:40:08 +0000
References: <20210217190332.21722-2-pablo@netfilter.org>
In-Reply-To: <20210217190332.21722-2-pablo@netfilter.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, kuba@kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Wed, 17 Feb 2021 20:03:30 +0100 you wrote:
> Add a function to release one table.
> 
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
>  net/netfilter/nf_tables_api.c | 75 +++++++++++++++++++----------------
>  1 file changed, 40 insertions(+), 35 deletions(-)

Here is the summary with links:
  - [net-next,1/3] netfilter: nftables: add helper function to release one table
    https://git.kernel.org/netdev/net-next/c/fd020332c156
  - [net-next,2/3] netfilter: nftables: add helper function to release hooks of one single table
    https://git.kernel.org/netdev/net-next/c/00dfe9bebdf0
  - [net-next,3/3] netfilter: nftables: introduce table ownership
    https://git.kernel.org/netdev/net-next/c/6001a930ce03

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


