Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DAA51CDB47E
	for <netfilter-devel@archiver.kernel.org>; Wed, 18 Oct 2023 10:20:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230473AbjJRKU2 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 18 Oct 2023 06:20:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230459AbjJRKU1 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 18 Oct 2023 06:20:27 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87301BA
        for <netfilter-devel@vger.kernel.org>; Wed, 18 Oct 2023 03:20:24 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 31682C433D9;
        Wed, 18 Oct 2023 10:20:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697624424;
        bh=abcaJaLEdDZuVGIJhG4m3B++7sbDPLq+MwLkRRMVbhA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=PNuXdEIv/pe1A6YHsEiDi5+5PJz8YVflFHYa1k+4JQzEjlLivmI2nJlfsc0jbLeuX
         zZwBz8kziO92I05iAqEeudoz/CNq+94IoDNW8WczucMJKc3REAhgWzN5ala7yMzfiG
         VGKLjloirYXW9Bj9NbhRfCFWWpPMiDG9bXT0qGrGnx6JwUBA04ErddYRx6agx6QtaE
         TX2iFuR60HIwGte1naToK3cf60yoSLADjq20DS5KUosok2q2CZtcV48H94Ps7Gc17A
         AB6bIp+VyQMXIQaFyseicpqDDnqba5LSyd/lIMA5+KqiemNIyXjLp7+QiVtaJ97HjI
         MUWsg0rLftW5w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 1F050C04E24;
        Wed, 18 Oct 2023 10:20:24 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next PATCH v2] net: skb_find_text: Ignore patterns extending
 past 'to'
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <169762442412.8273.16759719638129839234.git-patchwork-notify@kernel.org>
Date:   Wed, 18 Oct 2023 10:20:24 +0000
References: <20231017093906.26310-1-phil@nwl.cc>
In-Reply-To: <20231017093906.26310-1-phil@nwl.cc>
To:     Phil Sutter <phil@nwl.cc>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, fw@strlen.de, pablo@netfilter.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by David S. Miller <davem@davemloft.net>:

On Tue, 17 Oct 2023 11:39:06 +0200 you wrote:
> Assume that caller's 'to' offset really represents an upper boundary for
> the pattern search, so patterns extending past this offset are to be
> rejected.
> 
> The old behaviour also was kind of inconsistent when it comes to
> fragmentation (or otherwise non-linear skbs): If the pattern started in
> between 'to' and 'from' offsets but extended to the next fragment, it
> was not found if 'to' offset was still within the current fragment.
> 
> [...]

Here is the summary with links:
  - [net-next,v2] net: skb_find_text: Ignore patterns extending past 'to'
    https://git.kernel.org/netdev/net-next/c/c4eee56e14fe

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


