From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH 2/4 v3] src: fix byteorder conversions in simple
 values
Date: Thu, 31 Jul 2014 19:26:07 +0200
Message-ID: <20140731172607.GA4279@salvia>
References: <1406548146-31317-3-git-send-email-alvaroneay@gmail.com>
 <1406653795-8746-1-git-send-email-alvaroneay@gmail.com>
 <20140730111414.GA3674@salvia>
 <20140731170131.GA26503@server.your-server.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Alvaro Neira Ayuso <alvaroneay@gmail.com>,
	netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49232 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751394AbaGaR0G (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 31 Jul 2014 13:26:06 -0400
Content-Disposition: inline
In-Reply-To: <20140731170131.GA26503@server.your-server.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Jul 31, 2014 at 07:01:31PM +0200, Patrick McHardy wrote:
> On Wed, Jul 30, 2014 at 01:14:14PM +0200, Pablo Neira Ayuso wrote:
> > Some comments below.
> > 
> > On Tue, Jul 29, 2014 at 07:09:55PM +0200, Alvaro Neira Ayuso wrote:
> > > --- a/src/datatype.c
> > > +++ b/src/datatype.c
> > > @@ -255,8 +255,11 @@ static struct error_record *integer_type_parse(const struct expr *sym,
> > >  			     sym->dtype->desc);
> > >  	}
> > >  
> > > +	/* If we use integer type, we must to convert it to big endian for
> > > +	 * using it in internet format (big endian).
> > > +	 */
> > >  	*res = constant_expr_alloc(&sym->location, sym->dtype,
> > > -				   BYTEORDER_HOST_ENDIAN, 1, NULL);
> > > +				   BYTEORDER_BIG_ENDIAN, 1, NULL);
> > 
> > I guess sym->dtype->byteorder still indicates invalid byteorder when
> > you call datatype_parse, right?
> 
> This all looks quite strange to me. When parsing the integer it is
> of course always in host byteorder. We simply need to add the conversion
> in the correct spot, this should be quite minimal.

Right. IIRC he is trying to fix payload matching of rare header fields
for which the integer_type is used, which are currently sent in host
byte order to the kernel. I guess the right spot for this is the
evaluation step.

> Please do not apply any of these patches until I can get a good look at
> this. Should get a new notebook any day now.

No problem, thanks Patrick.
