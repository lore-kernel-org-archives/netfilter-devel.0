From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftables PATCH 7/7] chain: handle attribute is relevant if
 only there is no name to use
Date: Wed, 15 May 2013 15:40:10 +0200
Message-ID: <20130515134010.GA1577@localhost>
References: <519216B6.7060701@linux.intel.com>
 <1368528682-10041-1-git-send-email-tomasz.bursztyka@linux.intel.com>
 <1368528682-10041-8-git-send-email-tomasz.bursztyka@linux.intel.com>
 <20130514222051.GB10082@localhost>
 <5193265B.3050605@linux.intel.com>
 <20130515124330.GA1349@localhost>
 <51938852.1070705@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47659 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757296Ab3EONkS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 15 May 2013 09:40:18 -0400
Content-Disposition: inline
In-Reply-To: <51938852.1070705@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, May 15, 2013 at 04:06:26PM +0300, Tomasz Bursztyka wrote:
> Hi Pablo,
> >But the handle number is built into the netlink message if the client
> >sets the NFT_CHAIN_ATTR_HANDLE. Looking at iptables-nftables, that
> >only happens in nft_chain_user_rename.
> >
> >This seems to me like the client needs to be fixed not to set both
> >attributes at the same time (unless it wants a chain rename).
> >
> >Where are you hitting this?
> >
> 
> I was actually playing on my own with libnftables.
> It's easy: dump the chain list, then change the policy on one chain
> for instance, build the message to apply this change, send it...
> 
> We haven't hit the bug yet anywhere, because no code does such
> settings change after a dump, but we - or whatever app - surely will
> at some point.

We should document that. I have a patch to add the doxygen doc to
libnftables. I prefer that user is in control of this, instead of
adding internal workarounds to avoid tricky situations.
