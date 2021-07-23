Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 344D8C4320A
	for <netfilter-devel@archiver.kernel.org>; Fri, 23 Jul 2021 16:50:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1DFF660ED4
	for <netfilter-devel@archiver.kernel.org>; Fri, 23 Jul 2021 16:50:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231284AbhGWQJd (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 23 Jul 2021 12:09:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:35868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229847AbhGWQJc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 23 Jul 2021 12:09:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 32C3A60E9C;
        Fri, 23 Jul 2021 16:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627059006;
        bh=3/8tnojzEiEYMyqb8KSh1cm1Fsx5qkzL4Qylhfy0HOQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Mee9nr9pD1QumHzYFS/TZRvlcDuT86s7GiFcTpfBE0vr/JcuFEYdDlKbG/moF7Aah
         p081LZO5MyefV3TRwAPhOns7rNeR63H5J8VX5nzA7aJtoxjpJ5BicN5ugjEk5tdwq3
         0i1Q1AHga0l5WtHBvID5pBCZumJSc6o8DDrD+SeO/+2g+u3xyd29nsw75+FOYuJQAB
         3kkSfdKmNGaOeeAas4Adt/3xrDg6ICwcsiw/DC8Wbhtt0fEgol8USUibW2BTkdNO0m
         osZCwReqDuhUwkFJbtnN88kfaiPVnndS/G2g1RHGh+7o8ok0Yob8Qqw0fogYkL2nEN
         mC8GmdqHeGMQA==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/6] netfilter: nf_tables: fix audit memory leak in
 nf_tables_commit
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162705900614.21133.233240311011263145.git-patchwork-notify@kernel.org>
Date:   Fri, 23 Jul 2021 16:50:06 +0000
References: <20210723155412.17916-2-pablo@netfilter.org>
In-Reply-To: <20210723155412.17916-2-pablo@netfilter.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, kuba@kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Fri, 23 Jul 2021 17:54:07 +0200 you wrote:
> From: Dongliang Mu <mudongliangabcd@gmail.com>
> 
> In nf_tables_commit, if nf_tables_commit_audit_alloc fails, it does not
> free the adp variable.
> 
> Fix this by adding nf_tables_commit_audit_free which frees
> the linked list with the head node adl.
> 
> [...]

Here is the summary with links:
  - [net,1/6] netfilter: nf_tables: fix audit memory leak in nf_tables_commit
    https://git.kernel.org/netdev/net/c/cfbe3650dd3e
  - [net,2/6] netfilter: flowtable: avoid possible false sharing
    https://git.kernel.org/netdev/net/c/32c3973d8083
  - [net,3/6] netfilter: nft_last: avoid possible false sharing
    https://git.kernel.org/netdev/net/c/32953df7a6eb
  - [net,4/6] netfilter: conntrack: adjust stop timestamp to real expiry value
    https://git.kernel.org/netdev/net/c/30a56a2b8818
  - [net,5/6] netfilter: nft_nat: allow to specify layer 4 protocol NAT only
    https://git.kernel.org/netdev/net/c/a33f387ecd5a
  - [net,6/6] netfilter: nfnl_hook: fix unused variable warning
    https://git.kernel.org/netdev/net/c/217e26bd87b2

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


