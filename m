From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH RFC 0/2] nftables: fix time parsing
Date: Sat, 11 Apr 2015 18:52:50 +0200
Message-ID: <20150411165250.GA8078@salvia>
References: <1428760830-6135-1-git-send-email-kaber@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36299 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751709AbbDKQsj (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 11 Apr 2015 12:48:39 -0400
Content-Disposition: inline
In-Reply-To: <1428760830-6135-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Apr 11, 2015 at 03:00:28PM +0100, Patrick McHardy wrote:
> These patches attempt to fix time parsing to not require quotation marks
> around the time spec and loosen the checks so times can also be specified
> in smaller units.
> 
> Some testing indicates it works fine, however I'd put them into a branch
> for 4.1 since I mainly need this fixed for the set timeout support.

Thanks, this looks fine to me.

I still think that we need to consider flex start conditions or
something similar to make the scanner a bit smarter (stateful) to
avoid complexity on the parser.

I think that may also help to avoid the side issue related to this
patch:

http://patchwork.ozlabs.org/patch/443091/

Basically, the scanner takes this:

tcp sport vmap { 25:accept, 28:drop };ok
                 ^^^^^

as a tc handle.
