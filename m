From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: nftables/libnftnl release plan?
Date: Mon, 18 Sep 2017 19:21:53 +0200
Message-ID: <20170918172153.GA8945@salvia>
References: <20170918161835.GF30364@orbyte.nwl.cc>
 <20170918162453.GA6000@salvia>
 <20170918163240.GA24836@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ganesha.gnumonks.org ([213.95.27.120]:36826 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933072AbdIRRV6 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 18 Sep 2017 13:21:58 -0400
Content-Disposition: inline
In-Reply-To: <20170918163240.GA24836@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Sep 18, 2017 at 06:32:40PM +0200, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > On Mon, Sep 18, 2017 at 06:18:35PM +0200, Phil Sutter wrote:
> > > Hi Pablo,
> > > 
> > > What are your plans regarding release of libnftnl-1.0.8 and
> > > nftables-0.8?
> > 
> > As soon as I can integrate Florian's changes to support
> > 
> >         xyz set x,y
> >
> > comma-separated values in with an assignment statement.
> 
> Is there anything you need from my side?

I wanted to find a little slice of time to hack on the grammar, make
some sketch basically on it only on the parser side. My concern is the
fact that | & and such will not work anymore.

The patchset is large and I remember changes in the grammar were
happening in a way that I was having a hard time to follow track.

Let me have a look in the next days, if no news from before weekend,
let's take what you send as is, OK?
