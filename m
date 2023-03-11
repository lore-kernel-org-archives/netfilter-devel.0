Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15FA0C61DA4
	for <netfilter-devel@archiver.kernel.org>; Sat, 11 Mar 2023 05:50:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229645AbjCKFuZ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 11 Mar 2023 00:50:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229455AbjCKFuY (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 11 Mar 2023 00:50:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68E81659F;
        Fri, 10 Mar 2023 21:50:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 07B256069B;
        Sat, 11 Mar 2023 05:50:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 61C29C4339B;
        Sat, 11 Mar 2023 05:50:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678513822;
        bh=cEvt3ZhBfrja5tN7aTxCXLI507lYMVASgUZ8mx8gUlM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=SiIlnjIfuj06Rcw+muX2omnqkRBCKEZLqqnTDiYE6Yswvkpaq6m2I7CsG8koyryUv
         8VwDQn8Afdp9DJHsQLSRGZhoEVsbaqJe8IJQzBdNPyClm3rOFhKAhHyOTgNym5mXX6
         LBqMqk0C6I+yjX3NKyBkXfvZe+KFWgnHxsB4P5CwsmFuqfdYF+5CRme7knIJpwzJqM
         oRPdnnlSdx6SyA90ror6gJryyOcj159W4COGEprYHYbh/3Gar1/ik/zVCpwDrFiefB
         l2uGP8kSlmC1kvzFqZXDuqf+m4QdSKp3MrCPs7l6wig3PD9yK+g8e3UID9NMc7hdG6
         q+UsurgBmCH0w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 48881E270C7;
        Sat, 11 Mar 2023 05:50:22 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/4] netfilter: nft_nat: correct length for loading
 protocol registers
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167851382229.22535.17013828340193833705.git-patchwork-notify@kernel.org>
Date:   Sat, 11 Mar 2023 05:50:22 +0000
References: <20230309174655.69816-2-pablo@netfilter.org>
In-Reply-To: <20230309174655.69816-2-pablo@netfilter.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hello:

This series was applied to netdev/net.git (main)
by Pablo Neira Ayuso <pablo@netfilter.org>:

On Thu,  9 Mar 2023 18:46:52 +0100 you wrote:
> From: Jeremy Sowden <jeremy@azazel.net>
> 
> The values in the protocol registers are two bytes wide.  However, when
> parsing the register loads, the code currently uses the larger 16-byte
> size of a `union nf_inet_addr`.  Change it to use the (correct) size of
> a `union nf_conntrack_man_proto` instead.
> 
> [...]

Here is the summary with links:
  - [net,1/4] netfilter: nft_nat: correct length for loading protocol registers
    https://git.kernel.org/netdev/net/c/068d82e75d53
  - [net,2/4] netfilter: nft_masq: correct length for loading protocol registers
    https://git.kernel.org/netdev/net/c/ec2c5917eb85
  - [net,3/4] netfilter: nft_redir: correct length for loading protocol registers
    https://git.kernel.org/netdev/net/c/1f617b6b4c7a
  - [net,4/4] netfilter: nft_redir: correct value of inet type `.maxattrs`
    https://git.kernel.org/netdev/net/c/493924519b1f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


