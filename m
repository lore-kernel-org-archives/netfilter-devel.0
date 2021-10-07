Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 174ACC433F5
	for <netfilter-devel@archiver.kernel.org>; Thu,  7 Oct 2021 09:31:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EFC2E60FC1
	for <netfilter-devel@archiver.kernel.org>; Thu,  7 Oct 2021 09:31:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240740AbhJGJd1 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 7 Oct 2021 05:33:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240739AbhJGJdZ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 7 Oct 2021 05:33:25 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94234C061760
        for <netfilter-devel@vger.kernel.org>; Thu,  7 Oct 2021 02:31:32 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1mYPkR-0006zh-26; Thu, 07 Oct 2021 11:31:31 +0200
Date:   Thu, 7 Oct 2021 11:31:31 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Eugene Crosser <crosser@average.org>
Cc:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
        Jinpu Wang <jinpu.wang@ionos.com>
Subject: Re: In raw prerouting, `iif` matches different interfaces in
 different kernels when enslaved in a vrf
Message-ID: <20211007093131.GC25730@breakpoint.cc>
References: <17326577-1ab7-aaaa-0911-13ee131bdee0@average.org>
 <20211002185036.GJ2935@breakpoint.cc>
 <dc693a0b-cb3f-877e-1352-cfeb97f2f092@average.org>
 <026e1d28-c76c-fab8-7766-98ad126dbd49@average.org>
 <20211006150301.GA7393@breakpoint.cc>
 <060e0d5e-b40f-204a-1894-c1eef8c8411d@average.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <060e0d5e-b40f-204a-1894-c1eef8c8411d@average.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Eugene Crosser <crosser@average.org> wrote:
> On 06/10/2021 17:03, Florian Westphal wrote:
> 
> > > It looks like Jinpu Wang <jinpu.wang@ionos.com> has found the offending
> > > commit, it's 09e856d54bda5f28 "vrf: Reset skb conntrack connection on VRF
> > > rcv" from Aug 15 2021.
> > 
> > This change is very recent, you reported failure between 5.4 and 5.10, or was
> > that already backported?
> > 
> > This change doesn't influcence matching either, but it does zap the ct
> > zone association afaics.
> 
> Yes, looks like it was backported to Debian/Ubuntu kernels
> 
> Jinpu reported that reverting the change restores the "old" behaviour.
> 
> But we have not yet checked how it affects SNAT.

Can you start a new thread on netdev and CC author of that commit
and l3m/vrf maintainers/authors?

I'm afraid you won't find anyone on the netfilter lists that can make
any statements on what the VRF expectations are.
