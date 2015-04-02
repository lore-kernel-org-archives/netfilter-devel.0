From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 0/5] netfilter: nf_tables: set timeout support
Date: Thu, 2 Apr 2015 11:20:02 +0200
Message-ID: <20150402092001.GA9108@acer.localdomain>
References: <1427373580-19310-1-git-send-email-kaber@trash.net>
 <20150402085200.GA18386@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:58496 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752628AbbDBJUI (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 2 Apr 2015 05:20:08 -0400
Content-Disposition: inline
In-Reply-To: <20150402085200.GA18386@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 02.04, Pablo Neira Ayuso wrote:
> On Thu, Mar 26, 2015 at 12:39:35PM +0000, Patrick McHardy wrote:
> > These patches add support for set timeouts. Sets can have a default
> > timeout value that can be overriden by element specific timeouts.
> > 
> > Removal of expired elements will usually be performed by a garbage
> > collector for two reasons: avoiding an excessive number of timers
> > and because data deinit has to happen in process context.
> > 
> > The first two patches add the required netlink attributes, parsing,
> > dump etc. A set of GC helper functions for batched RCU element
> > destruction is added in patch three, some synchronization helpers
> > to avoid races between async GC and netlink insertion and removal
> > of elements are added in patch four.
> > 
> > Following patches will use this infrastrucure to support set updates
> > from the packet classification path for dynamic sets and dynamic
> > flow state maintenance.
> > 
> > Please apply, thanks!
> 
> Series applied, thanks Patrick.

Thanks, I'll send the next batch soon.

> BTW, what's your plan with the rbtree and timeouts?

No specific plans so far. It would be fairly easy to add them, however
we'll always chose nft_hash unless intervals are used anyway, and in
that case it doesn't make too much sense to have timeouts as long
as we have no real knowledge of intervals within the kernel.
