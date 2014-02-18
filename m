From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft RFC PATCH 6/6] src: add events reporting
Date: Tue, 18 Feb 2014 10:28:11 +0100
Message-ID: <20140218092811.GA3880@localhost>
References: <20140217231654.19943.18736.stgit@nfdev.cica.es>
 <20140217231837.19943.77406.stgit@nfdev.cica.es>
 <20140218011007.GA4456@localhost>
 <20140218020354.GG12893@macbook.localnet>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>,
	netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59547 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754652AbaBRJ2R (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 18 Feb 2014 04:28:17 -0500
Content-Disposition: inline
In-Reply-To: <20140218020354.GG12893@macbook.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Feb 18, 2014 at 02:03:55AM +0000, Patrick McHardy wrote:
> On Tue, Feb 18, 2014 at 02:10:07AM +0100, Pablo Neira Ayuso wrote:
> > On Tue, Feb 18, 2014 at 12:18:38AM +0100, Arturo Borrero Gonzalez wrote:
> > > +static int netlink_events_table_cb(const struct nlmsghdr *nlh, int type,
> > > +				   struct netlink_ev_handler *evh)
> > > +{
> > > +	struct nft_table *nlt;
> > > +	uint32_t family;
> > > +	char buf[4096];
> > > +
> > > +	nlt = nft_table_alloc();
> > > +	if (nlt == NULL)
> > > +		memory_allocation_error();
> > > +
> > > +	if (nft_table_nlmsg_parse(nlh, nlt) < 0) {
> > > +		netlink_io_error(evh->ctx, evh->loc,
> > > +				"Could not parse table: %s",
> > > +				strerror(errno));
> > 
> > I think you should exit on parsing errors.
> 
> I'm not so sure for event reporting. We should abort reporting the current
> event, sure. But I don't see why we shouldn't continue listering for further
> events.

I think if we fail to parse anything it means that there's some bug
that need to be fixed, eg. someone changed the length of an attribute
so validation fails. I think stopping there should help us to get
people reporting problems.
