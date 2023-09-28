Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F07A0CE7B1C
	for <netfilter-devel@archiver.kernel.org>; Thu, 28 Sep 2023 18:57:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229864AbjI1S5u (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 28 Sep 2023 14:57:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbjI1S5u (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 28 Sep 2023 14:57:50 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF690194
        for <netfilter-devel@vger.kernel.org>; Thu, 28 Sep 2023 11:57:47 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1qlwCn-0007A8-2l; Thu, 28 Sep 2023 20:57:45 +0200
Date:   Thu, 28 Sep 2023 20:57:45 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>,
        netfilter-devel@vger.kernel.org
Subject: Re: [nf PATCH v2 8/8] netfilter: nf_tables: Add locking for
 NFT_MSG_GETSETELEM_RESET requests
Message-ID: <20230928185745.GE19098@breakpoint.cc>
References: <20230928165244.7168-1-phil@nwl.cc>
 <20230928165244.7168-9-phil@nwl.cc>
 <20230928174630.GD19098@breakpoint.cc>
 <ZRXKWuGAE1snXkaK@calendula>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZRXKWuGAE1snXkaK@calendula>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Thu, Sep 28, 2023 at 07:46:30PM +0200, Florian Westphal wrote:
> > Phil Sutter <phil@nwl.cc> wrote:
> > > +static int nf_tables_dumpreset_set(struct sk_buff *skb,
> > > +				   struct netlink_callback *cb)
> > > +{
> > > +	struct nftables_pernet *nft_net = nft_pernet(sock_net(skb->sk));
> > > +	struct nft_set_dump_ctx *dump_ctx = cb->data;
> > > +	int ret, skip = cb->args[0];
> > > +
> > > +	mutex_lock(&nft_net->commit_mutex);
> > > +	ret = nf_tables_dump_set(skb, cb);
> > > +	mutex_unlock(&nft_net->commit_mutex);
> > > +
> > > +	if (cb->args[0] > skip)
> > > +		audit_log_nft_set_reset(dump_ctx->ctx.table, cb->seq,
> > > +					cb->args[0] - skip);
> > > +
> > 
> > Once commit_mutex is dropped, parallel user can
> > delete table, and ctx.table references garbage.
> 
> This path should hold rcu read lock.

Then it would splat on first mutex_lock().

> I think spinlock would be better, we would just spin for very little
> time here for another thread to complete the reset, and the race is
> fixed.
> 
> The use of commit_mutex here is confusing is really misleading to the
> reader, this is also not the commit path.

I'd say its semantically the same thing, we alter state.

We even emit audit records to tell userspace that there is state
change.

Also, are you sure spinlock is appropriate here?

For full-ruleset resets we might be doing quite some
traverals.

But, no problem, I'm fine with spinlock as well.
