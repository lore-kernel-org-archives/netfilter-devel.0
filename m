From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: New multiple DSCP match by "-m dscp --dscp-multi value,value,..."
Date: Tue, 4 Aug 2015 11:35:10 +0200
Message-ID: <20150804093510.GA8019@salvia>
References: <55BEE85E.2070001@alliedtelesis.co.nz>
 <20150804091935.GA7852@salvia>
 <20150804092511.GD20471@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Kyeong Yoo <Kyeong.Yoo@alliedtelesis.co.nz>,
	"netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:50287 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754495AbbHDJ3L (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Aug 2015 05:29:11 -0400
Content-Disposition: inline
In-Reply-To: <20150804092511.GD20471@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Aug 04, 2015 at 11:25:11AM +0200, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > On Mon, Aug 03, 2015 at 04:04:46AM +0000, Kyeong Yoo wrote:
> > > I found this is useful for me to match multiple DSCP values in a rule.
> > > 
> > > For example, if you want to handle traffic with a list of DSCP same way, 
> > > instead of using this:
> > > 
> > >   -A FORWARD ...cond1... -m dscp --dscp-class AF11 -j TARGET
> > >   -A FORWARD ...cond1... -m dscp --dscp-class AF21 -j TARGET
> > >   -A FORWARD ...cond1... -m dscp --dscp-class AF31 -j TARGET
> > >   -A FORWARD ...cond2... -m dscp --dscp 10 -j TARGET
> > >   -A FORWARD ...cond2... -m dscp --dscp 20 -j TARGET
> > > 
> > > you can use:
> > > 
> > >   -A FORWARD ...cond1... -m dscp --dscp-multi AF11,AF21,AF31 -j TARGET
> > >   -A FORWARD ...cond2... -m dscp --dscp-multi 10,20 -j TARGET
> > 
> > We support multiple matches in a rule for long time already:
> > 
> >         -A FORWARD ...cond1...  -m dscp --dscp-class AF11 \
> >                                 -m dscp --dscp-class AF21 \
> >                                 -m dscp --dscp-class AF31 \
> 
> Yes, but that won't work since this is foo && bar, not foo || bar.

Oh I see. I don't like this combo updates, we may keep receiving
patches to do the same thing for other matches in iptables.

nftables resolves this problem through dictionaries, please have a
look at that.
