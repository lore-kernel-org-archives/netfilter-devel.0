Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1255BC433EF
	for <netfilter-devel@archiver.kernel.org>; Wed,  3 Nov 2021 01:20:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F170260FC4
	for <netfilter-devel@archiver.kernel.org>; Wed,  3 Nov 2021 01:20:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231829AbhKCBWq (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 2 Nov 2021 21:22:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:58092 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231208AbhKCBWo (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 2 Nov 2021 21:22:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 46F0160FC4;
        Wed,  3 Nov 2021 01:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635902408;
        bh=DgmSYM2Z05M1PXI6XirV1xbPnFA0PG6MBbbt7fbohjY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=SrhyRmbDssVg/bU+UCzG5AhsuDcrtJTPmJeCIv1PnVfMYuOABH47qDITaWwYqpdOR
         8cM6EXC9zmpsWr5ZUZ+gU68bpK3JXY6+0djFZSqU1XMFv6gfUC755ng7pli1obZWVP
         90kq5SpEOCjFC1NDIqug1qcIIkrTVsC0jJo8Pm9PBE0VIDfKqjPsjYZ5/PNezVoGEA
         +2w/bS27I4aa9GqXOs+yNWIato7xa9G3RKgv7ZWZlys3I3xCIu/F8opyPWQdvnP/3i
         vcNwPoIt/TejOqZ9TkKvCA4tl88+v7KERXfJ5b7HmjtCL+SfKgOECwJqEiVweSkEY8
         BTyEZCUdvAhQA==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/2] netfilter: nfnetlink_queue: fix OOB when mac header
 was cleared
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163590240820.27381.17723425785268130948.git-patchwork-notify@kernel.org>
Date:   Wed, 03 Nov 2021 01:20:08 +0000
References: <20211101221528.236114-2-pablo@netfilter.org>
In-Reply-To: <20211101221528.236114-2-pablo@netfilter.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, kuba@kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by Pablo Neira Ayuso <pablo@netfilter.org>:

On Mon,  1 Nov 2021 23:15:27 +0100 you wrote:
> From: Florian Westphal <fw@strlen.de>
> 
> On 64bit platforms the MAC header is set to 0xffff on allocation and
> also when a helper like skb_unset_mac_header() is called.
> 
> dev_parse_header may call skb_mac_header() which assumes valid mac offset:
> 
> [...]

Here is the summary with links:
  - [net,1/2] netfilter: nfnetlink_queue: fix OOB when mac header was cleared
    https://git.kernel.org/netdev/net/c/5648b5e1169f
  - [net,2/2] ipvs: autoload ipvs on genl access
    https://git.kernel.org/netdev/net/c/2199f562730d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


