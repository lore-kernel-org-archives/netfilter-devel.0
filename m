From: Patrick McHardy <kaber@trash.net>
Subject: Re: libnftables set element printing, DATA_CHAIN
Date: Thu, 16 Jan 2014 10:40:53 +0000
Message-ID: <20140116104053.GA28413@macbook.localnet>
References: <20140115225002.GA13700@macbook.localnet>
 <CAOkSjBjD7VBgErC08C387u6Lgetx8m7mtBfe4khpRLWbahsHJA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:54625 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751520AbaAPKk5 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 16 Jan 2014 05:40:57 -0500
Content-Disposition: inline
In-Reply-To: <CAOkSjBjD7VBgErC08C387u6Lgetx8m7mtBfe4khpRLWbahsHJA@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Jan 16, 2014 at 11:30:26AM +0100, Arturo Borrero Gonzalez wrote:
> On 15 January 2014 23:50, Patrick McHardy <kaber@trash.net> wrote:
> > [resending because of incorrect list address]
> >
> > I was looking at some incorrect output in netlink debugging for set elements
> > and noticed a few things that seem odd:
> >
> > First, the regular netlink debugging seems very incomplete, it doesn't
> > print verdict types, it prints [end] whether the set contains intervals
> > and the set is an interval end or not and its messing up the output.
> >
> 
> It's true, most of the development went to the JSON/XML formats, not
> the default one.
> 
> > Next I'm wondering about what DATA_CHAIN is supposed to be. I guess its
> > the chain for a jump or goto verdict, This is even encoded in the
> > XML and JSON output. This seems wrong to me, there is no DATA_CHAIN,
> > there are JUMP or GOTO verdicts that include a chain. The specific
> > verdict is also missing, so its not possible to distinguish these
> > two cases.
> >
> 
> Ok, let's fix that. Do you have a proposal?
> 
> This is what I think you want:
> 
> * a <data_reg type=value> with raw data.
> * a <data_reg type=verdict> with a concrete verdict (eg drop accept)
> * a <data_reg type=jump> with a chain to jump to.
> * a <data_reg type=goto> with a chain to go to.
> 
> Or maybe:
> 
> * a <data_reg type=value> with raw data.
> * a <data_reg type=verdict> with a concrete verdict (eg drop accept)
> and if verdict == jump or goto, then a <chain> with the destination.

Yes, this is what I think we should do.

> > I could fix up the debugging output, but this looks like someone more
> > familiar with the XML and JSON stuff should have a look at this and
> > fix all of this consistently before we release it as wire format.
> 
> I can handle it.

Great, thanks a lot.
