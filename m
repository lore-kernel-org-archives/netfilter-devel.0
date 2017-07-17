From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH 1/4] monitor: Fix printing of range elements in named
 sets
Date: Mon, 17 Jul 2017 18:12:34 +0200
Message-ID: <20170717161234.GA32725@salvia>
References: <20170712123658.25363-1-phil@nwl.cc>
 <20170712123658.25363-2-phil@nwl.cc>
 <CAOkSjBhX1=DJuY9M8P0axCQkMyjZyweea9tROnGSHM=WqRq47A@mail.gmail.com>
 <20170712190545.GC16375@orbyte.nwl.cc>
 <20170713182202.GK16375@orbyte.nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Phil Sutter <phil@nwl.cc>,
        Arturo Borrero Gonzalez <arturo@netfilter.org>,
        Netfilter Development Mailing list
        <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48462 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751286AbdGQQMn (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 17 Jul 2017 12:12:43 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 1BAC624934
        for <netfilter-devel@vger.kernel.org>; Mon, 17 Jul 2017 18:12:30 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0CA8AD1D98
        for <netfilter-devel@vger.kernel.org>; Mon, 17 Jul 2017 18:12:30 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id DF227CE5DC
        for <netfilter-devel@vger.kernel.org>; Mon, 17 Jul 2017 18:12:27 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20170713182202.GK16375@orbyte.nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Jul 13, 2017 at 08:22:02PM +0200, Phil Sutter wrote:
> Just a quick status update: It's a mess. ;)

OK, let's address problems one by one.

> There are so many different cases, I actually started drawing flow
> diagrams (can't remember when I did that last time). In addition to what
> we discussed already, I realized that via 'nft -f', I can make multiple
> changes to even different sets within a single transaction - this
> requires dealing with cached half-open ranges everywhere, not just in
> NEWGEN callback.

half-open ranges always start by a NFT_SET_ELEM_INTERVAL_END flag set
on, eg.

# nft --debug=netlink add element x y { 5-65535 }
element 00000000  : 1 [end]     element 00000500  : 0 [end]

> Another trap is 'nft flush set': The elements are reported in
> reverse order.

Could you have a look at the function to order elements using the
mergesort function? It's currently only called for non-intervals by
now, so it would be good to converge to use it in all cases.

Anything else?
