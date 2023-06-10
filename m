Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61235C77B7A
	for <netfilter-devel@archiver.kernel.org>; Sat, 10 Jun 2023 19:12:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229746AbjFJTMa (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 10 Jun 2023 15:12:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229667AbjFJTMa (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 10 Jun 2023 15:12:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3866B1FE9
        for <netfilter-devel@vger.kernel.org>; Sat, 10 Jun 2023 12:12:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C94D461A43
        for <netfilter-devel@vger.kernel.org>; Sat, 10 Jun 2023 19:12:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 23661C433D2;
        Sat, 10 Jun 2023 19:12:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1686424348;
        bh=MnsFWRXlDOpNeOfrRaLfHEX8hGlKa+XhJ7sR/IyaEcg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=hBqldKsToM4vwuBKc2rZNUZT6IVkm+cpN8e63BKu1vKEC+t/TKo7qHPiFOQ/+zUIZ
         5NFG3c+b2njXJSIMAVJ9CZSI2tQncmOzks8rj8477QYVqfuF2qTafpA12NL4m4RJGM
         OtOYwZy/F8DaOlte+eX/1yLEpMA2HywQtsjBpjIxl+dERPlIPBP1aa09dhlL99dmQJ
         JyDt/48WUyTPP6EZgPakDN8XTwTfrrWJTlyoE88cfWzPog/Lx3hyT73kf4pA/kIfqz
         Jfllwabowm10fIfSKdq1oUaygLyY1tEH2WioZV1A6IOxx3xELYmRVDLukemuxnhtoD
         7cFmJZJk4FAhw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 050CAC395F3;
        Sat, 10 Jun 2023 19:12:28 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/3] netfilter: nf_tables: integrate pipapo into commit
 protocol
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168642434801.30474.1571791241057313404.git-patchwork-notify@kernel.org>
Date:   Sat, 10 Jun 2023 19:12:28 +0000
References: <20230608195706.4429-2-pablo@netfilter.org>
In-Reply-To: <20230608195706.4429-2-pablo@netfilter.org>
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

On Thu,  8 Jun 2023 21:57:04 +0200 you wrote:
> The pipapo set backend follows copy-on-update approach, maintaining one
> clone of the existing datastructure that is being updated. The clone
> and current datastructures are swapped via rcu from the commit step.
> 
> The existing integration with the commit protocol is flawed because
> there is no operation to clean up the clone if the transaction is
> aborted. Moreover, the datastructure swap happens on set element
> activation.
> 
> [...]

Here is the summary with links:
  - [net,1/3] netfilter: nf_tables: integrate pipapo into commit protocol
    https://git.kernel.org/netdev/net/c/212ed75dc5fb
  - [net,2/3] netfilter: nfnetlink: skip error delivery on batch in case of ENOMEM
    https://git.kernel.org/netdev/net/c/a1a64a151dae
  - [net,3/3] netfilter: nf_tables: incorrect error path handling with NFT_MSG_NEWRULE
    https://git.kernel.org/netdev/net/c/1240eb93f061

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


