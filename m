Return-Path: <SRS0=CDuC=UQ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84D62C31E5B
	for <netfilter-devel@archiver.kernel.org>; Mon, 17 Jun 2019 20:11:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4FBC32085A
	for <netfilter-devel@archiver.kernel.org>; Mon, 17 Jun 2019 20:11:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726872AbfFQULL (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 17 Jun 2019 16:11:11 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:47438 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726048AbfFQULK (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 17 Jun 2019 16:11:10 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@strlen.de>)
        id 1hcxy4-0000Jd-Pu; Mon, 17 Jun 2019 22:11:05 +0200
Date:   Mon, 17 Jun 2019 22:11:04 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Cc:     Anatoly Pugachev <matorola@gmail.com>,
        Sparc kernel list <sparclinux@vger.kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        debian-sparc <debian-sparc@lists.debian.org>
Subject: Re: [netfilter-core] [sparc64] possible circular locking / deadlock
Message-ID: <20190617201104.qv2tm5oezluyg4nv@breakpoint.cc>
References: <CADxRZqy=pCbwg6Lyio=GQ6gckR5B5Y=YQ1URPO0qn3YPAnUc0A@mail.gmail.com>
 <alpine.DEB.2.20.1906171656030.27371@blackhole.kfki.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.20.1906171656030.27371@blackhole.kfki.hu>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Jozsef Kadlecsik <kadlec@blackhole.kfki.hu> wrote:
> >                -> #0 (&table[i].mutex){+.+.}:
> > [   11.698157]        lock_acquire+0x1a4/0x1c0
> > [   11.698165]        __mutex_lock+0x48/0x920
> > [   11.698173]        mutex_lock_nested+0x1c/0x40
> > [   11.698181]        nfnl_lock+0x24/0x40 [nfnetlink]
> > [   11.698196]        ip_set_nfnl_get_byindex+0x19c/0x280 [ip_set]
> > [   11.698207]        set_match_v1_checkentry+0x14/0xc0 [xt_set]
> 
> set_match_v1_checkentry() from ipset always assumed that it's called via 
> the old xtables/setsockopt interface. Thus it calls 
> ip_set_nfnl_get_byindex() which is then calls 
> nfnl_lock(NFNL_SUBSYS_IPSET). Here comes the circular dependency.

But isnt it a false positive?

> > [   11.698359]        CPU0                    CPU1
> > [   11.698366]        ----                    ----
> > [   11.698372]   lock(&net->nft.commit_mutex);
> > [   11.698381]                                lock(&table[i].mutex);
> > [   11.698390]                                lock(&net->nft.commit_mutex);
> > [   11.698400]   lock(&table[i].mutex);
> > [   11.698408]

AFAICS CPU0 takes the ipset subsys mutex after taking the nftables
transaction mutex (via checkentry of ipset match), while CPU1 took the
nftables subsys mutex and then the nftables transaction mutex.

The only reason why this splat is generated is because nftables and
ipset subset mutexes are currently the same from lockdep pov.

It looks like we need to extend nfnetlink to place the subsystem mutexes
in different lockdep classes.
