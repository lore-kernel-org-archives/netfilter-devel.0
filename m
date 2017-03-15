From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH] proto: Add some exotic ICMPv6 types
Date: Wed, 15 Mar 2017 22:47:57 +0100
Message-ID: <20170315214757.GA1289@salvia>
References: <20170315155501.8603-1-phil@nwl.cc>
 <20170315161514.GB28159@salvia>
 <20170315195051.GE17939@orbyte.nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:41932 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752294AbdCOVsS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 15 Mar 2017 17:48:18 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 1AEB4174D07
        for <netfilter-devel@vger.kernel.org>; Wed, 15 Mar 2017 22:48:00 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0C3B0DA7F7
        for <netfilter-devel@vger.kernel.org>; Wed, 15 Mar 2017 22:48:00 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id F403ADA729
        for <netfilter-devel@vger.kernel.org>; Wed, 15 Mar 2017 22:47:57 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20170315195051.GE17939@orbyte.nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Mar 15, 2017 at 08:50:51PM +0100, Phil Sutter wrote:
> On Wed, Mar 15, 2017 at 05:15:14PM +0100, Pablo Neira Ayuso wrote:
> > On Wed, Mar 15, 2017 at 04:55:01PM +0100, Phil Sutter wrote:
> > > This adds support for matching on inverse ND messages as defined by
> > > RFC3122 (not implemented in Linux) and MLDv2 as defined by RFC3810.
> > > 
> > > Note that ICMPV6_MLD2_REPORT macro is defined in linux/icmpv6.h but
> > > including that header leads to conflicts with symbols defined in
> > > netinet/icmp6.h.
> > > 
> > > In addition to the above, "mld-listener-done" is introduced as an alias
> > > for "mld-listener-reduction".
> > > 
> > > Signed-off-by: Phil Sutter <phil@nwl.cc>
> > > ---
> > > This should resolve netfilter BZ#926.
> > > ---
> > >  src/proto.c | 8 ++++++++
> > >  1 file changed, 8 insertions(+)
> > > 
> > > diff --git a/src/proto.c b/src/proto.c
> > > index fb965304e59d9..6a8eed936d858 100644
> > > --- a/src/proto.c
> > > +++ b/src/proto.c
> > > @@ -632,6 +632,10 @@ const struct proto_desc proto_ip = {
> > >  
> > >  #include <netinet/icmp6.h>
> > >  
> > > +#define IND_NEIGHBOR_SOLICIT	141
> > > +#define IND_NEIGHBOR_ADVERT	142
> > > +#define ICMPV6_MLD2_REPORT	143
> > > +
> > >  static const struct symbol_table icmp6_type_tbl = {
> > >  	.base		= BASE_DECIMAL,
> > >  	.symbols	= {
> > > @@ -644,12 +648,16 @@ static const struct symbol_table icmp6_type_tbl = {
> > >  		SYMBOL("mld-listener-query",		MLD_LISTENER_QUERY),
> > >  		SYMBOL("mld-listener-report",		MLD_LISTENER_REPORT),
> > >  		SYMBOL("mld-listener-reduction",	MLD_LISTENER_REDUCTION),
> > > +		SYMBOL("mld-listener-done",		MLD_LISTENER_REDUCTION),
> > 
> > This one is duplicated, right?
> 
> Yes, it is the alias which was suggested in the ticket. Is this OK, or
> should we rather respond with WONTFIX?

Just add this before "mld-listener-reduction" so we use
"mld-listener-done" when printing this back to userspace. So we
prioritize the more appropriate syntax.

> I realize this patch lacks an update to man page and a few test cases.
> Should I reroll or send a follow-up?

Please do, thank you!
