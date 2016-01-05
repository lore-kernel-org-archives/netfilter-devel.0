From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH 2/4] rule: when listing all sets, don't print empty
 tables
Date: Tue, 5 Jan 2016 12:40:29 +0100
Message-ID: <20160105114029.GB9098@salvia>
References: <145190990642.22285.2420592085262978551.stgit@r2d2.cica.es>
 <145190991185.22285.13328538132434564559.stgit@r2d2.cica.es>
 <20160105113544.GA9098@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42202 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751653AbcAELke (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 5 Jan 2016 06:40:34 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 62A071324D9
	for <netfilter-devel@vger.kernel.org>; Tue,  5 Jan 2016 12:40:33 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 4A765DA803
	for <netfilter-devel@vger.kernel.org>; Tue,  5 Jan 2016 12:40:33 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id E0646DA801
	for <netfilter-devel@vger.kernel.org>; Tue,  5 Jan 2016 12:40:30 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20160105113544.GA9098@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Jan 05, 2016 at 12:35:44PM +0100, Pablo Neira Ayuso wrote:
> On Mon, Jan 04, 2016 at 01:18:31PM +0100, Arturo Borrero Gonzalez wrote:
> > diff --git a/src/rule.c b/src/rule.c
> > index 18ff592..c0e45aa 100644
> > --- a/src/rule.c
> > +++ b/src/rule.c
> > @@ -1009,12 +1009,24 @@ static int do_list_sets(struct netlink_ctx *ctx, struct cmd *cmd)
> >  	};
> >  	struct table *table;
> >  	struct set *set;
> > +	bool printable_sets = false;
> >  
> >  	list_for_each_entry(table, &table_list, list) {
> >  		if (cmd->handle.family != NFPROTO_UNSPEC &&
> >  		    cmd->handle.family != table->handle.family)
> >  			continue;
> >  
> > +		/* if there are no printable sets, don't print empty table */
> > +		list_for_each_entry(set, &table->sets, list) {
> > +			if (!set->flags & SET_F_ANONYMOUS) {
> 
> Wait, this should be:
> 
>         if (!(set->flags & SET_F_ANONYMOUS))
> 
> instead.
> 
> I'm fixing this here.

I'm going to keep this back.

We have to provide a consistent behaviour wrt. nft list chains, and
that is listing empty tables when it contains no chains.

I'm unsure here, I considering printing the table with no content
makes sense since the user knows no sets or chains are available
there. If we skip this, it looks like the table doesn't exists. Other
than that, the user is fully aware of having a table with no content.
