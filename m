Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F084C54FB9
	for <netfilter-devel@archiver.kernel.org>; Thu, 16 Nov 2023 10:29:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229806AbjKPK3g (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 16 Nov 2023 05:29:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229749AbjKPK3g (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 16 Nov 2023 05:29:36 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4191D1A7
        for <netfilter-devel@vger.kernel.org>; Thu, 16 Nov 2023 02:29:33 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C2A54C433C7;
        Thu, 16 Nov 2023 10:29:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1700130572;
        bh=sYxm+o9mysruVaMMu8BHgciGInB8OETPhkga4z0YhmU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=q3Ckb7P9p719w4kQjKkUo4DZe1Y2NpHUoZ1RlYEnbUQaeZfTxjQ9t08lvQx9pl1TL
         AOyCXkck4YobQmQNYC/k2yYHufodJfnFwBrjmsT8SnbfLpKEwvVMFNacsrTJohacuL
         G8etXrVVjJSVVlVoKCVBTXjtjVBud8rmspKqEdKYCUa2CbQgT+QI7AULDsx8OTj482
         RIGr26aXVfDI8UHeGdiJ7dwJenywcvDS2UFE7ux8X/xoU/8y62rxOiNJ3tbK21MjbG
         AS2rG+gE42gpiFBAAjMYguQFu/2g756LgB5qKrodo1E+b+InOcq26P/Ih+mt8ySQtc
         9+z1OhMLXELxw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A2ACFC4166E;
        Thu, 16 Nov 2023 10:29:32 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/6] netfilter: nft_set_rbtree: Remove unused variable
 nft_net
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <170013057266.29188.8784130938113311187.git-patchwork-notify@kernel.org>
Date:   Thu, 16 Nov 2023 10:29:32 +0000
References: <20231115184514.8965-2-pablo@netfilter.org>
In-Reply-To: <20231115184514.8965-2-pablo@netfilter.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, fw@strlen.de
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hello:

This series was applied to netdev/net.git (main)
by Pablo Neira Ayuso <pablo@netfilter.org>:

On Wed, 15 Nov 2023 19:45:09 +0100 you wrote:
> From: Yang Li <yang.lee@linux.alibaba.com>
> 
> The code that uses nft_net has been removed, and the nft_pernet function
> is merely obtaining a reference to shared data through the net pointer.
> The content of the net pointer is not modified or changed, so both of
> them should be removed.
> 
> [...]

Here is the summary with links:
  - [net,1/6] netfilter: nft_set_rbtree: Remove unused variable nft_net
    https://git.kernel.org/netdev/net/c/67059b61597c
  - [net,2/6] netfilter: nf_conntrack_bridge: initialize err to 0
    https://git.kernel.org/netdev/net/c/a44af08e3d4d
  - [net,3/6] netfilter: nf_tables: fix pointer math issue in nft_byteorder_eval()
    https://git.kernel.org/netdev/net/c/c301f0981fdd
  - [net,4/6] netfilter: nf_tables: bogus ENOENT when destroying element which does not exist
    https://git.kernel.org/netdev/net/c/a7d5a955bfa8
  - [net,5/6] netfilter: ipset: fix race condition between swap/destroy and kernel side add/del/test
    https://git.kernel.org/netdev/net/c/28628fa952fe
  - [net,6/6] netfilter: nf_tables: split async and sync catchall in two functions
    https://git.kernel.org/netdev/net/c/8837ba3e58ea

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


