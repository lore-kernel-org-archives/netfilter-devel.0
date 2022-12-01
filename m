Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDC42C43217
	for <netfilter-devel@archiver.kernel.org>; Thu,  1 Dec 2022 12:06:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231238AbiLAMGQ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 1 Dec 2022 07:06:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230454AbiLAMGP (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 1 Dec 2022 07:06:15 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FDAA934F0
        for <netfilter-devel@vger.kernel.org>; Thu,  1 Dec 2022 04:06:13 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1p0iKQ-0002Y2-1q; Thu, 01 Dec 2022 13:06:10 +0100
Date:   Thu, 1 Dec 2022 13:06:10 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Phil Sutter <phil@nwl.cc>, Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH iptables-nft] extensions: add xt_statistics random mode
 translation
Message-ID: <20221201120610.GB7057@breakpoint.cc>
References: <20221201101317.16818-1-fw@strlen.de>
 <Y4iW4R1tusL9PecX@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y4iW4R1tusL9PecX@orbyte.nwl.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Phil Sutter <phil@nwl.cc> wrote:
> On Thu, Dec 01, 2022 at 11:13:17AM +0100, Florian Westphal wrote:
> > Use meta random and bitops to replicate what xt_statistics
> > is doing.
> 
> I didn't know about 'meta random', even though it's a bit older than
> numgen. What's the difference to 'numgen random'?

META_RANDOM is simpler. its really just setting a 32bit register to a
32bit random value.

No modulus, offset or anything like that is supported.

For most users, numgen random is much better because you can generate a
random number within a given range.

But this translation really does match exactly what xt_statistics is
doing.

> I'm asking because I
> once tried to fix the same issue using the latter[1], it was never
> applied, though.
> 
> Maybe you could reuse gcd_div() from my patch to reduce nominal values?

Why?  If you prefer numgen, maybe just rebase your patch and push it out?
