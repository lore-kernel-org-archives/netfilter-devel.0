Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA901CE7B1E
	for <netfilter-devel@archiver.kernel.org>; Thu, 28 Sep 2023 19:04:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229864AbjI1TEJ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 28 Sep 2023 15:04:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbjI1TEJ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 28 Sep 2023 15:04:09 -0400
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96B27194
        for <netfilter-devel@vger.kernel.org>; Thu, 28 Sep 2023 12:04:07 -0700 (PDT)
Received: from [78.30.34.192] (port=36414 helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <pablo@gnumonks.org>)
        id 1qlwIt-003xs9-EA; Thu, 28 Sep 2023 21:04:05 +0200
Date:   Thu, 28 Sep 2023 21:04:02 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
Subject: Re: [nf PATCH v2 8/8] netfilter: nf_tables: Add locking for
 NFT_MSG_GETSETELEM_RESET requests
Message-ID: <ZRXOIrxtu5JPN4jA@calendula>
References: <20230928165244.7168-1-phil@nwl.cc>
 <20230928165244.7168-9-phil@nwl.cc>
 <20230928174630.GD19098@breakpoint.cc>
 <ZRXKWuGAE1snXkaK@calendula>
 <20230928185745.GE19098@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230928185745.GE19098@breakpoint.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Sep 28, 2023 at 08:57:45PM +0200, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > On Thu, Sep 28, 2023 at 07:46:30PM +0200, Florian Westphal wrote:
> > > Phil Sutter <phil@nwl.cc> wrote:
> > > > +static int nf_tables_dumpreset_set(struct sk_buff *skb,
> > > > +				   struct netlink_callback *cb)
> > > > +{
> > > > +	struct nftables_pernet *nft_net = nft_pernet(sock_net(skb->sk));
> > > > +	struct nft_set_dump_ctx *dump_ctx = cb->data;
> > > > +	int ret, skip = cb->args[0];
> > > > +
> > > > +	mutex_lock(&nft_net->commit_mutex);
> > > > +	ret = nf_tables_dump_set(skb, cb);
> > > > +	mutex_unlock(&nft_net->commit_mutex);
> > > > +
> > > > +	if (cb->args[0] > skip)
> > > > +		audit_log_nft_set_reset(dump_ctx->ctx.table, cb->seq,
> > > > +					cb->args[0] - skip);
> > > > +
> > > 
> > > Once commit_mutex is dropped, parallel user can
> > > delete table, and ctx.table references garbage.
> > 
> > This path should hold rcu read lock.
> 
> Then it would splat on first mutex_lock().
> 
> > I think spinlock would be better, we would just spin for very little
> > time here for another thread to complete the reset, and the race is
> > fixed.
> > 
> > The use of commit_mutex here is confusing is really misleading to the
> > reader, this is also not the commit path.
> 
> I'd say its semantically the same thing, we alter state.
> 
> We even emit audit records to tell userspace that there is state
> change.

This is a netlink event, how does the mutex help in that regard?

> Also, are you sure spinlock is appropriate here?
> 
> For full-ruleset resets we might be doing quite some
> traverals.

I said several times, we grab and release this for each
netlink_recvmsg(), commit_mutex helps us in no way to fix the "two
concurrent dump-and-reset problem".

One concern might be deadlock due to reordering, but I don't see how
that can happen.

> But, no problem, I'm fine with spinlock as well.
