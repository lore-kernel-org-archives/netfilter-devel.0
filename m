From: Phil Sutter <phil@nwl.cc>
Subject: Re: [nft PATCH v3 2/3] monitor: Fix printing of range elements in
 named sets
Date: Wed, 19 Jul 2017 20:22:49 +0200
Message-ID: <20170719182249.GD16375@orbyte.nwl.cc>
References: <20170719130529.25398-1-phil@nwl.cc>
 <20170719130529.25398-3-phil@nwl.cc>
 <20170719171736.GB18828@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org,
        Arturo Borrero Gonzalez <arturo@netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:47965 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752858AbdGSSWv (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 19 Jul 2017 14:22:51 -0400
Content-Disposition: inline
In-Reply-To: <20170719171736.GB18828@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jul 19, 2017 at 07:17:36PM +0200, Pablo Neira Ayuso wrote:
> On Wed, Jul 19, 2017 at 03:05:28PM +0200, Phil Sutter wrote:
> > diff --git a/include/rule.h b/include/rule.h
> > index a25e99bdf4cfd..6acd5fa810ef5 100644
> > --- a/include/rule.h
> > +++ b/include/rule.h
> > @@ -217,6 +217,7 @@ extern struct rule *rule_lookup(const struct chain *chain, uint64_t handle);
> >   * @datalen:	mapping data len
> >   * @objtype:	mapping object type
> >   * @init:	initializer
> > + * @rg_cache:	cached range element (left)
> 
> Just a side note. This field is very much exclusive to event monitor
> printing, I would prefer this is cached somewhere else, away from the
> structure, if possible.

My solution was to make dummyset static and use it as a cache. Would
that be acceptible? I went with Arturo's solution since you seemed to
appreciate it and I didn't want to "steal" his credit. :)

Cheers, Phil
