Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90474E936E7
	for <netfilter-devel@archiver.kernel.org>; Wed,  4 Oct 2023 21:30:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243933AbjJDVad (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 4 Oct 2023 17:30:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243954AbjJDVac (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 4 Oct 2023 17:30:32 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEA6790
        for <netfilter-devel@vger.kernel.org>; Wed,  4 Oct 2023 14:30:28 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 884B8C433C7;
        Wed,  4 Oct 2023 21:30:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1696455028;
        bh=PKLIN1crRYWBJUMODHzc6hZBbUNq1h2NBIRSnzC7bJs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=GjqKOdwCcYFOic9T6ObXXaxJHd5PBYZfVoSP0Kc56c4+gPgjWxVCLTxFEYtZ3xZ0+
         LZ0bttA73tD9pMQHPR9JcUzzK3s1LENteP4OXHXhyeIJdLMgrdu1U6EO2IXfWtSWY/
         CJLrAjnTxSEH3Er2uKj7TNMIfijr5IQUzmJkkMD29P9oN/65o5ZN9Zqf/0IJ9nUnYb
         lhZtfWMBbda2eIuNyF2UxOZz00V/NusyIhtPlx1y6LZYIg/LJe0J6kgNiCSyQuLwTT
         vVc9lw7SmB0NFLjVVh5Zllf0VZecQyRkz8NPtLdUsROU/COlmEpX0u8AEvSlEZqvgy
         1HRYg+lvup03w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 72689E632D6;
        Wed,  4 Oct 2023 21:30:28 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 1/4] netfilter: nf_nat: undo erroneous tcp edemux
 lookup after port clash
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <169645502846.6604.14166144214217944082.git-patchwork-notify@kernel.org>
Date:   Wed, 04 Oct 2023 21:30:28 +0000
References: <20230928144916.18339-2-fw@strlen.de>
In-Reply-To: <20230928144916.18339-2-fw@strlen.de>
To:     Florian Westphal <fw@strlen.de>
Cc:     netdev@vger.kernel.org, pabeni@redhat.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org,
        netfilter-devel@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (main)
by Florian Westphal <fw@strlen.de>:

On Thu, 28 Sep 2023 16:48:58 +0200 you wrote:
> In commit 03a3ca37e4c6 ("netfilter: nf_nat: undo erroneous tcp edemux lookup")
> I fixed a problem with source port clash resolution and DNAT.
> 
> A very similar issue exists with REDIRECT (DNAT to local address) and
> port rewrites.
> 
> Consider two port redirections done at prerouting hook:
> 
> [...]

Here is the summary with links:
  - [net-next,1/4] netfilter: nf_nat: undo erroneous tcp edemux lookup after port clash
    https://git.kernel.org/netdev/net-next/c/e27c3295114b
  - [net-next,2/4] selftests: netfilter: test nat source port clash resolution interaction with tcp early demux
    https://git.kernel.org/netdev/net-next/c/117e149e26d1
  - [net-next,3/4] netfilter: nf_tables: missing extended netlink error in lookup functions
    https://git.kernel.org/netdev/net-next/c/aee1f692bfed
  - [net-next,4/4] netfilter: nf_tables: Utilize NLA_POLICY_NESTED_ARRAY
    https://git.kernel.org/netdev/net-next/c/013714bf3e12

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


