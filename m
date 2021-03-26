Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41462C433DB
	for <netfilter-devel@archiver.kernel.org>; Fri, 26 Mar 2021 21:51:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3CAFD61976
	for <netfilter-devel@archiver.kernel.org>; Fri, 26 Mar 2021 21:51:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230249AbhCZVun (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 26 Mar 2021 17:50:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:42756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230043AbhCZVuL (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 26 Mar 2021 17:50:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 3BA7A61A27;
        Fri, 26 Mar 2021 21:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616795411;
        bh=8KfFO4xLxph24i2E9MikvFUHDdoNvPlr0M2rAy8ftwc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=K1yQTXF3DSoK/OV/VkD5dv6kiCnQMAAXCf5KPGq7TAtjUS45e6jQ9Mt0kp+A3LE6U
         KM2oXli4LwSL888cdMGS9b9IsDvsJdqlq9AXvFoyoYQMzOxgprM6czYgiKb9b73kZW
         O1KtTrjrKFHnZxxgyL6gcoEaF5xDZy6ZaZj/kCaQeuICzn1D+ROQSh5dHTG3NDyQMa
         TLWJ5xQB6a8c5uGDjNXb4g3p68ogGyMhDbwDewun5ZvVtXXzoglG8RXMHweGk0SXM9
         y/klQPPVe2tEJyYbVMn+kok6HHvOr2s6rbtHBkTFSGOKWapjM+O5IlknWrgnZ81jYr
         Q5LgW53jNBaQw==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] docs: nf_flowtable: fix compilation and warnings
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161679541104.17455.10378416343031812056.git-patchwork-notify@kernel.org>
Date:   Fri, 26 Mar 2021 21:50:11 +0000
References: <20210325211018.5548-1-pablo@netfilter.org>
In-Reply-To: <20210325211018.5548-1-pablo@netfilter.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, kuba@kernel.org, sfr@canb.auug.org.au
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Thu, 25 Mar 2021 22:10:16 +0100 you wrote:
> ... cannot be used in block quote, it breaks compilation, remove it.
> 
> Fix warnings due to missing blank line such as:
> 
> net-next/Documentation/networking/nf_flowtable.rst:142: WARNING: Block quote ends without a blank line; unexpected unindent.
> 
> Fixes: 143490cde566 ("docs: nf_flowtable: update documentation with enhancements")
> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> 
> [...]

Here is the summary with links:
  - [net-next] docs: nf_flowtable: fix compilation and warnings
    https://git.kernel.org/netdev/net-next/c/794d9b25817a

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


