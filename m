From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v3] xtables: Add locking to prevent concurrent instances
Date: Thu, 30 May 2013 00:28:42 +0200
Message-ID: <20130529222842.GA3626@localhost>
References: <20130527162311.GA1366@gmail.com>
 <20130529125903.GA6390@localhost>
 <20130529182333.GA5056@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net
To: Phil Oester <kernel@linuxace.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51155 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935301Ab3E2W2s (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 29 May 2013 18:28:48 -0400
Content-Disposition: inline
In-Reply-To: <20130529182333.GA5056@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, May 29, 2013 at 02:23:33PM -0400, Phil Oester wrote:
> On Wed, May 29, 2013 at 02:59:03PM +0200, Pablo Neira Ayuso wrote:
> > I think we can:
> > 
> > * Add a new option to explicitly request this behaviour, just as a way
> >   to assert that you really want iptables to retry. Harald was rising
> >   some concerns on the expected results in case of clash that sound
> >   reasonable to me.
> 
> I agree that the retry behaviour could be made optional, however
> I'm not sure that the locking behaviour should be optional.  It leads
> to various races, some of which are subtle and can occur during if-up
> and other "behind the scenes" scenarios.  In my personal experience,
> I had to implement locking inside my scripts because I was hitting
> races fairly regularly with dynamic rule additions/deletions (and I
> suspect other admins have done the same).  Perhaps we can change the
> error to say:
> 
> "Another app is currently holding the ip[6]tables lock (use -r option to enable retries)"

That seems reasonable to me.

> or something similar?  At least that is more informative than the typical
> race error of "iptables: Resource temporarily unavailable".
>
> > * Limit this to ip[6]tables. All bug reports refer to it.
> 
> Seems reasonable.  If future races are discovered in -save or -restore,
> it could be easily changed.

Good. Would you send us a new patch?

Thanks.
