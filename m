From: Phil Sutter <phil@nwl.cc>
Subject: Re: [nft PATCH] Don't merge adjacent/overlapping ranges by default
Date: Wed, 10 Jan 2018 13:44:26 +0100
Message-ID: <20180110124426.GP32305@orbyte.nwl.cc>
References: <20180110104221.3565-1-phil@nwl.cc>
 <20180110115100.z3hbazlk4w7lekga@salvia>
 <20180110115725.GO32305@orbyte.nwl.cc>
 <20180110120801.xq6hgryqjdif57xf@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:58642 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934345AbeAJMo2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 10 Jan 2018 07:44:28 -0500
Content-Disposition: inline
In-Reply-To: <20180110120801.xq6hgryqjdif57xf@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hey!

On Wed, Jan 10, 2018 at 01:08:01PM +0100, Pablo Neira Ayuso wrote:
> On Wed, Jan 10, 2018 at 12:57:25PM +0100, Phil Sutter wrote:
> > Hi Pablo,
> > 
> > On Wed, Jan 10, 2018 at 12:51:00PM +0100, Pablo Neira Ayuso wrote:
> > [...]
> > > I would disable this by default by now, no option.
> > > 
> > > Then, revisit this later on to see if it's worth adding this, thanks!
> > 
> > Should I drop everything that's needed to make it optional or just
> > remove the option from src/main.c?
> 
> Yes please. Thanks Phil.

You can't answer "yes" to an either-or-question! :P
