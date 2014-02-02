From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: nftables with ipset combined types
Date: Mon, 3 Feb 2014 00:57:34 +0100
Message-ID: <20140202235734.GA6793@localhost>
References: <52E8AD76.5050808@aim.com>
 <20140129093010.GA4332@localhost>
 <24843182.8UhhjTCEZr@rofl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Patrick Schaaf <netdev@bof.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48206 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752028AbaBBX5k (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 2 Feb 2014 18:57:40 -0500
Content-Disposition: inline
In-Reply-To: <24843182.8UhhjTCEZr@rofl>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jan 29, 2014 at 12:34:12PM +0100, Patrick Schaaf wrote:
> Hi Pablo,
> 
> another useful feature of ipset is that the same set is usable in the
> filter, nat, and mangle tables.
> 
> If I'm not mistaken, sets in nftables are right now scoped within a table,
> so I could not reuse them in that fashion.

The table <-> set link is currently needed to check for loops if
verdict maps are used. But AFAICS, for sets with no verdict maps using
jump to chain, this limitation could be removed. I'll add this to my
TODO list.
