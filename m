Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2158C433B4
	for <netfilter-devel@archiver.kernel.org>; Wed, 19 May 2021 12:15:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D27D461040
	for <netfilter-devel@archiver.kernel.org>; Wed, 19 May 2021 12:15:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239798AbhESMQ4 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 19 May 2021 08:16:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237999AbhESMQz (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 19 May 2021 08:16:55 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 477C6C06175F
        for <netfilter-devel@vger.kernel.org>; Wed, 19 May 2021 05:15:36 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1ljL6s-0006XX-0K; Wed, 19 May 2021 14:15:34 +0200
Date:   Wed, 19 May 2021 14:15:33 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, fw@strlen.de, dvyukov@google.com
Subject: Re: [PATCH nf,v2] netfilter: nftables: accept all dummy chain when
 table is dormant
Message-ID: <20210519121533.GC8317@breakpoint.cc>
References: <20210519101402.45141-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210519101402.45141-1-pablo@netfilter.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> The dormant flag need to be updated from the preparation phase,
> otherwise, two consecutive requests to dorm a table in the same batch
> might try to remove the same hooks twice, resulting in the following
> warning:
> 
>  hook not found, pf 3 num 0
>  WARNING: CPU: 0 PID: 334 at net/netfilter/core.c:480 __nf_unregister_net_hook+0x1eb/0x610 net/netfilter/core.c:480
>  Modules linked in:
>  CPU: 0 PID: 334 Comm: kworker/u4:5 Not tainted 5.12.0-syzkaller #0
>  Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
>  Workqueue: netns cleanup_net
>  RIP: 0010:__nf_unregister_net_hook+0x1eb/0x610 net/netfilter/core.c:480
> 
> This patch is a partial revert of 0ce7cf4127f1 ("netfilter: nftables:
> update table flags from the commit phase") to restore the previous
> behaviour, which updates the dormant flag from the preparation phase
> to address this issue.
> 
> However, there is still another problem: A batch containing a series of
> dorm-wakeup-dorm table and vice-versa also trigger the warning above
> since hook unregistration happens from the preparation phase, while hook
> registration occurs from the commit phase.

You could add nf_unregister_net_hook_try() or somesuch that elides
the WARN().

AFAIU this would not be needed at all if the WARN would not exist.
We could also just remove the WARN but it did catch the earlier
NFPROTO_ARP bug, so I would refer to keep it.
