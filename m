Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEC1DC7EE22
	for <netfilter-devel@archiver.kernel.org>; Mon,  8 May 2023 20:26:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229621AbjEHU0J (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 8 May 2023 16:26:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbjEHUZv (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 8 May 2023 16:25:51 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01F7C3C1B
        for <netfilter-devel@vger.kernel.org>; Mon,  8 May 2023 13:25:49 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1pw7QZ-0007qF-SS; Mon, 08 May 2023 22:25:47 +0200
Date:   Mon, 8 May 2023 22:25:47 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>,
        netfilter-devel <netfilter-devel@vger.kernel.org>
Subject: Re: nft transaction semantics and flowtable hw offload
Message-ID: <20230508202547.GA25016@breakpoint.cc>
References: <20230505123208.GB6126@breakpoint.cc>
 <ZFlRWJ/kC+F1YNsB@calendula>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZFlRWJ/kC+F1YNsB@calendula>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> Hi Florian,
> 
> On Fri, May 05, 2023 at 02:32:08PM +0200, Florian Westphal wrote:
> > Following dummy ruleset only works on first load:
> > 
> > $ cat bug
> > flush ruleset
> > table inet filter {
> >   flowtable f1 {
> >   hook ingress priority 10
> >   flags offload
> >   devices = { dummy0, dummy1 }
> >  }
> > }
> > $ nft -f bug
> 
> This follows flowtable addition path.
> 
> > $ nft -f bug
> 
> This follows nft_flow_update() path.

I don't think so, the "flush ruleset" should make the
existing flowtable invisible, no?

> > bug:3:13-14: Error: Could not process rule: Device or resource busy
> 
> I don't see who reports EBUSY at quick glance.

Its the NIC driver (ndo_setup_tc), but I do not see how its fixable,
hence this email.

> > This works when 'offload' flag is removed.
> > 
> > Transaction will *first* try to register the flowtable hook,
> > then it unregisters the existing flowtable hook.
> > 
> > When 'offload' flag is enabled, hook registration fails because
> > the device offload capability is already busy.
> >
> > Any suggestions on how to fix this?
> > Or would you say this is as expected/designed?
> 
> It should not report EBUSY, we have fixed similar issues like this one
> in the past.

But driver can't know that the (registered) flow block is going
to be unregistered later in the same transaction, so it can't
"suppress" the error.

For SW path (no offload) this works because netfilter core
will be happy to (temporarily) register the software flow bypass
hook a second time.

You can replicate a unrelated but similar error if you create 1k base chains,
then try to "nft -f" the same ruleset; if you prepend a "flush ruleset"
this will fail because we have "reg, unreg" and not "unreg, reg"
ordering (and we have to do it this way to not leave a "no hooks at all"
window) and the temporary 2nd registering brings the core over the
hardcoded limit.

> > We could swap register/unregister, but this has two major issues:
> > 
> > 1. it gives a window where no hook is registered on hw side
> > 2. after unreg, we cannot assume that (re)registering works, so
> >    'nft -f' may cause loss of functionality.
> > 
> > Adding a 'refcount' scheme doesn't really work either, we'd need
> > an extra data structure to record the known offload settings, so that
> > on a 'hook flowtable f1 to dummy0' request we can figure out that this
> > is expected to be busy and then we could skip the register request.
> > 
> > But that has to problem that the batch might not have an unregister
> > request, i.e. we would accept a bogus ruleset that *should* have failed
> > with -EBUSY.
> > 
> > Any ideas?
> 
> If you help me narrow down the issue, because I currently do not see
> where this EBUSY error originates from.

To be fair, I dont have offload capable HW so I hacked up the dummy driver
to add a faux ndo_setup_tc for testing.

As far as I can piece this together this is coming from
flow_block_cb_setup_simple() in mlx5.

Interesting however is that mtk_wed_setup_tc_block() seems to instead
bump an internal refcount.

Is that the expected driver handling in this situation?
If so, I'd ping mlx driver maintainers.

Thanks,
Florian
