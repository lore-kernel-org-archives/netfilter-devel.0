From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nft 7/7] tests: add tcp option set support / tcp mss
 mangling test cases
Date: Mon, 21 Aug 2017 16:28:25 +0200
Message-ID: <20170821142825.GB740@breakpoint.cc>
References: <20170819231413.15164-1-fw@strlen.de>
 <20170819231413.15164-8-fw@strlen.de>
 <20170821141417.GF6076@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:45174 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751654AbdHUOaz (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 21 Aug 2017 10:30:55 -0400
Content-Disposition: inline
In-Reply-To: <20170821141417.GF6076@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> Thanks for adding tests.
> 
> On Sun, Aug 20, 2017 at 01:14:13AM +0200, Florian Westphal wrote:
> > diff --git a/tests/py/inet/tcpopt.t b/tests/py/inet/tcpopt.t
> > index a42ecd250a9c..94ad3fc4c645 100644
> > --- a/tests/py/inet/tcpopt.t
> > +++ b/tests/py/inet/tcpopt.t
> > @@ -38,3 +38,6 @@ tcp option sack window 1;fail
> >  
> >  tcp option window exists;ok
> >  tcp option window missing;ok
> > +
> > +tcp option maxseg size set 1360;ok;tcp option mss set 1360
> 
> This is a follow up, related to 5/7.
> 
> Why do we need this assymetry at all?

it is same 'meta iif ethx' vs 'iif ethx'

I can drop the 'tcp option <option type> <field>' syntax
which means we need to add extra grammar for all 'tcp option set'
type/field combinations that we want to support.

Or we can drop the compact representation, but i find
'tcp option maxseg size' to be uglier than 'tcp option mss'.
