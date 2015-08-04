From: Florian Westphal <fw@strlen.de>
Subject: Re: New multiple DSCP match by "-m dscp --dscp-multi value,value,..."
Date: Tue, 4 Aug 2015 11:25:11 +0200
Message-ID: <20150804092511.GD20471@breakpoint.cc>
References: <55BEE85E.2070001@alliedtelesis.co.nz>
 <20150804091935.GA7852@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Kyeong Yoo <Kyeong.Yoo@alliedtelesis.co.nz>,
	"netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:38352 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932421AbbHDJZO (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Aug 2015 05:25:14 -0400
Content-Disposition: inline
In-Reply-To: <20150804091935.GA7852@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Mon, Aug 03, 2015 at 04:04:46AM +0000, Kyeong Yoo wrote:
> > I found this is useful for me to match multiple DSCP values in a rule.
> > 
> > For example, if you want to handle traffic with a list of DSCP same way, 
> > instead of using this:
> > 
> >   -A FORWARD ...cond1... -m dscp --dscp-class AF11 -j TARGET
> >   -A FORWARD ...cond1... -m dscp --dscp-class AF21 -j TARGET
> >   -A FORWARD ...cond1... -m dscp --dscp-class AF31 -j TARGET
> >   -A FORWARD ...cond2... -m dscp --dscp 10 -j TARGET
> >   -A FORWARD ...cond2... -m dscp --dscp 20 -j TARGET
> > 
> > you can use:
> > 
> >   -A FORWARD ...cond1... -m dscp --dscp-multi AF11,AF21,AF31 -j TARGET
> >   -A FORWARD ...cond2... -m dscp --dscp-multi 10,20 -j TARGET
> 
> We support multiple matches in a rule for long time already:
> 
>         -A FORWARD ...cond1...  -m dscp --dscp-class AF11 \
>                                 -m dscp --dscp-class AF21 \
>                                 -m dscp --dscp-class AF31 \

Yes, but that won't work since this is foo && bar, not foo || bar.
