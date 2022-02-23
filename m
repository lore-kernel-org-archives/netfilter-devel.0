Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8640C433F5
	for <netfilter-devel@archiver.kernel.org>; Wed, 23 Feb 2022 08:22:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235793AbiBWIWp (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 23 Feb 2022 03:22:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235755AbiBWIWo (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 23 Feb 2022 03:22:44 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 770F4433BD;
        Wed, 23 Feb 2022 00:22:14 -0800 (PST)
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 8538B64323;
        Wed, 23 Feb 2022 09:21:10 +0100 (CET)
Date:   Wed, 23 Feb 2022 09:22:10 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Eric Dumazet <edumazet@google.com>
Cc:     Florian Westphal <fw@strlen.de>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        netfilter-devel@vger.kernel.org, netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH net] netfilter: nf_tables: prefer kfree_rcu(ptr, rcu)
 variant
Message-ID: <YhXusp0zhI8Mob2A@salvia>
References: <20220222181331.811085-1-eric.dumazet@gmail.com>
 <20220222194605.GA28705@breakpoint.cc>
 <CANn89iLz4yML_RktHUadAkU966h9QCRJQ=cMPVzUDU7dHXg0sw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CANn89iLz4yML_RktHUadAkU966h9QCRJQ=cMPVzUDU7dHXg0sw@mail.gmail.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Feb 22, 2022 at 12:07:05PM -0800, Eric Dumazet wrote:
> On Tue, Feb 22, 2022 at 11:46 AM Florian Westphal <fw@strlen.de> wrote:
> >
> > Eric Dumazet <eric.dumazet@gmail.com> wrote:
> > > From: Eric Dumazet <edumazet@google.com>
> > >
> > > While kfree_rcu(ptr) _is_ supported, it has some limitations.
> > >
> > > Given that 99.99% of kfree_rcu() users [1] use the legacy
> > > two parameters variant, and @catchall objects do have an rcu head,
> > > simply use it.
> > >
> > > Choice of kfree_rcu(ptr) variant was probably not intentional.
> >
> > In case someone wondered, this causes expensive
> > sycnhronize_rcu + kfree for each removal operation.
> 
> This fallback to synchronize_rcu() only happens if kvfree_call_rcu() has been
> unable to allocate a new block of memory.
> 
> But yes, I guess I would add a Fixes: tag, because we can easily avoid
> this potential issue.
> 
> Pablo, if not too late:
> 
> Fixes: aaa31047a6d2 ("netfilter: nftables: add catch-all set element support")

Applied, thanks!
