From: Thomas Graf <tgraf@suug.ch>
Subject: Re: [PATCH 1/3] netfilter: nft_hash: no need for rcu in the hash set
 destroy path
Date: Tue, 2 Sep 2014 13:36:08 +0100
Message-ID: <20140902123608.GA18850@casper.infradead.org>
References: <1409650721-9621-1-git-send-email-pablo@netfilter.org>
 <20140902101440.GA12450@acer.localdomain>
 <20140902103856.GA10730@salvia>
 <20140902105920.GB12450@acer.localdomain>
 <20140902122207.GA11880@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:33779 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753930AbaIBMgJ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 2 Sep 2014 08:36:09 -0400
Content-Disposition: inline
In-Reply-To: <20140902122207.GA11880@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 09/02/14 at 02:22pm, Pablo Neira Ayuso wrote:
> On Tue, Sep 02, 2014 at 11:59:22AM +0100, Patrick McHardy wrote:
> > > The anonymous sets are problematic, we need to notify this from the
> > > commit path too to ensure the right ordering. I was trying to avoid
> > > some specific notify() interface in expr->ops but it seems we need it
> > > for nft_lookup.c.
> > > 
> > > Can you think of a better solution?
> > 
> > No, unless we can come up with a way that's synchronous.
> 
> I would really like not to go back to the two nearly consecutive
> synchronize_rcu() calls, it's slow.  I've been thinking on replacing
> the current check in the packet path by static keys, but I didn't
> manage to find the way yet.

Slight warning on additional complexity down the road: I'm about to
propose a rhashtable enhancement to move expansion/shrinking to a
async worker thread and protect insertion/removal by an array of
spinlocks. It will allow for much faster parallel inclusion/removal
but will require a sync on destruction to cancel/wait for any
outstanding/ongoing maintenance on the hash table.
