From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf] netfilter: nf_tables: fix addition/deletion of
 elements from commit/abort
Date: Tue, 24 Feb 2015 19:53:19 +0100
Message-ID: <20150224185319.GA32638@salvia>
References: <1424448670-4458-1-git-send-email-pablo@netfilter.org>
 <20150221103917.GA1683@acer.localdomain>
 <20150224135315.GA4322@salvia>
 <20150224143932.GA3713@acer.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44580 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753251AbbBXStr (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 Feb 2015 13:49:47 -0500
Content-Disposition: inline
In-Reply-To: <20150224143932.GA3713@acer.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Feb 24, 2015 at 02:39:33PM +0000, Patrick McHardy wrote:
> On 24.02, Pablo Neira Ayuso wrote:
> > On Sat, Feb 21, 2015 at 10:39:18AM +0000, Patrick McHardy wrote:
> > > On 20.02, Pablo Neira Ayuso wrote:
> > > > We have several problems in this path:
> > > > 
> > > > 1) There is a use-after-free when removing individual elements from
> > > >    the commit path.
> > > > 
> > > > 2) We have to uninit() the data part of the element from the abort
> > > >    path to avoid a chain refcount leak.
> > > > 
> > > > 3) We have to check for set->flags to see if there's a mapping, instead
> > > >    of the element flags.
> > > > 
> > > > 4) We have to check for !(flags & NFT_SET_ELEM_INTERVAL_END) to skip
> > > >    elements that are part of the interval that have no data part, so
> > > >    they don't need to be uninit().
> > > 
> > > Just wondering, in the delete case, don't we need to set the flags in
> > > the sets' ->get() function for this to work?
> > 
> > They are already set from hash and rbtree, so we only need to add the
> > check for NFT_SET_ELEM_INTERVAL_END from the commit path in nf_tables_api.c
> > 
> > Unless you have any further concern, I'll pass up this soon.
> 
> Right, in the hash case it's 0 anyways and rbtree does set them.
> 
> Looks good to me.

Ok, I'll pass this to David, thanks.
