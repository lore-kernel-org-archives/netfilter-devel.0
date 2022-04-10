Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77A92C433F5
	for <netfilter-devel@archiver.kernel.org>; Sun, 10 Apr 2022 15:16:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232277AbiDJPTC (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 10 Apr 2022 11:19:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235030AbiDJPTB (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 10 Apr 2022 11:19:01 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 67CFE2980A
        for <netfilter-devel@vger.kernel.org>; Sun, 10 Apr 2022 08:16:49 -0700 (PDT)
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id C2C0A63004;
        Sun, 10 Apr 2022 17:12:49 +0200 (CEST)
Date:   Sun, 10 Apr 2022 17:16:44 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Topi Miettinen <toiwoton@gmail.com>
Cc:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] doc: Document that kernel may accept unimplemented
 expressions
Message-ID: <YlL03ME01hrQOKJV@salvia>
References: <20220409094402.22567-1-toiwoton@gmail.com>
 <20220409095152.GA19371@breakpoint.cc>
 <9277ac40-4175-62b3-d777-bdfa9434d187@gmail.com>
 <20220409102216.GF19371@breakpoint.cc>
 <f926a231-6224-f6ca-841f-8a56531b33f8@gmail.com>
 <20220409114240.GG19371@breakpoint.cc>
 <430e61df-8126-f18e-0ecd-6c946dd54229@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <430e61df-8126-f18e-0ecd-6c946dd54229@gmail.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sat, Apr 09, 2022 at 04:01:48PM +0300, Topi Miettinen wrote:
> On 9.4.2022 14.42, Florian Westphal wrote:
> > Topi Miettinen <toiwoton@gmail.com> wrote:
> > > Would it be possible to add such checks in the future?
> > 
> > We could add socket skuid, socket skgid, its not hard.
> 
> That would be nice. Could the syntax still remain 'meta skuid' even though
> the credentials come from a socket for compatibility?
> 
> > > Note that the kernel may accept expressions without errors even if it
> > > doesn't implement the feature. For example, input chain filters using
> > > expressions such as *meta skuid*, *meta skgid*, *meta cgroup* or
> > 
> > Those can not be made to work.
> > 
> > > *socket cgroupv2* are silently accepted but they don't work reliably
> > 
> > socket should work, at least for tcp and udp.
> > The cgroupv2 is buggy.  I sent a patch, feel free to test it.
> 
> Once the patch is applied, the warnings in manual page wrt. cgroupv2 would
> only apply to old kernels. How about the following:
> 
> Note that different kernel versions may accept expressions without errors
> even if they don't implement the feature. For example, input chain filters
> using expressions such as *meta skuid*, *meta skgid*, *meta cgroup* or
> *socket cgroupv2* are silently accepted but they may not work reliably or at
> all.

Wrt this fix, it will be passed to -stable.

Regarding general use of socket match from input: Probably more
documentation on what kind of sockets early demux is actually being
attached to might help understand how this is working.
