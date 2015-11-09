From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: nft cache updates
Date: Mon, 9 Nov 2015 17:48:47 +0100
Message-ID: <20151109164847.GA1723@salvia>
References: <20151109153055.GI8098@macbook.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44958 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752083AbbKIQsy (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 9 Nov 2015 11:48:54 -0500
Content-Disposition: inline
In-Reply-To: <20151109153055.GI8098@macbook.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Nov 09, 2015 at 03:30:56PM +0000, Patrick McHardy wrote:
> Hi Pablo,
> 
> I'm wondering what the rational for the current cache update behaviour is.
> The changelog states it is somehow related to the requested command, but
> that doesn't seem to be true.
> 
> Even "nft describe" fails with EPERM as user since the cache appears to be
> initialized unconditionally, which is a bit unfortunate. Also I used to
> test things parsing, evaluation and even netlink generation without actually
> adding those rules as user, which does not work anymore.  This might
> be harder to get working again, but I'm not sure why we do a full
> initialization anyways.  The only thing that appears to be needed
> are sets, and those only in some specific circumstances.

To look up for the existing sets we need the existing tables and
chains, they are essential part of the object hierarchy. So this is
what we're currently dumping.

In general, we need this for incremental updates, in scenarios where
we have objects that are defined in kernelspace but userspace refers
to them.

As you said we can disable the cache in many cases, depending on the
command or if the ruleset file starts by:

flush ruleset

but I have left this out as follow up work, I just wanted to make sure
incremental updates where working, as well as the existing changes.

nft describe should be easy to restore.

Regarding inconditional check for table and chain, we have to make it
from the evaluation step in sets, so leaving other objects without
checking this seems inconsistent to me.

Another side effect of this is better error reporting to the user.
