From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: conntrackd, internal cache keeps filling up
Date: Mon, 12 May 2014 18:35:38 +0200
Message-ID: <20140512163538.GA13344@localhost>
References: <20140505104058.GA30297@finrod>
 <20140509113129.GA8031@localhost>
 <20140510061743.GA32197@finrod>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org
To: Martin Kraus <lists_mk@wujiman.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45723 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752124AbaELQft (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 12 May 2014 12:35:49 -0400
Content-Disposition: inline
In-Reply-To: <20140510061743.GA32197@finrod>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, May 10, 2014 at 08:17:45AM +0200, Martin Kraus wrote:
> On Fri, May 09, 2014 at 01:31:29PM +0200, Pablo Neira Ayuso wrote:
> > > There's thousands of these entries and in a few days they'll fill up the
> > > internal cache and break internal routing.
> > 
> > Could you retry with lastest conntrackd version? 1.4.2.
> 
> will try 1.4.2. we just need to package it.

OK.

> > You didn't specify your Linux kernel version either. Thanks.
> 
> current kernel is 3.13.7. 
> 
> we already hit a bug in the official 3.2 kernel packaged with wheezy where 
> our scan for heartbleed vulnerability would cause conntrackd to kernel panic
> the router.

Please, provide more information on how to reproduce the problem that
you're noticing. Thank you.
