Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D84BE936EB
	for <netfilter-devel@archiver.kernel.org>; Wed,  4 Oct 2023 22:13:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240038AbjJDWNF (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 4 Oct 2023 18:13:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244148AbjJDWMz (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 4 Oct 2023 18:12:55 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F37AC1736
        for <netfilter-devel@vger.kernel.org>; Wed,  4 Oct 2023 15:10:31 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 697EDC433C9;
        Wed,  4 Oct 2023 22:10:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1696457429;
        bh=U0ii4DijNx7BEQkEP+z9aT3zqk7TIw623GZy8mHNEnQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=RlGcZt0F8V1i+4WnYDTEJ1fX/IyV2YffjIe1/j3ssYU98KvWCGFxnbjXbbqAvzYGV
         Scf0LW8Cs2ieOjZ9z/FWHoZlavVBXuV7sVQo5CLIipOXHqhcNCtAvjRC6mH79aaBDX
         TZda5c8+xpue6K34EwwMK4cxVqC0iqh/lApoX79/S5bEmQvoiRpz7IIM7hXFLevzLg
         gObpfpIwQAhtuAeTgv9C0bv09iO5qW+dc481sqZeEYNEfci9tvKVvR6NO9C6qbznSL
         x27N8AlNbKe10EWHGESydzy8UXVdoZu8IHYi1uwCFme7VgIz+WEL0oUxg5S8sh1NCD
         azx4sBCMc6nZw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 439F3E632D8;
        Wed,  4 Oct 2023 22:10:29 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/6] netfilter: nft_payload: rebuild vlan header on
 h_proto access
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <169645742927.27663.17955454215093696095.git-patchwork-notify@kernel.org>
Date:   Wed, 04 Oct 2023 22:10:29 +0000
References: <20231004141405.28749-2-fw@strlen.de>
In-Reply-To: <20231004141405.28749-2-fw@strlen.de>
To:     Florian Westphal <fw@strlen.de>
Cc:     netdev@vger.kernel.org, pabeni@redhat.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org,
        netfilter-devel@vger.kernel.org, david.ward@ll.mit.edu
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hello:

This series was applied to netdev/net.git (main)
by Florian Westphal <fw@strlen.de>:

On Wed,  4 Oct 2023 16:13:45 +0200 you wrote:
> nft can perform merging of adjacent payload requests.
> This means that:
> 
> ether saddr 00:11 ... ether type 8021ad ...
> 
> is a single payload expression, for 8 bytes, starting at the
> ethernet source offset.
> 
> [...]

Here is the summary with links:
  - [net,1/6] netfilter: nft_payload: rebuild vlan header on h_proto access
    https://git.kernel.org/netdev/net/c/af84f9e447a6
  - [net,2/6] netfilter: handle the connecting collision properly in nf_conntrack_proto_sctp
    https://git.kernel.org/netdev/net/c/8e56b063c865
  - [net,3/6] selftests: netfilter: test for sctp collision processing in nf_conntrack
    https://git.kernel.org/netdev/net/c/cf791b22bef7
  - [net,4/6] selftests: netfilter: Extend nft_audit.sh
    https://git.kernel.org/netdev/net/c/203bb9d39866
  - [net,5/6] netfilter: nf_tables: Deduplicate nft_register_obj audit logs
    https://git.kernel.org/netdev/net/c/0d880dc6f032
  - [net,6/6] netfilter: nf_tables: nft_set_rbtree: fix spurious insertion failure
    https://git.kernel.org/netdev/net/c/087388278e0f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


