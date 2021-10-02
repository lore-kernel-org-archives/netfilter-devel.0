Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8219BC433EF
	for <netfilter-devel@archiver.kernel.org>; Sat,  2 Oct 2021 13:10:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5A1A461B23
	for <netfilter-devel@archiver.kernel.org>; Sat,  2 Oct 2021 13:10:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233181AbhJBNLx (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 2 Oct 2021 09:11:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:56498 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232821AbhJBNLx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 2 Oct 2021 09:11:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 9252261AF7;
        Sat,  2 Oct 2021 13:10:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633180207;
        bh=gdsG5d34FJYu48qDKbrtX1X1UiNQVwNBg5ZllrUN9cc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=KR5cR9l1uaRncMEU9wENbA5YVQL7FxC4ecaS4dWyOKedy0ldQK+uylIKq7g6JlwWE
         ngNIoGAF43DBJ6mMhR82npMGycJvR6noDAr+pHDjWnvEZX/XHTkWcr+Lkco+1KTbTK
         RJNPBrBwHUG1RS4btkShAKOqMxd8WG89QDllODm2jDAkosXl2rlAf7ACbQPu7K7Zsr
         EQztIkpYVwT301MKCnjG+VfLmBHpauXWjOAupwgAkriKvAHd0sgi5ATPn7863QP2Gm
         qxyuXrV0NqS9BQ57KBRRIbIPghzkkhriPoYF2Rxkeh1QmVC2RchTI1O82gXtYQ77BC
         5cxQwsG0j9V2A==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/4] netfilter: conntrack: fix boot failure with
 nf_conntrack.enable_hooks=1
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163318020753.24030.7023263983396784844.git-patchwork-notify@kernel.org>
Date:   Sat, 02 Oct 2021 13:10:07 +0000
References: <20211002100833.21411-2-pablo@netfilter.org>
In-Reply-To: <20211002100833.21411-2-pablo@netfilter.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, kuba@kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Sat,  2 Oct 2021 12:08:30 +0200 you wrote:
> From: Florian Westphal <fw@strlen.de>
> 
> This is a revert of
> 7b1957b049 ("netfilter: nf_defrag_ipv4: use net_generic infra")
> and a partial revert of
> 8b0adbe3e3 ("netfilter: nf_defrag_ipv6: use net_generic infra").
> 
> [...]

Here is the summary with links:
  - [net,1/4] netfilter: conntrack: fix boot failure with nf_conntrack.enable_hooks=1
    https://git.kernel.org/netdev/net/c/339031bafe6b
  - [net,2/4] netfilter: nf_tables: add position handle in event notification
    https://git.kernel.org/netdev/net/c/e189ae161dd7
  - [net,3/4] netfilter: nf_tables: reverse order in rule replacement expansion
    https://git.kernel.org/netdev/net/c/2c964c558641
  - [net,4/4] netfilter: nf_tables: honor NLM_F_CREATE and NLM_F_EXCL in event notification
    https://git.kernel.org/netdev/net/c/6fb721cf7818

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


