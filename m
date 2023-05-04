Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BEF7C7EE21
	for <netfilter-devel@archiver.kernel.org>; Thu,  4 May 2023 09:10:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229642AbjEDJKZ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 4 May 2023 05:10:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229585AbjEDJKY (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 4 May 2023 05:10:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7D51A0
        for <netfilter-devel@vger.kernel.org>; Thu,  4 May 2023 02:10:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 29F9D6328E
        for <netfilter-devel@vger.kernel.org>; Thu,  4 May 2023 09:10:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8413BC433D2;
        Thu,  4 May 2023 09:10:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1683191421;
        bh=joHPPU/3x0qCSXV2ad98zX5PwaX7fzHVNn5m1qSwO6I=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=SHpxKuI4RXF4fqoSYKRkSPIe9rOVaPTilVmVIlEYlmlp/M+vb6/ySJe9Gfre19Qvf
         9h9U6AiUBuekMjTw51WBQO8/f1H5v4BgHSEvScT6RaxrgY/zamtE3PXzGaCOfRKVgl
         Z0P1egB5Qgi+xikHncSro9T7fLc2nVA5H4VGVEVc9sUW0mtAyiTjdRu627D43hRh/8
         4fjx0G+vHLZg1KG3ctILxu3Ru6kSRJckwoJTa9aEViKN+uWBh4BnYKmDdQyYg9umV3
         Yg5VkObu3S41tDp02tWOZSMDlrUga8xqUn1ef9pItNtELuIVPMMZpCQ8uRPOyxfe/m
         R4WaycEJgA2og==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6617BC395C8;
        Thu,  4 May 2023 09:10:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/1] netfilter: nf_tables: fix ct untracked match breakage
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168319142141.23388.7612293400133775589.git-patchwork-notify@kernel.org>
Date:   Thu, 04 May 2023 09:10:21 +0000
References: <20230503201143.12310-2-pablo@netfilter.org>
In-Reply-To: <20230503201143.12310-2-pablo@netfilter.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Pablo Neira Ayuso <pablo@netfilter.org>:

On Wed,  3 May 2023 22:11:43 +0200 you wrote:
> From: Florian Westphal <fw@strlen.de>
> 
> "ct untracked" no longer works properly due to erroneous NFT_BREAK.
> We have to check ctinfo enum first.
> 
> Fixes: d9e789147605 ("netfilter: nf_tables: avoid retpoline overhead for some ct expression calls")
> Reported-by: Rvfg <i@rvf6.com>
> Link: https://marc.info/?l=netfilter&m=168294996212038&w=2
> Signed-off-by: Florian Westphal <fw@strlen.de>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> 
> [...]

Here is the summary with links:
  - [net,1/1] netfilter: nf_tables: fix ct untracked match breakage
    https://git.kernel.org/netdev/net/c/f057b63bc11d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


