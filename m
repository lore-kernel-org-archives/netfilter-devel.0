Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0A70E743C1
	for <netfilter-devel@archiver.kernel.org>; Thu, 28 Sep 2023 20:25:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231822AbjI1UZr (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 28 Sep 2023 16:25:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230251AbjI1UZq (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 28 Sep 2023 16:25:46 -0400
Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [IPv6:2001:738:5001::48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C4D41A2
        for <netfilter-devel@vger.kernel.org>; Thu, 28 Sep 2023 13:25:45 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by smtp2.kfki.hu (Postfix) with ESMTP id 0B2FECC02C6;
        Thu, 28 Sep 2023 22:25:42 +0200 (CEST)
X-Virus-Scanned: Debian amavisd-new at smtp2.kfki.hu
Received: from smtp2.kfki.hu ([127.0.0.1])
        by localhost (smtp2.kfki.hu [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP; Thu, 28 Sep 2023 22:25:39 +0200 (CEST)
Received: from blackhole.kfki.hu (blackhole.szhk.kfki.hu [148.6.240.2])
        by smtp2.kfki.hu (Postfix) with ESMTP id C32B9CC02B4;
        Thu, 28 Sep 2023 22:25:39 +0200 (CEST)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
        id BBD3E3431A9; Thu, 28 Sep 2023 22:25:39 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by blackhole.kfki.hu (Postfix) with ESMTP id B9708343155;
        Thu, 28 Sep 2023 22:25:39 +0200 (CEST)
Date:   Thu, 28 Sep 2023 22:25:39 +0200 (CEST)
From:   Jozsef Kadlecsik <kadlec@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
cc:     Pablo Neira Ayuso <pablo@netfilter.org>, Phil Sutter <phil@nwl.cc>,
        netfilter-devel@vger.kernel.org
Subject: Re: [nf PATCH v2 8/8] netfilter: nf_tables: Add locking for
 NFT_MSG_GETSETELEM_RESET requests
In-Reply-To: <20230928200946.GB28176@breakpoint.cc>
Message-ID: <3ec2da74-e884-3273-2dce-eab01a65ab70@netfilter.org>
References: <20230928165244.7168-1-phil@nwl.cc> <20230928165244.7168-9-phil@nwl.cc> <20230928174630.GD19098@breakpoint.cc> <ZRXKWuGAE1snXkaK@calendula> <20230928185745.GE19098@breakpoint.cc> <ZRXOIrxtu5JPN4jA@calendula> <fedeecd9-b03-789-bc6c-21a697fc29d@netfilter.org>
 <20230928200946.GB28176@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, 28 Sep 2023, Florian Westphal wrote:

> Jozsef Kadlecsik <kadlec@netfilter.org> wrote:
> > On Thu, 28 Sep 2023, Pablo Neira Ayuso wrote:
> > > One concern might be deadlock due to reordering, but I don't see how
> > > that can happen.
> > 
> > The same problem exists ipset: when a set is listed/saved (dumped), 
> > concurrent destroy/rename/swap for the same set must be excluded. As 
> > neither spinlock nor mutex helps, a reference counter is used: the start 
> > of the dump increases it and by checking it all concurrent events can 
> > safely be rejected by returning EBUSY.
> 
> Thanks for sharing!
> 
> I assume that means that a dumper that starts a dump, and then
> goes to sleep before closing the socket/finishing the dump can
> block further ipset updates, is that correct?

Concurrent updates are supported, both from user and kernel space.

The operations which would lead to corruption are excluded, like 
destroying the set being dumped or swapping the dumped set with another 
one. A relatively new application of the method is when there's a huge 
add-del operation which must be temporarily halted and the scheduler 
called (so spinlock/mutex cannot be held): for that time destroy/swap must 
also be excluded.
 
> (I assume so, I don't see a solution that doesn't trade one problem
>  for another).

Yes, usually that's the case. However, this code segment triggered me:

> > > > +       mutex_lock(&nft_net->commit_mutex);
> > > > +       ret = nf_tables_dump_set(skb, cb);
> > > > +       mutex_unlock(&nft_net->commit_mutex);
> > > > +
> > > > +       if (cb->args[0] > skip)
> > > > +               audit_log_nft_set_reset(dump_ctx->ctx.table, 
cb->seq,
> > > > +                                       cb->args[0] - skip);
> > > > +

That can quite nicely be handled by reference counting the object and 
protecting that way.

Best regards, 
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.hu
PGP key : https://wigner.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics
          H-1525 Budapest 114, POB. 49, Hungary
