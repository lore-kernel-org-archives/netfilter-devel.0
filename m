From: Pablo Neira Ayuso <pablo@gnumonks.org>
Subject: Re: [PATCH] netfilter: xt_LOG: avoid using old-style "<.>" printk
 prefix
Date: Wed, 12 Sep 2012 17:06:42 +0200
Message-ID: <20120912150642.GA22197@1984>
References: <874nn5dbx9.fsf@silenus.orebokech.com>
 <20120912124826.GA12726@1984>
 <87392n8j3w.fsf@silenus.orebokech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Patrick McHardy <kaber@trash.net>,
	netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
	coreteam@netfilter.org, Joe Perches <joe@perches.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>, eric.dumazet@gmail.com
To: Romain Francoise <romain@orebokech.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:50201 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759664Ab2ILPGt (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 12 Sep 2012 11:06:49 -0400
Content-Disposition: inline
In-Reply-To: <87392n8j3w.fsf@silenus.orebokech.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Replying from different email, @netfilter.org is currently down due to
some power supply problems.

On Wed, Sep 12, 2012 at 03:29:39PM +0200, Romain Francoise wrote:
> Hi Pablo,
> 
> Pablo Neira Ayuso <pablo@netfilter.org> writes:
> 
> > ebt_log chunk is missing.
> 
> Sorry, didn't notice that it has the same bug. Do you want that in the
> same patch, or separate?
> 
> >>  	m->buf[m->count] = 0;
> >> -	printk("%s\n", m->buf);
> >> +	printk_emit(0, level, NULL, 0, "%s\n", m->buf);
> 
> > I think it should be printk_emit(-1, ... Note facility is -1.
> 
> > Thus, we skip the syslog prefix stripping (we can skip it and save
> > some cycles).
> 
> I don't think that's possible, the facility is copied down to user-space
> consumers and it has to be zero for the message to be identified as
> originating from the kernel (0 is LOG_KERN).

I see.

> As it boils down to a single test for KERN_SOH_ASCII I don't think it
> matters very much.

I'm going to take Joe's patch, I prefer using the printk interface.

Thanks anyway.
