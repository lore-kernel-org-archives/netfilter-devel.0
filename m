Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53B19EB64DD
	for <netfilter-devel@archiver.kernel.org>; Thu,  6 Jul 2023 09:20:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231905AbjGFJU0 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 6 Jul 2023 05:20:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229527AbjGFJUY (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 6 Jul 2023 05:20:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62BAB1BD4
        for <netfilter-devel@vger.kernel.org>; Thu,  6 Jul 2023 02:20:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E77D7618DC
        for <netfilter-devel@vger.kernel.org>; Thu,  6 Jul 2023 09:20:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5128DC433C9;
        Thu,  6 Jul 2023 09:20:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1688635222;
        bh=2INGgEDHKXSagiP46fEaa51hlLtiaD991u5jIm6fMFA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=dnAvELrg96Jne7r5x6U/AXdgJq/sleKoCjSIUFI7J3gwomD3o1fbiOHeTGARPCbVR
         Xs8BzNvuxd3C3jerCHxquBQ7sQwS7NqwonwEJuknOfadDHOXHUfo0+WIz2+dr/8VUF
         gjpXtiPtrTRZpL3Kakq6ho8DRJnOr5PNWgq9mJahvaB1S/oXGVGrRIfotEowT/SpUQ
         SxyYGsCSr6rVcK4g4Q5ilbMABiI5ADUHv5SBfl4F22RR7lukMPXFcEMaItBjzQitJ7
         m7W3qyAufJD7MHQIev4ci2VeJU4IL4Djs4mYj2Cw7hRb15WzU+1Ce3SkJUp+1PsF2x
         DY629x9h/YCOA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 345CCE5381B;
        Thu,  6 Jul 2023 09:20:22 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/6] netfilter: nf_tables: report use refcount overflow
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168863522221.622.7964673708466321007.git-patchwork-notify@kernel.org>
Date:   Thu, 06 Jul 2023 09:20:22 +0000
References: <20230705230406.52201-2-pablo@netfilter.org>
In-Reply-To: <20230705230406.52201-2-pablo@netfilter.org>
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

On Thu,  6 Jul 2023 01:04:01 +0200 you wrote:
> Overflow use refcount checks are not complete.
> 
> Add helper function to deal with object reference counter tracking.
> Report -EMFILE in case UINT_MAX is reached.
> 
> nft_use_dec() splats in case that reference counter underflows,
> which should not ever happen.
> 
> [...]

Here is the summary with links:
  - [net,1/6] netfilter: nf_tables: report use refcount overflow
    https://git.kernel.org/netdev/net/c/1689f25924ad
  - [net,2/6] netfilter: conntrack: gre: don't set assured flag for clash entries
    https://git.kernel.org/netdev/net/c/8a9dc07ba924
  - [net,3/6] netfilter: conntrack: Avoid nf_ct_helper_hash uses after free
    https://git.kernel.org/netdev/net/c/6eef7a2b9338
  - [net,4/6] netfilter: conntrack: don't fold port numbers into addresses before hashing
    https://git.kernel.org/netdev/net/c/eaf9e7192ec9
  - [net,5/6] netfilter: nf_tables: do not ignore genmask when looking up chain by id
    https://git.kernel.org/netdev/net/c/515ad530795c
  - [net,6/6] netfilter: nf_tables: prevent OOB access in nft_byteorder_eval
    https://git.kernel.org/netdev/net/c/caf3ef7468f7

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


