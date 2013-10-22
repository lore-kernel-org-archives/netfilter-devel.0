From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] nftables: operational limit match
Date: Tue, 22 Oct 2013 10:55:40 +0200
Message-ID: <20131022085540.GA22591@localhost>
References: <20131005164456.GB16881@home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Phil Oester <kernel@linuxace.com>, f@localhost
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:38808 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751617Ab3JVIzq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 22 Oct 2013 04:55:46 -0400
Content-Disposition: inline
In-Reply-To: <20131005164456.GB16881@home>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Oct 05, 2013 at 09:44:56AM -0700, Phil Oester wrote:
> The nft limit match currently does not work at all.  Below patches to nftables,
> libnftables, and kernel address the issue.  A few notes on the implementation:
> 
> - Removed support for nano/micro/milli second limits.  These seem pointless,
>   given we are using jiffies in the limit match, not a hpet.  And who really
>   needs to limit items down to sub-second level??
> 
> - 'depth' member is removed as unnecessary.  All we need in the kernel is the
>   rate and the unit.  
> 
> - 'stamp' member becomes the time we need to next refresh the token bucket,
>   instead of being updated on every packet which goes through the match.
> 
> This closes netfilter bugzilla #827, reported by Eric Leblond.

Applied the userspace chunks to libnftables and nftables, please split
this in three patches next time. The kernel chunk was merged into the
nftables pull request.

Thanks.
