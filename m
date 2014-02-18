From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft RFC PATCH 6/6] src: add events reporting
Date: Tue, 18 Feb 2014 10:58:29 +0100
Message-ID: <20140218095829.GA4173@localhost>
References: <20140217231654.19943.18736.stgit@nfdev.cica.es>
 <20140217231837.19943.77406.stgit@nfdev.cica.es>
 <20140218011007.GA4456@localhost>
 <20140218020354.GG12893@macbook.localnet>
 <20140218092811.GA3880@localhost>
 <20140218093311.GA11507@macbook.localnet>
 <20140218094320.GA4009@localhost>
 <20140218095209.GA12005@macbook.localnet>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>,
	netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42349 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754749AbaBRJ6g (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 18 Feb 2014 04:58:36 -0500
Content-Disposition: inline
In-Reply-To: <20140218095209.GA12005@macbook.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Feb 18, 2014 at 09:52:10AM +0000, Patrick McHardy wrote:
> On Tue, Feb 18, 2014 at 10:43:20AM +0100, Pablo Neira Ayuso wrote:
> > On Tue, Feb 18, 2014 at 09:33:11AM +0000, Patrick McHardy wrote:
> > > On Tue, Feb 18, 2014 at 10:28:11AM +0100, Pablo Neira Ayuso wrote:
> > > > On Tue, Feb 18, 2014 at 02:03:55AM +0000, Patrick McHardy wrote:
> > > > > On Tue, Feb 18, 2014 at 02:10:07AM +0100, Pablo Neira Ayuso wrote:
> > > > > > On Tue, Feb 18, 2014 at 12:18:38AM +0100, Arturo Borrero Gonzalez wrote:
> > > > > > > +static int netlink_events_table_cb(const struct nlmsghdr *nlh, int type,
> > > > > > > +				   struct netlink_ev_handler *evh)
> > > > > > > +{
> > > > > > > +	struct nft_table *nlt;
> > > > > > > +	uint32_t family;
> > > > > > > +	char buf[4096];
> > > > > > > +
> > > > > > > +	nlt = nft_table_alloc();
> > > > > > > +	if (nlt == NULL)
> > > > > > > +		memory_allocation_error();
> > > > > > > +
> > > > > > > +	if (nft_table_nlmsg_parse(nlh, nlt) < 0) {
> > > > > > > +		netlink_io_error(evh->ctx, evh->loc,
> > > > > > > +				"Could not parse table: %s",
> > > > > > > +				strerror(errno));
> > > > > > 
> > > > > > I think you should exit on parsing errors.
> > > > > 
> > > > > I'm not so sure for event reporting. We should abort reporting the current
> > > > > event, sure. But I don't see why we shouldn't continue listering for further
> > > > > events.
> > > > 
> > > > I think if we fail to parse anything it means that there's some bug
> > > > that need to be fixed, eg. someone changed the length of an attribute
> > > > so validation fails. I think stopping there should help us to get
> > > > people reporting problems.
> > > 
> > > Well, it depends on what exactly we couldn't parse or handle. Basic things
> > > like table names etc. can of course trigger a fatal error. But unknown
> > > expression types shouldn't cause an error.
> > 
> > As i said, unknown netlink attributes are skipped.
> > 
> > That function is not building *any* struct expr *, it's just
> > generating the libnftnl nft_table object that is used to obtain the
> > internal table object in a later stage. If it fails there's something
> > that need to be fixed in that code.
> 
> Sure, just wanted to be clear about which types of errors may cause
> a fatal error.

Talking about errors when building the higher level expression tree
from the netlink message, I think nft should output some low-level
expression if it fails to interpret it in a human readable way / nft
syntax way.

We already discussed that third party applications may decide to skip
nft as use the netlink interface to build sophisticated filters, in
that case, I think those tools should not break the output of nft if
it fails to understand what it gets from the kernel.
