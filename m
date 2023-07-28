Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46899C04A6A
	for <netfilter-devel@archiver.kernel.org>; Fri, 28 Jul 2023 03:40:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231778AbjG1Dk0 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 27 Jul 2023 23:40:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229632AbjG1DkZ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 27 Jul 2023 23:40:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48C0CFE
        for <netfilter-devel@vger.kernel.org>; Thu, 27 Jul 2023 20:40:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DA42661FBA
        for <netfilter-devel@vger.kernel.org>; Fri, 28 Jul 2023 03:40:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4617CC433C9;
        Fri, 28 Jul 2023 03:40:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1690515623;
        bh=VJYDwUS9+6Cjn1ob/0UEv4RryqzUZciTJPp+xDvs3lI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Zhyg2uI8T/xtaPP6M1vZtICFZaezN/6gTopP0O8tpNznQWqLuqKUnVQYaYm0mFFp3
         ygxUirAsZAKPgCrwoe6FrawFcUZeRl3tf+rhHMGrgPKy5JaxUW/6avcxj/SEAo3ovH
         BP/M/3umJ7EK0/1EqDnezB1V4GqS9aCTQofsOj5GHjRpI4Xq2d5oLvmSgPYcv3uFcY
         8RllsMVVbC8faquVBMMdrBqdw4qwVM0K77OlKbKzaUg2kO8xncQ2SXkHXlGI224s8p
         7sK62vYo1poJOaCJACWm65+epK3wDx6DuIvzWNXWWPg6jwvUi1VwzBNulewXRRFxCK
         DWX623R2dsbTw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 2CE4FC3959F;
        Fri, 28 Jul 2023 03:40:23 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 1/5] nf_conntrack: fix -Wunused-const-variable=
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <169051562317.23821.4219034803296005345.git-patchwork-notify@kernel.org>
Date:   Fri, 28 Jul 2023 03:40:23 +0000
References: <20230727133604.8275-2-fw@strlen.de>
In-Reply-To: <20230727133604.8275-2-fw@strlen.de>
To:     Florian Westphal <fw@strlen.de>
Cc:     netdev@vger.kernel.org, pabeni@redhat.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org,
        netfilter-devel@vger.kernel.org, wangzhu9@huawei.com,
        simon.horman@corigine.com
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (main)
by Florian Westphal <fw@strlen.de>:

On Thu, 27 Jul 2023 15:35:56 +0200 you wrote:
> From: Zhu Wang <wangzhu9@huawei.com>
> 
> When building with W=1, the following warning occurs.
> 
> net/netfilter/nf_conntrack_proto_dccp.c:72:27: warning: ‘dccp_state_names’ defined but not used [-Wunused-const-variable=]
>  static const char * const dccp_state_names[] = {
> 
> [...]

Here is the summary with links:
  - [net-next,1/5] nf_conntrack: fix -Wunused-const-variable=
    https://git.kernel.org/netdev/net-next/c/a927d77778e3
  - [net-next,2/5] netlink: allow be16 and be32 types in all uint policy checks
    https://git.kernel.org/netdev/net-next/c/5fac9b7c16c5
  - [net-next,3/5] netfilter: nf_tables: use NLA_POLICY_MASK to test for valid flag options
    https://git.kernel.org/netdev/net-next/c/100a11b69842
  - [net-next,4/5] netfilter: conntrack: validate cta_ip via parsing
    https://git.kernel.org/netdev/net-next/c/0c805e80e35d
  - [net-next,5/5] lib/ts_bm: add helper to reduce indentation and improve readability
    https://git.kernel.org/netdev/net-next/c/86e9c9aa2358

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


