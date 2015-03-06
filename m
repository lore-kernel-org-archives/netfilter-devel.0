From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 0/3] netfilter: nf_tables cleanups
Date: Fri, 6 Mar 2015 00:41:39 +0000
Message-ID: <20150306004139.GA5606@acer.localdomain>
References: <1425413406-6804-1-git-send-email-kaber@trash.net>
 <20150306001318.GA18260@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:32873 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752592AbbCFAlo (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 5 Mar 2015 19:41:44 -0500
Content-Disposition: inline
In-Reply-To: <20150306001318.GA18260@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 06.03, Pablo Neira Ayuso wrote:
> On Tue, Mar 03, 2015 at 08:10:03PM +0000, Patrick McHardy wrote:
> > These patches for -next contain some cleanups which are not directly
> > related to the following set patches, so I'm sending them seperately
> > for easier review:
> > 
> >  * move the reoccuring checks for skb->nf_trace to an inline function
> >  * consolidate similar invocations of nft_trace_packet()
> >  * rearrange nf_tables.h so related things are next to each other
> 
> Applied, thanks Patrick.
> 
> I'll send another net-next batch with accumulated patches just after
> David gets the pending fixes. Then ask for net to go into net-next,
> sorry I cannot go any faster.

Thanks Pablo, I expected this will take a while.
