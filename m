From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH 1/4] mnl: Drop --echo support for non-batch calls
Date: Tue, 15 Aug 2017 13:48:27 +0200
Message-ID: <20170815114827.GA20284@salvia>
References: <20170814234305.2829-1-phil@nwl.cc>
 <20170814234305.2829-2-phil@nwl.cc>
 <20170815102500.GA3928@salvia>
 <20170815110504.GX16375@orbyte.nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ganesha.gnumonks.org ([213.95.27.120]:56283 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751129AbdHOLsw (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 15 Aug 2017 07:48:52 -0400
Content-Disposition: inline
In-Reply-To: <20170815110504.GX16375@orbyte.nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Aug 15, 2017 at 01:05:04PM +0200, Phil Sutter wrote:
> Hi,
> 
> On Tue, Aug 15, 2017 at 12:25:00PM +0200, Pablo Neira Ayuso wrote:
> > On Tue, Aug 15, 2017 at 01:43:02AM +0200, Phil Sutter wrote:
> [...]
> > > I didn't notice this because I didn't test for kernels without support
> > > for transactions. This has been added to nftables in kernel version 3.16
> > > back in 2014. Since then, user space which doesn't support it can't even
> > > add a table anymore. So adding this new feature to the old code path is
> > > really not feasible, therefore drop this broken attempt at supporting
> > > it.
> > 
> > We fixed this problem with nft and 3.16 IIRC. So at least the very
> > basic featureset still available there works fine.
> 
> I was speaking of the other way around, namely old user space with
> kernel >= 3.16 (that's what I simulated by forcing batch_supported to
> false).
> 
> Given that kernel user API isn't completely compatible, do you see a
> chance to drop the non-batch code from user space at some point?

Yes, as soon as 3.16 becomes unsupported we can let that code sink I
would suggest.
