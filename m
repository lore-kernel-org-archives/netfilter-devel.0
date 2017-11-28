From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf-next,RFC 1/3] netfilter: nf_conntrack: add 64-bit
 conntrack ID extension
Date: Tue, 28 Nov 2017 11:54:51 +0100
Message-ID: <20171128105451.GF23412@breakpoint.cc>
References: <20171128021309.11277-1-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, richard@nod.at, fw@strlen.de
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:47320 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754733AbdK1K4B (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 28 Nov 2017 05:56:01 -0500
Content-Disposition: inline
In-Reply-To: <20171128021309.11277-1-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> This patch adds a 64-bit conntrack ID extension that allows userspace to
> uniquely identify a conntrack object.
> 
> The existing 32-bit ID is not good to uniquely identify a conntrack
> object. Long time ago, this used to be an incremental number that could
> quickly wrap around. Someone suggested to use 64-bits, back then this
> was considered to be too much memory for just an ID. So we usually
> suggested to users that they should combine it with the conntrack tuple
> to achieve a way to uniquely conntrack objects. This has always
> generated a bit of controversy since userspace applications needed to
> deal with extra work.
> 
> At some point, someone remove the explicit ct->id field that we used to
> have to save memory space. This ID was modified to part of its memory
> address. Howeover, this is a problem because objects can be quickly
> recycled with the slab-by-rcu approach that we use these days. So even
> combining this 32-bit ID with the tuple doesn't ensure that this is
> unique. Moreover, this is leaking the pointer to userspace in 32-bit
> arches, which is not good.
> 
> So let's introduce a 64-bit unique ID that ensures no overlaps. This is
> only allocated once in the first packet, and never ever again from the
> hot path, so let's keep this in a separated extension not to grab more
> cachelines.
> 
> ID assignment is lockless: this patch divides the 64-bit space between

Why do we need an id in the first place?
Can you elaborate?

As far as I know there is no need for this ID at all,
the netlink attribute is only provided for backwards compat.

And for that the suggested approach (hash of tuple and memory
addresses) will work just fine.
