From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH] Don't merge adjacent/overlapping ranges by default
Date: Wed, 10 Jan 2018 13:08:01 +0100
Message-ID: <20180110120801.xq6hgryqjdif57xf@salvia>
References: <20180110104221.3565-1-phil@nwl.cc>
 <20180110115100.z3hbazlk4w7lekga@salvia>
 <20180110115725.GO32305@orbyte.nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45398 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932166AbeAJMIG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 10 Jan 2018 07:08:06 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 11ECB1BCFC6
        for <netfilter-devel@vger.kernel.org>; Wed, 10 Jan 2018 13:08:05 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 02FC9DA84C
        for <netfilter-devel@vger.kernel.org>; Wed, 10 Jan 2018 13:08:05 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20180110115725.GO32305@orbyte.nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jan 10, 2018 at 12:57:25PM +0100, Phil Sutter wrote:
> Hi Pablo,
> 
> On Wed, Jan 10, 2018 at 12:51:00PM +0100, Pablo Neira Ayuso wrote:
> [...]
> > I would disable this by default by now, no option.
> > 
> > Then, revisit this later on to see if it's worth adding this, thanks!
> 
> Should I drop everything that's needed to make it optional or just
> remove the option from src/main.c?

Yes please. Thanks Phil.
