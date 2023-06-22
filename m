Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10779EB64D8
	for <netfilter-devel@archiver.kernel.org>; Thu, 22 Jun 2023 14:30:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229828AbjFVOap (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 22 Jun 2023 10:30:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231151AbjFVOan (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 22 Jun 2023 10:30:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E87821BD8
        for <netfilter-devel@vger.kernel.org>; Thu, 22 Jun 2023 07:30:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8490D6186B
        for <netfilter-devel@vger.kernel.org>; Thu, 22 Jun 2023 14:30:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DDB92C433C8;
        Thu, 22 Jun 2023 14:30:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1687444223;
        bh=KHQwGNEwgcrs0rxctdpZsvSXluozpBikq/+0K+jIFLw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=tOZamL/wqUDdPP0LrXZCiW8MmY979EPxeqJBo8gqRWqXjPPHZ3Y7djhV7wfpG3zKr
         QXzGoT3SU6nZvDMuM3Cv7cbJSEzHhdpmeloprO6GXjBedCjtJxuj4Rffr1qLj2v47T
         ABiwZAUhjxwjSGA5TVSXNGc+io5cYN4uxfSxilMdwsfQVp8MXHxgCJgsCbRJ6WbFuK
         VSN1hjrYqE21Cb4eW6Q83hhzMrNMSfotAbE+F1KrXxfm5PrICoTOcKinvPdnrRFTpl
         WC8OqHRXaSZX0432x33614aeqMV76OCLMwq74QENGSCPjK+w21pr9oxP547jVHwtl8
         8gGXLfF+bO1lQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id BF175C395F1;
        Thu, 22 Jun 2023 14:30:23 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 01/14] ipvs: align inner_mac_header for encapsulation
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168744422377.515.17617756038976173501.git-patchwork-notify@kernel.org>
Date:   Thu, 22 Jun 2023 14:30:23 +0000
References: <20230621100731.68068-2-pablo@netfilter.org>
In-Reply-To: <20230621100731.68068-2-pablo@netfilter.org>
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

On Wed, 21 Jun 2023 12:07:18 +0200 you wrote:
> From: Terin Stock <terin@cloudflare.com>
> 
> When using encapsulation the original packet's headers are copied to the
> inner headers. This preserves the space for an inner mac header, which
> is not used by the inner payloads for the encapsulation types supported
> by IPVS. If a packet is using GUE or GRE encapsulation and needs to be
> segmented, flow can be passed to __skb_udp_tunnel_segment() which
> calculates a negative tunnel header length. A negative tunnel header
> length causes pskb_may_pull() to fail, dropping the packet.
> 
> [...]

Here is the summary with links:
  - [net,01/14] ipvs: align inner_mac_header for encapsulation
    https://git.kernel.org/netdev/net/c/d7fce52fdf96
  - [net,02/14] netfilter: nf_tables: fix chain binding transaction logic
    https://git.kernel.org/netdev/net/c/4bedf9eee016
  - [net,03/14] netfilter: nf_tables: add NFT_TRANS_PREPARE_ERROR to deal with bound set/chain
    https://git.kernel.org/netdev/net/c/26b5a5712eb8
  - [net,04/14] netfilter: nf_tables: drop map element references from preparation phase
    https://git.kernel.org/netdev/net/c/628bd3e49cba
  - [net,05/14] netfilter: nft_set_pipapo: .walk does not deal with generations
    https://git.kernel.org/netdev/net/c/2b84e215f874
  - [net,06/14] netfilter: nf_tables: fix underflow in object reference counter
    https://git.kernel.org/netdev/net/c/d6b478666ffa
  - [net,07/14] netfilter: nf_tables: disallow element updates of bound anonymous sets
    https://git.kernel.org/netdev/net/c/c88c535b592d
  - [net,08/14] netfilter: nf_tables: reject unbound anonymous set before commit phase
    https://git.kernel.org/netdev/net/c/938154b93be8
  - [net,09/14] netfilter: nf_tables: reject unbound chain set before commit phase
    https://git.kernel.org/netdev/net/c/62e1e94b246e
  - [net,10/14] netfilter: nf_tables: disallow updates of anonymous sets
    https://git.kernel.org/netdev/net/c/b770283c98e0
  - [net,11/14] netfilter: nf_tables: disallow timeout for anonymous sets
    https://git.kernel.org/netdev/net/c/e26d3009efda
  - [net,12/14] netfilter: nf_tables: drop module reference after updating chain
    https://git.kernel.org/netdev/net/c/043d2acf5722
  - [net,13/14] netfilter: nfnetlink_osf: fix module autoload
    https://git.kernel.org/netdev/net/c/62f9a68a36d4
  - [net,14/14] netfilter: nf_tables: Fix for deleting base chains with payload
    https://git.kernel.org/netdev/net/c/42e344f01688

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


