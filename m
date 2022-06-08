Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 430A6C43334
	for <netfilter-devel@archiver.kernel.org>; Wed,  8 Jun 2022 10:37:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236159AbiFHKhq (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 8 Jun 2022 06:37:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235886AbiFHKhb (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 8 Jun 2022 06:37:31 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 41F0C22BAD0
        for <netfilter-devel@vger.kernel.org>; Wed,  8 Jun 2022 03:33:47 -0700 (PDT)
Date:   Wed, 8 Jun 2022 12:33:43 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: use get_random_u32 instead of prandom
Message-ID: <YqB7B2/b0mqqYVlO@salvia>
References: <20220518181531.92593-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220518181531.92593-1-fw@strlen.de>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, May 18, 2022 at 08:15:31PM +0200, Florian Westphal wrote:
> bh might occur while updating per-cpu rnd_state from user context,
> ie. local_out path.
> 
> BUG: using smp_processor_id() in preemptible [00000000] code: nginx/2725
> caller is nft_ng_random_eval+0x24/0x54 [nft_numgen]
> Call Trace:
>  check_preemption_disabled+0xde/0xe0
>  nft_ng_random_eval+0x24/0x54 [nft_numgen]
> 
> Use the random driver instead, this also avoids need for local prandom
> state.
> 
> Based on earlier patch from Pablo Neira.

Applied to nf.git, thanks.

For the record, I have also added to the commit description:

    Moreover, prandom now uses the random driver since d4150779e60f
    ("random32: use real rng for non-deterministic randomness").
