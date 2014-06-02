From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [ulogd PATCH 12/13] nfct: introduce new out keys for ipfix
 timestamp
Date: Mon, 2 Jun 2014 11:52:37 +0200
Message-ID: <20140602095237.GA15230@localhost>
References: <20140308010344.GA4415@gmail.com>
 <20140428113936.GA12523@gmail.com>
 <20140428115621.GM12523@gmail.com>
 <1401618512.2562.3.camel@ice-age2.regit.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ken-ichirou MATSUZAWA <chamaken@gmail.com>,
	The netfilter developer mailinglist
	<netfilter-devel@vger.kernel.org>
To: Eric Leblond <eric@regit.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40504 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752745AbaFBJwq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 2 Jun 2014 05:52:46 -0400
Content-Disposition: inline
In-Reply-To: <1401618512.2562.3.camel@ice-age2.regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Jun 01, 2014 at 12:28:32PM +0200, Eric Leblond wrote:
> On Mon, 2014-04-28 at 20:56 +0900, Ken-ichirou MATSUZAWA wrote:
> > Signed-off-by Ken-ichirou MATSUZAWA <chamas@h4.dion.ne.jp>
> > ---
> >  input/flow/ulogd_inpflow_NFCT.c | 23 +++++++++++++++++++++++
> >  1 file changed, 23 insertions(+)
> > 
> > diff --git a/input/flow/ulogd_inpflow_NFCT.c b/input/flow/ulogd_inpflow_NFCT.c
> > index 4f4301e..b31c46f 100644
> > --- a/input/flow/ulogd_inpflow_NFCT.c
> > +++ b/input/flow/ulogd_inpflow_NFCT.c
> > @@ -186,8 +186,10 @@ enum nfct_keys {
> >  	NFCT_CT_EVENT,
> >  	NFCT_FLOW_START_SEC,
> >  	NFCT_FLOW_START_USEC,
> > +	NFCT_FLOW_START_MCSEC,

Perhaps you can consolidate this and provide just one single keys in
milliseconds?

> >  	NFCT_FLOW_END_SEC,
> >  	NFCT_FLOW_END_USEC,
> > +	NFCT_FLOW_END_MCSEC,
> >  	NFCT_OOB_FAMILY,
> >  	NFCT_OOB_PROTOCOL,
> >  	NFCT_CT,

It will just need to adapt other extensions to use it.
