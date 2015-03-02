From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: nftables transaction semantics
Date: Mon, 2 Mar 2015 13:08:35 +0100
Message-ID: <20150302120835.GA16802@salvia>
References: <20150302115141.GC6142@acer.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37052 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751258AbbCBMFC (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 2 Mar 2015 07:05:02 -0500
Content-Disposition: inline
In-Reply-To: <20150302115141.GC6142@acer.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Mar 02, 2015 at 11:51:41AM +0000, Patrick McHardy wrote:
> I'm looking at the nftables transaction code and wondering about the
> semantics of GET operations intermixed with ADD/DEL operations:
> 
> AFAIK there are currently some inconsistencies:
> 
> - new sets get marked as inactive and invisible to GET until the
>   transaction is supported. So
> 
>   ADD set
>   GET set
> 
>   will return ENOENT.

These two follow different paths.

The ADD is included in the batch, the GET doesn't. So we won't see the
object until we have finish processing a full batch.

    ADD set
    --------> batch OK, commit
    GET set

> - Rule GET operations OTOH don't care about the activeness of the rule
>   at all, so
> 
>   DEL rule
>   GET rule
> 
>   will return the rule even though it is actually deleted.
>
>   ADD rule
>   GET rule
>   transaction fail
> 
>   Will equally return the rule even though it will afterwards not be
>   present.
> 
> So the general question is how to properly handle this. GET operations
> should obviously take activeness into account and not return deleted
> objects.

You have DUMP_INTR if a get happens while updating any of the lists.

> The next question would be how to handle failed transactions. We should
> obviously only return new objects if the transaction actually succeeds,
> so I guess this means handling GET requests in the commit path.

Userspace will notice the interference via the netlink flag and will
retry from scratch.
