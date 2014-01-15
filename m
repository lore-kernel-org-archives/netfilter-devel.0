From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft] segtree: add new segtree debugging option
Date: Wed, 15 Jan 2014 16:03:00 +0100
Message-ID: <20140115150300.GA20630@localhost>
References: <1389788704-21079-1-git-send-email-pablo@netfilter.org>
 <20140115144810.GA32750@macbook.localnet>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:50099 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751928AbaAOPDJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 15 Jan 2014 10:03:09 -0500
Content-Disposition: inline
In-Reply-To: <20140115144810.GA32750@macbook.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jan 15, 2014 at 02:48:10PM +0000, Patrick McHardy wrote:
> On Wed, Jan 15, 2014 at 01:25:04PM +0100, Pablo Neira Ayuso wrote:
> > Currently, nft displays the debugging information if it's compiled with
> > --enable-debug (which seems a good idea) and when intervals are used
> > in maps. Add a new option to enable debugging to segtree, so we only
> > get this information when explicitly requested.
> > 
> > Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> > ---
> > We need this in master to avoid inconditional display of the
> > debugging information when --enable-debug is passed at configuration
> > / compilation time. I'm aware this patch conflicts with next-3.14,
> > that conflict should be easy to resolve.
> 
> Looks good, thanks, I wanted to change this myself.

Just pushed it, thanks.

> A few more things about debugging, some are easy, some might be a bit more
> work:
> 
> - we should use stdout for netlink rule debugging

OK, pushed another small patch for this.

> - netlink rule debugging is very very verbose since it dumps the entire
>   netlink message. I'd prefer to only have the netlink expressions
>   ([meta load ...]) and have the netlink message as another option.
>   It keeps scrolling everything off the screen.

Fine with me. I'd like to keep that there as option, it has helped me
to debug some issues in the past. Will check this.

> - netlink message debugging colors break in less. We should check for
>   isatty().

less -R can interpret them here.
