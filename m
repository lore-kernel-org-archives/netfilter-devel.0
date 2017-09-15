From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: nft typeof keywork patch
Date: Fri, 15 Sep 2017 13:26:59 +0200
Message-ID: <20170915112659.GB29676@salvia>
References: <20170912172527.GC25977@breakpoint.cc>
 <20170913115823.GA2297@salvia>
 <20170913152728.GB2453@breakpoint.cc>
 <20170913154318.GA4681@salvia>
 <20170915110243.GA27110@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ganesha.gnumonks.org ([213.95.27.120]:38783 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751369AbdIOL1a (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 15 Sep 2017 07:27:30 -0400
Content-Disposition: inline
In-Reply-To: <20170915110243.GA27110@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Sep 15, 2017 at 01:02:43PM +0200, Florian Westphal wrote:
> > > Wait, so
> > >     nft add set ip filter set1 { typeof ip saddr;}
> > > 
> > > then it should not list
> > >     nft add set ip filter set1 { type ipv4_addr;}
> > > 
> > > but the exact input using the typeof()?
> > > 
> > > I wonder how to encode this, especially given we also need to support
> > > concatenation, e.g.
> 
> I've started with this, first item i am working on is to change
> struct set to pass in struct expr *key instead of datatype+len to make
> the original expression (meta iifname for example) available to the
> linerize parts so we can stash this info in the udata.
> 
> For "typeof(meta iifname) . mark" case the parser will generate a concat
> expression, and, since these keep the original expr around we can
> iterate over that list to get back the original expressions.

Yes, a list is going to be much cleaner and I would expect it simplies
the code. I remember Carlos Falgueras sent me a patch for this in a
batch he made, however, for whatever reason it never reached upstream.

> For the normal 'type' case, i think we can simply use a dummy
> constant expression to serve as a container for the data type.
> 
> What do you think?

Sounds reasonable, give a shot.
