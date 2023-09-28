Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 133F0CE7B1E
	for <netfilter-devel@archiver.kernel.org>; Thu, 28 Sep 2023 19:39:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229864AbjI1Tjl (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 28 Sep 2023 15:39:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbjI1Tjk (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 28 Sep 2023 15:39:40 -0400
Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [IPv6:2001:738:5001::48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9101619F
        for <netfilter-devel@vger.kernel.org>; Thu, 28 Sep 2023 12:39:37 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by smtp2.kfki.hu (Postfix) with ESMTP id C1EF2CC0325;
        Thu, 28 Sep 2023 21:39:33 +0200 (CEST)
X-Virus-Scanned: Debian amavisd-new at smtp2.kfki.hu
Received: from smtp2.kfki.hu ([127.0.0.1])
        by localhost (smtp2.kfki.hu [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP; Thu, 28 Sep 2023 21:39:31 +0200 (CEST)
Received: from blackhole.kfki.hu (blackhole.szhk.kfki.hu [148.6.240.2])
        by smtp2.kfki.hu (Postfix) with ESMTP id 5E944CC0323;
        Thu, 28 Sep 2023 21:39:30 +0200 (CEST)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
        id 875773431A9; Thu, 28 Sep 2023 21:39:30 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by blackhole.kfki.hu (Postfix) with ESMTP id 85E5C343155;
        Thu, 28 Sep 2023 21:39:30 +0200 (CEST)
Date:   Thu, 28 Sep 2023 21:39:30 +0200 (CEST)
From:   Jozsef Kadlecsik <kadlec@netfilter.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
cc:     Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>,
        netfilter-devel@vger.kernel.org
Subject: Re: [nf PATCH v2 8/8] netfilter: nf_tables: Add locking for
 NFT_MSG_GETSETELEM_RESET requests
In-Reply-To: <ZRXOIrxtu5JPN4jA@calendula>
Message-ID: <fedeecd9-b03-789-bc6c-21a697fc29d@netfilter.org>
References: <20230928165244.7168-1-phil@nwl.cc> <20230928165244.7168-9-phil@nwl.cc> <20230928174630.GD19098@breakpoint.cc> <ZRXKWuGAE1snXkaK@calendula> <20230928185745.GE19098@breakpoint.cc> <ZRXOIrxtu5JPN4jA@calendula>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, 28 Sep 2023, Pablo Neira Ayuso wrote:

> On Thu, Sep 28, 2023 at 08:57:45PM +0200, Florian Westphal wrote:
> > Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > On Thu, Sep 28, 2023 at 07:46:30PM +0200, Florian Westphal wrote:
> > > > Phil Sutter <phil@nwl.cc> wrote:
> > > > > +static int nf_tables_dumpreset_set(struct sk_buff *skb,
> > > > > +				   struct netlink_callback *cb)
> > > > > +{
> > > > > +	struct nftables_pernet *nft_net = nft_pernet(sock_net(skb->sk));
> > > > > +	struct nft_set_dump_ctx *dump_ctx = cb->data;
> > > > > +	int ret, skip = cb->args[0];
> > > > > +
> > > > > +	mutex_lock(&nft_net->commit_mutex);
> > > > > +	ret = nf_tables_dump_set(skb, cb);
> > > > > +	mutex_unlock(&nft_net->commit_mutex);
> > > > > +
> > > > > +	if (cb->args[0] > skip)
> > > > > +		audit_log_nft_set_reset(dump_ctx->ctx.table, cb->seq,
> > > > > +					cb->args[0] - skip);
> > > > > +
> > > > 
> > > > Once commit_mutex is dropped, parallel user can
> > > > delete table, and ctx.table references garbage.
> > > 
> > > This path should hold rcu read lock.
> > 
> > Then it would splat on first mutex_lock().
> > 
> > > I think spinlock would be better, we would just spin for very little
> > > time here for another thread to complete the reset, and the race is
> > > fixed.
> > > 
> > > The use of commit_mutex here is confusing is really misleading to the
> > > reader, this is also not the commit path.
> > 
> > I'd say its semantically the same thing, we alter state.
> > 
> > We even emit audit records to tell userspace that there is state
> > change.
> 
> This is a netlink event, how does the mutex help in that regard?
> 
> > Also, are you sure spinlock is appropriate here?
> > 
> > For full-ruleset resets we might be doing quite some
> > traverals.
> 
> I said several times, we grab and release this for each
> netlink_recvmsg(), commit_mutex helps us in no way to fix the "two
> concurrent dump-and-reset problem".
> 
> One concern might be deadlock due to reordering, but I don't see how
> that can happen.

The same problem exists ipset: when a set is listed/saved (dumped), 
concurrent destroy/rename/swap for the same set must be excluded. As 
neither spinlock nor mutex helps, a reference counter is used: the start 
of the dump increases it and by checking it all concurrent events can 
safely be rejected by returning EBUSY.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.hu
PGP key : https://wigner.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics
          H-1525 Budapest 114, POB. 49, Hungary
