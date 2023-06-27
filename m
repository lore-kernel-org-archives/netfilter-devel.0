Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54FABEB64D9
	for <netfilter-devel@archiver.kernel.org>; Tue, 27 Jun 2023 11:00:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230422AbjF0LAZ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 27 Jun 2023 07:00:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229568AbjF0LAY (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 27 Jun 2023 07:00:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87C5D1BE9
        for <netfilter-devel@vger.kernel.org>; Tue, 27 Jun 2023 04:00:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 240676113A
        for <netfilter-devel@vger.kernel.org>; Tue, 27 Jun 2023 11:00:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 84088C433C9;
        Tue, 27 Jun 2023 11:00:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1687863622;
        bh=BYNUTlfP7f+F3b9ynsAQKbHDC50G0DCol5Tq/g0IjEA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=c8hZ+o1ZTaRX/xB01+g4P7JfO861D0RV5G0GltHcQ2Rz0zuG9lKMMrlUfL82cSBLX
         WiiVBQRO12aUUVXYjm/NjzOn9U4EOk8L5j4iezAIEyxFRRftURYxADNU/QQWJQAFtT
         QAFDFsVq7sBGY4LWu0jBjBx7Qmg+rOQK+6c/viFHvpQIzeK19feI18omLW0u0yXL26
         DM0LZfflveOaGwqZXdf8MCPuc0ACDk6mXRGIj4RsoepLv66SSemQyXD68aBGQ+hssr
         qDTrolVXIbEbsKTr6dM4gG9ixTHYF1cwgyZia8gOKS5rv+M3GsMLoFcTN3pvShrh0n
         Yd5TESiq/jCyg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6240CE5380A;
        Tue, 27 Jun 2023 11:00:22 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/6] lib/ts_bm: reset initial match offset for every block
 of text
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168786362239.16210.6293213397519316594.git-patchwork-notify@kernel.org>
Date:   Tue, 27 Jun 2023 11:00:22 +0000
References: <20230627065304.66394-2-pablo@netfilter.org>
In-Reply-To: <20230627065304.66394-2-pablo@netfilter.org>
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

On Tue, 27 Jun 2023 08:52:59 +0200 you wrote:
> From: Jeremy Sowden <jeremy@azazel.net>
> 
> The `shift` variable which indicates the offset in the string at which
> to start matching the pattern is initialized to `bm->patlen - 1`, but it
> is not reset when a new block is retrieved.  This means the implemen-
> tation may start looking at later and later positions in each successive
> block and miss occurrences of the pattern at the beginning.  E.g.,
> consider a HTTP packet held in a non-linear skb, where the HTTP request
> line occurs in the second block:
> 
> [...]

Here is the summary with links:
  - [net,1/6] lib/ts_bm: reset initial match offset for every block of text
    https://git.kernel.org/netdev/net/c/6f67fbf8192d
  - [net,2/6] netfilter: conntrack: dccp: copy entire header to stack buffer, not just basic one
    https://git.kernel.org/netdev/net/c/ff0a3a7d52ff
  - [net,3/6] linux/netfilter.h: fix kernel-doc warnings
    https://git.kernel.org/netdev/net/c/f18e7122cc73
  - [net,4/6] netfilter: nf_conntrack_sip: fix the ct_sip_parse_numerical_param() return value.
    https://git.kernel.org/netdev/net/c/f188d3008748
  - [net,5/6] netfilter: nf_tables: unbind non-anonymous set if rule construction fails
    https://git.kernel.org/netdev/net/c/3e70489721b6
  - [net,6/6] netfilter: nf_tables: fix underflow in chain reference counter
    https://git.kernel.org/netdev/net/c/b389139f12f2

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


