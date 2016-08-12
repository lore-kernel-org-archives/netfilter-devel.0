From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftnl PATCH 2/7] ruleset: Prevent memleak in
 nftnl_ruleset_snprintf_*() functions
Date: Fri, 12 Aug 2016 10:38:41 +0200
Message-ID: <20160812083841.GA1440@salvia>
References: <1470958419-32602-1-git-send-email-phil@nwl.cc>
 <1470958419-32602-3-git-send-email-phil@nwl.cc>
 <20160811234202.GA5290@salvia>
 <20160812004458.GF10197@orbyte.nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org,
	Arturo Borrero <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:54926 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751143AbcHLIj3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 12 Aug 2016 04:39:29 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 5AE0CD162C
	for <netfilter-devel@vger.kernel.org>; Fri, 12 Aug 2016 10:38:45 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 4AF2C1B3329
	for <netfilter-devel@vger.kernel.org>; Fri, 12 Aug 2016 10:38:45 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id D8907A8E1
	for <netfilter-devel@vger.kernel.org>; Fri, 12 Aug 2016 10:38:42 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20160812004458.GF10197@orbyte.nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Aug 12, 2016 at 02:44:58AM +0200, Phil Sutter wrote:
> On Fri, Aug 12, 2016 at 01:42:02AM +0200, Pablo Neira Ayuso wrote:
> > On Fri, Aug 12, 2016 at 01:33:34AM +0200, Phil Sutter wrote:
> > > From: Phil Sutter <psutter@redhat.com>
> > > 
> > > This is an ugly aspect of the SNPRINTF_BUFFER_SIZE() macro: it contains
> > > a return statement and if that triggers, the function returns without
> > > freeing the iterator object. Therefore duplicate the 'ret < 0' check
> > > before calling it, freeing the iterator knowing that we will bail out
> > > immediately afterwards anyway.
> > > 
> > > Cc: Arturo Borrero <arturo.borrero.glez@gmail.com>
> > > Signed-off-by: Phil Sutter <phil@nwl.cc>
> > > ---
> > >  src/ruleset.c | 16 ++++++++++++++++
> > >  1 file changed, 16 insertions(+)
> > > 
> > > diff --git a/src/ruleset.c b/src/ruleset.c
> > > index 666bcc7a246b6..93cf95ab61e15 100644
> > > --- a/src/ruleset.c
> > > +++ b/src/ruleset.c
> > > @@ -888,12 +888,16 @@ nftnl_ruleset_snprintf_table(char *buf, size_t size,
> > >  	t = nftnl_table_list_iter_next(ti);
> > >  	while (t != NULL) {
> > >  		ret = nftnl_table_snprintf(buf+offset, len, t, type, flags);
> > > +		if (ret < 0)
> > > +			nftnl_table_list_iter_destroy(ti);
> > >  		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
> > 
> > Better get rid of the obscure if (ret < 0) hidden in
> > SNPRINT_BUFFER_SIZE.
> > 
> > Or simply set:
> > 
> >         if (ret < 0)
> >                 ret = 0;
> > 
> > in SNPRINT_BUFFER_SIZE.
> 
> Hmm. This means we will lose error propagation. Given how widely this
> macro is being used (grep says 200 calls), this needs a good second
> thought.

The usual suggested idiom to deal with this looks like:

    snprintf(cp, blen, "AF=%d ", sau->soa.sa_family)
    blen -= strlen(cp);
    cp += strlen(cp);

See: https://goo.gl/AUGE5m

No need to second thought, we can just ignore the -1 case.
