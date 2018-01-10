From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH] Don't merge adjacent/overlapping ranges by default
Date: Wed, 10 Jan 2018 15:16:53 +0100
Message-ID: <20180110141653.lhszuzvtt2gpbmzn@salvia>
References: <20180110104221.3565-1-phil@nwl.cc>
 <20180110115100.z3hbazlk4w7lekga@salvia>
 <20180110115725.GO32305@orbyte.nwl.cc>
 <20180110120801.xq6hgryqjdif57xf@salvia>
 <20180110124426.GP32305@orbyte.nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59336 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754563AbeAJOQ5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 10 Jan 2018 09:16:57 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 661021EC2C1
        for <netfilter-devel@vger.kernel.org>; Wed, 10 Jan 2018 15:16:56 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 554E4DA84B
        for <netfilter-devel@vger.kernel.org>; Wed, 10 Jan 2018 15:16:56 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20180110124426.GP32305@orbyte.nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jan 10, 2018 at 01:44:26PM +0100, Phil Sutter wrote:
> Hey!
> 
> On Wed, Jan 10, 2018 at 01:08:01PM +0100, Pablo Neira Ayuso wrote:
> > On Wed, Jan 10, 2018 at 12:57:25PM +0100, Phil Sutter wrote:
> > > Hi Pablo,
> > > 
> > > On Wed, Jan 10, 2018 at 12:51:00PM +0100, Pablo Neira Ayuso wrote:
> > > [...]
> > > > I would disable this by default by now, no option.
> > > > 
> > > > Then, revisit this later on to see if it's worth adding this, thanks!
> > > 
> > > Should I drop everything that's needed to make it optional or just
> > > remove the option from src/main.c?
> > 
> > Yes please. Thanks Phil.
> 
> You can't answer "yes" to an either-or-question! :P

Sorry :), I mean, yes please remove the option in src/main.c, moving
forward we decide what to do with remaing code. So I can just include
this in the 0.8.1 release.

Thanks!
