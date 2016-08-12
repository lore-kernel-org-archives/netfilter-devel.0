From: Phil Sutter <phil@nwl.cc>
Subject: Re: [libnftnl PATCH 2/7] ruleset: Prevent memleak in
 nftnl_ruleset_snprintf_*() functions
Date: Fri, 12 Aug 2016 02:44:58 +0200
Message-ID: <20160812004458.GF10197@orbyte.nwl.cc>
References: <1470958419-32602-1-git-send-email-phil@nwl.cc>
 <1470958419-32602-3-git-send-email-phil@nwl.cc>
 <20160811234202.GA5290@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org,
	Arturo Borrero <arturo.borrero.glez@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:59366 "EHLO mail.nwl.cc"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752040AbcHLApA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 11 Aug 2016 20:45:00 -0400
Content-Disposition: inline
In-Reply-To: <20160811234202.GA5290@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Aug 12, 2016 at 01:42:02AM +0200, Pablo Neira Ayuso wrote:
> On Fri, Aug 12, 2016 at 01:33:34AM +0200, Phil Sutter wrote:
> > From: Phil Sutter <psutter@redhat.com>
> > 
> > This is an ugly aspect of the SNPRINTF_BUFFER_SIZE() macro: it contains
> > a return statement and if that triggers, the function returns without
> > freeing the iterator object. Therefore duplicate the 'ret < 0' check
> > before calling it, freeing the iterator knowing that we will bail out
> > immediately afterwards anyway.
> > 
> > Cc: Arturo Borrero <arturo.borrero.glez@gmail.com>
> > Signed-off-by: Phil Sutter <phil@nwl.cc>
> > ---
> >  src/ruleset.c | 16 ++++++++++++++++
> >  1 file changed, 16 insertions(+)
> > 
> > diff --git a/src/ruleset.c b/src/ruleset.c
> > index 666bcc7a246b6..93cf95ab61e15 100644
> > --- a/src/ruleset.c
> > +++ b/src/ruleset.c
> > @@ -888,12 +888,16 @@ nftnl_ruleset_snprintf_table(char *buf, size_t size,
> >  	t = nftnl_table_list_iter_next(ti);
> >  	while (t != NULL) {
> >  		ret = nftnl_table_snprintf(buf+offset, len, t, type, flags);
> > +		if (ret < 0)
> > +			nftnl_table_list_iter_destroy(ti);
> >  		SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
> 
> Better get rid of the obscure if (ret < 0) hidden in
> SNPRINT_BUFFER_SIZE.
> 
> Or simply set:
> 
>         if (ret < 0)
>                 ret = 0;
> 
> in SNPRINT_BUFFER_SIZE.

Hmm. This means we will lose error propagation. Given how widely this
macro is being used (grep says 200 calls), this needs a good second
thought.

Thanks, Phil
