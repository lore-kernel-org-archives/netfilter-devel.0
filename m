From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: nfqueue: detect when packet has already been checksummed?
Date: Wed, 29 May 2013 13:14:23 +0200
Message-ID: <20130529111423.GA4989@localhost>
References: <20130526204826.GC6578@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: nf-devel <netfilter-devel@vger.kernel.org>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:38670 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965590Ab3E2LOa (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 29 May 2013 07:14:30 -0400
Content-Disposition: inline
In-Reply-To: <20130526204826.GC6578@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Florian,

On Sun, May 26, 2013 at 10:48:26PM +0200, Florian Westphal wrote:
> Hi.
> 
> When using nfqueue, userspace currently has no way
> to tell wheter queued packets have a bad checksum, i.e.
> applications that need data integrity must do full checksum
> validation in userspace (except maybe when only queueing in OUTPUT).
> 
> However, there are several places where incoming packets are already
> checksummed in kernel, before packet hits nfqueue, e.g. via nic rx
> csum offload, or in conntrack.
> 
> So I think it would be nice to provide a hint that kernel already did
> checksumming.
> 
> The SKB_INFO attribute added in -net for GRO support seems like a
> candidate.  However, since 'already checksummed' is the common case this
> would mean adding that attribute most of the time.
> 
> Unless we would do the opposite hint, i.e. tell userspace when
> checksumming has NOT been performed yet.
> 
> Such change would however need to go into -net, else userspace can't tell
> 'checksum ok' from 'kernel too old to provide flag in SKB_INFO attribute'.

User-space has no way to know what info flags are available. If we add
more info flags in the future, we'll have the same problem that we have
now. I mean, currently an unset info flag from userspace may mean:

* It's actually unset.
* It is not available in this kernel.

So I think we need to pass a mask of available info flags, so
user-space knows how to interpret what 'unset' means. The mask would
also help to tell user-space that some info flag is not available.

Regards.
