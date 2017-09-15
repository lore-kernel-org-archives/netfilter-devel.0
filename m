From: Florian Westphal <fw@strlen.de>
Subject: Re: nft typeof keywork patch
Date: Fri, 15 Sep 2017 13:02:43 +0200
Message-ID: <20170915110243.GA27110@breakpoint.cc>
References: <20170912172527.GC25977@breakpoint.cc>
 <20170913115823.GA2297@salvia>
 <20170913152728.GB2453@breakpoint.cc>
 <20170913154318.GA4681@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:40560 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751213AbdIOLFx (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 15 Sep 2017 07:05:53 -0400
Content-Disposition: inline
In-Reply-To: <20170913154318.GA4681@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

> > Wait, so
> >     nft add set ip filter set1 { typeof ip saddr;}
> > 
> > then it should not list
> >     nft add set ip filter set1 { type ipv4_addr;}
> > 
> > but the exact input using the typeof()?
> > 
> > I wonder how to encode this, especially given we also need to support
> > concatenation, e.g.

I've started with this, first item i am working on is to change
struct set to pass in struct expr *key instead of datatype+len to make
the original expression (meta iifname for example) available to the
linerize parts so we can stash this info in the udata.

For "typeof(meta iifname) . mark" case the parser will generate a concat
expression, and, since these keep the original expr around we can
iterate over that list to get back the original expressions.

For the normal 'type' case, i think we can simply use a dummy
constant expression to serve as a container for the data type.

What do you think?
