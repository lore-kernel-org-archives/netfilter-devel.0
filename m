Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE9EDCDB47E
	for <netfilter-devel@archiver.kernel.org>; Wed, 18 Oct 2023 10:10:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229801AbjJRKKZ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 18 Oct 2023 06:10:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229552AbjJRKKY (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 18 Oct 2023 06:10:24 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8233595
        for <netfilter-devel@vger.kernel.org>; Wed, 18 Oct 2023 03:10:23 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 28AE0C433CA;
        Wed, 18 Oct 2023 10:10:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697623823;
        bh=WuXUZXR6Fqzg/9JZerRXRjWDA8H5BHBFcBiSCLvFMiI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=h42bS60IcySv71gfgESP05vUUViquk8C4qlcx5lEbXN3xF69+ZahfgceImdhNw/EY
         0w8NaF4berxwJyWmn1biV0L4NKkEfqT2Z7T7Q7QnquDgP/yxw2v4YTTmMKE5GTO0nt
         Aw1nbAs1ZkdLJ46JwdTjaPEaCJlBiqfzoIIVyYf9Jw/nzM0q99S3ydj37FnLnRw1T0
         tumiZEsPCCqYjgjbIX4imqTw60VFmJr5tKFXCw12h5YSTlq+78i2x87C3M62NWBMJM
         Kob6zHEeXE7ej5/SnXezlzHYl1Tu/Bw1zRJYMag63kVkHSNqRcN95hjcnew8iFlBOb
         /ZbMF0A/98Fkw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 16674C04E27;
        Wed, 18 Oct 2023 10:10:23 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 1/7] netfilter: xt_mangle: only check verdict part of
 return value
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <169762382308.3133.9060197209130107475.git-patchwork-notify@kernel.org>
Date:   Wed, 18 Oct 2023 10:10:23 +0000
References: <20231018085118.10829-2-fw@strlen.de>
In-Reply-To: <20231018085118.10829-2-fw@strlen.de>
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

On Wed, 18 Oct 2023 10:51:05 +0200 you wrote:
> These checks assume that the caller only returns NF_DROP without
> any errno embedded in the upper bits.
> 
> This is fine right now, but followup patches will start to propagate
> such errors to allow kfree_skb_drop_reason() in the called functions,
> those would then indicate 'errno << 8 | NF_STOLEN'.
> 
> [...]

Here is the summary with links:
  - [net-next,1/7] netfilter: xt_mangle: only check verdict part of return value
    https://git.kernel.org/netdev/net-next/c/e15e5027106f
  - [net-next,2/7] netfilter: nf_tables: mask out non-verdict bits when checking return value
    https://git.kernel.org/netdev/net-next/c/4d26ab0086aa
  - [net-next,3/7] netfilter: conntrack: convert nf_conntrack_update to netfilter verdicts
    https://git.kernel.org/netdev/net-next/c/6291b3a67ad5
  - [net-next,4/7] netfilter: nf_nat: mask out non-verdict bits when checking return value
    https://git.kernel.org/netdev/net-next/c/35c038b0a4be
  - [net-next,5/7] netfilter: make nftables drops visible in net dropmonitor
    https://git.kernel.org/netdev/net-next/c/e0d4593140b0
  - [net-next,6/7] netfilter: bridge: convert br_netfilter to NF_DROP_REASON
    https://git.kernel.org/netdev/net-next/c/cf8b7c1a5be7
  - [net-next,7/7] netfilter: nf_tables: de-constify set commit ops function argument
    https://git.kernel.org/netdev/net-next/c/256001672153

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


