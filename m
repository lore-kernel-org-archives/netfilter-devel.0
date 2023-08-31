Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8179AC83F14
	for <netfilter-devel@archiver.kernel.org>; Thu, 31 Aug 2023 01:40:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231201AbjHaBk2 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 30 Aug 2023 21:40:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240480AbjHaBk2 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 30 Aug 2023 21:40:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87D74CC2
        for <netfilter-devel@vger.kernel.org>; Wed, 30 Aug 2023 18:40:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0A68962C86
        for <netfilter-devel@vger.kernel.org>; Thu, 31 Aug 2023 01:40:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 61161C433CA;
        Thu, 31 Aug 2023 01:40:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1693446024;
        bh=3UBuIH9oezN3MeGWCS5SIAUAARrNrd/sZPmIPDPDzAM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=omv6zFo4YaiJapxC2N0WJNH9jn+Ah96QdZbo6DA4qmxpnRFrLi8g1VkBzgLpO9NVy
         4z4oIzQ8ZSa/OLzmroTgpshRNRXDF2aBytfOoWDK0tSDVXZp4SfCu2eXxidIXcA+l9
         uTuI0w8aYhmJMX0meMuBB7G3C1XLMI4uCJ7IaQTijzv1KbBoggHg7F8FHR5zCT/gP4
         8FVXLl+XLGbjssUMUpPumAJiiKhIRnvSosyFhllvRHTsEux727bUxt/gTeKJCKvg3N
         Zk1Xn9ggFFp6Ezk3cYAbQpSdOAjvKBw/qsrkErKUJBeCjEUo4c4hN1PST7nG6faLcu
         fnbeawHgXumEw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 49D07C64457;
        Thu, 31 Aug 2023 01:40:24 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/5] netfilter: nft_exthdr: Fix non-linear header
 modification
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <169344602429.11127.17750805118759756153.git-patchwork-notify@kernel.org>
Date:   Thu, 31 Aug 2023 01:40:24 +0000
References: <20230830235935.465690-2-pablo@netfilter.org>
In-Reply-To: <20230830235935.465690-2-pablo@netfilter.org>
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

On Thu, 31 Aug 2023 01:59:31 +0200 you wrote:
> From: Xiao Liang <shaw.leon@gmail.com>
> 
> Fix skb_ensure_writable() size. Don't use nft_tcp_header_pointer() to
> make it explicit that pointers point to the packet (not local buffer).
> 
> Fixes: 99d1712bc41c ("netfilter: exthdr: tcp option set support")
> Fixes: 7890cbea66e7 ("netfilter: exthdr: add support for tcp option removal")
> Cc: stable@vger.kernel.org
> Signed-off-by: Xiao Liang <shaw.leon@gmail.com>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> 
> [...]

Here is the summary with links:
  - [net,1/5] netfilter: nft_exthdr: Fix non-linear header modification
    https://git.kernel.org/netdev/net/c/28427f368f0e
  - [net,2/5] netfilter: xt_sctp: validate the flag_info count
    https://git.kernel.org/netdev/net/c/e99476497687
  - [net,3/5] netfilter: xt_u32: validate user space input
    https://git.kernel.org/netdev/net/c/69c5d284f670
  - [net,4/5] netfilter: nf_tables: Audit log setelem reset
    https://git.kernel.org/netdev/net/c/7e9be1124dbe
  - [net,5/5] netfilter: nf_tables: Audit log rule reset
    https://git.kernel.org/netdev/net/c/ea078ae9108e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


