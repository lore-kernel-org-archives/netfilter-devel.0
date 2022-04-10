Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 771A6C433EF
	for <netfilter-devel@archiver.kernel.org>; Sun, 10 Apr 2022 15:38:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236946AbiDJPkp (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 10 Apr 2022 11:40:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232155AbiDJPkp (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 10 Apr 2022 11:40:45 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B198286E4
        for <netfilter-devel@vger.kernel.org>; Sun, 10 Apr 2022 08:38:34 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1ndZe3-0004L3-HB; Sun, 10 Apr 2022 17:38:31 +0200
Date:   Sun, 10 Apr 2022 17:38:31 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next RFC 2/2] netfilter: conntrack: skip event
 delivery for the netns exit path
Message-ID: <20220410153831.GD5623@breakpoint.cc>
References: <20220408125837.221673-1-pablo@netfilter.org>
 <20220408125837.221673-2-pablo@netfilter.org>
 <20220408193413.GC7920@breakpoint.cc>
 <YlL2Vfn3ijjh9O97@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YlL2Vfn3ijjh9O97@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > If you really dislike the nfnl changes I will respin without this
> > and will keep the pernet ctnetlink callback.
> 
> OK, my patch is not covering all the possible cases then.
> 
> Probably we can remove the hooks from .pre_exit, then force a run of
> the garbage collector from there. Then .exit path skips event delivery
> as my patch does.

Hmm, sounds tricky, but doabble.

> This would allow to remove the per-netns callback workaround, and all
> would be handled from nf_conntrack instead?

Ok. I will drop the pernet change from this patch set.
