From: Phil Sutter <phil@nwl.cc>
Subject: Re: [nft PATCH 1/4] monitor: Fix printing of range elements in named
 sets
Date: Thu, 13 Jul 2017 20:22:02 +0200
Message-ID: <20170713182202.GK16375@orbyte.nwl.cc>
References: <20170712123658.25363-1-phil@nwl.cc>
 <20170712123658.25363-2-phil@nwl.cc>
 <CAOkSjBhX1=DJuY9M8P0axCQkMyjZyweea9tROnGSHM=WqRq47A@mail.gmail.com>
 <20170712190545.GC16375@orbyte.nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Arturo Borrero Gonzalez <arturo@netfilter.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Development Mailing list
        <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:58689 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752072AbdGMSWE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 13 Jul 2017 14:22:04 -0400
Content-Disposition: inline
In-Reply-To: <20170712190545.GC16375@orbyte.nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jul 12, 2017 at 09:05:45PM +0200, Phil Sutter wrote:
> On Wed, Jul 12, 2017 at 06:30:47PM +0200, Arturo Borrero Gonzalez wrote:
[...]
> > Could this logic be merged into that function? My goal is to only
> > print from one code path.
> 
> Yes, that makes sense. I found it too cumbersome to squeeze the
> additional logic into netlink_events_setelem_cb(), hence why I went with
> a separate function. I'll give it another try. In doubt I'll move the
> printing logic into a separate function to be called from both places.
> 
> I'll prepare a v2 tomorrow, also merging the previous two patches as
> suggested.

Just a quick status update: It's a mess. ;)

There are so many different cases, I actually started drawing flow
diagrams (can't remember when I did that last time). In addition to what
we discussed already, I realized that via 'nft -f', I can make multiple
changes to even different sets within a single transaction - this
requires dealing with cached half-open ranges everywhere, not just in
NEWGEN callback. Another trap is 'nft flush set': The elements are
reported in reverse order. Anyway, I have something that seems to work
but needs quite some cleanup before I dare to publish it. :)

I should probably look into ways to write tests for this to get all the
cases covered.

Cheers, Phil
