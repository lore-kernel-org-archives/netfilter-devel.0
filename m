Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1946C43217
	for <netfilter-devel@archiver.kernel.org>; Thu,  1 Dec 2022 13:14:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230281AbiLANOO (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 1 Dec 2022 08:14:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229769AbiLANOO (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 1 Dec 2022 08:14:14 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DE3F9E464
        for <netfilter-devel@vger.kernel.org>; Thu,  1 Dec 2022 05:14:12 -0800 (PST)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1p0jOE-0000v5-AA; Thu, 01 Dec 2022 14:14:10 +0100
Date:   Thu, 1 Dec 2022 14:14:10 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH iptables-nft] extensions: add xt_statistics random mode
 translation
Message-ID: <Y4iooljLqMmp1bgn@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
References: <20221201101317.16818-1-fw@strlen.de>
 <Y4iW4R1tusL9PecX@orbyte.nwl.cc>
 <20221201120610.GB7057@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221201120610.GB7057@breakpoint.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Dec 01, 2022 at 01:06:10PM +0100, Florian Westphal wrote:
> Phil Sutter <phil@nwl.cc> wrote:
> > On Thu, Dec 01, 2022 at 11:13:17AM +0100, Florian Westphal wrote:
> > > Use meta random and bitops to replicate what xt_statistics
> > > is doing.
> > 
> > I didn't know about 'meta random', even though it's a bit older than
> > numgen. What's the difference to 'numgen random'?
> 
> META_RANDOM is simpler. its really just setting a 32bit register to a
> 32bit random value.
> 
> No modulus, offset or anything like that is supported.
> 
> For most users, numgen random is much better because you can generate a
> random number within a given range.
> 
> But this translation really does match exactly what xt_statistics is
> doing.

OK, cool!

> > I'm asking because I
> > once tried to fix the same issue using the latter[1], it was never
> > applied, though.
> > 
> > Maybe you could reuse gcd_div() from my patch to reduce nominal values?
> 
> Why?  If you prefer numgen, maybe just rebase your patch and push it out?

No, I don't care whether meta or numgen. I just recall some
probability/mask values would trim down nicely and make things more
readable. Just push your patch please, I'll play with gcd() if time
allows.

Thanks, Phil
